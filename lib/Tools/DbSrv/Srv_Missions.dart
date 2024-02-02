class Mission {


/*
  int? InterMissionsID = 0;
  String? InterMissionsMissions_Nom = "";
  String? InterMissionsMissions_Exec = "";
  String? InterMissionsMissions_Date = "";
*/


  int MissionsID = 0;
  String Missions_Nom = "";


  static MissionInit() {
    return Mission(0,  "", );
  }

  Mission(
    int     MissionsID,
    String  Missions_Nom,
  ) {
    this.MissionsID = MissionsID;
    this.Missions_Nom = Missions_Nom;
  }

  factory Mission.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Mission wMission = Mission(
      int.parse(json['MissionsID']),
      json['Missions_Nom'],
    );
    return wMission;
  }

  String Desc() {
    return '$MissionsID        '
        '$Missions_Nom ';
  }
}
