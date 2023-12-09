import 'package:buecherkreisel_flutter/backend/UserAPI.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRegisterScreen extends StatefulWidget {
  UserAPI userAPI = UserAPI();
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
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
                _isLogin ? 'Login' : 'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: usernameValidator,
                controller: _usernameController,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                validator: passwordValidator,
                controller: _passwordController,
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text(
                  _isLogin ? 'Login' : 'Register',
                  //style: TextStyle(
                  //    color: !_passwordOk || !_usernameOK
                  //        ? Colors.black38
                  //        : Colors.black),
                ),
                onPressed: () async {
                  //if (!_passwordOk || !_usernameOK) return;
                  if (!_isLogin) {
                    try {
                      state.setUser(await widget.userAPI.createUser(
                          _usernameController.text, _passwordController.text));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Registration Failed"),
                        ),
                      );
                    }
                  } else {
                    try {
                      state.setUser(await widget.userAPI.loginUser(
                          _usernameController.text, _passwordController.text));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login Failed"),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 20),
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
