import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// Selecionar e recorta uma imagem da camera ou da galeria
class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;
  final Color backgroundColor;
  final Color iconColor;
  final Color buttonColor;
  ImageSourceSheet({this.onImageSelected,this.backgroundColor, this.iconColor, this.buttonColor});

  void imageSelected(File image) async {
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        ratioX: 1.0,
        ratioY: 1.0,
      );
      onImageSelected(croppedImage);
    }
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
