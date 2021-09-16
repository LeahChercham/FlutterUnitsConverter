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
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  double _startValue = 0;
  var _startUnit = "Meter";
  var _endUnit = "Feet";
  double _endValue = 0;
  var textController = TextEditingController();
  bool showResult = false;
  bool blockConversion = false;
  String _result = "";
  List<String> units = ['Meter', 'Kilometer', 'Feet', 'Mile'];

  var currentFocus;

  void unfocus() {
    // function to hide nummeric keyboard
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void _pressButton() {
    unfocus(); // Hide Numeric Keyboard
    _convertValue();

    setState(() {
      showResult = true;
    });
  }

  void _convertValue() {
    if (blockConversion) {
      return; // do nothing
    } else {
      switch (_startUnit) {
        case "Meter":
          switch (_endUnit) {
            case "Feet":
              setState(() {
                _endValue = _startValue * 3.28084;
              });
              break;
            case "Kilometer":
              setState(() {
                _endValue = _startValue * 0.001;
              });
              break;
            case "Mile":
              setState(() {
                _endValue = _startValue * 0.000621371;
              });
              break;
            case "Meter":
              setState(() {
                _endValue = _startValue * 1;
              });
              break;
          }
          break;

        case "Kilometer":
          switch (_endUnit) {
            case "Feet":
              setState(() {
                _endValue = _startValue * 3280.84;
              });
              break;
            case "Kilometer":
              setState(() {
                _endValue = _startValue * 1;
              });
              break;
            case "Mile":
              setState(() {
                _endValue = _startValue * 0.621371;
              });
              break;
            case "Meter":
              setState(() {
                _endValue = _startValue * 1000;
              });
              break;
          }
          break;

        case "Feet":
          switch (_endUnit) {
            case "Feet":
              setState(() {
                _endValue = _startValue * 1;
              });
              break;
            case "Kilometer":
              setState(() {
                _endValue = _startValue * 0.0003048;
              });
              break;
            case "Mile":
              setState(() {
                _endValue = _startValue * 0.000189394;
              });
              break;
            case "Meter":
              setState(() {
                _endValue = _startValue * 0.3048;
              });
              break;
          }
          break;

        case "Mile":
          switch (_endUnit) {
            case "Feet":
              setState(() {
                _endValue = _startValue * 5280;
              });
              break;
            case "Kilometer":
              setState(() {
                _endValue = _startValue * 1.60934;
              });
              break;
            case "Mile":
              setState(() {
                _endValue = _startValue * 1;
              });
              break;
            case "Meter":
              setState(() {
                _endValue = _startValue * 1609.34;
              });
              break;
          }
          break;
      }
      setState(() {
        _result = '$_startValue $_startUnit sind $_endValue $_endUnit';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // visible content of app
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding:
            EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
                  setState(() {
                    _result = (_startValue == 0 || newValue == "")
                        ? ""
                        : "Nur Dezimalzahlen mit Punkt als Trennzeichen sind erlaubt.";
                    showResult = true;
                    blockConversion = true;
                  });
                } else {
                  setState(() {
                    _startValue = double.parse(newValue);
                    blockConversion = false;
                  });
                }
              },
            ),
            Text('Von'),
            DropdownButton<String>(
              isExpanded: true,
              value: _startUnit,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              underline: Container(height: 2, color: Colors.blue[900]),
              onChanged: (String? newValue) {
                setState(() {
                  _startUnit = newValue!;
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
            Text('Nach'),
            DropdownButton<String>(
              isExpanded: true,
              value: _endUnit,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.blue[900],
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _endUnit = newValue!;
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
                onPressed: _pressButton, child: const Text('Konvertieren')),
            showResult ? Text('$_result') : Text(""),
          ],
        ),
      ),
    );
  }
}
