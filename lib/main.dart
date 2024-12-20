import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_to_speedv1/Screens/gallery.dart';
import 'package:image_to_speedv1/Screens/intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_to_speedv1/Screens/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const ScreenUtilInit();
  runApp(const ITSpeech());
}

class ITSpeech extends StatelessWidget {
  const ITSpeech({super.key});

  @override
  Widget build(BuildContext context) {
    User currentUser;
    bool loggedIn;

    if (FirebaseAuth.instance.currentUser != null) {
      currentUser = FirebaseAuth.instance.currentUser!;
    } else {
      loggedIn = false;
    }
    return ScreenUtilInit(
      child: GetMaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser != null
            ? const Gallery()
            : const Intro(),
      ),
    );
  }
}
