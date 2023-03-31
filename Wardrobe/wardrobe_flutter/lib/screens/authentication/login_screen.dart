import 'package:flutter/foundation.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_flutter/services/api.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void login() async {
    try {
      if (await ApiService.login(
          _usernameController.text, _passwordController.text)) {
        _btnController.success();
        await SharedPreferences.getInstance().then((value) => {
              value.setBool('isLoggedIn', true),
              Navigator.pushReplacementNamed(context, '/wardrobes')
            });
      } else {
        setState(() {
          _btnController.reset();
        });
      }
    } catch (e) {
      setState(() {
        _btnController.error();
      });
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) => _btnController.reset(),
            ),
            TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              onChanged: (value) => _btnController.reset(),
              onSubmitted: (value) => login(),
            ),
            _btnController.currentState == ButtonState.error
                ? const Text('Invalid email or password')
                : Container(),
            RoundedLoadingButton(
              controller: _btnController,
              onPressed: () {
                login();
              },
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
            // MaterialButton(
            //   onPressed: () async {
            //     Future result = appwriteAccount.createOAuth2Session(
            //       provider: 'google',
            //       success: 'https://appwrite.skyface.de/oauth/google/success',
            //     );

            //     result.then((response) {
            //       print(response);
            //     }).catchError(
            //       (error) {
            //         print(error.response);
            //       },
            //     );
            //   },
            //   child: Text('Login with Google'),
            // )
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(fontSize: 25.0),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    ' Sign Up',
                    style: TextStyle(fontSize: 25.0, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
