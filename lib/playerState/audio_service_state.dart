import 'dart:async';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/playerState/background_audio_service.dart';
import 'package:vocal/res/widgets/my_loader.dart';

class AudioMainScreen extends StatefulWidget {
  final int index;

  AudioMainScreen(this.index);

  @override
  _AudioMainScreenState createState() => _AudioMainScreenState();
}

class _AudioMainScreenState extends State<AudioMainScreen> {
  AudioPlayer audioPlayer;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    print("PPPP ${PodCastEpisodeModel.episodesList.length}");
    super.initState();
  }

  initializePlayer() async {
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'Vocal Cast',
      // Enable this if you want the Android service to exit the foreground state on pause.
      androidStopForegroundOnPause: true,
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidEnableQueue: true,
    );
    // await AudioService.skipToQueueItem(queue[GlobalData.currentEpisodeTapped].id);
    // await AudioService.playFromMediaId("http://101.53.153.152:7890/uploads/a9d0cec9-ed96-4722-b76d-847e836b6ced.mp3");
    AudioService.play();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AudioServiceWidget(
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder<bool>(
            stream: AudioService.runningStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                // Don't show anything until we've ascertained whether or not the
                // service is running, since we want to show a different UI in
                // each case.
                return SizedBox();
              }
              final running = snapshot.data ?? false;
              return FutureBuilder(
                future: initializePlayer(),
                builder: (context, _snapshot) {
                  print("SSS ${_snapshot.hasData} $running");
                  if (running) {
                    return ListView(
                      children: [
                        // UI to show when we're running, i.e. player state/controls.
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
                        StreamBuilder<QueueState>(
                          stream: _queueStateStream,
                          builder: (context, snapshot) {
                            final queueState = snapshot.data;
                            final queue = queueState?.queue ?? [];
                            final mediaItem = queueState?.mediaItem;
                            if (mediaItem != null) {
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
                                                  image: NetworkImage(
                                                      "${mediaItem?.artUri}"), fit: BoxFit.cover),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.53,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.53,
                                          ),
                                          new Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
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
                                  mediaItem != null
                                      ? Text(
                                          "${mediaItem.album}",
                                          style: TextStyle(
                                              color: colorScheme.onSecondary,
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : new Container(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  mediaItem != null
                                      ? Text(
                                          "${mediaItem.title}",
                                          style: TextStyle(
                                              color:
                                                  colorScheme.secondaryVariant,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        )
                                      : new Container(),
                                ],
                              );
                            } else {
                              return new Container();
                            }
                          },
                        ),
                        // Queue display/controls.
                        StreamBuilder<QueueState>(
                          stream: _queueStateStream,
                          builder: (context, snapshot) {
                            final queueState = snapshot.data;
                            final queue = queueState?.queue ?? [];
                            final mediaItem = queueState?.mediaItem;
                            if (mediaItem != null) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (queue.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.volume_up_rounded,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary),
                                            onPressed: () {
                                              _showSliderDialog(
                                                context: context,
                                                title: "Adjust volume",
                                                divisions: 10,
                                                min: 0.0,
                                                max: 1.0,
                                                stream:
                                                    audioPlayer.volumeStream,
                                                onChanged: (val) {
                                                  AudioService.customAction(
                                                      "setVolume", val);
                                                  audioPlayer.setVolume(val);
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                                Icons.skip_previous_rounded),
                                            onPressed: mediaItem == queue.first
                                                ? null
                                                : AudioService.skipToPrevious,
                                            disabledColor:
                                                colorScheme.secondaryVariant,
                                            color: colorScheme.primary,
                                            iconSize: 32,
                                          ),
                                          StreamBuilder<bool>(
                                            stream: AudioService
                                                .playbackStateStream
                                                .map((state) => state.playing)
                                                .distinct(),
                                            builder: (context, snapshot) {
                                              final playing =
                                                  snapshot.data ?? false;
                                              return playing
                                                  ? pauseButton()
                                                  : playButton();
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.skip_next_rounded),
                                            onPressed: mediaItem == queue.last
                                                ? null
                                                : AudioService.skipToNext,
                                            iconSize: 32,
                                            disabledColor:
                                                colorScheme.secondaryVariant,
                                            color: colorScheme.primary,
                                          ),
                                          StreamBuilder<double>(
                                            stream: audioPlayer.speedStream,
                                            builder: (context, snapshot) =>
                                                IconButton(
                                              icon: Text(
                                                  "${snapshot.data?.toStringAsFixed(1)}X",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary)),
                                              onPressed: () {
                                                _showSliderDialog(
                                                  context: context,
                                                  title: "Adjust speed",
                                                  divisions: 20,
                                                  min: 0.1,
                                                  max: 2.0,
                                                  stream:
                                                      audioPlayer.speedStream,
                                                  onChanged: (val) {
                                                    AudioService.setSpeed(val);
                                                    audioPlayer.setSpeed(val);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // if (mediaItem?.title != null) Text(mediaItem.title),
                                ],
                              );
                            } else {
                              return new Container();
                            }
                          },
                        ),
                        // A seek bar.
                        StreamBuilder<MediaState>(
                          stream: _mediaStateStream,
                          builder: (context, snapshot) {
                            final mediaState = snapshot.data;
                            if (mediaState != null) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 0),
                                child: SeekBar(
                                  duration: mediaState?.mediaItem?.duration ??
                                      Duration.zero,
                                  position:
                                      mediaState?.position ?? Duration.zero,
                                  onChangeEnd: (newPosition) {
                                    AudioService.seekTo(newPosition);
                                  },
                                ),
                              );
                            } else {
                              return new Container();
                            }
                          },
                        ),
                        // Episodes List
                        StreamBuilder<QueueState>(
                          stream: _queueStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            final sequence = state?.queue ?? [];
                            final mediaItem = state?.mediaItem;
                            if (mediaItem != null) {
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 15, top: 25),
                                    decoration: BoxDecoration(
                                      gradient: new LinearGradient(
                                          colors: [
                                            colorScheme.onSurface,
                                            colorScheme.onPrimary
                                          ],
                                          begin:
                                              const FractionalOffset(0.0, 0.0),
                                          end: const FractionalOffset(0.0, 1.0),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 25),
                                            child: Text(
                                              "All Episodes",
                                              style: TextStyle(
                                                  color: colorScheme.onSecondary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: sequence.length,
                                    itemBuilder: (context, i) => SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: CupertinoButton(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          color: colorScheme.onPrimary,
                                          child: new Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color:
                                                        colorScheme.onSurface,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            "${sequence[i].artUri}"),
                                                        fit: BoxFit.cover)),
                                                height: 50,
                                                width: 50,
                                              ),
                                              new Expanded(
                                                  child: Text(
                                                sequence[i].title,
                                                style: TextStyle(
                                                    color: colorScheme
                                                        .onSecondary),
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              )),
                                              state.queue[i].id == mediaItem.id
                                                  ? new Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15),
                                                      alignment:
                                                          Alignment.center,
                                                      height: 15,
                                                      child: new Image.asset(
                                                          "assets/playing.gif"),
                                                    )
                                                  : new Container()
                                            ],
                                          ),
                                          onPressed: () {
                                            AudioService.skipToQueueItem(
                                                sequence[i].id);
                                            AudioService.play();
                                            // audioPlayer.seek(Duration.zero, index: i);
                                            // audioPlayer.play();
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return new Container();
                            }
                          },
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: MyLoader(),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem, Duration, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
          (mediaItem, position) =>
              MediaState(mediaItem, position, mediaItem.duration));

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get _queueStateStream =>
      Rx.combineLatest2<List<MediaItem>, MediaItem, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          (queue, mediaItem) => QueueState(queue, mediaItem));

  IconButton playButton() => IconButton(
        icon: Icon(CupertinoIcons.play_circle_fill),
        iconSize: 64.0,
        onPressed: AudioService.play,
      );

  IconButton pauseButton() => IconButton(
        icon: Icon(CupertinoIcons.pause_circle_fill),
        iconSize: 64.0,
        onPressed: AudioService.pause,
      );

  IconButton stopButton() => IconButton(
        icon: Icon(Icons.stop),
        iconSize: 64.0,
        onPressed: AudioService.stop,
      );
}

class QueueState {
  final List<MediaItem> queue;
  final MediaItem mediaItem;

  QueueState(this.queue, this.mediaItem);
}

class MediaState {
  final MediaItem mediaItem;
  final Duration position;
  final Duration duration;

  MediaState(this.mediaItem, this.position, this.duration);
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final value = min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
        widget.duration.inMilliseconds.toDouble());
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Row(
      children: [
        Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                    .firstMatch("$_position")
                    ?.group(1) ??
                '$_position',
            style: Theme.of(context).textTheme.caption),
        Expanded(
            child: Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: value,
          onChanged: (value) {
            if (!_dragging) {
              _dragging = true;
            }
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
            _dragging = false;
          },
        )),
        Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                    .firstMatch("${widget.duration}")
                    ?.group(1) ??
                '${widget.duration}',
            style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;

  Duration get _position => widget.position;
}

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class Seeker {
  final AudioPlayer player;
  final Duration positionInterval;
  final Duration stepInterval;
  final MediaItem mediaItem;
  bool _running = false;

  Seeker(
    this.player,
    this.positionInterval,
    this.stepInterval,
    this.mediaItem,
  );

  start() async {
    _running = true;
    while (_running) {
      Duration newPosition = player.position + positionInterval;
      if (newPosition < Duration.zero) newPosition = Duration.zero;
      if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
      player.seek(newPosition);
      await Future.delayed(stepInterval);
    }
  }

  stop() {
    _running = false;
  }
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
