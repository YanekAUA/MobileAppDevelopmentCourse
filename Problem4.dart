enum IntegerStatus {
  positive('Positive'),
  negative('Negative'),
  zero('Zero');

  final String label;
  const IntegerStatus(this.label);

  @override
  String toString() => label;
}

IntegerStatus checkInteger(int number) {
  if (number > 0) {
    return IntegerStatus.positive;
  } else if (number < 0) {
    return IntegerStatus.negative;
  } else {
    return IntegerStatus.zero;
  }
}

void main() {
  List<int> testNumbers = [5, -3, 0, 12, -7];
  for (var number in testNumbers) {
    print('The number $number is ${checkInteger(number)}');
  }
}
