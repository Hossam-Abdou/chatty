import 'package:chatty/core/utils/app_colors.dart';
import 'package:chatty/core/utils/components/custom_textfield.dart';
import 'package:chatty/features/auth/view/register_screen.dart';
import 'package:chatty/features/auth/widgets/custom_button.dart';
import 'package:chatty/features/home/view/home_screen.dart';
import '../view_model/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is ChatLoginSuccess) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
          const snackBar = SnackBar(
            content: Text('Login Successfully'),
            backgroundColor: Colors.green,
            duration: Durations.extralong4,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (state is ChatLoginError) {
          SnackBar snackBar = SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.red,
            duration: Durations.extralong4,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height*0.06,),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: const AssetImage(
                            'images/chat.png',
                          ),
                          width: MediaQuery.sizeOf(context).width*0.21,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Please enter your data to login',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        label: 'E-mail',
                        hintText: 'hossam@mail.com',
                        controller: cubit.emailController,
                      ),
                      CustomTextField(
                        counterText: 'Forget Password ? ',
                        label: 'Password',
                        hintText: '* * * * * * *',
                        isPassword: cubit.isVisible,
                        controller: cubit.passwordController,
                        suffixIcon: cubit.isVisible
                            ? Icons.visibility
                            : Icons.remove_red_eye_outlined,
                        suffixIconOnPress: () {
                          cubit.changeObscureText();
                          // print(cubit.isVisible);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomButton(
                        title: 'Login',
                        condition: state is! ChatLoginloading,
                        onPressed:  () {
                          cubit.Login();
                        },
                      ),
                      // AnimatedConditionalBuilder(
                      //   condition: state is! ChatLoginloading,
                      //   fallback: (context) => const CircularProgressIndicator(
                      //     color: AppColors.secondaryColor,
                      //   ),
                      //   builder: (BuildContext context) {
                      //     return Material(
                      //       color: AppColors.secondaryColor,
                      //       borderRadius: BorderRadius.circular(30),
                      //       child: InkWell(
                      //         onTap: () {
                      //           cubit.Login();
                      //         },
                      //         child: Container(
                      //           width: MediaQuery.sizeOf(context).width * 0.3,
                      //           height:
                      //               MediaQuery.sizeOf(context).height * 0.05,
                      //           alignment: Alignment.center,
                      //           child: const Text(
                      //             'Login',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 18,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      const SizedBox(height: 16,),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: Row(
                      //     children: [
                      //       Expanded(child: Divider(color: Colors.grey,)),
                      //       Text('   OR   ',style: TextStyle(color: Colors.grey),),
                      //       Expanded(child: Divider(color: Colors.grey,)),
                      //     ],
                      //   ),
                      // ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t Have An Account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                              onPressed: () {
                                cubit.emailController.clear();
                                cubit.passwordController.clear();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ));
                              },
                              child: const Text(
                                'Register Now',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
