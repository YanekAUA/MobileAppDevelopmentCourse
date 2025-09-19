class Pair {
  final dynamic first;
  final dynamic second;

  Pair(this.first, this.second);
}

int sumAscii(String s) {
  int sum = 0;
  for (var char in s.runes) {
    sum += char;
  }
  return sum;
}

int sumPair(Pair p) {
  return sumNested(p.first) + sumNested(p.second);
}

int sumSpecialList(List<dynamic> list) {
  int sum = 0;
  for (var element in list) {
    sum += sumNested(element);
  }
  return sum;
}

int sumNested(dynamic obj) {
  int sum = switch (obj) {
    int n => n,
    double d => d.floor(),
    String s => sumAscii(s),
    List<dynamic> list => sumSpecialList(list),
    Pair r => sumPair(r),
    Map<String, dynamic> map => map.values.fold(
      0,
      (sum, value) => sum + sumNested(value),
    ),
    _ => 0,
  };
  return sum;
}

void main() {
  // examples:
  print(sumNested(5)); // 5
  print(sumNested([1, 2, 3])); // 6
  print(sumNested("ab")); // 195
  print(
    sumNested({
      'a': 4,
      'b': ["xy", 6.9],
    }),
  ); // 251
  print(sumNested((first: 7, second: ("z", 9)))); // 138
  print(sumNested([])); // 0
  print(sumNested({})); // 0
  print(sumNested("")); // 0
  print(sumNested(-5)); // -5
  print(
    sumNested([
      1,
      {'key': "ab"},
      Pair(3, "c"),
    ]),
  ); // 298
}
