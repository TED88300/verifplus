import 'dart:typed_data';

class DCL_Ent {
  int? DCL_EntID;
  String? DCL_Ent_Type;
  String? DCL_Ent_Num;
  int? DCL_Ent_Version;
  int? DCL_Ent_ClientId;
  int? DCL_Ent_GroupeId;
  int? DCL_Ent_SiteId;
  int? DCL_Ent_ZoneId;
  int? DCL_Ent_InterventionId;
  String? DCL_Ent_Date;
  String? DCL_Ent_Statut;
  String? DCL_Ent_Etat;
  String? DCL_Ent_EtatMotif;
  String? DCL_Ent_EtatNote;
  String? DCL_Ent_EtatAction;
  String? DCL_Ent_Collaborateur;
  String? DCL_Ent_Affaire;
  String? DCL_Ent_AffaireNote;

  String? DCL_Ent_Validite;
  String? DCL_Ent_LivrPrev;
  String? DCL_Ent_ModeRegl;
  String? DCL_Ent_MoyRegl;
  int? DCL_Ent_Valo;

  String? DCL_Ent_PrefAff;
  String? DCL_Ent_RelAuto;
  String? DCL_Ent_RelAnniv;
  String? DCL_Ent_CopRel;

  int? DCL_Ent_RelanceAuto;
  int? DCL_Ent_RelanceAnniv;
  String? DCL_Ent_RelanceMode;
  String? DCL_Ent_RelanceContact;
  String? DCL_Ent_RelanceMail;
  String? DCL_Ent_RelanceTel;

  int? DCL_Ent_Proba;
  String? DCL_Ent_Proba_Note;

  String? DCL_Ent_Concurent;
  String? DCL_Ent_Note;
  String? DCL_Ent_Regl;
  String? DCL_Ent_Partage;
  String? DCL_Ent_Contributeurs;
  String? DCL_Ent_DemTech;
  String? DCL_Ent_DemSsT;

  double? DCL_Ent_MtHT;
  double? DCL_Ent_MtTVA;
  double? DCL_Ent_MtTTC;

  String? DCL_Signataire_Tech = "";
  Uint8List DCL_Signature_Tech = Uint8List.fromList([]);
  String? DCL_Signataire_Date = "";

  String? DCL_Signataire_Client       = "";
  String? DCL_Signature_Client        = "";
  String? DCL_Signataire_Date_Client = "";




  String? DCL_Ent_ClientNom = "";
  String? DCL_Ent_GroupeNom = "";
  String? DCL_Ent_SiteNom = "";
  String? DCL_Ent_ZoneNom = "";
  String? DCL_Ent_InterventionNom = "";

  String? DCL_Ent_CCGSZ = "";
  String? DCL_Ent_Adr1 = "";
  String? DCL_Ent_Adr2 = "";

  bool DCL_Ent_isOptions = false;

  static DCL_EntInit() {
    return DCL_Ent(
       0,
       "",
       "",
       0,
       0,
       0,
       0,
       0,
       0,
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
      "",
      0,
      "",
       "",
      "",
      "",
      0,
      0,
      "",
       "",
       "",
       "",
       0,
      "",
       "",
       "",
       "",
        "",
       "",
       "",
       "",
       0,
       0,
       0,
       "",
       Uint8List.fromList([]),
       "",
       "",
       "",
       "",
    );
  }



  DCL_Ent(
  int?    DCL_EntID,
  String? DCL_Ent_Type,
  String? DCL_Ent_Num,
  int?    DCL_Ent_Version,
  int?    DCL_Ent_ClientId,
  int?    DCL_Ent_GroupeId,
  int?    DCL_Ent_SiteId,
  int?    DCL_Ent_ZoneId,
  int?    DCL_Ent_InterventionId,
  String? DCL_Ent_Date,
  String? DCL_Ent_Statut,
  String? DCL_Ent_Etat,
  String? DCL_Ent_EtatMotif,
  String? DCL_Ent_EtatNote,
  String? DCL_Ent_EtatAction,
  String? DCL_Ent_Collaborateur,
  String? DCL_Ent_Affaire,
  String? DCL_Ent_AffaireNote,
  String? DCL_Ent_Validite,
  String? DCL_Ent_LivrPrev,
  String? DCL_Ent_ModeRegl,
  String? DCL_Ent_MoyRegl,
  int?    DCL_Ent_Valo,
  String? DCL_Ent_PrefAff,
  String? DCL_Ent_RelAuto,
  String? DCL_Ent_RelAnniv,
  String? DCL_Ent_CopRel,
  int?    DCL_Ent_RelanceAuto,
  int?    DCL_Ent_RelanceAnniv,
  String? DCL_Ent_RelanceMode,
  String? DCL_Ent_RelanceContact,
  String? DCL_Ent_RelanceMail,
  String? DCL_Ent_RelanceTel,
  int?    DCL_Ent_Proba,
  String? DCL_Ent_Proba_Note,
  String? DCL_Ent_Concurent,
  String? DCL_Ent_Note,
  String? DCL_Ent_Regl,
  String? DCL_Ent_Partage,
  String? DCL_Ent_Contributeurs,
  String? DCL_Ent_DemTech,
  String? DCL_Ent_DemSsT,
  double? DCL_Ent_MtHT,
  double? DCL_Ent_MtTVA,
  double? DCL_Ent_MtTTC,
  String? DCL_Signataire_Tech ,
  Uint8List DCL_Signature_Tech,
  String? DCL_Signataire_Date ,
  String? DCL_Signataire_Client      ,
  String? DCL_Signature_Client       ,
  String? DCL_Signataire_Date_Client ,
  ) {
  this.DCL_EntID = DCL_EntID;
  this.DCL_Ent_Type = DCL_Ent_Type;
  this.DCL_Ent_Num = DCL_Ent_Num;
  this.DCL_Ent_Version = DCL_Ent_Version;
  this.DCL_Ent_ClientId = DCL_Ent_ClientId;
  this.DCL_Ent_GroupeId = DCL_Ent_GroupeId;
  this.DCL_Ent_SiteId = DCL_Ent_SiteId;
  this.DCL_Ent_ZoneId = DCL_Ent_ZoneId;
  this.DCL_Ent_InterventionId = DCL_Ent_InterventionId;
  this.DCL_Ent_Date = DCL_Ent_Date;
  this.DCL_Ent_Statut = DCL_Ent_Statut;
  this.DCL_Ent_Etat = DCL_Ent_Etat;
  this.DCL_Ent_EtatMotif = DCL_Ent_EtatMotif;
  this.DCL_Ent_EtatNote = DCL_Ent_EtatNote;
  this.DCL_Ent_EtatAction = DCL_Ent_EtatAction;
  this.DCL_Ent_Collaborateur = DCL_Ent_Collaborateur;
  this.DCL_Ent_Affaire = DCL_Ent_Affaire;
  this.DCL_Ent_AffaireNote = DCL_Ent_AffaireNote;
  this.DCL_Ent_Validite = DCL_Ent_Validite;
  this.DCL_Ent_LivrPrev = DCL_Ent_LivrPrev;
  this.DCL_Ent_ModeRegl = DCL_Ent_ModeRegl;
  this.DCL_Ent_MoyRegl = DCL_Ent_MoyRegl;
  this.DCL_Ent_Valo = DCL_Ent_Valo;
  this.DCL_Ent_PrefAff = DCL_Ent_PrefAff;
  this.DCL_Ent_RelAuto = DCL_Ent_RelAuto;
  this.DCL_Ent_RelAnniv = DCL_Ent_RelAnniv;
  this.DCL_Ent_CopRel = DCL_Ent_CopRel;
  this.DCL_Ent_RelanceAuto = DCL_Ent_RelanceAuto;
  this.DCL_Ent_RelanceAnniv = DCL_Ent_RelanceAnniv;
  this.DCL_Ent_RelanceMode = DCL_Ent_RelanceMode;
  this.DCL_Ent_RelanceContact = DCL_Ent_RelanceContact;
  this.DCL_Ent_RelanceMail = DCL_Ent_RelanceMail;
  this.DCL_Ent_RelanceTel = DCL_Ent_RelanceTel;
  this.DCL_Ent_Proba = DCL_Ent_Proba;
  this.DCL_Ent_Proba_Note = DCL_Ent_Proba_Note;
  this.DCL_Ent_Concurent = DCL_Ent_Concurent;
  this.DCL_Ent_Note = DCL_Ent_Note;
  this.DCL_Ent_Regl = DCL_Ent_Regl;
  this.DCL_Ent_Partage = DCL_Ent_Partage;
  this.DCL_Ent_Contributeurs = DCL_Ent_Contributeurs;
  this.DCL_Ent_DemTech = DCL_Ent_DemTech;
  this.DCL_Ent_DemSsT = DCL_Ent_DemSsT;
  this.DCL_Ent_MtHT = DCL_Ent_MtHT;
  this.DCL_Ent_MtTVA = DCL_Ent_MtTVA;
  this.DCL_Ent_MtTTC = DCL_Ent_MtTTC;
  this.DCL_Signataire_Tech   = DCL_Signataire_Tech  ;
  this.DCL_Signature_Tech    = DCL_Signature_Tech   ;
  this.DCL_Signataire_Date   = DCL_Signataire_Date  ;
  this.DCL_Signataire_Client = DCL_Signataire_Client;
  this.DCL_Signature_Client  = DCL_Signature_Client ;
  this.DCL_Signataire_Date_Client = DCL_Signataire_Date_Client;
  }


  DCL_Ent.fromJson(Map<String, dynamic> json) {
//    gColors.printWrapped("json ${json}");
    Uint8List wUint8ListTech = Uint8List.fromList([]);
    if (json['DCL_Signature_Tech'].toString().isNotEmpty) {
      String value = json['DCL_Signature_Tech'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8ListTech = Uint8List.fromList(list);
      }
    }

    DCL_EntID = int.parse(json['DCL_EntID']);
    DCL_Ent_Type = json['DCL_Ent_Type'];
    DCL_Ent_Num = json['DCL_Ent_Num'];
    DCL_Ent_Version = int.parse(json['DCL_Ent_Version']);
    DCL_Ent_ClientId = int.parse(json['DCL_Ent_ClientId']);
    DCL_Ent_GroupeId = int.parse(json['DCL_Ent_GroupeId']);
    DCL_Ent_SiteId = int.parse(json['DCL_Ent_SiteId']);
    DCL_Ent_ZoneId = int.parse(json['DCL_Ent_ZoneId']);
    DCL_Ent_InterventionId = int.parse(json['DCL_Ent_InterventionId']);
    DCL_Ent_Date = json['DCL_Ent_Date'];
    DCL_Ent_Statut = json['DCL_Ent_Statut'];
    DCL_Ent_Etat = json['DCL_Ent_Etat'];
    DCL_Ent_EtatMotif = json['DCL_Ent_Etat_Motif'];
    DCL_Ent_EtatNote = json['DCL_Ent_Etat_Note'];
    DCL_Ent_EtatAction = json['DCL_Ent_Etat_Action'];
    DCL_Ent_Collaborateur = json['DCL_Ent_Collaborateur'];
    DCL_Ent_Affaire = json['DCL_Ent_Affaire'];
    DCL_Ent_AffaireNote = json['DCL_Ent_Affaire_Note'];
    DCL_Ent_Validite = json['DCL_Ent_Validite'];
    DCL_Ent_LivrPrev = json['DCL_Ent_LivrPrev'];
    DCL_Ent_ModeRegl = json['DCL_Ent_ModeRegl'];
    DCL_Ent_MoyRegl = json['DCL_Ent_MoyRegl'];
    DCL_Ent_PrefAff = json['DCL_Ent_PrefAff'];
    DCL_Ent_RelAuto = json['DCL_Ent_RelAuto'];
    DCL_Ent_RelAnniv = json['DCL_Ent_RelAnniv'];
    DCL_Ent_CopRel = json['DCL_Ent_CopRel'];
    DCL_Ent_Valo = int.parse(json['DCL_Ent_Valo']);
    DCL_Ent_RelanceAuto = int.parse(json['DCL_Ent_RelanceAuto']);
    DCL_Ent_RelanceAnniv = int.parse(json['DCL_Ent_RelanceAnniv']);
    DCL_Ent_RelanceMode = json['DCL_Ent_Relance_Mode'];
    DCL_Ent_RelanceContact = json['DCL_Ent_Relance_Contact'];
    DCL_Ent_RelanceMail = json['DCL_Ent_Relance_Mail'];
    DCL_Ent_RelanceTel = json['DCL_Ent_Relance_Tel'];
    DCL_Ent_Proba = int.parse(json['DCL_Ent_Proba']);
    DCL_Ent_Proba_Note = json['DCL_Ent_Proba_Note'];
    DCL_Ent_Concurent = json['DCL_Ent_Concurent'];
    DCL_Ent_Note = json['DCL_Ent_Note'];
    DCL_Ent_Regl = json['DCL_Ent_Regl'];
    DCL_Ent_Partage = json['DCL_Ent_Partage'];
    DCL_Ent_Contributeurs = json['DCL_Ent_Contributeurs'];
    DCL_Ent_DemTech = json['DCL_Ent_Dem_Tech'];
    DCL_Ent_DemSsT = json['DCL_Ent_Dem_SsT'];

    DCL_Ent_MtHT = double.parse(json['DCL_Ent_MtHT']);
    DCL_Ent_MtTVA = double.parse(json['DCL_Ent_MtTVA']);
    DCL_Ent_MtTTC = double.parse(json['DCL_Ent_MtTTC']);

    DCL_Signataire_Tech = json['DCL_Signataire_Tech'];
    DCL_Signature_Tech = wUint8ListTech;
    DCL_Signataire_Date = json['DCL_Signataire_Date'];

    DCL_Signataire_Client = json['DCL_Signataire_Client'];
    DCL_Signature_Client = json['DCL_Signature_Client'];
    DCL_Signataire_Date_Client = json['DCL_Signataire_Date_Client'];
    DCL_Ent_ClientNom = json['DCL_Ent_ClientNom'];
  }

  Map<String, dynamic> toMapInsert() {
    return {
      'DCL_Ent_Type': DCL_Ent_Type,
      'DCL_Ent_Num': DCL_Ent_Num,
      'DCL_Ent_Version': DCL_Ent_Version,
      'DCL_Ent_ClientId': DCL_Ent_ClientId,
      'DCL_Ent_GroupeId': DCL_Ent_GroupeId,
      'DCL_Ent_SiteId': DCL_Ent_SiteId,
      'DCL_Ent_ZoneId': DCL_Ent_ZoneId,
      'DCL_Ent_InterventionId': DCL_Ent_InterventionId,
      'DCL_Ent_Date': DCL_Ent_Date,
      'DCL_Ent_Statut': DCL_Ent_Statut,
      'DCL_Ent_Etat': DCL_Ent_Etat,
      'DCL_Ent_Etat_Motif': DCL_Ent_EtatMotif,
      'DCL_Ent_Etat_Note': DCL_Ent_EtatNote,
      'DCL_Ent_Etat_Action': DCL_Ent_EtatAction,
      'DCL_Ent_Collaborateur': DCL_Ent_Collaborateur,
      'DCL_Ent_Affaire': DCL_Ent_Affaire,
      'DCL_Ent_Affaire_Note': DCL_Ent_AffaireNote,
      'DCL_Ent_Validite': DCL_Ent_Validite,
      'DCL_Ent_LivrPrev': DCL_Ent_LivrPrev,
      'DCL_Ent_ModeRegl': DCL_Ent_ModeRegl,
      'DCL_Ent_MoyRegl': DCL_Ent_MoyRegl,
      'DCL_Ent_PrefAff': DCL_Ent_PrefAff,
      'DCL_Ent_RelAuto': DCL_Ent_RelAuto,
      'DCL_Ent_RelAnniv': DCL_Ent_RelAnniv,
      'DCL_Ent_CopRel': DCL_Ent_CopRel,
      'DCL_Ent_Valo': DCL_Ent_Valo,
      'DCL_Ent_RelanceAuto': DCL_Ent_RelanceAuto,
      'DCL_Ent_RelanceAnniv': DCL_Ent_RelanceAnniv,
      'DCL_Ent_Relance_Mode': DCL_Ent_RelanceMode,
      'DCL_Ent_Relance_Contact': DCL_Ent_RelanceContact,
      'DCL_Ent_Relance_Mail': DCL_Ent_RelanceMail,
      'DCL_Ent_Relance_Tel': DCL_Ent_RelanceTel,
      'DCL_Ent_Proba': DCL_Ent_Proba,
      'DCL_Ent_Proba_Note': DCL_Ent_Proba_Note,
      'DCL_Ent_Concurent': DCL_Ent_Concurent,
      'DCL_Ent_Note': DCL_Ent_Note,
      'DCL_Ent_Regl': DCL_Ent_Regl,
      'DCL_Ent_Partage': DCL_Ent_Partage,
      'DCL_Ent_Contributeurs': DCL_Ent_Contributeurs,
      'DCL_Ent_Dem_Tech': DCL_Ent_DemTech,
      'DCL_Ent_Dem_SsT': DCL_Ent_DemSsT,
      'DCL_Ent_MtHT': DCL_Ent_MtHT,
      'DCL_Ent_MtTVA': DCL_Ent_MtTVA,
      'DCL_Ent_MtTTC': DCL_Ent_MtTTC,
      'DCL_Signataire_Tech': DCL_Signataire_Tech,
      'DCL_Signature_Tech': DCL_Signature_Tech,
      'DCL_Signataire_Date': DCL_Signataire_Date,
      'DCL_Signataire_Client': DCL_Signataire_Client,
      'DCL_Signature_Client': DCL_Signature_Client,
      'DCL_Signataire_Date_Client': DCL_Signataire_Date_Client,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DCL_EntID'] = DCL_EntID;
    data['DCL_Ent_Type'] = DCL_Ent_Type;
    data['DCL_Ent_Num'] = DCL_Ent_Num;
    data['DCL_Ent_Version'] = DCL_Ent_Version;
    data['DCL_Ent_ClientId'] = DCL_Ent_ClientId;
    data['DCL_Ent_GroupeId'] = DCL_Ent_GroupeId;
    data['DCL_Ent_SiteId'] = DCL_Ent_SiteId;
    data['DCL_Ent_ZoneId'] = DCL_Ent_ZoneId;
    data['DCL_Ent_InterventionId'] = DCL_Ent_InterventionId;
    data['DCL_Ent_Date'] = DCL_Ent_Date;
    data['DCL_Ent_Statut'] = DCL_Ent_Statut;
    data['DCL_Ent_Etat'] = DCL_Ent_Etat;
    data['DCL_Ent_Etat_Motif'] = DCL_Ent_EtatMotif;
    data['DCL_Ent_Etat_Note'] = DCL_Ent_EtatNote;
    data['DCL_Ent_Etat_Action'] = DCL_Ent_EtatAction;
    data['DCL_Ent_Collaborateur'] = DCL_Ent_Collaborateur;
    data['DCL_Ent_Affaire'] = DCL_Ent_Affaire;
    data['DCL_Ent_Affaire_Note'] = DCL_Ent_AffaireNote;
    data['DCL_Ent_Validite'] = DCL_Ent_Validite;
    data['DCL_Ent_LivrPrev'] = DCL_Ent_LivrPrev;
    data['DCL_Ent_ModeRegl'] = DCL_Ent_ModeRegl;
    data['DCL_Ent_MoyRegl'] = DCL_Ent_MoyRegl;
    data['DCL_Ent_PrefAff'] = DCL_Ent_PrefAff;
    data['DCL_Ent_RelAuto'] = DCL_Ent_RelAuto;
    data['DCL_Ent_RelAnniv'] = DCL_Ent_RelAnniv;
    data['DCL_Ent_CopRel'] = DCL_Ent_CopRel;
    data['DCL_Ent_Valo'] = DCL_Ent_Valo;
    data['DCL_Ent_RelanceAuto'] = DCL_Ent_RelanceAuto;
    data['DCL_Ent_RelanceAnniv'] = DCL_Ent_RelanceAnniv;
    data['DCL_Ent_Relance_Mode'] = DCL_Ent_RelanceMode;
    data['DCL_Ent_Relance_Contact'] = DCL_Ent_RelanceContact;
    data['DCL_Ent_Relance_Mail'] = DCL_Ent_RelanceMail;
    data['DCL_Ent_Relance_Tel'] = DCL_Ent_RelanceTel;
    data['DCL_Ent_Proba'] = DCL_Ent_Proba;
    data['DCL_Ent_Proba_Note'] = DCL_Ent_Proba_Note;
    data['DCL_Ent_Concurent'] = DCL_Ent_Concurent;
    data['DCL_Ent_Note'] = DCL_Ent_Note;
    data['DCL_Ent_Regl'] = DCL_Ent_Regl;
    data['DCL_Ent_Partage'] = DCL_Ent_Partage;
    data['DCL_Ent_Contributeurs'] = DCL_Ent_Contributeurs;
    data['DCL_Ent_Dem_Tech'] = DCL_Ent_DemTech;
    data['DCL_Ent_Dem_SsT'] = DCL_Ent_DemSsT;
    data['DCL_Ent_MtHT'] = DCL_Ent_MtHT;
    data['DCL_Ent_MtTVA'] = DCL_Ent_MtTVA;
    data['DCL_Ent_MtTTC'] = DCL_Ent_MtTTC;
    data['DCL_Signataire_Tech'] = DCL_Signataire_Tech;
    data['DCL_Signature_Tech'] = DCL_Signature_Tech;
    data['DCL_Signataire_Date'] = DCL_Signataire_Date;
    data['DCL_Signataire_Client'] = DCL_Signataire_Client;
    data['DCL_Signature_Client'] = DCL_Signature_Client;
    data['DCL_Signataire_Date_Client'] = DCL_Signataire_Date_Client;
    return data;
  }

  static DCL_Ent fromMap(Map<String, dynamic> map) {


    Uint8List wUint8ListTech = Uint8List.fromList([]);
    if (map['DCL_Signature_Tech'].toString().isNotEmpty) {
      String value = map['DCL_Signature_Tech'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8ListTech = Uint8List.fromList(list);
      }
    }

    return DCL_Ent(
       map["DCL_EntId"],
       map["DCL_Ent_Type"],
       map["DCL_Ent_Num"],
       map["DCL_Ent_Version"],
         map["DCL_Ent_ClientId"],
       map["DCL_Ent_GroupeId"],
       map["DCL_Ent_SiteId"],
       map["DCL_Ent_ZoneId"],
        map["DCL_Ent_InterventionId"],
          map["DCL_Ent_Date"],
        map["DCL_Ent_Statut"],
      map["DCL_Ent_Etat"],
      map["DCL_Ent_EtatMotif"],
      map["DCL_Ent_EtatNote"],
      map["DCL_Ent_EtatAction"],
      map["DCL_Ent_Collaborateur"],
          map["DCL_Ent_Affaire"],
       map["DCL_Ent_AffaireNote"],
        map["DCL_Ent_Validite"],
       map["DCL_Ent_LivrPrev"],
       map["DCL_Ent_ModeRegl"],
      map["DCL_Ent_MoyRegl"],
      map["DCL_Ent_PrefAff"],
       map["DCL_Ent_RelAuto"],
      map["DCL_Ent_RelAnniv"],
      map["DCL_Ent_CopRel"],
       map["DCL_Ent_Valo"],
       map["DCL_Ent_RelanceAuto"],
       map["DCL_Ent_RelanceAnniv"],
       map["DCL_Ent_RelanceMode"],
      map["DCL_Ent_RelanceContact"],
       map["DCL_Ent_RelanceMail"],
       map["DCL_Ent_RelanceTel"],
       map["DCL_Ent_Proba"],
       map["DCL_Ent_Proba_Note"],
       map["DCL_Ent_Concurent"],
       map["DCL_Ent_Note"],
       map["DCL_Ent_Regl"],
       map["DCL_Ent_Partage"],
       map["DCL_Ent_Contributeurs"],
       map["DCL_Ent_DemTech"],
       map["DCL_Ent_DemSsT"],
       map["DCL_Ent_MtHT"],
       map["DCL_Ent_MtTVA"],
     map["DCL_Ent_MtTTC"],
      map["DCL_Signataire_Tech"],
      wUint8ListTech,
      map["DCL_Ent_DemSsTDCL_Signataire_Date"],
      map["DCL_Signataire_Client"],
      map["DCL_Signature_Client"],
       map["DCL_Ent_DemSsTDCL_Signataire_Date_Client"],
    );
  }

  @override
  String Desc() {
    return "$DCL_Ent_Num $DCL_Ent_ClientNom $DCL_Ent_GroupeNom $DCL_Ent_SiteNom $DCL_Ent_ZoneNom $DCL_Ent_InterventionNom";
  }
}
