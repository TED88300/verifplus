


class Parc_Img {
  int?    Parc_Imgid = 0;
  int?    Parc_Imgs_ParcsId = 0;
  int?    Parc_Imgs_Type = 0;
  int?    Parc_Imgs_Principale = 0;
  String? Parc_Imgs_Date = "";
  String? Parc_Imgs_Data = "";
  String? Parc_Imgs_Path = "";

  Parc_Img({
    this.Parc_Imgid,
    this.Parc_Imgs_ParcsId,
    this.Parc_Imgs_Type,
    this.Parc_Imgs_Principale,
    this.Parc_Imgs_Date,
    this.Parc_Imgs_Data,
    this.Parc_Imgs_Path,

  });

  Map<String, dynamic> toMap() {
    return {
      'Parc_Imgid': Parc_Imgid,
      'Parc_Imgs_ParcsId': Parc_Imgs_ParcsId,
      'Parc_Imgs_Type': Parc_Imgs_Type,
      'Parc_Imgs_Principale': Parc_Imgs_Principale,
      'Parc_Imgs_Path': Parc_Imgs_Path,
      'Parc_Imgs_Date': Parc_Imgs_Date,
      'Parc_Imgs_Data': Parc_Imgs_Data,

    };
  }

  static  Parc_Img fromMap(Map<String, dynamic> map) {
    return new Parc_Img(
      Parc_Imgid: map["Parc_Imgid"],
      Parc_Imgs_ParcsId: map["Parc_Imgs_ParcsId"],
      Parc_Imgs_Type: map["Parc_Imgs_Type"],
      Parc_Imgs_Principale: map["Parc_Imgs_Principale"],
      Parc_Imgs_Path: map["Parc_Imgs_Path"],
      Parc_Imgs_Date: map["Parc_Imgs_Date"],
      Parc_Imgs_Data: map["Parc_Imgs_Data"],
    );
  }




    @override
  String toString() {
    return 'Parc_Img{Parc_Imgid: $Parc_Imgid, Parc_Imgs_ParcsId : $Parc_Imgs_ParcsId Parc_Imgs_Path: $Parc_Imgs_Path Parc_Imgs_Type: $Parc_Imgs_Type  Parc_Imgs_Principale: $Parc_Imgs_Principale  Parc_Imgs_Date: $Parc_Imgs_Date  Parc_Imgs_Data: $Parc_Imgs_Data}';
  }
}
