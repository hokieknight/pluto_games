import 'package:flutter/material.dart';
import 'package:pluto_games/widgets/my_textfield.dart';
import 'package:pluto_games/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    Navigator.pushNamed(context, MainScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    //_socketMethods.loginSuccessListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pluto Games'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.lock,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 30),
            MyTextField(
              hintText: 'Email',
              controller: usernameController,
            ),
            const SizedBox(height: 30),
            MyTextField(
              hintText: 'Password',
              controller: passwordController,
              obscureText: true,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Forgot Password'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: login,
              child: const Text("Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}
