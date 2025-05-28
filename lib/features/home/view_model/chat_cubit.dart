import 'package:chatty/features/home/widgets/edit_message_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatty/core/constants/access_token.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  String? chatRoomId;

  // final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  // final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  String get currentUserUid => firebaseAuth.currentUser!.uid;

  final TextEditingController messageController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  searchFieldChanged(String value) {
    searchQuery = value;
    emit(SearchFieldChangedState());
  }

  Stream<List<DocumentSnapshot>> getUsersWithoutMessages() async* {
    final usersSnapshot = await firestore.collection('users').get();
    final users = usersSnapshot.docs
        .where((user) => user['uid'] != currentUserUid)
        .toList();

    final usersWithoutMessages = <DocumentSnapshot>[];

    for (final user in users) {
      final chatRoomId = generateChatRoomId(currentUserUid, user['uid']);
      final messagesSnapshot = await firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isEmpty) {
        usersWithoutMessages.add(user);
      }
    }

    yield usersWithoutMessages;
  }

  // Initialize the chatRoomId
  void initializeChatRoom(String receiverUid) {
    chatRoomId = generateChatRoomId(currentUserUid, receiverUid);
  }

  // Fetch the current user's name
  Future<String?> getCurrentUserName() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (userSnapshot.exists) {
        debugPrint('User Name: ${userSnapshot.data()?['name']}');
        return userSnapshot.data()?['name'];
      } else {
        debugPrint('User document does not exist');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
      return null;
    }
  } // Generate a unique chat room ID

  String generateChatRoomId(String user1Uid, String user2Uid) {
    List<String> uids = [user1Uid, user2Uid];
    uids.sort();
    return uids.join('_');
  }

  // Streams
  Stream<QuerySnapshot> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getHomeStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      debugPrint('Fetched users: ${snapshot.docs.map((doc) => doc.data())}');
      return snapshot;
    });
  }

  Stream<QuerySnapshot> getHomeUsersStream(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy(
          'timestamp',
          descending: true,
        )
        .limit(1) // Only fetch the latest message
        .snapshots();
  }
  Future<void> sendMessage(String receiverUid) async {
    // Ensure the message text is not empty and chatRoomId is initialized
    if (messageController.text.isNotEmpty && chatRoomId != null) {
      try {
        // Capture the message text before clearing the TextField
        final String messageText = messageController.text;

        // Clear the TextField immediately
        messageController.clear();

        // Get the current timestamp
        final Timestamp timestamp = Timestamp.now();

        // Fetch the sender's name
        String? senderName = await getCurrentUserName();

        // Send the message to Firestore
        await FirebaseFirestore.instance
            .collection('chatRooms')
            .doc(chatRoomId)
            .collection('messages')
            .add({
          'text': messageText, // Use the captured message text
          'senderUid': firebaseAuth.currentUser!.uid,
          'receiverUid': receiverUid,
          'timestamp': timestamp,
          'isEdited': false, // Add this field for new messages
        });

        // Fetch the recipient's FCM token
        final receiverSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(receiverUid)
            .get();
        final String? fcmToken = receiverSnapshot.data()?['fcmToken'];

        // Send a notification to the recipient if FCM token exists
        if (fcmToken != null) {
          await AppAccessToken.sendNotificationToDevice(
              fcmToken, messageText, senderName!);
        }
      } catch (e) {
        debugPrint('Error sending message: $e');
        // Optionally, restore the message text back to the TextField if sending fails
        // messageController.text = messageText; // Restore the message text
      }
    }
  }

}

