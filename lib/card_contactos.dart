import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'card_doctores.dart';

class CardContactos extends StatefulWidget{

  String nombreContacto;
  String telefonoContacto;
  var doctores;
  
  CardContactos(this.nombreContacto,this.telefonoContacto, this.doctores);

  @override
  State<StatefulWidget> createState() {
    return _CardContactos(nombreContacto, telefonoContacto, doctores);
  }
}

class _CardContactos extends State <CardContactos> {

  String nombreContacto;
  String telefonoContacto;
  var doctores;
  
  _CardContactos(this.nombreContacto,this.telefonoContacto, this.doctores);

  final _formKey = GlobalKey<FormState>();

  void ventanaDoctores(){
    showDialog(
      context: context,
      builder: (BuildContext context) {

        var datosContacto = [];
        datosContacto.add(nombreContacto);
        datosContacto.add(telefonoContacto);

        return AlertDialog(
          content: Container(
            width: 300,
            height: 600,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int i){

                if( (doctores.length - 1) == i){
                  return CardDoctores(
                    doctores[i]['nombre'], 
                    doctores[i]['foto'], 
                    doctores[i]['especialidad'],
                    doctores[i]['id_doctor'],
                    datosContacto
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      CardDoctores(
                        doctores[i]['nombre'], 
                        doctores[i]['foto'], 
                        doctores[i]['especialidad'],
                        doctores[i]['id_doctor'],
                        datosContacto
                      ),
                      Divider(
                        thickness: 3,
                        color: Color(0xFFdbe387),
                      )
                    ],
                  );
                }       
              },
              itemCount: doctores.length,
            ),
          )
        );
      });
  }

  @override
  Widget build(BuildContext context) {

    final _imagenContacto = Image.network(
      "https://divumclinic.com/opinion/vista/assets/image/contacto.png",
      width: 50,
    );

    final _nombreContacto = Text('$nombreContacto', style: TextStyle(fontFamily: 'Jost', fontSize: 16),);

    final _numeroContacto = Text('$telefonoContacto', style: TextStyle(fontFamily: 'Jost',),);

    final _cardContacto = Container(
        padding: EdgeInsets.only(
          left: 20
        ),
        
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                _nombreContacto,
                _numeroContacto,
            ],
        ),
    );

    return InkWell(
      onTap: (){
        ventanaDoctores();
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: 15
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                _imagenContacto,
                _cardContacto,
              ],
            ),
          ],
        )
      ),
    );
  }
}