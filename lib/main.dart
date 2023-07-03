import 'package:flutter/material.dart';
import 'package:flutter_musicplayer_reto/src/models/audioplayer_mode.dart';
import 'package:flutter_musicplayer_reto/src/pages/music_player_page.dart';
import 'package:flutter_musicplayer_reto/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AudioPlayerModel(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        theme: miTema,
        home: const MusicPlayerPage(),
      ),
    );
  }
}
