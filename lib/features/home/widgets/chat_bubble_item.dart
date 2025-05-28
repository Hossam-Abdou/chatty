import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubbleItem extends StatelessWidget {
  final Stream<QuerySnapshot> messages;
  final String currentUserUid;
  final Function(String messageId) onLongPress; // Callback for long press

  const ChatBubbleItem({super.key, 
    required this.messages,
    required this.currentUserUid,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: messages,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isMe = message['senderUid'] == currentUserUid;
              String messageTime = '';
              if (message['timestamp'] != null) {
                try {
                  final timestamp = message['timestamp'] as Timestamp;
                  messageTime = DateFormat('h:mm a').format(timestamp.toDate());
                } catch (e) {
                  // print('Error parsing timestamp: $e');
                }
              }

              return GestureDetector(
                onLongPress: isMe ? () => onLongPress(message.id) : null,

                child: Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                      minWidth: 0.1,
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[600] : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(23),
                        topRight: const Radius.circular(23),
                        bottomLeft: Radius.circular(isMe ? 23 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 23),
                      ),
                      boxShadow: [
                        if (isMe)
                          BoxShadow(
                            color: Colors.blue[600]!.withOpacity(0.5),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            message['text'],
                            maxLines: null,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (message['isEdited'] == true)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              '(edited)',
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          messageTime,
                          style: TextStyle(
                            color: isMe
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey[600],
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (isMe)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: _getStatusIcon(
                                'delivered'), // Pass the dynamic status
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return Tooltip(
          message: 'Sent',
          child: Icon(
            Icons.check,
            size: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        );
      case 'delivered':
        return Tooltip(
          message: 'Delivered',
          child: Icon(
            Icons.done_all_outlined,
            size: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        );
      case 'seen':
        return const Tooltip(
          message: 'Seen',
          child: Icon(
            Icons.done_all,
            size: 14,
            color: Colors.greenAccent,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
