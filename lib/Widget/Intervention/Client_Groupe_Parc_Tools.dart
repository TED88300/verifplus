import 'package:fbroadcast/fbroadcast.dart';
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

  static String wRefBase = "Inst,VerifAnn, Rech, MAA, Charge, RA, ";
  static String wRefRES = "RES";
  static String wRefInst = "Inst";

  static List<Parc_Art> wlParcs_Art = [];

  static bool isRef = false;

  static Future ArttoDeb() async {
    for (int i = 0; i < Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.length; i++) {
      Result_Article_Link_Verif verifDeb = Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb[i];
      for (var j = 0; j < wlParcs_Art.length; j++) {
        var element = wlParcs_Art[j];
        if (element.ParcsArt_Id!.compareTo(verifDeb.ChildID) == 0) {
          Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb[i].Fact = element.ParcsArt_Fact;
          Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb[i].Livr = element.ParcsArt_Livr;
          break;
        }
      }
    }
  }

  static Future DebtoArt() async {
    print("lParcs_Art ${DbTools.lParcs_Art.length}");

    for (var i = 0; i < DbTools.lParcs_Art.length; i++) {
      var element = DbTools.lParcs_Art[i];
      for (int j = 0; j < Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.length; j++) {
        Result_Article_Link_Verif verifDeb = Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb[j];
        if (element.ParcsArt_Id!.compareTo(verifDeb.ChildID) == 0) {
          DbTools.lParcs_Art[i].ParcsArt_Fact = verifDeb.Fact;
          DbTools.lParcs_Art[i].ParcsArt_Livr = verifDeb.Livr;
          break;
        }
      }
    }
  }

  static Future InitArt() async {
    wlParcs_Art = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);
    print("InitArt wlParcs_Art (${DbTools.gParc_Ent.ParcsId}) => ${wlParcs_Art.length}");

    for (int i = 0; i < wlParcs_Art.length; i++) {
      Parc_Art element = wlParcs_Art[i];
      print("wlParcs_Art ART ${element.ParcsArtId} ${element.ParcsArt_Type} ${element.ParcsArt_Id} ${element.ParcsArt_Lib}");
    }

    List<Parc_Art> zwlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    List<Parc_Art> zlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    zlParcs_Art.addAll(zwlParcs_Art);

    print("InitArt zlParcs_Art  ${zlParcs_Art.length}");

    for (int i = 0; i < zlParcs_Art.length; i++) {
      Parc_Art element = zlParcs_Art[i];
      print("zlParcs_Art ART ${element.ParcsArtId} ${element.ParcsArt_Type} ${element.ParcsArt_Id} ${element.ParcsArt_Lib}");
    }

//    print("••••• ${Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.length }");
    if (Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.length == 0) {
      //    print("••••• Call getVerifLink C ");
      Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb = await Client_Groupe_Parc_Tools.getVerifLink();
    }

    List<Parc_Art> zzwlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    print("InitArt zzwlParcs_Art AAA  ${zzwlParcs_Art.length}");
    List<Parc_Art> zzlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    print("InitArt zlParcs_Art AAA ${zzlParcs_Art.length}");

    ArttoDeb();

    zzwlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    print("InitArt zzwlParcs_Art BBB  ${zzwlParcs_Art.length}");
    zzlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    print("InitArt zlParcs_Art BBB ${zzlParcs_Art.length}");

    for (int i = 0; i < Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.length; i++) {
      Result_Article_Link_Verif wLink = Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb[i];
      //  print("πππππππππππππππππππππ InitArt ART listResult_Article_Link_Verif_Deb ${wLink.Desc()}");
    }

    zzwlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    print("InitArt zzwlParcs_Art CCC  ${zzwlParcs_Art.length}");
    zzlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    print("InitArt zlParcs_Art CCC ${zzlParcs_Art.length}");

    print("<≈><≈><≈><≈><≈><≈><≈><≈><≈>  InitArt ART getParcs_ArtAll ${listResult_Article_Link_Verif_Deb.length}");
    await AddArt(listResult_Article_Link_Verif_Deb);





    zzwlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    print("InitArt zzwlParcs_Art DDD  ${zzwlParcs_Art.length}");
    zzlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    print("InitArt zlParcs_Art DDD ${zzlParcs_Art.length}");
  }

  static void AddCumul_Result_Article_Link_Verif(String ParentID, String TypeChildID, String ChildID, double Qte, String Fact, String Livr, bool isOU) {
    bool wTrv = false;
    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif[i];
      if (wResult_Article_Link_Verif.ParentID.compareTo(ParentID) == 0 && wResult_Article_Link_Verif.ChildID.compareTo(ChildID) == 0 && wResult_Article_Link_Verif.TypeChildID.compareTo(TypeChildID) == 0) {
        wTrv = true;
        wResult_Article_Link_Verif.Qte += Qte;
        //print("•••••••••••••••••••••••••••••••••• wResult_Article_Link_Verif UPD ${ParentID}  ${ChildID}  ${TypeChildID} ${wResult_Article_Link_Verif.Qte} ${Qte} ");
      }
    }

    if (!wTrv) {
      Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(ParentID, TypeChildID, ChildID, Qte, Fact, Livr, isOU));
    }
  }

  static void AddCumul_Result_Article_Link_Verif_PROP(String ParentID, String TypeChildID, String ChildID, double Qte, String Fact, String Livr) {
    if (ChildID.startsWith("S")) {
      AddCumul_Result_Article_Link_Verif_PROP_Service(ParentID, TypeChildID, ChildID, Qte, Fact, Livr);
      return;
    }

    bool wTrv = false;
    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_PROP.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif_PROP = Srv_DbTools.ListResult_Article_Link_Verif_PROP[i];
      if (wResult_Article_Link_Verif_PROP.ParentID.compareTo(ParentID) == 0 && wResult_Article_Link_Verif_PROP.ChildID.compareTo(ChildID) == 0 && wResult_Article_Link_Verif_PROP.TypeChildID.compareTo(TypeChildID) == 0) {
        wTrv = true;
        wResult_Article_Link_Verif_PROP.Qte += Qte;
        // print("•••••••••••••••••••••••••••••••••• wResult_Article_Link_Verif_PROP UPD ${ParentID}  ${ChildID}  ${TypeChildID} ${wResult_Article_Link_Verif_PROP.Qte} ${Qte} ");
      }
    }

    if (!wTrv) {
      Srv_DbTools.ListResult_Article_Link_Verif_PROP.add(Result_Article_Link_Verif(ParentID, TypeChildID, ChildID, Qte, Fact, Livr, false));
    }
  }

  static void AddCumul_Result_Article_Link_Verif_PROP_Mixte(String ParentID, String TypeChildID, String ChildID, double Qte, String Fact, String Livr) {
    if (ChildID.startsWith("S")) {
      AddCumul_Result_Article_Link_Verif_PROP_Service(ParentID, TypeChildID, ChildID, Qte, Fact, Livr);
      return;
    }

    bool wTrv = false;
    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif_PROP = Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte[i];
      if (wResult_Article_Link_Verif_PROP.ParentID.compareTo(ParentID) == 0 && wResult_Article_Link_Verif_PROP.ChildID.compareTo(ChildID) == 0 && wResult_Article_Link_Verif_PROP.TypeChildID.compareTo(TypeChildID) == 0) {
        wTrv = true;
        wResult_Article_Link_Verif_PROP.Qte += Qte;
        // print("•••••••••••••••••••••••••••••••••• wResult_Article_Link_Verif_PROP UPD ${ParentID}  ${ChildID}  ${TypeChildID} ${wResult_Article_Link_Verif_PROP.Qte} ${Qte} ");
      }
    }

    if (!wTrv) {
      Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte.add(Result_Article_Link_Verif(ParentID, TypeChildID, ChildID, Qte, Fact, Livr, false));
    }
  }

  static void AddCumul_Result_Article_Link_Verif_PROP_Service(String ParentID, String TypeChildID, String ChildID, double Qte, String Fact, String Livr) {
    bool wTrv = false;
    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif_PROP = Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service[i];
      if (wResult_Article_Link_Verif_PROP.ParentID.compareTo(ParentID) == 0 && wResult_Article_Link_Verif_PROP.ChildID.compareTo(ChildID) == 0 && wResult_Article_Link_Verif_PROP.TypeChildID.compareTo(TypeChildID) == 0) {
        wTrv = true;
        wResult_Article_Link_Verif_PROP.Qte += Qte;
        // print("•••••••••••••••••••••••••••••••••• wResult_Article_Link_Verif_PROP UPD ${ParentID}  ${ChildID}  ${TypeChildID} ${wResult_Article_Link_Verif_PROP.Qte} ${Qte} ");
      }
    }

    if (!wTrv) {
      Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service.add(Result_Article_Link_Verif(ParentID, TypeChildID, ChildID, Qte, Fact, Livr, false));
    }
  }

  static Future<List<Result_Article_Link_Verif>> getVerifLink() async {
    bool wDbg = false;
    bool wDbg2 = false;

    if (wDbg) print(" getVerifLink ");

    if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink ${isRef}  DbTools.gParc_Ent.Parcs_UUID_Parent ${DbTools.gParc_Ent.Parcs_UUID_Parent}");
    List<Result_Article_Link_Verif> wVerifLink = [];
//    if (!isRef) return wVerifLink;

    if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink REF_Lib ${Srv_DbTools.REF_Lib}");

    // ==
    //    ==> Création tableau des Verif
    // ==

    String wRef = wRefBase;
    if (wDbg) print("πππππ getVerifLink wRefBase ${wRef}");
    if (wDbg) print("πππππ DbTools.gParc_Ent.Parcs_UUID_Parent ${DbTools.gParc_Ent.Parcs_UUID_Parent}");
    if (DbTools.gParc_Ent.Parcs_UUID_Parent!.isNotEmpty) {
      wRef = wRefInst;
      if (wDbg) print("πππππ getVerifLink wRefInst ${wRefInst}");
    } else {
      for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
        Parc_Desc wParc_Desc = DbTools.glfParcs_Desc[i];
        if (!wParc_Desc.ParcsDesc_Lib!.contains("---")) {
          if (wParc_Desc.ParcsDesc_Type!.compareTo("RES") == 0) {
            wRef = wRefRES;
            if (wDbg) print("πππππ getVerifLink wRefRES ${wRefRES}");
          }
        }
      }
    }
    if (wDbg) print("πππππ getVerifLink wRef ${wRef}");

    List<String> wVerif = [];
    for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
      Parc_Desc wParc_Desc = DbTools.glfParcs_Desc[i];
      if (!wParc_Desc.ParcsDesc_Lib!.contains("---")) {
        if (wDbg) print("> wParc_Desc.ParcsDesc_Type ${wParc_Desc.ParcsDesc_Type}");

        if (wRef.contains(wParc_Desc.ParcsDesc_Type!)) {
          for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
            Param_Saisie wParam_Saisie = Srv_DbTools.ListParam_Verif_Base[i];
            if (wDbg) print("> wParam_Saisie.Param_Saisie_ID ${wParam_Saisie.Param_Saisie_ID}");
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

    if (wDbg) print(" ERASE ");
    Srv_DbTools.ListResult_Article_Link_Verif.clear();
    Srv_DbTools.ListResult_Article_Link_Verif_PROP.clear();
    Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte.clear();
    Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service.clear();

    if (Srv_DbTools.GAM_Lib.compareTo("---") == 0) return wVerifLink;

    if (wDbg) print(" PIECE ACTION ");
    DbTools.glfNF074_Pieces_Actions_In = await DbTools.getNF074_Pieces_Actions_In(sVerif);
    for (int i = 0; i < DbTools.glfNF074_Pieces_Actions_In.length; i++) {
      NF074_Pieces_Actions wNF074_Pieces_Actions_In = DbTools.glfNF074_Pieces_Actions_In[i];
      if (wDbg) print(">>>>>>>>>>> Pieces_Actions ADD  ${wNF074_Pieces_Actions_In.NF074_Pieces_Actions_CodeArticlePD1}  ${wNF074_Pieces_Actions_In.NF074_Pieces_Actions_DescriptionPD1}  ${wNF074_Pieces_Actions_In.NF074_Pieces_Actions_QtePD1}");
      Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif("${Srv_DbTools.REF_Lib}", "V", "${wNF074_Pieces_Actions_In.NF074_Pieces_Actions_CodeArticlePD1}", wNF074_Pieces_Actions_In.NF074_Pieces_Actions_QtePD1 + 0.0, "Fact.", "Livré", false));
    }

    // PIECE DET
    bool Is_Piece_Det = await DbTools.getNF074_Pieces_Det_Is_Def();

    if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Is_Piece_Det $Is_Piece_Det ${Srv_DbTools.REF_Lib}");

    if (Is_Piece_Det) {
      if (wDbg) print(" PIECE DET ");

      DbTools.glfNF074_Pieces_Det_In = await DbTools.getNF074_Pieces_Det_In(sVerif);

      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_In.length; i++) {
        NF074_Pieces_Det wNF074_Pieces_Det_In = DbTools.glfNF074_Pieces_Det_In[i];
      }

      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_In.length; i++) {
        NF074_Pieces_Det wNF074_Pieces_Det_In = DbTools.glfNF074_Pieces_Det_In[i];
//        print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det P  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_DescriptionPD1}");
        double MaxQte = 1.0;
        if (wNF074_Pieces_Det_In.NF074_Pieces_Det_VerifAnn == 2) MaxQte = 2;
        bool isOU = false;

        //          SELECT * FROM `NF074_Pieces_Det_Inc` where NF074_Pieces_Det_Inc_Description_PD1 like "%Gr-Adef%";
// Cartouche Ext. CO2 (Gr-Adef) - Fab Gen

        if (wNF074_Pieces_Det_In.NF074_Pieces_Det_DescriptionPD1.contains("“OU“")) isOU = true;
        AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD1, MaxQte, "Fact.", "Livré", isOU);


        if (wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD2.isNotEmpty) {
          AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD2, wNF074_Pieces_Det_In.NF074_Pieces_Det_QtePD2.toDouble(), "Fact.", "Livré", false);
        }

        if (wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD3.isNotEmpty) {
          AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD3, wNF074_Pieces_Det_In.NF074_Pieces_Det_QtePD3.toDouble(), "Fact.", "Livré", false);
        }
      }

      if (wDbg) print("\n\n");

      if (!sVerif.contains("RES")) {
        DbTools.glfNF074_Pieces_Det_Prop = await DbTools.getNF074_Pieces_Det_PROP();
        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Prop.length; i++) {
          NF074_Pieces_Det wNF074_Pieces_Det_Prop = DbTools.glfNF074_Pieces_Det_Prop[i];

          double MaxQte = 1.0;
          if (wNF074_Pieces_Det_Prop.NF074_Pieces_Det_VerifAnn == 2) MaxQte = 2;

          //  print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Prop P ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_DescriptionPD1}  1");
          AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "P", wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD1, MaxQte, "Fact.", "Livré");

          if (wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD2.isNotEmpty) {
            //  print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Prop Mo ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_DescriptionPD1}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "Mo", wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD2, wNF074_Pieces_Det_Prop.NF074_Pieces_Det_QtePD2.toDouble(), "Fact.", "Livré");
          }
          if (wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD3.isNotEmpty) {
            //print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Prop Dn ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_DescriptionPD1}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "Dn", wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD3, wNF074_Pieces_Det_Prop.NF074_Pieces_Det_QtePD3.toDouble(), "Fact.", "Livré");
          }
        }

        if (wDbg) print("\n\n");
      }
    } else {
      if (wDbg) print(" PIECE DET INCONNU ");

      DbTools.glfNF074_Pieces_Det_Inc_In = await DbTools.getNF074_Pieces_Det_Inc_In(sVerif);
      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_In.length; i++) {
        NF074_Pieces_Det_Inc wNF074_Pieces_Det_Inc = DbTools.glfNF074_Pieces_Det_Inc_In[i];
        if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1.isNotEmpty) {
          if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc P ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1}  ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_DescriptionPD1}  1");


          bool isGrAde = false;
          if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_DescriptionPD1 == "Cartouche Ext. CO2 (Gr-Adef) - Fab Gen") isGrAde = true;
          print(" isGrAde  ${isGrAde}");

          if (!isGrAde)
            AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1, wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_QtePD1.toDouble(), "Fact.", "Livré", false);
          else {
            List<NF074_Pieces_Det_Inc> G001_NF074_Pieces_Det_Inc = [];


            G001_NF074_Pieces_Det_Inc = await DbTools.getNF074_Pieces_Det_Inc_G110();

            print(" G001_NF074_Pieces_Det_Inc ");
            print(" G001_NF074_Pieces_Det_Inc ${G001_NF074_Pieces_Det_Inc.length} ");
            print(" G001_NF074_Pieces_Det_Inc ${Srv_DbTools.REF_Lib} ");

            for (int i = 0; i < G001_NF074_Pieces_Det_Inc.length; i++) {
              NF074_Pieces_Det_Inc gNF074_Pieces_Det_Inc = G001_NF074_Pieces_Det_Inc[i];
              AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", gNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1, gNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_QtePD1.toDouble(), "Fact.", "Livré", true);
            }

          }
        }
        if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD2.isNotEmpty) {
          // if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc Mo ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD2}  1");
          AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD2, wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_QtePD2.toDouble(), "Fact.", "Livré", false);
        }
        if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD3.isNotEmpty) {
          // if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc Dn ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD3}  1");
          AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD3, wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_QtePD3.toDouble(), "Fact.", "Livré", false);
        }
      }

      if (!sVerif.contains("RES")) {
        DbTools.glfNF074_Pieces_Det_Inc_Prop = await DbTools.getNF074_Pieces_Det_Inc_Prop();
        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_Prop.length; i++) {
          NF074_Pieces_Det_Inc wNF074_Pieces_Det_Inc = DbTools.glfNF074_Pieces_Det_Inc_Prop[i];
          if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1.isNotEmpty) {
            if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc PROP P ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1}                    ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_DescriptionPD1}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "P", wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD1, wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_QtePD1.toDouble(), "Fact.", "Livré");
          }

          if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD2.isNotEmpty) {
            // if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc PROP Mo ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD2}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "Mo", wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD2, wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_QtePD2.toDouble(), "Fact.", "Livré");
          }

          if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD3.isNotEmpty) {
            // if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc PROP Dn ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD3}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "Dn", wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CodeArticlePD3, wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_QtePD3.toDouble(), "Fact.", "Livré");
          }
        }
      }
    }

    if (wDbg) print(" MIXTE PRODUIT ");

    DbTools.glfNF074_Mixte_Produit_In = await DbTools.getNF074_Mixte_Produit_In(sVerif);
    for (int i = 0; i < DbTools.glfNF074_Mixte_Produit_In.length; i++) {
      NF074_Mixte_Produit wNF074_Mixte_Produit = DbTools.glfNF074_Mixte_Produit_In[i];
      if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Mixte_Produit S ${wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD1}  ${wNF074_Mixte_Produit.NF074_Mixte_Produit_DescriptionPD1}  1");
      AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "M", wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD1, wNF074_Mixte_Produit.NF074_Mixte_Produit_QtePD1.toDouble(), "Fact.", "Livré", false);

      if (wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD2.isNotEmpty) {
        Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", "${wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD2}", wNF074_Mixte_Produit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré", false));
        AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD2, wNF074_Mixte_Produit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré", false);
      }
      if (wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD3.isNotEmpty) {
        AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD3, wNF074_Mixte_Produit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré", false);
      }
    }

    if (wDbg) print("\n\n");

    if (!sVerif.contains("RES")) {
      DbTools.glfNF074_Mixte_Produit_In = await DbTools.getNF074_Mixte_Produit_In_Prop(sVerif);
      for (int i = 0; i < DbTools.glfNF074_Mixte_Produit_In.length; i++) {
        NF074_Mixte_Produit wNF074_Mixte_Produit = DbTools.glfNF074_Mixte_Produit_In[i];
        if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Mixte_Produit PROP ${wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD1}                    ${wNF074_Mixte_Produit.NF074_Mixte_Produit_DescriptionPD1}  1");
        AddCumul_Result_Article_Link_Verif_PROP_Mixte(Srv_DbTools.REF_Lib, "M", wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD1, wNF074_Mixte_Produit.NF074_Mixte_Produit_QtePD1.toDouble(), "Fact.", "Livré");

        if (wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD2.isNotEmpty) {
          AddCumul_Result_Article_Link_Verif_PROP_Mixte(Srv_DbTools.REF_Lib, "Mo", wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD2, wNF074_Mixte_Produit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré");
        }
        if (wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD3.isNotEmpty) {
          AddCumul_Result_Article_Link_Verif_PROP_Mixte(Srv_DbTools.REF_Lib, "Dn", wNF074_Mixte_Produit.NF074_Mixte_Produit_CodeArticlePD3, wNF074_Mixte_Produit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré");
        }
      }
      if (wDbg) print("\n\n");
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
        if (verifDeb.isOU) DbTools.gIsOU = true;
        Article_Ebp wArticle_Ebp = await Srv_DbTools.IMPORT_Article_Ebp(verifDeb.ChildID);
        Parc_Art wParc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
        wParc_Art.ParcsArt_Id = verifDeb.ChildID;
        wParc_Art.ParcsArt_Type = verifDeb.TypeChildID;
        wParc_Art.ParcsArt_lnk = "L";
        wParc_Art.ParcsArt_Lib = verifDeb.isOU ? ">>> ${wArticle_Ebp.Article_descriptionCommercialeEnClair}" : "${wArticle_Ebp.Article_descriptionCommercialeEnClair}";
        wParc_Art.ParcsArt_Qte = verifDeb.Qte.toInt();
        wParc_Art.ParcsArt_Livr = verifDeb.Livr;
        wParc_Art.ParcsArt_Fact = verifDeb.Fact;
//        print(">>>>>>>>>>> insertParc_Art ${wParc_Art.toString()}");
        await DbTools.insertParc_Art(wParc_Art);
        wlParcs_Art.add(wParc_Art);
        if (verifDeb.isOU) {
          DbTools.gIsOUlParcs_Art.add(wParc_Art);
        }
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

  static Future Gen_Articles() async {
    for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
      Parc_Art element = DbTools.lParcs_Art[i];
//      print("¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶ AAA getParcs_Art_AllType ${element.Desc()}");
    }

    List<Parc_Art> wlParcs_Art = [];
    wlParcs_Art.addAll(DbTools.lParcs_Art);

//    print(" BBB Gen_Articles >> Call getVerifLink");
    listResult_Article_Link_Verif_Fin = await getVerifLink();

    for (int i = 0; i < listResult_Article_Link_Verif_Deb.length; i++) {
      Result_Article_Link_Verif wLinkDeb = listResult_Article_Link_Verif_Deb[i];
      for (int i = 0; i < listResult_Article_Link_Verif_Fin.length; i++) {
        Result_Article_Link_Verif wLink = listResult_Article_Link_Verif_Fin[i];
        if (wLinkDeb.ChildID.compareTo(wLink.ChildID) == 0) {
          listResult_Article_Link_Verif_Fin[i].Livr = wLinkDeb.Livr;
          listResult_Article_Link_Verif_Fin[i].Fact = wLinkDeb.Fact;
        }
      }
    }

    await DbTools.deleteParc_Art_ParcsArt_ParcsId(DbTools.gParc_Ent.ParcsId!);

    print("<≈><≈><≈><≈><≈><≈><≈><≈><≈>  Gen_Articles() ART getParcs_ArtAll ${listResult_Article_Link_Verif_Fin.length}");
    print("<≈><≈><≈><≈><≈><≈><≈><≈><≈> MS > insertParc_Art ${DbTools.gParc_Art_MS.toString()}");
    await AddArt(listResult_Article_Link_Verif_Fin);

    // AJOUT MS
    if (DbTools.gParc_Art_MS.ParcsArtId != -99)
    {
      print(" MS > insertParc_Art ${DbTools.gParc_Art_MS.toString()}");
      await DbTools.insertParc_Art(DbTools.gParc_Art_MS);
      print(" MS < insertParc_Art ");
      DbTools.gParc_Art_MS.ParcsArtId = -99;
    }

    DbTools.lParcs_Art = await DbTools.getParcs_Art_AllType(DbTools.gParc_Ent.ParcsId!);
    for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
      Parc_Art element = DbTools.lParcs_Art[i];
    }

    listResult_Article_Link_Verif_Deb = listResult_Article_Link_Verif_Fin;
    FBroadcast.instance().broadcast("Gen_Articles");
  }
}
