
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';

class Parc_Desc {
  int?    ParcsDescId = 0;
  int?    ParcsDesc_ParcsId = 0;
  String? ParcsDesc_Type = "";
  String? ParcsDesc_Id = "";
  String? ParcsDesc_Lib = "";

  static Parc_DescInit(int wparcsdescParcsid, String wparcsdescType) {

    String parcsdescLib = "---";
    int parcsdescId = -1;

//    print("Parc_DescInit Parc_DescInit Parc_DescInit Parc_DescInit ${wParcsDesc_Type}");

    Srv_DbTools.getParam_Saisie_ParamMem(wparcsdescType);
    for (var element in Srv_DbTools.ListParam_Saisie_Param) {
      if (element.Param_Saisie_Param_Init) {
        parcsdescLib = element.Param_Saisie_Param_Label;
        parcsdescId = element.Param_Saisie_ParamId;
//        print(">><<<<<<<<<>>>>>>><<<<<<<<<>>>>>>> Parc_DescInit ${element.Desc()}");

        continue;
        }
      }
    Parc_Desc wparcDesc = Parc_Desc();
    wparcDesc.ParcsDescId = -1;
    wparcDesc.ParcsDesc_ParcsId = wparcsdescParcsid;
    wparcDesc.ParcsDesc_Type = wparcsdescType;
    wparcDesc.ParcsDesc_Id = "$parcsdescId";
    wparcDesc.ParcsDesc_Lib = parcsdescLib;

    return wparcDesc;
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
    Parc_Desc wparcDesc = Parc_Desc(
      ParcsDescId: map["ParcsDescId"],
      ParcsDesc_ParcsId: map["ParcsDesc_ParcsId"],
      ParcsDesc_Type: map["ParcsDesc_Type"],
      ParcsDesc_Id: map["ParcsDesc_Id"],
      ParcsDesc_Lib: map["ParcsDesc_Lib"],
    );
    return wparcDesc;
  }


  @override
  String toString() {
    return 'Parc_DesctoString {ParcsDescId: $ParcsDescId, ParcsDesc_ParcsId: $ParcsDesc_ParcsId, ParcsDesc_Type $ParcsDesc_Type, ParcsDesc_Id : $ParcsDesc_Id,ParcsDesc_Lib : $ParcsDesc_Lib,}';
  }
}
