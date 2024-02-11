import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  File? _image;
  List? _recognitions;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  Future loadModel() async {
    Tflite.close(); // Ensure previous instances are closed
    try {
      String? res = await Tflite.loadModel(
        model: "assets/mobilenet_v2.tflite",
        labels: "assets/labels.txt", // Assuming you have a labels file
      );
      print("Model loading result: $res");
    } catch (e) {
      print("Failed to load the model: $e");
    }
  }

  Future classifyImage(File image) async {
    if (_image == null) {
      print("No image selected.");
      return;
    }
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 127.5,   // Used for scaling pixel values
        imageStd: 127.5,    // Used for scaling pixel values
        numResults: 2,      // Number of results to return
        threshold: 0.1,     // Results below this threshold are ignored
        asynch: true        // Run inference in a separate thread
      );
      setState(() {
        _recognitions = recognitions;
      });
    } catch (e) {
      print("Failed to classify image: $e");
    }
  }


  // Image picker
  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Classifier'),
        ),
        body: Column(
          children: <Widget>[
            _image == null ? Container() : Image.file(_image!),
            _recognitions != null ? Text(_recognitions![0]["label"]) : Container()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: pickImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}
