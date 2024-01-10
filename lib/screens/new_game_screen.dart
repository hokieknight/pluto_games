import 'package:flutter/material.dart';

enum GameTypes { tictactoe, secretsith, uno, poker }

const gameTypeNames = {
  GameTypes.poker: 'Poker',
  GameTypes.secretsith: 'Secret Sith',
  GameTypes.tictactoe: 'Tic-Tac-Toe',
  GameTypes.uno: 'Uno',
};

class NewGameScreen extends StatefulWidget {
  static String routeName = '/new-game';

  const NewGameScreen({super.key});

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  final _nameController = TextEditingController();
  GameTypes _selectedGameType = GameTypes.tictactoe;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createGame() {
    if (_nameController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter valid name'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Nickname'),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButton(
              value: _selectedGameType,
              items: GameTypes.values
                  .map(
                    (gameType) => DropdownMenuItem(
                      value: gameType,
                      child: Text(
                        gameTypeNames[gameType]!,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedGameType = value;
                });
              }),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _createGame,
                child: const Text('Create Game'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
