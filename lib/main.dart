import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:password_generator/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de Senha',
      theme: ThemeData(
        //Define o tema claro
        brightness: Brightness.light,
        scaffoldBackgroundColor: colorScaf,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle:
              SystemUiOverlayStyle.light, //Controla a cor da barra de status
        ),
      ),
      darkTheme: ThemeData(
        //Define o tema escuro
        brightness: Brightness.dark,
        scaffoldBackgroundColor: colorScafDark,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      themeMode: _themeMode,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _password = '';
  int _passwordLength = 13;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumber = true;
  bool _includeSymbols = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    // Atualize o tema da aplicação
    MyApp.of(context)!.toggleTheme(_isDarkMode);
  }

  void _generatePassword() {
    const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const numberChars = '0123456789';
    const symbolChars = '!@#%&*_+-=';

    String chars = '';
    if (_includeUppercase) {
      chars += uppercaseChars;
    }
    if (_includeLowercase) {
      chars += lowercaseChars;
    }
    if (_includeNumber) {
      chars += numberChars;
    }
    if (_includeSymbols) {
      chars += symbolChars;
    }

    if (chars.isEmpty) {
      chars = lowercaseChars;
    }

    Random rnd = Random();

    String password = String.fromCharCodes(Iterable.generate(
      _passwordLength,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ));

    setState(() {
      _password = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBase,
        title: const Text(
          'SAFEKEYGEN',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80.0,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                color: Colors.white,
                icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
                onPressed: _toggleTheme,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              //senha Gerada
              margin: EdgeInsets.all(20.0),
              width: 400,
              // padding: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.fromLTRB(10, 25, 5, 25),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: _isDarkMode ? colorContainersDark : colorContainers,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _password,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _password));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          padding: EdgeInsets.all(20.0),
                          backgroundColor: Colors.green,
                          content: Text(
                            'Senha copiada!',
                            textAlign: TextAlign.right,
                            style:
                                TextStyle(fontSize: 21.0, color: Colors.white),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, color: colorBase),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              //persornalização da senha
              width: 400,
              color: _isDarkMode ? colorContainersDark : colorContainers,
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personalize sua senha:',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                      value: _passwordLength.toDouble(),
                      min: 6, //tamanho minumo da senha
                      max: 16, //tamanho maximo da senha
                      divisions: 10, //quantos passos
                      label: _passwordLength.toString(), //blão acima do slide
                      onChanged: (double value) {
                        setState(() {
                          _passwordLength = value
                              .toInt(); //passando o value do slide para a variavel
                          _generatePassword(); //chama pra gerar novamentecomo novo tamanho
                        });
                      }),
                  //duas linhas
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Letras maiúsculas'),
                          value: _includeUppercase,
                          onChanged: (value) {
                            setState(() {
                              _includeUppercase = value!;
                              _generatePassword();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Letras minúsculas'),
                          value: _includeLowercase,
                          onChanged: (value) {
                            setState(() {
                              _includeLowercase = value!;
                              _generatePassword();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Números'),
                          value: _includeNumber,
                          onChanged: (value) {
                            setState(() {
                              _includeNumber = value!;
                              _generatePassword();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Símbolos'),
                          value: _includeSymbols,
                          onChanged: (value) {
                            setState(() {
                              _includeSymbols = value!;
                              _generatePassword();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 400,
                    // color: testeColor,
                    padding: EdgeInsets.fromLTRB(30, 60, 30, 20),
                    child: ElevatedButton(
                      onPressed: _generatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorBase,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 10.0,
                        ),
                      ),
                      child: const Text(
                        'Gerar Senha',
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
