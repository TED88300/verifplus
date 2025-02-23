class DCL_Ent_Img {
  int? dCLEntImgid;
  int? dCLEntImgEntID;
  String? DCL_Ent_Img_Type;
  int? DCL_Ent_Img_No;

  String? dCLEntImgData;
  String? DCL_Ent_Img_Name;

  DCL_Ent_Img({this.dCLEntImgid, this.dCLEntImgEntID, this.dCLEntImgData});

  DCL_Ent_Img.fromJson(Map<String, dynamic> json) {
    dCLEntImgid = int.parse(json['DCL_Ent_Imgid']);
    dCLEntImgEntID = int.parse(json['DCL_Ent_Img_EntID']);
    DCL_Ent_Img_Type = json['DCL_Ent_Img_Type'];
    DCL_Ent_Img_No = int.parse(json['DCL_Ent_Img_No']);
    dCLEntImgData = json['DCL_Ent_Img_Data'];
    DCL_Ent_Img_Name = json['DCL_Ent_Img_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DCL_Ent_Imgid'] = dCLEntImgid;
    data['DCL_Ent_Img_EntID'] = dCLEntImgEntID;
    data['DCL_Ent_Img_Type'] = DCL_Ent_Img_Type;
    data['DCL_Ent_Img_No'] = DCL_Ent_Img_No;
    data['DCL_Ent_Img_Data'] = dCLEntImgData;
    data['DCL_Ent_Img_Name'] = DCL_Ent_Img_Name;
    return data;
  }
}
