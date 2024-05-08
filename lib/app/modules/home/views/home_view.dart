import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            padding: const EdgeInsets.only(left: 50),
            child: const Text(
              'PROFILE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel", style: TextStyle(color: Colors.pink),),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          controller.logout();
                        },
                        child: const Text("Logout", style: TextStyle(color: Colors.pink),),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout, size: 25,),
            color: Colors.pink,
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 238, 242, 255),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_home.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userData = snapshot.data?.data();
                if (userData != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 60,
                               backgroundImage: userData['image_url'] != null
                                    ? NetworkImage(userData['image_url'])
                                    : AssetImage(controller.defaultImagePath) as ImageProvider,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Positioned(
                              right: -5,
                              bottom: 0,
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Center(
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Profile Image"),
                                                content: const Text("What would you like to do with your profile image?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(context).pop();
                                                      await controller.getImage(true);
                                                      await controller.uploadImageToFirebase();
                                                    },
                                                    child: const Text("Upload", style: TextStyle(color: Colors.pink),),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(context).pop();
                                                      await controller.deleteOldProfileImage();
                                                    },
                                                    child: const Text("Delete", style: TextStyle(color: Colors.pink),),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 25,
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Icon(
                                          Icons.account_circle,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        userData['name'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Icon(
                                          Icons.email,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        userData['email'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        userData['phone number'] != null ? userData['phone number'].toString() : '',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 16), 
                                    Expanded(
                                      child: Text(
                                        userData['address'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text('No user data available.');
                }
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.pink,
      ),
    );
  }
}
