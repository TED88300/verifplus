import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Adresses.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Contacts.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Client/Vue_Client_Popup.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

//**********************************
//**********************************
//**********************************

class Client_Vue extends StatefulWidget {
  const Client_Vue({super.key});

  @override
  _Client_VueState createState() => _Client_VueState();
}

class _Client_VueState extends State<Client_Vue> {
  bool bFact = true;
  bool affEdtFilter = false;
  bool affAdresseAll = false;
  bool affContactAll = false;
  bool AddVis = false;

  void Reload() async {

    print("Client_Vue Reload ${Srv_DbTools.gClient.ClientId}");
    await DbTools.getAdresseClientType(Srv_DbTools.gClient.ClientId, "LIVR");
    await DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gAdresse.AdresseId, "LIVR");

    Srv_DbTools.gAdresseLivr = Srv_DbTools.gAdresse;
    Srv_DbTools.gContactLivr = Srv_DbTools.gContact;

    print("Client_Vue Reload Srv_DbTools.gContactLivr ${Srv_DbTools.gContactLivr.Desc()}");



    await DbTools.getAdresseClientType(Srv_DbTools.gClient.ClientId, "FACT");
    await DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gAdresse.AdresseId, "FACT");


    print("Client_Vue Reload Srv_DbTools.gContact ${Srv_DbTools.gContact.Desc()}");





//    await Srv_DbTools.getGroupesClient(Srv_DbTools.gClient.ClientId);
    AddVis = Srv_DbTools.ListGroupe.length <= 1;

    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    Srv_DbTools.gAdresse = Adresse.AdresseInit();
    Srv_DbTools.gContact = Contact.ContactInit();
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Srv_DbTools.gClient.Client_isUpdate ? Container() :
              Container(
                padding: const EdgeInsets.only(right: 5, bottom: 6),
                child: Text(
                   "◉",
                  maxLines: 1,
                  style: gColors.bodyTitle1_B_R32,
                ),
              ),

              Text(
                "CLIENT",
                maxLines: 1,
                style: gColors.bodyTitle1_B_G24,
              ),
            ],
          ),
          leading: InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
              child: DbTools.gBoolErrorSync
                  ? Image.asset(
                "assets/images/IcoWErr.png",
              )
                  : Image.asset("assets/images/IcoW.png"),
            ),
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 40,
              icon: gColors.wBoxDecoration(context),
              onPressed: () async {
                gColors.AffUser(context);
              },
            ),
          ],
          backgroundColor: gColors.white,
        ),
        body: Container(
            color: gColors.white,
            child: Column(
              children: [
                Material(
                  elevation: 4,
                  child: Container(
                    color: gColors.white,
                    height: 57,
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      InkWell(
                        onTap: () async {
                          await HapticFeedback.vibrate();
                          bFact = true;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 3.0, color: bFact ? gColors.primaryRed : gColors.transparent))),
                          child: Text(
                            ' FACTURATION  ',
                            textAlign: TextAlign.center,
                            style: gColors.bodyTitle1_B_Wr.copyWith(color: bFact ? gColors.primaryRed : gColors.greyDark, fontWeight: bFact ? FontWeight.bold : FontWeight.normal),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await HapticFeedback.vibrate();
                          bFact = false;
                          setState(() {});
                        },
                        child: Container(
                          // optional
                          padding: const EdgeInsets.only(bottom: 1.0),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 3.0, color: !bFact ? gColors.primaryRed : gColors.transparent))),
                          child: Text(
                            ' LIVRAISON  ',
                            textAlign: TextAlign.center,
                            style: gColors.bodyTitle1_B_Wr.copyWith(color: !bFact ? gColors.primaryRed : gColors.greyDark, fontWeight: !bFact ? FontWeight.bold : FontWeight.normal),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Container(
                  height: 6,
                ),
                Expanded(
                  child: bFact ? build_Facture() : build_Livr(),
                )
              ],
            )),

/*
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child:
            (!AddVis) ? Container() :
        FloatingActionButton.extended(
                elevation: 0.0,
                label: Text('Ajout Groupe', style: gColors.bodyTitle1_N_W),
                backgroundColor: gColors.primaryGreen,
                onPressed: () async {

                  Groupe wGroupe = await Groupe.GroupeInit();
                  bool wRet = await Srv_DbTools.addGroupe(Srv_DbTools.gClient.ClientId);
                  wGroupe.Groupe_isUpdate = wRet;
                  if (!wRet) Srv_DbTools.gLastID = new DateTime.now().millisecondsSinceEpoch * -1;
                  wGroupe.GroupeId = Srv_DbTools.gLastID;
                  wGroupe.Groupe_Nom = "???";
                  await DbTools.inserGroupes(wGroupe);

                  Srv_DbTools.gGroupe = wGroupe;
                  print("Client_Vue Reload ${Srv_DbTools.gClient.ClientId}");

                  wGroupe.GroupeId          = Srv_DbTools.gLastID;
                  wGroupe.Groupe_ClientId   = Srv_DbTools.gClient.ClientId;
                  wGroupe.Groupe_Nom        = Srv_DbTools.gClient.Client_Nom + "_2";
                  wGroupe.Groupe_Adr1       = Srv_DbTools.gAdresse.Adresse_Adr1;
                  wGroupe.Groupe_Adr2       = Srv_DbTools.gAdresse.Adresse_Adr2;
                  wGroupe.Groupe_Adr3       = Srv_DbTools.gAdresse.Adresse_Adr3;
                  wGroupe.Groupe_CP         = Srv_DbTools.gAdresse.Adresse_CP;
                  wGroupe.Groupe_Ville      = Srv_DbTools.gAdresse.Adresse_Ville;
                  Srv_DbTools.setGroupe(wGroupe);

                  await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gGroupe.GroupeId, "GRP");
                  Srv_DbTools.gContact.Contact_Civilite  = Srv_DbTools.gContactLivr.Contact_Civilite ;
                  Srv_DbTools.gContact.Contact_Prenom    = Srv_DbTools.gContactLivr.Contact_Prenom   ;
                  Srv_DbTools.gContact.Contact_Nom       = Srv_DbTools.gContactLivr.Contact_Nom      ;
                  Srv_DbTools.gContact.Contact_Fonction  = Srv_DbTools.gContactLivr.Contact_Fonction ;
                  Srv_DbTools.gContact.Contact_Service   = Srv_DbTools.gContactLivr.Contact_Service  ;
                  Srv_DbTools.gContact.Contact_Tel1      = Srv_DbTools.gContactLivr.Contact_Tel1     ;
                  Srv_DbTools.gContact.Contact_Tel2      = Srv_DbTools.gContactLivr.Contact_Tel2     ;
                  Srv_DbTools.gContact.Contact_eMail     = Srv_DbTools.gContactLivr.Contact_eMail    ;
                  Srv_DbTools.setContact(Srv_DbTools.gContact);
                  Navigator.of(context).pop();
                }



                ))
*/



    );
            }

  Widget build_Facture() {
    String Dep = "";

    if (Srv_DbTools.gAdresse.Adresse_CP.length >= 2) Dep = Srv_DbTools.gAdresse.Adresse_CP.substring(0, 2);

    String wAdr = "${Srv_DbTools.gAdresse.Adresse_Adr1} ";
    if (Srv_DbTools.gAdresse.Adresse_Adr2.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresse.Adresse_Adr2} ";
    if (Srv_DbTools.gAdresse.Adresse_Adr3.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresse.Adresse_Adr3} ";
    if (Srv_DbTools.gAdresse.Adresse_Adr4.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresse.Adresse_Adr4} ";
    if (Srv_DbTools.gAdresse.Adresse_CP.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresse.Adresse_CP} ";
    if (Srv_DbTools.gAdresse.Adresse_Ville.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresse.Adresse_Ville} ";
    if (Srv_DbTools.gAdresse.Adresse_Pays.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresse.Adresse_Pays} ";

    print("Srv_DbTools.gContact.Contact_Nom ${Srv_DbTools.gContact.Contact_Nom}");
    return ListView(
      children: [
        AffLigne("Client", Srv_DbTools.gClient.Client_CL_Pr ? "Prospect " : "Client ", gColors.greyLight, "Icon_Clientb", "", "", "", ""),
        AffBtn("Client_Nom", "Nom", Srv_DbTools.gClient.Client_Nom),
        AffBtn("Client_Siret", "Siret", Srv_DbTools.gClient.Client_Siret),
        AffLigne("Commercial", "", gColors.greyLight, "Icon_Comm", "", "", "", ""),
        AffBtn("Client_Commercial", "Commercial", Srv_DbTools.gClient.Client_Commercial),
        AffLigne("Adresse de Facturation", "", gColors.greyLight, "Icon_Adr", !affAdresseAll ? "Icon_circle_down" : "Icon_circle_up", "", "", ""),
        AffBtn("Adresse", "Adresse", Srv_DbTools.gAdresse.Adresse_Adr1),
        !affAdresseAll ? Container() : AffBtn("Adresse", "Adresse (Suite)", Srv_DbTools.gAdresse.Adresse_Adr2),
        !affAdresseAll ? Container() : AffBtn("Adresse", "Adresse (Suite)", Srv_DbTools.gAdresse.Adresse_Adr3),
        !affAdresseAll ? Container() : AffBtn("Adresse", "Adresse (Fin)", Srv_DbTools.gAdresse.Adresse_Adr4),
        AffBtn("Adresse", "CP", Srv_DbTools.gAdresse.Adresse_CP),
        AffBtn("Adresse", "Villle", Srv_DbTools.gAdresse.Adresse_Ville),
        !affAdresseAll ? Container() : AffLigne("Département", Dep, gColors.white, "", "", "", "", ""),
        !affAdresseAll ? Container() : AffBtn("Adresse", "Pays", "${Srv_DbTools.gAdresse.Adresse_Pays} "),
        AffLigne("", "", gColors.white, "", "", "", "", wAdr),
        AffLigne("Contact de Facturation", "", gColors.greyLight, "Icon_Cont", "", !affContactAll ? "Icon_circle_down" : "Icon_circle_up", "", ""),
        !affContactAll ? AffBtn("Contact", "Nom", "${Srv_DbTools.gContact.Contact_Civilite} ${Srv_DbTools.gContact.Contact_Prenom} ${Srv_DbTools.gContact.Contact_Nom} ") : AffBtn("Contact", "Civilité", Srv_DbTools.gContact.Contact_Civilite),
        !affContactAll ? Container() : AffBtn("Contact", "Prénom", "${Srv_DbTools.gContact.Contact_Prenom} "),
        !affContactAll ? Container() : AffBtn("Contact", "Nom", Srv_DbTools.gContact.Contact_Nom),
        !affContactAll
            ? Container()
            : AffBtn(
                "Contact",
                "Fonction / Service",
                "${Srv_DbTools.gContact.Contact_Fonction} ${Srv_DbTools.gContact.Contact_Service}",
              ),
        !affContactAll ? Container() : AffBtn("Contact", "Tel Fixe", Srv_DbTools.gContact.Contact_Tel1),
        AffBtn("Contact", "Portable", Srv_DbTools.gContact.Contact_Tel2),
        AffLigne("Email", "", gColors.white, "", "", "", Srv_DbTools.gContact.Contact_eMail, ""),
      ],
    );
  }

  Widget build_Livr() {
    String Dep = "";

    if (Srv_DbTools.gAdresseLivr.Adresse_CP.length >= 2) Dep = Srv_DbTools.gAdresseLivr.Adresse_CP.substring(0, 2);

    String wAdr = "${Srv_DbTools.gAdresseLivr.Adresse_Adr1} ";
    if (Srv_DbTools.gAdresseLivr.Adresse_Adr2.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresseLivr.Adresse_Adr2} ";
    if (Srv_DbTools.gAdresseLivr.Adresse_Adr3.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresseLivr.Adresse_Adr3} ";
    if (Srv_DbTools.gAdresseLivr.Adresse_Adr4.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresseLivr.Adresse_Adr4} ";
    if (Srv_DbTools.gAdresseLivr.Adresse_CP.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresseLivr.Adresse_CP} ";
    if (Srv_DbTools.gAdresseLivr.Adresse_Ville.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresseLivr.Adresse_Ville} ";
    if (Srv_DbTools.gAdresseLivr.Adresse_Pays.isNotEmpty) wAdr = "$wAdr${Srv_DbTools.gAdresseLivr.Adresse_Pays} ";

    print("Srv_DbTools.gContactLivr.Contact_Nom ${Srv_DbTools.gContactLivr.Contact_Nom}");
    return ListView(
      children: [
        AffLigne("Adresse de Livraison", "", gColors.greyLight, "Icon_Adr", !affAdresseAll ? "Icon_circle_down" : "Icon_circle_up", "", "", ""),

/*
        AffLigne("Adresse", "${Srv_DbTools.gAdresseLivr.Adresse_Adr1}", gColors.white, "", "", "", "", ""),
        !affAdresseAll ? Container() : AffLigne("Adresse (Suite)", "${Srv_DbTools.gAdresseLivr.Adresse_Adr2}", gColors.white, "", "", "", "", ""),
        !affAdresseAll ? Container() : AffLigne("Adresse (Suite)", "${Srv_DbTools.gAdresseLivr.Adresse_Adr3}", gColors.white, "", "", "", "", ""),
        !affAdresseAll ? Container() : AffLigne("Adresse (Fin)", "${Srv_DbTools.gAdresseLivr.Adresse_Adr4}", gColors.white, "", "", "", "", ""),
        AffLigne("CP / Villle", "${Srv_DbTools.gAdresseLivr.Adresse_CP} ${Srv_DbTools.gAdresseLivr.Adresse_Ville}", gColors.white, "", "", "", "", ""),
        !affAdresseAll ? Container() : AffLigne("Département", "${Dep} ", gColors.white, "", "", "", "", ""),
        !affAdresseAll ? Container() : AffLigne("Pays", "${Srv_DbTools.gAdresseLivr.Adresse_Pays} ", gColors.white, "", "", "", "", ""),
*/

        AffBtn("AdresseLivr", "Adresse", Srv_DbTools.gAdresseLivr.Adresse_Adr1),
        !affAdresseAll ? Container() : AffBtn("AdresseLivr", "Adresse (Suite)", Srv_DbTools.gAdresseLivr.Adresse_Adr2),
        !affAdresseAll ? Container() : AffBtn("AdresseLivr", "Adresse (Suite)", Srv_DbTools.gAdresseLivr.Adresse_Adr3),
        !affAdresseAll ? Container() : AffBtn("AdresseLivr", "Adresse (Fin)", Srv_DbTools.gAdresseLivr.Adresse_Adr4),
        AffBtn("AdresseLivr", "CP", Srv_DbTools.gAdresseLivr.Adresse_CP),
        AffBtn("AdresseLivr", "Villle", Srv_DbTools.gAdresseLivr.Adresse_Ville),
        !affAdresseAll ? Container() : AffLigne("Département", Dep, gColors.white, "", "", "", "", ""),
        !affAdresseAll ? Container() : AffBtn("AdresseLivr", "Pays", "${Srv_DbTools.gAdresseLivr.Adresse_Pays} "),
        AffLigne("", "", gColors.white, "", "", "", "", wAdr),

/*

        AffLigne("Contact de Livraison", "", gColors.greyLight, "Icon_Cont", "", !affContactAll ? "Icon_circle_down" : "Icon_circle_up", "", ""),
        !affContactAll ? AffLigne("Nom", "${Srv_DbTools.gContactLivr.Contact_Civilite} ${Srv_DbTools.gContactLivr.Contact_Prenom} ${Srv_DbTools.gContactLivr.Contact_Nom} ", gColors.white, "", "", "", "", "") : AffLigne("Civilité", "${Srv_DbTools.gContactLivr.Contact_Civilite} ", gColors.white, "", "", "", "", ""),
        !affContactAll ? Container() : AffLigne("Prénom", "${Srv_DbTools.gContactLivr.Contact_Prenom} ", gColors.white, "", "", "", "", ""),
        !affContactAll ? Container() : AffLigne("Nom", "${Srv_DbTools.gContactLivr.Contact_Nom}", gColors.white, "", "", "", "", ""),
        !affContactAll ? Container() : AffLigne("Fonction / Service", "${Srv_DbTools.gContactLivr.Contact_Fonction} ${Srv_DbTools.gContactLivr.Contact_Service}", gColors.white, "", "", "", "", ""),
        !affContactAll ? Container() : AffLigne("Tel Fixe", "${Srv_DbTools.gContactLivr.Contact_Tel1} ", gColors.white, "", "", "", "", ""),
        AffLigne("Portable", "${Srv_DbTools.gContactLivr.Contact_Tel2}", gColors.white, "", "", "", "", ""),
        AffLigne("Email", "", gColors.white, "", "", "", "${Srv_DbTools.gContactLivr.Contact_eMail}", ""),

*/

        AffLigne("Contact de Livraison", "", gColors.greyLight, "Icon_Cont", "", !affContactAll ? "Icon_circle_down" : "Icon_circle_up", "", ""),
        !affContactAll ? AffBtn("ContactLivr", "Nom", "${Srv_DbTools.gContactLivr.Contact_Civilite} ${Srv_DbTools.gContactLivr.Contact_Prenom} ${Srv_DbTools.gContactLivr.Contact_Nom} ") : AffBtn("Contact", "Civilité", Srv_DbTools.gContactLivr.Contact_Civilite),
        !affContactAll ? Container() : AffBtn("ContactLivr", "Prénom", "${Srv_DbTools.gContactLivr.Contact_Prenom} "),
        !affContactAll ? Container() : AffBtn("ContactLivr", "Nom", Srv_DbTools.gContactLivr.Contact_Nom),
        !affContactAll
            ? Container()
            : AffBtn(
                "ContactLivr",
                "Fonction / Service",
                "${Srv_DbTools.gContactLivr.Contact_Fonction} ${Srv_DbTools.gContactLivr.Contact_Service}",
              ),
        !affContactAll ? Container() : AffBtn("ContactLivr", "Tel Fixe", Srv_DbTools.gContactLivr.Contact_Tel1),
        AffBtn("ContactLivr", "Portable", Srv_DbTools.gContactLivr.Contact_Tel2),
        AffLigne("Email", "", gColors.white, "", "", "", Srv_DbTools.gContactLivr.Contact_eMail, ""),
      ],
    );
  }

  Widget AffLigne(String wTextL, String wTextR, Color BckGrd, String ImgL, String ImgR, String ImgR2, String eMail, String Map, {bool textBlackColor = true}) {
    double wHeight = 44;
    double mTop = 15;
    double icoWidth = 32;

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: BckGrd,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Image.asset(
                          "assets/images/$ImgL.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      wTextL,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodySaisie_B_B,
                    )),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(right: 10, top: mTop),
                        height: wHeight,
                        child: Text(
                          wTextR,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: gColors.bodySaisie_B_B.copyWith(color: textBlackColor ? Colors.black : gColors.primaryGreen),
                        ))),
                ImgR.isEmpty
                    ? Container()
                    : IconButton(
                        icon: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            "assets/images/$ImgR.png",
                            height: icoWidth,
                            width: icoWidth,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            affAdresseAll = !affAdresseAll;
                          });
                        },
                      ),
                ImgR2.isEmpty
                    ? Container()
                    : IconButton(
                        icon: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            "assets/images/$ImgR2.png",
                            height: icoWidth,
                            width: icoWidth,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            affContactAll = !affContactAll;
                          });
                        },
                      ),
                eMail.isEmpty
                    ? Container()
                    : InkWell(
                        onTap: () async {
                          await HapticFeedback.vibrate();
                          var url = Uri.parse('mailto:$eMail?subject= &body=');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.only(right: 10, top: mTop),
                            height: wHeight,
                            child: Text(
                              eMail,
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: gColors.bodySaisie_B_B.copyWith(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ))),
                Map.isEmpty
                    ? Container()
                    : InkWell(
                        onTap: () async {
                          await HapticFeedback.vibrate();
                          MapsLauncher.launchQuery(Map);
                        },
                        child: Container(
                            padding: EdgeInsets.only(right: 10, top: mTop),
                            height: wHeight,
                            child: Text(
                              "MAP >",
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: gColors.bodySaisie_B_B.copyWith(color: gColors.primaryGreen),
                            ))),
              ],
            ),
            gColors.wLigne(),
          ],
        ));
  }

  Widget AffBtn(String wChamps, String wTitle, String wValue) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          print("onPressed");
//            await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Vue_Edit()));
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return Container(padding: const EdgeInsets.fromLTRB(30, 0, 30, 30), child: Client_Vue_Popup(bFact: true, wChamps: wChamps));
              });
          setState(() {});
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", gColors.white, "", "", "", "", "", textBlackColor : false),
          ],
        ));
  }
}
