# Number Guessing Game in Assembly Language

This repository contains an implementation of a simple number guessing game using assembly language. The game prompts the user to guess a randomly generated number between 0 and 10. The user has up to 5 attempts to guess the correct number, after which the game ends. If the user guesses the correct number within the allotted attempts, they win; otherwise, they lose.

## Instructions

1. **Setting up the Environment:**
   - Make sure you have a compatible assembler and linker installed on your system.
   - Use the `gcc` command with the `-no-pie` flag to compile the assembly code.
   
2. **Running the Program:**
   - After compiling the code, run the executable to start the game.
   - Follow the prompts to input your guess for the randomly generated number.

### Output Examples

![image](https://github.com/ilanitb16/numbers_game/assets/97344492/0cd00baf-d349-4772-8bb0-0ff165ac15d8)

## Game Mechanics

- The game prompts the user to enter a seed value for the random number generator.
- It then generates a random number between 0 and 10.
- The user is asked to guess the number, and they have up to 5 attempts to do so.
- If the guess is incorrect, the program prints "Incorrect."
- The game ends when either the user guesses the correct number or exceeds the maximum number of attempts.
- If the user guesses the correct number within the allotted attempts, the program prints "Congratulations! You won!"
- If the user fails to guess the correct number within the allotted attempts, the program prints "Game over, you lost :(. The correct answer was X," where X is the randomly generated number.

## Files

- **move.s:** Contains the assembly code for the number guessing game.
- **README.md:** This file, providing instructions and information about the game.

## Usage

1. Clone this repository to your local machine.
2. Compile the assembly code using the provided `gcc` command with the `-no-pie` flag.
3. Run the executable to start the game.

## Notes

- This implementation assumes a Unix-like environment and may require adjustments for other operating systems.

## Author

Ilanit Berditchevski

## License

This project is licensed under the [MIT License](LICENSE).

