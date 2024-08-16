import 'package:flutter/material.dart';
import 'package:minesweeper/bomb.dart';
import 'package:minesweeper/number_box.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //variables
  static const int numberOfSquares = 9 * 9;
  static const int numberInEachRow = 9;

  //[(num of bombs around, are they revealed)]
  final List<({int numOfBombsAround, bool isRevealed})> squareStatus = [];

  // bomb locations
  final List<int> bombLocation = [4, 36, 37, 38, 39, 40, 41, 61];

  bool bombsRevealed = false;

  @override
  void initState() {
    //initially each square has 0 bombs and is unrevealed
    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add((numOfBombsAround: 0, isRevealed: false));
    }

    scanBombs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          //game stats and menu
          SizedBox(
            height: 150 + MediaQuery.of(context).padding.top,
            // color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //display number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bombLocation.length.toString(),
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
                crossAxisCount: numberInEachRow,
              ),
              itemCount: numberOfSquares,
              itemBuilder: (BuildContext context, int index) {
                if (bombLocation.contains(index)) {
                  return Bomb(
                    revealed: bombsRevealed,
                    onTap: () {
                      //if user tapped bomb he loses
                      setState(() {
                        bombsRevealed = true;
                      });
                      playerLost();
                    },
                  );
                } else {
                  return NumberBox(
                    child: (squareStatus[index].numOfBombsAround).toString(),
                    revealed: squareStatus[index].isRevealed,
                    onTap: () {
                      //reveal current box
                      revealBox(index);
                      checkWinner();
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

  void revealBox(int index) {
    //reveal current box if it is 1,2,3
    if (squareStatus[index].numOfBombsAround > 0) {
      setState(() {
        // Create a new record with the updated value
        squareStatus[index] = (
          numOfBombsAround: squareStatus[index].numOfBombsAround,
          isRevealed: true
        );
      });
    } else {
      //reveal current box, and the 8 surrounding boxes unless you are on a wall

      final isNotFirstColumn = index % numberInEachRow != 0;
      final isNotLastColumn = index % numberInEachRow != numberInEachRow - 1;
      final isNotFirstRow = index >= numberInEachRow;
      final isNotLastRow = !((index >= numberOfSquares - numberInEachRow) &&
          (index <= numberOfSquares - 1));

      setState(() {
        //reveal current box
        squareStatus[index] = (
          numOfBombsAround: squareStatus[index].numOfBombsAround,
          isRevealed: true
        );

        //revealing left side boxes
        if (isNotFirstColumn) {
          // if this next (left) box isn't revealed yet and it is a 0, recurse
          final indexToCheck = index - 1;
          if (squareStatus[indexToCheck].numOfBombsAround == 0 &&
              squareStatus[indexToCheck].isRevealed == false) {
            revealBox(indexToCheck);
          }

          // reveal left box
          squareStatus[indexToCheck] = (
            numOfBombsAround: squareStatus[indexToCheck].numOfBombsAround,
            isRevealed: true
          );
        }

        // revelaing top left boxes, unless we are on top or leftmost wall
        if (isNotFirstColumn && isNotFirstRow) {
          //if top left box isn't revealed and is a 0
          final indexToCheck = index - 1 - numberInEachRow;
          if (squareStatus[indexToCheck].numOfBombsAround == 0 &&
              squareStatus[indexToCheck].isRevealed == false) {
            //recurse
            revealBox(indexToCheck);
          }

          squareStatus[indexToCheck] = (
            numOfBombsAround: squareStatus[indexToCheck].numOfBombsAround,
            isRevealed: true
          );
        }

        // revealing top boxes, unless we are on top row
        if (isNotFirstRow) {
          final indexToCheck = index - numberInEachRow;
          if (squareStatus[indexToCheck].numOfBombsAround == 0 &&
              squareStatus[indexToCheck].isRevealed == false) {
            //recurse
            revealBox(indexToCheck);
          }

          squareStatus[indexToCheck] = (
            numOfBombsAround: squareStatus[indexToCheck].numOfBombsAround,
            isRevealed: true
          );
        }

        // revealing top right boxes, unless we are on top row or last column
        if (isNotFirstRow && isNotLastColumn) {
          final indexToCheck = index - numberInEachRow + 1;

          if (squareStatus[indexToCheck].numOfBombsAround == 0 &&
              squareStatus[indexToCheck].isRevealed == false) {
            //recurse
            revealBox(indexToCheck);
          }

          squareStatus[indexToCheck] = (
            numOfBombsAround: squareStatus[indexToCheck].numOfBombsAround,
            isRevealed: true
          );
        }

        // revealing right boxes, unless we are on last column
        if (isNotLastColumn) {
          final indexToCheck = index + 1;
          if (squareStatus[indexToCheck].numOfBombsAround == 0 &&
              squareStatus[indexToCheck].isRevealed == false) {
            //recurse
            revealBox(indexToCheck);
          }

          squareStatus[indexToCheck] = (
            numOfBombsAround: squareStatus[indexToCheck].numOfBombsAround,
            isRevealed: true
          );
        }

        //! revealing bottom right boxes, unless we are on last column or last row
        if (isNotLastColumn && isNotLastRow) {
          final indexToCheck = index + 1 + numberInEachRow;
          if (squareStatus[indexToCheck].numOfBombsAround == 0 &&
              squareStatus[indexToCheck].isRevealed == false) {
            //recurse
            revealBox(indexToCheck);
          }

          squareStatus[indexToCheck] = (
            numOfBombsAround: squareStatus[indexToCheck].numOfBombsAround,
            isRevealed: true
          );
        }

        // revealing bottom boxes, unless we are on last row
        if (isNotLastRow) {
          final indexToCheck = index + numberInEachRow;

          if (squareStatus[indexToCheck].numOfBombsAround == 0 &&
              squareStatus[indexToCheck].isRevealed == false) {
            //recurse
            revealBox(indexToCheck);
          }

          squareStatus[indexToCheck] = (
            numOfBombsAround: squareStatus[indexToCheck].numOfBombsAround,
            isRevealed: true
          );
        }

        // revealing bottom left boxes, unless we are on last row or first column
        if (isNotFirstColumn && isNotLastRow) {
          final indexToCheck = index - 1 + numberInEachRow;

          if (squareStatus[indexToCheck].numOfBombsAround == 0 &&
              squareStatus[indexToCheck].isRevealed == false) {
            //recurse
            revealBox(indexToCheck);
          }

          squareStatus[indexToCheck] = (
            numOfBombsAround: squareStatus[indexToCheck].numOfBombsAround,
            isRevealed: true
          );
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      //there are no bombs around initially = 0
      int numberOfBombsAround = 0;

      /*
      check each square if there is a bomb surrounding it
      there are 8 surrounding boxes to check
      */
      final numberNotInFirstColumn = i % numberInEachRow != 0;
      final numberNotInLastColum = (i + 1) % numberInEachRow != 0;
      final numberNotInFirstRow = i >= numberInEachRow;
      final numberNotInLastRow = !(i >= (numberOfSquares - numberInEachRow) &&
          i <= (numberOfSquares - 1));

      // check square to left, unless it is the first column
      if (numberNotInFirstColumn && bombLocation.contains(i - 1)) {
        numberOfBombsAround++;
      }

      // check square top-left, unless it is the first column or in first row
      // from current index -1 (to move a column back) -num in each row to move a ro up
      if (numberNotInFirstColumn &&
          numberNotInFirstRow &&
          bombLocation.contains(i - 1 - numberInEachRow)) {
        numberOfBombsAround++;
      }

      // check top square, unless in first row
      if (i >= numberInEachRow && bombLocation.contains(i - numberInEachRow)) {
        numberOfBombsAround++;
      }

      // check top right square, unless in first row and last column
      // from current index +1 (to move a column forward) -num in each row to move a ro up
      if (numberNotInLastColum &&
          numberNotInFirstRow &&
          bombLocation.contains(i + 1 - numberInEachRow)) {
        numberOfBombsAround++;
      }

      // check right square, unless we are on last column
      if (numberNotInLastColum && bombLocation.contains(i + 1)) {
        numberOfBombsAround++;
      }

      //check bottom right square unless, we are in last colum and last row
      if (numberNotInLastColum &&
          numberNotInLastRow &&
          bombLocation.contains(i + 1 + numberInEachRow)) {
        numberOfBombsAround++;
      }

      // check bottom square unless we are in last row
      if (numberNotInLastRow && bombLocation.contains(i + numberInEachRow)) {
        numberOfBombsAround++;
      }

      // check bottom left , unless we are in last row and first column
      if (numberNotInFirstColumn &&
          numberNotInLastRow &&
          bombLocation.contains(i - 1 + numberInEachRow)) {
        numberOfBombsAround++;
      }

      setState(() {
        squareStatus[i] = (
          numOfBombsAround: numberOfBombsAround,
          isRevealed: squareStatus[i].isRevealed,
        );
      });
    }
  }

  void restartGame() {
    setState(() {
      bombsRevealed = false;
      for (var i = 0; i < numberOfSquares; i++) {
        squareStatus[i] = (
          numOfBombsAround: squareStatus[i].numOfBombsAround,
          isRevealed: false
        );
      }
    });
  }

  void playerLost() {
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

  void playerWon(){
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

  void checkWinner(){
    //check how many boxes yet to be revealed
    int boxesYetToBeRevealed = 0;

    for (var i = 0; i < numberOfSquares; i++) {
      if(squareStatus[i].isRevealed == false){
        boxesYetToBeRevealed++;
      }
    }

    if(boxesYetToBeRevealed == bombLocation.length){
      playerWon();
    }
  }
}
