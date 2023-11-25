import 'user.dart';
import 'message.dart';

class Chat {
  user_id person;
  List<Message> messages;
  String imageUri;
  Chat({required this.person, required this.messages, required this.imageUri});
}
