import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:saver_gallery/saver_gallery.dart';



/*
 This widget is for displaying a picture at the center of the screen.
 If you are satisfied, you save it, otherwise you can retake the picture.
 */
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the picture
        Expanded(
          child: Center(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          // Buttons for SAVE the picture or RETAKE the picture
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    try{
                      final imageBytes = await File(imagePath).readAsBytes();
                      final successSavedImage = await SaverGallery.saveImage(imageBytes, fileName: 'image_from_camera', skipIfExists: false);

                      if(!successSavedImage.isSuccess){
                        throw Error();
                      }
                      SnackBar savedMessage = SnackBar(content: Text("Picture saved at this folder **** "));
                      ScaffoldMessenger.of(context).showSnackBar(savedMessage);

                      Navigator.pop(context);
                    } catch(e){
                      print(e);
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Save the picture"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retake"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    textStyle: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
