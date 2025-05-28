import 'package:chatty/core/utils/app_colors.dart';
import 'package:chatty/core/utils/components/custom_textfield.dart';
import 'package:chatty/features/auth/widgets/custom_button.dart';
import 'package:chatty/features/home/view/home_screen.dart';
import '../view_model/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is ChatRegisterSuccess) {
          // Show SnackBar first
          const snackBar = SnackBar(
            content: Text('Registered Successfully'),
            backgroundColor: Colors.green,
            duration: Durations.extralong4,

          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          // Navigate after a short delay to ensure the SnackBar is visible

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  const HomeScreen()),
          );
        }
        if (state is ChatRegisterError) {
          var snackBar = SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.redAccent,
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
                      child:  Image(
                        image: const AssetImage('images/add-user.png'),
                        width: MediaQuery.sizeOf(context).width*0.21,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text('Create an account', style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 20,),

                    CustomTextField(
                      label: 'UserName',
                      controller: cubit.nameController,
                    ),
                    CustomTextField(
                      label: 'E-mail',
                      controller: cubit.emailController,
                    ),
                    CustomTextField(
                      label: 'Password',
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
                    const SizedBox(height: 15,),
                    CustomButton(
                      title: 'Sign up',
                      condition: state is! ChatRegisterLoading,
                      onPressed:  () {
                        cubit.signUp();
                      },
                    ),
                    // AnimatedConditionalBuilder(
                    //   condition: state is! ChatRegisterLoading,
                    //   fallback: (context) =>  const CircularProgressIndicator(
                    //     color: Color(0xff2FC2FF),
                    //   ),
                    //   builder: (BuildContext context) {
                    //     return   Material(
                    //       color: const Color(0xff2FC2FF),
                    //       borderRadius: BorderRadius.circular(30),
                    //       child: InkWell(
                    //         onTap: () {
                    //           cubit.signUp();
                    //         },
                    //         child: Container(
                    //           width: MediaQuery.sizeOf(context).width*0.3,
                    //           height: MediaQuery.sizeOf(context).height*0.05,
                    //           alignment: Alignment.center,
                    //           child: const Text(
                    //             'Register',
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.bold),
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Have An Account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                              cubit.emailController.clear();
                              cubit.passwordController.clear();
                            },
                            child: const Text(
                              'Login Now',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
