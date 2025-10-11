void divideNumbers(int a, int b) {

  if (b == 0) {
    print("Error: Division by zero is not allowed.");
    return;
  }

  double result = a / b;
  print("The result of division is: $result");
}

void main() {
  divideNumbers(10, 2); // Valid division
  divideNumbers(10, 0); // Division by zero
}