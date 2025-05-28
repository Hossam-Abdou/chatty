import 'package:chatty/core/utils/services/fcm_service.dart';
import 'package:chatty/core/utils/services/secure_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Stream? messagesStream;
  Stream? usersStream;
  // UserModel userModel = UserModel();

  static FirebaseAuth auth = FirebaseAuth.instance;


  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  Future<void>Login() async {
  try {
    emit(ChatLoginloading());

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      emit(ChatLoginError(error: 'Email and password cannot be empty.'));
      return;
    }

    if (!isValidEmail(emailController.text)) {
      emit(ChatLoginError(error: 'Please enter a valid email address.'));
      return;
    }
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    FCMService().saveDeviceToken(FirebaseAuth.instance.currentUser!.uid);
    await SecureStorage.saveData(key: 'token', value: credential.user!.uid);
    emit(ChatLoginSuccess());
    passwordController.clear();
    emailController.clear();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      // print('No user found for that email.');
      emit(ChatLoginError(error: e.code.toString()));

    } else if (e.code == 'wrong-password') {
      // print('Wrong password provided for that user.');
      emit(ChatLoginError(error: e.code.toString()));

    }
  }
}

  Future<void> signUp() async {
    try {
      emit(ChatRegisterLoading());
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await credential.user?.updateDisplayName(nameController.text);

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'uid': credential.user?.uid,

      });

      // print('User signed up: ${credential.user?.email}');
      emit(ChatRegisterSuccess());
      await SecureStorage.saveData(key: 'token', value: credential.user!.uid);
      FCMService().saveDeviceToken(FirebaseAuth.instance.currentUser!.uid);
nameController.clear();
emailController.clear();
passwordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        debugPrint('The email provided is invalid.');
      } else {
        debugPrint('Sign-up failed: ${e.message}');
      }
      emit(ChatRegisterError(error: e.message ?? 'Error occurred during sign-up'));
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      emit(ChatRegisterError(error: 'An unexpected error occurred.'));
    }
  }

  bool isVisible=true;

  changeObscureText() {
    isVisible = !isVisible;
    emit(ChangeObscureTextState());
  }


  @override
  Future<void> close() {
    // Dispose of controllers when the cubit is closed
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
  //
  // users() async {
  //   usersStream = FirebaseFirestore.instance
  //       .collection('user')
  //   // .where('id', isEqualTo: auth.currentUser?.uid)
  //       .snapshots(includeMetadataChanges: true);
  //   emit(GetUsersState());
  // }
  //
  //
  // Register() async {
  //   emit(ChatRegisterLoading());
  //   await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(
  //     email: emailController.text,
  //     password: passwordController.text,
  //   )
  //       .then((value) {
  //     emit(ChatRegisterSuccess());
  //   }).catchError((error) {
  //     emit(ChatRegisterError(error: error.toString()));
  //   });
  // }





//
//  UserModel me = UserModel(
//     uid: user.uid,
//     name: user.displayName,
//     email: user.email.toString(),
//     // about: "Hey, I'm using We Chat!",
//     image: user.photoURL,
//     // createdAt: '',
//     isOnline: false,
//     // lastActive: '',
//     // pushToken: ''
//  );
// static User get user => auth.currentUser!;

// static  Future<bool> usersExists() async {
//   return (await FirebaseFirestore.instance
//           .collection('users')
//           .doc(auth.currentUser!.email)
//           .get())
//       .exists;
// }

// static Future<void> createUser() async {
//   UserModel chatUser = UserModel(
//       id: auth.currentUser!.uid,
//       name: user.displayName.toString(),
//       image: user.photoURL.toString(),
//       about: 'Hey I am using Chat',
//       email: auth.currentUser!.email,
//       lastActive: DateTime.now().millisecondsSinceEpoch.toString(),
//       createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
//       pushToken: '',
//       isOnline: false);
//   return await FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .set(chatUser.toJson());
// }





  // sendMessage(String text, DateTime time, String receiverEmail) {
  //   String userEmail = FirebaseAuth.instance.currentUser!.email!;
  //
  //   Message message = Message(text: text, time: time, sender: userEmail, receiver: receiverEmail);
  //   FirebaseFirestore.instance
  //       .collection('messages')
  //       .add(message.toMap())
  //       .then((value) {
  //     emit(ChatSendSuccess());
  //   }).catchError((error) {
  //     emit(ChatSendError());
  //     print(error);
  //   });
  // }
  //
  // receiveMessages() {
  //   messagesStream = FirebaseFirestore.instance
  //       .collection('messages')
  //       // .where('sender', isEqualTo: FirebaseAuth.instance.currentUser?.email)
  //       // .where('receiver', isEqualTo: userModel?.email.toString())
  //       .orderBy('time')
  //       .snapshots();
  //
  //   emit(ChatReceiveMessageState());
  // }
  //
  // void addUser() {
  //   UserModel user = UserModel(
  //     name: nameController.text,
  //     email: emailController.text,
  //   );
  // }

// try {
// UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
// email:emailController.text,
// password:passwordController.text,
// );
// emit(ChatRegisterSuccess());
// const snackBar = SnackBar(
// content: Text('Registered Successfully'),
// backgroundColor: Colors.green,
// );
// } on FirebaseAuthException catch (e) {
// if (e.code == 'weak-password')
// {
// const snackBar = SnackBar(
// content: Text('The password provided is too weak.'),
// backgroundColor: Colors.blueGrey,
// );
// emit(ChatRegisterError());
// }
// else if (e.code == 'email-already-in-use')
// {
// const snackBar = SnackBar(
// content: Text('The account already exists for that email.'),
// backgroundColor: Colors.blueGrey,
// );
// emit(ChatRegisterError());
// }
// }
