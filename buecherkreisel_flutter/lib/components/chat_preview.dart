import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:flutter/material.dart';

class ChatPreview extends StatelessWidget {
  late Message lastMessage;
  late String chatWith;
  late String imageUri;
  ChatPreview(
      {super.key,
      required this.lastMessage,
      required this.chatWith,
      required this.imageUri});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage("lib/assets/6NyIq.jpg"),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chatWith),
                  Text(
                    lastMessage.message,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Text(lastMessage.send.toIso8601String().split("T").first),
        ],
      ),
    );
  }
}

List<Chat> sampleDataChats = [
  Chat(messages: [
    Message(
      send: DateTime.now(),
      message: "Hey, hast du die Vorlesungsunterlagen?",
      sendBy: "Tina Schmidt",
    )
  ], person: "Tina Schmidt", imageUri: ""),
  Chat(messages: [
    Message(
      send: DateTime.now(),
      message: "Ich habe ein Problem bei der Registrierung",
      sendBy: "David Becker",
    )
  ], person: "David Becker", imageUri: ""),
  Chat(messages: [
    Message(
      send: DateTime.now(),
      message: "Kannst du mir bei meinem Projekt helfen?",
      sendBy: "Julia Wagner",
    )
  ], person: "Julia Wagner", imageUri: ""),
  Chat(messages: [
    Message(
      send: DateTime.now(),
      message: "Wann findet die nächste Veranstaltung statt?",
      sendBy: "Markus Fischer",
    )
  ], person: "Markus Fischer", imageUri: ""),
  Chat(messages: [
    Message(
      send: DateTime.now(),
      message: "Hast du die Prüfungsergebnisse schon erhalten?",
      sendBy: "Laura Peters",
    )
  ], person: "Laura Peters", imageUri: ""),
  Chat(messages: [
    Message(
      send: DateTime.now(),
      message: "Ich habe mich für das Praktikum angemeldet",
      sendBy: "Maximilian Klein",
    )
  ], person: "Maximilian Klein", imageUri: "")
];
