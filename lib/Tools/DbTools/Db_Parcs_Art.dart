import 'package:flutter/material.dart';

class Parc_Art {
  int?    ParcsArtId = 0;
  int?    ParcsArt_ParcsId = 0;
  String? ParcsArt_Id = "";
  String? ParcsArt_Type = "";
  String? ParcsArt_lnk = "";

  String? ParcsArt_Fact = "";
  String? ParcsArt_Livr = "";
  int?    ParcsArt_Qte = 0;

  String? ParcsArt_Lib = "";
  int?    Qte = 0;
  Image?  wImage ;
  bool    wImgeTrv       = false;
  bool    Art_Sel       = false;


  static Parc_ArtInit(int wparcsartParcsid) {
    String parcsartLib = "---";
    int parcsartId = -1;
    Parc_Art wparcArt = Parc_Art();
    wparcArt.ParcsArtId = -1;
    wparcArt.ParcsArt_ParcsId = wparcsartParcsid;
    wparcArt.ParcsArt_Type = "P";
    wparcArt.ParcsArt_lnk = "";
    wparcArt.ParcsArt_Fact = "Fact.";
    wparcArt.ParcsArt_Livr = "Livré";
    wparcArt.ParcsArt_Id = "$parcsartId";
    wparcArt.ParcsArt_Lib = parcsartLib;
    wparcArt.ParcsArt_Qte = 0;
    wparcArt.Qte = 0;
    wparcArt.wImage = Image.asset("assets/images/Audit_det.png", height: 30, width: 30,);
    return wparcArt;
  }


  Parc_Art( {
    this.ParcsArtId,
    this.ParcsArt_ParcsId,
    this.ParcsArt_Type,
    this.ParcsArt_lnk,
    this.ParcsArt_Fact,
    this.ParcsArt_Livr,
    this.ParcsArt_Id,
    this.ParcsArt_Lib,
    this.ParcsArt_Qte,
    this.Qte,
  });


  static String getIndex(Parc_Art wparcArt, int index) {
    int wQteLivr = 0;
    int wQteRel = 0;

    String parcsartLivr = wparcArt.ParcsArt_Livr!.substring(0,1);
    if (parcsartLivr.compareTo("R") == 0)
      {
        wQteRel = wparcArt.ParcsArt_Qte!;
      }
      else
        {
          wQteLivr = wparcArt.ParcsArt_Qte!;

        }


    switch (index) {
      case 0:
        return wparcArt.ParcsArt_Id.toString();
      case 1:
        return wparcArt.ParcsArt_Lib.toString();
      case 2:
        return wQteLivr.toStringAsFixed(2).toString();
      case 3:
        return "";
      case 4:
        return wQteRel.toStringAsFixed(2).toString();

    }
    return '';
  }

static  Parc_Art fromMap(Map<String, dynamic> map) {
    return Parc_Art(
        ParcsArtId: map["ParcsArtId"],
        ParcsArt_ParcsId: map["ParcsArt_ParcsId"],
        ParcsArt_Fact: map["ParcsArt_Fact"],
        ParcsArt_Livr: map["ParcsArt_Livr"],
        ParcsArt_Type: map["ParcsArt_Type"],
        ParcsArt_lnk: map["ParcsArt_lnk"],
        ParcsArt_Id: map["ParcsArt_Id"],
        ParcsArt_Lib: map["ParcsArt_Lib"],
        ParcsArt_Qte: map["ParcsArt_Qte"],
    );


  }

  static  Parc_Art fromMapQte(Map<String, dynamic> map) {
    return Parc_Art(
      ParcsArtId: map["ParcsArtId"],
      ParcsArt_ParcsId: map["ParcsArt_ParcsId"],
      ParcsArt_Type: map["ParcsArt_Type"],
      ParcsArt_lnk: map["ParcsArt_lnk"],
      ParcsArt_Fact: map["ParcsArt_Fact"],
      ParcsArt_Livr: map["ParcsArt_Livr"],
      ParcsArt_Id: map["ParcsArt_Id"],
      ParcsArt_Lib: map["ParcsArt_Lib"],
      ParcsArt_Qte: map["ParcsArt_Qte"],
      Qte: map["Qte"],
    );


  }


    Map<String, dynamic> toMap() {
      return {
        'ParcsArtId': ParcsArtId,
        'ParcsArt_ParcsId': ParcsArt_ParcsId,
        'ParcsArt_Type': ParcsArt_Type,
        'ParcsArt_lnk': ParcsArt_lnk,
        'ParcsArt_Fact': ParcsArt_Fact,
        'ParcsArt_Livr': ParcsArt_Livr,
        'ParcsArt_Id': ParcsArt_Id,
        'ParcsArt_Lib': ParcsArt_Lib,
        'ParcsArt_Qte': ParcsArt_Qte,

      };
    }

    @override
    String toString() {
      return 'Parc_Art {ParcsArtId : $ParcsArtId, ParcsArt_ParcsId: $ParcsArt_ParcsId,ParcsArt_Id : $ParcsArt_Id, ParcsArt_Type : $ParcsArt_Type, ParcsArt_lnk : $ParcsArt_lnk, ParcsArt_Fact : $ParcsArt_Fact, ParcsArt_Livr : $ParcsArt_Livr, ParcsArt_Lib : $ParcsArt_Lib, ParcsArt_Qte : $ParcsArt_Qte,}';
    }

  @override
  String Desc() {
    return 'Parc_Art {ParcsArtId : $ParcsArtId,ParcsArt_Id : $ParcsArt_Id, ParcsArt_Fact : $ParcsArt_Fact, ParcsArt_Livr: $ParcsArt_Livr, ParcsArt_ParcsId: $ParcsArt_ParcsId, ParcsArt_Type : $ParcsArt_Type, ParcsArt_lnk : ParcsArt_Id : $ParcsArt_Id, ParcsArt_Lib : $ParcsArt_Lib, ParcsArt_Qte : $ParcsArt_Qte,}';
  }



  }

