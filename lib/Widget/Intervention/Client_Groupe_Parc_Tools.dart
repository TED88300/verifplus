import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Link_Verif_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';

class Client_Groupe_Parc_Tools {
  static List<Result_Article_Link_Verif> listResult_Article_Link_Verif_Deb = [];
  static List<Result_Article_Link_Verif> listResult_Article_Link_Verif_Fin = [];

  static List<Result_Article_Link_Verif> listResult_Article_Mo = [];
  static List<Result_Article_Link_Verif> listResult_Article_Dn = [];

  static String wRefBase = "VerifAnn, Rech, MAA, Charge, RA, ";
  static String wRefRES = "RES";
  static String wRefInst = "Inst";

  static List<Parc_Art> wlParcs_Art = [];

  static bool isRef = false;

  static Future InitArt() async {
    if (Srv_DbTools.REF_Lib.isNotEmpty) {
      isRef = true;
      print("<≈≈≈> <≈≈≈> InitArt A ${isRef} ${Srv_DbTools.REF_Lib}");

      await Srv_DbTools.getArticle_Link_Verif_Indisp(Srv_DbTools.REF_Lib);

      await Srv_DbTools.getArticle_Link_Verif_All(Srv_DbTools.REF_Lib);
      if (Srv_DbTools.ListResult_Article_Link_Verif.length == 0) isRef = false;
      print("<≈≈≈> <≈≈≈> InitArt B ${isRef}");
    } else {
      print("<≈≈≈> <≈≈≈> InitArt C ${isRef} ${Srv_DbTools.REF_Lib}");
      isRef = false;
    }

    wlParcs_Art = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);

    print("<≈≈≈>  InitArt D listResult_Article_Link_Verif_Deb ${listResult_Article_Link_Verif_Deb.length}");
    await AddArt(listResult_Article_Link_Verif_Deb);
  }

  static Future<List<Result_Article_Link_Verif>> getVerifLink() async {

    bool wDbg = false;
    bool wDbg2 = true;


    if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink ${isRef}  DbTools.gParc_Ent.Parcs_UUID_Parent ${DbTools.gParc_Ent.Parcs_UUID_Parent}");
    List<Result_Article_Link_Verif> wVerifLink = [];
//    if (!isRef) return wVerifLink;

    if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink REF_Lib ${Srv_DbTools.REF_Lib}");


    // ==
    //    ==> Création tableau des Verif
    // ==

    String wRef = wRefBase;
//    print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink wRefBase ${wRefBase}");
    if (DbTools.gParc_Ent.Parcs_UUID_Parent!.isNotEmpty)
      {
        wRef = wRefInst;
 //       print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink wRefInst ${wRefInst}");
      }
    else {
      for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
        Parc_Desc wParc_Desc = DbTools.glfParcs_Desc[i];
        if (!wParc_Desc.ParcsDesc_Lib!.contains("---")) {
          if (wParc_Desc.ParcsDesc_Type!.compareTo("RES") == 0) {
            wRef = wRefRES;
//            print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink wRefRES ${wRefRES}");
          }
        }
      }
    }
//    print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink wRef ${wRef}");

    List<String> wVerif = [];
    for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
      Parc_Desc wParc_Desc = DbTools.glfParcs_Desc[i];
      if (!wParc_Desc.ParcsDesc_Lib!.contains("---")) {
        if (wRef.contains(wParc_Desc.ParcsDesc_Type!)) {
          for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
            Param_Saisie wParam_Saisie = Srv_DbTools.ListParam_Verif_Base[i];
            if (wParc_Desc.ParcsDesc_Type!.compareTo(wParam_Saisie.Param_Saisie_ID) == 0) {
              {
                wVerif.add(wParc_Desc.ParcsDesc_Type!);
              }
            }
          }
        }
      }
    }

//    print(">>>>>>>>>>> getVerifLink wRef ${wRef} wVerif ${wVerif}");

    String sVerif = "";
    wVerif.forEach((verifDeb) {
      if (sVerif.length > 0) sVerif += ",";
      sVerif += "'$verifDeb'";
    });

    if (DbTools.gParc_Ent.Parcs_UUID_Parent!.isNotEmpty) sVerif = "'Inst'";

    if (wDbg) print(">>>>>>>>>>> getVerifLink sVerif ${sVerif}");

    // <<
    //   << Création tableau des Verif
    // <<

    Srv_DbTools.ListResult_Article_Link_Verif.clear();
    Srv_DbTools.ListResult_Article_Link_Verif_PROP.clear();
    Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte.clear();


    if (Srv_DbTools.GAM_Lib.compareTo("---") == 0)
      return wVerifLink;


    // PIECE ACTION
    DbTools.glfNF074_Pieces_Actions_In = await DbTools.getNF074_Pieces_Actions_In(sVerif);
    for (int i = 0; i < DbTools.glfNF074_Pieces_Actions_In.length; i++) {
      NF074_Pieces_Actions wNF074_Pieces_Actions_In = DbTools.glfNF074_Pieces_Actions_In[i];
      if (wDbg) print(">>>>>>>>>>> wNF074_Pieces_Actions_In  ${wNF074_Pieces_Actions_In.NF074_Pieces_Actions_CodeArticlePD1}  ${wNF074_Pieces_Actions_In.NF074_Pieces_Actions_DescriptionPD1}  ${wNF074_Pieces_Actions_In.NF074_Pieces_Actions_QtePD1}");
      Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "V", "${wNF074_Pieces_Actions_In.NF074_Pieces_Actions_CodeArticlePD1}", wNF074_Pieces_Actions_In.NF074_Pieces_Actions_QtePD1 +  0.0 ));
    }

    if (wDbg) print(">>>>>>>>>>> getNF074_Pieces_Det_In");

    // PIECE DET


    bool Is_Piece_Det = await DbTools.getNF074_Pieces_Det_Is_Def();

    print(">>>>>>>>>>> Is_Piece_Det $Is_Piece_Det");

    if (Is_Piece_Det)
      {
        DbTools.glfNF074_Pieces_Det_In = await DbTools.getNF074_Pieces_Det_In(sVerif);
        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_In.length; i++) {
          NF074_Pieces_Det wNF074_Pieces_Det_In = DbTools.glfNF074_Pieces_Det_In[i];
          if (wDbg)           print(" wNF074_Pieces_Det_In  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_DescriptionPD1}  1");
          Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", "${wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD1}", 1.0 ));
        }

        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_In.length; i++) {
          NF074_Pieces_Det wNF074_Pieces_Det_In = DbTools.glfNF074_Pieces_Det_In[i];
          if (wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD2.isNotEmpty )
          {
            if (wDbg) print(" wNF074_Pieces_Det_In ${wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD2}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_DescriptionPD2}  1");
            Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", "${wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD2}", 1.0 ));
          }
        }

        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_In.length; i++) {
          NF074_Pieces_Det wNF074_Pieces_Det_In = DbTools.glfNF074_Pieces_Det_In[i];
          if (wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD3.isNotEmpty )
          {
            if (wDbg) print(" wNF074_Pieces_Det_In ${wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD3}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_DescriptionPD3}  1");
            Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", "${wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD3}", 1.0 ));
          }
        }

        DbTools.glfNF074_Pieces_Det_Prop = await DbTools.getNF074_Pieces_Det_PROP();
        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Prop.length; i++) {
          NF074_Pieces_Det wNF074_Pieces_Det_Prop = DbTools.glfNF074_Pieces_Det_Prop[i];
          if (wDbg2) print(">>>>>>>>>>> wNF074_Pieces_Det_Prop  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_DescriptionPD1}  1");
          Srv_DbTools.ListResult_Article_Link_Verif_PROP.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", "${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD1}", 1.0 ));
        }

        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Prop.length; i++) {
          NF074_Pieces_Det wNF074_Pieces_Det_Prop = DbTools.glfNF074_Pieces_Det_Prop[i];
          if (wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD2.isNotEmpty )
          {
            if (wDbg2) print(">>>>>>>>>>> wNF074_Pieces_Det_Prop ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD2}  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_DescriptionPD2}  1");
            Srv_DbTools.ListResult_Article_Link_Verif_PROP.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", "${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD2}", 1.0 ));
          }
        }

        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Prop.length; i++) {
          NF074_Pieces_Det wNF074_Pieces_Det_Prop = DbTools.glfNF074_Pieces_Det_Prop[i];
          if (wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD3.isNotEmpty )
          {
            if (wDbg2) print(">>>>>>>>>>> wNF074_Pieces_Det_Prop ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD3}  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_DescriptionPD3}  1");
            Srv_DbTools.ListResult_Article_Link_Verif_PROP.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", "${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD3}", 1.0 ));
          }
        }
      }
    else{
      DbTools.glfNF074_Pieces_Det_Inc_In = await DbTools.getNF074_Pieces_Det_Inc_In(sVerif);
      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_In.length; i++) {
        NF074_Pieces_Det_Inc wNF074_Pieces_Det_Inc = DbTools.glfNF074_Pieces_Det_Inc_In[i];
        if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1.isNotEmpty )
          {
            if (wDbg) print(">>>>>>>>>>> NF074_Pieces_Det_Inc_In ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1}  ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_DescriptionPD1}  1");
            Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", "${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1}", 1.0 ));

          }
        }
      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_In.length; i++) {
        NF074_Pieces_Det_Inc wNF074_Pieces_Det_In = DbTools.glfNF074_Pieces_Det_Inc_In[i];
        print(">>>>>>>>>>> NF074_Pieces_Det_Inc_In MO ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD2}  1");

        if (wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2.isNotEmpty )
        {
          if (wDbg) print(">>>>>>>>>>> NF074_Pieces_Det_Inc_In MO ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD2}  1");
          Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", "${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2}", 1.0 ));
        }
      }

      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_In.length; i++) {
        NF074_Pieces_Det_Inc wNF074_Pieces_Det_In = DbTools.glfNF074_Pieces_Det_Inc_In[i];
        if (wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3.isNotEmpty) {
          if (wDbg) print(">>>>>>>>>>> NF074_Pieces_Det_Inc_In ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD3}  1");
          Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", "${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3}", 1.0));
        }
      }
        DbTools.glfNF074_Pieces_Det_Prop = await DbTools.getNF074_Pieces_Det_PROP();
      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_In.length; i++) {
        NF074_Pieces_Det_Inc wNF074_Pieces_Det_Inc = DbTools.glfNF074_Pieces_Det_Inc_In[i];
        if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1.isNotEmpty )
        {
          if (wDbg) print(">>>>>>>>>>> NF074_Pieces_Det_Inc_In_PROP ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1}  ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_DescriptionPD1}  1");
          Srv_DbTools.ListResult_Article_Link_Verif_PROP.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", "${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1}", 1.0 ));

        }
      }
      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_In.length; i++) {
        NF074_Pieces_Det_Inc wNF074_Pieces_Det_In = DbTools.glfNF074_Pieces_Det_Inc_In[i];
        if (wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2.isNotEmpty )
        {
          if (wDbg) print(">>>>>>>>>>> NF074_Pieces_Det_Inc_In_PROP ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD2}  1");
          Srv_DbTools.ListResult_Article_Link_Verif_PROP.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", "${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2}", 1.0 ));
        }
      }

      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_In.length; i++) {
        NF074_Pieces_Det_Inc wNF074_Pieces_Det_In = DbTools.glfNF074_Pieces_Det_Inc_In[i];
        if (wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3.isNotEmpty) {
          if (wDbg) print(">>>>>>>>>>> wNF074_Pieces_Det_In_PROP ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD3}  1");
          Srv_DbTools.ListResult_Article_Link_Verif_PROP.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", "${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3}", 1.0));
        }
      }
    }

    DbTools.glfNF074_Mixte_Produit_In = await DbTools.getNF074_Mixte_Produit_In(sVerif);
    for (int i = 0; i < DbTools.glfNF074_Mixte_Produit_In.length; i++) {
      NF074_Mixte_Produit wNF074_Mixte_Produit = DbTools.glfNF074_Mixte_Produit_In[i];
      if (wDbg)       print(">>>>>>>>>>> wNF074_Mixte_Produit ${wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD1}  ${wNF074_Mixte_Produit.NF074_Mixte_Produit_DescriptionPD1}  1");
        Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "S", "${wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD1}", 1.0 ));
    }
    DbTools.glfNF074_Mixte_Produit_In = await DbTools.getNF074_Mixte_Produit_In_Prop(sVerif);
    for (int i = 0; i < DbTools.glfNF074_Mixte_Produit_In.length; i++) {
      NF074_Mixte_Produit wNF074_Mixte_Produit = DbTools.glfNF074_Mixte_Produit_In[i];
      if (wDbg) print(">>>>>>>>>>> wNF074_Mixte_Produit PROP ${wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD1}  ${wNF074_Mixte_Produit.NF074_Mixte_Produit_DescriptionPD1}  1");
      Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "S", "${wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD1}", 1.0 ));
    }

    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif[i];
      if (wDbg) print(" ListResult_Article_Link_Verif  ${wResult_Article_Link_Verif.Desc()}");
    }

    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_PROP.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif_PROP[i];
      if (wDbg) print(" ListResult_Article_Link_Verif_PROP  ${wResult_Article_Link_Verif.Desc()}");
    }



    if (Srv_DbTools.ListResult_Article_Link_Verif.length > 0) wVerifLink.addAll(Srv_DbTools.ListResult_Article_Link_Verif);


    return wVerifLink;
  }


  static Future Del_All_Art() async {
    wlParcs_Art = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);
    for (var i = 0; i < wlParcs_Art.length; i++) {
      var element = wlParcs_Art[i];
        await DbTools.deleteParc_Art(element.ParcsArtId!);
    }
  }

  static Future GenMo() async {
    wlParcs_Art = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);
    for (var i = 0; i < wlParcs_Art.length; i++) {
      var element = wlParcs_Art[i];
      if (element.ParcsArt_Type!.compareTo("Mo") == 0) {
        await DbTools.deleteParc_Art(element.ParcsArtId!);
      }
    }

    listResult_Article_Mo.clear();

    await Srv_DbTools.getArticle_Link_EbpParentAll(Srv_DbTools.REF_Lib);
    for (var i = 0; i < wlParcs_Art.length; i++) {
      var wParc_Art = wlParcs_Art[i];
      for (var i = 0; i < Srv_DbTools.ListArticle_Link_Ebp.length; i++) {
        var Article_Link_Ebp = Srv_DbTools.ListArticle_Link_Ebp[i];
        if (Article_Link_Ebp.Articles_Link_MoID.isNotEmpty) {
          if (Article_Link_Ebp.Articles_Link_ChildID.compareTo(wParc_Art.ParcsArt_Id!) == 0) {
            print("MOMOMO ${wParc_Art.ParcsArt_Id} ${Article_Link_Ebp.Articles_Link_MoID} ${Article_Link_Ebp.Articles_Link_Tps}");

            bool trv = false;
            for (var i = 0; i < listResult_Article_Mo.length; i++) {
              var wResult_Article_Link_Verif = listResult_Article_Mo[i];
              if (wResult_Article_Link_Verif.ChildID.compareTo(Article_Link_Ebp.Articles_Link_MoID) == 0) {
                wResult_Article_Link_Verif.Qte += int.parse(Article_Link_Ebp.Articles_Link_Tps) * wParc_Art.ParcsArt_Qte!;
                trv = true;
              }
            }
            if (!trv) {
              double Qte = double.parse(Article_Link_Ebp.Articles_Link_Tps) * wParc_Art.ParcsArt_Qte!;
              Result_Article_Link_Verif wResult_Article_Link_Verif = Result_Article_Link_Verif("", "", Article_Link_Ebp.Articles_Link_MoID, Qte);
              listResult_Article_Mo.add(wResult_Article_Link_Verif);
            }
          }
        }
      }
    }

    for (var i = 0; i < listResult_Article_Mo.length; i++) {
      var wResult_Article_Link_Verif = listResult_Article_Mo[i];

      Parc_Art wParc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
      wParc_Art.ParcsArt_Id = wResult_Article_Link_Verif.ChildID;
      wParc_Art.ParcsArt_Type = "Mo";
      wParc_Art.ParcsArt_Lib = "Mo";

      var wArticle_Ebp = Srv_DbTools.ListArticle_Ebp.where((element) => element.Article_codeArticle.compareTo(wResult_Article_Link_Verif.ChildID) == 0);
      if (wArticle_Ebp.length > 0) wParc_Art.ParcsArt_Lib = wArticle_Ebp.first.Article_descriptionCommercialeEnClair;

      wParc_Art.ParcsArt_Qte = wResult_Article_Link_Verif.Qte.toInt();
      await DbTools.insertParc_Art(wParc_Art);
    }
  }

  static Future GenDn() async {
    wlParcs_Art = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);
    for (var i = 0; i < wlParcs_Art.length; i++) {
      var element = wlParcs_Art[i];
      if (element.ParcsArt_Type!.compareTo("Dn") == 0) {
        await DbTools.deleteParc_Art(element.ParcsArtId!);
      }
    }

    listResult_Article_Dn.clear();

    await Srv_DbTools.getArticle_Link_EbpParentAll(Srv_DbTools.REF_Lib);
    for (var i = 0; i < wlParcs_Art.length; i++) {
      var wParc_Art = wlParcs_Art[i];
      for (var i = 0; i < Srv_DbTools.ListArticle_Link_Ebp.length; i++) {
        var Article_Link_Ebp = Srv_DbTools.ListArticle_Link_Ebp[i];
        if (Article_Link_Ebp.Articles_Link_DnID.isNotEmpty) {
          if (Article_Link_Ebp.Articles_Link_ChildID.compareTo(wParc_Art.ParcsArt_Id!) == 0) {
            print("DNDNDN ${wParc_Art.ParcsArt_Id} ${Article_Link_Ebp.Articles_Link_DnID} ${Article_Link_Ebp.Articles_Link_DnQte}");
            bool trv = false;
            for (var i = 0; i < listResult_Article_Dn.length; i++) {
              var wResult_Article_Link_Verif = listResult_Article_Dn[i];
              if (wResult_Article_Link_Verif.ChildID.compareTo(Article_Link_Ebp.Articles_Link_DnID) == 0) {
                wResult_Article_Link_Verif.Qte += int.parse(Article_Link_Ebp.Articles_Link_DnQte) * wParc_Art.ParcsArt_Qte!;
                trv = true;
              }
            }
            if (!trv) {
              double Qte = double.parse(Article_Link_Ebp.Articles_Link_DnQte) * wParc_Art.ParcsArt_Qte!;
              Result_Article_Link_Verif wResult_Article_Link_Verif = Result_Article_Link_Verif("", "", Article_Link_Ebp.Articles_Link_DnID, Qte);
              listResult_Article_Dn.add(wResult_Article_Link_Verif);
            }
          }
        }
      }
    }

    for (var i = 0; i < listResult_Article_Dn.length; i++) {
      var wResult_Article_Link_Verif = listResult_Article_Dn[i];

      Parc_Art wParc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
      wParc_Art.ParcsArt_Id = wResult_Article_Link_Verif.ChildID;
      wParc_Art.ParcsArt_Type = "Dn";
      wParc_Art.ParcsArt_Lib = "Dn";

      var wArticle_Ebp = Srv_DbTools.ListArticle_Ebp.where((element) => element.Article_codeArticle.compareTo(wResult_Article_Link_Verif.ChildID) == 0);
      if (wArticle_Ebp.length > 0) wParc_Art.ParcsArt_Lib = wArticle_Ebp.first.Article_descriptionCommercialeEnClair;

      wParc_Art.ParcsArt_Qte = wResult_Article_Link_Verif.Qte.toInt();
      await DbTools.insertParc_Art(wParc_Art);
    }
  }

  static Future AddArt(List<Result_Article_Link_Verif> wVerifAdd) async {
    wlParcs_Art = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);
    for (int i = 0; i < wVerifAdd.length; i++) {
      Result_Article_Link_Verif verifDeb = wVerifAdd[i];
      bool wTrv = false;
      for (var i = 0; i < wlParcs_Art.length; i++) {
        var element = wlParcs_Art[i];
        if (element.ParcsArt_Id!.compareTo(verifDeb.ChildID) == 0) {
          wTrv = true;
          break;
        }
      }
      if (!wTrv) {
        Article_Ebp wArticle_Ebp = await Srv_DbTools.getArticle_Ebp(verifDeb.ChildID);
        Parc_Art wParc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
        wParc_Art.ParcsArt_Id = verifDeb.ChildID;
        wParc_Art.ParcsArt_Type = verifDeb.TypeChildID;
        wParc_Art.ParcsArt_lnk = "L";
        wParc_Art.ParcsArt_Lib = wArticle_Ebp.Article_descriptionCommercialeEnClair;
        wParc_Art.ParcsArt_Qte = verifDeb.Qte.toInt();
//        print(">>>>>>>>>>> insertParc_Art ${wParc_Art.toString()}");
        await DbTools.insertParc_Art(wParc_Art);
      }

    }
  }

  static Future SuppArt(List<Result_Article_Link_Verif> wVerifSupp) async {
    wlParcs_Art = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);
    print(">>>>>>>>>>> SuppArt ${wlParcs_Art.length}");

    for (int i = 0; i < wVerifSupp.length; i++) {
      Result_Article_Link_Verif verifDeb = wVerifSupp[i];
      print(">>>>>>>>>>> element ${verifDeb.ChildID}");
      for (var i = 0; i < wlParcs_Art.length; i++) {
        var element = wlParcs_Art[i];
        if (element.ParcsArt_Id!.compareTo(verifDeb.ChildID) == 0) {
                  print(">>>>>>>>>>> deleteParc_Art ${element.toString()}");
          await DbTools.deleteParc_Art(element.ParcsArtId!);
          break;
        }
      }
    }
  }
  static Future Gen_Articlesvp() async {

    print("≈≈≈> Gen_Articles >> listResult_Article_Link_Verif_Deb ${listResult_Article_Link_Verif_Deb.length}");


    print("≈≈≈> Gen_Articles >> Call getVerifLink");
    listResult_Article_Link_Verif_Fin = await getVerifLink();
    print("≈≈≈> Gen_Articles >> listResult_Article_Link_Verif_Fin ${listResult_Article_Link_Verif_Fin.length}");

    List<Result_Article_Link_Verif> wVerifAdd = [];
    List<Result_Article_Link_Verif> wVerifSupp = [];

    listResult_Article_Link_Verif_Deb.forEach((verifDeb) {
      bool trv = false;
      listResult_Article_Link_Verif_Fin.forEach((verifFin) {
        if (verifDeb.ChildID.compareTo(verifFin.ChildID) == 0) {
          trv = true;
          return;
        }
      });
      if (!trv) {
        print("≈≈≈> wVerifSupp >> SuppArt ${verifDeb.ChildID}");

        wVerifSupp.add(verifDeb);
      }
    });
    print("≈≈≈> Gen_Articles >> SuppArt ${wVerifSupp.length}");

    listResult_Article_Link_Verif_Fin.forEach((verifFin) {
      bool trv = false;
//      print("> verifFin.ChildID  F>> ${verifFin.ChildID} trv $trv");
      listResult_Article_Link_Verif_Deb.forEach((verifDeb) {

        if (verifDeb.ChildID.compareTo(verifFin.ChildID) == 0) {
          //        print("             > verifDeb.ChildID D>> ${verifDeb.ChildID} R ${(verifDeb.ChildID.compareTo(verifFin.ChildID) == 0)}");
          trv = true;
          return;
        }
      });
      if (!trv) {
        print("¶¶¶> verifFin.ChildID  F>> ${verifFin.ChildID} trv $trv");
        wVerifAdd.add(verifFin);
      }
    });
    print("≈≈≈> Gen_Articles >> AddArt ${wVerifAdd.length}");




/*
    if (wVerifAdd.length == 0 && wVerifSupp.length == 0)
      {
        print("≈≈≈> Gen_Articles >> Del_All_Art ${wVerifAdd.length} ${wVerifSupp.length}");
        await Del_All_Art();
      }
*/

    if (wVerifAdd.length > 0 ) await AddArt(wVerifAdd);
    if (wVerifSupp.length > 0 ) await SuppArt(wVerifSupp);


    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif[i];
      //print(" ListResult_Article_Link_Verif  ${wResult_Article_Link_Verif.Desc()}");
    }
    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_PROP.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif_PROP[i];
      //print(" ListResult_Article_Link_Verif_PROP  ${wResult_Article_Link_Verif.Desc()}");
    }


    DbTools.lParcs_Art = await DbTools.getParcs_Art_AllType(DbTools.gParc_Ent.ParcsId!);
    for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
      Parc_Art element = DbTools.lParcs_Art[i];
      print("getParcs_Art_AllType ${element.toString()}");

    }

    listResult_Article_Link_Verif_Deb = listResult_Article_Link_Verif_Fin;
  }

  static Future Gen_Articles() async {

    print("≈≈≈> Gen_Articles >> listResult_Article_Link_Verif_Deb ${listResult_Article_Link_Verif_Deb.length}");
    print("≈≈≈> Gen_Articles >> Call getVerifLink");
    listResult_Article_Link_Verif_Fin = await getVerifLink();
    print("≈≈≈> Gen_Articles >> listResult_Article_Link_Verif_Fin ${listResult_Article_Link_Verif_Fin.length}");

    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif[i];
      print(" ListResult_Article_Link_Verif  ${wResult_Article_Link_Verif.Desc()}");
    }
    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_PROP.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif_PROP[i];
      print(" ListResult_Article_Link_Verif_PROP  ${wResult_Article_Link_Verif.Desc()}");
    }

    await DbTools.deleteParc_Art_ParcsArt_ParcsId(DbTools.gParc_Ent.ParcsId!);
    await AddArt(listResult_Article_Link_Verif_Fin);



    DbTools.lParcs_Art = await DbTools.getParcs_Art_AllType(DbTools.gParc_Ent.ParcsId!);
    for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
      Parc_Art element = DbTools.lParcs_Art[i];
      print("¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶ getParcs_Art_AllType ${element.Desc()}");

    }

    listResult_Article_Link_Verif_Deb = listResult_Article_Link_Verif_Fin;
  }

}
