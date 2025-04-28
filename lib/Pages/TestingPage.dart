import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'DisplayPictureScreen.dart';

class TestingPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const TestingPage({super.key, required this.cameras});

  @override
  State<StatefulWidget> createState() {
    return TestingPageState();
  }
}

class TestingPageState extends State<TestingPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Testing camera")),
        body: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;

              // Take the picture and store it
              final image = await _controller.takePicture();
              if (!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      DisplayPictureScreen(imagePath: image.path),
                ),
              );
            } catch (e) {
              print(e);
            }
          },
          child: Icon(Icons.camera_alt),
        ));
  }
}

/*
      TODO
      * Finish the floating action for the camera:
      * Watch this video : https://www.youtube.com/watch?v=5n4Fcr3hp0U&ab_channel=WidgetWisdom
      */
