


import 'package:path/path.dart';

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
  String Users_Nom = "";

  String Adresse_Adr1     = "";
  String Adresse_CP     = "";
  String Adresse_Ville  = "";
  String Adresse_Pays   = "";
  String Livr   = "";

  bool Client_isUpdate = true;


  static ClientInit() {
    return Client(0, "", false, "", "","", false, false, "", "", "", "", "", "", "", false, "","", "", "", "", false);
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
      String Users_Nom,
      bool Client_isUpdate,

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
    this.Users_Nom     = Users_Nom    ;
    this.Client_isUpdate     = Client_isUpdate    ;

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
      'Users_Nom': Users_Nom,
      'Livr': Livr,
      'Client_isUpdate': Client_isUpdate,
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
      "",
      true,

    );

    wTmp.Adresse_Adr1     = json['Adresse_Adr1'];
    wTmp.Adresse_CP     = json['Adresse_CP'];
    wTmp.Adresse_Ville  = json['Adresse_Ville'];
    wTmp.Adresse_Pays   = json['Adresse_Pays'];




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
        '$Users_Nom '
        '$Adresse_CP    '
        '$Adresse_Ville '
        '$Adresse_Pays  ';
  }
}
