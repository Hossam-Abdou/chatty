import 'package:flutter/material.dart';

class EditMessageDialog extends StatelessWidget {
final String currentText;

EditMessageDialog({required this.currentText});

  @override
Widget build(BuildContext context) {
  final TextEditingController controller = TextEditingController(text: currentText);

  return AlertDialog(
  title: const Text('Edit Message'),
  content: TextField(
    controller: controller,
    maxLines: null, // Allow multi-line input
    // maxLength: 500, // Optional: Limit input length
    decoration: InputDecoration(
      hintText: 'Enter new message',
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
    style: const TextStyle(fontSize: 16),
  ),
  actions: [
    TextButton(
      onPressed: () {
        Navigator.pop(context); // Cancel editing
      },
      child: const Text(
        'Cancel',
        style: TextStyle(color: Colors.grey),
      ),
    ),
    ElevatedButton(
      onPressed: () {
        if (controller.text.trim().isNotEmpty) {
          Navigator.pop(context, controller.text); // Return the new text
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        'Save',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ],
);
}
}
