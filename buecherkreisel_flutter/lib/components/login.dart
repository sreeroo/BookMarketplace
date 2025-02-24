import 'package:buecherkreisel_flutter/backend/UserAPI.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRegisterScreen extends StatefulWidget {
  UserAPI userAPI = UserAPI();
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _passwordOk = false;
  bool _usernameOK = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _usernameOK = false;
      });
      return 'Bitte gib einen Nutzernamen ein.';
    }
    setState(() {
      _usernameOK = true;
    });
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty || value.length < 6) {
      setState(() {
        _passwordOk = false;
      });
      return 'Bitte gib ein Passwort len>=6 ein.';
    }
    setState(() {
      _passwordOk = true;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (b, state, w) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? 'Anmelden' : 'Registrieren',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: usernameValidator,
                      controller: _usernameController,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Passwort',
                      ),
                      validator: passwordValidator,
                      controller: _passwordController,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: Text(
                  _isLogin ? 'Einloggen' : 'Registrieren',
                  //style: TextStyle(
                  //    color: !_passwordOk || !_usernameOK
                  //        ? Colors.black38
                  //        : Colors.black),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (!_isLogin) {
                      try {
                        state.setUser(await widget.userAPI.createUser(
                            _usernameController.text,
                            _passwordController.text));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Registrierung fehlgeschlagen, bereits registriert?"),
                            duration: Durations.long2,
                          ),
                        );
                      }
                    } else {
                      try {
                        state.setUser(await widget.userAPI.loginUser(
                            _usernameController.text,
                            _passwordController.text));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Login fehlgeschlagen, falsches Passwort/Username oder noch nicht registriert? "),
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Bitte füllen Sie alle Felder aus"),
                        duration: Durations.long1,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                child: Text(
                  _isLogin
                      ? 'Noch keinen Account? Registrieren'
                      : 'Bereits registriert? Einloggen',
                ),
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
