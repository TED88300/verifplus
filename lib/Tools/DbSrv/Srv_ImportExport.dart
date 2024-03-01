import 'package:verifplus/Tools/DbSrv/Srv_Adresses.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Clients.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Contacts.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Groupes.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Zones.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';

class Srv_ImportExport {
  Srv_ImportExport();




  static Future getErrorSync() async {
    List<Client> ListClient = await DbTools.getClients();
    for (int i = 0; i < ListClient.length; i++) {
      Client wClient = ListClient[i];
      if (!wClient.Client_isUpdate ) {
        DbTools.setBoolErrorSync(true);
        return;
      }
    }

    List<Adresse> ListAdresse = await DbTools.getAdresse();
    for (int i = 0; i < ListAdresse.length; i++) {
      Adresse wAdresse = ListAdresse[i];

      if (!wAdresse.Adresse_isUpdate ) {
        DbTools.setBoolErrorSync(true);
        return;
      }
    }

    List<Contact> ListContact = await DbTools.getContact();
    for (int i = 0; i < ListContact.length; i++) {
      Contact wContact = ListContact[i];
      if (!wContact.Contact_isUpdate ) {
        DbTools.setBoolErrorSync(true);
        return;
      }
    }

    List<Groupe> ListGroupe = await DbTools.getGroupesAll();
    for (int i = 0; i < ListGroupe.length; i++) {
      Groupe wGroupe = ListGroupe[i];
      if (!wGroupe.Groupe_isUpdate ) {
        DbTools.setBoolErrorSync(true);
        return;
      }
    }

    List<Site> ListSite = await DbTools.getSitesAll();
    for (int i = 0; i < ListSite.length; i++) {
      Site wSite = ListSite[i];
      if (!wSite.Site_isUpdate) {
        DbTools.setBoolErrorSync(true);
        return;
      }
    }

    List<Zone> ListZone = await DbTools.getZonesAll();
    for (int i = 0; i < ListZone.length; i++) {
      Zone wZone = ListZone[i];
      if (!wZone.Zone_isUpdate) {
        DbTools.setBoolErrorSync(true);
        return;
      }
    }

    List<Intervention> ListIntervention = await DbTools.getInterventionsAll();
    for (int i = 0; i < ListIntervention.length; i++) {
      Intervention wIntervention = ListIntervention[i];
      if (!wIntervention.Intervention_isUpdate ) {
        DbTools.setBoolErrorSync(true);
        return;
      }
    }

    List<Parc_Ent> ListParcs_Ent = await DbTools.getParcs_EntAll();
    for (int i = 0; i < ListParcs_Ent.length; i++) {
      Parc_Ent wParc_Ent = ListParcs_Ent[i];
      if (wParc_Ent.Parcs_Update == 1) {
        DbTools.setBoolErrorSync(true);
        return;
      }
    }

    DbTools.setBoolErrorSync(false);


  }

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
      newClientId = Srv_DbTools.gLastID;
      print("Client à remonter INSERT OK ${wClient.Client_Nom} >>>> ${wClient.ClientId}");
      wRes = await Srv_DbTools.setClient(wClient);
    }
    wClient.Client_isUpdate = wRes;
    if (!wRes) DbTools.setBoolErrorSync(true);
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateClients(wClient);
    return wRes;
  }

  // ☀︎☀︎☀︎ GROUPE UPDATE ☀︎☀︎☀︎
  static Future<bool> Groupe_Export_Update(Groupe wGroupe) async {
    print("Groupe à remonter ${wGroupe.Groupe_Nom} ${wGroupe.GroupeId}");
    bool wRes = await Srv_DbTools.setGroupe(wGroupe);
    wGroupe.Groupe_isUpdate = wRes;
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateGroupes(wGroupe);
    print("Groupe à remonter Groupe wRes ${wRes}");
    return wRes;
  }

  // ☀︎☀︎☀︎ GROUPE INSERT ☀︎☀︎☀︎
  static Future<bool> Groupe_Export_Insert(Groupe wGroupe) async {
    print("Groupe à remonter INSERT  ${wGroupe.Groupe_Nom} ${wGroupe.GroupeId} ${newClientId}");
    bool wRes = await Srv_DbTools.addGroupe(newClientId);
    if (wRes) {
      wGroupe.Groupe_ClientId = newClientId;
      wGroupe.GroupeId = Srv_DbTools.gLastID;
      newGroupeId = Srv_DbTools.gLastID;
      print("Groupe à remonter INSERT OK ${wGroupe.Groupe_Nom} >>>> ${wGroupe.GroupeId}");
      wRes = await Srv_DbTools.setGroupe(wGroupe);
    }
    wGroupe.Groupe_isUpdate = wRes;
    if (!wRes) DbTools.setBoolErrorSync(true);
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateGroupes(wGroupe);
    return wRes;
  }

  // ☀︎☀︎☀︎ SITE UPDATE ☀︎☀︎☀︎
  static Future<bool> Site_Export_Update(Site wSite) async {
    print("Site à remonter ${wSite.Site_Nom} ${wSite.SiteId}");
    bool wRes = await Srv_DbTools.setSite(wSite);
    wSite.Site_isUpdate = wRes;
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateSites(wSite);
    print("Site à remonter Site wRes ${wRes}");
    return wRes;
  }

  // ☀︎☀︎☀︎ SITE INSERT ☀︎☀︎☀︎
  static Future<bool> Site_Export_Insert(Site wSite) async {
    print("Site à remonter INSERT  ${wSite.Site_Nom} ${wSite.SiteId}");
    bool wRes = await Srv_DbTools.addSite(newGroupeId);
    if (wRes) {
      wSite.Site_GroupeId = newGroupeId;
      wSite.SiteId = Srv_DbTools.gLastID;
      newSiteId = Srv_DbTools.gLastID;

      print("Site à remonter INSERT OK ${wSite.Site_Nom} >>>> ${wSite.SiteId}");
      wRes = await Srv_DbTools.setSite(wSite);
    }
    wSite.Site_isUpdate = wRes;
    if (!wRes) DbTools.setBoolErrorSync(true);
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateSites(wSite);
    return wRes;
  }

  // ☀︎☀︎☀︎ ZONE UPDATE ☀︎☀︎☀︎
  static Future<bool> Zone_Export_Update(Zone wZone) async {
    print("Zone à remonter ${wZone.Zone_Nom} ${wZone.ZoneId}");
    bool wRes = await Srv_DbTools.setZone(wZone);
    wZone.Zone_isUpdate = wRes;
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateZones(wZone);
    print("Zone à remonter Zone wRes ${wRes}");
    return wRes;
  }

  // ☀︎☀︎☀︎ ZONE INSERT ☀︎☀︎☀︎
  static Future<bool> Zone_Export_Insert(Zone wZone) async {
    print("Zone à remonter INSERT  ${wZone.Zone_Nom} ${wZone.ZoneId}");
    bool wRes = await Srv_DbTools.addZone(newSiteId);
    if (wRes) {
      wZone.Zone_SiteId = newSiteId;
      wZone.ZoneId = Srv_DbTools.gLastID;
      newZoneId = Srv_DbTools.gLastID;
      print("Zone à remonter INSERT OK ${wZone.Zone_Nom} >>>> ${wZone.ZoneId}");
      wRes = await Srv_DbTools.setZone(wZone);
    }
    wZone.Zone_isUpdate = wRes;
    if (!wRes) DbTools.setBoolErrorSync(true);
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateZones(wZone);
    return wRes;
  }

  // ☀︎☀︎☀︎ INTERVENTION UPDATE ☀︎☀︎☀︎
  static Future<bool> Intervention_Export_Update(Intervention wIntervention) async {
    print("Intervention à remonter ${wIntervention.Intervention_Type} ${wIntervention.InterventionId}");
    bool wRes = await Srv_DbTools.setIntervention(wIntervention);
    wIntervention.Intervention_isUpdate = wRes;
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateInterventions(wIntervention);
    print("Intervention à remonter Intervention wRes ${wRes}");
    return wRes;
  }

  // ☀︎☀︎☀︎ INTERVENTION INSERT ☀︎☀︎☀︎
  static Future<bool> Intervention_Export_Insert(Intervention wIntervention) async {
    print("Intervention à remonter INSERT  ${wIntervention.Intervention_Type} ${wIntervention.InterventionId}");
    bool wRes = await Srv_DbTools.addIntervention(newZoneId);
    if (wRes) {
      wIntervention.Intervention_ZoneId = newZoneId;
      wIntervention.InterventionId = Srv_DbTools.gLastID;
      newInterventionId = Srv_DbTools.gLastID;

      print("Intervention à remonter INSERT OK ${wIntervention.Intervention_Type} >>>> ${wIntervention.InterventionId}");
      wRes = await Srv_DbTools.setIntervention(wIntervention);
    }
    wIntervention.Intervention_isUpdate = wRes;
    if (!wRes) DbTools.setBoolErrorSync(true);
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateInterventions(wIntervention);
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
    if (!wRes) DbTools.setBoolErrorSync(true);
    Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
    await DbTools.updateAdresse(wAdresse);
    print("Adresse à remonter Adresse wRes ${wRes}");
    AdresseId = wAdresse.AdresseId;
    return wRes;
  }

  // ☀︎☀︎☀︎ CONTACT INSERT ☀︎☀︎☀︎
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
    if (!wRes) DbTools.setBoolErrorSync(true);
    Srv_DbTools.gContact.Contact_isUpdate = wRes;
    await DbTools.updateContact(wContact);
    print("Contact à remonter Contact wRes ${wRes}");

    return wRes;
  }

  static int saveClientId = 0;
  static int newClientId = 0;

  static int saveGroupeId = 0;
  static int newGroupeId = 0;

  static int saveSiteId = 0;
  static int newSiteId = 0;

  static int saveZoneId = 0;
  static int newZoneId = 0;

  static int saveInterventionId = 0;
  static int newInterventionId = 0;

  static int saveAdresseId = 0;
  static int AdresseId = 0;

  static Future ExportNotSync() async {
    DbTools.setBoolErrorSync(false);
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

            Srv_DbTools.ListGroupe = await DbTools.getGroupes(saveClientId);
            for (int ig = 0; ig < Srv_DbTools.ListGroupe.length; ig++) {
              Groupe wGroupe = Srv_DbTools.ListGroupe[ig];
              if (!wGroupe.Groupe_isUpdate && wGroupe.GroupeId >= 0) {
                bool wRes = await Groupe_Export_Update(wGroupe);
              } else if (!wGroupe.Groupe_isUpdate && wGroupe.GroupeId < 0) {
                saveGroupeId = wGroupe.GroupeId;
                bool wRes = await Groupe_Export_Insert(wGroupe);
                // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
                // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎ SITE   ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
                // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

                Srv_DbTools.ListSite = await DbTools.getSiteGroupe(saveGroupeId);
                for (int isi = 0; isi < Srv_DbTools.ListSite.length; isi++) {
                  Site wSite = Srv_DbTools.ListSite[isi];
                  if (!wSite.Site_isUpdate && wSite.SiteId >= 0) {
                    bool wRes = await Site_Export_Update(wSite);
                  } else if (!wSite.Site_isUpdate && wSite.SiteId < 0) {
                    saveSiteId = wSite.SiteId;
                    bool wRes = await Site_Export_Insert(wSite);

                    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
                    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎ ZONE  ☀︎☀︎☀︎☀︎☀︎
                    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

                    Srv_DbTools.ListZone = await DbTools.getZones(saveSiteId);
                    for (int iz = 0; iz < Srv_DbTools.ListZone.length; iz++) {
                      Zone wZone = Srv_DbTools.ListZone[iz];
                      if (!wZone.Zone_isUpdate && wZone.ZoneId >= 0) {
                        bool wRes = await Zone_Export_Update(wZone);
                      } else if (!wZone.Zone_isUpdate && wZone.ZoneId < 0) {
                        saveZoneId = wZone.ZoneId;
                        bool wRes = await Zone_Export_Insert(wZone);

                        // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
                        // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎ INTERVENTION  ☀︎☀︎☀︎☀︎☀︎
                        // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

                        Srv_DbTools.ListIntervention = await DbTools.getInterventions(saveZoneId);
                        for (int ii = 0; ii < Srv_DbTools.ListIntervention.length; ii++) {
                          Intervention wIntervention = Srv_DbTools.ListIntervention[ii];
                          if (!wIntervention.Intervention_isUpdate && wIntervention.InterventionId >= 0) {
                            bool wRes = await Intervention_Export_Update(wIntervention);
                          } else if (!wIntervention.Intervention_isUpdate && wIntervention.InterventionId < 0) {
                            bool wRes = await Intervention_Export_Insert(wIntervention);


                                DbTools.glfParcs_Ent = await DbTools.getParcs_Ent(wIntervention.InterventionId!);
                                  for (int j = 0; j < DbTools.lParcs_Ent.length; j++) {
                                    Parc_Ent wParc_Ent = DbTools.lParcs_Ent[j];
                                     if (wParc_Ent.Parcs_Update == 1 && wParc_Ent.Parcs_InterventionId! < 0) {
                                       wParc_Ent.Parcs_InterventionId = newInterventionId;
                                       await DbTools.updateParc_Ent(wParc_Ent);
                                    }
                                  }

                          }
                        }




                      }
                    }
                  }
                }
              }
            }

            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
            // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎ CONTACT GROUPE ☀︎☀︎☀︎☀︎
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
    // ☀︎☀︎☀︎ ADRESSE UPDATE ☀︎☀︎☀︎
    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
    Srv_DbTools.ListAdresse = await DbTools.getAdresse();
    for (int i = 0; i < Srv_DbTools.ListAdresse.length; i++) {
      Adresse wAdresse = Srv_DbTools.ListAdresse[i];
      if (!wAdresse.Adresse_isUpdate && wAdresse.AdresseId >= 0) {
        print("Adresse à remonter ${wAdresse.Adresse_Adr1}");
        bool wRes = await Srv_DbTools.setAdresse(wAdresse);
        wAdresse.Adresse_isUpdate = wRes;
        if (!wRes) DbTools.setBoolErrorSync(true);
        Srv_DbTools.gAdresse.Adresse_isUpdate = wRes;
        await DbTools.updateAdresse(wAdresse);
        print("Adresse à remonter Adresse wRes ${wRes}");
      }
    }
    Srv_DbTools.ListAdresse = await DbTools.getAdresse();

    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
    // ☀︎☀︎☀︎ CONTACT UPDATE ☀︎☀︎☀︎
    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

    Srv_DbTools.ListContact = await DbTools.getContact();
    print("Contact Srv_DbTools.ListContact.length ${Srv_DbTools.ListContact.length}");

    for (int i = 0; i < Srv_DbTools.ListContact.length; i++) {
      Contact wContact = Srv_DbTools.ListContact[i];

      if (!wContact.Contact_isUpdate && wContact.ContactId >= 0) {
        print("Contact à remonter ${wContact.Contact_Nom}");
        bool wRes = await Srv_DbTools.setContact(wContact);
        wContact.Contact_isUpdate = wRes;
        if (!wRes) DbTools.setBoolErrorSync(true);
        Srv_DbTools.gContact.Contact_isUpdate = wRes;
        await DbTools.updateContact(wContact);
        print("Contact à remonter Contact wRes ${wRes}");
      }
    }
    Srv_DbTools.ListContact = await DbTools.getContact();

    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
    // ☀︎☀︎☀︎ GROUPE UPDATE ☀︎☀︎☀︎
    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

    Srv_DbTools.ListGroupe = await DbTools.getGroupesAll();
    for (int i = 0; i < Srv_DbTools.ListGroupe.length; i++) {
      Groupe wGroupe = Srv_DbTools.ListGroupe[i];
      if (!wGroupe.Groupe_isUpdate && wGroupe.GroupeId >= 0) {
        bool wRes = await Groupe_Export_Update(wGroupe);
      } else if (!wGroupe.Groupe_isUpdate && wGroupe.GroupeId < 0) {
        bool wRes = await Groupe_Export_Insert(wGroupe);
      }
    }

    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
    // ☀︎☀︎☀︎ SITE UPDATE ☀︎☀︎☀︎
    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

    Srv_DbTools.ListSite = await DbTools.getSitesAll();
    for (int i = 0; i < Srv_DbTools.ListSite.length; i++) {
      Site wSite = Srv_DbTools.ListSite[i];
      if (!wSite.Site_isUpdate && wSite.SiteId >= 0) {
        bool wRes = await Site_Export_Update(wSite);
      } else if (!wSite.Site_isUpdate && wSite.SiteId < 0) {
        bool wRes = await Site_Export_Insert(wSite);
      }
    }

    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
    // ☀︎☀︎☀︎ INTERVENTION UPDATE ☀︎☀︎☀︎
    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

    Srv_DbTools.ListIntervention = await DbTools.getInterventionsAll();
    for (int i = 0; i < Srv_DbTools.ListIntervention.length; i++) {
      Intervention wIntervention = Srv_DbTools.ListIntervention[i];
      if (!wIntervention.Intervention_isUpdate && wIntervention.InterventionId >= 0) {
        bool wRes = await Intervention_Export_Update(wIntervention);
      } else if (!wIntervention.Intervention_isUpdate && wIntervention.InterventionId < 0) {
        bool wRes = await Intervention_Export_Insert(wIntervention);
      }
    }


    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎
    // ☀︎☀︎☀︎ Parcs_Ent UPDATE ☀︎☀︎☀︎
    // ☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎☀︎

    DbTools.glfParcs_Ent = await DbTools.getParcs_EntAll();
    for (int j = 0; j < DbTools.lParcs_Ent.length; j++) {
      Parc_Ent wParc_Ent = DbTools.lParcs_Ent[j];
      if (wParc_Ent.Parcs_Update == 1 && wParc_Ent.Parcs_InterventionId! < 0) {


        int NbDesc = 0;
        int NbArt = 0;

        DbTools.glfParcs_Ent = await DbTools.getParcs_Ent_Upd(wParc_Ent.Parcs_InterventionId!);
        print("glfParcs_Ent lenght ${DbTools.glfParcs_Ent.length}");

        DbTools.lParcs_Art.clear();
        DbTools.glfParcs_Art = await DbTools.getParcs_ArtInter(wParc_Ent.Parcs_InterventionId!);
        print("getParcs_ArtInter ${Srv_DbTools.gIntervention.InterventionId!}");
        print("glfParcs_Art lenght ${DbTools.glfParcs_Art.length}");
        DbTools.lParcs_Art.addAll(DbTools.glfParcs_Art);

//                    await Srv_DbTools.delParc_Ent_Srv(Srv_DbTools.gIntervention.InterventionId!);
        await Srv_DbTools.delParc_Ent_Srv_Upd();

        for (int i = 0; i < DbTools.glfParcs_Ent.length; i++) {
          var element = DbTools.glfParcs_Ent[i];
          await Srv_DbTools.InsertUpdateParc_Ent_Srv(element);

          int gLastID = Srv_DbTools.gLastID;
          print("Srv_DbTools.gLastID ${gLastID}      <   ${element.ParcsId}");

          String wSql = "";
          for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
            var element2 = DbTools.glfParcs_Desc[i];
            if (element2.ParcsDesc_ParcsId == element.ParcsId) {
              NbDesc++;
              element2.ParcsDesc_ParcsId = gLastID;
              String wTmp = Srv_DbTools.InsertUpdateParc_Desc_Srv_GetSql(element2);
              wSql = "${wSql} ${wTmp};";
            }
          }

          if (wSql.isNotEmpty) {
            await Srv_DbTools.InsertUpdateParc_Desc_Srv_Sql(wSql);
          }

          wSql = "";
          for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
            var element2 = DbTools.lParcs_Art[i];
            if (element2.ParcsArt_ParcsId == element.ParcsId) {
              NbArt++;
              element2.ParcsArt_ParcsId = gLastID;
              String wTmp = Srv_DbTools.InsertUpdateParc_Art_Srv_GetSql(element2);
              wSql = "${wSql} ${wTmp};";
            }
          }

          if (wSql.isNotEmpty) {
            await Srv_DbTools.InsertUpdateParc_Art_Srv_Sql(wSql);
          }

          print(" updateParc_Ent_Update");
          await DbTools.updateParc_Ent_Update(element.ParcsId!, 0);
        }

      }
    }


  }

  //******************************************************************
  //******************************************************************
  //******************************************************************

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

  static Future<bool> ImportGSZ(int ID) async {
    bool wRet = await ImportGroupe(ID);
    wRet = await ImportSite(ID);

    return false;
  }

  static Future<bool> ImportGroupe(int ID) async {
    bool wResult = await Srv_DbTools.getGroupesClient(ID);
    print("ImportGroupe Groupe wResult ${wResult}");
    if (wResult) {
      await DbTools.TrunckGroupes();
      for (int i = 0; i < Srv_DbTools.ListGroupe.length; i++) {
        Groupe wGroupe = Srv_DbTools.ListGroupe[i];
        await DbTools.inserGroupes(wGroupe);
      }
      Srv_DbTools.ListGroupe = await DbTools.getGroupes(ID);
      print("ImportGroupe Srv_DbTools.ListGroupe ${Srv_DbTools.ListGroupe}");
      return true;
    }
    Srv_DbTools.ListGroupe = await DbTools.getGroupes(ID);
    print("ImportGroupe Srv_DbTools.ListGroupe ${Srv_DbTools.ListGroupe}");
    return false;
  }

  static Future<bool> ImportSite(int ID) async {
    bool wResult = await Srv_DbTools.getSitesGroupe(ID);
    print("ImportSite Groupe wResult ${wResult}");
    if (wResult) {
      await DbTools.TrunckSites();
      for (int i = 0; i < Srv_DbTools.ListSite.length; i++) {
        Site wSite = Srv_DbTools.ListSite[i];
        await DbTools.inserSites(wSite);
      }
      Srv_DbTools.ListSite = await DbTools.getSiteGroupe(ID);
      print("ImportSite Srv_DbTools.ListSite ${Srv_DbTools.ListSite}");
      return true;
    }
    Srv_DbTools.ListSite = await DbTools.getSiteGroupe(ID);
    print("ImportSite Srv_DbTools.ListSite ${Srv_DbTools.ListSite}");
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
