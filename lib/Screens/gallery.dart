import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_speedv1/Data/data.dart';
import 'package:image_to_speedv1/Requirements/fade-out.dart';
import 'package:image_to_speedv1/Screens/history.dart';
import 'package:image_to_speedv1/Screens/result.dart';

import 'intro.dart';

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  File? _image;
  String _text = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    String description = await getImageDescription(File(image!.path));
    setState(() {
      _image = File(image.path);
    });
    _recognizeText(_image!, description);
  }

  Future<void> _clickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    String description = await getImageDescription(File(image!.path));
    setState(() {
      _image = File(image.path);
    });
    _recognizeText(_image!, description);
  }

  Future<String> getImageDescription(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    // Create ImageLabelerOptions with desired settings
    final options = ImageLabelerOptions(
      confidenceThreshold: 0.7, // Adjust threshold as needed
    );

    final labeler = ImageLabeler(options: options);

    try {
      final List<ImageLabel> labels = await labeler.processImage(inputImage);
      if (labels.isNotEmpty) {
        // Combine the top 5 labels to form a descriptive sentence
        final topLabels = labels.take(5).toList();
        String description = "The image contains ";
        for (int i = 0; i < topLabels.length; i++) {
          description += topLabels[i].label;
          if (i < topLabels.length - 1) {
            description += ", ";
          }
        }
        return description;
      } else {
        return "No objects or scenes could be identified in the image.";
      }
    } catch (e) {
      print('Error labeling image: $e');
      return "Error processing image.";
    } finally {
      labeler.close();
    }
  }

  Future<void> _recognizeText(File image, String description,
      {String? preSavedText}) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      setState(() {
        _text = recognizedText.text;
      });
      Get.to(
        routeName: routes["result"],
        () => ResultView(
          text: _text,
          image: image,
          description: description,
        ),
        transition: custransition,
        duration: cusDuration,
        curve: cusCurve,
      );
    } catch (e) {
      debugPrint('Error recognizing text: $e');
      setState(() {
        _text = 'Error recognizing text.';
      });
    } finally {
      textRecognizer.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: 500.w,
        child: ListView(
          children: [
            SizedBox(
              height: 200.h,
              child: DrawerHeader(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 300.w),
                      child: IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.closeDrawer();
                          },
                          icon: const Icon(Icons.close)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/drawer.png",
                          height: 200.h,
                          width: 200.w,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(
                "History",
                style: TextStyle(fontSize: 15.w),
              ),
              onTap: () {
                Get.to(
                  routeName: routes["history"],
                  () => const history(),
                  transition: custransition,
                  duration: cusDuration,
                  curve: cusCurve,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                "LogOut",
                style: TextStyle(fontSize: 15.w),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut().then(
                      (value) => Get.offAll(
                        routeName: "intro",
                        () => const Intro(),
                        transition: custransition,
                        duration: cusDuration,
                        curve: cusCurve,
                      ),
                    );
              },
            ),
            ListTile(
              title: Text("-----------Developers---------"),
            ),
            for (int i = 0; i < names.length; i++)
              ListTile(
                title: Text(
                  "${names.keys.elementAt(i)} - ${names.values.elementAt(i)}",
                  style: TextStyle(fontSize: 15.w),
                ),
                // onTap: () { _handleNavigation(context, i); },
              ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Image to Text Recognition App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadedWidget(
                      child: Image.asset(
                        "assets/${SchedulerBinding.instance.platformDispatcher.platformBrightness}.jpg",
                        width: 200.w,
                        height: 180.h,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: SizedBox(
                              width: 180.w,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: TextButton(
                                  onPressed: () => _clickImage(),
                                  child: Text(
                                    "Take a Picture",
                                    style: TextStyle(
                                      fontSize: 20.r,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: SizedBox(
                              width: 180.w,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: TextButton(
                                  onPressed: () => _pickImage(),
                                  child: Text(
                                    "Gallery",
                                    style: TextStyle(
                                      fontSize: 20.r,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
