import 'dart:typed_data';

class Intervention {
  int InterventionId = 0;
  int Intervention_ZoneId = 0;

  String Intervention_Date = "";
  String Intervention_Date_Visite = "";
  String Intervention_Type = "";
  String Intervention_Parcs_Type = "";
  String Intervention_Status = "";

  String Intervention_Histo_Status = "";
  String Intervention_Facturation = "";
  String Intervention_Histo_Facturation = "";
  String Intervention_Responsable = "";
  String Intervention_Responsable2 = "";
  String Intervention_Responsable3 = "";
  String Intervention_Responsable4 = "";
  String Intervention_Responsable5 = "";
  String Intervention_Responsable6 = "";
  String Intervention_Intervenants = "";
  String Intervention_Reglementation = "";
  String Intervention_Signataire_Client = "";
  Uint8List Intervention_Signature_Client = Uint8List.fromList([]);
  String Intervention_Signataire_Tech = "";
  Uint8List Intervention_Signature_Tech = Uint8List.fromList([]);
  String Intervention_Signataire_Date = "";
  String Intervention_Signataire_Date_Client	 = "";
  String Intervention_Contrat = "";
  String Intervention_TypeContrat = "";
  String Intervention_Duree = "";
  String Intervention_Organes = "";
  String Intervention_RT = "";
  String Intervention_APSAD = "";
  int Intervention_Sat = 0;
  String Intervention_Remarque = "";
  String Livr = "";
  bool Intervention_isUpdate = true;

  String? Client_Nom = "";
  String? Groupe_Nom = "";
  String? Site_Nom = "";
  String? Zone_Nom = "";

  int? ClientId = 0;
  int? GroupeId = 0;
  int? SiteId = 0;
  int? ZoneId = 0;



  static InterventionInit() {
    return Intervention(0, 0, "", "", "","","",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", 0, "","", true, Uint8List.fromList([]), Uint8List.fromList([]));
  }

  Intervention(
    int InterventionId,
    int Intervention_ZoneId,
    String Intervention_Date,
      String Intervention_Date_Visite,
    String Intervention_Type,
    String Intervention_Parcs_Type,
    String Intervention_Status,
    String Intervention_Histo_Status,
    String Intervention_Facturation,
    String Intervention_Histo_Facturation,
    String Intervention_Responsable,
      String Intervention_Responsable2,
      String Intervention_Responsable3,
      String Intervention_Responsable4,
      String Intervention_Responsable5,
      String Intervention_Responsable6,
    String Intervention_Intervenants,
    String Intervention_Reglementation,
    String Intervention_Signataire_Client,
    String Intervention_Signataire_Tech,
    String Intervention_Signataire_Date,
    String Intervention_Signataire_Date_Client	,
    String Intervention_Contrat,
    String Intervention_TypeContrat,
    String Intervention_Duree,
    String Intervention_Organes,
    String Intervention_RT,
    String Intervention_APSAD,
    int Intervention_Sat,
    String Intervention_Remarque,
    String Livr,
    bool Intervention_isUpdate,
    Uint8List Intervention_Signature_Client,
    Uint8List Intervention_Signature_Tech,




  ) {
    this.InterventionId = InterventionId;
    this.Intervention_ZoneId = Intervention_ZoneId;
    this.Intervention_Date = Intervention_Date;
    this.Intervention_Date_Visite = Intervention_Date_Visite;
    this.Intervention_Type = Intervention_Type;
    this.Intervention_Parcs_Type = Intervention_Parcs_Type;
    this.Intervention_Status = Intervention_Status;
    this.Intervention_Histo_Status = Intervention_Histo_Status;
    this.Intervention_Facturation = Intervention_Facturation;
    this.Intervention_Histo_Facturation = Intervention_Histo_Facturation;
    this.Intervention_Responsable = Intervention_Responsable;
    this.Intervention_Responsable2 = Intervention_Responsable2;
    this.Intervention_Responsable3 = Intervention_Responsable3;
    this.Intervention_Responsable4 = Intervention_Responsable4;
    this.Intervention_Responsable5 = Intervention_Responsable5;
    this.Intervention_Responsable6 = Intervention_Responsable6;
    this.Intervention_Intervenants = Intervention_Intervenants;
    this.Intervention_Reglementation = Intervention_Reglementation;
    this.Intervention_Signataire_Client = Intervention_Signataire_Client;
    this.Intervention_Signataire_Tech = Intervention_Signataire_Tech;
    this.Intervention_Signataire_Date = Intervention_Signataire_Date;
    this.Intervention_Signataire_Date_Client	 = Intervention_Signataire_Date_Client	;
    this.Intervention_Contrat = Intervention_Contrat;
    this.Intervention_TypeContrat = Intervention_TypeContrat;
    this.Intervention_Duree = Intervention_Duree;
    this.Intervention_Organes = Intervention_Organes;
    this.Intervention_RT = Intervention_RT;
    this.Intervention_APSAD = Intervention_APSAD;
    this.Intervention_Sat = Intervention_Sat;
    this.Intervention_Remarque = Intervention_Remarque;
    this.Livr = Livr;
    this.Intervention_isUpdate = Intervention_isUpdate;
    this.Intervention_Signature_Client = Intervention_Signature_Client;
    this.Intervention_Signature_Tech = Intervention_Signature_Tech;
  }

  Map<String, dynamic> toMap() {
    return {
      'InterventionId': InterventionId,
      'Intervention_ZoneId': Intervention_ZoneId,
      'Intervention_Date': Intervention_Date,
      'Intervention_Date_Visite': Intervention_Date_Visite,
      'Intervention_Type': Intervention_Type,
      'Intervention_Parcs_Type': Intervention_Parcs_Type,
      'Intervention_Status': Intervention_Status,
      'Intervention_Histo_Status': Intervention_Histo_Status,
      'Intervention_Facturation': Intervention_Facturation,
      'Intervention_Histo_Facturation': Intervention_Histo_Facturation,
      'Intervention_Responsable': Intervention_Responsable,
      'Intervention_Responsable2': Intervention_Responsable2,
      'Intervention_Responsable3': Intervention_Responsable3,
      'Intervention_Responsable4': Intervention_Responsable4,
      'Intervention_Responsable5': Intervention_Responsable5,
      'Intervention_Responsable6': Intervention_Responsable6,
      'Intervention_Intervenants': Intervention_Intervenants,
      'Intervention_Reglementation': Intervention_Reglementation,
      'Intervention_Signataire_Client': Intervention_Signataire_Client,
      'Intervention_Signataire_Tech': Intervention_Signataire_Tech,
      'Intervention_Signataire_Date': Intervention_Signataire_Date,
      'Intervention_Signataire_Date_Client': Intervention_Signataire_Date_Client	,
      'Intervention_Contrat': Intervention_Contrat,
      'Intervention_TypeContrat': Intervention_TypeContrat,
      'Intervention_Duree': Intervention_Duree,
      'Intervention_Organes': Intervention_Organes,
      'Intervention_RT': Intervention_RT,
      'Intervention_APSAD': Intervention_APSAD,
      'Intervention_Sat': Intervention_Sat,
      'Intervention_Remarque': Intervention_Remarque,
      'Intervention_isUpdate': Intervention_isUpdate,
      'Intervention_Signature_Client': Intervention_Signature_Client,
      'Intervention_Signature_Tech': Intervention_Signature_Tech,
    };
  }

  factory Intervention.fromJson(Map<String, dynamic> json) {
//    print("••• Intervention.fromJson ${json}");

    Uint8List wUint8ListTech = Uint8List.fromList([]);
    if (json['Intervention_Signature_Tech'].toString().isNotEmpty) {
      String value = json['Intervention_Signature_Tech'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8ListTech = Uint8List.fromList(list);
      }
    }

    Uint8List wUint8List = Uint8List.fromList([]);
    if (json['Intervention_Signature_Client'].toString().isNotEmpty) {
      String value = json['Intervention_Signature_Client'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8List = Uint8List.fromList(list);
      }
    }

    //    print("Intervention.fromJson ${json['InterventionId']} wUint8ListTech ${wUint8ListTech.length} wUint8List ${wUint8List.length} ");

    Intervention wIntervention = Intervention(
      int.parse(json['InterventionId']),
      int.parse(json['Intervention_ZoneId']),
      json['Intervention_Date'],
      json['Intervention_Date_Visite'],
      json['Intervention_Type'],
      json['Intervention_Parcs_Type'],
      json['Intervention_Status'],
      json['Intervention_Histo_Status'],
      json['Intervention_Facturation'],
      json['Intervention_Histo_Facturation'],
      json['Intervention_Responsable'],
      json['Intervention_Responsable2'],
      json['Intervention_Responsable3'],
      json['Intervention_Responsable4'],
      json['Intervention_Responsable5'],
      json['Intervention_Responsable6'],
      json['Intervention_Intervenants'],
      json['Intervention_Reglementation'],
      json['Intervention_Signataire_Client'],
      json['Intervention_Signataire_Tech'],
      json['Intervention_Signataire_Date'],
      json['Intervention_Signataire_Date_Client'],
      json['Intervention_Contrat'],
      json['Intervention_TypeContrat'],
      json['Intervention_Duree'],
      json['Intervention_Organes'],
      json['Intervention_RT'],
      json['Intervention_APSAD'],
      int.parse(json['Intervention_Sat']),
      json['Intervention_Remarque'],
      json['Livr'],
      true,
      wUint8List,
      wUint8ListTech,
    );

//    print("Intervention ${wIntervention.toMap()}");

    return wIntervention;
  }

  factory Intervention.fromJsonClient(Map<String, dynamic> json) {
//    print("json $json");

    String wCnt = "0";
    if (json['Cnt'] != null) wCnt = json['Cnt'];
    String wIntervention_Sat = "0";
    if (json['Intervention_Sat'] != null) wIntervention_Sat = json['Intervention_Sat'];

    Uint8List wUint8ListTech = Uint8List.fromList([]);
    if (json['Intervention_Signature_Tech'].toString().isNotEmpty) {
      String value = json['Intervention_Signature_Tech'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8ListTech = Uint8List.fromList(list);
      }
    }

    Uint8List wUint8List = Uint8List.fromList([]);
    if (json['Intervention_Signature_Client'].toString().isNotEmpty) {
      String value = json['Intervention_Signature_Client'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8List = Uint8List.fromList(list);
      }
    }

    Intervention wIntervention = Intervention(
      int.parse(json['InterventionId']),
      int.parse(json['Intervention_ZoneId']),
      json['Intervention_Date'],
      json['Intervention_Date_Visite'],
      json['Intervention_Type'],
      json['Intervention_Parcs_Type'],
      json['Intervention_Status'],
      json['Intervention_Histo_Status'],
      json['Intervention_Facturation'],
      json['Intervention_Histo_Facturation'],
      json['Intervention_Responsable'],
      json['Intervention_Responsable2'],
      json['Intervention_Responsable3'],
      json['Intervention_Responsable4'],
      json['Intervention_Responsable5'],
      json['Intervention_Responsable6'],
      json['Intervention_Intervenants'],
      json['Intervention_Reglementation'],
      json['Intervention_Signataire_Client'],
      json['Intervention_Signataire_Tech'],
      json['Intervention_Signataire_Date'],
      json['Intervention_Signataire_Date_Client'],
      json['Intervention_Contrat'],
      json['Intervention_TypeContrat'],
      json['Intervention_Duree'],
      json['Intervention_Organes'],
      json['Intervention_RT'],
      json['Intervention_APSAD'],
      int.parse(json['Intervention_Sat']),
      json['Intervention_Remarque'],
      json['Livr'],
      true,
      wUint8List,
      wUint8ListTech,

    );

    wIntervention.Client_Nom = json['Client_Nom'];
    wIntervention.Groupe_Nom = json['Groupe_Nom'];
    wIntervention.Site_Nom = json['Site_Nom'];
    wIntervention.Zone_Nom = json['Zone_Nom'];

    wIntervention.ClientId = int.parse(json['ClientId']);
    wIntervention.GroupeId = int.parse(json['GroupeId']);
    wIntervention.SiteId = int.parse(json['SiteId']);
    wIntervention.ZoneId = int.parse(json['ZoneID']);

    return wIntervention;
  }




  String Desc() {
    return '$InterventionId        '
        '$Intervention_ZoneId '
        '$Intervention_Date     '
        '$Intervention_Date_Visite     '
        '$Intervention_Type     '
        '$Intervention_Parcs_Type     '
        '$Intervention_Status     '
        '$Intervention_Histo_Status	          '
        '$Intervention_Facturation	          '
        '$Intervention_Histo_Facturation     '
        '$Intervention_Responsable	          '
        '$Intervention_Responsable2	          '
        '$Intervention_Responsable3	          '
        '$Intervention_Responsable4	          '
        '$Intervention_Responsable5	          '
        '$Intervention_Responsable6	          '
        '$Intervention_Intervenants	          '
        '$Intervention_Reglementation	        '
        '$Intervention_Signataire_Client     '
        '$Intervention_Signataire_Tech	      '
        '$Intervention_Signataire_Date        '
        '$Intervention_Signataire_Date_Client	        '
        '$Intervention_Contrat        '
        '$Intervention_TypeContrat        '
        '$Intervention_Duree        '
        '$Intervention_Organes        '
        '$Intervention_RT        '
        '$Intervention_APSAD        '
        '$Intervention_Sat      '
        '$Intervention_Remarque    '
        '$Livr     '
        '$Intervention_Signature_Client     '
        '$Intervention_Signature_Tech     ';
  }
}
