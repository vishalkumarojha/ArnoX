import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Resultview extends StatefulWidget {
  const Resultview({super.key, required this.text});

  final String text;

  @override
  State<Resultview> createState() => _ResultviewState();
}

class _ResultviewState extends State<Resultview> {
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.text),
            Container(
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
            )
          ],
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
