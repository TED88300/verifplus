class InterMissions_Document {
  int? InterMissionsDocInterMissionId = 0;
  int? DocID = 0;
  String? DocNom = "";
  String? DocDate = "";
  int? DocLength = 0;
  String? DocCRC = "";
  String? DocUserMat = "";

  InterMissions_Document(
      {this.InterMissionsDocInterMissionId,
        this.DocID,
        this.DocNom,
        this.DocDate,
        this.DocLength,
        this.DocCRC,
        this.DocUserMat});

  InterMissions_Document.fromJson(Map<String, dynamic> json) {


    print("json $json");
    InterMissionsDocInterMissionId = int.parse(json['InterMissionsDocInterMissionId']);
    DocID = int.parse(json['DocID']);
    DocNom = json['DocNom'];
    DocDate = json['DocDate'];
    DocLength = int.parse(json['DocLength']);
    DocCRC = json['DocCRC'];
    DocUserMat = json['DocUserMat'];




  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['InterMissionsDocInterMissionId'] = InterMissionsDocInterMissionId;
    data['DocID'] = DocID;
    data['DocNom'] = DocNom;
    data['DocDate'] = DocDate;
    data['DocLength'] = DocLength;
    data['DocCRC'] = DocCRC;
    data['DocUserMat'] = DocUserMat;
    return data;
  }
}
