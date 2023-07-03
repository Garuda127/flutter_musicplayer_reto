import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_musicplayer_reto/src/helpers/helpers.dart';
import 'package:flutter_musicplayer_reto/src/models/audioplayer_mode.dart';
import 'package:flutter_musicplayer_reto/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(
      children: [
        Background(),
        Column(
          children: [
            CustomAppBar(),
            ImagenDiscoDuracion(),
            TituloPlay(),
            Expanded(child: Lyrics())
          ],
        ),
      ],
    ));
  }
}

class Background extends StatelessWidget {
  const Background({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        height: screenSize.height * 0.8,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.center,
                colors: [
                  Color(0xff33333e),
                  Color(0xff201e28),
                ])));
  }
}

class Lyrics extends StatelessWidget {
  const Lyrics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return ListWheelScrollView(
        diameterRatio: 2.0,
        physics: const BouncingScrollPhysics(),
        itemExtent: getLyrics().length.toDouble(),
        children: lyrics
            .map((e) => Text(
                  e,
                  style: TextStyle(
                      fontSize: 20, color: Colors.white.withOpacity(0.6)),
                ))
            .toList());
  }
}

class TituloPlay extends StatefulWidget {
  const TituloPlay({
    super.key,
  });

  @override
  State<TituloPlay> createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool fistTime = true;
  late AnimationController playAnimation;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    playAnimation.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel =
        Provider.of<AudioPlayerModel>(context, listen: false);

    assetsAudioPlayer.open(Audio('assets/starlog.mp3'),
        autoStart: true, showNotification: true);

    assetsAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });

    assetsAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration =
          playingAudio?.audio.duration ?? const Duration(seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Starlog',
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 30,
                    color: Colors.white.withOpacity(0.8)),
              ),
              Text('-Chou cho-',
                  style: TextStyle(
                      fontSize: 15, color: Colors.white.withOpacity(0.5))),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              final audioPlayerModel =
                  Provider.of<AudioPlayerModel>(context, listen: false);
              if (isPlaying) {
                playAnimation.reverse();
                isPlaying = false;
                audioPlayerModel.controller.stop();
                assetsAudioPlayer.pause();
              } else {
                playAnimation.forward();
                isPlaying = true;
                audioPlayerModel.controller.repeat();
                if (fistTime) {
                  open();
                  fistTime = false;
                } else {
                  assetsAudioPlayer.play();
                }
              }
            },
            highlightElevation: 0,
            elevation: 0,
            backgroundColor: const Color(0xfff8cb51),
            child: AnimatedIcon(
                icon: AnimatedIcons.play_pause, progress: playAnimation),
          )
        ],
      ),
    );
  }
}

class ImagenDiscoDuracion extends StatelessWidget {
  const ImagenDiscoDuracion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: const Row(
        children: [
          ImagenDisco(),
          SizedBox(width: 20),
          BarraProgreso(),
          SizedBox(width: 20)
        ],
      ),
    );
  }
}

class BarraProgreso extends StatelessWidget {
  const BarraProgreso({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;
    final TextStyle style = TextStyle(color: Colors.white.withOpacity(0.4));
    return Column(
      children: [
        Text(
          audioPlayerModel.songTotalDuration,
          style: style,
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              width: 3,
              height: 230,
              color: Colors.white.withOpacity(0.1),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 3,
                height: 230 * porcentaje,
                color: Colors.white.withOpacity(0.8),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Text(
          audioPlayerModel.currentSecond,
          style: style,
        )
      ],
    );
  }
}

class ImagenDisco extends StatelessWidget {
  const ImagenDisco({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              colors: [Color(0xff484750), Color(0xff1e1c24)])),
      width: 250,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              manualTrigger: true,
              animate: false,
              controller: (animationController) =>
                  audioPlayerModel.controller = animationController,
              infinite: true,
              duration: const Duration(seconds: 10),
              child: const Image(
                image: AssetImage('assets/aurora.jpg'),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(100)),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                  color: const Color(0xff1c1c25),
                  borderRadius: BorderRadius.circular(100)),
            )
          ],
        ),
      ),
    );
  }
}
