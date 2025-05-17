
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
