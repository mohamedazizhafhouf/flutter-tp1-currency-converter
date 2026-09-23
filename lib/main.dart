import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Currency Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const double _euroToDinarRate = 3.4;

  final TextEditingController _amountController = TextEditingController();
  String? _selectedCurrency;
  String _result = 'Enter an amount and choose a conversion.';

  void _convertCurrency([String? direction]) {
    final String? selectedDirection = direction ?? _selectedCurrency;
    final double? amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    setState(() {
      if (selectedDirection == null) {
        _result = 'Choose a conversion direction.';
        return;
      }

      _selectedCurrency = selectedDirection;

      if (amount == null) {
        _result = 'Please enter a valid number.';
        return;
      }

      if (selectedDirection == 'EUR') {
        final double convertedAmount = amount / _euroToDinarRate;
        _result =
            '${amount.toStringAsFixed(2)} TND = '
            '${convertedAmount.toStringAsFixed(2)} EUR';
      } else {
        final double convertedAmount = amount * _euroToDinarRate;
        _result =
            '${amount.toStringAsFixed(2)} EUR = '
            '${convertedAmount.toStringAsFixed(2)} TND';
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Montant',
                    hintText: 'Enter an amount',
                  ),
                ),
              ),
              RadioListTile<String>(
                title: const Text('Dinar -> Euro'),
                value: 'EUR',
                groupValue: _selectedCurrency,
                onChanged: (String? value) {
                  if (value != null) {
                    _convertCurrency(value);
                  }
                },
              ),

              RadioListTile<String>(
                title: const Text('Euro -> Dinar'),
                value: 'TND',
                groupValue: _selectedCurrency,
                onChanged: (String? value) {
                  if (value != null) {
                    _convertCurrency(value);
                  }
                },
              ),

              const SizedBox(height: 16),
              Text(
                _result,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 248, 248, 248),
                  backgroundColor: const Color.fromARGB(255, 198, 33, 243),
                ),
                onPressed: _convertCurrency,
                child: const Text('Convertir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
