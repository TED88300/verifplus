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

    List<Parc_Art> zwlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    List<Parc_Art> zlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    zlparcsArt.addAll(zwlparcsArt);

    print("InitArt zlParcs_Art  ${zlparcsArt.length}");

    for (int i = 0; i < zlparcsArt.length; i++) {
      Parc_Art element = zlparcsArt[i];
      print("zlParcs_Art ART ${element.ParcsArtId} ${element.ParcsArt_Type} ${element.ParcsArt_Id} ${element.ParcsArt_Lib}");
    }

//    print("••••• ${Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.length }");
    if (Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.isEmpty) {
      //    print("••••• Call getVerifLink C ");
      Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb = await Client_Groupe_Parc_Tools.getVerifLink();
    }

    List<Parc_Art> zzwlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    print("InitArt zzwlParcs_Art AAA  ${zzwlparcsArt.length}");
    List<Parc_Art> zzlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    print("InitArt zlParcs_Art AAA ${zzlparcsArt.length}");

    ArttoDeb();

    zzwlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    print("InitArt zzwlParcs_Art BBB  ${zzwlparcsArt.length}");
    zzlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    print("InitArt zlParcs_Art BBB ${zzlparcsArt.length}");

    for (int i = 0; i < Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.length; i++) {
      Result_Article_Link_Verif wLink = Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb[i];
      //  print("πππππππππππππππππππππ InitArt ART listResult_Article_Link_Verif_Deb ${wLink.Desc()}");
    }

    zzwlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    print("InitArt zzwlParcs_Art CCC  ${zzwlparcsArt.length}");
    zzlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    print("InitArt zlParcs_Art CCC ${zzlparcsArt.length}");

    print("<≈><≈><≈><≈><≈><≈><≈><≈><≈>  InitArt ART getParcs_ArtAll ${listResult_Article_Link_Verif_Deb.length}");
    await AddArt(listResult_Article_Link_Verif_Deb);

    zzwlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    print("InitArt zzwlParcs_Art DDD  ${zzwlparcsArt.length}");
    zzlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    print("InitArt zlParcs_Art DDD ${zzlparcsArt.length}");
  }

  static void AddCumul_Result_Article_Link_Verif(String ParentID, String TypeChildID, String ChildID, double Qte, String Fact, String Livr, bool isOU) {
    bool wTrv = false;
    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif.length; i++) {
      Result_Article_Link_Verif wresultArticleLinkVerif = Srv_DbTools.ListResult_Article_Link_Verif[i];
      if (wresultArticleLinkVerif.ParentID.compareTo(ParentID) == 0 && wresultArticleLinkVerif.ChildID.compareTo(ChildID) == 0 && wresultArticleLinkVerif.TypeChildID.compareTo(TypeChildID) == 0) {
        wTrv = true;
        wresultArticleLinkVerif.Qte += Qte;
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
      Result_Article_Link_Verif wresultArticleLinkVerifProp = Srv_DbTools.ListResult_Article_Link_Verif_PROP[i];
      if (wresultArticleLinkVerifProp.ParentID.compareTo(ParentID) == 0 && wresultArticleLinkVerifProp.ChildID.compareTo(ChildID) == 0 && wresultArticleLinkVerifProp.TypeChildID.compareTo(TypeChildID) == 0) {
        wTrv = true;
        wresultArticleLinkVerifProp.Qte += Qte;
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
      Result_Article_Link_Verif wresultArticleLinkVerifProp = Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte[i];
      if (wresultArticleLinkVerifProp.ParentID.compareTo(ParentID) == 0 && wresultArticleLinkVerifProp.ChildID.compareTo(ChildID) == 0 && wresultArticleLinkVerifProp.TypeChildID.compareTo(TypeChildID) == 0) {
        wTrv = true;
        wresultArticleLinkVerifProp.Qte += Qte;
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
      Result_Article_Link_Verif wresultArticleLinkVerifProp = Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service[i];
      if (wresultArticleLinkVerifProp.ParentID.compareTo(ParentID) == 0 && wresultArticleLinkVerifProp.ChildID.compareTo(ChildID) == 0 && wresultArticleLinkVerifProp.TypeChildID.compareTo(TypeChildID) == 0) {
        wTrv = true;
        wresultArticleLinkVerifProp.Qte += Qte;
        // print("•••••••••••••••••••••••••••••••••• wResult_Article_Link_Verif_PROP UPD ${ParentID}  ${ChildID}  ${TypeChildID} ${wResult_Article_Link_Verif_PROP.Qte} ${Qte} ");
      }
    }

    if (!wTrv) {
      Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service.add(Result_Article_Link_Verif(ParentID, TypeChildID, ChildID, Qte, Fact, Livr, false));
    }
  }

  static Future<List<Result_Article_Link_Verif>> getVerifLink() async {
    bool wDbg = true;


    if (wDbg) print(" getVerifLink ");

    if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink $isRef  DbTools.gParc_Ent.Parcs_UUID_Parent ${DbTools.gParc_Ent.Parcs_UUID_Parent}");
    List<Result_Article_Link_Verif> wVerifLink = [];
//    if (!isRef) return wVerifLink;

    if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> getVerifLink REF_Lib ${Srv_DbTools.REF_Lib}");

    // ==
    //    ==> Création tableau des Verif
    // ==

    String wRef = wRefBase;
    if (wDbg) print("πππππ getVerifLink wRefBase $wRef");
    if (wDbg) print("πππππ DbTools.gParc_Ent.Parcs_UUID_Parent ${DbTools.gParc_Ent.Parcs_UUID_Parent}");
    if (DbTools.gParc_Ent.Parcs_UUID_Parent!.isNotEmpty) {
      wRef = wRefInst;
      print(" MS > insertParc_Art ${DbTools.gParc_Art_MS.toString()}");
      if (wDbg) print("πππππ getVerifLink wRefInst $wRefInst");
    } else {
      for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
        Parc_Desc wparcDesc = DbTools.glfParcs_Desc[i];
        if (!wparcDesc.ParcsDesc_Lib!.contains("---")) {
          if (wparcDesc.ParcsDesc_Type!.compareTo("RES") == 0) {
            wRef = wRefRES;
            if (wDbg) print("πππππ getVerifLink wRefRES $wRefRES");
          }
        }
      }
    }
    if (wDbg) print("πππππ getVerifLink wRef $wRef");

    List<String> wVerif = [];
    for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
      Parc_Desc wparcDesc = DbTools.glfParcs_Desc[i];
      if (!wparcDesc.ParcsDesc_Lib!.contains("---")) {
        if (wDbg) print("> wParc_Desc.ParcsDesc_Type ${wparcDesc.ParcsDesc_Type}");

        if (wRef.contains(wparcDesc.ParcsDesc_Type!)) {
          for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
            Param_Saisie wparamSaisie = Srv_DbTools.ListParam_Verif_Base[i];
            if (wDbg) print("> wParam_Saisie.Param_Saisie_ID ${wparamSaisie.Param_Saisie_ID}");
            if (wparcDesc.ParcsDesc_Type!.compareTo(wparamSaisie.Param_Saisie_ID) == 0) {
              {
                wVerif.add(wparcDesc.ParcsDesc_Type!);
              }
            }
          }
        }
      }
    }


    String sVerif = "";
    for (var verifDeb in wVerif) {
      if (sVerif.isNotEmpty) sVerif += ",";
      sVerif += "'$verifDeb'";
    }

//    if (DbTools.gParc_Ent.Parcs_UUID_Parent!.isNotEmpty) sVerif = "'Inst'";

    if (wDbg)     print(" getVerifLink wRef $wRef  sVerif $sVerif");

    if (wDbg) print(" ERASE ");
    Srv_DbTools.ListResult_Article_Link_Verif.clear();
    Srv_DbTools.ListResult_Article_Link_Verif_PROP.clear();
    Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte.clear();
    Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service.clear();

    if (DbTools.gParc_Art_MS.ParcsArtId != null) {
      if (DbTools.gParc_Art_MS.ParcsArtId != -99) {
        return wVerifLink;
      }
    }




    if (Srv_DbTools.GAM_Lib.compareTo("---") == 0)

    if (wDbg) {
      print(" PIECE ACTION ");
    }
    DbTools.glfNF074_Pieces_Actions_In = await DbTools.getNF074_Pieces_Actions_In(sVerif);
    for (int i = 0; i < DbTools.glfNF074_Pieces_Actions_In.length; i++) {
      NF074_Pieces_Actions wnf074PiecesActionsIn = DbTools.glfNF074_Pieces_Actions_In[i];
      if (wDbg) print(">>>>>>>>>>> Pieces_Actions ADD  ${wnf074PiecesActionsIn.NF074_Pieces_Actions_CodeArticlePD1}  ${wnf074PiecesActionsIn.NF074_Pieces_Actions_DescriptionPD1}  ${wnf074PiecesActionsIn.NF074_Pieces_Actions_QtePD1}");
      Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "V", wnf074PiecesActionsIn.NF074_Pieces_Actions_CodeArticlePD1, wnf074PiecesActionsIn.NF074_Pieces_Actions_QtePD1 + 0.0, "Fact.", "Livré", false));
    }

    // PIECE DET
    bool isPieceDet = await DbTools.getNF074_Pieces_Det_Is_Def();

    if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Is_Piece_Det $isPieceDet ${Srv_DbTools.REF_Lib}");

    if (isPieceDet) {
      if (wDbg) print(" PIECE DET ");

      DbTools.glfNF074_Pieces_Det_In = await DbTools.getNF074_Pieces_Det_In(sVerif);

      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_In.length; i++) {
        NF074_Pieces_Det wnf074PiecesDetIn = DbTools.glfNF074_Pieces_Det_In[i];
      }

      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_In.length; i++) {
        NF074_Pieces_Det wnf074PiecesDetIn = DbTools.glfNF074_Pieces_Det_In[i];
//        print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det P  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_DescriptionPD1}");
        double MaxQte = 1.0;
        if (wnf074PiecesDetIn.NF074_Pieces_Det_VerifAnn == 2) MaxQte = 2;
        bool isOU = false;

        //          SELECT * FROM `NF074_Pieces_Det_Inc` where NF074_Pieces_Det_Inc_Description_PD1 like "%Gr-Adef%";
// Cartouche Ext. CO2 (Gr-Adef) - Fab Gen

        if (wnf074PiecesDetIn.NF074_Pieces_Det_DescriptionPD1.contains("“OU“")) isOU = true;
        AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", wnf074PiecesDetIn.NF074_Pieces_Det_CodeArticlePD1, MaxQte, "Fact.", "Livré", isOU);

        if (wnf074PiecesDetIn.NF074_Pieces_Det_CodeArticlePD2.isNotEmpty) {
          AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", wnf074PiecesDetIn.NF074_Pieces_Det_CodeArticlePD2, wnf074PiecesDetIn.NF074_Pieces_Det_QtePD2.toDouble(), "Fact.", "Livré", false);
        }

        if (wnf074PiecesDetIn.NF074_Pieces_Det_CodeArticlePD3.isNotEmpty) {
          AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", wnf074PiecesDetIn.NF074_Pieces_Det_CodeArticlePD3, wnf074PiecesDetIn.NF074_Pieces_Det_QtePD3.toDouble(), "Fact.", "Livré", false);
        }
      }

      if (wDbg) print("\n\n");

      if (!sVerif.contains("RES")) {
        DbTools.glfNF074_Pieces_Det_Prop = await DbTools.getNF074_Pieces_Det_PROP();
        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Prop.length; i++) {
          NF074_Pieces_Det wnf074PiecesDetProp = DbTools.glfNF074_Pieces_Det_Prop[i];

          double MaxQte = 1.0;
          if (wnf074PiecesDetProp.NF074_Pieces_Det_VerifAnn == 2) MaxQte = 2;

          //  print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Prop P ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_DescriptionPD1}  1");
          AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "P", wnf074PiecesDetProp.NF074_Pieces_Det_CodeArticlePD1, MaxQte, "Fact.", "Livré");

          if (wnf074PiecesDetProp.NF074_Pieces_Det_CodeArticlePD2.isNotEmpty) {
            //  print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Prop Mo ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_DescriptionPD1}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "Mo", wnf074PiecesDetProp.NF074_Pieces_Det_CodeArticlePD2, wnf074PiecesDetProp.NF074_Pieces_Det_QtePD2.toDouble(), "Fact.", "Livré");
          }
          if (wnf074PiecesDetProp.NF074_Pieces_Det_CodeArticlePD3.isNotEmpty) {
            //print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Prop Dn ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_CodeArticlePD1}  ${wNF074_Pieces_Det_Prop.NF074_Pieces_Det_DescriptionPD1}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "Dn", wnf074PiecesDetProp.NF074_Pieces_Det_CodeArticlePD3, wnf074PiecesDetProp.NF074_Pieces_Det_QtePD3.toDouble(), "Fact.", "Livré");
          }
        }

        if (wDbg) print("\n\n");
      }
    } else {
      if (wDbg) print(" PIECE DET INCONNU ");

      DbTools.glfNF074_Pieces_Det_Inc_In = await DbTools.getNF074_Pieces_Det_Inc_In(sVerif);
      for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_In.length; i++) {
        NF074_Pieces_Det_Inc wnf074PiecesDetInc = DbTools.glfNF074_Pieces_Det_Inc_In[i];
        if (wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD1.isNotEmpty) {
          if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc P ${wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD1}  ${wnf074PiecesDetInc.NF074_Pieces_Det_Inc_DescriptionPD1}  1");

          bool isGrAde = false;
          if (wnf074PiecesDetInc.NF074_Pieces_Det_Inc_DescriptionPD1 == "Cartouche Ext. CO2 (Gr-Adef) - Fab Gen") isGrAde = true;
          print(" isGrAde  $isGrAde");

          if (!isGrAde) {
            AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD1, wnf074PiecesDetInc.NF074_Pieces_Det_Inc_QtePD1.toDouble(), "Fact.", "Livré", false);
          } else {
            List<NF074_Pieces_Det_Inc> g001Nf074PiecesDetInc = [];

            g001Nf074PiecesDetInc = await DbTools.getNF074_Pieces_Det_Inc_G110();

            print(" G001_NF074_Pieces_Det_Inc ");
            print(" G001_NF074_Pieces_Det_Inc ${g001Nf074PiecesDetInc.length} ");
            print(" G001_NF074_Pieces_Det_Inc ${Srv_DbTools.REF_Lib} ");

            for (int i = 0; i < g001Nf074PiecesDetInc.length; i++) {
              NF074_Pieces_Det_Inc gnf074PiecesDetInc = g001Nf074PiecesDetInc[i];
              AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "P", gnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD1, gnf074PiecesDetInc.NF074_Pieces_Det_Inc_QtePD1.toDouble(), "Fact.", "Livré", true);
            }
          }
        }
        if (wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD2.isNotEmpty) {
          // if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc Mo ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD2}  1");
          AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD2, wnf074PiecesDetInc.NF074_Pieces_Det_Inc_QtePD2.toDouble(), "Fact.", "Livré", false);
        }
        if (wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD3.isNotEmpty) {
          // if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc Dn ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD3}  1");
          AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD3, wnf074PiecesDetInc.NF074_Pieces_Det_Inc_QtePD3.toDouble(), "Fact.", "Livré", false);
        }
      }

      if (!sVerif.contains("RES")) {
        DbTools.glfNF074_Pieces_Det_Inc_Prop = await DbTools.getNF074_Pieces_Det_Inc_Prop();
        for (int i = 0; i < DbTools.glfNF074_Pieces_Det_Inc_Prop.length; i++) {
          NF074_Pieces_Det_Inc wnf074PiecesDetInc = DbTools.glfNF074_Pieces_Det_Inc_Prop[i];
          if (wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD1.isNotEmpty) {
            if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc PROP P ${wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD1}                    ${wnf074PiecesDetInc.NF074_Pieces_Det_Inc_DescriptionPD1}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "P", wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD1, wnf074PiecesDetInc.NF074_Pieces_Det_Inc_QtePD1.toDouble(), "Fact.", "Livré");
          }

          if (wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD2.isNotEmpty) {
            // if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc PROP Mo ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD2}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD2}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "Mo", wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD2, wnf074PiecesDetInc.NF074_Pieces_Det_Inc_QtePD2.toDouble(), "Fact.", "Livré");
          }

          if (wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD3.isNotEmpty) {
            // if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>>> Pieces_Det_Inc PROP Dn ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_CodeArticlePD3}  ${wNF074_Pieces_Det_In.NF074_Pieces_Det_Inc_DescriptionPD3}  1");
            AddCumul_Result_Article_Link_Verif_PROP(Srv_DbTools.REF_Lib, "Dn", wnf074PiecesDetInc.NF074_Pieces_Det_Inc_CodeArticlePD3, wnf074PiecesDetInc.NF074_Pieces_Det_Inc_QtePD3.toDouble(), "Fact.", "Livré");
          }
        }
      }
    }

    if (wDbg) print(" MIXTE PRODUIT ");

    DbTools.glfNF074_Mixte_Produit_In = await DbTools.getNF074_Mixte_Produit_In(sVerif);
    for (int i = 0; i < DbTools.glfNF074_Mixte_Produit_In.length; i++) {
      NF074_Mixte_Produit wnf074MixteProduit = DbTools.glfNF074_Mixte_Produit_In[i];
      if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Mixte_Produit S ${wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD1}  ${wnf074MixteProduit.NF074_Mixte_Produit_DescriptionPD1}  1");
      AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "M", wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD1, wnf074MixteProduit.NF074_Mixte_Produit_QtePD1.toDouble(), "Fact.", "Livré", false);

      if (wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD2.isNotEmpty) {
        Srv_DbTools.ListResult_Article_Link_Verif.add(Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD2, wnf074MixteProduit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré", false));
        AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Mo", wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD2, wnf074MixteProduit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré", false);
      }
      if (wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD3.isNotEmpty) {
        AddCumul_Result_Article_Link_Verif(Srv_DbTools.REF_Lib, "Dn", wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD3, wnf074MixteProduit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré", false);
      }
    }

    if (wDbg) print("\n\n");

    if (!sVerif.contains("RES")) {
      DbTools.glfNF074_Mixte_Produit_In = await DbTools.getNF074_Mixte_Produit_In_Prop(sVerif);
      for (int i = 0; i < DbTools.glfNF074_Mixte_Produit_In.length; i++) {
        NF074_Mixte_Produit wnf074MixteProduit = DbTools.glfNF074_Mixte_Produit_In[i];
        if (wDbg) print(">>>>>>>>>>>>>>>>>>>>>>>>>> Mixte_Produit PROP ${wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD1}                    ${wnf074MixteProduit.NF074_Mixte_Produit_DescriptionPD1}  1");
        AddCumul_Result_Article_Link_Verif_PROP_Mixte(Srv_DbTools.REF_Lib, "M", wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD1, wnf074MixteProduit.NF074_Mixte_Produit_QtePD1.toDouble(), "Fact.", "Livré");

        if (wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD2.isNotEmpty) {
          AddCumul_Result_Article_Link_Verif_PROP_Mixte(Srv_DbTools.REF_Lib, "Mo", wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD2, wnf074MixteProduit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré");
        }
        if (wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD3.isNotEmpty) {
          AddCumul_Result_Article_Link_Verif_PROP_Mixte(Srv_DbTools.REF_Lib, "Dn", wnf074MixteProduit.NF074_Mixte_Produit_CodeArticlePD3, wnf074MixteProduit.NF074_Mixte_Produit_QtePD2.toDouble(), "Fact.", "Livré");
        }
      }
      if (wDbg) print("\n\n");
    }


/*
    if (DbTools.gParc_Ent.Parcs_UUID_Parent!.isNotEmpty)
      {
        if (wDbg) print("πππππ getVerifLink DbTools.gParc_Ent.ParcsId ${DbTools.gParc_Ent.ParcsId}");
        DbTools.lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "MS");
        print(" DbTools.lParcs_Art  B ${DbTools.lParcs_Art.length}");
        if (DbTools.lParcs_Art.length > 0) {
          Parc_Art wParc_Art = DbTools.lParcs_Art[0];
          print(" wParc_Art  B ${wParc_Art.toMap()}");
          if (wParc_Art.ParcsArt_Fact == "Devis")
          {
            print("  ListResult_Article_Link_Verif len ${Srv_DbTools.ListResult_Article_Link_Verif.length}");
            if (Srv_DbTools.ListResult_Article_Link_Verif.length > 0) wVerifLink.addAll(Srv_DbTools.ListResult_Article_Link_Verif);
            Srv_DbTools.ListResult_Article_Link_Verif.clear();
            Srv_DbTools.ListResult_Article_Link_Verif_PROP.clear();
            Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte.clear();
            Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service.clear();

          }

        }
      }
*/

/*
    for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif[i];
      print("❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖  wResult_Article_Link_Verif ${wResult_Article_Link_Verif.Desc()}");
    }
*/


    if (Srv_DbTools.ListResult_Article_Link_Verif.isNotEmpty) wVerifLink.addAll(Srv_DbTools.ListResult_Article_Link_Verif);


  /*  for (int i = 0; i < wVerifLink.length; i++) {
      Result_Article_Link_Verif wResult_Article_Link_Verif = wVerifLink[i];
      print("❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖  wVerifLink ${wResult_Article_Link_Verif.Desc()}");
    }*/



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
      var wresultArticleLinkVerif = listResult_Article_Mo[i];

      Parc_Art wparcArt = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
      wparcArt.ParcsArt_Id = wresultArticleLinkVerif.ChildID;
      wparcArt.ParcsArt_Type = "Mo";
      wparcArt.ParcsArt_Lib = "Mo";

      var warticleEbp = Srv_DbTools.ListArticle_Ebp.where((element) => element.Article_codeArticle.compareTo(wresultArticleLinkVerif.ChildID) == 0);
      if (warticleEbp.isNotEmpty) wparcArt.ParcsArt_Lib = warticleEbp.first.Article_descriptionCommercialeEnClair;

      wparcArt.ParcsArt_Qte = wresultArticleLinkVerif.Qte.toInt();
      await DbTools.insertParc_Art(wparcArt);
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
      var wresultArticleLinkVerif = listResult_Article_Dn[i];

      Parc_Art wparcArt = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
      wparcArt.ParcsArt_Id = wresultArticleLinkVerif.ChildID;
      wparcArt.ParcsArt_Type = "Dn";
      wparcArt.ParcsArt_Lib = "Dn";

      var warticleEbp = Srv_DbTools.ListArticle_Ebp.where((element) => element.Article_codeArticle.compareTo(wresultArticleLinkVerif.ChildID) == 0);
      if (warticleEbp.isNotEmpty) wparcArt.ParcsArt_Lib = warticleEbp.first.Article_descriptionCommercialeEnClair;

      wparcArt.ParcsArt_Qte = wresultArticleLinkVerif.Qte.toInt();
      await DbTools.insertParc_Art(wparcArt);
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
        Article_Ebp warticleEbp = Srv_DbTools.IMPORT_Article_Ebp(verifDeb.ChildID);
        Parc_Art wparcArt = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
        wparcArt.ParcsArt_Id = verifDeb.ChildID;
        wparcArt.ParcsArt_Type = verifDeb.TypeChildID;
        wparcArt.ParcsArt_lnk = "L";
        wparcArt.ParcsArt_Lib = verifDeb.isOU ? ">>> ${warticleEbp.Article_descriptionCommercialeEnClair}" : warticleEbp.Article_descriptionCommercialeEnClair;
        wparcArt.ParcsArt_Qte = verifDeb.Qte.toInt();
        wparcArt.ParcsArt_Livr = verifDeb.Livr;
        wparcArt.ParcsArt_Fact = verifDeb.Fact;
//        print(">>>>>>>>>>> insertParc_Art ${wParc_Art.toString()}");
        await DbTools.insertParc_Art(wparcArt);
        wlParcs_Art.add(wparcArt);
        if (verifDeb.isOU) {
          DbTools.gIsOUlParcs_Art.add(wparcArt);
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

    List<Parc_Art> wlparcsArt = [];
    wlparcsArt.addAll(DbTools.lParcs_Art);

//    print(" BBB Gen_Articles >> Call getVerifLink");
    listResult_Article_Link_Verif_Fin = await getVerifLink();

    print("<≈><≈><≈><≈><≈><≈><≈><≈><≈>  Gen_Articles()  listResult_Article_Link_Verif_Deb ${listResult_Article_Link_Verif_Deb.length}");
    print("<≈><≈><≈><≈><≈><≈><≈><≈><≈>  Gen_Articles()  listResult_Article_Link_Verif_Fin ${listResult_Article_Link_Verif_Fin.length}");


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

    print("<≈><≈><≈><≈><≈><≈><≈><≈><≈>  Gen_Articles()  listResult_Article_Link_Verif_Fin ${listResult_Article_Link_Verif_Fin.length}");

    await AddArt(listResult_Article_Link_Verif_Fin);

    // AJOUT MS

    print("<≈><≈><≈><≈><≈><≈><≈><≈><≈>  Gen_Articles() ART DbTools.gParc_Art_MS ${DbTools.gParc_Art_MS}");
    if (DbTools.gParc_Art_MS.ParcsArtId != null) {
      if (DbTools.gParc_Art_MS.ParcsArtId != -99) {
        print(" MS > insertParc_Art ${DbTools.gParc_Art_MS.toString()}");
        await DbTools.insertParc_Art(DbTools.gParc_Art_MS);
        print(" MS < insertParc_Art ");
        DbTools.gParc_Art_MS.ParcsArtId = -99;
      }
    }

    DbTools.lParcs_Art = await DbTools.getParcs_Art_AllType(DbTools.gParc_Ent.ParcsId!);
    for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
      Parc_Art element = DbTools.lParcs_Art[i];
    }

    listResult_Article_Link_Verif_Deb = listResult_Article_Link_Verif_Fin;
    FBroadcast.instance().broadcast("Gen_Articles");
  }
}
