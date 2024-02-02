
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';

class Parc_Desc {
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
//        print(">><<<<<<<<<>>>>>>><<<<<<<<<>>>>>>> Parc_DescInit ${element.Desc()}");

        return;
        }
      }
    );
    Parc_Desc wParc_Desc = Parc_Desc();
    wParc_Desc.ParcsDescId = -1;
    wParc_Desc.ParcsDesc_ParcsId = wParcsDesc_ParcsId;
    wParc_Desc.ParcsDesc_Type = wParcsDesc_Type;
    wParc_Desc.ParcsDesc_Id = "${ParcsDesc_Id}";
    wParc_Desc.ParcsDesc_Lib = ParcsDesc_Lib;

    return wParc_Desc;
  }


  Parc_Desc( {
    this.ParcsDescId,
    this.ParcsDesc_ParcsId,
    this.ParcsDesc_Type,
    this.ParcsDesc_Id,
    this.ParcsDesc_Lib,
  });

  Map<String, dynamic> toMap() {
    return {
      'ParcsDescId': ParcsDescId,
      'ParcsDesc_ParcsId': ParcsDesc_ParcsId,
      'ParcsDesc_Type': ParcsDesc_Type,
      'ParcsDesc_Id': ParcsDesc_Id,
      'ParcsDesc_Lib': ParcsDesc_Lib,
    };
  }

  Map<String, dynamic> toMapInsert() {
    return {

      'ParcsDesc_ParcsId': ParcsDesc_ParcsId,
      'ParcsDesc_Type': ParcsDesc_Type,
      'ParcsDesc_Id': ParcsDesc_Id,
      'ParcsDesc_Lib': ParcsDesc_Lib,
    };
  }

  factory Parc_Desc.fromMap(Map<String, dynamic> map) {
    Parc_Desc wParc_Desc = Parc_Desc(
      ParcsDescId: map["ParcsDescId"],
      ParcsDesc_ParcsId: map["ParcsDesc_ParcsId"],
      ParcsDesc_Type: map["ParcsDesc_Type"],
      ParcsDesc_Id: map["ParcsDesc_Id"],
      ParcsDesc_Lib: map["ParcsDesc_Lib"],
    );
    return wParc_Desc;
  }


  @override
  String toString() {
    return 'Parc_DesctoString {ParcsDescId: $ParcsDescId, ParcsDesc_ParcsId: $ParcsDesc_ParcsId, ParcsDesc_Type $ParcsDesc_Type, ParcsDesc_Id : $ParcsDesc_Id,ParcsDesc_Lib : $ParcsDesc_Lib,}';
  }
}
