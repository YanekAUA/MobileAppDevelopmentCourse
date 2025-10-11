import 'dart:io';
import 'dart:core';

void main() {
  stdout.write("Enter your name: ");
  String? name = stdin.readLineSync();

  stdout.write("Enter your age: ");
  String? ageInput = stdin.readLineSync();
  int? age = int.tryParse(ageInput ?? '');

  if (name == null || name.isEmpty) {
    print("Name cannot be empty. Please run the program again.");
    return;
  }

  if (age == null) {
    print("Invalid age input. Please enter a valid number for age.");
    return;
  }

  StringBuffer greeting = StringBuffer("Hello, $name! ");

  switch (age) {
    case < 0:
      greeting.write("Wow, you haven't been born yet!");
      break;
    case <= 12:
      greeting.write("You're curious and full of potential!");
      break;
    case <= 19:
      greeting.write("These teenage years are full of discovery and energy!");
      break;
    case <= 35:
      greeting.write("You're in a period of growth and new opportunities!");
      break;
    case <= 50:
      greeting.write("Your experiences are teaching valuable lessons.");
      break;
    case <= 65:
      greeting.write("You're gathering a wealth of insight and perspective!");
      break;
    default:
      greeting.write("You hold many stories and deep wisdom!");
  }

  print(greeting);
}
