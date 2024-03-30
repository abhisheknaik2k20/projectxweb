import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String videoURL;
  const VideoPlayerView({super.key, required this.videoURL});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerView();
}

class _VideoPlayerView extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(widget.videoURL);
    _chewieController = ChewieController(
      looping: true,
      showControls: true,
      videoPlayerController: _videoPlayerController,
    );

    _videoPlayerController.initialize().then((_) => setState(() =>
        _chewieController = ChewieController(
            allowedScreenSleep: false,
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio)));
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await Future.delayed(const Duration(milliseconds: 300));
    Navigator.of(context).pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(177, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.teal.shade400,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: SizedBox(
            height: height * 0.75,
            child: Chewie(controller: _chewieController),
          ),
        ),
      ),
    );
  }
}
