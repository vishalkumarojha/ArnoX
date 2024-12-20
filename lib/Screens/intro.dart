import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_to_speedv1/Data/data.dart';
import 'package:image_to_speedv1/Requirements/fade-out.dart';
import 'package:image_to_speedv1/Screens/gallery.dart';
import 'package:image_to_speedv1/Screens/login.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    // Return the Into Page for the App if not Signed In
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(child: Text("IMSpeech", style: TextStyle(fontSize: 40.r, fontWeight: FontWeight.w700),)),
            // Display the Image of the Intro Page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 70.h,
                  ),
                  child: SizedBox(
                    height: 200.h,
                    child: FadedWidget(
                      child: Image.asset(
                        "assets/intro.jpg",
                        width: 250.w,
                        height: 250.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Give a Headline of the App and the Moto for developing the App
            SizedBox(
              width: 360.w,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 50.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      introHeader,
                      style: TextStyle(
                        fontSize: 30.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // A Text Intro for the App
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 33.w,
                vertical: 14.h,
              ),
              child: Text(
                introText,
                style: TextStyle(
                  fontSize: 17.r,
                ),
              ),
            ),

            // A button to move on forward in the App
            Padding(
              padding: EdgeInsets.only(top: 50.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(
                        routeName: routes["login"],
                        () => const Login(),
                        transition: custransition,
                        duration: cusDuration,
                        curve: cusCurve,
                      );
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 25.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_double_arrow_right_sharp,
                    color: Colors.blueAccent,
                    size: 25.r,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
