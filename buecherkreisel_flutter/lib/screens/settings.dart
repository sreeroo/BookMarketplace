import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/components/account.dart';
import 'package:buecherkreisel_flutter/components/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (b, state, w) {
        return state.user.token.isEmpty
            ? LoginRegisterScreen()
            : ProfileScreen();
      },
    );
  }
}
