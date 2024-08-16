import 'package:flutter/material.dart';

class GameLogic {
  static const int numberOfSquares = 9 * 9;
  static const int numberInEachRow = 9;

  final List<Map<String, dynamic>> squareStatus = [];
  final List<int> bombLocation = [4, 36, 37, 38, 39, 40, 41, 61];
  bool bombsRevealed = false;

  GameLogic() {
    initializeGame();
  }

  void initializeGame() {
    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add({'numOfBombsAround': 0, 'isRevealed': false});
    }
    scanBombs();
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      int numberOfBombsAround = 0;

      // Check surrounding squares for bombs
      final bool isNotFirstColumn = i % numberInEachRow != 0;
      final bool isNotLastColumn = (i + 1) % numberInEachRow != 0;
      final bool isNotFirstRow = i >= numberInEachRow;
      final bool isNotLastRow = !(i >= (numberOfSquares - numberInEachRow) &&
          i <= (numberOfSquares - 1));

      // Check each surrounding square
      if (isNotFirstColumn && bombLocation.contains(i - 1)) {
        numberOfBombsAround++;
      }
      if (isNotFirstColumn &&
          isNotFirstRow &&
          bombLocation.contains(i - 1 - numberInEachRow)) numberOfBombsAround++;
      if (isNotFirstRow && bombLocation.contains(i - numberInEachRow)) {
        numberOfBombsAround++;
      }
      if (isNotLastColumn &&
          isNotFirstRow &&
          bombLocation.contains(i + 1 - numberInEachRow)) numberOfBombsAround++;
      if (isNotLastColumn && bombLocation.contains(i + 1)) {
        numberOfBombsAround++;
      }
      if (isNotLastColumn &&
          isNotLastRow &&
          bombLocation.contains(i + 1 + numberInEachRow)) numberOfBombsAround++;
      if (isNotLastRow && bombLocation.contains(i + numberInEachRow)) {
        numberOfBombsAround++;
      }
      if (isNotFirstColumn &&
          isNotLastRow &&
          bombLocation.contains(i - 1 + numberInEachRow)) numberOfBombsAround++;

      squareStatus[i] = {
        'numOfBombsAround': numberOfBombsAround,
        'isRevealed': squareStatus[i]['isRevealed']
      };
    }
  }

  void revealBox(int index) {
    if (squareStatus[index]['numOfBombsAround'] > 0) {
      squareStatus[index] = {
        'numOfBombsAround': squareStatus[index]['numOfBombsAround'],
        'isRevealed': true
      };
    } else {
      // Logic to reveal surrounding boxes
      revealSurroundingBoxes(index);
    }
  }

  void revealSurroundingBoxes(int index) {
    // Check if the box is already revealed
    if (squareStatus[index]['isRevealed']) return;

    // Reveal the current box
    squareStatus[index] = {
      'numOfBombsAround': squareStatus[index]['numOfBombsAround'],
      'isRevealed': true
    };

    // If there are bombs around, do not reveal surrounding boxes
    if (squareStatus[index]['numOfBombsAround'] > 0) return;

    // Determine the surrounding indices
    final bool isNotFirstColumn = index % numberInEachRow != 0;
    final bool isNotLastColumn = (index + 1) % numberInEachRow != 0;
    final bool isNotFirstRow = index >= numberInEachRow;
    final bool isNotLastRow = !(index >= (numberOfSquares - numberInEachRow) &&
        index <= (numberOfSquares - 1));

    // Reveal surrounding boxes recursively
    if (isNotFirstColumn) revealSurroundingBoxes(index - 1); // Left
    if (isNotLastColumn) revealSurroundingBoxes(index + 1); // Right
    if (isNotFirstRow) revealSurroundingBoxes(index - numberInEachRow); // Top
    if (isNotLastRow) revealSurroundingBoxes(index + numberInEachRow); // Bottom
    if (isNotFirstColumn && isNotFirstRow) {
      revealSurroundingBoxes(index - 1 - numberInEachRow); // Top Left
    }
    if (isNotLastColumn && isNotFirstRow) {
      revealSurroundingBoxes(index + 1 - numberInEachRow); // Top Right
    }
    if (isNotFirstColumn && isNotLastRow) {
      revealSurroundingBoxes(index - 1 + numberInEachRow); // Bottom Left
    }
    if (isNotLastColumn && isNotLastRow) {
      revealSurroundingBoxes(index + 1 + numberInEachRow); // Bottom Right
    }
  }

  void restartGame() {
    bombsRevealed = false;
    for (var i = 0; i < numberOfSquares; i++) {
      squareStatus[i] = {
        'numOfBombsAround': squareStatus[i]['numOfBombsAround'],
        'isRevealed': false
      };
    }
    initializeGame();
  }

  bool isBomb(int index) {
    return bombLocation.contains(index);
  }

  void playerLost(BuildContext context, VoidCallback restartGame) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: const Text(
            'YOU LOST!',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                restartGame();
                Navigator.pop(context);
              },
              child: const Icon(Icons.restart_alt),
            ),
          ],
        );
      },
    );
  }

  void playerWon(BuildContext context, VoidCallback restartGame) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: const Text(
            'YOU WON!',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                restartGame();
                Navigator.pop(context);
              },
              child: const Icon(Icons.restart_alt),
            ),
          ],
        );
      },
    );
  }

  void checkWinner(BuildContext context, VoidCallback restartGame) {
    //check how many boxes yet to be revealed
    int boxesYetToBeRevealed = 0;

    for (var i = 0; i < numberOfSquares; i++) {
      if (squareStatus[i]['isRevealed'] == false) {
        boxesYetToBeRevealed++;
      }
    }

    if (boxesYetToBeRevealed == bombLocation.length) {
      playerWon(context, restartGame);
    }
  }
}
