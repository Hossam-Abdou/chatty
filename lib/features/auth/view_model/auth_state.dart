part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class ChangeObscureTextState extends AuthState {}

class ChatRegisterLoading extends AuthState {}
class ChatRegisterSuccess extends AuthState {}
class ChatRegisterError extends AuthState {
  String error;

  ChatRegisterError({required this.error});
}

class ChatLoginloading extends AuthState {}
class ChatLoginSuccess extends AuthState {}
class ChatLoginError   extends AuthState {
  String error;

  ChatLoginError({required this.error});
}

class ChatSendSuccess extends AuthState{}
class ChatSendError extends AuthState{}

class ChatReceiveMessageState extends AuthState{}
class GetUsersState extends AuthState{}
class ChatCreateUserloading extends AuthState{}

