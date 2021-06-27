import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List outputs;
  File _image;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    //  _loading = true;

    loadModel().then((value) {
      setState(() {
        //  _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text("Doggy & Catty",
                      style: TextStyle(color: Color(0xFFEEDA28), fontSize: 20)),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Dogs and Cats Classifier',
                    style: TextStyle(
                        color: Color(0xFFE99600),
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: _loading
                      ? Container(
                          width: 300,
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/dogAndcat.jpg',
                                width: 300,
                                height: 250,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'please select image from gallery or camera.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ))
                      : Container(
                          child: Column(
                            children: [
                              _image == null
                                  ? Container()
                                  : Container(
                                      height: 250, child: Image.file(_image)),
                            ],
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: pickCameraImage,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 250,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                              color: Color(0xFFE99600),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text('Camera',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: pickGallerytImage,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 250,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                              color: Color(0xFFE99600),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text('Gallery',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                outputs != null && outputs[0]['label'] == "0 Dog"
                    ? Container(
                        child: Image.asset(
                          "assets/dog.png",
                          width: 100,
                          height: 100,
                        ),
                      )
                    : Container(),
                outputs != null && outputs[0]['label'] == "1 Cat"
                    ? Container(
                        child: Image.asset(
                          "assets/cat.png",
                          width: 100,
                          height: 100,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                outputs == null
                    ? Text(
                        'Result',
                        style: TextStyle(color: Colors.white),
                      )
                    : Container(
                        child: Text(
                          "${outputs[0]['label'].substring(2)} : ${(outputs[0]['confidence'] * 100).toStringAsFixed(1)} %",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      )
              ]),
        ),
      ),
    );
  }

  pickCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGallerytImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
