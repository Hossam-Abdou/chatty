import 'package:flutter/material.dart';

class HandleMessageLongPress extends StatelessWidget {
VoidCallback? editMessage;
VoidCallback? deleteMessage;
HandleMessageLongPress({required this.editMessage,required this.deleteMessage,});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text('Edit'),
            onTap: editMessage,
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete'),
            onTap: deleteMessage,
          ),
        ],
      ),
    );
  }
}
