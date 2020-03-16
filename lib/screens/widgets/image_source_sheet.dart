import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Selecionar e recorta uma imagem da camera ou da galeria
class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;
  final Color backgroundColor;
  final Color iconColor;
  final Color buttonColor;
  ImageSourceSheet(
      {this.onImageSelected,
      this.backgroundColor,
      this.iconColor,
      this.buttonColor});

  void imageSelected(File image) async {
    if (image != null) {
      await image.rename(image.path.replaceAll("cache", "imagens_bordero"));
      print(image.path);
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio16x9,
          ]);
      await _localPath();
      if (croppedImage != null) {
        onImageSelected(croppedImage);
      }
    }
  }

  Future<String> _localPath() async {
    // final directory = await getApplicationDocumentsDirectory();
    //  final sdcard = await getExternalStorageDirectory();
    var directory = await getApplicationSupportDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: backgroundColor,
      onClosing: () {},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            color: buttonColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.camera_alt, color: iconColor),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Câmera",
                  style: TextStyle(color: iconColor),
                ),
              ],
            ),
            onPressed: () async {
              File image =
                  await ImagePicker.pickImage(source: ImageSource.camera);
              imageSelected(image);
            },
          ),
          FlatButton(
            color: buttonColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.image, color: iconColor),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Galeria",
                  style: TextStyle(color: iconColor),
                ),
              ],
            ),
            onPressed: () async {
              File image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
              imageSelected(image);
            },
          )
        ],
      ),
    );
  }
}
