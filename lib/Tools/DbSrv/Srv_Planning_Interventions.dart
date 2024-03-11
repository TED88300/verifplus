class Planning_Intervention {


  int? Planning_Interv_PlanningId = -1;
  int? Planning_Interv_InterventionId = -1;
  int? Planning_Interv_ResourceId = -1;
  DateTime Planning_Interv_InterventionstartTime = DateTime.now();
  DateTime Planning_Interv_InterventionendTime = DateTime.now();
  String Planning_Libelle = "";
  String? Planning_Interv_Intervention_Type = "";
  String? Planning_Interv_Intervention_Parcs_Type = "";
  String? Planning_Interv_Intervention_Status = "";
  int? Planning_Interv_ZoneId = -1;
  String? Planning_Interv_Zone_Nom = "";
  int? Planning_Interv_SiteId = -1;
  String? Planning_Interv_Site_Nom = "";
  int? Planning_Interv_GroupeId = -1;
  String? Planning_Interv_Groupe_Nom = "";
  int? Planning_Interv_ClientId = -1;
  String? Planning_Interv_Client_Nom = "";



  static Planning_InterventionInit() {
    return Planning_Intervention( 0, 0, 0, DateTime.now(), DateTime.now(), "", "", "", "", 0, "", 0, "", 0, "", 0, "");
  }

  Planning_Intervention(
    int Planning_Interv_PlanningId,
    int Planning_Interv_InterventionId,
    int Planning_Interv_ResourceId,
    DateTime Planning_Interv_InterventionstartTime,
    DateTime Planning_Interv_InterventionendTime,
    String Planning_Libelle,
    String Planning_Interv_Intervention_Type,
    String Planning_Interv_Intervention_Parc,
    String Planning_Interv_Intervention_Stat,
    int Planning_Interv_ZoneId,
    String Planning_Interv_Zone_Nom,
    int Planning_Interv_SiteId,
    String Planning_Interv_Site_Nom,
    int Planning_Interv_GroupeId,
    String Planning_Interv_Groupe_Nom,
    int Planning_Interv_ClientId,
    String Planning_Interv_Client_Nom,
  ) {
    this.Planning_Interv_PlanningId =Planning_Interv_PlanningId;
    this.Planning_Interv_InterventionId =Planning_Interv_InterventionId;
    this.Planning_Interv_ResourceId =Planning_Interv_ResourceId;
    this.Planning_Interv_InterventionstartTime = Planning_Interv_InterventionstartTime;
    this.Planning_Interv_InterventionendTime = Planning_Interv_InterventionendTime;
    this.Planning_Libelle   = Planning_Libelle;

    this.Planning_Interv_Intervention_Type = Planning_Interv_Intervention_Type;
    this.Planning_Interv_Intervention_Parcs_Type = Planning_Interv_Intervention_Parcs_Type;
    this.Planning_Interv_Intervention_Status = Planning_Interv_Intervention_Status;

    this.Planning_Interv_ZoneId = Planning_Interv_ZoneId;
    this.Planning_Interv_Zone_Nom = Planning_Interv_Zone_Nom;
    this.Planning_Interv_SiteId = Planning_Interv_SiteId;
    this.Planning_Interv_Site_Nom = Planning_Interv_Site_Nom;
    this.Planning_Interv_GroupeId = Planning_Interv_GroupeId;
    this.Planning_Interv_Groupe_Nom = Planning_Interv_Groupe_Nom;
    this.Planning_Interv_ClientId = Planning_Interv_ClientId;
    this.Planning_Interv_Client_Nom = Planning_Interv_Client_Nom;
  }

  Map<String, dynamic> toMap() {

    return {
      'Planning_Interv_PlanningId': Planning_Interv_PlanningId,
      'Planning_Interv_InterventionId': Planning_Interv_InterventionId,
      'Planning_Interv_ResourceId': Planning_Interv_ResourceId,
      'Planning_Interv_InterventionstartTime': '${Planning_Interv_InterventionstartTime}',
      'Planning_Interv_InterventionendTime': '${Planning_Interv_InterventionendTime}',
      'Planning_Libelle': Planning_Libelle,

      'Planning_Interv_Intervention_Type': Planning_Interv_Intervention_Type,
      'Planning_Interv_Intervention_Parcs_Type': Planning_Interv_Intervention_Parcs_Type,
      'Planning_Interv_Intervention_Status': Planning_Interv_Intervention_Status,
      'Planning_Interv_ZoneId': Planning_Interv_ZoneId,
      'Planning_Interv_Zone_Nom': Planning_Interv_Zone_Nom,
      'Planning_Interv_SiteId': Planning_Interv_SiteId,
      'Planning_Interv_Site_Nom': Planning_Interv_Site_Nom,
      'Planning_Interv_GroupeId': Planning_Interv_GroupeId,
      'Planning_Interv_Groupe_Nom': Planning_Interv_Groupe_Nom,
      'Planning_Interv_ClientId': Planning_Interv_ClientId,
      'Planning_Interv_Client_Nom': Planning_Interv_Client_Nom,

    };
  }

  factory Planning_Intervention.fromJson(Map<String, dynamic> json) {
    Planning_Intervention wPlanning_Intervention = Planning_Intervention(
      int.parse(json['PlanningId']),
      int.parse(json['Planning_InterventionId']),
      int.parse(json['Planning_ResourceId']),
      DateTime.parse(json['Planning_InterventionstartTime']),
      DateTime.parse(json['Planning_InterventionendTime']),
      json['Planning_Libelle'],

      json['Intervention_Type'],
      json['Intervention_Parcs_Type'],
      json['Intervention_Status'],

      int.parse(json['ZoneId']),
      json['Zone_Nom'],

      int.parse(json['SiteId']),
      json['Site_Nom'],

      int.parse(json['GroupeId']),
      json['Groupe_Nom'],

      int.parse(json['ClientId']),
      json['Client_Nom'],


    );
    return wPlanning_Intervention;
  }




  String Desc() {
 return
       '$Planning_Interv_PlanningId, '
       '$Planning_Interv_InterventionId, '
       '$Planning_Interv_ResourceId, '
       '$Planning_Interv_InterventionstartTime, '
       '$Planning_Interv_InterventionendTime, '
           '$Planning_Libelle, '
        '$Planning_Interv_Intervention_Type, '
        '$Planning_Interv_Intervention_Parcs_Type,    '
        '$Planning_Interv_Intervention_Status,'
        '$Planning_Interv_ZoneId, '
        '$Planning_Interv_Zone_Nom, '
        '$Planning_Interv_SiteId, '
        '$Planning_Interv_Site_Nom, '
        '$Planning_Interv_GroupeId, '
        '$Planning_Interv_Groupe_Nom, '
        '$Planning_Interv_ClientId, '
        '$Planning_Interv_Client_Nom,  ';}















}
