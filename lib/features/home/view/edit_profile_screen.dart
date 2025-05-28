import 'package:chatty/core/utils/app_colors.dart';
import 'package:chatty/features/auth/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text:FirebaseAuth.instance.currentUser!.displayName);
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title:  Text('Edit Profile',style:GoogleFonts.poppins(
              color: Colors.white, ),),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 50),
          child: SingleChildScrollView(
            child: Column(

              children: [
                // Profile Image
                Image.asset('images/user.png',height: MediaQuery.sizeOf(context).height * 0.17,),
                const SizedBox(height: 35),

                // Name Field
                TextField(

                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'User-Name',
                    labelStyle: const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                      const BorderSide(color: Color(0xff2FC2FF), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                  ),
                ),
                const SizedBox(height: 24),

                // Email Field
                TextField(
                  controller: TextEditingController(text: FirebaseAuth.instance.currentUser!.email),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                      const BorderSide(color: Color(0xff2FC2FF), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  enabled: false, // Email cannot be edited directly
                ),
                const SizedBox(height: 21),


                CustomButton(title: 'Save Changes', condition: true,  onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name cannot be empty')),
                    );
                    return;
                  }

                  try {
                    // Update display name in Firebase Authentication
                    await FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);

                    // Optionally, update Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({'name': nameController.text});

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );

                    // Navigate back
                    Navigator.pop(context);
                  } catch (e) {
                    print('heree ${e.toString()}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating profile: $e')),
                    );
                  }
                },),
                // Save Button

              ],
            ),
          ),
        ),
      ),
    );
  }
}
