part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}
class SearchFieldChangedState extends ChatState {}

class ChatRegisterloading extends ChatState {}
class ChatRegisterSuccess extends ChatState {}
class ChatRegisterError   extends ChatState {
  String error;

  ChatRegisterError({required this.error});
}

class ChatLoginloading extends ChatState {}
class ChatLoginSuccess extends ChatState {}
class ChatLoginError   extends ChatState {
  String error;

  ChatLoginError({required this.error});
}

class ChatSendSuccess extends ChatState{}
class ChatSendError extends ChatState{}

class ChatReceiveMessageState extends ChatState{}
class GetUsersState extends ChatState{}
class ChatCreateUserloading extends ChatState{}

