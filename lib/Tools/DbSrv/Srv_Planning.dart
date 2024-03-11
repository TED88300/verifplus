import 'package:intl/intl.dart';

class Planning {
  int? PlanningId = -1;
  int? Planning_InterventionId = -1;
  int? Planning_ResourceId = -1;
  DateTime Planning_InterventionstartTime = DateTime.now();
  DateTime Planning_InterventionendTime = DateTime.now();

  String Planning_Libelle = "";

  static Planning_RdvInit() {
    return Planning(0, 0, 0, DateTime.now(), DateTime.now(), "");
  }

  Planning(
      int       PlanningId,
      int       Planning_InterventionId,
      int       Planning_ResourceId,
      DateTime  Planning_InterventionstartTime,
      DateTime  Planning_InterventionendTime,
      String    Planning_Libelle,
      ) {
    this.PlanningId                     = PlanningId;
    this.Planning_InterventionId        = Planning_InterventionId;
    this.Planning_ResourceId            = Planning_ResourceId;
    this.Planning_InterventionstartTime = Planning_InterventionstartTime;
    this.Planning_InterventionendTime   = Planning_InterventionendTime;
    this.Planning_Libelle   = Planning_Libelle;
  }

  Map<String, dynamic> toMap() {

    return {
      'PlanningId': PlanningId,
      'Planning_InterventionId': Planning_InterventionId,
      'Planning_ResourceId': Planning_ResourceId,
      'Planning_InterventionstartTime': '${Planning_InterventionstartTime}',
      'Planning_InterventionendTime': '${Planning_InterventionendTime}',
      'Planning_Libelle': Planning_Libelle,
    };
  }


  factory Planning.fromJson(Map<String, dynamic> json) {
    Planning wplanningRdv = Planning(
      int.parse(json['PlanningId']),
      int.parse(json['Planning_InterventionId']),
      int.parse(json['Planning_ResourceId']),
      DateTime.parse(json['Planning_InterventionstartTime']),
      DateTime.parse(json['Planning_InterventionendTime']),
      json['Planning_Libelle'],
    );
    return wplanningRdv;
  }
  String Desc() {
    return '$PlanningId        '
        'Planning_InterventionId $Planning_InterventionId '
        'user $Planning_ResourceId     '
        'start $Planning_InterventionstartTime     '
        'end $Planning_InterventionendTime     ';
        'lib $Planning_Libelle     ';
  }
}
