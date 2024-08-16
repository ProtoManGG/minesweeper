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
    // Logic to scan bombs and update squareStatus
  }

  void revealBox(int index) {
    // Logic to reveal a box
  }

  void restartGame() {
    // Logic to restart the game
  }

  bool isBomb(int index) {
    return bombLocation.contains(index);
  }

  // Other game-related methods...
}
