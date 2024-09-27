
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';

class Parc_Imgs_Srv {
  int?    Parc_Imgid          = 0;
  int?    Parc_Imgs_ParcsId    = 0;
  int?    Parc_Imgs_Type       = 0;
  String? Parc_Imgs_Data       = "";
  String? Parc_Imgs_Path       = "";


  static Parc_ArtInit(int wParc_Imgs_ParcsId, int wParc_Imgs_Type) {
    Parc_Imgs_Srv wParc_Art = Parc_Imgs_Srv(0,0,0,"","");
    wParc_Art.Parc_Imgid  = -1;
    wParc_Art.Parc_Imgs_ParcsId  = wParc_Imgs_ParcsId;
    wParc_Art.Parc_Imgs_Type  = wParc_Imgs_Type;
    return wParc_Art;
  }


  Parc_Imgs_Srv(
      Parc_Imgid,
      Parc_Imgs_ParcsId,
      Parc_Imgs_Type,
      Parc_Imgs_Data,
      Parc_Imgs_Path,


      ) {
    this.Parc_Imgid            = Parc_Imgid;
    this.Parc_Imgs_ParcsId     = Parc_Imgs_ParcsId;
    this.Parc_Imgs_Type        = Parc_Imgs_Type;
    this.Parc_Imgs_Data        = Parc_Imgs_Data;
    this.Parc_Imgs_Path        = Parc_Imgs_Path;
  }


  Map<String, dynamic> toMap() {
    return {
      'Parc_Imgid':             Parc_Imgid,
      'Parc_Imgs_ParcsId':      Parc_Imgs_ParcsId,
      'Parc_Imgs_Type':         Parc_Imgs_Type,
      'Parc_Imgs_Data':         Parc_Imgs_Data,
      'Parc_Imgs_Path':         Parc_Imgs_Path,
    };
  }


  factory Parc_Imgs_Srv.fromJson(Map<String, dynamic> json) {
//    print("json $json");

    Parc_Imgs_Srv wTmp = Parc_Imgs_Srv(
      int.parse(json['Parc_Imgid']),
      int.parse(json['Parc_Imgs_ParcsId']),
      int.parse(json['Parc_Imgs_Type']),
      json['Parc_Imgs_Data'],
      json['Parc_Imgs_Path'],);
      return wTmp;
  }




  @override
  String toString() {
    return 'Parc_Art {Parc_Imgid: $Parc_Imgid, '
        'Parc_Imgs_ParcsId: $Parc_Imgs_ParcsId, '
        'Parc_Imgs_Type $Parc_Imgs_Type, '
        'Parc_Imgs_Data $Parc_Imgs_Data, '
        'Parc_Imgs_Path $Parc_Imgs_Path, ';
  }
}
