// import 'dart:async';
//
// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';
//
// MediaControl playControl = MediaControl(
//   androidIcon: 'drawable/ic_action_play_arrow',
//   label: 'Play',
//   action: MediaAction.play,
// );
// MediaControl pauseControl = MediaControl(
//   androidIcon: 'drawable/ic_action_pause',
//   label: 'Pause',
//   action: MediaAction.pause,
// );
// MediaControl skipToNextControl = MediaControl(
//   androidIcon: 'drawable/ic_action_skip_next',
//   label: 'Next',
//   action: MediaAction.skipToNext,
// );
// MediaControl skipToPreviousControl = MediaControl(
//   androidIcon: 'drawable/ic_action_skip_previous',
//   label: 'Previous',
//   action: MediaAction.skipToPrevious,
// );
// MediaControl stopControl = MediaControl(
//   androidIcon: 'drawable/ic_action_stop',
//   label: 'Stop',
//   action: MediaAction.stop,
// );
//
// class AudioPlayerTask extends BackgroundAudioTask {
//   //
//   var _queue = <MediaItem>[];
//
//   int _queueIndex = -1;
//
//   AudioPlayer _audioPlayer = new AudioPlayer();
//   AudioProcessingState _skipState;
//   bool _playing;
//
//   bool get hasNext => _queueIndex + 1 < _queue.length;
//
//   bool get hasPrevious => _queueIndex > 0;
//
//   MediaItem get mediaItem => _queue[_queueIndex];
//
//   StreamSubscription<AudioPlaybackState> _playerStateSubscription;
//   StreamSubscription<AudioPlaybackEvent> _eventSubscription;
//
//   @override
//   Future<void> onStart(Map<String, dynamic> params) async {
//     _queue.clear();
//     List mediaItems = params['data'];
//     for (int i = 0; i < mediaItems.length; i++) {
//       MediaItem mediaItem = MediaItem.fromJson(mediaItems[i]);
//       _queue.add(mediaItem);
//     }
//     _playerStateSubscription = _audioPlayer.playbackStateStream
//         .where((state) => state == AudioPlaybackState.completed)
//         .listen((state) {
//       _handlePlaybackCompleted();
//     });
//     _eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
//       final bufferingState =
//       event.buffering ? AudioProcessingState.buffering : null;
//       switch (event.state) {
//         case AudioPlaybackState.paused:
//           _setState(
//               processingState: bufferingState ?? AudioProcessingState.ready,
//               position: event.position);
//           break;
//         case AudioPlaybackState.playing:
//           _setState(
//               processingState: bufferingState ?? AudioProcessingState.ready,
//               position: event.position);
//           break;
//         case AudioPlaybackState.connecting:
//           _setState(
//               processingState: _skipState ?? AudioProcessingState.connecting,
//               position: event.position);
//           break;
//         default:
//       }
//     });
//     AudioServiceBackground.setQueue(_queue);
//     onSkipToNext();
//   }
//
//   @override
//   Future<void> onPlay() async {
//     if (_skipState == null) {
//       _playing = true;
//       _audioPlayer.play();
//     }
//   }
//
//   @override
//   Future<void> onPause() async {
//     _playing = false;
//     _audioPlayer.pause();
//   }
//
//   @override
//   Future<void> onSkipToNext() async {
//     skip(1);
//   }
//
//   @override
//   Future<void> onSkipToPrevious() async {
//     skip(-1);
//   }
//
//   void skip(int offset) async {
//     int newPos = _queueIndex + offset;
//     if (!(newPos >= 0 && newPos < _queue.length)) {
//       return;
//     }
//     if (null == _playing) {
//       _playing = true;
//     } else if (_playing) {
//       await _audioPlayer.stop();
//     }
//     _queueIndex = newPos;
//     _skipState = offset > 0
//         ? AudioProcessingState.skippingToNext
//         : AudioProcessingState.skippingToPrevious;
//     AudioServiceBackground.setMediaItem(mediaItem);
//     await _audioPlayer.setUrl(mediaItem.id);
//     print(mediaItem.id);
//     _skipState = null;
//     if (_playing) {
//       onPlay();
//     } else {
//       _setState(processingState: AudioProcessingState.ready);
//     }
//   }
//
//   @override
//   Future<void> onStop() async {
//     _playing = false;
//     await _audioPlayer.stop();
//     await _audioPlayer.dispose();
//     _playerStateSubscription.cancel();
//     _eventSubscription.cancel();
//     return await super.onStop();
//   }
//
//   @override
//   Future<void> onSeekTo(Duration position) async {
//     _audioPlayer.seek(position);
//   }
//
//   @override
//   Future<void> onClick(MediaButton button) async {
//     playPause();
//   }
//
//   @override
//   Future<void> onFastForward() async {
//     await _seekRelative(fastForwardInterval);
//   }
//
//   @override
//   Future<void> onRewind() async {
//     await _seekRelative(rewindInterval);
//   }
//
//   Future<void> _seekRelative(Duration offset) async {
//     var newPosition = _audioPlayer.playbackEvent.updatePosition + offset;
//     if (newPosition < Duration.zero) {
//       newPosition = Duration.zero;
//     }
//     if (newPosition > mediaItem.duration) {
//       newPosition = mediaItem.duration;
//     }
//     await _audioPlayer.seek(_audioPlayer.playbackEvent.updatePosition + offset);
//   }
//
//   _handlePlaybackCompleted() {
//     if (hasNext) {
//       onSkipToNext();
//     } else {
//       onStop();
//     }
//   }
//
//   void playPause() {
//     if (AudioServiceBackground.state.playing)
//       onPause();
//     else
//       onPlay();
//   }
//
//   Future<void> _setState({
//     AudioProcessingState processingState,
//     Duration position,
//     Duration bufferedPosition,
//   }) async {
//     print('SetState $processingState');
//     if (position == null) {
//       position = _audioPlayer.playbackEvent.updatePosition;
//     }
//     await AudioServiceBackground.setState(
//       controls: getControls(),
//       systemActions: [MediaAction.seekTo],
//       processingState:
//       processingState ?? AudioServiceBackground.state.processingState,
//       playing: _playing,
//       position: position,
//       bufferedPosition: bufferedPosition ?? position,
//       speed: _audioPlayer.speed,
//     );
//   }
//
//   List<MediaControl> getControls() {
//     if (_playing) {
//       return [
//         skipToPreviousControl,
//         pauseControl,
//         stopControl,
//         skipToNextControl
//       ];
//     } else {
//       return [
//         skipToPreviousControl,
//         playControl,
//         stopControl,
//         skipToNextControl
//       ];
//     }
//   }
// }
//
// class AudioState {
//   final List<MediaItem> queue;
//   final MediaItem mediaItem;
//   final PlaybackState playbackState;
//
//   AudioState(this.queue, this.mediaItem, this.playbackState);
// }
