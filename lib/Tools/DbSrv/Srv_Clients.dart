



/*
Client_delete
BEGIN
Delete FROM Groupes WHERE Groupe_ClientId =  OLD.ClientId;
Delete FROM Contacts WHERE Contact_ClientId =  OLD.ClientId AND Contact_Type = "FACT";
Delete FROM Contacts WHERE Contact_ClientId =  OLD.ClientId AND Contact_Type = "LIVR";
Delete FROM Adresses WHERE Adresse_ClientId =  OLD.ClientId AND Adresse_Type = "FACT";
Delete FROM Adresses WHERE Adresse_ClientId =  OLD.ClientId AND Adresse_Type = "LIVR";
END

Groupe_delete
BEGIN
Delete FROM Sites WHERE Site_GroupeId =  OLD.GroupeId;
Delete FROM Contacts WHERE Contact_ClientId =  OLD.GroupeId AND Contact_Type = "GRP";
Delete FROM Adresses WHERE Adresse_ClientId =  OLD.GroupeId AND Adresse_Type = "GRP";
END

Site_delete
BEGIN
Delete FROM Zones WHERE Zone_SiteId =  OLD.SiteId
Delete FROM Contacts WHERE Contact_ClientId =  OLD.SiteId AND Contact_Type = "SITE"
Delete FROM Adresses WHERE Adresse_ClientId =  OLD.SiteId AND Adresse_Type = "SITE";
END

Zones_delete
BEGIN
Delete FROM Interventions WHERE Intervention_ZoneId =  OLD.ZoneId;
Delete FROM Contacts WHERE Contact_ClientId =  OLD.ZoneId AND Contact_Type = "ZONE";
Delete FROM Adresses WHERE Adresse_ClientId =  OLD.ZoneId AND Adresse_Type = "ZONE";
END


Intervention_delete
BEGIN
Delete FROM InterMissions WHERE InterMission_InterventionId =  OLD.InterventionId
Delete FROM Parcs_Ent WHERE Parcs_InterventionId =  OLD.InterventionId
END

BEGIN
DELETE GR FROM Groupes GR LEFT JOIN Clients ON ClientId = GR.Groupe_ClientId WHERE ClientId IS NULL;
DELETE ST FROM Sites ST LEFT JOIN Groupes ON GroupeId = ST.Site_GroupeId WHERE GroupeId IS NULL;
DELETE ZN FROM Zones ZN LEFT JOIN Sites ON SiteId = ZN.Zone_SiteId WHERE SiteId IS NULL;
DELETE IT FROM Interventions IT LEFT JOIN Zones ON ZoneId = IT.Intervention_ZoneId WHERE ZoneId IS NULL;

DELETE PE FROM Parcs_Ent PE LEFT JOIN Interventions ON InterventionId = PE.Parcs_InterventionId WHERE InterventionId IS NULL;
DELETE IM FROM InterMissions IM LEFT JOIN Interventions ON InterventionId = IM.InterMission_InterventionId WHERE InterventionId IS NULL;

DELETE CT FROM Contacts CT LEFT JOIN Clients ON ClientId = CT.Contact_ClientId WHERE ClientId IS NULL AND Contact_Type = "FACT";
DELETE CT FROM Contacts CT LEFT JOIN Clients ON ClientId = CT.Contact_ClientId WHERE ClientId IS NULL AND Contact_Type = "LIVR";
DELETE AD FROM Adresses AD LEFT JOIN Clients ON ClientId = AD.Adresse_ClientId WHERE ClientId IS NULL AND Adresse_Type = "FACT";
DELETE AD FROM Adresses AD LEFT JOIN Clients ON ClientId = AD.Adresse_ClientId WHERE ClientId IS NULL AND Adresse_Type = "LIVR";
DELETE CT FROM Contacts CT LEFT JOIN Groupes ON GroupeId = CT.Contact_ClientId WHERE GroupeId IS NULL AND Contact_Type = "GRP";
DELETE AD FROM Adresses AD LEFT JOIN Groupes ON GroupeId = AD.Adresse_ClientId WHERE GroupeId IS NULL AND Adresse_Type = "GRP";
DELETE CT FROM Contacts CT LEFT JOIN Sites ON SiteId = CT.Contact_ClientId WHERE SiteId IS NULL AND Contact_Type = "SITE";
DELETE AD FROM Adresses AD LEFT JOIN Sites ON SiteId = AD.Adresse_ClientId WHERE SiteId IS NULL AND Adresse_Type = "SITE";
DELETE CT FROM Contacts CT LEFT JOIN Zones ON ZoneId = CT.Contact_ClientId WHERE ZoneId IS NULL AND Contact_Type = "ZONE";
DELETE AD FROM Adresses AD LEFT JOIN Zones ON ZoneId = AD.Adresse_ClientId WHERE ZoneId IS NULL AND Adresse_Type = "ZONE";
END


*/


class Client {
  int ClientId = -1;
  String Client_CodeGC = "";
  bool Client_CL_Pr = false;
  String Client_Famille = "";
  String Client_Rglt = "";
  String Client_Depot = "";

  bool Client_PersPhys = false;
  bool Client_OK_DataPerso = false;
  String Client_Civilite = "";
  String Client_Nom = "";
  String Client_Siret = "";
  String Client_NAF = "";
  String Client_TVA = "";
  String Client_Commercial = "";
  String Client_Createur = "";
  bool Client_Contrat = false;
  String Client_TypeContrat = "";
  String Client_Ct_Debut = "";
  String Client_Ct_Fin = "";
  String Client_Organes = "";

  String Adresse_Adr1     = "";
  String Adresse_CP     = "";
  String Adresse_Ville  = "";
  String Adresse_Pays   = "";
  String Livr   = "";

  static ClientInit() {
    return Client(0, "", false, "", "","", false, false, "", "", "", "", "", "", "", false, "","", "", "");
  }

  Client(
      int    ClientId,
      String Client_CodeGC,
      bool   Client_CL_Pr,
      String Client_Famille,
      String Client_Rglt,
      String Client_Depot,
      bool   Client_PersPhys,
      bool   Client_OK_DataPerso,
      String Client_Civilite,
      String Client_Nom,
      String Client_Siret,
      String Client_NAF,
      String Client_TVA,
      String Client_Commercial,
      String Client_Createur,
      bool   Client_Contrat,
      String Client_TypeContrat,
      String Client_Ct_Debut,
      String Client_Ct_Fin,
      String Client_Organes,
/*
      String Adresse_Adr1,
      String Adresse_CP,
      String Adresse_Ville,
      String Adresse_Pays,
*/
      ) {
    this.ClientId = ClientId;
    this.Client_CodeGC = Client_CodeGC;
    this.Client_CL_Pr = Client_CL_Pr;
    this.Client_Famille = Client_Famille;
    this.Client_Rglt = Client_Rglt;
    this.Client_Depot = Client_Depot;
    this.Client_PersPhys = Client_PersPhys;
    this.Client_OK_DataPerso = Client_OK_DataPerso;
    this.Client_Civilite = Client_Civilite;
    this.Client_Nom = Client_Nom;
    this.Client_Siret = Client_Siret;
    this.Client_NAF = Client_NAF;
    this.Client_TVA = Client_TVA;
    this.Client_Commercial = Client_Commercial;
    this.Client_Createur = Client_Createur;
    this.Client_Contrat     = Client_Contrat    ;
    this.Client_TypeContrat = Client_TypeContrat;
    this.Client_Ct_Debut       = Client_Ct_Debut      ;
    this.Client_Ct_Fin       = Client_Ct_Fin      ;
    this.Client_Organes     = Client_Organes    ;


/*
    this.Adresse_Adr1      = Adresse_Adr1     ;
    this.Adresse_CP      = Adresse_CP     ;
    this.Adresse_Ville   = Adresse_Ville  ;
    this.Adresse_Pays    = Adresse_Pays   ;
*/
  }


  Map<String, dynamic> toMap() {
    if (Client_CL_Pr == null) Client_CL_Pr = false;
    if (Client_CL_Pr == null) Client_CL_Pr = false;
    return {
      'ClientId': ClientId,
      'Client_CodeGC': Client_CodeGC,
      'Client_CL_Pr': Client_CL_Pr,
      'Client_Famille': Client_Famille,
      'Client_Rglt': Client_Rglt,
      'Client_Depot': Client_Depot,
      'Client_PersPhys': Client_PersPhys,
      'Client_OK_DataPerso': Client_OK_DataPerso,
      'Client_Civilite': Client_Civilite,
      'Client_Nom': Client_Nom,
      'Client_Siret': Client_Siret,
      'Client_NAF': Client_NAF,
      'Client_TVA': Client_TVA,
      'Client_Commercial': Client_Commercial,
      'Client_Createur': Client_Createur,
      'Client_Contrat': Client_Contrat,
      'Client_TypeContrat': Client_TypeContrat,
      'Client_Ct_Debut': Client_Ct_Debut,
      'Client_Ct_Fin': Client_Ct_Fin,
      'Client_Organes': Client_Organes,
      'Livr': Livr,
/*
      'Adresse_Adr1': Adresse_Adr1,
      'Adresse_CP': Adresse_CP,
      'Adresse_Ville': Adresse_Ville,
      'Adresse_Pays': Adresse_Pays,
*/
    };


  }



  factory Client.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    if (json['Adresse_Adr1'] == null) json['Adresse_Adr1'] ="";
    if (json['Adresse_CP'] == null) json['Adresse_CP'] ="";
    if (json['Adresse_Ville'] == null) json['Adresse_Ville'] ="";
    if (json['Adresse_Pays'] == null) json['Adresse_Pays'] ="";

    Client wTmp = Client(
      int.parse(json['ClientId']),
      json['Client_CodeGC'],
      int.parse(json['Client_CL_Pr']) == 1,
      json['Client_Famille'],
      json['Client_Rglt'],
      json['Client_Depot'],
      int.parse(json['Client_PersPhys']) == 1,
      int.parse(json['Client_OK_DataPerso']) == 1,
      json['Client_Civilite'],
      json['Client_Nom'],
      json['Client_Siret'],
      json['Client_NAF'],
      json['Client_TVA'],
      json['Client_Commercial'],
      json['Client_Createur'],
      int.parse(json['Client_Contrat']) == 1,
      json['Client_TypeContrat'],
      json['Client_Ct_Debut'],
      json['Client_Ct_Fin'],
      json['Client_Organes'],
/*
      json['Adresse_Adr1'],
      json['Adresse_CP'],
      json['Adresse_Ville'],
      json['Adresse_Pays'],
*/
    );
    return wTmp;
  }

  String Desc() {
    return '$ClientId, '
        '$ClientId '
        '$Client_CodeGC '
        '$Client_CL_Pr '
        '$Client_Famille '
        '$Client_Rglt '
        '$Client_Depot '
        '$Client_PersPhys '
        '$Client_OK_DataPerso '
        '$Client_Civilite	'
        '$Client_Nom	'
        '$Client_Siret	'
        '$Client_Nom	'
        '$Client_NAF	'
        '$Client_TVA	'
        '$Client_Commercial '
        '$Client_Createur '

        '$Client_Contrat '
        '$Client_TypeContrat '
        '$Client_Ct_Debut '
        '$Client_Ct_Fin '
        '$Client_Organes '

        '$Adresse_CP    '
        '$Adresse_Ville '
        '$Adresse_Pays  ';
  }
}
