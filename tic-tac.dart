
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
