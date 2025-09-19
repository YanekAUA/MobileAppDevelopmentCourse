import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

const Map<String, String> numberWords = {
  '0': '',
  '1': 'one',
  '2': 'two',
  '3': 'three',
  '4': 'four',
  '5': 'five',
  '6': 'six',
  '7': 'seven',
  '8': 'eight',
  '9': 'nine',
  '10': 'ten',
  '11': 'eleven',
  '12': 'twelve',
  '13': 'thirteen',
  '14': 'fourteen',
  '15': 'fifteen',
  '16': 'sixteen',
  '17': 'seventeen',
  '18': 'eighteen',
  '19': 'nineteen',
  '20': 'twenty',
  '30': 'thirty',
  '40': 'forty',
  '50': 'fifty',
  '60': 'sixty',
  '70': 'seventy',
  '80': 'eighty',
  '90': 'ninety',
  '100': 'hundred',
  '1000': 'thousand',
  '1000000': 'million',
  '1000000000': 'billion',
};

String integerToWords(String number) {
  // Define a map for number to words conversion
  /*For numbers 1–19, use direct mappings (e.g., 1 → "one", 15 → "fifteen").
For tens (20–99), handle the tens place (e.g., 20 → "twenty", 50 → "fifty") and append units if non-zero (e.g., 23 → "twenty three").
For hundreds (100–999), include the hundreds place (e.g., 100 → "one hundred") and append the tens/units if non-zero.
For thousands and millions, process the group as a 1–999 number and append "thousand" or "million".
*/
  String result = '';
  if (number == '0') {
    return 'zero';
  }

  for (int i = 0; i < number.length; i += 3) {
    int end = number.length - i;
    int start = (end - 3) < 0 ? 0 : end - 3;
    String segment = number.substring(start, end);
    String segmentWord = convertTriDigital(segment);
    if (segmentWord.isNotEmpty) {
      String thousandWord = '';

      if (segmentWord == 'zero') {
        thousandWord = '';
      } else if (i != 0) {
        thousandWord = numberWords['${pow(10, i)}']!;
      }
      result = '$segmentWord $thousandWord ${result.trim()}'.trim();
    }
  }
  return result.trim();
}

String convertBiDigital(String twoDigitNumber) {
  if (twoDigitNumber.length == 1) {
    return numberWords[twoDigitNumber] ?? 'Invalid input';
  }
  if (twoDigitNumber.length != 2) {
    return 'Invalid input';
  }

  String firstDigit = twoDigitNumber[0];
  String secondDigit = twoDigitNumber[1];

  if (firstDigit == '0') {
    return numberWords[secondDigit] ?? 'Invalid input';
  } else {
    if (firstDigit == '1') {
      return numberWords[twoDigitNumber] ?? 'Invalid input';
    } else {
      String tens = '${firstDigit}0';
      String units = secondDigit;
      String tensWord = numberWords[tens] ?? '';
      String unitsWord = numberWords[units] ?? '';
      return '$tensWord $unitsWord'.trim();
    }
  }
}

String convertTriDigital(String threeDigitNumber) {
  if (threeDigitNumber.length < 3) {
    return convertBiDigital(threeDigitNumber);
  } else if (threeDigitNumber.length != 3) {
    return 'Invalid input';
  }

  String firstDigit = threeDigitNumber[0];
  String lastTwoDigits = threeDigitNumber.substring(1);

  if (firstDigit == '0') {
    return convertBiDigital(lastTwoDigits);
  } else {
    String hundredsWord = '${numberWords[firstDigit]} hundred';
    String restOfTheNumber = convertBiDigital(lastTwoDigits);
    return '$hundredsWord $restOfTheNumber'.trim();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number to Words Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 23, 34, 39),
        ),
      ),
      home: const MyHomePage(title: 'Number to Words Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _mirrorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberController.addListener(() {
      _mirrorController.text = integerToWords(_numberController.text.trim());
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    _mirrorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.7, // Set width to 50% of screen width
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ), // Optional padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Number input field
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter a number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0), // Optional spacing)
              TextField(
                controller: _mirrorController,
                readOnly: true,
                minLines: 1,
                maxLines: null, // Expands vertically as needed
                decoration: const InputDecoration(
                  labelText: 'String Value',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
