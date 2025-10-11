void main() {
  DateTime now = DateTime.now();
  String formattedDate =
      "${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} "
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  print("Current date and time: $formattedDate");
}
