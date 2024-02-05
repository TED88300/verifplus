/*
* INSERT INTO User_Hab (User_Hab_UserID, User_Hab_Param_HabID, User_Hab_Ordre)
  SELECT 1, Param_HabId, Param_Hab_OrdreFROM Param_Hab

  * */

class User_Hab {
  int User_HabID = 0;
  int User_Hab_UserID = 0;
  int User_Hab_Param_HabID = 0;
  bool User_Hab_MaintPrev = true;
  bool User_Hab_Install = true;
  bool User_Hab_MaintCorrect = true;
  int User_Hab_Ordre = 0;

  String Param_Hab_PDT = "";
  String Param_Hab_Grp = "";
  bool User_Hab_Sel = false;

  static User_HabInit() {
    return User_Hab(
      0,
      0,
      0,
      false,
      false,
      false,
      0,
    );
  }

  User_Hab(
    int User_HabID,
    int User_Hab_UserID,
    int User_Hab_Param_HabID,
    bool User_Hab_MaintPrev,
    bool User_Hab_Install,
    bool User_Hab_MaintCorrect,
    int User_Hab_Ordre,
  ) {
    this.User_HabID = User_HabID;
    this.User_Hab_UserID = User_Hab_UserID;
    this.User_Hab_Param_HabID = User_Hab_Param_HabID;
    this.User_Hab_MaintPrev = User_Hab_MaintPrev;
    this.User_Hab_Install = User_Hab_Install;
    this.User_Hab_MaintCorrect = User_Hab_MaintCorrect;
    this.User_Hab_Ordre = User_Hab_Ordre;
  }

  Map<String, dynamic> toMap() {
    return {
      'User_HabID': User_HabID,
      'User_Hab_UserID': User_Hab_UserID,
      'User_Hab_Param_HabID': User_Hab_Param_HabID,
      'User_Hab_MaintPrev': User_Hab_MaintPrev,
      'User_Hab_Install': User_Hab_Install,
      'User_Hab_MaintCorrect': User_Hab_MaintCorrect,
      'User_Hab_Ordre': User_Hab_Ordre,
    };
  }

  factory User_Hab.fromJson(Map<String, dynamic> json) {
    int iUser_Hab_MaintPrev = int.parse(json['User_Hab_MaintPrev']);
    int iUser_Hab_Install = int.parse(json['User_Hab_Install']);
    int iUser_Hab_MaintCorrect = int.parse(json['User_Hab_MaintCorrect']);
    bool bUser_Hab_MaintPrev = (iUser_Hab_MaintPrev == 1);
    bool bUser_Hab_Install = (iUser_Hab_Install == 1);
    bool bUser_Hab_MaintCorrect = (iUser_Hab_MaintCorrect == 1);

    User_Hab wUser = User_Hab(
      int.parse(json['User_HabID']),
      int.parse(json['User_Hab_UserID']),
      int.parse(json['User_Hab_Param_HabID']),
      bUser_Hab_MaintPrev,
      bUser_Hab_Install,
      bUser_Hab_MaintCorrect,
      int.parse(json['User_Hab_Ordre']),
    );

    return wUser;
  }

  String Desc() {
    return '$User_HabID $User_Hab_UserID $User_Hab_Param_HabID $User_Hab_MaintPrev $User_Hab_Install $User_Hab_MaintCorrect $User_Hab_Ordre $Param_Hab_PDT $Param_Hab_Grp $User_Hab_Sel';
  }
}
