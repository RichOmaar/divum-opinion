import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class CardDoctores extends StatelessWidget{

  String nombreDoctor;
  String urlImagen;
  String especialidad;
  String idDoctor;
  var datosContacto;
  

  CardDoctores(this.nombreDoctor,this.urlImagen,this.especialidad,this.idDoctor,this.datosContacto);

  void enviarEnlace(String nombre, String numero, String idDoctor) async{
    var rng = new Random();
    var numAleatorio = rng.nextInt(500);

    var url = "https://divumclinic.com/opinion/app/insertarConsulta.app.php";

    http.Response respuesta = await http.post(
      url,
      body: {
        "nombreCliente":nombre,
        "numero":numero.toString(),
        "token":numAleatorio.toString(),
        "idDoctor":idDoctor
      }
    );

    print(respuesta.body);

    var _respuesta = jsonDecode(respuesta.body);

    if(_respuesta['response'] == "success"){
      var enlace = "Gracias por tu visita, puedes dar tu opinión sobre el servicio aquí: https://divumclinic.com/opinion/?token=$numAleatorio";

      numero = numero.replaceAll("(","");
      numero = numero.replaceAll(")","");
      numero = numero.replaceAll(" ","");

      if(numero[0] != "+"){
        numero = "+521${numero.substring(0)}";
      }

      print(numero);

      var whatsappUrl ="whatsapp://send?phone=$numero&text=$enlace";
      await canLaunch(whatsappUrl) ? launch(whatsappUrl) : print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
    }

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        enviarEnlace(datosContacto[0].toString(), datosContacto[1].toString(), idDoctor.toString());
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 10
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50,
                backgroundImage: NetworkImage(urlImagen),
                ),
              ),
            Container(
              padding: EdgeInsets.only(
                top: 10
              ),
              child: 
              Text(nombreDoctor)
            ),
            Container(
              padding: EdgeInsets.only(
                top: 10
              ),
              child: 
              Text(especialidad)
            ),
          ],
        ),
      ),
    );
  }
}

