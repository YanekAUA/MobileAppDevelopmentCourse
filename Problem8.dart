class Person {
  String _name;
  int _age;

  Person(String name, int age) : _name = name, _age = age {
    if (age < 0) {
      throw ArgumentError("Age cannot be negative");
    }
  }

  String toString() => '$_name, Age: $_age';
  String getName() => _name;
  int getAge() => _age;
}

void main() {
  Person person = Person("Ani", 22);
  print("Name: ${person.getName()}");
  print("Age: ${person.getAge()}");
}
