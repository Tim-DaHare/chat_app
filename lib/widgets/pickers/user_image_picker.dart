import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedFile) onImagePicked;

  const UserImagePicker({
    Key key,
    this.onImagePicked,
  }) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  var _imagePicker = new ImagePicker();

  File _pickedImage;

  void _pickImage() async {
    final pickedFile = await _imagePicker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedFile.path);
    });
    widget.onImagePicked(File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text("Add Image"),
          textColor: theme.primaryColor,
        ),
      ],
    );
  }
}
