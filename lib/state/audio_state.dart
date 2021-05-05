import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vocal/modules/podcast/state/current_player_state.dart';

// void main() => runApp(MyApp());

class AudioPlayerPage extends StatefulWidget {
  final int index;

  AudioPlayerPage(this.index);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  AudioPlayer _player;
  var _playlist;
  int _addedCount = 0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(_playlist);
      _player.seek(Duration.zero, index: widget.index);
      _player.play();
    } catch (e) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    var currentPlayer = Provider.of<CurrentPlayerState>(context, listen: false);
    _playlist = ConcatenatingAudioSource(
      children: List.generate(
        currentPlayer.currentEpisodeModelList.length,
        (index) => AudioSource.uri(
          Uri.parse("${currentPlayer.currentEpisodeModelList[index].url}"),
          tag: AudioMetadata(
            album: "${currentPlayer.currentEpisodeModelList[index].title}",
            title: "A Salute To Head-Scratching Science",
            artwork: "${currentPlayer.currentEpisodeModelList[index].banner}",
          ),
        ),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            new SizedBox(
              height: 1,
            ),
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: new Row(
                children: [
                  new IconButton(
                      icon: Icon(
                        CupertinoIcons.back,
                        color: colorScheme.primary,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  Spacer()
                ],
              ),
            ),
            StreamBuilder<SequenceState>(
              stream: _player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state.sequence.isEmpty ?? true) return SizedBox();
                final metadata = state.currentSource.tag as AudioMetadata;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage("${metadata.artwork}")),
                              ),
                              height: MediaQuery.of(context).size.width * 0.53,
                              width: MediaQuery.of(context).size.width * 0.53,
                            ),
                            new Container(
                              height: MediaQuery.of(context).size.width * 0.6,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Image.asset(
                                "assets/circle_wave.gif",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      metadata.album,
                      style: TextStyle(
                          color: colorScheme.onSecondary,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      metadata.title,
                      style: TextStyle(
                          color: colorScheme.secondaryVariant,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              },
            ),
            new SizedBox(
              height: 15,
            ),
            StreamBuilder<Duration>(
              stream: _player.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<PositionData>(
                  stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                      _player.positionStream,
                      _player.bufferedPositionStream,
                      (position, bufferedPosition) =>
                          PositionData(position, bufferedPosition)),
                  builder: (context, snapshot) {
                    final positionData = snapshot.data ??
                        PositionData(Duration.zero, Duration.zero);
                    var position = positionData.position;
                    if (position > duration) {
                      position = duration;
                    }
                    var bufferedPosition = positionData.bufferedPosition;
                    if (bufferedPosition > duration) {
                      bufferedPosition = duration;
                    }
                    return SeekBar(
                      duration: duration,
                      position: position,
                      bufferedPosition: bufferedPosition,
                      onChangeEnd: (newPosition) {
                        _player.seek(newPosition);
                      },
                    );
                  },
                );
              },
            ),
            ControlButtons(_player),
            SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [colorScheme.onSurface, colorScheme.onPrimary],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      " Episodes",
                      style: TextStyle(
                          color: colorScheme.onSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  StreamBuilder<LoopMode>(
                    stream: _player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      var icons = [
                        Icon(Icons.repeat, color: colorScheme.secondaryVariant),
                        Icon(Icons.repeat, color: colorScheme.primary),
                        Icon(Icons.repeat_one, color: colorScheme.primary),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return CupertinoButton(
                        padding: EdgeInsets.all(5),
                        child: icons[index],
                        onPressed: () {
                          _player.setLoopMode(cycleModes[
                              (cycleModes.indexOf(loopMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
                  StreamBuilder<bool>(
                    stream: _player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return CupertinoButton(
                        padding: EdgeInsets.all(5),
                        child: shuffleModeEnabled
                            ? Icon(Icons.shuffle, color: colorScheme.primary)
                            : Icon(Icons.shuffle,
                                color: colorScheme.secondaryVariant),
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          if (enable) {
                            await _player.shuffle();
                          }
                          await _player.setShuffleModeEnabled(enable);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            StreamBuilder<SequenceState>(
              stream: _player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final sequence = state?.sequence ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sequence.length,
                  itemBuilder: (context, i) => SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        color: colorScheme.onPrimary,
                        child: new Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: colorScheme.onSurface,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "${sequence[i].tag.artwork}"),
                                      fit: BoxFit.cover)),
                              height: 50,
                              width: 50,
                            ),
                            new Expanded(
                                child: Text(
                              sequence[i].tag.title as String,
                              style: TextStyle(color: colorScheme.onSecondary),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )),
                            i == state.currentIndex
                                ? new Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    alignment: Alignment.center,
                                    height: 15,
                                    child:
                                        new Image.asset("assets/playing.gif"),
                                  )
                                : new Container()
                          ],
                        ),
                        onPressed: () {
                          _player.seek(Duration.zero, index: i);
                          _player.play();
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: new Container(
        height: 60,
        color: colorScheme.onSurface,
        child: StreamBuilder<SequenceState>(
          stream: _player.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state.sequence.isEmpty ?? true) return SizedBox();
            final metadata = state.currentSource.tag as AudioMetadata;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(metadata.artwork),
                        ),
                        shape: BoxShape.circle),
                  ),
                ),
                new Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(metadata.album,
                        style: TextStyle(
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text(metadata.title,
                        style: TextStyle(
                            color: colorScheme.secondaryVariant,
                            fontWeight: FontWeight.normal,
                            fontSize: 14)),
                  ],
                )),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: StreamBuilder<PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          width: 32.0,
                          height: 32.0,
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator(
                            radius: 10,
                          ),
                        );
                      } else if (playing != true) {
                        return IconButton(
                          icon: Icon(
                            CupertinoIcons.play_circle,
                            color: Colors.white,
                          ),
                          iconSize: 32.0,
                          onPressed: _player.play,
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return IconButton(
                          icon: Icon(
                            CupertinoIcons.pause_circle_fill,
                            color: Colors.white,
                          ),
                          iconSize: 32.0,
                          onPressed: _player.pause,
                        );
                      } else {
                        return IconButton(
                          icon: Icon(
                            Icons.replay,
                            color: Colors.white,
                          ),
                          iconSize: 32.0,
                          onPressed: () => _player.seek(Duration.zero,
                              index: _player.effectiveIndices.first),
                        );
                      }
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.volume_up_rounded,
                color: Theme.of(context).colorScheme.onSecondary),
            onPressed: () {
              _showSliderDialog(
                context: context,
                title: "Adjust volume",
                divisions: 10,
                min: 0.0,
                max: 1.0,
                stream: player.volumeStream,
                onChanged: player.setVolume,
              );
            },
          ),
          StreamBuilder<SequenceState>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(Icons.skip_previous_rounded),
              onPressed: (){
                if(player.hasPrevious){
                  player.seekToPrevious();
                  player.play();
                }
              },
              disabledColor: colorScheme.secondaryVariant,
              color: colorScheme.primary,
              iconSize: 32,
            ),
          ),
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: EdgeInsets.all(18.0),
                  width: 45.0,
                  height: 45.0,
                  child: CircularProgressIndicator(),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: Icon(CupertinoIcons.play_circle_fill),
                  iconSize: 64.0,
                  onPressed: player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: Icon(CupertinoIcons.pause_circle_fill),
                  iconSize: 64.0,
                  onPressed: player.pause,
                );
              } else {
                return IconButton(
                  icon: Icon(CupertinoIcons.refresh_circled),
                  iconSize: 64.0,
                  onPressed: () => player.seek(Duration.zero,
                      index: player.effectiveIndices.first),
                );
              }
            },
          ),
          StreamBuilder<SequenceState>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(Icons.skip_next_rounded),
              onPressed: (){
                if(player.hasPrevious){
                  player.seekToNext();
                  player.play();
                }
              },
              iconSize: 32,
              disabledColor: colorScheme.secondaryVariant,
              color: colorScheme.primary,
            ),
          ),
          StreamBuilder<double>(
            stream: player.speedStream,
            builder: (context, snapshot) => IconButton(
              icon: Text("${snapshot.data?.toStringAsFixed(1)}X",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSecondary)),
              onPressed: () {
                _showSliderDialog(
                  context: context,
                  title: "Adjust speed",
                  divisions: 10,
                  min: 0.5,
                  max: 2.0,
                  stream: player.speedStream,
                  onChanged: player.setSpeed,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    @required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;
  SliderThemeData _sliderThemeData;

  @override
  void initState() {
    print("Duration ${widget.duration}");
    print("Position ${widget.duration}");
    print("Buffered ${widget.duration}");
    print("Duration ${widget.duration}");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("${widget.duration - _remaining}")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
          Expanded(
              child: Stack(
            children: [
              SliderTheme(
                data: _sliderThemeData.copyWith(
                  thumbShape: HiddenThumbComponentShape(),
                  activeTrackColor: Colors.blue.shade100,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
                child: ExcludeSemantics(
                  child: Slider(
                    min: 0.0,
                    max: widget.duration.inMilliseconds.toDouble(),
                    value: widget.bufferedPosition.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _dragValue = value;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged(Duration(milliseconds: value.round()));
                      }
                    },
                    onChangeEnd: (value) {
                      if (widget.onChangeEnd != null) {
                        widget
                            .onChangeEnd(Duration(milliseconds: value.round()));
                      }
                      _dragValue = null;
                    },
                  ),
                ),
              ),
              SliderTheme(
                data: _sliderThemeData.copyWith(
                  inactiveTrackColor: Colors.transparent,
                ),
                child: Slider(
                  min: 0.0,
                  max: widget.duration.inMilliseconds.toDouble(),
                  value: min(
                      _dragValue ?? widget.position.inMilliseconds.toDouble(),
                      widget.duration.inMilliseconds.toDouble()),
                  onChanged: (value) {
                    setState(() {
                      _dragValue = value;
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged(Duration(milliseconds: value.round()));
                    }
                  },
                  onChangeEnd: (value) {
                    if (widget.onChangeEnd != null) {
                      widget.onChangeEnd(Duration(milliseconds: value.round()));
                    }
                    _dragValue = null;
                  },
                ),
              ),
            ],
          )),
          Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("${widget.duration - _remaining}")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

void _showSliderDialog({
  @required BuildContext context,
  @required String title,
  @required int divisions,
  @required double min,
  @required double max,
  String valueSuffix = '',
  @required Stream<double> stream,
  @required ValueChanged<double> onChanged,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      // backgroundColor: Theme.of(context).colorScheme.onPrimary,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(title, textAlign: TextAlign.center),
      message: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Material(
            color: Colors.transparent,
            child: Slider(
              divisions: divisions,
              min: min,
              max: max,
              value: snapshot.data ?? 1.0,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    ),
  );
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata(
      {@required this.album, @required this.title, @required this.artwork});
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    @required Animation<double> activationAnimation,
    @required Animation<double> enableAnimation,
    @required bool isDiscrete,
    @required TextPainter labelPainter,
    @required RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    @required TextDirection textDirection,
    @required double value,
    @required double textScaleFactor,
    @required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}
