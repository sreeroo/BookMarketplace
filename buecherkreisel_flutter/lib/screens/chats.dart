import 'package:buecherkreisel_flutter/components/chat_preview.dart';
import 'package:flutter/material.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: sampleDataChats.length,
        itemBuilder: (c, index) => ChatPreview(
          lastMessage: sampleDataChats[index].messages.last,
          chatWith: sampleDataChats[index].person,
          imageUri: "",
        ),
      ),
    );
  }
}
