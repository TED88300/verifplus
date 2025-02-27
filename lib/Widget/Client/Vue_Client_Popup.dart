import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:verifplus/Tools/Api_Gouv.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

//**********************************
//**********************************
//**********************************

class Client_Vue_Popup extends StatefulWidget {
  final bool bFact;
  final String wChamps;
  const Client_Vue_Popup({Key? key, required this.bFact, required this.wChamps}) : super(key: key);

  @override
  _Client_Vue_PopupState createState() => _Client_Vue_PopupState();
}

class _Client_Vue_PopupState extends State<Client_Vue_Popup> {
  String wTitle = "";

  String wClientNom = "";
  bool wClient_CL_Pr = false;
  String wClient_Famille = "";
  String wClient_Depot = "";
  String wClient_Rglt = "";
  bool wClient_OK_DataPerso = false;

  String wClient_Siret = "";
  String wClient_NAF = "";
  String wClient_TVA = "";

  String wClient_Commercial = "";

  String wAdresse_Adr1 = "";
  String wAdresse_Adr2 = "";
  String wAdresse_Adr3 = "";
  String wAdresse_Adr4 = "";
  String wAdresse_CP = "";
  String wAdresse_Ville = "";
  String wAdresse_Pays = "";

  String wLivr_Adresse_Adr1 = "";
  String wLivr_Adresse_Adr2 = "";
  String wLivr_Adresse_Adr3 = "";
  String wLivr_Adresse_Adr4 = "";
  String wLivr_Adresse_CP = "";
  String wLivr_Adresse_Ville = "";
  String wLivr_Adresse_Pays = "";

  String wContact_Civilite = "";
  String wContact_Prenom = "";
  String wContact_Nom = "";
  String wContact_Fonction = "";
  String wContact_Service = "";
  String wContact_Tel1 = "";
  String wContact_Tel2 = "";
  String wContact_eMail = "";

  String wLivr_Contact_Civilite = "";
  String wLivr_Contact_Prenom = "";
  String wLivr_Contact_Nom = "";
  String wLivr_Contact_Fonction = "";
  String wLivr_Contact_Service = "";
  String wLivr_Contact_Tel1 = "";
  String wLivr_Contact_Tel2 = "";
  String wLivr_Contact_eMail = "";

  String selectedValueFam = "";
  String selectedValueFamID = "";
  List<String> ListParam_ParamFam = [];
  List<String> ListParam_ParamFamID = [];

  List<String> ListParam_ParamDepot = [];
  String selectedValueDepot = "";

  List<String> ListParam_ParamRglt = [];
  String selectedValueRglt = "";


  List<String> ListParam_ParamUser = [];
  List<String> ListParam_ParamUserFam = [];
  List<String> ListParam_ParamUserID = [];
  String selectedValueUser = "";
  String selectedValueUserID = "";

  TextEditingController textController_Adresse_Geo = TextEditingController();

  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    await Srv_DbTools.getParam_ParamFam("FamClient");

    ListParam_ParamFam.clear();
    ListParam_ParamFam.addAll(Srv_DbTools.ListParam_ParamFam);
    ListParam_ParamFamID.clear();
    ListParam_ParamFamID.addAll(Srv_DbTools.ListParam_ParamFamID);



    selectedValueFam = ListParam_ParamFam[0];
    selectedValueFamID = ListParam_ParamFamID[0];

/*
    print("wClient_Famille ${wClient_Famille}");
    if (wClient_Famille.isNotEmpty) {
      selectedValueFam = wClient_Famille;
    }
*/

    for (int i = 0; i < ListParam_ParamFam.length; i++) {
      String element = ListParam_ParamFam[i];
      if (element.compareTo(wClient_Famille) == 0) {
        selectedValueFam = element;
        selectedValueFamID = ListParam_ParamFamID[i];
      }
    }




    await DbTools.getAdresseType( "AGENCE");
    ListParam_ParamDepot.clear();
    for (var wAdresse in Srv_DbTools.ListAdressesearchresult) {
      ListParam_ParamDepot.add(wAdresse.Adresse_Nom);
    }

    selectedValueDepot = ListParam_ParamDepot[0];
    for (int i = 0; i < ListParam_ParamDepot.length; i++) {
      String element = ListParam_ParamDepot[i];
      if (element.compareTo(wClient_Depot) == 0) {
        selectedValueDepot = element;
      }
    }

    await Srv_DbTools.getParam_ParamFam("RgltClient");
    ListParam_ParamRglt.clear();
    ListParam_ParamRglt.addAll(Srv_DbTools.ListParam_ParamFam);

    selectedValueRglt = ListParam_ParamRglt[0];
    for (int i = 0; i < ListParam_ParamRglt.length; i++) {
      String element = ListParam_ParamRglt[i];
      if (element.compareTo(wClient_Rglt) == 0) {
        selectedValueRglt = element;
      }
    }


    ListParam_ParamUser.clear();
    ListParam_ParamUserFam.clear();
    ListParam_ParamUserID.clear();

    await Srv_DbTools.getUserAll();
    for (var element in Srv_DbTools.ListUser) {
      ListParam_ParamUser.add("${element.User_Nom} ${element.User_Prenom}");
      ListParam_ParamUserFam.add("${element.User_Famille} ");
      ListParam_ParamUserID.add("${element.UserID}");
    }
    selectedValueUser = ListParam_ParamUser[0];
    selectedValueUserID = ListParam_ParamUserID[0];

    for (int i = 0; i < ListParam_ParamUser.length; i++) {
      String element = ListParam_ParamUser[i];
      if (element.compareTo(wClient_Commercial) == 0) {
        selectedValueUser = element;
        selectedValueUserID = ListParam_ParamUserID[i];
      }
    }


    Reload();
  }

  @override
  void initState() {
    wClientNom = Srv_DbTools.gClient.Client_Nom;
    wClient_CL_Pr = Srv_DbTools.gClient.Client_CL_Pr;
    wClient_Famille = Srv_DbTools.gClient.Client_Famille;
    wClient_Depot = Srv_DbTools.gClient.Client_Depot;
    wClient_Rglt = Srv_DbTools.gClient.Client_Rglt;
    wClient_OK_DataPerso = Srv_DbTools.gClient.Client_OK_DataPerso;
    wClient_Siret = Srv_DbTools.gClient.Client_Siret;
    wClient_NAF = Srv_DbTools.gClient.Client_NAF;
    wClient_TVA = Srv_DbTools.gClient.Client_TVA;
    wClient_Commercial = Srv_DbTools.gClient.Client_Commercial;

    wAdresse_Adr1 = Srv_DbTools.gAdresse.Adresse_Adr1;
    wAdresse_Adr2 = Srv_DbTools.gAdresse.Adresse_Adr2;
    wAdresse_Adr3 = Srv_DbTools.gAdresse.Adresse_Adr3;
    wAdresse_Adr4 = Srv_DbTools.gAdresse.Adresse_Adr4;
    wAdresse_CP = Srv_DbTools.gAdresse.Adresse_CP;
    wAdresse_Ville = Srv_DbTools.gAdresse.Adresse_Ville;
    wAdresse_Pays = Srv_DbTools.gAdresse.Adresse_Pays;

    wLivr_Adresse_Adr1 = Srv_DbTools.gAdresseLivr.Adresse_Adr1;
    wLivr_Adresse_Adr2 = Srv_DbTools.gAdresseLivr.Adresse_Adr2;
    wLivr_Adresse_Adr3 = Srv_DbTools.gAdresseLivr.Adresse_Adr3;
    wLivr_Adresse_Adr4 = Srv_DbTools.gAdresseLivr.Adresse_Adr4;
    wLivr_Adresse_CP = Srv_DbTools.gAdresseLivr.Adresse_CP;
    wLivr_Adresse_Ville = Srv_DbTools.gAdresseLivr.Adresse_Ville;
    wLivr_Adresse_Pays = Srv_DbTools.gAdresseLivr.Adresse_Pays;

    wContact_Civilite = Srv_DbTools.gContact.Contact_Civilite;
    wContact_Prenom = Srv_DbTools.gContact.Contact_Prenom;
    wContact_Nom = Srv_DbTools.gContact.Contact_Nom;
    wContact_Fonction = Srv_DbTools.gContact.Contact_Fonction;
    wContact_Service = Srv_DbTools.gContact.Contact_Service;
    wContact_Tel1 = Srv_DbTools.gContact.Contact_Tel1;
    wContact_Tel2 = Srv_DbTools.gContact.Contact_Tel2;
    wContact_eMail = Srv_DbTools.gContact.Contact_eMail;

    wLivr_Contact_Civilite = Srv_DbTools.gContactLivr.Contact_Civilite;
    wLivr_Contact_Prenom = Srv_DbTools.gContactLivr.Contact_Prenom;
    wLivr_Contact_Nom = Srv_DbTools.gContactLivr.Contact_Nom;
    wLivr_Contact_Fonction = Srv_DbTools.gContactLivr.Contact_Fonction;
    wLivr_Contact_Service = Srv_DbTools.gContactLivr.Contact_Service;
    wLivr_Contact_Tel1 = Srv_DbTools.gContactLivr.Contact_Tel1;
    wLivr_Contact_Tel2 = Srv_DbTools.gContactLivr.Contact_Tel2;
    wLivr_Contact_eMail = Srv_DbTools.gContactLivr.Contact_eMail;

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();

    double wDialogHeight = 450;

    print("widget.wChamps ${widget.wChamps}");

    print("ListParam_ParamFam BBB ${ListParam_ParamFam.length}");


    if (widget.wChamps.compareTo("Client_Nom") == 0) {
      wTitle = "Nom";
      Ctrl = Column(
        children: [
          gColors.wLigne(),
          CheckBox("Client_CL"),
          gColors.wLigne(),
          CheckBox("Client_Pr"),
          gColors.wLigne(),
          EdtTxt(widget.wChamps),
          gColors.wLigne(),
          DropdownButton("Client_Famille"),
          gColors.wLigne(),
          DropdownButton("Client_Depot"),
          gColors.wLigne(),
          DropdownButton("Client_Rglt"),
          gColors.wLigne(),
          CheckBox("Client_OK_DataPerso"),
          gColors.wLigne(),
        ],
      );
    }

    if (widget.wChamps.compareTo("Client_Commercial") == 0) {
      wTitle = "Commercial";
      wDialogHeight = 125;
      Ctrl = Column(
        children: [
          gColors.wLigne(),
          DropdownButton("Client_Commercial"),
          gColors.wLigne(),
        ],
      );
    }

    if (widget.wChamps.compareTo("Client_Siret") == 0) {
      wTitle = "Siret";
      wDialogHeight = 320;
      Ctrl = Column(
        children: [
          gColors.wLigne(),
          EdtTxt("Client_Siret"),
          gColors.wLigne(),
          EdtTxt("Client_NAF"),
          gColors.wLigne(),
          EdtTxt("Client_TVA"),
          gColors.wLigne(),
        ],
      );
    }

    if (widget.wChamps.compareTo("Adresse") == 0) {
      wTitle = "Adresse de facturation";
      wDialogHeight = 650;

      Ctrl = Column(
        children: [
          gColors.wLigne(),
          Container(
            height: 44,
            width: 450,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: AutoAdresseFact(textController_Adresse_Geo),
          ),
          gColors.wLigne(),
          EdtTxt("Adresse_Adr1"),
          gColors.wLigne(),
          EdtTxt("Adresse_Adr2"),
          gColors.wLigne(),
          EdtTxt("Adresse_Adr3"),
          gColors.wLigne(),
          EdtTxt("Adresse_Adr4"),
          gColors.wLigne(),
          EdtTxt("Adresse_CP"),
          gColors.wLigne(),
          EdtTxt("Adresse_Ville"),
          gColors.wLigne(),
          EdtTxt("Adresse_Pays"),
          gColors.wLigne(),
        ],
      );
    }

    if (widget.wChamps.compareTo("AdresseLivr") == 0) {
      wTitle = "Adresse de Livraison";
      wDialogHeight = 650;

      Ctrl = Column(
        children: [
          gColors.wLigne(),
          Container(
            height: 44,
            width: 450,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: AutoAdresseLivr(textController_Adresse_Geo),
          ),
          gColors.wLigne(),
          EdtTxt("Livr_Adresse_Adr1"),
          gColors.wLigne(),
          EdtTxt("Livr_Adresse_Adr2"),
          gColors.wLigne(),
          EdtTxt("Livr_Adresse_Adr3"),
          gColors.wLigne(),
          EdtTxt("Livr_Adresse_Adr4"),
          gColors.wLigne(),
          EdtTxt("Livr_Adresse_CP"),
          gColors.wLigne(),
          EdtTxt("Livr_Adresse_Ville"),
          gColors.wLigne(),
          EdtTxt("Livr_Adresse_Pays"),
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
          DropdownButtonCivFact(),
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

    if (widget.wChamps.compareTo("ContactLivr") == 0) {
      wTitle = "Contact de livraison";
      wDialogHeight = 664;

      Ctrl = Column(
        children: [
          gColors.wLigne(),
          DropdownButtonCivLivr(),
          gColors.wLigne(),
          EdtTxt("Livr_Contact_Prenom"),
          gColors.wLigne(),
          EdtTxt("Livr_Contact_Nom"),
          gColors.wLigne(),
          EdtTxt("Livr_Contact_Fonction"),
          gColors.wLigne(),
          EdtTxt("Livr_Contact_Service"),
          gColors.wLigne(),
          EdtTxt("Livr_Contact_Tel1"),
          gColors.wLigne(),
          EdtTxt("Livr_Contact_Tel2"),
          gColors.wLigne(),
          EdtTxt("Livr_Contact_eMail"),
          gColors.wLigne(),
        ],
      );
    }

    print("Contact     Srv_DbTools.gContact.Contact_Nom       ${Srv_DbTools.gContact.Contact_Nom}     $wContact_Nom");
    print("ContactLivr Srv_DbTools.gContactLivr.Contact_Nom   ${Srv_DbTools.gContactLivr.Contact_Nom} $wLivr_Contact_Nom");

    return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
        surfaceTintColor: Colors.white,
        backgroundColor: gColors.white,
        title: Container(
            color: gColors.white,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Column(
              children: [
                Text(
                  wTitle,
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_G_20,
                ),
                Container(
                  height: 8,
                ),
              ],
            )),
        contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
        content: SingleChildScrollView(
          // won't be scrollable
          child: Container(
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
                  const Spacer(),
                  Container(
                    color: gColors.black,
                    height: 1,
                  ),
                  Valider(context),
                ],
              )),
        ));
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
          (widget.wChamps.compareTo("Adresse") == 0 || widget.wChamps.compareTo("AdresseLivr") == 0 || widget.wChamps.compareTo("Contact") == 0 || widget.wChamps.compareTo("ContactLivr") == 0)
              ? ElevatedButton(
                  onPressed: () async {
// Copie
                    if (widget.wChamps.compareTo("Adresse") == 0 || widget.wChamps.compareTo("AdresseLivr") == 0)
                      {
                        Srv_DbTools.gAdresseLivr.Adresse_Adr1   = Srv_DbTools.gAdresse.Adresse_Adr1 ;
                        Srv_DbTools.gAdresseLivr.Adresse_Adr2   = Srv_DbTools.gAdresse.Adresse_Adr2 ;
                        Srv_DbTools.gAdresseLivr.Adresse_Adr3   = Srv_DbTools.gAdresse.Adresse_Adr3 ;
                        Srv_DbTools.gAdresseLivr.Adresse_Adr4   = Srv_DbTools.gAdresse.Adresse_Adr4 ;
                        Srv_DbTools.gAdresseLivr.Adresse_CP     = Srv_DbTools.gAdresse.Adresse_CP ;
                        Srv_DbTools.gAdresseLivr.Adresse_Ville  = Srv_DbTools.gAdresse.Adresse_Ville ;
                        Srv_DbTools.gAdresseLivr.Adresse_Pays   = Srv_DbTools.gAdresse.Adresse_Pays ;
                        await DbTools.updateAdresse(Srv_DbTools.gAdresseLivr);
                        bool wRes = await Srv_DbTools.setAdresse(Srv_DbTools.gAdresseLivr);
                        Srv_DbTools.gAdresseLivr.Adresse_isUpdate = wRes;
                        if (!wRes) DbTools.setBoolErrorSync(true);
                        await DbTools.updateAdresse(Srv_DbTools.gAdresseLivr);
                        print("VALIDER AdresseLivr wRes $wRes");

                      }

                    if (widget.wChamps.compareTo("Contact") == 0 || widget.wChamps.compareTo("ContactLivr") == 0)
                    {

                      Srv_DbTools.gContactLivr.Contact_Civilite  =Srv_DbTools.gContact.Contact_Civilite  ;
                      Srv_DbTools.gContactLivr.Contact_Prenom    =Srv_DbTools.gContact.Contact_Prenom    ;
                      Srv_DbTools.gContactLivr.Contact_Nom       =Srv_DbTools.gContact.Contact_Nom       ;
                      Srv_DbTools.gContactLivr.Contact_Fonction  =Srv_DbTools.gContact.Contact_Fonction  ;
                      Srv_DbTools.gContactLivr.Contact_Service   =Srv_DbTools.gContact.Contact_Service   ;
                      Srv_DbTools.gContactLivr.Contact_Tel1      =Srv_DbTools.gContact.Contact_Tel1      ;
                      Srv_DbTools.gContactLivr.Contact_Tel2      =Srv_DbTools.gContact.Contact_Tel2      ;
                      Srv_DbTools.gContactLivr.Contact_eMail     =Srv_DbTools.gContact.Contact_eMail     ;

                      await DbTools.updateContact(Srv_DbTools.gContact);
                      bool wRes = await  Srv_DbTools.setContact(Srv_DbTools.gContact);
                      Srv_DbTools.gContact.Contact_isUpdate = wRes;
                      if (!wRes) DbTools.setBoolErrorSync(true);
                      await DbTools.updateContact(Srv_DbTools.gContact);
                      print("VALIDER gContact wRes $wRes");

                    }

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primaryGreen,
                  ),
                  child: Text('Factutration / Livraison', style: gColors.bodyTitle1_N_W),
                )
              : Container(),
          const Spacer(),
          ElevatedButton(
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
          ElevatedButton(
            onPressed: () async {
              print("VALIDER");

              Srv_DbTools.gClient.Client_Nom = wClientNom;
              Srv_DbTools.gClient.Client_CL_Pr = wClient_CL_Pr;
              Srv_DbTools.gClient.Client_Famille = wClient_Famille;
              Srv_DbTools.gClient.Client_Depot = wClient_Depot;
              Srv_DbTools.gClient.Client_Rglt = wClient_Rglt;
              Srv_DbTools.gClient.Client_OK_DataPerso = wClient_OK_DataPerso;
              Srv_DbTools.gClient.Client_Siret = wClient_Siret;
              Srv_DbTools.gClient.Client_NAF = wClient_NAF;
              Srv_DbTools.gClient.Client_TVA = wClient_TVA;
              Srv_DbTools.gClient.Client_Commercial = wClient_Commercial;
              await DbTools.updateClients(Srv_DbTools.gClient);
              bool wRes = await Srv_DbTools.setClient(Srv_DbTools.gClient);
              print("•••• setClient $wRes");
              Srv_DbTools.gClient.Client_isUpdate = wRes;
              await DbTools.updateClients(Srv_DbTools.gClient);


              await DbTools.getClientsAll();

              Srv_DbTools.gAdresse.Adresse_Adr1 = wAdresse_Adr1;
              Srv_DbTools.gAdresse.Adresse_Adr2 = wAdresse_Adr2;
              Srv_DbTools.gAdresse.Adresse_Adr3 = wAdresse_Adr3;
              Srv_DbTools.gAdresse.Adresse_Adr4 = wAdresse_Adr4;
              Srv_DbTools.gAdresse.Adresse_CP = wAdresse_CP;
              Srv_DbTools.gAdresse.Adresse_Ville = wAdresse_Ville;
              Srv_DbTools.gAdresse.Adresse_Pays = wAdresse_Pays;

              await DbTools.updateAdresse(Srv_DbTools.gAdresse);
               wRes = await Srv_DbTools.setAdresse(Srv_DbTools.gAdresse);
              Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
              await DbTools.updateAdresse(Srv_DbTools.gAdresse);
              print("VALIDER Adresse wRes $wRes");


              Srv_DbTools.gAdresseLivr.Adresse_Adr1 = wLivr_Adresse_Adr1;
              Srv_DbTools.gAdresseLivr.Adresse_Adr2 = wLivr_Adresse_Adr2;
              Srv_DbTools.gAdresseLivr.Adresse_Adr3 = wLivr_Adresse_Adr3;
              Srv_DbTools.gAdresseLivr.Adresse_Adr4 = wLivr_Adresse_Adr4;
              Srv_DbTools.gAdresseLivr.Adresse_CP = wLivr_Adresse_CP;
              Srv_DbTools.gAdresseLivr.Adresse_Ville = wLivr_Adresse_Ville;
              Srv_DbTools.gAdresseLivr.Adresse_Pays = wLivr_Adresse_Pays;

              await DbTools.updateAdresse(Srv_DbTools.gAdresseLivr);
              wRes = await Srv_DbTools.setAdresse(Srv_DbTools.gAdresseLivr);
              print("•••• setAdresse wRes $wRes");
              Srv_DbTools.gAdresseLivr.Adresse_isUpdate = wRes;
              if (!wRes) DbTools.setBoolErrorSync(true);
              await DbTools.updateAdresse(Srv_DbTools.gAdresseLivr);
              print("VALIDER AdresseLivr wRes $wRes");

              await DbTools.getAdresseAll();

              Srv_DbTools.gContact.Contact_Civilite = wContact_Civilite;
              Srv_DbTools.gContact.Contact_Prenom = wContact_Prenom;
              Srv_DbTools.gContact.Contact_Nom = wContact_Nom;
              Srv_DbTools.gContact.Contact_Fonction = wContact_Fonction;
              Srv_DbTools.gContact.Contact_Service = wContact_Service;
              Srv_DbTools.gContact.Contact_Tel1 = wContact_Tel1;
              Srv_DbTools.gContact.Contact_Tel2 = wContact_Tel2;
              Srv_DbTools.gContact.Contact_eMail = wContact_eMail;
              await DbTools.updateContact(Srv_DbTools.gContact);
              wRes = await  Srv_DbTools.setContact(Srv_DbTools.gContact);
              print("•••• setContact wRes $wRes");
              Srv_DbTools.gContact.Contact_isUpdate = wRes;
              if (!wRes) DbTools.setBoolErrorSync(true);
              await DbTools.updateContact(Srv_DbTools.gContact);




              print("Contact     Srv_DbTools.gContactLivr.Contact_Nom       ${Srv_DbTools.gContactLivr.Contact_Nom}     $wLivr_Contact_Nom");
              Srv_DbTools.gContactLivr.Contact_Civilite   = wLivr_Contact_Civilite;
              Srv_DbTools.gContactLivr.Contact_Prenom     = wLivr_Contact_Prenom;
              Srv_DbTools.gContactLivr.Contact_Nom        = wLivr_Contact_Nom;
              Srv_DbTools.gContactLivr.Contact_Fonction   = wLivr_Contact_Fonction;
              Srv_DbTools.gContactLivr.Contact_Service    = wLivr_Contact_Service;
              Srv_DbTools.gContactLivr.Contact_Tel1       = wLivr_Contact_Tel1;
              Srv_DbTools.gContactLivr.Contact_Tel2       = wLivr_Contact_Tel2;
              Srv_DbTools.gContactLivr.Contact_eMail      = wLivr_Contact_eMail;

              await DbTools.updateContact(Srv_DbTools.gContactLivr);
              wRes = await  Srv_DbTools.setContact(Srv_DbTools.gContactLivr);
              print("•••• setContact LIVR  wRes $wRes");
              Srv_DbTools.gContactLivr.Contact_isUpdate = wRes;
              if (!wRes) DbTools.setBoolErrorSync(true);
              await DbTools.updateContact(Srv_DbTools.gContactLivr);



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
    if (wChamps.compareTo("Client_Nom") == 0) {
      txtController.text = wClientNom;
      hintText = "Nom";
    }
    if (wChamps.compareTo("Client_Siret") == 0) {
      txtController.text = wClient_Siret;
      hintText = "Siret";
    }
    if (wChamps.compareTo("Client_NAF") == 0) {
      txtController.text = wClient_NAF;
      hintText = "NAF";
    }
    if (wChamps.compareTo("Client_TVA") == 0) {
      txtController.text = wClient_TVA;
      hintText = "TVA";
    }

    if (wChamps.compareTo("Adresse_Adr1") == 0) {
      txtController.text = wAdresse_Adr1;
      hintText = "Adresse";
    }
    if (wChamps.compareTo("Adresse_Adr2") == 0) {
      txtController.text = wAdresse_Adr2;
      hintText = "Adresse (Suite)";
    }
    if (wChamps.compareTo("Adresse_Adr3") == 0) {
      txtController.text = wAdresse_Adr3;
      hintText = "Adresse (Suite)";
    }
    if (wChamps.compareTo("Adresse_Adr4") == 0) {
      txtController.text = wAdresse_Adr4;
      hintText = "Adresse (Fin)";
    }
    if (wChamps.compareTo("Adresse_CP") == 0) {
      txtController.text = wAdresse_CP;
      hintText = "Cp";
    }
    if (wChamps.compareTo("Adresse_Ville") == 0) {
      txtController.text = wAdresse_Ville;
      hintText = "Ville";
    }
    if (wChamps.compareTo("Adresse_Pays") == 0) {
      txtController.text = wAdresse_Pays;
      hintText = "Pays";
    }

    if (wChamps.compareTo("Livr_Adresse_Adr1") == 0) {
      txtController.text = wLivr_Adresse_Adr1;
      hintText = "Adresse";
    }
    if (wChamps.compareTo("Livr_Adresse_Adr2") == 0) {
      txtController.text = wLivr_Adresse_Adr2;
      hintText = "Adresse (Suite)";
    }
    if (wChamps.compareTo("Livr_Adresse_Adr3") == 0) {
      txtController.text = wLivr_Adresse_Adr3;
      hintText = "Adresse (Suite)";
    }
    if (wChamps.compareTo("Livr_Adresse_Adr4") == 0) {
      txtController.text = wLivr_Adresse_Adr4;
      hintText = "Adresse (Fin)";
    }
    if (wChamps.compareTo("Livr_Adresse_CP") == 0) {
      txtController.text = wLivr_Adresse_CP;
      hintText = "Cp";
    }
    if (wChamps.compareTo("Livr_Adresse_Ville") == 0) {
      txtController.text = wLivr_Adresse_Ville;
      hintText = "Ville";
    }
    if (wChamps.compareTo("Livr_Adresse_Pays") == 0) {
      txtController.text = wLivr_Adresse_Pays;
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

    if (wChamps.compareTo("Livr_Contact_Civilite") == 0) {
      txtController.text = wLivr_Contact_Civilite;
      hintText = "Civilite";
    }
    if (wChamps.compareTo("Livr_Contact_Prenom") == 0) {
      txtController.text = wLivr_Contact_Prenom;
      hintText = "Prenom";
    }
    if (wChamps.compareTo("Livr_Contact_Nom") == 0) {
      txtController.text = wLivr_Contact_Nom;
      hintText = "Nom";
    }
    if (wChamps.compareTo("Livr_Contact_Fonction") == 0) {
      txtController.text = wLivr_Contact_Fonction;
      hintText = "Fonction";
    }
    if (wChamps.compareTo("Livr_Contact_Service") == 0) {
      txtController.text = wLivr_Contact_Service;
      hintText = "Service";
    }
    if (wChamps.compareTo("Livr_Contact_Tel1") == 0) {
      txtController.text = wLivr_Contact_Tel1;
      hintText = "Tel FIXE";
    }
    if (wChamps.compareTo("Livr_Contact_Tel2") == 0) {
      txtController.text = wLivr_Contact_Tel2;
      hintText = "PORTABLE";
    }
    if (wChamps.compareTo("Livr_Contact_eMail") == 0) {
      txtController.text = wLivr_Contact_eMail;
      hintText = "EMail";
    }

    return Container(
      height: 50,
      width: 450,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        color: gColors.white,
        border: Border.all(
          /**/
          color: Colors.grey,
        ),
        borderRadius: const BorderRadius.all(
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
                hintText,
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_Gr,
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: txtController,
                  autofocus: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
//                  hintText: hintText,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 10.0),
                  ),
                  onChanged: (value) async {
                    await HapticFeedback.vibrate();
                    if (wChamps.compareTo("Client_Nom") == 0) {
                      wClientNom = txtController.text;
                    }
                    if (wChamps.compareTo("Client_Siret") == 0) {
                      wClient_Siret = txtController.text;
                    }
                    if (wChamps.compareTo("Client_NAF") == 0) {
                      wClient_NAF = txtController.text;
                    }
                    if (wChamps.compareTo("Client_TVA") == 0) {
                      wClient_TVA = txtController.text;
                    }

                    if (wChamps.compareTo("Adresse_Adr1") == 0) {
                      wAdresse_Adr1 = txtController.text;
                    }
                    if (wChamps.compareTo("Adresse_Adr2") == 0) {
                      wAdresse_Adr2 = txtController.text;
                    }
                    if (wChamps.compareTo("Adresse_Adr3") == 0) {
                      wAdresse_Adr3 = txtController.text;
                    }
                    if (wChamps.compareTo("Adresse_Adr4") == 0) {
                      wAdresse_Adr4 = txtController.text;
                    }
                    if (wChamps.compareTo("Adresse_CP") == 0) {
                      wAdresse_CP = txtController.text;
                    }
                    if (wChamps.compareTo("Adresse_Ville") == 0) {
                      wAdresse_Ville = txtController.text;
                    }
                    if (wChamps.compareTo("Adresse_Pays") == 0) {
                      wAdresse_Pays = txtController.text;
                    }

                    if (wChamps.compareTo("Livr_Adresse_Adr1") == 0) {
                      wLivr_Adresse_Adr1 = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Adresse_Adr2") == 0) {
                      wLivr_Adresse_Adr2 = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Adresse_Adr3") == 0) {
                      wLivr_Adresse_Adr3 = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Adresse_Adr4") == 0) {
                      wLivr_Adresse_Adr4 = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Adresse_CP") == 0) {
                      wLivr_Adresse_CP = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Adresse_Ville") == 0) {
                      wLivr_Adresse_Ville = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Adresse_Pays") == 0) {
                      wLivr_Adresse_Pays = txtController.text;
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

                    if (wChamps.compareTo("Livr_Contact_Civilite") == 0) {
                      wLivr_Contact_Civilite = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Contact_Prenom") == 0) {
                      wLivr_Contact_Prenom = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Contact_Nom") == 0) {
                      wLivr_Contact_Nom = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Contact_Fonction") == 0) {
                      wLivr_Contact_Fonction = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Contact_Service") == 0) {
                      wLivr_Contact_Service = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Contact_Tel1") == 0) {
                      wLivr_Contact_Tel1 = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Contact_Tel2") == 0) {
                      wLivr_Contact_Tel2 = txtController.text;
                    }
                    if (wChamps.compareTo("Livr_Contact_eMail") == 0) {
                      wLivr_Contact_eMail = txtController.text;
                    }
                  },
                ),
              ),
              wChamps.compareTo("Client_Siret") != 0 ? Container() : gObj.SquareRoundIcon(context, 50, 8, Colors.white, Colors.black, Icons.search, InseeSiret),
            ],
          )),
    );
  }

  Widget CheckBox(String wChamps) {
    double IcoWidth = 40;

    String wLabel = "";
    bool wSel = false;
    if (wChamps.compareTo("Client_CL") == 0) {
      wLabel = "Client";
      wSel = !wClient_CL_Pr;
    }
    if (wChamps.compareTo("Client_Pr") == 0) {
      wLabel = "Prospect";
      wSel = wClient_CL_Pr;
    }
    if (wChamps.compareTo("Client_OK_DataPerso") == 0) {
      wLabel = "Autorise la réutilisation de ses données personneles";
      wSel = wClient_OK_DataPerso;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: 450,
      height: 45,
      child: Card(
        color: gColors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              wLabel,
              textAlign: TextAlign.center,
              style: gColors.bodyTitle1_B_Gr,
            ),
            InkWell(
                onTap: () async {
                  await HapticFeedback.vibrate();
                  if (wChamps.compareTo("Client_CL") == 0) {
                    wClient_CL_Pr = !wClient_CL_Pr;
                  }
                  if (wChamps.compareTo("Client_Pr") == 0) {
                    wClient_CL_Pr = !wClient_CL_Pr;
                  }

                  if (wChamps.compareTo("Client_OK_DataPerso") == 0) {
                    wClient_OK_DataPerso = !wClient_OK_DataPerso;
                  }
                  setState(() {});
                },
                child:

                Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Image.asset(
                      wSel ? "assets/images/Plus_Sel.png" : "assets/images/Plus_No_Sel.png",
                      width: IcoWidth,
                      height: IcoWidth,
                    ))
            

            ),
          ],
        ),
      ),
    );
  }

  Widget DropdownButton(String wChamps) {
    List<String> listparamParam = [];
    List<String> listparamParamid = [];
    String selectedValue = "";
    String selectedValueID = "";
    String wLabel = "";

    print("wChamps $wChamps");


    if (wChamps.compareTo("Client_Commercial") == 0) {
      listparamParam = ListParam_ParamUser;
      listparamParamid = ListParam_ParamUserID;
      selectedValue = selectedValueUser;
      selectedValueID = selectedValueUserID;
      wLabel = "Commercial";
    }

    if (wChamps.compareTo("Client_Famille") == 0) {
      listparamParam = ListParam_ParamFam;
      listparamParamid = ListParam_ParamFamID;
      selectedValue = selectedValueFam;
      selectedValueID = selectedValueFamID;
      wLabel = "Famille";
    }

    if (wChamps.compareTo("Client_Depot") == 0) {
      listparamParam = ListParam_ParamDepot;
      selectedValue = selectedValueDepot;
      wLabel = "Rattaché à l'Agence";
    }

    if (wChamps.compareTo("Client_Rglt") == 0) {
      listparamParam = ListParam_ParamRglt;
      selectedValue = selectedValueRglt;
      wLabel = "Condition de réglements";
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        width: 450,
        height: 45,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            child: Text(
              wLabel,
              style: gColors.bodySaisie_B_G,
            ),
          ),
          Container(
            child: DropdownButtonHideUnderline(
                child: DropdownButton2(
              alignment: AlignmentDirectional.centerEnd,
//              itemHighlightColor: Colors.green,
  //            selectedItemHighlightColor: Colors.green,
              items: listparamParam.map((item) => DropdownMenuItem<String>(
                    alignment: AlignmentDirectional.centerEnd,
                    value: item,
                    child: Container(
//                      color: item.compareTo(wClient_Commercial)==0 ? Colors.green : Colors.white,
                      child: Text(
                        item,
                        style: gColors.bodySaisie_N_B,
                      ),
                    ),
                  )).toList(),
              value: selectedValue,
              selectedItemBuilder: (BuildContext ctxt) {
                return listparamParam.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item, style: gColors.bodySaisie_B_B));
                }).toList();
              },
              onChanged: (value) {
                setState(() {
                  selectedValue = value as String;
                  selectedValue = value;

                  print("onChanged selectedValue $selectedValue");
                  print("onChanged selectedValueID $selectedValueID");

                  if (wChamps.compareTo("Client_Commercial") == 0) {
                    selectedValueID = listparamParamid[listparamParam.indexOf(selectedValue)];
                    selectedValueUser = selectedValue;
                    selectedValueUserID = selectedValueID;
                    wClient_Commercial = selectedValue;
                  }

                  if (wChamps.compareTo("Client_Famille") == 0) {
                    selectedValueID = listparamParamid[listparamParam.indexOf(selectedValue)];
                    selectedValueFam = selectedValue;
                    selectedValueUserID = selectedValueID;
                    wClient_Famille = selectedValueFam;
                  }
                  if (wChamps.compareTo("Client_Depot") == 0) {
                    selectedValueDepot = selectedValue;
                    wClient_Depot = selectedValueDepot;
                  }
                  if (wChamps.compareTo("Client_Rglt") == 0) {
                    selectedValueRglt = selectedValue;
                    wClient_Rglt = selectedValueRglt;
                  }
                  setState(() {});
                });
              },
                  buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      height: 30,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 44,
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 800,
                  ),
            )),
          ),
        ]));
  }

  void InseeSiret() async {
    String wSiret = Srv_DbTools.gClient.Client_Siret;

    print("InseeSiret $wSiret");

    wSiret = wSiret.replaceAll(" ", "");
    print("InseeSiret $wSiret");
    if (wSiret.length != 14) {
      Alert(
        context: context,
        style: alertStyle,
        alertAnimation: fadeAlertAnimation,
        image: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/AppIco.png'),
        ),
        title: "RECHERCHE DU SIRET DANS INSEE",
        desc: "Le numéro de Siret doit comporter 14 caractères",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              return;
            },
            width: 120,
            child: const Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }

//    await Api_Gouv.siret('43447418500015') ;

    if (await Api_Gouv.siret(wSiret)) {
      int iSiret = int.parse(Api_Gouv.siret_SIREN);
//        int iSiret = 404833048;
      int iSiret97 = iSiret % 97;
      print("iSiret $iSiret iSiret97 $iSiret97");
      int iSiret97_2 = 12 + 3 * iSiret97;
      int iCleTva = iSiret97_2 % 97;
      String sCleTva = iCleTva.toString().padLeft(2, '0');
      print("iSiret97_2 $iSiret97_2 iCleTva $iCleTva sCleTva $sCleTva");

      String NoTVA = "FR$sCleTva$iSiret";

      Alert(
        context: context,
        style: confirmStyle,
        alertAnimation: fadeAlertAnimation,
        image: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/AppIco.png'),
        ),
        title: "RECHERCHE DU SIRET DANS INSEE",
        desc: "Êtes-vous sûre de vouloir remplacer les données ?\n${Api_Gouv.siret_Nom}\n${Api_Gouv.siret_Rue}\n${Api_Gouv.siret_Cp} ${Api_Gouv.siret_Ville}\n\nNAF : ${Api_Gouv.siret_NAF}\n\nTVA : $NoTVA",
        buttons: [
          DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black12,
              child: const Text(
                "Annuler",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
          DialogButton(
              onPressed: () async {
                Srv_DbTools.gClient.Client_Nom = Api_Gouv.siret_Nom;
                Srv_DbTools.gClient.Client_NAF = Api_Gouv.siret_NAF;
                Srv_DbTools.gClient.Client_TVA = NoTVA;
                Srv_DbTools.setClient(Srv_DbTools.gClient);

                Srv_DbTools.gAdresse.Adresse_Adr1 = Api_Gouv.siret_Rue;
                Srv_DbTools.gAdresse.Adresse_CP = Api_Gouv.siret_Cp;
                Srv_DbTools.gAdresse.Adresse_Ville = Api_Gouv.siret_Ville;
                Srv_DbTools.gAdresse.Adresse_Pays = "France";
                Srv_DbTools.setAdresse(Srv_DbTools.gAdresse);

                Reload();
                setState(() {});

                Navigator.pop(context);

                Navigator.pop(context);
              },
              color: Colors.green,
              child: const Text(
                "Remplacer",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
        ],
      ).show();
    } else {
      Alert(
        context: context,
        style: alertStyle,
        alertAnimation: fadeAlertAnimation,
        image: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/AppIco.png'),
        ),
        title: "RECHERCHE DU SIRET DANS INSEE",
        desc: Api_Gouv.siret_Nom,
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              return;
            },
            width: 120,
            child: const Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  }

  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: gColors.bodyText_B_R,
      overlayColor: const Color(0x88000000),
      alertElevation: 20,
      alertAlignment: Alignment.center);

  var confirmStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: gColors.bodyTitle1_B_Green,
      overlayColor: const Color(0x88000000),
      alertElevation: 20,
      alertAlignment: Alignment.center);

  Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  Widget AutoAdresseFact(TextEditingController textEditingController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.search,
          color: Colors.black,
          size: 30,
        ),
        Expanded(
          child: Container(
              child: TypeAheadField(




            suggestionsCallback: (pattern) async {
              await Api_Gouv.ApiAdresse(textController_Adresse_Geo.text);
              List<String> matches = <String>[];
              for (var propertie in Api_Gouv.properties) {
                matches.add(propertie.label!);
              }
              return matches;
            },
            itemBuilder: (context, sone) {
              return Card(
                  child: Container(
                padding: const EdgeInsets.all(5),
                child: Text(sone.toString()),
              ));
            },
            onSelected: (suggestion) {
              for (var propertie in Api_Gouv.properties) {
                if (propertie.label!.compareTo(suggestion.toString()) == 0) {
                  Api_Gouv.gProperties = propertie;
                }
              }
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

    wAdresse_Adr1 = Api_Gouv.gProperties.name!;
    wAdresse_CP = Api_Gouv.gProperties.postcode!;
    wAdresse_Ville = Api_Gouv.gProperties.city!;
    wAdresse_Pays = "France";
    setState(() {});
  }

  Widget AutoAdresseLivr(TextEditingController textEditingController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.search,
          color: Colors.black,
          size: 30,
        ),
        Expanded(
          child: Container(
              child: TypeAheadField(


            suggestionsCallback: (pattern) async {
              await Api_Gouv.ApiAdresse(textController_Adresse_Geo.text);
              List<String> matches = <String>[];
              for (var propertie in Api_Gouv.properties) {
                matches.add(propertie.label!);
              }
              return matches;
            },
            itemBuilder: (context, sone) {
              return Card(
                  child: Container(
                padding: const EdgeInsets.all(5),
                child: Text(sone.toString()),
              ));
            },
            onSelected: (suggestion) {
              for (var propertie in Api_Gouv.properties) {
                if (propertie.label!.compareTo(suggestion.toString()) == 0) {
                  Api_Gouv.gProperties = propertie;
                }
              }
              textController_Adresse_Geo.text = suggestion.toString();
            },
          )),
        ),
        gObj.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.arrow_downward, ToolsBarCopySearchLivr),
      ],
    );
  }

  void ToolsBarCopySearchLivr() async {
    print("ToolsBaToolsBarCopySearchLivrrCopySearch ${Api_Gouv.gProperties.toJson()}");

    wLivr_Adresse_Adr1 = Api_Gouv.gProperties.name!;
    wLivr_Adresse_CP = Api_Gouv.gProperties.postcode!;
    wLivr_Adresse_Ville = Api_Gouv.gProperties.city!;
    wLivr_Adresse_Pays = "France";
    setState(() {});
  }

  Widget DropdownButtonCivFact() {
    return

      Container(
        height: 50,
        width: 450,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        decoration: BoxDecoration(
          color: gColors.white,
          border: Border.all(
            /**/
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Row(children: [
          SizedBox(
            width: 74,
            child: Text("Civilité",
              style: gColors.bodyTitle1_B_Gr,),
          ),

          Container(
            child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: Text(
                    'Séléctionner une civilité',
                    style: gColors.bodyTitle1_N_Gr,
                  ),
                  items: Srv_DbTools.ListParam_ParamCiv.map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: gColors.bodySaisie_B_G,
                    ),
                  )).toList(),
                  value: wContact_Civilite,
                  onChanged: (value) {
                    setState(() {
                      wContact_Civilite = value as String;
                      print("textController_Contact_Civilite $wContact_Civilite");
                      setState(() {});
                    });
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    height: 30,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 32,
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 800,
                  ),

                )),
          ),
        ])
      );
  }


  Widget DropdownButtonCivLivr() {
    return

      Container(
          height: 50,
          width: 450,
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          decoration: BoxDecoration(
            color: gColors.white,
            border: Border.all(
              /**/
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Row(children: [
            SizedBox(
              width: 74,
              child: Text("Civilité",
                style: gColors.bodyTitle1_B_Gr,),
            ),

            Container(
              child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      'Séléctionner une civilité',
                      style: gColors.bodyTitle1_N_Gr,
                    ),
                    items: Srv_DbTools.ListParam_ParamCiv.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: gColors.bodySaisie_B_G,
                      ),
                    )).toList(),
                    value: wContact_Civilite,
                    onChanged: (value) {
                      setState(() {
                        wContact_Civilite = value as String;
                        print("textController_Contact_Civilite $wContact_Civilite");
                        setState(() {});
                      });
                    },


                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(left: 14, right: 14),
                      height: 30,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 32,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 800,
                    ),

                  )),
            ),
          ])
      );
  }
}
