import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Contacts.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Client/Vue_Site_Popup.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

//**********************************
//**********************************
//**********************************

class Site_Vue extends StatefulWidget {
  @override
  _Site_VueState createState() => _Site_VueState();
}

class _Site_VueState extends State<Site_Vue> {
  bool bFact = true;

  bool affAdresseAll = false;
  bool affContactAll = false;

  List<Widget> wAff = [];

  void Reload() async {
    await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gSite.SiteId, "SITE");

    String Dep = "";

    print("Srv_DbTools.gClient.Client_CL_Pr ${Srv_DbTools.gClient.Client_CL_Pr}");

    if (Srv_DbTools.gSite.Site_CP.length >= 2) Dep = Srv_DbTools.gSite.Site_CP.substring(0, 2);
    String wAdr = "${Srv_DbTools.gSite.Site_Adr1} ";
    if (Srv_DbTools.gSite.Site_Adr2.isNotEmpty) wAdr = wAdr + "${Srv_DbTools.gSite.Site_Adr2} ";
    if (Srv_DbTools.gSite.Site_Adr3.isNotEmpty) wAdr = wAdr + "${Srv_DbTools.gSite.Site_Adr3} ";

    if (Srv_DbTools.gSite.Site_Adr4.isNotEmpty) wAdr = wAdr + "${Srv_DbTools.gSite.Site_Adr4} ";
    if (Srv_DbTools.gSite.Site_CP.isNotEmpty) wAdr = wAdr + "${Srv_DbTools.gSite.Site_CP} ";
    if (Srv_DbTools.gSite.Site_Ville.isNotEmpty) wAdr = wAdr + "${Srv_DbTools.gSite.Site_Ville} ";
    if (Srv_DbTools.gSite.Site_Pays.isNotEmpty) wAdr = wAdr + "${Srv_DbTools.gSite.Site_Pays} ";

    wAff = [
      AffLigne("Site", "", gColors.greyLight, "Icon_Site", "", "", "", ""),
      AffBtn("Site_Nom", "Nom", "${Srv_DbTools.gSite.Site_Nom}"),
      AffLigne("Adresse du Site", "", gColors.greyLight, "Icon_Adr", !affAdresseAll ? "Icon_circle_down" : "Icon_circle_up", "", "", ""),
      AffBtn("Adresse", "Adresse", "${Srv_DbTools.gSite.Site_Adr1}"),
      !affAdresseAll ? Container() : AffBtn("Adresse", "Adresse (Suite)", "${Srv_DbTools.gSite.Site_Adr2}"),
      !affAdresseAll ? Container() : AffBtn("Adresse", "Adresse (Suite)", "${Srv_DbTools.gSite.Site_Adr3}"),
      !affAdresseAll ? Container() : AffBtn("Adresse", "Adresse (Fin)", "${Srv_DbTools.gSite.Site_Adr4}"),
      AffBtn("Adresse", "CP", "${Srv_DbTools.gSite.Site_CP}"),
      AffBtn("Adresse", "Villle", "${Srv_DbTools.gSite.Site_Ville}"),
      !affAdresseAll ? Container() : AffLigne("Département", "${Dep}", gColors.white, "", "", "", "", ""),
      !affAdresseAll ? Container() : AffBtn("Adresse", "Pays", "${Srv_DbTools.gSite.Site_Pays} "),
      AffLigne("", "", gColors.white, "", "", "", "", wAdr),
      AffLigne("Contact du Site", "", gColors.greyLight, "Icon_Cont", "", !affContactAll ? "Icon_circle_down" : "Icon_circle_up", "", ""),
      !affContactAll ? AffBtn("Contact", "Nom", "${Srv_DbTools.gContact.Contact_Civilite} ${Srv_DbTools.gContact.Contact_Prenom} ${Srv_DbTools.gContact.Contact_Nom} ") : AffBtn("Contact", "Civilité", "${Srv_DbTools.gContact.Contact_Civilite}"),
      !affContactAll ? Container() : AffBtn("Contact", "Prénom", "${Srv_DbTools.gContact.Contact_Prenom} "),
      !affContactAll ? Container() : AffBtn("Contact", "Nom", "${Srv_DbTools.gContact.Contact_Nom}"),
      !affContactAll
          ? Container()
          : AffBtn(
        "Contact",
        "Fonction / Service",
        "${Srv_DbTools.gContact.Contact_Fonction} ${Srv_DbTools.gContact.Contact_Service}",
      ),
      !affContactAll ? Container() : AffBtn("Contact", "Tel Fixe", "${Srv_DbTools.gContact.Contact_Tel1}"),
      AffBtn("Contact", "Portable", "${Srv_DbTools.gContact.Contact_Tel2}"),
      AffLigne("Email", "", gColors.white, "", "", "", "${Srv_DbTools.gContact.Contact_eMail}", ""),
    AffBtnAdd("Autres Contacts"),
    ];

    if (Srv_DbTools.ListContact.length > 1) {

      for (int i = 1; i < Srv_DbTools.ListContact.length; i++) {
        var element = Srv_DbTools.ListContact[i];
        String wNom = "${element.Contact_Prenom} ${element.Contact_Nom}";
        if (element.Contact_Fonction.isNotEmpty) wNom = wNom + " - ${element.Contact_Fonction}";
        if (element.Contact_Service.isNotEmpty) wNom = wNom + "/${element.Contact_Service}";
        if (element.Contact_Tel1.isNotEmpty) wNom = wNom + " - ${element.Contact_Tel1}";
        if (element.Contact_Tel2.isNotEmpty) wNom = wNom + " - ${element.Contact_Tel2}";
        if (element.Contact_eMail.isNotEmpty) wNom = wNom + " - ${element.Contact_eMail}";
        wAff.add(AffBtnAutr("Contact", i, "${wNom}"));
      }
    }

    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
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
              Text(
                "SITE",
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
              child: Image.asset("assets/images/IcoW.png"),
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
                gObj.InterventionTitleWidget("${Srv_DbTools.gSite.Site_Nom.toUpperCase()}"),
                Container(
                  height: 6,
                ),
                Expanded(
                  child: build_Facture(),
                )
              ],
            )));
  }

  Widget build_Facture() {
    return ListView(
      children: wAff,
    );
  }

  Widget AffLigne(String wTextL, String wTextR, Color BckGrd, String ImgL, String ImgR, String ImgR2, String eMail, String Map) {
    double wHeight = 44;
    double mTop = 15;
    double icoWidth = 32;
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: BckGrd,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Image.asset(
                    "assets/images/${ImgL}.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      "${wTextL}",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodySaisie_B_B,
                    )),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(right: 10, top: mTop),
                        height: wHeight,
                        child: Text(
                          "${wTextR}",
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: gColors.bodySaisie_B_B.copyWith(color: gColors.primaryGreen),
                        ))),
                ImgR.isEmpty
                    ? Container()
                    : IconButton(
                  icon: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Image.asset(
                      "assets/images/${ImgR}.png",
                      height: icoWidth,
                      width: icoWidth,
                    ),
                  ),
                  onPressed: () async {
                    affAdresseAll = !affAdresseAll;
                    Reload();
                  },
                ),
                ImgR2.isEmpty
                    ? Container()
                    : IconButton(
                  icon: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Image.asset(
                      "assets/images/${ImgR2}.png",
                      height: icoWidth,
                      width: icoWidth,
                    ),
                  ),
                  onPressed: () async {
                    affContactAll = !affContactAll;
                    Reload();
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
                          "${eMail}",
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
                      MapsLauncher.launchQuery("${Map}");
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
                Srv_DbTools.gContact = Srv_DbTools.ListContact[0];
                return Container(padding: EdgeInsets.fromLTRB(30, 0, 30, 30), child: Site_Vue_Popup(bFact: true, wChamps: wChamps));
              });
          Reload();
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", gColors.white, "", "", "", "", ""),
          ],
        ));
  }

  Widget AffBtnAutr(String wChamps, int i, String wValue) {
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
                Srv_DbTools.gContact = Srv_DbTools.ListContact[i];
                return Container(padding: EdgeInsets.fromLTRB(30, 0, 30, 30), child: Site_Vue_Popup(bFact: true, wChamps: wChamps));
              });
          Reload();
        },
        child: Column(
          children: [
            AffLigne("", "$wValue >", gColors.white, "", "", "", "", ""),
          ],
        ));
  }

  Widget AffBtnAdd(String wChamps) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          print("onPressed AffBtnAdd  ${Srv_DbTools.gClient.ClientId} ${Srv_DbTools.gSite.SiteId}");
          await Srv_DbTools.addContactAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gSite.SiteId, "SITE");
          await Srv_DbTools.getContactSite(Srv_DbTools.gClient.ClientId, Srv_DbTools.gSite.SiteId);
          Srv_DbTools.gContact = Srv_DbTools.ListContact[Srv_DbTools.ListContact.length - 1];
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return Container(padding: EdgeInsets.fromLTRB(30, 0, 30, 30), child: Site_Vue_Popup(bFact: true, wChamps: "Contact"));
              });
          Reload();
        },
        child: Column(
          children: [
            AffLigne2("Autres Contacts", "", gColors.greyLight, "Icon_Cont", "ico4"),
          ],
        ));
  }

  Widget AffLigne2(String wTextL, String wTextR, Color BckGrd, String ImgL, String ImgR, ) {
    double wHeight = 44;
    double mTop = 15;
    double icoWidth = 32;
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: BckGrd,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Image.asset(
                    "assets/images/${ImgL}.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      "${wTextL}",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodySaisie_B_B,
                    )),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(right: 10, top: mTop),
                        height: wHeight,
                        child: Text(
                          "${wTextR}",
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: gColors.bodySaisie_B_B.copyWith(color: gColors.primaryGreen),
                        ))),


                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Image.asset(
                    "assets/images/${ImgR}.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ),
              ],
            ),
            gColors.wLigne(),
          ],
        ));
  }
}
