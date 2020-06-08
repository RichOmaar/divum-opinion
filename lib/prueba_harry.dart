import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:moduloeventos/card_contactos.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class PruebaHarry extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PruebaHarry();
  }

}

class _PruebaHarry extends State<PruebaHarry> {

  final _formKey = GlobalKey<FormState>();
  final ControlerContacto = TextEditingController();
  List contactos = [];
  var doctores = [];
  List resultadoBusqueda = [];
  List _contactos = [];
  bool cargarDatos = false;

  void peticionDoctores() async {
    var url = 'https://divumclinic.com/opinion/app/obtenerDoctores.app.php';

    http.Response respuesta = await http.post(
      url
    );
    
    var _respuesta = jsonDecode(respuesta.body);

    setState(() {
      doctores = _respuesta;
    });

  }
  

  void ObtenerPermisoContacto() async{
    if (await Permission.contacts.request().isGranted) {
      await Contacts.streamContacts().forEach((contact) {
        contactos.add({
              "nombreContacto":contact.displayName,
              "telefono":(contact.phones.length > 0) ? contact.phones.first.value : ""
            });
      });                
      setState(() {
        contactos.sort((a, b) => a["nombreContacto"].toString().compareTo(b["nombreContacto"].toString()));
        cargarDatos = true;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    
    ObtenerPermisoContacto();
    peticionDoctores();

  }

  void buscarContacto (String terminoBusqueda) {
    //resultadoBusqueda = [];

    setState((){
      cargarDatos = false;
    });

    if(terminoBusqueda == ""){
      contactos = _contactos;
    } else {
      contactos = _contactos;
      contactos = contactos.where((contacto) => contacto['nombreContacto'].toLowerCase().contains(terminoBusqueda.toLowerCase())).toList();
    }

    setState((){
      cargarDatos = true;
    });

    print(contactos);
    
  } 


  @override
  Widget build(BuildContext context) {
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black
    ));
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 20,
                top: 15
              ),
              child: ListView.builder(
                padding: EdgeInsets.only(top:100),
                itemBuilder: (BuildContext context, int i){
                  
                  if(!cargarDatos){
                    print(contactos.length);
                    return Center(child: CircularProgressIndicator(),);
                    
                  } else {
                    return CardContactos(
                      contactos[i]['nombreContacto'], 
                      contactos[i]['telefono'],
                      doctores
                    );
                  }
                  
                      
                },
                itemCount: contactos.length,
              ),
            ),
            Container(
              padding: EdgeInsets.only( 
                top: 40,
                left: 23,
                right: 23
              ),
              color: Color(0xFFdae292),
              height: 90,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: ControlerContacto,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (respuesta){
                    setState((){
                      buscarContacto(respuesta);
                    });
                  },
                  onChanged: (respuesta){
                   // print(respuesta);
                    
                  },
                  style: TextStyle(
                    fontFamily: 'Jost',
                    color: Color(0xFFB3B3B3),
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Busca el contacto',
                    hintStyle: TextStyle(
                      fontFamily: 'Jost',
                      color: Color(0xFFB3B3B3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.search,
                        color: Color(0xFFB3B3B3)
                        
                      ), 
                      onPressed: (){

                      }
                    ),
                  ),
                )
                ),     
            )
          ],
        )
    );
  }
}