class Person {
  String name;
  int age;

  Person(this.name, this.age);
  String toString() => '$name, Age: $age';
}

void main() {
  Map<int, Person> people = {
    1: Person('Alice', 30),
    2: Person('Bob', 25),
    3: Person('Charlie', 35),
  };

  people.forEach((id, person) {
    print('ID: $id, Person|| $person');
  });
}
