import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final image = XFile("").obs;
  final String defaultImagePath = "assets/pp.jpg";

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUsers() {
    final String userId = _auth.currentUser?.uid ?? '';
    return firestore.collection('user').doc(userId).snapshots();
  }

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    if (gallery) {
      pickedFile = await picker.pickImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera,
      );
    } else {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
    }
    if (pickedFile != null) {
      image.value = pickedFile;
    } else {
      image.value = XFile(defaultImagePath);
    }
  }

  Future<void> uploadImageToFirebase() async {
    try {
      if (image.value.path != defaultImagePath) {
        await deleteOldProfileImage();

        final File imageFile = File(image.value.path);
        final String userId = _auth.currentUser?.uid ?? '';
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        final Reference firebaseStorageRef = storage.ref().child('Foto/$userId/$fileName');
        await firebaseStorageRef.putFile(imageFile);
        final String imageUrl = await firebaseStorageRef.getDownloadURL();

        await firestore.collection('user').doc(userId).update({'image_url': imageUrl});
      } else {
        print('Using default image. No need to upload.');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> deleteOldProfileImage() async {
    final String userId = _auth.currentUser?.uid ?? '';
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await firestore.collection('user').doc(userId).get();
    final String? oldImageUrl = userSnapshot.data()?['image_url'];
    if (oldImageUrl != null) {
      try {
        await storage.refFromURL(oldImageUrl).delete();
        await userSnapshot.reference.update({'image_url': FieldValue.delete()});
      } catch (e) {
        print('Error deleting old profile image: $e');
      }
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
