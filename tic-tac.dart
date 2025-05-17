
import 'dart:io';
import 'dart:math';

void main() {
  // Display welcome message
  print("Welcome to Tic-Tac Game !\n");
  
  // Initialize the game
  TicTacGame game = TicTacGame();
  String? userInput;
  
  // Prompt user for game mode selection
  print("Do you want to play with a robot? (Y/N):\n");
  userInput = stdin.readLineSync();
  
  // Start game based on user selection
  if (userInput != null && userInput.compareTo("Y") == 0) {
    game.startGameWithRobot();
  } else {
    game.startNewGame();
  }
  
  // Game replay loop
  while (true) {
    // Ask user if they want to play again
    print("Do you want to play again? (Y/N):\n");
    userInput = stdin.readLineSync();
    
    if (userInput != null && userInput.compareTo("Y") == 0) {
      // Check if user wants to reset score
      print("Would you like to reset the score? (Y/N):\n");
      userInput = stdin.readLineSync(); 
      if (userInput != null && userInput.compareTo("Y") == 0) {
        game.resetScore();
      }
      
      // Select game mode for new game
      print("Do you want to play with a robot? (Y/N):\n");
      userInput = stdin.readLineSync();
      if (userInput != null && userInput.compareTo("Y") == 0) {
        game.startGameWithRobot();
      } else {
        game.startNewGame();
      }
    } else {
      // End the game
      print("Thanks for playing !\n");
      break;
    }
  }
}



// Enum representing player moves with associated values
enum PlayerMove {
  player1(1),   // Player 1 represented by 1
  player2(-1);  // Player 2 represented by -1

  final int value;
  const PlayerMove(this.value);
}

/// Player class that manages player information and interactions
class Player {
  String? name;      // Player's name
  String? choice;    // Player's symbol (X or O)
  int winingsCount = 0;  // Number of wins
  int position = -1;     // Selected position on board
  
  // Constructor with default values
  Player([this.name = "player", this.winingsCount = 0, this.choice = 'X']);

  // Display player information
  void printInfo() {
    print("name: $name\nnumber of winings: $winingsCount\nsymbol choice: $choice\n");
  }

  // Return player information as a map
  Map<String, dynamic> getInfo() {
    return {
      "name": name,
      "winingsCount": winingsCount,
      "choice": choice
    };
  }

  // Get player's move from console input
  int getMove() {
    String? input = null;
    int position = -1;
    
    // Loop until valid position is entered
    while (position == -1) {
      print("$name: Please Enter your move (number from 1-9, make sure it is not selected previously):\n");
      input = stdin.readLineSync();
      
      if (input != null) {
        try {
          position = int.parse(input);
        } catch (e) {
          print("Make sure to enter number from 1-9!!! :\n$e"); 
        }
      } else {
        print("Enter a number from 1-9!");
      }
    }
    
    this.position = position; 
    return position;
  }
}





/// Main game class to manage tic-tac-toe gameplay
class TicTacGame {
  // Players initialization
  Player player1 = Player("player1", 0, "O");
  Player player2 = Player("player2", 0, "X");
  String? userInput;
  
  // Game state
  List<int> gameBoard = List<int>.filled(9, 0);  // Game board (0 = empty, 1 = player1, -1 = player2)
  List<int> result = List<int>.filled(8, 0);     // Tracking win conditions
  int moveCount = 0;                            // Number of moves played

  /// Start a new two-player game
  void startNewGame() {
    // Reset game state
    gameBoard = List<int>.filled(9, 0);
    result = List<int>.filled(8, 0);
    moveCount = 0;
    
    print("Starting a new Game !\n");
    
    // Player symbol selection
    while (!selectPlayerSymbols()) {
      print("Please make sure to enter valid option!!\n");
    }
    print("Player1 Selection is: ${player1.choice}, Player2 Selection is: ${player2.choice}");
    
    // Main game loop
    while (!checkGameEnd()) {
      // Player 1 turn
      while (!validatePlayerMove(player1.getMove())) {
        print("Please try again and follow instruction!\n");
      }
      gameBoard[player1.position - 1] = PlayerMove.player1.value;
      moveCount++;
      printGameBoard();
      updateResultList(player1.position, PlayerMove.player1);
      
      if (checkGameEnd()) {
        break;
      }

      // Player 2 turn
      while (!validatePlayerMove(player2.getMove())) {
        print("Please try again and follow instruction!\n");
      }
      gameBoard[player2.position - 1] = PlayerMove.player2.value;
      printGameBoard();
      updateResultList(player2.position, PlayerMove.player2);
      moveCount++;
    }
    
    showScore();
  }

  /// Handle player symbol selection (X or O)
  bool selectPlayerSymbols() {
    print("Please select Player1 choice (O, X): \n");
    userInput = stdin.readLineSync();
    
    if (userInput != null) {
      if (userInput?.compareTo("X") == 0) {
        player1.choice = userInput;
        player2.choice = "O";
        return true; 
      } else if (userInput?.compareTo("O") == 0) {
        player1.choice = userInput;
        player2.choice = "X";
        return true; 
      } else {
        print("Please select a valid option either O or X:\n");
      }
    }
    return false;
  }

  /// Validate if player move is valid
  bool validatePlayerMove(int position) {
    // Check if position is within valid range
    if (position < 1 || position > 9) {
      print("Make sure to select position between 1-9!!!\n");
      return false;
    }
    
    // Check if position is already taken
    if (gameBoard[position - 1] != 0) {
      print("This position is already selected!!!\n");
      return false;
    }
    
    return true;
  }

  
  /// Check if there is a win or draw
  bool checkGameEnd() { 
    // Check all possible win conditions
    for (int i in result) {
      if (i == 3) {
        player1.winingsCount++;
        print("Congratulations Player 1 Won!!! \n\n");
        return true;
      } else if (i == -3) {
        player2.winingsCount++;
        print("Congratulations Player 2 Won!!! \n\n");
        return true;
      }
    }
    
    // Check for draw (all positions filled)
    if (moveCount == 9) {
      print("Game End with a draw!!!");
      return true;
    }
    
    return false;
  }

  /// Display the current game board
  void printGameBoard() {
    print('''
 ${getSymbol(gameBoard[0])} | ${getSymbol(gameBoard[1])} | ${getSymbol(gameBoard[2])}
---+---+---
 ${getSymbol(gameBoard[3])} | ${getSymbol(gameBoard[4])} | ${getSymbol(gameBoard[5])}
---+---+---
 ${getSymbol(gameBoard[6])} | ${getSymbol(gameBoard[7])} | ${getSymbol(gameBoard[8])}
''');
  }
  
  /// Convert board value to player symbol
  String? getSymbol(int gameBoardValue) {
    if (gameBoardValue == PlayerMove.player1.value) {
      return player1.choice;
    } else if (gameBoardValue == PlayerMove.player2.value) {
      return player2.choice;
    }
    return ' ';
  }

  /// Update the result list to track win conditions
  void updateResultList(int position, PlayerMove player) {
    int pos = position - 1;
    
    // Special case for position 0 (top-left corner)
    if (pos == 0) {
      result[0] += player.value;  // Update row 0
      result[3] += player.value;  // Update column 0
      result[6] += player.value;  // Update diagonal
      return;
    }
    
    // Calculate row and column indices
    int row = pos ~/ 3;
    int column = pos % 3;
    
    // Update row and column values
    result[row] += player.value;
    result[column + 3] += player.value;
    
    // Update diagonals if applicable
    if (row + column == 2) {
      if (column == 1) {
        result[6] += player.value;
        result[7] += player.value;
      } else {
        result[7] += player.value;
      }
    }
    
    if (row + column == 4) {
      result[6] += player.value;
    }
  }



  /// Display the current score
  void showScore() {
    print('\n' + '=' * 30);
    print('         🎯 Score Board         ');
    print('=' * 30);
    print('🧑 Player 1: ${player1.winingsCount}');
    print('🧑 Player 2: ${player2.winingsCount}');
    print('=' * 30 + '\n');
  }

  /// Reset the game board and scores
  void resetGame() {
    gameBoard = List<int>.filled(9, 0);
    result = List<int>.filled(8, 0);
    moveCount = 0;
    player1.position = -1;
    player2.position = -1;
    resetScore();
    print("Game has been reset!\n");
  }

  /// Reset only the scores
  void resetScore() {
    player1.winingsCount = 0;
    player2.winingsCount = 0;
  }

  /// Start a game against a robot player
  void startGameWithRobot() {
    // Reset game state
    gameBoard = List<int>.filled(9, 0);
    result = List<int>.filled(8, 0);
    moveCount = 0;
    player1.position = -1;
    player2.position = -1;
    
    print("Starting a new Game with Robot!\n");
    
    // Player symbol selection
    while (!selectPlayerSymbols()) {
      print("Please make sure to enter valid option!!\n");
    }
    print("Player1 Selection is: ${player1.choice}, Player2 Selection is: ${player2.choice}");
    
    // Main game loop against robot
    while (!checkGameEnd()) {
      // Human player turn
      while (!validatePlayerMove(player1.getMove())) {
        print("Please try again and follow instruction!\n");
      }
      gameBoard[player1.position - 1] = PlayerMove.player1.value;
      moveCount++;
      printGameBoard();
      updateResultList(player1.position, PlayerMove.player1);
      
      if (checkGameEnd()) {
        break;
      }

      // Robot player turn
      RobotPlayer robot = RobotPlayer();
      while (!validatePlayerMove(robot.getMove())) {
        // Robot will try different positions until finding a valid one
      }
      gameBoard[robot.position - 1] = PlayerMove.player2.value;
      printGameBoard();
      updateResultList(robot.position, PlayerMove.player2);
      moveCount++;
    }
    
    showScore();
  }
}




/// Robot player that makes random moves
class RobotPlayer extends Player {
  String? name;
  String? choice;
  int winingsCount = 0;
  int position = -1;
  
  // Robot player constructor
  RobotPlayer([this.name = "robot", this.winingsCount = 0, this.choice = 'X']);
  
  @override
  int getMove() {
    // Generate random position between 1-9
    Random random = Random();
    position = random.nextInt(9) + 1;
    print("Robot selects position: $position");
    return position;
  }
}