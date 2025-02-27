import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/GestCo/DCL_Ent_Garantie_Dialog.dart';

/*
*/

class Article_Ebp {
  int     ArticleID = 0;
  String Article_codeArticle = "";
  String Article_descriptionCommerciale = "";
  String Article_descriptionCommercialeEnClair = "";
  String Article_codeFamilleArticles = "";
  String Article_LibelleFamilleArticle = "";
  String Article_CodeSousFamilleArticle = "";
  String Article_LibelleSousFamilleArticle = "";
  double Article_PVHT = 0;
  double Article_tauxTVA = 0;
  String Article_codeTVA = "";
  double Article_PVTTC = 0;
  double Article_stockReel = 0;
  double Article_stockVirtuel = 0;
  String Article_Notes = "";
  bool   Article_Pousse     = false;
  bool   Article_New     = false;

  double  Article_Promo_PVHT = 0;
  String  Article_Libelle     = "";
  String  Article_Groupe      = "";
  String  Article_Fam         = "";
  String  Article_Sous_Fam    = "";
  String  Article_codeArticle_Parent = "";
  bool    Art_Sel       = false;
  int     Art_Qte       = 0;
  Image?  wImage ;
  bool    wImgeTrv       = false;
  Image?  wImageL ;
  bool    wImgeTrvL       = false;
  int     DCL_Det_Livr = 0;
  String DCL_Det_DateLivr = "";
  String DCL_Det_Statut = "Facturable";

  double DCL_Det_PU = 0;
  double DCL_Det_RemP = 0;
  double DCL_Det_RemMt = 0;
  double DCL_Det_TVA = 0;

  String DCL_Det_Garantie = "Garantie";

  Uint8List DCL_Det_Path1 = Uint8List.fromList([]);
  Uint8List DCL_Det_Path2 = Uint8List.fromList([]);
  Uint8List DCL_Det_Path3 = Uint8List.fromList([]);

  Image wImageG1 = Image.memory(blankBytes, height: 1,);
  Image wImageG2 = Image.memory(blankBytes, height: 1,);
  Image wImageG3 = Image.memory(blankBytes, height: 1,);


  static Article_EbpInit() {
    Article_Ebp warticleEbp =  Article_Ebp(-1, "", "", "", "", "", "", "", 0, 0, "", 0, 0, 0, "", false, false, 0, "","","","", "");
    warticleEbp.wImage = Image.asset("assets/images/Audit_det.png", height: 30, width: 30,);
    return warticleEbp;
  }

  Article_Ebp(int ArticleID, String Article_codeArticle, String Article_descriptionCommerciale, String Article_descriptionCommercialeEnClair, String Article_codeFamilleArticles, String Article_LibelleFamilleArticle, String Article_CodeSousFamilleArticle, String Article_LibelleSousFamilleArticle, double Article_PVHT, double Article_tauxTVA, String Article_codeTVA, double Article_PVTTC, double Article_stockReel, double Article_stockVirtuel, String Article_Notes,bool     Article_Pousse, bool     Article_New, double  Article_Promo_PVHT,String  Article_Libelle, String  Article_Groupe,String  Article_Fam, String  Article_Sous_Fam,String  Article_codeArticle_Parent) {
    this.ArticleID                              = ArticleID;
    this.Article_codeArticle                    = Article_codeArticle;
    this.Article_descriptionCommerciale         = Article_descriptionCommerciale;
    this.Article_descriptionCommercialeEnClair  = Article_descriptionCommercialeEnClair;
    this.Article_codeFamilleArticles            = Article_codeFamilleArticles;
    this.Article_LibelleFamilleArticle          = Article_LibelleFamilleArticle;
    this.Article_CodeSousFamilleArticle         = Article_CodeSousFamilleArticle;
    this.Article_LibelleSousFamilleArticle      = Article_LibelleSousFamilleArticle;
    this.Article_PVHT                           = Article_PVHT;
    this.Article_tauxTVA                        = Article_tauxTVA;
    this.Article_codeTVA                        = Article_codeTVA;
    this.Article_PVTTC                          = Article_PVTTC;
    this.Article_stockReel                      = Article_stockReel;
    this.Article_stockVirtuel                   = Article_stockVirtuel;
    this.Article_Notes                          = Article_Notes;
    this.Article_Pousse                         = Article_Pousse;
    this.Article_New                         = Article_New;
    this.Article_Promo_PVHT                     = Article_Promo_PVHT;
    this.Article_Libelle                        = Article_Libelle;
    this.Article_Groupe                         = Article_Groupe;
    this.Article_Fam                            = Article_Fam;
    this.Article_Sous_Fam                       = Article_Sous_Fam;
    this.Article_codeArticle_Parent             = Article_codeArticle_Parent;

  }

   Map<String, dynamic> toMap() {
    return {
      'ArticleID': ArticleID,
      'Article_codeArticle': Article_codeArticle,
      'Article_descriptionCommerciale': Article_descriptionCommerciale,
      'Article_descriptionCommercialeEnClair': Article_descriptionCommercialeEnClair,
      'Article_codeFamilleArticles': Article_codeFamilleArticles,
      'Article_LibelleFamilleArticle': Article_LibelleFamilleArticle,
      'Article_CodeSousFamilleArticle': Article_CodeSousFamilleArticle,
      'Article_LibelleSousFamilleArticle': Article_LibelleSousFamilleArticle,
      'Article_PVHT': Article_PVHT,
      'Article_tauxTVA': Article_tauxTVA,
      'Article_codeTVA': Article_codeTVA,
      'Article_PVTTC': Article_PVTTC,
      'Article_stockReel': Article_stockReel,
      'Article_stockVirtuel': Article_stockVirtuel,
      'Article_Notes': Article_Notes,
      'Article_Pousse': Article_Pousse,
      'Article_New': Article_New,
      'Article_Promo_PVHT': Article_Promo_PVHT,
      'Article_Libelle': Article_Libelle,
      'Article_Groupe': Article_Groupe,
      'Article_Fam': Article_Fam,
      'Article_Sous_Fam': Article_Sous_Fam,
      'Article_codeArticle_Parent': Article_codeArticle_Parent,
    };
  }


  factory Article_Ebp.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Article_Ebp warticleEbp = Article_Ebp(
      int.parse(json['ArticleID']),
      json['Article_codeArticle'],
      json['Article_descriptionCommerciale'],
      json['Article_descriptionCommercialeEnClair'],
      json['Article_codeFamilleArticles'],
      json['Article_LibelleFamilleArticle'],
      json['Article_CodeSousFamilleArticle'],
      json['Article_LibelleSousFamilleArticle'],
      double.parse(json['Article_PVHT']),
      double.parse(json['Article_tauxTVA']),
      json['Article_codeTVA'],
      double.parse(json['Article_PVTTC']),
      double.parse(json['Article_stockReel']),
      double.parse(json['Article_stockVirtuel']),
      json['Article_Notes'],
      int.parse(json['Article_Pousse']) == 1,
      int.parse(json['Article_New']) == 1,
      double.parse(json['Article_Promo_PVHT']),
      json['Article_Libelle'],
      json['Article_Groupe'],
      json['Article_Fam'],
      json['Article_Sous_Fam'],
      json['Article_codeArticle_Parent'],
    );

    return warticleEbp;
  }

  String Desc() {
    return '$ArticleID,$Article_codeArticle,$Article_descriptionCommerciale,$Article_descriptionCommercialeEnClair,$Article_codeFamilleArticles,$Article_LibelleFamilleArticle,$Article_CodeSousFamilleArticle,$Article_LibelleSousFamilleArticle,$Article_PVHT,$Article_tauxTVA,$Article_codeTVA,$Article_PVTTC, $Article_stockReel, $Article_stockVirtuel, $Article_Notes $Article_Pousse  $Article_New  ,$Article_Promo_PVHT, $Article_Libelle   ,$Article_Groupe    ,$Article_Fam       ,$Article_Sous_Fam  ,$Article_codeArticle_Parent, ';
  }
  String DescRech() {
    return '$ArticleID,$Article_codeArticle,$Article_descriptionCommercialeEnClair,';
  }

  static Future<List<Article_Ebp>> getArticle_Ebp() async {
    final db = await DbTools.database;
    final List<Map<String, dynamic>> maps = await db.query("Articles_Ebp", orderBy: "Article_codeArticle ASC");

    return List.generate(maps.length, (i) {
      return Article_Ebp(
        maps[i]["ArticleID"],
        maps[i]["Article_codeArticle"],
        maps[i]["Article_descriptionCommerciale"],
        maps[i]["Article_descriptionCommercialeEnClair"],
        maps[i]["Article_codeFamilleArticles"],
        maps[i]["Article_LibelleFamilleArticle"],
        maps[i]["Article_CodeSousFamilleArticle"],
        maps[i]["Article_LibelleSousFamilleArticle"],
        maps[i]["Article_PVHT"],
        maps[i]["Article_tauxTVA"],
        maps[i]["Article_codeTVA"],
        maps[i]["Article_PVTTC"],
        maps[i]["Article_stockReel"],
        maps[i]["Article_stockVirtuel"],
        maps[i]["Article_Notes"],
        maps[i]["Article_Pousse"]==1,
        maps[i]["Article_New"]==1,
        maps[i]["Article_Promo_PVHT"],
        maps[i]["Article_Libelle"],
        maps[i]["Article_Groupe"],
        maps[i]["Article_Fam"],
        maps[i]["Article_Sous_Fam"],
        maps[i]["Article_codeArticle_Parent"],


      );
    });
  }

  static Future<void> insertArticle_Ebp(Article_Ebp articleEbp) async {
    final db = await DbTools.database;
    int? repid = await db.insert("Articles_Ebp", articleEbp.toMap());

  }

  static Future<void> TrunckArticle_Ebp() async {
    final db = await DbTools.database;
    int? repid = await db.delete("Articles_Ebp");
  }



}
