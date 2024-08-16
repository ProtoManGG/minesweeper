import 'package:flutter/material.dart';
import 'package:minesweeper/bomb.dart';
import 'package:minesweeper/number_box.dart';
import 'game_logic.dart'; // Import the new GameLogic class

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GameLogic gameLogic = GameLogic(); // Create an instance of GameLogic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // UI code for displaying game stats and menu
          SizedBox(
            height: 150 + MediaQuery.of(context).padding.top,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //display number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gameLogic.bombLocation.length.toString(),
                      style: const TextStyle(fontSize: 40),
                    ),
                    const Text('B O M B'),
                  ],
                ),

                // button to refresh the game
                Card(
                  color: Colors.grey[700],
                  child: IconButton(
                    onPressed: () {
                      restartGame();
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),

                //display time taken
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '0',
                      style: TextStyle(fontSize: 40),
                    ),
                    Text('T I M E'),
                  ],
                )
              ],
            ),
          ),

          //grid
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: GameLogic.numberInEachRow,
              ),
              itemCount: GameLogic.numberOfSquares,
              itemBuilder: (BuildContext context, int index) {
                if (gameLogic.isBomb(index)) {
                  return Bomb(
                    revealed: gameLogic.bombsRevealed,
                    onTap: () {
                      setState(() {
                        gameLogic.bombsRevealed = true;
                        gameLogic.playerLost(context, restartGame);
                      });
                      // Handle bomb tap
                    },
                  );
                } else {
                  return NumberBox(
                    child: (gameLogic.squareStatus[index]['numOfBombsAround'])
                        .toString(),
                    revealed: gameLogic.squareStatus[index]['isRevealed'],
                    onTap: () {
                      setState(() {
                        gameLogic.revealBox(index);
                        gameLogic.checkWinner(context, restartGame);
                      });
                      // Check winner logic
                    },
                  );
                }
              },
            ),
          ),

          //branding
          const Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Text(
              'C R E A T E D   B Y   P T',
            ),
          )
        ],
      ),
    );
  }

  void restartGame() {
    setState(() {
      gameLogic.restartGame();
    });
  }
}
