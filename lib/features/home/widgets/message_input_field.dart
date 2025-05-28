import 'package:flutter/material.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21,vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(

                      controller: controller,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: InputBorder.none,
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.black26,
                        )
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        controller.text = controller.text.trim();

                        onSend();
                      }
                    },
                    icon:  Icon(Icons.send, color: Colors.blue[600],),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
