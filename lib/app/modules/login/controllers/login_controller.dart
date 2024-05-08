import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  Stream<User?> get streamAuthStatus => FirebaseAuth.instance.authStateChanges();

  void login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (userCredential.user!.emailVerified) {
          Get.snackbar('Success', 'User logged in successfully');
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.snackbar('Error', 'Please verify your email');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar('Error', 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Error', 'Wrong password provided for that user.');
        } else if (e.code == 'too-many-requests') {
          Get.snackbar('Error', 'Too many requests. Try again later.');
        } else {
          Get.snackbar('Error', 'Email or Password is invalid. Please try again.');
        }
        print(e.code);
      } catch (e) {
        Get.snackbar('Error', 'An unexpected error occurred');
        print(e);
      } finally {
        isLoading.value = false;
      }
    }
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
