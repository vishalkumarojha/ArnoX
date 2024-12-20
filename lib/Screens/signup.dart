import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_to_speedv1/Data/data.dart';
import 'package:image_to_speedv1/Screens/gallery.dart';
import 'package:image_to_speedv1/Screens/login.dart';

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _showPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 30.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 22.w, bottom: 10.h),
              child: Text(
                "Create your Account",
                style: TextStyle(
                  fontSize: 20.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email ID",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        icon: Icon(
                          Icons.person,
                          size: 30.r,
                        ),
                      ),
                      validator: (value) {
                        if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)) {
                          return null;
                        } else {
                          return "Please check your Email Address";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                    child: TextFormField(
                      obscureText: _showPassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        icon: Icon(
                          Icons.lock_outline,
                          size: 30.r,
                        ),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              _showPassword = !_showPassword;
                              setState(() {});
                            },
                            child: Icon(!_showPassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded)),
                      ),
                      validator: (value) {
                        if (value!.length > 7) {
                          return null;
                        } else {
                          return "Password can only be minimum opf 8 Characters";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                    child: TextFormField(
                      obscureText: _showPassword,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        icon: Icon(
                          Icons.lock_outline,
                          size: 30.r,
                        ),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              _showPassword = !_showPassword;
                              setState(() {});
                            },
                            child: Icon(!_showPassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded)),
                      ),
                      validator: (value) {
                        if (value!.length > 7) {
                          return null;
                        } else {
                          return "Password can only be minimum opf 8 Characters";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
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
                        padding: EdgeInsets.symmetric(horizontal: 120.w),
                        child: TextButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate() && confirmPasswordController.text == passwordController.text) {
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    )
                                    .then(
                                      (value) => Get.offAll(
                                        routeName: routes["homePage"],
                                        () => const Gallery(),
                                        transition: custransition,
                                        duration: cusDuration,
                                        curve: cusCurve,
                                      ),
                                    );
                              } on FirebaseAuthException catch (e) {
                                debugPrint(e.message);
                              }
                            }
                          },
                          child: Text(
                            "SignUp",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already Joined Us?",
                        style: TextStyle(fontSize: 15.r),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.off(
                            routeName: routes["login"],
                            () => const Login(),
                            transition: custransition,
                            duration: cusDuration,
                            curve: cusCurve,
                          );
                        },
                        child: Text(
                          "LogIn",
                          style: TextStyle(fontSize: 15.r),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
