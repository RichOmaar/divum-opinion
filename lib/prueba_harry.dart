import 'dart:convert';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
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
  List contactos;
  var doctores;
  List resultadoBusqueda;
  bool datosCargados = false;

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
  

  void obtenerPermisoContacto() async{
    //PEDIMOS PERMISO PARA ACCEDER A LOS CONTACTOS
    if (await Permission.contacts.request().isGranted) {
      contactos = []; //INICIALIZAMOS LA LISTA QUE VAMOS A UTILIZAR
      Iterable<Contact> _contacts = await ContactsService.getContacts();
      _contacts.forEach((contact) {
        if(contact.phones.length > 0){
          contactos.add({
            "nombreContacto":contact.displayName,
            "telefono":contact.phones.first.value
          });
        }
      });

      setState(() {
        //contactos.sort((a, b) => a["nombreContacto"].toString().compareTo(b["nombreContacto"].toString()));
        datosCargados = true; //LE DECIMOS AL SISTEMA QUE YA HEMOS CARGADO TODOS LOS DATOS DE LOS CONTACTOS
      });


      /*_contacts.forEach( (contact) {
        //AGREAGAMOS TODOS Y CADA UNO DE LOS CONTACTOS DEL DISPOSITIVO A LA LISTA DE contactos, SÓLO SÍ TIENE UN NÚMERO DE TELÉFONO
        if(contact.phones.length > 0){
          contactos.add({
            "nombreContacto":contact.displayName,
            "telefono":contact.phones.first.value
          });
        }
        
      }).whenComplete((){
        //CUANDO TERMINE DE AGREGAR LOS CONTACTOS, LOS ORDENAMOS POR ORDEN ALFABETICO
        setState(() {
          //contactos.sort((a, b) => a["nombreContacto"].toString().compareTo(b["nombreContacto"].toString()));
          datosCargados = true; //LE DECIMOS AL SISTEMA QUE YA HEMOS CARGADO TODOS LOS DATOS DE LOS CONTACTOS
        });
      });*/
    }
  }

  Future <List> algoritmoBusqueda(String terminoBusqueda, List dondeBuscar) async{
    var respuesta = dondeBuscar.where((contacto){
      //print(contacto['nombreContacto'].toLowerCase());
      return contacto['nombreContacto'].toString().toLowerCase().contains(terminoBusqueda.toLowerCase());
    }).toList();
    return respuesta;
  }

  void buscarContacto (String terminoBusqueda) async{

    if(terminoBusqueda != ""){
      resultadoBusqueda = await algoritmoBusqueda(terminoBusqueda, contactos);
      Future.delayed(Duration(seconds: 1)).whenComplete((){
        setState(() {
          datosCargados = true;  
        });
      });
    }
    
  } 

  @override
  void initState(){
    super.initState();
    obtenerPermisoContacto();
    peticionDoctores();
  }


  @override
  Widget build(BuildContext context) {
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color(0xFFdae292)
    ));

    final inputBuscador = Container(
      padding: EdgeInsets.only( 
        left: 10,
        right: 10
      ),
      color: Color(0xFFdae292),
      child: TextField(
          controller: ControlerContacto,
          textInputAction: TextInputAction.done,
          onChanged: (respuesta){
            if(respuesta == ""){
              setState(() {
                resultadoBusqueda = null;
                datosCargados = true;
              });
            } else {
              setState((){
                resultadoBusqueda = null;
                datosCargados = false;
                buscarContacto(respuesta);
              });
            }
          },
          style: TextStyle(
            fontFamily: 'Jost',
            color: Color(0xFFB3B3B3),
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Busca un contacto aquí...',
            hintStyle: TextStyle(
              fontFamily: 'Jost',
              color: Color(0xFFB3B3B3),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
    );

    final listaContactos = ListView.builder(
        padding: EdgeInsets.only(top:25, left: 15, right: 15),
        itemBuilder: (BuildContext context, int i){
          
          if(!datosCargados){

            return Center(
              child: Container(
                margin: EdgeInsets.only(top: 180),
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 20,),
                    Text(
                      "Buscando contactos...",
                      style: TextStyle(
                        fontFamily: 'Jost',
                      ),
                    )
                  ],
                ),
              ),
            );
            
          } else {

            //SÍ NO HAY NADA ESCRITO EN EL BUSCADOR, MOSTRAMOS TODOS LOS CONTACTOS DE  LA LISTA contactos
            if(ControlerContacto.text == ""){
              return CardContactos(
                contactos[i]['nombreContacto'], 
                contactos[i]['telefono'],
                doctores
              );
            } else {
              //SÍ HAY ALGO ESCRITO EN EL BUSCADOR, VAMOS A MOSTRAR LA LISTA resultadosBusqueda

              //PRIMERO VALIDAMOS QUE HAYA RESULTADOS EN LA LISTA resultadosBusqueda, Y SÍ LO HAY, LO MOSTRAMOS
              if(resultadoBusqueda != null && resultadoBusqueda.length >= 1){
                return CardContactos(
                  resultadoBusqueda[i]['nombreContacto'], 
                  resultadoBusqueda[i]['telefono'],
                  doctores
                );

              } else {
                //SÍ NO HAY RESULTADOS DE BÚSQUEDA, MOSTRAMOS UN MENSAJE DE QUE NO EXISTE NINGÚN CONTACTO CON ESE NOMBRE
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 180),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.account_circle, size: 35, color: Colors.grey,),
                        SizedBox(height: 20,),
                        Text(
                          "No existe el contacto ${ControlerContacto.text}",
                          style: TextStyle(
                            fontFamily: 'Jost',
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }

            }
          }
          
              
        },
        itemCount: (datosCargados) ? 
                      (resultadoBusqueda != null && ControlerContacto.text != "") ?
                          (resultadoBusqueda.length >= 1) ? resultadoBusqueda.length : 1 
                          :
                          (contactos != null && contactos.length >= 1) ?
                            contactos.length :
                            1
                    :
                      1
      );

    final botonActualizarContactos = IconButton(
      icon: Icon(Icons.cached, size: 30,color: Color(0xFFB3B3B3)),
      onPressed: (){

      },
    );

    final botonEliminarTextoBusqueda = IconButton(
      icon: Icon(
        FontAwesomeIcons.times,
        color: Color(0xFFB3B3B3),
        size: 28,
      ), 
      onPressed: (){
        if(ControlerContacto.text != ""){
          setState((){
            resultadoBusqueda = null;
            ControlerContacto.text = "";
            datosCargados = true;
          });
        } 
      }
    );

    return Scaffold(
      appBar: AppBar(
        title: inputBuscador,
        backgroundColor: Color(0xFFdae292),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          botonEliminarTextoBusqueda
          //botonActualizarContactos
        ],
      ),
      body: listaContactos
    );
  }
}