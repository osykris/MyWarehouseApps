import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uts_osy/providers/image_picker_provider.dart';

void imagePickBottomSheet(context)  async{
  ImagePickerProvider imagePicker = Provider.of<ImagePickerProvider>(context, listen: false);
      await showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
        borderRadius:  BorderRadius.vertical(
          top:  Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Image from Gallery"),
                  onTap: () {
                    imagePicker.pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text("Image from Camera"),
                  onTap: () {
                    imagePicker.pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }