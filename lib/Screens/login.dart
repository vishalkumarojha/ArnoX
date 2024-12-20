import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_to_speedv1/Data/data.dart';
import 'package:image_to_speedv1/Screens/gallery.dart';
import 'package:image_to_speedv1/Screens/signup.dart';

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                "Welcome Back !",
                style: TextStyle(
                  fontSize: 30.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 20.h),
              child: Text(
                "Enter your Credentials for Login in to your Account",
                style: TextStyle(
                  fontSize: 20.r,
                  fontWeight: FontWeight.w300,
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        icon: const Icon(Icons.alternate_email),
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        icon: const Icon(Icons.lock_outline),
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
                    padding: EdgeInsets.only(left: 180.w),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 15.r,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
                        padding: EdgeInsets.symmetric(horizontal: 120.w),
                        child: TextButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text)
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
                                if (e.code.toLowerCase() ==
                                    "invalid-credential") {
                                  Get.snackbar("Wrong Credentials",
                                      "Please check the Credentials you've Entered");
                                }
                              }
                            }
                          },
                          child: Text(
                            "Login",
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
                        "Didn't Joined Us yet?",
                        style: TextStyle(fontSize: 15.r),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.off(
                            routeName: routes["signup"],
                            () => Signup(),
                            transition: custransition,
                            duration: cusDuration,
                            curve: cusCurve,
                          );
                        },
                        child: Text(
                          "Sign Up",
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
