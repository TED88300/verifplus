
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';

class Parc_Desc_Srv {
  int?    ParcsDescId = 0;
  int?    ParcsDesc_ParcsId = 0;
  String? ParcsDesc_Type = "";
  String? ParcsDesc_Id = "";
  String? ParcsDesc_Lib = "";

  static Parc_DescInit(int wParcsDesc_ParcsId, String wParcsDesc_Type) {

    String ParcsDesc_Lib = "---";
    int ParcsDesc_Id = -1;

//    print("Parc_DescInit Parc_DescInit Parc_DescInit Parc_DescInit ${wParcsDesc_Type}");

    Srv_DbTools.getParam_Saisie_ParamMem(wParcsDesc_Type);

    Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
      if (element.Param_Saisie_Param_Init) {
        ParcsDesc_Lib = element.Param_Saisie_Param_Label;
        ParcsDesc_Id = element.Param_Saisie_ParamId;
        print(">><<<<<<<<<>>>>>>><<<<<<<<<>>>>>>> Parc_DescInit ${element.Desc()}");

        return;
        }
      }
    );
    Parc_Desc_Srv wParc_Desc = Parc_Desc_Srv(0,0,"","","");
    wParc_Desc.ParcsDescId = -1;
    wParc_Desc.ParcsDesc_ParcsId = wParcsDesc_ParcsId;
    wParc_Desc.ParcsDesc_Type = wParcsDesc_Type;
    wParc_Desc.ParcsDesc_Id = "${ParcsDesc_Id}";
    wParc_Desc.ParcsDesc_Lib = ParcsDesc_Lib;

    return wParc_Desc;
  }


  Parc_Desc_Srv(
      ParcsDescId ,
      ParcsDesc_ParcsId ,ParcsDesc_Type ,ParcsDesc_Id ,ParcsDesc_Lib
      ) {
    this.ParcsDescId   = ParcsDescId    ;
    this.ParcsDesc_ParcsId   = ParcsDesc_ParcsId    ;
    this.ParcsDesc_Type   = ParcsDesc_Type    ;
    this.ParcsDesc_Id   = ParcsDesc_Id    ;
    this.ParcsDesc_Lib   = ParcsDesc_Lib    ;
  }






  Map<String, dynamic> toMap() {
    return {
      'ParcsDescId': ParcsDescId,
      'ParcsDesc_ParcsId': ParcsDesc_ParcsId,
      'ParcsDesc_Type': ParcsDesc_Type,
      'ParcsDesc_Id': ParcsDesc_Id,
      'ParcsDesc_Lib': ParcsDesc_Lib,


    };
  }


  factory Parc_Desc_Srv.fromJson(Map<String, dynamic> json) {
//    print("json $json");

    Parc_Desc_Srv wTmp = Parc_Desc_Srv(
      int.parse(json['ParcsDescId']),
      int.parse(json['ParcsDesc_ParcsId']),
      json['ParcsDesc_Type'],
      json['ParcsDesc_Id'],
      json['ParcsDesc_Lib'],);





    return wTmp;
  }




  @override
  String toString() {
    return 'Parc_Desc {ParcsDescId: $ParcsDescId, ParcsDesc_ParcsId: $ParcsDesc_ParcsId, ParcsDesc_Type $ParcsDesc_Type, ParcsDesc_Id : $ParcsDesc_Id,ParcsDesc_Lib : $ParcsDesc_Lib,}';
  }
}
