class Intervention {

  int? InterventionId = 0;
  int? Intervention_ZoneId = 0;

  String? Intervention_Date = "";
  String? Intervention_Type = "";
  String? Intervention_Parcs_Type = "";
  String? Intervention_Status = "";

  String? Intervention_Histo_Status = "";
  String? Intervention_Facturation = "";
  String? Intervention_Histo_Facturation = "";
  String? Intervention_Responsable = "";
  String? Intervention_Intervenants = "";
  String? Intervention_Reglementation = "";
  String? Intervention_Signataire_Client = "";
  String? Intervention_Signataire_Tech = "";
  String? Intervention_Signataire_Date = "";

  String? Intervention_Contrat = "";
  String? Intervention_TypeContrat = "";
  String? Intervention_Duree = "";
  String? Intervention_Organes = "";
  String? Intervention_RT = "";
  String? Intervention_APSAD = "";

  String? Intervention_Remarque = "";
  String? Livr = "";

  static InterventionInit() {
    return Intervention(0, 0, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");
  }

  Intervention(
    int    InterventionId,
    int    Intervention_ZoneId,
    String Intervention_Date,
    String Intervention_Type,
    String Intervention_Parcs_Type,
    String Intervention_Status,
    String Intervention_Histo_Status,
    String Intervention_Facturation,
    String Intervention_Histo_Facturation,
    String Intervention_Responsable,
    String Intervention_Intervenants,
    String Intervention_Reglementation,
    String Intervention_Signataire_Client,
    String Intervention_Signataire_Tech,
    String Intervention_Signataire_Date,
    String Intervention_Contrat,
    String Intervention_TypeContrat,
    String Intervention_Duree,
    String Intervention_Organes,
    String Intervention_RT,
    String Intervention_APSAD,
    String Intervention_Remarque,
    String Livr,
  ) {
    this.InterventionId = InterventionId;
    this.Intervention_ZoneId = Intervention_ZoneId;
    this.Intervention_Date = Intervention_Date;
    this.Intervention_Type = Intervention_Type;
    this.Intervention_Parcs_Type = Intervention_Parcs_Type;
    this.Intervention_Status = Intervention_Status;

    this.Intervention_Histo_Status = Intervention_Histo_Status;
    this.Intervention_Facturation = Intervention_Facturation;
    this.Intervention_Histo_Facturation = Intervention_Histo_Facturation;
    this.Intervention_Responsable = Intervention_Responsable;
    this.Intervention_Intervenants = Intervention_Intervenants;
    this.Intervention_Reglementation = Intervention_Reglementation;
    this.Intervention_Signataire_Client = Intervention_Signataire_Client;
    this.Intervention_Signataire_Tech = Intervention_Signataire_Tech;
    this.Intervention_Signataire_Date = Intervention_Signataire_Date;

    this.Intervention_Contrat = Intervention_Contrat;
    this.Intervention_TypeContrat = Intervention_TypeContrat;
    this.Intervention_Duree = Intervention_Duree;
    this.Intervention_Organes = Intervention_Organes;
    this.Intervention_RT = Intervention_RT;
    this.Intervention_APSAD = Intervention_APSAD;

    this.Intervention_Remarque = Intervention_Remarque;
    this.Livr = Livr;
  }

  Map<String, dynamic> toMap() {
    return {
      'InterventionId': InterventionId,
      'Intervention_ZoneId': Intervention_ZoneId,
      'Intervention_Date': Intervention_Date,
      'Intervention_Type': Intervention_Type,
      'Intervention_Parcs_Type': Intervention_Parcs_Type,
      'Intervention_Status': Intervention_Status,
      'Intervention_Histo_Status': Intervention_Histo_Status,
      'Intervention_Facturation': Intervention_Facturation,
      'Intervention_Histo_Facturation': Intervention_Histo_Facturation,
      'Intervention_Responsable': Intervention_Responsable,
      'Intervention_Intervenants': Intervention_Intervenants,
      'Intervention_Reglementation': Intervention_Reglementation,
      'Intervention_Signataire_Client': Intervention_Signataire_Client,
      'Intervention_Signataire_Tech': Intervention_Signataire_Tech,
      'Intervention_Signataire_Date': Intervention_Signataire_Date,
      'Intervention_Contrat': Intervention_Contrat,
      'Intervention_TypeContrat': Intervention_TypeContrat,
      'Intervention_Duree': Intervention_Duree,
      'Intervention_Organes': Intervention_Organes,
      'Intervention_RT': Intervention_RT,
      'Intervention_APSAD': Intervention_APSAD,
      'Intervention_Remarque': Intervention_Remarque,
    };
  }

  factory Intervention.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Intervention wUser = Intervention(
      int.parse(json['InterventionId']),
      int.parse(json['Intervention_ZoneId']),
      json['Intervention_Date'],
      json['Intervention_Type'],
      json['Intervention_Parcs_Type'],
      json['Intervention_Status'],
      json['Intervention_Histo_Status'],
      json['Intervention_Facturation'],
      json['Intervention_Histo_Facturation'],
      json['Intervention_Responsable'],
      json['Intervention_Intervenants'],
      json['Intervention_Reglementation'],
      json['Intervention_Signataire_Client'],
      json['Intervention_Signataire_Tech'],
      json['Intervention_Signataire_Date'],
      json['Intervention_Contrat'],
      json['Intervention_TypeContrat'],
      json['Intervention_Duree'],
      json['Intervention_Organes'],
      json['Intervention_RT'],
      json['Intervention_APSAD'],
      json['Intervention_Remarque'],
      json['Livr'],
    );
    return wUser;
  }

  String Desc() {
    return '$InterventionId        '
        '$Intervention_ZoneId '
        '$Intervention_Date     '
        '$Intervention_Type     '
        '$Intervention_Parcs_Type     '
        '$Intervention_Status     '
        '$Intervention_Histo_Status	          '
        '$Intervention_Facturation	          '
        '$Intervention_Histo_Facturation     '
        '$Intervention_Responsable	          '
        '$Intervention_Intervenants	          '
        '$Intervention_Reglementation	        '
        '$Intervention_Signataire_Client     '
        '$Intervention_Signataire_Tech	      '
        '$Intervention_Signataire_Date        '
        '$Intervention_Contrat        '
        '$Intervention_TypeContrat        '
        '$Intervention_Duree        '
        '$Intervention_Organes        '
        '$Intervention_RT        '
        '$Intervention_APSAD        '
        '$Intervention_Remarque'
        '$Livr';
  }
}
