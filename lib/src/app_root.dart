import 'package:chatty/core/utils/app_colors.dart';
import 'package:chatty/features/auth/view/login_screen.dart';
import 'package:chatty/features/auth/view_model/auth_cubit.dart';
import 'package:chatty/features/home/view/home_screen.dart';
import 'package:chatty/features/home/view_model/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoot extends StatelessWidget {
  bool? loggedIn;

  AppRoot({super.key, this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => ChatCubit(),
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                    cursorColor: Colors.blue,
                    selectionHandleColor: Colors.blue),
                indicatorColor: AppColors.primaryColor),
            home:
                loggedIn ?? false ? const HomeScreen() : const LoginScreen()));
  }
}
