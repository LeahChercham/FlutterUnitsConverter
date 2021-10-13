import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Einheiten Konverter',
      theme: ThemeData(
        // Theme of the application.
        primarySwatch: Colors.blueGrey,
        textTheme: const TextTheme(
            bodyText2: TextStyle(color: Colors.black87, fontSize: 22),
            subtitle1: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      home: ConverterScreen(title: 'Einheiten Konverter'),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  ConverterScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  ConverterScreenState createState() => ConverterScreenState();
}

class ConverterScreenState extends State<ConverterScreen> {
  // Definition of standard start values
  double startValue = 0;
  var startUnit = "Meter";
  var endUnit = "Feet";
  double endValue = 0;
  var textController = TextEditingController();
  bool showResult = false;
  bool blockConversion = false;
  String result = "";
  List<String> units = ['Meter', 'Kilometer', 'Feet', 'Mile'];
  var currentFocus;

  void unfocus() {
    // Function to hide nummeric keyboard
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void pressButton() {
    // Function called after press on convert Button
    unfocus(); // Hide Numeric Keyboard
    convertValue();

    setState(() {
      showResult = true;
    });
  }

  void convertValue() {
    // Conversion function
    if (blockConversion) {
      return; // Do nothing
    } else {
      // If conversion allowed
      // Switch statement for conversions. (Better solution: matrix or 2d array)
      switch (startUnit) {
        case "Meter":
          switch (endUnit) {
            case "Feet":
              setState(() {
                endValue = startValue * 3.28084;
              });
              break;
            case "Kilometer":
              setState(() {
                endValue = startValue * 0.001;
              });
              break;
            case "Mile":
              setState(() {
                endValue = startValue * 0.000621371;
              });
              break;
            case "Meter":
              setState(() {
                endValue = startValue * 1;
              });
              break;
          }
          break;

        case "Kilometer":
          switch (endUnit) {
            case "Feet":
              setState(() {
                endValue = startValue * 3280.84;
              });
              break;
            case "Kilometer":
              setState(() {
                endValue = startValue * 1;
              });
              break;
            case "Mile":
              setState(() {
                endValue = startValue * 0.621371;
              });
              break;
            case "Meter":
              setState(() {
                endValue = startValue * 1000;
              });
              break;
          }
          break;

        case "Feet":
          switch (endUnit) {
            case "Feet":
              setState(() {
                endValue = startValue * 1;
              });
              break;
            case "Kilometer":
              setState(() {
                endValue = startValue * 0.0003048;
              });
              break;
            case "Mile":
              setState(() {
                endValue = startValue * 0.000189394;
              });
              break;
            case "Meter":
              setState(() {
                endValue = startValue * 0.3048;
              });
              break;
          }
          break;

        case "Mile":
          switch (endUnit) {
            case "Feet":
              setState(() {
                endValue = startValue * 5280;
              });
              break;
            case "Kilometer":
              setState(() {
                endValue = startValue * 1.60934;
              });
              break;
            case "Mile":
              setState(() {
                endValue = startValue * 1;
              });
              break;
            case "Meter":
              setState(() {
                endValue = startValue * 1609.34;
              });
              break;
          }
          break;
      }
      setState(() {
        result = '$startValue $startUnit sind $endValue $endUnit';
      });
    }
  } // End of Switch Statement.

  @override
  Widget build(BuildContext context) {
    // Visible Content of App
    return Scaffold(
        // Top level container
        // resizeToAvoidBottomInset:false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding:
              EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Start of Widget Array
                Text(
                  'Wert',
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: textController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: "Hier zu konvertierenden Wert eingeben"),
                  onChanged: (String newValue) {
                    showResult = false;
                    if (double.tryParse(newValue) == null || newValue == "") {
                      // Error handling
                      setState(() {
                        result = (startValue == 0 || newValue == "")
                            ? ""
                            : "Nur Dezimalzahlen mit Punkt als Trennzeichen sind erlaubt.";
                        showResult = true;
                        blockConversion = true;
                      });
                    } else {
                      // If input correct
                      setState(() {
                        startValue = double.parse(newValue);
                        blockConversion = false;
                      });
                    }
                  },
                ),
                Padding(padding:EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Text('Von')),
                DropdownButton<String>(
                  isExpanded: true,
                  value: startUnit,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(height: 2, color: Colors.blue[900]),
                  onChanged: (String? newValue) {
                    setState(() {
                      startUnit = newValue!;
                      showResult = false;
                    });
                  },
                  items: units.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Padding(padding:EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Text('Nach')),
                DropdownButton<String>(
                  isExpanded: true,
                  value: endUnit,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.blue[900],
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      endUnit = newValue!;
                      showResult = false;
                    });
                  },
                  items: units.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                    onPressed: pressButton, child: const Text('Konvertieren')),
                showResult ? Text('$result') : Text(""),
              ],
            ),
          ),
        ));
  }
}
