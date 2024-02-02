import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:verifplus/Tools/Api_Gouv.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

//**********************************
//**********************************
//**********************************

class Groupe_Vue_Popup extends StatefulWidget {
  final bool bFact;
  final String wChamps;
  const Groupe_Vue_Popup({Key? key, required this.bFact, required this.wChamps}) : super(key: key);

  @override
  _Groupe_Vue_PopupState createState() => _Groupe_Vue_PopupState();
}

class _Groupe_Vue_PopupState extends State<Groupe_Vue_Popup> {
  String wTitle = "";

  String wGroupe_Nom = "";


  String wGroupe_Adr1 = "";
  String wGroupe_Adr2 = "";
  String wGroupe_Adr3 = "";
  String wGroupe_Adr4 = "";
  String wGroupe_CP = "";
  String wGroupe_Ville = "";
  String wGroupe_Pays = "";


  String wContact_Civilite = "";
  String wContact_Prenom = "";
  String wContact_Nom = "";
  String wContact_Fonction = "";
  String wContact_Service = "";
  String wContact_Tel1 = "";
  String wContact_Tel2 = "";
  String wContact_eMail = "";

  TextEditingController textController_Adresse_Geo = TextEditingController();

  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    wGroupe_Nom = Srv_DbTools.gGroupe.Groupe_Nom;

    wGroupe_Adr1 = Srv_DbTools.gGroupe.Groupe_Adr1;
    wGroupe_Adr2 = Srv_DbTools.gGroupe.Groupe_Adr2;
    wGroupe_Adr3 = Srv_DbTools.gGroupe.Groupe_Adr3;
    wGroupe_Adr4 = Srv_DbTools.gGroupe.Groupe_Adr4;
    wGroupe_CP = Srv_DbTools.gGroupe.Groupe_CP;
    wGroupe_Ville = Srv_DbTools.gGroupe.Groupe_Ville;
    wGroupe_Pays = Srv_DbTools.gGroupe.Groupe_Pays;

    wContact_Civilite = Srv_DbTools.gContact.Contact_Civilite;
    wContact_Prenom = Srv_DbTools.gContact.Contact_Prenom;
    wContact_Nom = Srv_DbTools.gContact.Contact_Nom;
    wContact_Fonction = Srv_DbTools.gContact.Contact_Fonction;
    wContact_Service = Srv_DbTools.gContact.Contact_Service;
    wContact_Tel1 = Srv_DbTools.gContact.Contact_Tel1;
    wContact_Tel2 = Srv_DbTools.gContact.Contact_Tel2;
    wContact_eMail = Srv_DbTools.gContact.Contact_eMail;

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();

    double wDialogHeight = 160;

    if (widget.wChamps.compareTo("Groupe_Nom") == 0) {
      wTitle = "Nom";
      Ctrl = Column(
        children: [
          gColors.wLigne(),
          EdtTxt("Groupe_Nom"),
          gColors.wLigne(),
        ],
      );
    }


    if (widget.wChamps.compareTo("Adresse") == 0) {
      wTitle = "Adresse";
      wDialogHeight = 650;
      Ctrl = Column(
        children: [
          gColors.wLigne(),
          Container(
            height: 44,
            width: 450,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: AutoAdresseFact(textController_Adresse_Geo),
          ),

          gColors.wLigne(),
          EdtTxt("Groupe_Adr1"),
          gColors.wLigne(),
          EdtTxt("Groupe_Adr2"),
          gColors.wLigne(),
          EdtTxt("Groupe_Adr3"),
          gColors.wLigne(),
          EdtTxt("Groupe_Adr4"),
          gColors.wLigne(),
          EdtTxt("Groupe_CP"),
          gColors.wLigne(),
          EdtTxt("Groupe_Ville"),
          gColors.wLigne(),
          EdtTxt("Groupe_Pays"),
          gColors.wLigne(),
        ],
      );
    }


    if (widget.wChamps.compareTo("Contact") == 0) {
      wTitle = "Contact de facturation";
      wDialogHeight = 664;
      Ctrl = Column(
        children: [
          gColors.wLigne(),
          EdtTxt("Contact_Civilite"),
          gColors.wLigne(),
          EdtTxt("Contact_Prenom"),
          gColors.wLigne(),
          EdtTxt("Contact_Nom"),
          gColors.wLigne(),
          EdtTxt("Contact_Fonction"),
          gColors.wLigne(),
          EdtTxt("Contact_Service"),
          gColors.wLigne(),
          EdtTxt("Contact_Tel1"),
          gColors.wLigne(),
          EdtTxt("Contact_Tel2"),
          gColors.wLigne(),
          EdtTxt("Contact_eMail"),
          gColors.wLigne(),
        ],
      );
    }

    print("Contact     Srv_DbTools.gContact.Contact_Nom       ${Srv_DbTools.gContact.Contact_Nom}     ${wContact_Nom}");


    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
        backgroundColor: gColors.white,
        title: Container(
            color: gColors.white,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Column(
              children: [
                Text(
                  "${wTitle}",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_G_20,
                ),
                Container(
                  height: 8,
                ),
              ],
            )),
        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
        content:
        SingleChildScrollView( // won't be scrollable
          child:
          Container(
              color: gColors.greyLight,
              height: wDialogHeight,
//          width: 600,
              child: Column(
                children: [
                  Container(
                    color: gColors.black,
                    height: 1,
                  ),
                  Container(
                    color: gColors.greyLight,
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Ctrl,
                  ),
                  Spacer(),
                  Container(
                    color: gColors.black,
                    height: 1,
                  ),
                  Valider(context),
                ],
              )),
        )
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),
      width: 480,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_N_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              print("VALIDER");

              Srv_DbTools.gGroupe.Groupe_Nom = wGroupe_Nom;
              Srv_DbTools.gGroupe.Groupe_Adr1 = wGroupe_Adr1;
              Srv_DbTools.gGroupe.Groupe_Adr2 = wGroupe_Adr2;
              Srv_DbTools.gGroupe.Groupe_Adr3 = wGroupe_Adr3;
              Srv_DbTools.gGroupe.Groupe_Adr4 = wGroupe_Adr4;
              Srv_DbTools.gGroupe.Groupe_CP = wGroupe_CP;
              Srv_DbTools.gGroupe.Groupe_Ville = wGroupe_Ville;
              Srv_DbTools.gGroupe.Groupe_Pays = wGroupe_Pays;
              await Srv_DbTools.setGroupe(Srv_DbTools.gGroupe);


              Srv_DbTools.gContact.Contact_Civilite = wContact_Civilite;
              Srv_DbTools.gContact.Contact_Prenom = wContact_Prenom;
              Srv_DbTools.gContact.Contact_Nom = wContact_Nom;
              Srv_DbTools.gContact.Contact_Fonction = wContact_Fonction;
              Srv_DbTools.gContact.Contact_Service = wContact_Service;
              Srv_DbTools.gContact.Contact_Tel1 = wContact_Tel1;
              Srv_DbTools.gContact.Contact_Tel2 = wContact_Tel2;
              Srv_DbTools.gContact.Contact_eMail = wContact_eMail;
              await  Srv_DbTools.setContact(Srv_DbTools.gContact);


              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }

  //**************************************************
  //**************************************************
  //**************************************************

  Widget EdtTxt(String wChamps) {
    final txtController = TextEditingController();
    String hintText = "";
    if (wChamps.compareTo("Groupe_Nom") == 0) {
      txtController.text = wGroupe_Nom;
      hintText = "Nom";
    }


    if (wChamps.compareTo("Groupe_Adr1") == 0) {
      txtController.text = wGroupe_Adr1;
      hintText = "Adresse";
    }
    if (wChamps.compareTo("Groupe_Adr2") == 0) {
      txtController.text = wGroupe_Adr2;
      hintText = "Adresse (Suite)";
    }
    if (wChamps.compareTo("Groupe_Adr3") == 0) {
      txtController.text = wGroupe_Adr3;
      hintText = "Adresse (Suite)";
    }
    if (wChamps.compareTo("Groupe_Adr4") == 0) {
      txtController.text = wGroupe_Adr4;
      hintText = "Adresse (Fin)";
    }
    if (wChamps.compareTo("Groupe_CP") == 0) {
      txtController.text = wGroupe_CP;
      hintText = "Cp";
    }
    if (wChamps.compareTo("Groupe_Ville") == 0) {
      txtController.text = wGroupe_Ville;
      hintText = "Ville";
    }
    if (wChamps.compareTo("Groupe_Pays") == 0) {
      txtController.text = wGroupe_Pays;
      hintText = "Pays";
    }


    if (wChamps.compareTo("Contact_Civilite") == 0) {
      txtController.text = wContact_Civilite;
      hintText = "Civilite";
    }
    if (wChamps.compareTo("Contact_Prenom") == 0) {
      txtController.text = wContact_Prenom;
      hintText = "Prenom";
    }
    if (wChamps.compareTo("Contact_Nom") == 0) {
      txtController.text = wContact_Nom;
      hintText = "Nom";
    }
    if (wChamps.compareTo("Contact_Fonction") == 0) {
      txtController.text = wContact_Fonction;
      hintText = "Fonction";
    }
    if (wChamps.compareTo("Contact_Service") == 0) {
      txtController.text = wContact_Service;
      hintText = "Service";
    }
    if (wChamps.compareTo("Contact_Tel1") == 0) {
      txtController.text = wContact_Tel1;
      hintText = "Tel FIXE";
    }
    if (wChamps.compareTo("Contact_Tel2") == 0) {
      txtController.text = wContact_Tel2;
      hintText = "PORTABLE";
    }
    if (wChamps.compareTo("Contact_eMail") == 0) {
      txtController.text = wContact_eMail;
      hintText = "EMail";
    }


    return new Container(
      height: 50,
      width: 450,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        color: gColors.white,
        border: Border.all(
          /**/
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Card(
          color: gColors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${hintText}",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_Gr,
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: txtController,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
//                  hintText: hintText,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 10.0),
                  ),
                  onChanged: (value) async {
                    await HapticFeedback.vibrate();
                    if (wChamps.compareTo("Groupe_Nom") == 0) {
                      wGroupe_Nom = txtController.text;
                    }


                    if (wChamps.compareTo("Groupe_Adr1") == 0) {
                      wGroupe_Adr1 = txtController.text;
                    }
                    if (wChamps.compareTo("Groupe_Adr2") == 0) {
                      wGroupe_Adr2 = txtController.text;
                    }
                    if (wChamps.compareTo("Groupe_Adr3") == 0) {
                      wGroupe_Adr3 = txtController.text;
                    }
                    if (wChamps.compareTo("Groupe_Adr4") == 0) {
                      wGroupe_Adr4 = txtController.text;
                    }
                    if (wChamps.compareTo("Groupe_CP") == 0) {
                      wGroupe_CP = txtController.text;
                    }
                    if (wChamps.compareTo("Groupe_Ville") == 0) {
                      wGroupe_Ville = txtController.text;
                    }
                    if (wChamps.compareTo("Groupe_Pays") == 0) {
                      wGroupe_Pays = txtController.text;
                    }


                    if (wChamps.compareTo("Contact_Civilite") == 0) {
                      wContact_Civilite = txtController.text;
                    }
                    if (wChamps.compareTo("Contact_Prenom") == 0) {
                      wContact_Prenom = txtController.text;
                    }
                    if (wChamps.compareTo("Contact_Nom") == 0) {
                      wContact_Nom = txtController.text;
                    }
                    if (wChamps.compareTo("Contact_Fonction") == 0) {
                      wContact_Fonction = txtController.text;
                    }
                    if (wChamps.compareTo("Contact_Service") == 0) {
                      wContact_Service = txtController.text;
                    }
                    if (wChamps.compareTo("Contact_Tel1") == 0) {
                      wContact_Tel1 = txtController.text;
                    }
                    if (wChamps.compareTo("Contact_Tel2") == 0) {
                      wContact_Tel2 = txtController.text;
                    }
                    if (wChamps.compareTo("Contact_eMail") == 0) {
                      wContact_eMail = txtController.text;
                    }
                  },
                ),
              ),

            ],
          )),
    );
  }

  Widget AutoAdresseFact(TextEditingController textEditingController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.search,
          color: Colors.black,
          size: 30,
        ),
        Expanded(
          child: Container(
              child: TypeAheadField(
                animationStart: 0,
                animationDuration: Duration.zero,
                textFieldConfiguration: TextFieldConfiguration(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                  ),
                ),
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  color: Colors.white,
                ),
                suggestionsCallback: (pattern) async {
                  await Api_Gouv.ApiAdresse(textController_Adresse_Geo.text);
                  List<String> matches = <String>[];
                  Api_Gouv.properties.forEach((propertie) {
                    matches.add(propertie.label!);
                  });
                  return matches;
                },
                itemBuilder: (context, sone) {
                  return Card(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(sone.toString()),
                      ));
                },
                onSuggestionSelected: (suggestion) {
                  Api_Gouv.properties.forEach((propertie) {
                    if (propertie.label!.compareTo(suggestion.toString()) == 0) {
                      Api_Gouv.gProperties = propertie;
                    }
                  });
                  textController_Adresse_Geo.text = suggestion.toString();
                },
              )),
        ),
        gObj.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.arrow_downward, ToolsBarCopySearchFact),
      ],
    );
  }

  void ToolsBarCopySearchFact() async {
    print("ToolsBarCopySearchFact ${Api_Gouv.gProperties.toJson()}");

    wGroupe_Adr1 = Api_Gouv.gProperties.name!;
    wGroupe_CP = Api_Gouv.gProperties.postcode!;
    wGroupe_Ville = Api_Gouv.gProperties.city!;
    wGroupe_Pays = "France";
    setState(() {});
  }



}