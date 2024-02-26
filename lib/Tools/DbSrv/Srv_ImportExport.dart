import 'package:verifplus/Tools/DbSrv/Srv_Adresses.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Clients.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Contacts.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';

class Srv_ImportExport {
  Srv_ImportExport();


  // ☀︎☀︎☀︎ CLIENT UPDATE ☀︎☀︎☀︎
  static Future<bool> Client_Export_Update(Client wClient) async {
    print("Client à remonter ${wClient.Client_Nom} ${wClient.ClientId}");
    bool wRes = await Srv_DbTools.setClient(wClient);
    wClient.Client_isUpdate = wRes;
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateClients(wClient);
    print("Client à remonter Client wRes ${wRes}");
    return wRes;
  }

  // ☀︎☀︎☀︎ CLIENT INSERT ☀︎☀︎☀︎
  static Future<bool> Client_Export_Insert(Client wClient) async {
    print("Client à remonter INSERT  ${wClient.Client_Nom} ${wClient.ClientId}");
    bool wRes = await Srv_DbTools.addClient(wClient);
    if (wRes) {
      wClient.ClientId = Srv_DbTools.gLastID;
      print("Client à remonter INSERT OK ${wClient.Client_Nom} >>>> ${wClient.ClientId}");
      wRes = await Srv_DbTools.setClient(wClient);
    }
    wClient.Client_isUpdate = wRes;
    if (!wRes) DbTools.gErrorSync = true;
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateClients(wClient);
    return wRes;
  }

  // ☀︎☀︎☀︎ ADRESSE INSERT ☀︎☀︎☀︎
  static Future<bool> Adresse_Export_Insert(Client wClient, int saveClientId, String wType) async {
    await DbTools.getAdresseClientType(saveClientId, wType);
    Adresse wAdresse = Srv_DbTools.gAdresse;
     saveAdresseId = wAdresse.AdresseId;
    print("Adresse à remonter INSERT  ${wAdresse.Adresse_Adr1} ${wAdresse.AdresseId}");
    bool wRes = await Srv_DbTools.addAdresse(saveClientId, wType);
    if (wRes) {
      wAdresse.AdresseId = Srv_DbTools.gLastID;
      wAdresse.Adresse_ClientId = wClient.ClientId;
      wRes = await Srv_DbTools.setAdresse(wAdresse);
    }
    wAdresse.Adresse_isUpdate = wRes;
    if (!wRes) DbTools.gErrorSync = true;
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateAdresse(wAdresse);
    print("Adresse à remonter Adresse wRes ${wRes}");
    AdresseId = wAdresse.AdresseId;
    return wRes;
  }

  // ☀︎☀︎☀︎ ADRESSE INSERT ☀︎☀︎☀︎
  static Future<bool> Contact_Export_Insert(Client wClient, int saveClientId, String wType) async {
    await DbTools.getContactClientAdrType(saveClientId, saveAdresseId, wType);
    Contact wContact = Srv_DbTools.gContact;
    print("Contact à remonter INSERT  ${wContact.Contact_Nom} ${wContact.ContactId}");
    bool wRes = await Srv_DbTools.addContactAdrType(saveClientId, saveAdresseId, wType);
    if (wRes) {
      wContact.ContactId = Srv_DbTools.gLastID;
      wContact.Contact_ClientId = wClient.ClientId;
      wContact.Contact_AdresseId = AdresseId;
      wRes = await Srv_DbTools.setContact(wContact);
    }
    wContact.Contact_isUpdate = wRes;
    if (!wRes) DbTools.gErrorSync = true;
    Srv_DbTools.gContact.Contact_isUpdate = wRes;
    await DbTools.updateContact(wContact);
    print("Contact à remonter Contact wRes ${wRes}");

    return wRes;
  }



  static int saveClientId = 0;
  static int saveAdresseId = 0;
  static int AdresseId = 0;



  static Future ExportNotSync() async {

    DbTools.gErrorSync = false;
    Srv_DbTools.ListClient = await DbTools.getClients();
    for (int i = 0; i < Srv_DbTools.ListClient.length; i++) {
      Client wClient = Srv_DbTools.ListClient[i];
      // ☀︎☀︎☀︎ CLIENT UPDATE ☀︎☀︎☀︎
      if (!wClient.Client_isUpdate && wClient.ClientId >= 0) {
        bool wRes = await Client_Export_Update(wClient);
      }
      // ☀︎☀︎☀︎ CLIENT INSERT ☀︎☀︎☀︎
      else if (!wClient.Client_isUpdate && wClient.ClientId < 0) {
        saveClientId = wClient.ClientId;
        bool wRes = await Client_Export_Insert(wClient);

        print("Client à remonter INSERT Client wRes ${wRes}");
        if (wRes) {
          // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
          // ☀︎☀︎☀︎ ADRESSE CLIENT INSERT FACT ☀︎☀︎☀︎
          // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

          bool wRes = await Adresse_Export_Insert(wClient, saveClientId, "FACT");
          // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
          // ☀︎☀︎☀︎ CONTACT CLIENT INSERT FACT ☀︎☀︎☀︎
          // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
          if (wRes) {
            bool wRes = await Contact_Export_Insert(wClient, saveClientId, "FACT");
          }

          // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
          // ☀︎☀︎☀︎ ADRESSE CLIENT INSERT LIVR ☀︎☀︎☀︎
          // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

           wRes = await Adresse_Export_Insert(wClient, saveClientId, "LIVR");
          // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
          // ☀︎☀︎☀︎ CONTACT CLIENT INSERT FACT ☀︎☀︎☀︎
          // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
          if (wRes) {
            bool wRes = await Contact_Export_Insert(wClient, saveClientId, "LIVR");
          }


          if (wRes) {

            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎ GROUPE ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎


            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎ CONTACT GROUPE ☀︎☀︎☀︎☀︎
            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎


            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎ SITE   ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎ CONTACT SITE   ☀︎☀︎☀︎☀︎
            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎





          }












        }
      }
    }
    Srv_DbTools.ListClient = await DbTools.getClients();


    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
    // ☀︎☀︎☀︎ ADRESSE INSERT ☀︎☀︎☀︎
    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
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


    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
    // ☀︎☀︎☀︎ CONTACT INSERT ☀︎☀︎☀︎
    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

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
