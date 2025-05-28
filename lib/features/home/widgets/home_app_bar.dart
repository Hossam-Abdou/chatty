import 'package:chatty/core/utils/app_colors.dart';
import 'package:chatty/core/utils/services/secure_storage.dart';
import 'package:chatty/features/auth/view/login_screen.dart';
import 'package:chatty/features/home/view/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryColor,
      title: Row(
        children: [
          Text(
            'Chatty',
            style: GoogleFonts.poiretOne(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
          ),
          Image.asset(
            'images/chat.png',
            height: MediaQuery.sizeOf(context).height * 0.026,
            width: 40.32,
          ),
        ],
      ),
      actions: [
        // Profile Icon
        Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: GestureDetector(
            onTap: () {
              _showProfileDialog(context);
            },
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
// ImageIcon(AssetImage('images/edit_profile.png'),color: Colors.white,),
      // Logout Button
      //   IconButton(
      //     icon: const Icon(Icons.logout, color: Colors.white),
      //     onPressed: () async {
      //       String userUid = FirebaseAuth.instance.currentUser!.uid;
      //       await FirebaseFirestore.instance
      //           .collection('users')
      //           .doc(userUid)
      //           .update({'fcmToken': ''}); // or use null instead of ''
      //       await FirebaseAuth.instance.signOut();
      //
      //       await SecureStorage.deleteData(key: 'token');
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => const LoginScreen()),
      //       );
      //     },
      //   ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // Show Profile Dialog
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(8),

            // decoration: BoxDecoration(
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.white.withOpacity(0.5),
            //       spreadRadius: 2,
            //       blurRadius: 4,
            //       offset: const Offset(2, 2),
            //     ),
            //   ]
            // ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                SizedBox(
                  height: 25,
                  child: Align(
                    alignment: Alignment.topRight,
                      child: IconButton(

                          onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      )),),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 56,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 55.5,
                    child: Image.asset(
                      'images/user.png',
                      height: MediaQuery.sizeOf(context).height * 0.1,
                    ),
                  )
                ),
                const SizedBox(height: 16),

                // User Name
                Text(
                  FirebaseAuth.instance.currentUser!.displayName ?? '...',
                  // Replace with dynamic user name
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                // Email
                Text(
                  '${FirebaseAuth.instance.currentUser!.email}',
                  // Replace with dynamic email
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: Divider(),
                ),
                const SizedBox(height: 8),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, ),

                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white,),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: ()async {

                      String userUid = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userUid)
                          .update({'fcmToken': ''}); // or use null instead of ''
                      await FirebaseAuth.instance.signOut();

                      await SecureStorage.deleteData(key: 'token');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red[100]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
                    ),
                    child: Text(
                      'Log out',
                      style: TextStyle(color: Colors.red[400]!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
