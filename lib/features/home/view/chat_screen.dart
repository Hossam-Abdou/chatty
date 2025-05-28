import 'package:chatty/core/utils/app_colors.dart';
import 'package:chatty/core/utils/components/snackbar.dart';
import 'package:chatty/features/home/view_model/chat_cubit.dart';
import 'package:chatty/features/home/widgets/chat_bubble_item.dart';
import 'package:chatty/features/home/widgets/edit_message_dialog.dart';
import 'package:chatty/features/home/widgets/message_input_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverUid;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverUid,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String generateChatRoomId(String user1Uid, String user2Uid) {
    // Sort the UIDs alphabetically
    final uids = [user1Uid, user2Uid]..sort();
    // Join the sorted UIDs with a separator (e.g., '_')
    return uids.join('_');
  }
  void handleMessageLongPress(String messageId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _editMessage(messageId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _deleteMessage(messageId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteMessage(String messageId) async {
    final chatRoomId = generateChatRoomId(
      context.read<ChatCubit>().firebaseAuth.currentUser!.uid,
      widget.receiverUid,
    );

    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message deleted')),
    );
  }

  Future<void> _editMessage(String messageId) async {
    try {
      // Ensure currentUser is not null
      final currentUser = context.read<ChatCubit>().firebaseAuth.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to edit messages')),
        );
        return;
      }

      final chatRoomId = generateChatRoomId(currentUser.uid, widget.receiverUid);

      // Fetch the message from Firestore
      final messageSnapshot = await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .get();

      // Ensure the message exists and has a 'text' field
      if (!messageSnapshot.exists || messageSnapshot.data()!['text'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message not found')),
        );
        return;
      }

      // Extract the current message text
      final currentText = messageSnapshot.data()!['text'] as String;

      // Show the edit dialog with the current message pre-filled
      final newText = await showDialog<String>(
        context: context,
        builder: (context) {

          return EditMessageDialog(
            currentText: currentText,
          );
        },
      );

      // Check if the user provided new text and if it differs from the current text
      if (newText != null && newText.isNotEmpty && newText.trim() != currentText.trim()) {
        await FirebaseFirestore.instance
            .collection('chatRooms')
            .doc(chatRoomId)
            .collection('messages')
            .doc(messageId)
            .update({
          'text': newText,
          'isEdited': true, // Mark the message as edited
        });

        snackBarMessage(
          context: context,
          message: 'Message updated',
        );
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('No changes made')),
        // );
      }
    } catch (e) {
      // Handle unexpected errors
      // print('Error editing message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().initializeChatRoom(widget.receiverUid);

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   debugPrint('Got a message whilst in the foreground!');
    //   debugPrint('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     debugPrint('Notification title: ${message.notification?.title}');
    //     debugPrint('Notification body: ${message.notification?.body}');
    //   }
    // });
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return Scaffold(
          backgroundColor: AppColors.primaryColor,

          appBar: CustomAppBar(),
          body: Column(
            children: [
              ChatBubbleItem(
                currentUserUid: cubit.firebaseAuth.currentUser!.uid,
                  messages: cubit.getMessagesStream(),
                onLongPress: handleMessageLongPress, // Pass the selection handler

              ),
              MessageInputField(
                controller: cubit.messageController,
                onSend: () {
                  cubit.sendMessage(widget.receiverUid);

                },
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar CustomAppBar() {
    return AppBar(
          backgroundColor: AppColors.primaryColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white,size: 19),
           title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Center(
                  child: Image.asset(
                    'images/user.png',
                    height: 16,
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),
              Text(
                widget.receiverName,
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
            ],
          ),

        );
  }


}
