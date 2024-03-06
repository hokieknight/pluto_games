import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/providers/game_user_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late GameUser _gameUser;
  //String _enteredNickname = '';

  void _saveSettings() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    ref.read(gameUserProvider.notifier).setUser(_gameUser);
    //_saveSettingsRemote(_gameUser);
    _gameUser.saveRemote();

    Navigator.of(context).pop();
  }

  // Future<void> _saveSettingsRemote(GameUser gameUser) async {
  //   //final gameUser = ref.watch(gameUserProvider);
  //   await FirebaseFirestore.instance
  //       .collection('game_users')
  //       .doc(gameUser.uid)
  //       .set({
  //     'email': gameUser.email,
  //     'nickname': gameUser.nickname,
  //     'image_url': gameUser.imageUrl,
  //   });
  //}

  @override
  Widget build(BuildContext context) {
    _gameUser = ref.watch(gameUserProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pluto Games - Settings'),
      ),
      body: Center(
        //padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.settings,
                size: 50,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('UserID: ${_gameUser.uid}'),
                          Text('Email: ${_gameUser.email}'),
                          TextFormField(
                            initialValue: _gameUser.nickname,
                            decoration: const InputDecoration(
                              labelText: 'Nickname',
                            ),
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter valied nickname';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _gameUser.nickname = value!;
                            },
                          ),
                          Text('Image URL: ${_gameUser.imageUrl}'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: _saveSettings,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
