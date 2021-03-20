import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:appx/models/mensajes_response.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/chat_service.dart';
import 'package:appx/services/cita_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final citaService = new CitaService();
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;
  final GlobalKey<NavigatorState> navigatorKeyChat = new GlobalKey<NavigatorState>();
  File _image;

  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  BuildContext blConte;

  List<ChatMessage> _messages = [
    // ChatMessage(uid: '123', texto: 'Hola mundo'),
    // ChatMessage(uid: '123', texto: 'Hola mundo'),
    // ChatMessage(uid: '12344', texto: 'Hola mundo')
  ];

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.blConte = context;

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    final history = chat.map((m) => new ChatMessage(
          texto: m.mensaje,
          uid: m.de,
          animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 300))..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    // print('Tengo un mensaje!! $data');
    ChatMessage message = new ChatMessage(
        texto: payload['mensaje'],
        uid: payload['de'],
        animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)));

    if (payload['mensaje'] == "F1n@liz@Ch@t") {
      // print('POP!!!!!!!!!');
      // mostrarAlerta(this.blConte, '3', '3');
      Fluttertoast.showToast(
          msg: "Chat Finalizado",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey[300],
          textColor: Colors.black,
          fontSize: 16.0);
      Navigator.pushReplacementNamed(this.blConte, 'home');
    } else {
      setState(() {
        _messages.insert(0, message);
      });

      message.animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          padding: EdgeInsets.all(10.0),
          child: CircleAvatar(
            child: Text(usuarioPara.nombre.substring(0, 2), style: TextStyle(fontSize: 12)),
            backgroundColor: Colors.blue[100],
            // maxRadius: 8
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              usuarioPara.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 16),
            )
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _btnFinalizarCita(usuarioPara.tipo, context),
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider(height: 1.0),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  /// Cuando hay un avlor
                  setState(() {
                    if (texto.trim().length > 0) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.height * 0.05,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscribiendo ? () => _handleSubmit(_textController.text.trim()) : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _estaEscribiendo ? () => _handleSubmit(_textController.text.trim()) : null,
                        ),
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.height * 0.05,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.add_photo_alternate),
                    onPressed: () => _showPicker(context),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: authService.usuario.uid,
      texto: texto,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    //emitir mensaje
    this.socketService.emit(
        'mensaje-personal', {'de': this.authService.usuario.uid, 'para': this.chatService.usuarioPara.uid, 'mensaje': texto});
  }

  @override
  void dispose() {
    //Off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  Widget _btnFinalizarCita(strTipo, context) {
    if (strTipo == "P") {
      return FlatButton(
          minWidth: double.infinity,
          child: Text('Finalizar Cita', style: TextStyle(color: Colors.white)),
          color: Colors.red,
          onPressed: () async {
            bool okFinalizaCita = await citaService.setFinalizaMedicoCita(chatService.idCita);
            if (okFinalizaCita) {
              this.socketService.emit('mensaje-personal',
                  {'de': this.authService.usuario.uid, 'para': this.chatService.usuarioPara.uid, 'mensaje': 'F1n@liz@Ch@t'});
              Navigator.pushReplacementNamed(context, 'citasMedico');
            } else {
              print('Error!!');
            }
          });
    } else {
      return Container();
    }
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    Uint8List imageBytes = image.readAsBytesSync();
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: authService.usuario.uid,
      texto: 'image',
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
      tipo: "I",
      imageBytes: imageBytes,
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    //emitir mensaje
    this.socketService.emit(
        'mensaje-personal', {
          'de': this.authService.usuario.uid,
          'para': this.chatService.usuarioPara.uid,
          'mensaje': imageBytes,
          'tipo': "I"});

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galería'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camara'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
