import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:desktop_window/desktop_window.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      title: 'Generador de Licencia',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Generador Licencia v1.0'),
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
  String _codigopegado = '';
  String _codigogenerado = '-----------------';
  var pegado = false;
  var fecha = false;
  String _host = '';
  String _puerto = '';
  String _username = '';
  String _password = '';
  String _fecha = '';

  // String _LICENCIA_ENCRYPT_KEY = "TEVENDOSITRANSVC";
  // String _LICENCIA_KEY = "GENERADORTEVENDO";
  var txt_host = TextEditingController();
  var txt_puerto = TextEditingController();
  var txt_username = TextEditingController();
  var txt_password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testWindowFunctions();
    cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          MouseRegion(
            // <----
            cursor: SystemMouseCursors.click,
            child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _showMyDialog();
                  },
                  child: Icon(Icons.info),
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text(
                'Pegar Código',
                style: Theme.of(context).textTheme.headline6,
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black54,
                  height: 1,
                ),
              ),
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      _codigopegado,
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      iconSize: 50,
                      icon: const Icon(Icons.paste),
                      onPressed: pegar,
                    ),
                  ),
                ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text(
                'Seleccionar Fecha',
                style: Theme.of(context).textTheme.headline6,
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black54,
                  height: 1,
                ),
              ),
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      _fecha,
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        iconSize: 50,
                        icon: const Icon(Icons.date_range_rounded),
                        onPressed: () => _selectDate(context),
                      )),
                ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text(
                'Conexión',
                style: Theme.of(context).textTheme.headline6,
              ),
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black87,
                      height: 1,
                    ),
                  ),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                      maxWidth: 300,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: TextField(
                        controller: txt_host,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.web),
                          hintText: 'Host',
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _host = value;
                          salvar('host', value);
                          chequear();
                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                      maxWidth: 300,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: txt_puerto,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.cable),
                          hintText: 'Puerto',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _puerto = value;
                          salvar('puerto', value);
                          chequear();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                      maxWidth: 300,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: txt_username,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.account_circle),
                          hintText: 'Usuario',
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _username = value;
                          salvar('username', value);
                          chequear();
                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                      maxWidth: 300,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: TextField(
                        controller: txt_password,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: 'Contraseña',
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _password = value;
                          salvar('password', value);
                          chequear();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text(
                'Código Generado',
                style: Theme.of(context).textTheme.headline6,
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black45,
                  height: 1,
                ),
              ),
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: Text(
                        _codigogenerado,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.indigo, fontSize: 13),
                        maxLines: 3,
                        //overflow: TextOverflow.ellipsis,
                      )),
                  const Spacer(
                    flex: 2,
                  ),
                  IconButton(
                      iconSize: 50,
                      icon: const Icon(Icons.copy),
                      onPressed: () => copiar()),
                  const Spacer(
                    flex: 1,
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Future testWindowFunctions() async {
    //  Size size = await DesktopWindow.getWindowSize();
    // print(size);
    await DesktopWindow.setWindowSize(const Size(600, 600));
    await DesktopWindow.setMinWindowSize(const Size(400, 600));
    await DesktopWindow.setMaxWindowSize(const Size(600, 600));
    // await DesktopWindow.resetMaxWindowSize();
    // await DesktopWindow.toggleFullScreen();
    //bool isFullScreen = await DesktopWindow.getFullScreen();
    //await DesktopWindow.setFullScreen(true);
    // await DesktopWindow.setFullScreen(false);
  }

  pegar() async {
    try {
      ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
      String? copiedtext = cdata?.text;
      if (copiedtext != null) {
        if (copiedtext.length != 10) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Formato de Código Incorrecto"),
              backgroundColor: Colors.redAccent));
          return;
        }
        setState(() {
          _codigopegado = copiedtext;
        });
        pegado = true;
        chequear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Código Pegado"), backgroundColor: Colors.indigo));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Vacío"), backgroundColor: Colors.redAccent));
      }
    } on Exception catch (exception) {
      errorMSG(exception.toString());
    } catch (error) {
      errorMSG("");
    }
  }

  void _selectDate(BuildContext buildContext) async {
    var diaplus = DateTime.now().add(const Duration(days: 365));
    final DateTime? pickedDate = await showDatePicker(
        context: buildContext,
        initialDate: diaplus,
        firstDate: DateTime.now(),
        lastDate: diaplus);
    if (pickedDate != null) {
      int dia = pickedDate.day;
      int mes = pickedDate.month;
      int anno = pickedDate.year;
      String cerod = "";
      String cerom = "";
      if (mes < 10) {
        cerom = "0";
      }
      if (dia < 10) {
        cerod = "0";
      }
      setState(() {
        _fecha = "$cerod$dia-$cerom$mes-$anno";
      });
      fecha = true;
      salvar('fecha', _fecha);
      chequear();
    }
  }

  copiar() {
    if (fecha && pegado) {
      try {
        Clipboard.setData(ClipboardData(text: _codigogenerado)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Código Copiado"), backgroundColor: Colors.indigo));
        });
      } on Exception catch (exception) {
        errorMSG(exception.toString());
      } catch (error) {
        errorMSG("Error al copiar el código");
      }
    } else {
      errorMSG("No se ha generado el código");
    }
  }

  void errorMSG(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  String encriptar(String txt) {
    final key = enc.Key.fromUtf8('TEVENDOSITRANSVC');
    final iv = enc.IV.fromUtf8('TEVENDOSITRANSVC');
    final encrypter =
        enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc)); //aesmode.cbc
    final encrypted = encrypter.encrypt(txt, iv: iv);
    return encrypted.base64;
  }

  void chequear() {
    if (fecha && pegado) {
      Map<String, dynamic> json = {};
      json['codigo'] = _codigopegado;
      json['fecha'] = _fecha;

      if (_username.isNotEmpty) {
        json['username'] = _username;
      }

      if (_puerto.isNotEmpty) {
        json['puerto'] = _puerto;
      }
      if (_host.isNotEmpty) {
        json['host'] = _host;
      }
      if (_password.isNotEmpty) {
        json['password'] = _password;
      }
      try {
        encriptar(json.toString());
        setState(() {
          _codigogenerado = encriptar(json.toString());
        });
      } on Exception catch (exception) {
        errorMSG("Error al encriptar el código");
      } catch (error) {
        errorMSG("Error al encriptar el código");
      }
    }
  }

  salvar(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  cargar() async {
    final prefs = await SharedPreferences.getInstance();
    String? host = prefs.getString('host');
    String? puerto = prefs.getString('puerto');
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    String? fecha = prefs.getString('fecha');

    if (host != null) {
      _host = host;
      txt_host.text = host;
    }
    if (puerto != null) {
      _puerto = puerto;
      txt_puerto.text = puerto;
    } else {
      _puerto = '8000';
      txt_puerto.text = '8000';
    }
    if (username != null) {
      _username = username;
      txt_username.text = username;
    }
    if (password != null) {
      _password = password;
      txt_password.text = password;
    }
    setState(() {
      if (fecha != null) {
        _fecha = fecha;
        this.fecha = true;
      }
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Información',
                    style: Theme.of(context).textTheme.headline6),
                Container(
                  color: Colors.black45,
                  height: 1,
                )
              ]),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Objetivo: ',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              'T-Muestro v1.0',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ]),
                      Text('SITRANS 2022',
                          style: Theme.of(context).textTheme.headline5),
                    ]),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Regresar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
