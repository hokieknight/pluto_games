import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pluto Games'),
        leading: Image.asset('images/my-pluto-2.png'),
      ),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}
