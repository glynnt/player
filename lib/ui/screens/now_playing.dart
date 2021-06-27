import 'dart:ui';

import 'package:app/models/song.dart';
import 'package:app/providers/audio_player_provider.dart';
import 'package:app/extensions/duration.dart';
import 'package:app/extensions/assets_audio_player.dart';
import 'package:app/providers/song_provider.dart';
import 'package:app/ui/screens/queue.dart';
import 'package:app/ui/widgets/song_thumbnail.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingScreen extends StatefulWidget {
  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayerProvider audio;
  late SongProvider songProvider;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  double _volume = 0.7;
  bool _liked = false;
  LoopMode _loopMode = LoopMode.none;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    songProvider = context.read<SongProvider>();
    audio = context.read<AudioPlayerProvider>();

    audio.player.currentPosition.listen((position) {
      setState(() => _position = position);
    });

    audio.player.current.listen((Playing? playing) {
      if (playing == null) return;

      setState(() => _duration = playing.audio.duration);

      String? songId = playing.audio.audio.metas.extra?['songId'];
      if (songId == null) return;

      setState(() => _liked = songProvider.byId(songId).liked);
    });

    audio.player.volume.listen((volume) {
      setState(() => _volume = volume);
    });

    audio.player.loopMode.listen((loopMode) {
      setState(() => _loopMode = loopMode);
    });
  }

  Widget hero(Song song) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: SongThumbnail(song: song, size: ThumbnailSize.extraLarge),
    );
  }

  Widget songInfo(Song song) {
    double mainFontSize = Theme.of(context).textTheme.headline6?.fontSize ?? 20;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          song.title,
          style: TextStyle(
            fontSize: mainFontSize,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        Opacity(
          opacity: .8,
          child: Text(
            song.artist.name,
            style: TextStyle(
              color: Theme.of(context).textTheme.caption?.color,
              fontSize: mainFontSize - 2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget progress() {
    TextStyle style = TextStyle(fontSize: 12);

    return Column(
      children: [
        Slider(
          value: _position.inSeconds.toDouble(),
          min: 0.0,
          max: _duration.inSeconds.toDouble(),
          onChanged: (double value) {
            audio.player.seek(new Duration(seconds: value.toInt()));
          },
        ),
        Opacity(
          opacity: .4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_position.toMs(), style: style),
              Text('-' + (_duration - _position).toMs(), style: style),
            ],
          ),
        ),
      ],
    );
  }

  Widget audioControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            if (_position.inSeconds > 5) {
              audio.player.restart();
            } else {
              audio.player.previous();
            }
          },
          icon: Icon(Icons.fast_rewind_rounded),
          iconSize: 48,
        ),
        PlayerBuilder.isPlaying(
          player: audio.player,
          builder: (context, isPlaying) {
            return IconButton(
              onPressed: () => audio.player.playOrPause(),
              icon: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              iconSize: 64,
            );
          },
        ),
        IconButton(
          onPressed: () => audio.player.next(),
          icon: Icon(Icons.fast_forward_rounded),
          iconSize: 48,
        ),
      ],
    );
  }

  Widget volumeSlider() {
    return Row(
      children: [
        Icon(Icons.volume_down, size: 20, color: Colors.white.withOpacity(.5)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SliderTheme(
              data: Theme.of(context).sliderTheme.copyWith(
                    trackHeight: 2,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
              child: Slider(
                min: 0.0,
                max: 1.0,
                value: _volume,
                onChanged: (value) => audio.player.setVolume(value),
              ),
            ),
          ),
        ),
        Icon(Icons.volume_up, size: 20, color: Colors.white.withOpacity(.5)),
      ],
    );
  }

  Widget loopModeButton() {
    return IconButton(
      color: _loopMode == LoopMode.none
          ? Colors.white.withOpacity(.5)
          : Colors.white,
      onPressed: () {
        late LoopMode newMode;
        if (_loopMode == LoopMode.none)
          newMode = LoopMode.playlist;
        else if (_loopMode == LoopMode.playlist)
          newMode = LoopMode.single;
        else
          newMode = LoopMode.none;
        audio.player.setLoopMode(newMode);
        setState(() => _loopMode = newMode);
      },
      icon: Icon(
        _loopMode == LoopMode.single ? Icons.repeat_one : Icons.repeat,
      ),
    );
  }

  Widget extraControls(Song song) {
    return Opacity(
      opacity: .5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          loopModeButton(),
          IconButton(onPressed: () {}, icon: Icon(Icons.playlist_add)),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => QueueScreen(),
                ),
              );
            },
            icon: Icon(Icons.list),
          ),
        ],
      ),
    );
  }

  Widget likeButton(Song song) {
    return IconButton(
      onPressed: () {
        setState(() => _liked = !_liked);
      },
      icon: Icon(_liked ? Icons.favorite_rounded : Icons.favorite_outline),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Playing?>(
      stream: audio.player.current,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        String? songId = snapshot.data?.audio.audio.metas.extra?['songId'];
        if (songId == null) return SizedBox.shrink();
        Song song = songProvider.byId(songId);

        return ClipRect(
          child: BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  hero(song),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          songInfo(song),
                          likeButton(song),
                        ],
                      ),
                      progress(),
                    ],
                  ),
                  audioControls(),
                  Column(
                    children: [
                      volumeSlider(),
                      extraControls(song),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}