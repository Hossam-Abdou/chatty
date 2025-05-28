// import 'package:chatty/features/home/widgets/edit_message_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class MessageActions {
//   static Future<void> deleteMessage(
//       BuildContext context,
//       String messageId,
//       String currentUserUid,
//       String receiverUid,
//       ) async {
//     try {
//       final chatRoomId = generateChatRoomId(currentUserUid, receiverUid);
//
//       await FirebaseFirestore.instance
//           .collection('chatRooms')
//           .doc(chatRoomId)
//           .collection('messages')
//           .doc(messageId)
//           .delete();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Message deleted')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $e')),
//       );
//     }
//   }
//
//   static Future<void> editMessage(
//       BuildContext context,
//       String messageId,
//       String currentUserUid,
//       String receiverUid,
//       ) async {
//     try {
//       final chatRoomId = generateChatRoomId(currentUserUid, receiverUid);
//
//       // Fetch the message from Firestore
//       final messageSnapshot = await FirebaseFirestore.instance
//           .collection('chatRooms')
//           .doc(chatRoomId)
//           .collection('messages')
//           .doc(messageId)
//           .get();
//
//       if (!messageSnapshot.exists || messageSnapshot.data()!['text'] == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Message not found')),
//         );
//         return;
//       }
//
//       final currentText = messageSnapshot.data()!['text'] as String;
//
//       // Show the edit dialog with the current message pre-filled
//       final newText = await showDialog<String>(
//         context: context,
//         builder: (context) {
//           return EditMessageDialog(currentText: currentText);
//         },
//       );
//
//       // Check if the user provided new text and if it differs from the current text
//       if (newText != null && newText.isNotEmpty && newText.trim() != currentText.trim()) {
//         await FirebaseFirestore.instance
//             .collection('chatRooms')
//             .doc(chatRoomId)
//             .collection('messages')
//             .doc(messageId)
//             .update({
//           'text': newText,
//           'isEdited': true, // Mark the message as edited
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Message updated')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $e')),
//       );
//     }
//   }
//
//   static String generateChatRoomId(String user1Uid, String user2Uid) {
//     final uids = [user1Uid, user2Uid]..sort();
//     return uids.join('_');
//   }
// }