import 'dart:async';

import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Adresses.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Clients.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Contacts.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Groupes.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Zones.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Import_ASync_Dialog {
  Import_ASync_Dialog();

  static Future<void> Dialogs_ASync(
    BuildContext context,
    VoidCallback onSaisie,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Import_ASyncDialog(
        onSaisie: onSaisie,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Import_ASyncDialog extends StatefulWidget {
  final VoidCallback onSaisie;

  const Import_ASyncDialog({
    Key? key,
    required this.onSaisie,
  }) : super(key: key);

  @override
  Import_ASyncDialogState createState() => Import_ASyncDialogState();
}

class Import_ASyncDialogState extends State<Import_ASyncDialog> with TickerProviderStateMixin {
  bool iStrfExp = false;

  String wSt = "";

  @override
  void initLib() async {

    wSt += "Clients\n";
    List<Client> ListClient = await DbTools.getClientsAll();
    for (int i = 0; i < ListClient.length; i++) {
      Client wClient = ListClient[i];

      // ☀︎☀︎☀︎ CLIENT UPDATE ☀︎☀︎☀︎
      if (!wClient.Client_isUpdate && wClient.ClientId >= 0) {
        wSt += "     UPDATE ${wClient.Client_Nom} [${wClient.ClientId}]\n";
      }
      // ☀︎☀︎☀︎ CLIENT INSERT ☀︎☀︎☀︎
      else if (!wClient.Client_isUpdate && wClient.ClientId < 0) {
        wSt += "     INSERT ${wClient.Client_Nom} [${wClient.ClientId}]\n";
      }
    }
    wSt += "\n";

    wSt += "Adresses\n";
    List<Adresse> ListAdresse = await DbTools.getAdresseAll();
    for (int i = 0; i < ListAdresse.length; i++) {
      Adresse wAdresse = ListAdresse[i];

      // ☀︎☀︎☀︎ ADRESSE UPDATE ☀︎☀︎☀︎
      if (!wAdresse.Adresse_isUpdate && wAdresse.AdresseId >= 0) {
        wSt += "     UPDATE ${wAdresse.Adresse_Nom} [${wAdresse.Adresse_ClientId}, ${wAdresse.AdresseId}]\n";
      }
      // ☀︎☀︎☀︎ ADRESSE INSERT ☀︎☀︎☀︎
      else if (!wAdresse.Adresse_isUpdate && wAdresse.AdresseId < 0) {
        wSt += "     INSERT ${wAdresse.Adresse_Nom} [${wAdresse.Adresse_ClientId}, ${wAdresse.AdresseId}]\n";
      }
    }
    wSt += "\n";

    wSt += "Contacts\n";
    List<Contact> ListContact = await DbTools.getContact();
    for (int i = 0; i < ListContact.length; i++) {
      Contact wContact = ListContact[i];

      // ☀︎☀︎☀︎ CONTACT UPDATE ☀︎☀︎☀︎
      if (!wContact.Contact_isUpdate && wContact.ContactId >= 0) {
        wSt += "     UPDATE ${wContact.Contact_Nom} [${wContact.Contact_ClientId}, ${wContact.Contact_AdresseId}, ${wContact.ContactId}]\n";
      }
      // ☀︎☀︎☀︎ CONTACT INSERT ☀︎☀︎☀︎
      else if (!wContact.Contact_isUpdate && wContact.ContactId < 0) {
        wSt += "     INSERT ${wContact.Contact_Nom} [${wContact.Contact_ClientId}, ${wContact.Contact_AdresseId}, ${wContact.ContactId}]\n";
      }
    }
    wSt += "\n";

    wSt += "Groupes\n";
    List<Groupe> ListGroupe = await DbTools.getGroupesAll();
    for (int i = 0; i < ListGroupe.length; i++) {
      Groupe wGroupe = ListGroupe[i];

      // ☀︎☀︎☀︎ GROUPE UPDATE ☀︎☀︎☀︎
      if (!wGroupe.Groupe_isUpdate && wGroupe.GroupeId >= 0) {
        wSt += "     UPDATE ${wGroupe.Groupe_Nom} [${wGroupe.Groupe_ClientId}, ${wGroupe.GroupeId}]\n";
      }
      // ☀︎☀︎☀︎ GROUPE INSERT ☀︎☀︎☀︎
      else if (!wGroupe.Groupe_isUpdate && wGroupe.GroupeId < 0) {
        wSt += "     INSERT ${wGroupe.Groupe_Nom} [${wGroupe.Groupe_ClientId}, ${wGroupe.GroupeId}]\n";
      }
    }
    wSt += "\n";

    wSt += "Sites\n";
    List<Site> ListSite = await DbTools.getSitesAll();
    for (int i = 0; i < ListSite.length; i++) {
      Site wSite = ListSite[i];
      print("LISTE ${wSite.Site_Nom} [${wSite.Site_GroupeId}, ${wSite.SiteId}] ${wSite.Site_isUpdate}");

      // ☀︎☀︎☀︎ SITE UPDATE ☀︎☀︎☀︎
      if (!wSite.Site_isUpdate && wSite.SiteId >= 0) {
        wSt += "UPDATE ${wSite.Site_Nom} [${wSite.Site_GroupeId}, ${wSite.SiteId}]\n";
      }
      // ☀︎☀︎☀︎ SITE INSERT ☀︎☀︎☀︎
      else if (!wSite.Site_isUpdate && wSite.SiteId < 0) {
        wSt += "INSERT ${wSite.Site_Nom} [${wSite.Site_GroupeId}, ${wSite.SiteId}]\n";
      }
    }
    wSt += "\n";

    wSt += "Zones\n";
    List<Zone> ListZone = await DbTools.getZonesAll();
    for (int i = 0; i < ListZone.length; i++) {
      Zone wZone = ListZone[i];
      print("LISTE ${wZone.Zone_Nom} [${wZone.Zone_SiteId}, ${wZone.ZoneId}] ${wZone.Zone_isUpdate}");

      // ☀︎☀︎☀︎ ZONE UPDATE ☀︎☀︎☀︎
      if (!wZone.Zone_isUpdate && wZone.ZoneId >= 0) {
        wSt += "     UPDATE ${wZone.Zone_Nom} [${wZone.Zone_SiteId}, ${wZone.ZoneId}]\n";
      }
      // ☀︎☀︎☀︎ ZONE INSERT ☀︎☀︎☀︎
      else if (!wZone.Zone_isUpdate && wZone.ZoneId < 0) {
        wSt += "     INSERT ${wZone.Zone_Nom} [${wZone.Zone_SiteId}, ${wZone.ZoneId}]\n";
      }
    }
    wSt += "\n";

    wSt += "Interventions\n";
    List<Intervention> ListIntervention = await DbTools.getInterventionsAll();
    for (int i = 0; i < ListIntervention.length; i++) {
      Intervention wIntervention = ListIntervention[i];
      print("Interventions ${wIntervention.Intervention_Organes} [${wIntervention.Intervention_ZoneId}, ${wIntervention.InterventionId}] ${wIntervention.Intervention_isUpdate}");

      // ☀︎☀︎☀︎ INTERVENTION UPDATE ☀︎☀︎☀︎
      if (!wIntervention.Intervention_isUpdate && wIntervention.InterventionId >= 0) {
        wSt += "     UPDATE ${wIntervention.Intervention_Organes} [${wIntervention.Intervention_ZoneId}, ${wIntervention.InterventionId}]\n";
      }
      // ☀︎☀︎☀︎ INTERVENTION INSERT ☀︎☀︎☀︎
      else if (!wIntervention.Intervention_isUpdate && wIntervention.InterventionId < 0) {
        wSt += "     INSERT ${wIntervention.Intervention_Type} [Zone ${wIntervention.Intervention_ZoneId}, Interv ${wIntervention.InterventionId}]\n";
      }
    }
    wSt += "\n";

    wSt += "Parcs\n";

    List<Parc_Ent> ListParcs_Ent = await DbTools.getParcs_EntAll();
    for (int i = 0; i < ListParcs_Ent.length; i++) {
      Parc_Ent wParc_Ent = ListParcs_Ent[i];
      print("Parcs ${wParc_Ent.ParcsId} [${wParc_Ent.Parcs_InterventionId}] ${wParc_Ent.Parcs_Update}");
      if (wParc_Ent.Parcs_Update == 1) {
        wSt += "     > ${wParc_Ent.Parcs_InterventionId} ${wParc_Ent.Parcs_Type} - ${wParc_Ent.Parcs_EMP_Label} ${wParc_Ent.Parcs_NIV_Label} \n";
      }

/*
      // ☀︎☀︎☀︎ INTERVENTION UPDATE ☀︎☀︎☀︎
      if (!wParc_Ent.Intervention_isUpdate && wParc_Ent.InterventionId >= 0) {
        wSt += "UPDATE ${wParc_Ent.Intervention_Organes} [${wParc_Ent.Intervention_ZoneId}, ${wParc_Ent.InterventionId}]\n";
      }
      // ☀︎☀︎☀︎ INTERVENTION INSERT ☀︎☀︎☀︎
      else if (!wParc_Ent.Intervention_isUpdate && wParc_Ent.InterventionId < 0) {
        wSt += "INSERT ${wParc_Ent.Intervention_Organes} [${wParc_Ent.Intervention_ZoneId}, ${wParc_Ent.InterventionId}]\n";
      }
*/
    }
    wSt += "\n";

    wSt += "\n\n Fin";

    setState(() {});
  }

  @override
  void initState() {
    print("initState");
    super.initState();
    initLib();
  }

  @override
  void dispose() {
    print("dispose");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                "Verif Sync Liste",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.greyLight,
          height: 900,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Container(
                height: 10,
              ),
              Container(
                height: 10,
              ),
              new Expanded(
                flex: 1,
                child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical, //.horizontal
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        wSt,
                        style: gColors.bodyTitle1_N_G24,
                      ),
                    )),
              ),
              Container(
                color: gColors.black,
                height: 1,
              ),
            ],
          )),
      actions: <Widget>[
        iStrfExp
            ? Container()
            : ElevatedButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              )
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************
}
