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
import 'package:vocal/state/background_audio_service.dart';

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
    super.initState();
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
              return ListView(
                children: [
                  if (!running) ...[
                    // UI to show when we're not running, i.e. a menu.
                    audioPlayerButton(),
                  ] else ...[
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
                        if(mediaItem != null){
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
                                                  "${mediaItem?.artUri}")),
                                        ),
                                        height:
                                        MediaQuery.of(context).size.width *
                                            0.53,
                                        width: MediaQuery.of(context).size.width *
                                            0.53,
                                      ),
                                      new Container(
                                        height:
                                        MediaQuery.of(context).size.width *
                                            0.6,
                                        width: MediaQuery.of(context).size.width *
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
                              mediaItem != null ? Text(
                                "${mediaItem.album}",
                                style: TextStyle(
                                    color: colorScheme.onSecondary,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold),
                              ) : new Container(),
                              SizedBox(
                                height: 5,
                              ),
                              mediaItem != null ? Text(
                                "${mediaItem.title}",
                                style: TextStyle(
                                    color: colorScheme.secondaryVariant,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ) : new Container(),
                            ],
                          );
                        }else{
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
                        if(mediaItem != null){
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
                                            stream: audioPlayer.volumeStream,
                                            onChanged: (val){
                                              AudioService.customAction("setVolume", val);
                                              audioPlayer.setVolume(val);
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.skip_previous_rounded),
                                        onPressed: mediaItem == queue.first
                                            ? null
                                            : AudioService.skipToPrevious,
                                        disabledColor:
                                        colorScheme.secondaryVariant,
                                        color: colorScheme.primary,
                                        iconSize: 32,
                                      ),
                                      StreamBuilder<bool>(
                                        stream: AudioService.playbackStateStream
                                            .map((state) => state.playing)
                                            .distinct(),
                                        builder: (context, snapshot) {
                                          final playing = snapshot.data ?? false;
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
                                                      fontWeight: FontWeight.bold,
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
                                                  stream: audioPlayer.speedStream,
                                                  onChanged: (val){
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
                        }else{
                          return new Container();
                        }
                      },
                    ),
                    // A seek bar.
                    StreamBuilder<MediaState>(
                      stream: _mediaStateStream,
                      builder: (context, snapshot) {
                        final mediaState = snapshot.data;
                        if(mediaState != null){
                          print("DUR ${mediaState?.mediaItem?.duration}");
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            child: SeekBar(
                              duration: mediaState?.mediaItem?.duration ??
                                  Duration.zero,
                              position: mediaState?.position ?? Duration.zero,
                              onChangeEnd: (newPosition) {
                                AudioService.seekTo(newPosition);
                              },
                            ),
                          );
                        }else{
                          return new Container();
                        }
                      },
                    ),
                    // Display the processing state.
                    // StreamBuilder<AudioProcessingState>(
                    //   stream: AudioService.playbackStateStream
                    //       .map((state) => state.processingState)
                    //       .distinct(),
                    //   builder: (context, snapshot) {
                    //     final processingState =
                    //         snapshot.data ?? AudioProcessingState.none;
                    //     return Text(
                    //         "Processing state: ${describeEnum(processingState)}");
                    //   },
                    // ),
                    // Display the latest custom event.
                    // StreamBuilder(
                    //   stream: AudioService.customEventStream,
                    //   builder: (context, snapshot) {
                    //     return Text("custom event: ${snapshot.data}");
                    //   },
                    // ),
                    // Display the notification click status.
                    // StreamBuilder<bool>(
                    //   stream: AudioService.notificationClickEventStream,
                    //   builder: (context, snapshot) {
                    //     return Text(
                    //       'Notification Click Status: ${snapshot.data}',
                    //     );
                    //   },
                    // ),
                    // Heading and Suffle
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              colorScheme.onSurface,
                              colorScheme.onPrimary
                            ],
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
                            stream: audioPlayer.loopModeStream,
                            builder: (context, snapshot) {
                              final loopMode = snapshot.data ?? LoopMode.off;
                              var icons = [
                                Icon(Icons.repeat,
                                    color: colorScheme.secondaryVariant),
                                Icon(Icons.repeat, color: colorScheme.primary),
                                Icon(Icons.repeat_one,
                                    color: colorScheme.primary),
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
                                  audioPlayer.setLoopMode(cycleModes[
                                      (cycleModes.indexOf(loopMode) + 1) %
                                          cycleModes.length]);
                                },
                              );
                            },
                          ),
                          StreamBuilder<bool>(
                            stream: audioPlayer.shuffleModeEnabledStream,
                            builder: (context, snapshot) {
                              final shuffleModeEnabled = snapshot.data ?? false;
                              return CupertinoButton(
                                padding: EdgeInsets.all(5),
                                child: AudioServiceShuffleMode.all != null
                                    ? Icon(Icons.shuffle,
                                        color: colorScheme.primary)
                                    : Icon(Icons.shuffle,
                                        color: colorScheme.secondaryVariant),
                                onPressed: () async {
                                  final enable = !shuffleModeEnabled;
                                  if (enable) {
                                    await audioPlayer.shuffle();
                                  }
                                  await audioPlayer
                                      .setShuffleModeEnabled(enable);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Episodes List
                    StreamBuilder<QueueState>(
                      stream: _queueStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        final sequence = state?.queue ?? [];
                        final mediaItem = state?.mediaItem;
                        if(mediaItem != null){
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
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
                                                    "${sequence[i].artUri}"),
                                                fit: BoxFit.cover)),
                                        height: 50,
                                        width: 50,
                                      ),
                                      new Expanded(
                                          child: Text(
                                            sequence[i].title,
                                            style: TextStyle(
                                                color: colorScheme.onSecondary),
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )),
                                      state.queue[i].id == mediaItem.id
                                          ? new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        alignment: Alignment.center,
                                        height: 15,
                                        child: new Image.asset(
                                            "assets/playing.gif"),
                                      )
                                          : new Container()
                                    ],
                                  ),
                                  onPressed: () {
                                    AudioService.skipToQueueItem(sequence[i].id);
                                    AudioService.play();
                                    // audioPlayer.seek(Duration.zero, index: i);
                                    // audioPlayer.play();
                                  },
                                ),
                              ),
                            ),
                          );
                        }else{
                          return new Container();
                        }
                      },
                    ),
                  ],
                ],
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
          (mediaItem, position) => MediaState(mediaItem, position, mediaItem.duration));

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get _queueStateStream =>
      Rx.combineLatest2<List<MediaItem>, MediaItem, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          (queue, mediaItem) => QueueState(queue, mediaItem));

  ElevatedButton audioPlayerButton() => startButton(
        'AudioPlayer',
        () {
          print("SASAS ${PodCastEpisodeModel.episodesList.length}");
          AudioService.start(
            backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
            androidNotificationChannelName: 'Vocal Cast',
            // Enable this if you want the Android service to exit the foreground state on pause.
            androidStopForegroundOnPause: true,
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
            androidEnableQueue: true,
          );
          // AudioService.playFromMediaId(EpisodeModel.episodesList[widget.index].id);
          AudioService.play();
          // AudioService.customAction('setVolume', 0.8);
        },
      );

  ElevatedButton startButton(String label, VoidCallback onPressed) =>
      ElevatedButton(
        child: Text(label),
        onPressed: onPressed,
      );

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

/// Provides access to a library of media items. In your app, this could come
/// from a database or web service.
class MediaLibrary {
  final _items = List.generate(
      PodCastEpisodeModel.episodesList.length,
      (index) => MediaItem(
            // This can be any unique id, but we use the audio URL for convenience.
            id: "${PodCastEpisodeModel.episodesList[index].audio}",
            album: "${PodCastEpisodeModel.episodesList[index].title}",
            title: "${PodCastEpisodeModel.episodesList[index].title}",
            artist: "${PodCastEpisodeModel.episodesList[index].desc}",
            // duration: Duration(milliseconds: 5739820),
            artUri: Uri.parse("${PodCastEpisodeModel.episodesList[index].graphic}"),
          ));

  List<MediaItem> get items => _items;
}

/// This task defines logic for speaking a sequence of numbers using
/// text-to-speech.
class TextPlayerTask extends BackgroundAudioTask {
  bool _finished = false;
  Sleeper _sleeper = Sleeper();
  Completer _completer = Completer();
  bool _interrupted = false;

  bool get _playing => AudioServiceBackground.state.playing;

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // flutter_tts resets the AVAudioSession category to playAndRecord and the
    // options to defaultToSpeaker whenever this background isolate is loaded,
    // so we need to set our preferred audio session configuration here after
    // that has happened.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Handle audio interruptions.
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (_playing) {
          onPause();
          _interrupted = true;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.duck:
            if (!_playing && _interrupted) {
              onPlay();
            }
            break;
          case AudioInterruptionType.unknown:
            break;
        }
        _interrupted = false;
      }
    });
    // Handle unplugged headphones.
    session.becomingNoisyEventStream.listen((_) {
      if (_playing) onPause();
    });

    // Start playing.
    await _playPause();
    for (var i = 1; i <= 10 && !_finished;) {
      AudioServiceBackground.setMediaItem(mediaItem(i));
      AudioServiceBackground.androidForceEnableMediaButtons();
      try {
        // await _tts.speak('$i');
        i++;
        await _sleeper.sleep(Duration(milliseconds: 300));
      } catch (e) {
        // Speech was interrupted
      }
      // If we were just paused
      if (!_finished && !_playing) {
        try {
          // Wait to be unpaused
          await _sleeper.sleep();
        } catch (e) {
          // unpaused
        }
      }
    }
    await AudioServiceBackground.setState(
      controls: [],
      processingState: AudioProcessingState.stopped,
      playing: false,
    );
    if (!_finished) {
      onStop();
    }
    _completer.complete();
  }

  @override
  Future<void> onPlay() => _playPause();

  @override
  Future<void> onPause() => _playPause();

  @override
  Future<void> onStop() async {
    // Signal the speech to stop
    _finished = true;
    _sleeper.interrupt();
    // _tts.interrupt();
    // Wait for the speech to stop
    await _completer.future;
    // Shut down this task
    await super.onStop();
  }

  MediaItem mediaItem(int number) => MediaItem(
      id: 'tts_$number',
      album: 'Numbers',
      title: 'Number $number',
      artist: 'Sample Artist');

  Future<void> _playPause() async {
    if (_playing) {
      _interrupted = false;
      await AudioServiceBackground.setState(
        controls: [MediaControl.play, MediaControl.stop],
        processingState: AudioProcessingState.ready,
        playing: false,
      );
      _sleeper.interrupt();
      // _tts.interrupt();
    } else {
      final session = await AudioSession.instance;
      // flutter_tts doesn't activate the session, so we do it here. This
      // allows the app to stop other apps from playing audio while we are
      // playing audio.
      if (await session.setActive(true)) {
        // If we successfully activated the session, set the state to playing
        // and resume playback.
        await AudioServiceBackground.setState(
          controls: [MediaControl.pause, MediaControl.stop],
          processingState: AudioProcessingState.ready,
          playing: true,
        );
        _sleeper.interrupt();
      }
    }
  }
}

/// An object that performs interruptable sleep.
class Sleeper {
  Completer _blockingCompleter;

  /// Sleep for a duration. If sleep is interrupted, a
  /// [SleeperInterruptedException] will be thrown.
  Future<void> sleep([Duration duration]) async {
    _blockingCompleter = Completer();
    if (duration != null) {
      await Future.any([Future.delayed(duration), _blockingCompleter.future]);
    } else {
      await _blockingCompleter.future;
    }
    final interrupted = _blockingCompleter.isCompleted;
    _blockingCompleter = null;
    if (interrupted) {
      throw SleeperInterruptedException();
    }
  }

  /// Interrupt any sleep that's underway.
  void interrupt() {
    if (_blockingCompleter?.isCompleted == false) {
      _blockingCompleter.complete();
    }
  }
}

class SleeperInterruptedException {}

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
