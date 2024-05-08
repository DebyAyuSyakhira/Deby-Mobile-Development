import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../routes/app_pages.dart';

class RegisController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool loading = false.obs;

  void regis(String name, String email, String phoneNumber, String address) async {
    if (formKey.currentState!.validate()) {
      if (passwordController.text.trim() != confirmPassController.text.trim()) {
        Get.snackbar('Error', 'Password and confirm password do not match.');
        return; 
      }
      try {
        loading.value = true;
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        String userId = userCredential.user!.uid; 
      
        await firestore.collection('user').doc(userId).set({
          'name': name,
          'email': email,
          'phone number': phoneNumber,
          'address': address,
        });
        
        userCredential.user!.sendEmailVerification();
        Get.defaultDialog(
          title: 'Verify your email',
          middleText:'Please verify your email to continue. We have sent you an email verification link.',
          textConfirm: 'OK',
          textCancel: 'Resend',
          confirmTextColor: Colors.pink,
          onConfirm: () {
            loading.value = false;
            Get.offAllNamed(Routes.LOGIN);
          },
          onCancel: () {
            userCredential.user!.sendEmailVerification();
            Get.snackbar('Success', 'Email verification link sent');
          },
        );
      } on FirebaseAuthException catch (e) {
        loading.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar('Error', 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Error', 'The account already exists for that email.');
        } else {
          Get.snackbar('Error', 'Failed to create account: ${e.message}');
        }
      } catch (e) {
        loading.value = false;
        print(e);
        Get.snackbar('Error', 'An unexpected error occurred.');
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
