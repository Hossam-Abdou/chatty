import 'package:chatty/features/home/view/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UsersListTile extends StatelessWidget {
  final Stream<QuerySnapshot> homeStream;
  final String searchQuery;
  final String currentUserId;

  const UsersListTile({super.key,
    required this.homeStream,
    required this.searchQuery,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: homeStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users found!', style: TextStyle(color: Colors.white)),
            );
          }

          final users = snapshot.data!.docs;
          final filteredUsers = users
              .where((user) =>
          user['uid'] != currentUserId && (user['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
                  user['email']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase())))
              .toList();

          if (filteredUsers.isEmpty) {
            return const Center(
              child: Text('No matching users found!', style: TextStyle(color: Colors.white)),
            );
          }

          String generateChatRoomId(String user1Uid, String user2Uid) {
            List<String> uids = [user1Uid, user2Uid];
            uids.sort();
            return uids.join('_');
          }
          // ConnectionState.waiting==true? const Center(child: CircularProgressIndicator(color: AppColors.secondaryColor,)) :
          return   ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              final userEmail = user['email'];
              final userName = user['name'];
              final userUid = user['uid'];
              final chatRoomId = generateChatRoomId(currentUserId, userUid);

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatRooms')
                    .doc(chatRoomId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .limit(1) // Only fetch the latest message
                    .snapshots(),
                builder: (context, messageSnapshot) {


                  // Check if there are any messages
                  if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
                    return const SizedBox.shrink(); // Hide users with no messages
                  }

                  final latestMessage = messageSnapshot.data!.docs.first;
                  final senderUid = latestMessage['senderUid'];
                  String lastMessage = latestMessage['text'];

                  if (senderUid == currentUserId) {
                    lastMessage = 'You: $lastMessage';
                  }

                  String lastMessageTime = '';
                  final timestamp = latestMessage['timestamp'];
                  if (timestamp != null) {
                    try {
                      final dateTime = (timestamp as Timestamp).toDate();
                      lastMessageTime = DateFormat('h:mm a').format(dateTime);
                    } catch (e) {
                      print('Error parsing timestamp: $e');
                    }
                  }

                  // Display the user's tile only if there are messages
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      lastMessageTime,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
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
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}