import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ResetController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  void resetPassword(String email) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      if (email != "" && GetUtils.isEmail(email)) {
        await auth.sendPasswordResetEmail(email: email);
        Get.snackbar('Success', 'Password reset link sent to your email');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar('Error', 'Please enter a valid email');
      }
    }
  }
}
