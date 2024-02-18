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

class Site_Vue_Popup extends StatefulWidget {
  final bool bFact;
  final String wChamps;
  const Site_Vue_Popup({Key? key, required this.bFact, required this.wChamps}) : super(key: key);

  @override
  _Site_Vue_PopupState createState() => _Site_Vue_PopupState();
}

class _Site_Vue_PopupState extends State<Site_Vue_Popup> {
  String wTitle = "";

  String wSite_Nom = "";


  String wSite_Adr1 = "";
  String wSite_Adr2 = "";
  String wSite_Adr3 = "";
  String wSite_Adr4 = "";
  String wSite_CP = "";
  String wSite_Ville = "";
  String wSite_Pays = "";


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
    wSite_Nom = Srv_DbTools.gSite.Site_Nom;


    wSite_Adr1 = Srv_DbTools.gSite.Site_Adr1;
    wSite_Adr2 = Srv_DbTools.gSite.Site_Adr2;
    wSite_Adr3 = Srv_DbTools.gSite.Site_Adr3;
    wSite_Adr4 = Srv_DbTools.gSite.Site_Adr4;
    wSite_CP = Srv_DbTools.gSite.Site_CP;
    wSite_Ville = Srv_DbTools.gSite.Site_Ville;
    wSite_Pays = Srv_DbTools.gSite.Site_Pays;

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

    if (widget.wChamps.compareTo("Site_Nom") == 0) {
      wTitle = "Nom";
      Ctrl = Column(
        children: [
          gColors.wLigne(),
          EdtTxt(widget.wChamps),
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
          EdtTxt("Site_Adr1"),
          gColors.wLigne(),
          EdtTxt("Site_Adr2"),
          gColors.wLigne(),
          EdtTxt("Site_Adr3"),
          gColors.wLigne(),
          EdtTxt("Site_Adr4"),
          gColors.wLigne(),
          EdtTxt("Site_CP"),
          gColors.wLigne(),
          EdtTxt("Site_Ville"),
          gColors.wLigne(),
          EdtTxt("Site_Pays"),
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
        surfaceTintColor: Colors.white,
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

              Srv_DbTools.gSite.Site_Nom = wSite_Nom;
              Srv_DbTools.gSite.Site_Adr1 = wSite_Adr1;
              Srv_DbTools.gSite.Site_Adr2 = wSite_Adr2;
              Srv_DbTools.gSite.Site_Adr3 = wSite_Adr3;
              Srv_DbTools.gSite.Site_Adr4 = wSite_Adr4;
              Srv_DbTools.gSite.Site_CP = wSite_CP;
              Srv_DbTools.gSite.Site_Ville = wSite_Ville;
              Srv_DbTools.gSite.Site_Pays = wSite_Pays;
              await Srv_DbTools.setSite(Srv_DbTools.gSite);


              Srv_DbTools.gContact.Contact_Civilite = wContact_Civilite;
              Srv_DbTools.gContact.Contact_Prenom = wContact_Prenom;
              Srv_DbTools.gContact.Contact_Nom = wContact_Nom;
              Srv_DbTools.gContact.Contact_Fonction = wContact_Fonction;
              Srv_DbTools.gContact.Contact_Service = wContact_Service;
              Srv_DbTools.gContact.Contact_Tel1 = wContact_Tel1;
              Srv_DbTools.gContact.Contact_Tel2 = wContact_Tel2;
              Srv_DbTools.gContact.Contact_eMail = wContact_eMail;
              await Srv_DbTools.setContact(Srv_DbTools.gContact);


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
    if (wChamps.compareTo("Site_Nom") == 0) {
      txtController.text = wSite_Nom;
      hintText = "Nom";
    }


    if (wChamps.compareTo("Site_Adr1") == 0) {
      txtController.text = wSite_Adr1;
      hintText = "Adresse";
    }
    if (wChamps.compareTo("Site_Adr2") == 0) {
      txtController.text = wSite_Adr2;
      hintText = "Adresse (Suite)";
    }
    if (wChamps.compareTo("Site_Adr3") == 0) {
      txtController.text = wSite_Adr3;
      hintText = "Adresse (Suite)";
    }
    if (wChamps.compareTo("Site_Adr4") == 0) {
      txtController.text = wSite_Adr4;
      hintText = "Adresse (Fin)";
    }
    if (wChamps.compareTo("Site_CP") == 0) {
      txtController.text = wSite_CP;
      hintText = "Cp";
    }
    if (wChamps.compareTo("Site_Ville") == 0) {
      txtController.text = wSite_Ville;
      hintText = "Ville";
    }
    if (wChamps.compareTo("Site_Pays") == 0) {
      txtController.text = wSite_Pays;
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
                    if (wChamps.compareTo("Site_Nom") == 0) {
                      wSite_Nom = txtController.text;
                    }


                    if (wChamps.compareTo("Site_Adr1") == 0) {
                      wSite_Adr1 = txtController.text;
                    }
                    if (wChamps.compareTo("Site_Adr2") == 0) {
                      wSite_Adr2 = txtController.text;
                    }
                    if (wChamps.compareTo("Site_Adr3") == 0) {
                      wSite_Adr3 = txtController.text;
                    }
                    if (wChamps.compareTo("Site_Adr4") == 0) {
                      wSite_Adr4 = txtController.text;
                    }
                    if (wChamps.compareTo("Site_CP") == 0) {
                      wSite_CP = txtController.text;
                    }
                    if (wChamps.compareTo("Site_Ville") == 0) {
                      wSite_Ville = txtController.text;
                    }
                    if (wChamps.compareTo("Site_Pays") == 0) {
                      wSite_Pays = txtController.text;
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

    wSite_Adr1 = Api_Gouv.gProperties.name!;
    wSite_CP = Api_Gouv.gProperties.postcode!;
    wSite_Ville = Api_Gouv.gProperties.city!;
    wSite_Pays = "France";
    setState(() {});
  }



}