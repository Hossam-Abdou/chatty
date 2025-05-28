import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool isPassword;
  late final bool isVisible;
  final IconData? suffixIcon;
  final VoidCallback? suffixIconOnPress;
  final TextEditingController controller;
  String? counterText;

  CustomTextField({super.key, 
    required this.label,
    this.hintText,
    this.counterText,
    this.suffixIcon,
    this.isPassword = false,
    this.suffixIconOnPress,
    required this.controller,
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0,right: 30, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
              counterText == null ? const SizedBox.shrink() : Text(
                counterText!,
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(

            cursorColor: const Color(0xff2FC2FF),
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 21),
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: Color(0xff2FC2FF), width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: hintText ?? label,

                // labelText: label,
                // labelStyle: const TextStyle(color:d),
                hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                ),
                suffixIcon: IconButton(
                  onPressed: suffixIconOnPress,
                  icon: Icon(suffixIcon),
                )),
          ),
        ],
      ),
    );
  }
}
