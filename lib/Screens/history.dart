import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_to_speedv1/Data/data.dart';
import 'package:image_to_speedv1/Screens/resultView.dart';

class history extends StatelessWidget {
  const history({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference userHistoryRef = FirebaseFirestore.instance
        .collection("User History")
        .doc(userId)
        .collection("documents");

    return Scaffold(
      appBar: AppBar(
        title: Text('User History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userHistoryRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Get.to(
                      routeName: "resultView",
                      () => Resultview(text: data["result"]),
                      curve: cusCurve,
                      transition: custransition,
                      duration: cusDuration);
                },
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: ListTile(
                        title: SizedBox(
                          child: Text(data['result']),
                          height: 80.h,
                        ),
                        subtitle: Text(data['time'].toDate().toString()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: const Divider(),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
