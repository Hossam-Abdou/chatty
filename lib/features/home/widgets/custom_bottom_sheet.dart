import 'package:chatty/core/utils/app_colors.dart';
import 'package:chatty/features/home/view/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Stream<List<DocumentSnapshot>> usersWithoutMessages;
  const CustomBottomSheet({super.key, required this.usersWithoutMessages});

@override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream:usersWithoutMessages ,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(
            color: Color(0xff2FC2FF),
          ));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No users available to start a new chat.',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          );
        }

        final users = snapshot.data!;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final userName = user['name'];
            final userEmail = user['email'];
            final userUid = user['uid'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Center(
                        child: Image.asset(
                          'images/user.png',
                          height: 16,
                        ),
                      ),
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      userEmail,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            receiverEmail: userEmail,
                            receiverUid: userUid,
                            receiverName: userName,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
