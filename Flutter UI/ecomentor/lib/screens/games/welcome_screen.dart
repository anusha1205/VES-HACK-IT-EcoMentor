import 'package:flutter/material.dart';
import 'models.dart';
import 'game_screen.dart';
import 'jumbled_screen.dart';
import 'waste_sorter/start_screen.dart';
import 'escape_room/escape_room.dart';
import '../challenges/challenges_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _player1Controller = TextEditingController(text: 'Player 1');
  final _player2Controller = TextEditingController(text: 'Player 2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Keeping the background clean and white
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),

            // Tagline
            Text(
              "Learn, Play & Save the Earth 🌱",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),

            SizedBox(height: 40),

            // Game Mode Selection
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Clustered Start Game Button (Single + Multiplayer)
                    _buildGameCard(
                      title: "EcoQuest",
                      icon: Icons.videogame_asset,
                      onTap: () => _showGameModeDialog(),
                    ),
                    SizedBox(height: 15),

                    // Jumbled Climate Words (Remains Separate)
                    _buildGameCard(
                      title: "EcoScramble",
                      icon: Icons.shuffle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JumbledClimateScreen(
                              player: Player(name: 'Player 1', avatar: '🦁'),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 15),
                    _buildGameCard(
                      title: "Waste Sorter",
                      icon: Icons.recycling,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>  WasteSorterApp(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 15),
                    _buildGameCard(
                      title: "Escape Room",
                      icon: Icons.room,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClimateEscapeGame(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Clustered Game Mode Selection Dialog
  void _showGameModeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Choose Game Mode',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Single Player Option
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF1E4B5F)),
              title: Text('Single Player'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(
                      players: [Player(name: 'Player 1', avatar: '🦁')],
                      isSinglePlayer: true,
                    ),
                  ),
                );
              },
            ),

            Divider(),

            // Multiplayer Option
            ListTile(
              leading: Icon(Icons.group, color: Color(0xFF1E4B5F)),
              title: Text('Multiplayer'),
              onTap: () {
                Navigator.pop(context);
                _showMultiplayerDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Multiplayer Player Name Input Dialog
  void _showMultiplayerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Enter Player Names',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPlayerTextField(
                _player1Controller, 'Player 1 Name', Icons.person),
            SizedBox(height: 10),
            _buildPlayerTextField(
                _player2Controller, 'Player 2 Name', Icons.person_outline),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                    players: [
                      Player(name: _player1Controller.text, avatar: '🦁'),
                      Player(name: _player2Controller.text, avatar: '🐯'),
                    ],
                    isSinglePlayer: false,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            child: Text('Start Game', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  // Card-style Buttons for Game Modes
  Widget _buildGameCard(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon,
                  size: 28, color: Color(0xFF1E4B5F)), // Updated icon color
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: Colors.grey.shade600, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // Styled Player Name Input Field
  Widget _buildPlayerTextField(
      TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
