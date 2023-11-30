import 'package:flutter/material.dart';

class LoginRegisterScreen extends StatefulWidget {
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login/Register'),
      ),
      body: Center(
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
                labelText: 'Email',
              ),
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              child: Text(_isLogin ? 'Login' : 'Register'),
              onPressed: () {
                // Hier kannst du den Login- oder Registrierungsvorgang implementieren
              },
            ),
            SizedBox(height: 20),
            TextButton(
              child: Text(_isLogin
                  ? 'Noch keinen Account? Registrieren'
                  : 'Bereits registriert? Einloggen'),
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
