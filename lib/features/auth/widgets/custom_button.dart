import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
String title;
bool condition;
VoidCallback? onPressed;

CustomButton({super.key, required this.title, required this.condition, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  AnimatedConditionalBuilder(
      condition: condition,
      fallback: (context) => const CircularProgressIndicator(
        color: AppColors.secondaryColor,
      ),
      builder: (BuildContext context) {
        return Material(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: title == 'Login' ? MediaQuery.sizeOf(context).width * 0.3 : MediaQuery.sizeOf(context).width * 0.4,
              height:
              MediaQuery.sizeOf(context).height * 0.05,
              alignment: Alignment.center,
              child:  Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
