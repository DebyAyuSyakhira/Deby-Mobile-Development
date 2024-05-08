import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/reset_controller.dart';

class ResetView extends GetView<ResetController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              Container(
                height: 221,
                width: 221,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/login_logo.png'),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 223, 128, 144),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      autocorrect: true,
                      controller: controller.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is still empty';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 223, 128, 144),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () => controller.resetPassword(controller.emailController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:const Color.fromARGB(255, 248, 30, 67),
                        minimumSize: const Size(250, 50), 
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Obx(() => controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.white),
                            )),
                    ),
                    TextButton(
                      onPressed: () {
                       Get.offAllNamed(Routes.LOGIN);
                      },
                      child: const Text(
                      'Back to Login',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        )
      )
    );
  }
}
