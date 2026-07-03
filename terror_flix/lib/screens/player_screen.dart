import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/movie.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  bool cargando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Movie movie =
        ModalRoute.of(context)!.settings.arguments
            as Movie;

    inicializar(movie.video);
  }

  Future<void> inicializar(String url) async {
    if (url.isEmpty) {
      setState(() {
        cargando = false;
      });
      return;
    }

    videoPlayerController =
        VideoPlayerController.networkUrl(
      Uri.parse(url),
    );

    await videoPlayerController!.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.redAccent,
        backgroundColor: Colors.white24,
        bufferedColor: Colors.white54,
      ),
    );

    if (mounted) {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  void dispose() {
    chewieController?.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Movie movie =
        ModalRoute.of(context)!.settings.arguments
            as Movie;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(movie.titulo),
      ),
      body: Center(
        child: cargando
            ? const CircularProgressIndicator(
                color: Colors.red,
              )
            : movie.video.isEmpty
                ? Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.videocam_off,
                        color: Colors.red,
                        size: 120,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Esta película aún no tiene video.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20),
                      child: Chewie(
                        controller: chewieController!,
                      ),
                    ),
                  ),
      ),
    );
  }
}