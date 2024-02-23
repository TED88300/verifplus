import 'package:verifplus/Tools/DbSrv/Srv_Adresses.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Clients.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Contacts.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';

class Srv_ImportExport {
  Srv_ImportExport();

  static Future ExportNotSync() async {
    DbTools.gErrorSync = false;
    Srv_DbTools.ListClient = await DbTools.getClients();
    for (int i = 0; i < Srv_DbTools.ListClient.length; i++) {
      Client wClient = Srv_DbTools.ListClient[i];
      if (!wClient.Client_isUpdate && wClient.ClientId >= 0) {
        print("Client à remonter ${wClient.Client_Nom}");
        bool wRes = await Srv_DbTools.setClient(wClient);
        wClient.Client_isUpdate = wRes;
        if (!wRes) DbTools.gErrorSync = true;
        Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
        await DbTools.updateClients(wClient);
        print("Client à remonter Client wRes ${wRes}");
      }




    }
    Srv_DbTools.ListClient = await DbTools.getClients();


    Srv_DbTools.ListAdresse = await DbTools.getAdresse();
    for (int i = 0; i < Srv_DbTools.ListAdresse.length; i++) {
      Adresse wAdresse = Srv_DbTools.ListAdresse[i];
      if (!wAdresse.Adresse_isUpdate && wAdresse.AdresseId >= 0) {
        print("Adresse à remonter ${wAdresse.Adresse_Adr1}");
        bool wRes = await Srv_DbTools.setAdresse(wAdresse);
        wAdresse.Adresse_isUpdate = wRes;
        if (!wRes) DbTools.gErrorSync = true;
        Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
        await DbTools.updateAdresse(wAdresse);
        print("Adresse à remonter Adresse wRes ${wRes}");

      }
    }
    Srv_DbTools.ListAdresse = await DbTools.getAdresse();

    Srv_DbTools.ListContact = await DbTools.getContact();
    print("Contact Srv_DbTools.ListContact.length ${Srv_DbTools.ListContact.length}");

    for (int i = 0; i < Srv_DbTools.ListContact.length; i++) {
      Contact wContact = Srv_DbTools.ListContact[i];

      if (!wContact.Contact_isUpdate && wContact.ContactId >= 0) {
        print("Contact à remonter ${wContact.Contact_Nom}");
        bool wRes = await Srv_DbTools.setContact(wContact);
        wContact.Contact_isUpdate = wRes;
        if (!wRes) DbTools.gErrorSync = true;
        Srv_DbTools.gContact.Contact_isUpdate = wRes;
        await DbTools.updateContact(wContact);
        print("Contact à remonter Contact wRes ${wRes}");
      }
    }
    Srv_DbTools.ListContact = await DbTools.getContact();





  }


  static Future<bool> ImportClient() async {
    bool wResult = await Srv_DbTools.IMPORT_ClientAll();
    print("ImportClient wResult ${wResult}");
    if (wResult) {
      await DbTools.TrunckClients();
      for (int i = 0; i < Srv_DbTools.ListClient.length; i++) {
        Client wClient = Srv_DbTools.ListClient[i];
        await DbTools.inserClients(wClient);
      }
      Srv_DbTools.ListClient = await DbTools.getClients();
      print("Import_DataDialog ON LINE Srv_DbTools.ListClient ${Srv_DbTools.ListClient}");
      return true;
    }
    Srv_DbTools.ListClient = await DbTools.getClients();
    print("Import_DataDialog OFF LINE Srv_DbTools.ListClient ${Srv_DbTools.ListClient}");
    return false;
  }

  static Future<bool> ImportAdresse() async {
    bool wResult = await Srv_DbTools.IMPORT_AdresseAll();
    print("ImportAdresse wResult ${wResult}");
    if (wResult) {
      await DbTools.TrunckAdresse();
      for (int i = 0; i < Srv_DbTools.ListAdresse.length; i++) {
        Adresse wAdresse = Srv_DbTools.ListAdresse[i];
        await DbTools.inserAdresse(wAdresse);
      }
      Srv_DbTools.ListAdresse = await DbTools.getAdresse();
      print("Import_DataDialog Srv_DbTools.ListAdresse ${Srv_DbTools.ListAdresse}");
      return true;
    }
    Srv_DbTools.ListAdresse = await DbTools.getAdresse();
    print("Import_DataDialog Srv_DbTools.ListAdresse ${Srv_DbTools.ListAdresse}");
    return false;
  }

  static Future<bool> ImportContact() async {
    bool wResult = await Srv_DbTools.getContactAll();
    print("ImportContact wResult ${wResult}");
    if (wResult) {
      await DbTools.TrunckContact();
      for (int i = 0; i < Srv_DbTools.ListContact.length; i++) {
        Contact wContact = Srv_DbTools.ListContact[i];
        await DbTools.inserContact(wContact);
      }
      Srv_DbTools.ListContact = await DbTools.getContact();
      print("Import_DataDialog Srv_DbTools.ListContact ${Srv_DbTools.ListContact}");
      return true;
    }
    Srv_DbTools.ListContact = await DbTools.getContact();
    print("Import_DataDialog Srv_DbTools.ListContact ${Srv_DbTools.ListContact}");
    return false;
  }


  static Future<bool> ImportParam_ParamAll() async {
    bool wResult = await Srv_DbTools.getParam_ParamAll();

    print("ImportContact wResult ${wResult}");
    if (wResult) {
      await DbTools.TrunckContact();
      for (int i = 0; i < Srv_DbTools.ListContact.length; i++) {
        Contact wContact = Srv_DbTools.ListContact[i];
        await DbTools.inserContact(wContact);
      }
      Srv_DbTools.ListContact = await DbTools.getContact();
      print("Import_DataDialog Srv_DbTools.ListContact ${Srv_DbTools.ListContact}");
      return true;
    }
    Srv_DbTools.ListContact = await DbTools.getContact();
    print("Import_DataDialog Srv_DbTools.ListContact ${Srv_DbTools.ListContact}");
    return false;
  }





}

