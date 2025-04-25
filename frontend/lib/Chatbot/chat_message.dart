import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool transparent;            // for avatar-mode transparency
  final List<String> options;
  final void Function(String)? onOptionSelected;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isUser,
    this.transparent = false,
    this.options = const [],
    this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bubble color
    final bubbleColor = isUser
        ? Theme.of(context).primaryColor
        : (transparent
            ? Colors.white.withOpacity(0.6)
            : Theme.of(context).cardColor);

    final textColor = isUser
        ? Colors.white
        : Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
            const SizedBox(width: 8.0),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(color: textColor),
                  ),
                ),
                if (!isUser && options.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: options
                          .map(
                            (option) => ElevatedButton(
                              onPressed: () => onOptionSelected?.call(option),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              child: Text(option),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8.0),
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
