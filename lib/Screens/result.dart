import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_to_speedv1/Requirements/fade-out.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key, required this.text, required this.image, required this.description});

  final String text;
  final File image;
  final String description;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    _initTts();
    super.initState();
  }

  _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(100);
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  void storeToFirebase() async {
    // Get the current user ID
    final String userId = FirebaseAuth.instance.currentUser!.uid;

// Reference the user's history collection
    final CollectionReference userHistoryRef = FirebaseFirestore.instance
        .collection("User History")
        .doc(userId)
        .collection("documents");

// Create a new document within the user's history collection
    final DocumentReference newDocRef = userHistoryRef.doc();

// Set the data in the new document
    await newDocRef.set({
      "time": DateTime.now(),
      "result": widget.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    storeToFirebase();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h, bottom: 40.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadedWidget(
                          child: Image.file(
                            widget.image,
                            width: 250.w,
                            height: 250.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    Text(widget.description),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(widget.text),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.blueAccent,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: TextButton(
                      onPressed: () {
                        _speak(widget.text);
                      },
                      child: Text(
                        "Narrate",
                        style: TextStyle(fontSize: 18.r),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
