import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Widget/Client/Client_Dialog.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Audit.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Entete_Dialog.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Entete_DialogNo.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Equip.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Piece.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Serv.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Mixte.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Synth.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Verif.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Tools.dart';
import 'package:verifplus/Widget/Widget_Tools/CounterScreen.dart';
import 'package:verifplus/Widget/Widget_Tools/bottom_navigation_bar2.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gDialogs.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

bool Client_Groupe_Parc_Inter_Entete_affAll = true;

class Client_Groupe_Parc_Inter_Entete extends StatefulWidget {
  const Client_Groupe_Parc_Inter_Entete({super.key});

  @override
  Client_Site_ParcState createState() => Client_Site_ParcState();
}

class Client_Site_ParcState extends State<Client_Groupe_Parc_Inter_Entete> with SingleTickerProviderStateMixin {
//  late TabController _tabController;

  double textSize = 14.0;

  int SelCol = -1;
  int SelID = -1;
  bool onCellTap = false;

  bool islock = true;



  String subTitle = "";
  List<String> subTitleArray = [
    "",
    "Audit",
    "Vérification",
    "Pièces détachées associées",
    "Signalétique & Services Associés",
    "Services",
    "Synthèse de maintance",
  ];

  List<Widget> widgets = [];
  final pageController = PageController(keepPage: false, initialPage: DbTools.gCurrentIndex2);

  bool isImage = false;
  List<Widget> imgList = [];

  Future Reload() async {
    print("");
    print(" ENTETE Reload ******************");
    print("");

    await AffDesc();
    print(" Call InitArt() ******************");
    await Client_Groupe_Parc_Tools.InitArt();

    DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, 0);
    if (DbTools.glfParc_Imgs.isNotEmpty) {
      imgList.clear();

      for (int i = 0; i < DbTools.glfParc_Imgs.length; i++) {
        var element = DbTools.glfParc_Imgs[i];
        var bytes = base64Decode(element.Parc_Imgs_Data!);
        Widget wWidget = Container();
        if (bytes.isNotEmpty) {
          wWidget = ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.memory(
              bytes,
              fit: BoxFit.fill,
              height: 50.0,
              width: 50.0,
            ),
          );

          imgList.add(wWidget);
          isImage = true;
        }
      }
    }
    setState(() {});
  }

  @override
  void initLib() async {
    print("initLib Relaod()");
    Reload();
  }

  void onMaj() async {
    print("Parent onMaj() Relaod()");
    Reload();
  }

  @override
  void initState() {
    subTitle = subTitleArray[0];
    widgets = [
      Client_Groupe_Parc_Inter_Equip(onMaj: onMaj),
      Client_Groupe_Parc_Inter_Audit(onMaj: onMaj, x_t: "1/6"),
      Client_Groupe_Parc_Inter_Verif(onMaj: onMaj, x_t: "2/6"),
      Client_Groupe_Parc_Inter_Piece(onMaj: onMaj, x_t: "3/6"),
      Client_Groupe_Parc_Inter_Mixte(onMaj: onMaj, x_t: "4/6"),
      Client_Groupe_Parc_Inter_Serv(onMaj: onMaj, x_t: "5/6"),
      Client_Groupe_Parc_Inter_Synth(onMaj: onMaj, x_t: "6/6"),
    ];

    initLib();
    super.initState();
  }

  String DescAff = "";
  String DescAff2 = "";
  String DescAff3 = "";

  String StrTimer = "";

  Future AffDesc() async {


    String DescAffnewParamBig = "";
    Srv_DbTools.getParam_ParamMemDet("Param_Div", "${Srv_DbTools.gIntervention.Intervention_Parcs_Type}_Desc_Big");
    if (Srv_DbTools.ListParam_Param.isNotEmpty) DescAffnewParamBig = Srv_DbTools.ListParam_Param[0].Param_Param_Text;


    DbTools.glfParcs_Desc = await DbTools.getParcs_Desc(DbTools.gParc_Ent.ParcsId!);

    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Saisie[i];
      await DbTools.getParcs_Desc_Id_Type_Add(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);
    }

    for (var wParcs_Desc in DbTools.glfParcs_Desc) {
      switch (wParcs_Desc.ParcsDesc_Type) {
        case "DESC":
        case "DESC2":
          Srv_DbTools.DESC_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "FAB":
        case "FAB2":
          Srv_DbTools.FAB_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "TYPE":
        case "TYPE2":
          Srv_DbTools.TYPE_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;

        case "SIT":
          Srv_DbTools.SIT_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;

        case "ARM":
          Srv_DbTools.ARM_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "INOX":
          Srv_DbTools.INOX_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;

        case "DIAM":
          Srv_DbTools.DIAM_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "LONG":
          Srv_DbTools.LONG_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "DIF":
          Srv_DbTools.DIF_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "DISP":
          Srv_DbTools.DISP_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "PREM":
          {
            Srv_DbTools.PREM_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
            break;
          }
        case "GAM":
          Srv_DbTools.GAM_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;

        case "CLF":
          Srv_DbTools.CLF_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "MOB":
          Srv_DbTools.MOB_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "PDT":
          Srv_DbTools.PDT_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          Srv_DbTools.getUser_Hab_PDT(Srv_DbTools.PDT_Lib);
          break;
        case "POIDS":
          Srv_DbTools.POIDS_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          break;
        case "PRS":
          Srv_DbTools.PRS_Lib = wParcs_Desc.ParcsDesc_Lib.toString();
          Srv_DbTools.getParam_Saisie_ParamMem_REF();
          Srv_DbTools.gArticle_EbpEnt = Srv_DbTools.IMPORT_Article_Ebp(Srv_DbTools.REF_Lib);
          DescAff3 = "${Srv_DbTools.REF_Lib} ${Srv_DbTools.gArticle_EbpEnt.Article_descriptionCommercialeEnClair}";
          break;
      }
    }



    print("⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ${Srv_DbTools.DESC_Lib}  ${Srv_DbTools.PDT_Lib}");

    List<Param_Saisie> listparamSaisieTmp = [];
    listparamSaisieTmp.addAll(Srv_DbTools.ListParam_Saisie);
    listparamSaisieTmp.addAll(Srv_DbTools.ListParam_Saisie_Base);

    DescAff = "N°${DbTools.gParc_Ent.Parcs_order} ${DbTools.gParc_Ent.Parcs_NoSpec!.isEmpty ? '': DbTools.gParc_Ent.Parcs_NoSpec}\n";

    DbTools.gParc_Ent.Parcs_Intervention_Timer ??= 0;

    print("<<<<<<<<<<<<<<<<<<< StrTimer A ${DbTools.gParc_Ent.Parcs_Intervention_Timer}");
    StrTimer = gObj.printDuration(Duration(seconds: DbTools.gParc_Ent.Parcs_Intervention_Timer!));
    print("<<<<<<<<<<<<<<<<<<< StrTimer B $StrTimer");

//    PDT POIDS PRS MOB ANN FAB

    listparamSaisieTmp.sort(Srv_DbTools.affL1SortComparison);
    listparamSaisieTmp.forEach((element) async {

      if (element.Param_Saisie_Affichage_L1) {
        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
          DbTools.gDateMS = DbTools.gParc_Ent.Parcs_ANN_Label!;
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ANN_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("AFAB") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FAB_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_NIV_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ZNE_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_EMP_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_LOT_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_SERIE_Label!, element.Param_Saisie_ID)}";
        } else {
          // !!! Suppression Doublon
          bool trv = false;
          for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
            Parc_Desc wparcDesc = DbTools.glfParcs_Desc[i];
            if (element.Param_Saisie_ID == wparcDesc.ParcsDesc_Type) {
              if (!trv)
                {
                  DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(wparcDesc.ParcsDesc_Lib!, element.Param_Saisie_ID)}";
                  print("⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ⛔︎ ${wparcDesc.toMap()}");
                  trv = true;
                }
              else
                {
                  DbTools.deleteParc_Desc(wparcDesc.ParcsDescId!);
                }
            }
          }
        }
      }
     print(">>>>>>>>>>>>>>>>>>>>>>>> DescAff $DescAff");
    });

    ///////////
    // BIG ////
    ///////////

    DescAff = DescAffnewParamBig;
    List<String?>? parcsCols = [];
    for (int j = 0; j < listparamSaisieTmp.length; j++) {
      Param_Saisie paramSaisie = listparamSaisieTmp[j];
      if (paramSaisie.Param_Saisie_Affichage.compareTo("DESC") == 0) {
        if (paramSaisie.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, paramSaisie.Param_Saisie_ID));
        } else if (paramSaisie.Param_Saisie_ID.compareTo("ANN") == 0) {
          DbTools.gDateMS = DbTools.gParc_Ent.Parcs_ANN_Label!;
          String s = gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ANN_Label!, paramSaisie.Param_Saisie_ID);
          int pos = s.indexOf('-');
          String ws = (pos != -1) ? s.substring(pos + 1) : s;
          DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, ws);
        } else if (paramSaisie.Param_Saisie_ID.compareTo("AFAB") == 0) {
          DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FAB_Label!, paramSaisie.Param_Saisie_ID));
        } else if (paramSaisie.Param_Saisie_ID.compareTo("NIV") == 0) {
          DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_NIV_Label!, paramSaisie.Param_Saisie_ID));
        } else if (paramSaisie.Param_Saisie_ID.compareTo("ZNE") == 0) {
          DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ZNE_Label!, paramSaisie.Param_Saisie_ID));
        } else if (paramSaisie.Param_Saisie_ID.compareTo("EMP") == 0) {
          DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_EMP_Label!, paramSaisie.Param_Saisie_ID));
        } else if (paramSaisie.Param_Saisie_ID.compareTo("LOT") == 0) {
          DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_LOT_Label!, paramSaisie.Param_Saisie_ID));
        } else if (paramSaisie.Param_Saisie_ID.compareTo("SERIE") == 0) {
          DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_SERIE_Label!, paramSaisie.Param_Saisie_ID));
        } else {
          bool trv = false;
          for (int j = 0; j < DbTools.glfParcs_Desc.length; j++) {
            Parc_Desc element2 = DbTools.glfParcs_Desc[j];
            if (DbTools.gParc_Ent.ParcsId == element2.ParcsDesc_ParcsId && paramSaisie.Param_Saisie_ID == element2.ParcsDesc_Type) {
              if (paramSaisie.Param_Saisie_ID == "POIDS") {
                DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, paramSaisie.Param_Saisie_ID));
              } else {
                DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, "${element2.ParcsDesc_Lib}");
              }

              trv = true;
            }
          }
          if (!trv) DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, "");
        }
      } else if (paramSaisie.Param_Saisie_ID.compareTo("DESC2") == 0) {
        bool trv = false;
        for (int j = 0; j < DbTools.glfParcs_Desc.length; j++) {
          Parc_Desc element2 = DbTools.glfParcs_Desc[j];
          if (DbTools.gParc_Ent.ParcsId == element2.ParcsDesc_ParcsId && paramSaisie.Param_Saisie_ID == element2.ParcsDesc_Type) {
            DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, paramSaisie.Param_Saisie_ID));
            trv = true;
          }
        }
        if (!trv) DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, "");
      }

      if (paramSaisie.Param_Saisie_Affichage.compareTo("COL") == 0) {
        for (int j = 0; j < DbTools.glfParcs_Desc.length; j++) {
          Parc_Desc element2 = DbTools.glfParcs_Desc[j];
          if (DbTools.gParc_Ent.ParcsId == element2.ParcsDesc_ParcsId && paramSaisie.Param_Saisie_ID == element2.ParcsDesc_Type) {
            parcsCols.add(element2.ParcsDesc_Lib);
          }
        }
      }
    }

    if (DbTools.gParc_Ent.Parcs_NoSpec!.isNotEmpty) {
      DescAff = DescAff.replaceAll("SPEC ", "N° ${DbTools.gParc_Ent.Parcs_order} / N°Sp : ${DbTools.gParc_Ent.Parcs_NoSpec}\n");
    } else {
      DescAff = DescAff.replaceAll("SPEC ", "N° ${DbTools.gParc_Ent.Parcs_order}\n");
    }


//    DescAff = "N° ${DbTools.gParc_Ent.Parcs_order} / ${DescAff}";


    if (DescAff.compareTo(DescAffnewParamBig) == 0) DescAff = "";
    String wTmp = DescAff;
    wTmp = wTmp.replaceAll("---", "");
    wTmp = wTmp.replaceAll("/", "");
    wTmp = wTmp.replaceAll(" ", "");

    if (wTmp.isEmpty) DescAff = "";

    DbTools.gParc_Ent.Parcs_Date_DescBig = DescAff;





    DescAff2 = "";
    listparamSaisieTmp.sort(Srv_DbTools.affL2SortComparison);
    listparamSaisieTmp.forEach((element) async {
      if (element.Param_Saisie_Affichage_L2) {
        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
          DbTools.gDateMS = DbTools.gParc_Ent.Parcs_ANN_Label!;
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ANN_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("AFAB") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FAB_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_NIV_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ZNE_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_EMP_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_LOT_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_SERIE_Label!, element.Param_Saisie_ID)}";
        } else {
          DbTools.glfParcs_Desc.forEach((element2) async {
            if (element.Param_Saisie_ID == element2.ParcsDesc_Type) {
              DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}";
            }
          });
        }
      }
    });

    DbTools.gParc_Ent.Parcs_Date_DescBig = DescAff;
    DbTools.gParc_Ent.Parcs_Date_Desc2 = "${DbTools.gParc_Ent.Parcs_FAB_Label} / ${Srv_DbTools.GAM_Lib}";
    DbTools.gParc_Ent.Parcs_Date_Desc3 =  "${DbTools.gParc_Ent.Parcs_ZNE_Label} / ${DbTools.gParc_Ent.Parcs_EMP_Label} / ${DbTools.gParc_Ent.Parcs_NIV_Label}";
    await DbTools.updateParc_Ent(DbTools.gParc_Ent);

    DbTools.DescAff = DbTools.gParc_Ent.Parcs_Date_DescBig!;
    DbTools.DescAff2 = DbTools.gParc_Ent.Parcs_Date_Desc2!;
    DbTools.DescAff3 = DbTools.gParc_Ent.Parcs_Date_Desc3!;

    DescAff = DbTools.gParc_Ent.Parcs_Date_DescBig!;
    DescAff2 = DbTools.gParc_Ent.Parcs_Date_Desc2!;
    DescAff3 = DbTools.gParc_Ent.Parcs_Date_Desc3!;


  }

  @override
  Widget build(BuildContext context) {
    if (!Srv_DbTools.IsComplet) {
      islock = false;
      Srv_DbTools.Hab_PDT = 99;
    } else {}

    islock = false;
    Srv_DbTools.Hab_PDT = 99;


    print(" ENTETE RELOAD");

//    Widget wchildren = widgets[DbTools.gCurrentIndex2];

    String wTitre2 = "${Srv_DbTools.gIntervention.Client_Nom!.toUpperCase()} ${Srv_DbTools.gIntervention.Groupe_Nom} / ${Srv_DbTools.gIntervention.Site_Nom} / ${Srv_DbTools.gIntervention.Zone_Nom}";
    if (Srv_DbTools.gIntervention.Groupe_Nom! == Srv_DbTools.gIntervention.Site_Nom!) wTitre2 = Srv_DbTools.gIntervention.Client_Nom!.toUpperCase();

    double icoWidth = 40;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //    endDrawer: DbTools.gIsMedecinLogin! ? C_SideDrawer() : I_SideDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            await Client_Dialog.Dialogs_Client(context);
          },
          child: AutoSizeText(
            Srv_DbTools.DESC_Lib.isEmpty || Srv_DbTools.DESC_Lib == "---" ? DbTools.OrgLib : Srv_DbTools.DESC_Lib,
            style: gColors.bodyTitle1_B_G_20,
            textAlign: TextAlign.center,
          ),
        ),
        leading: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
            child: DbTools.gBoolErrorSync
                ? Image.asset(
                    "assets/images/IcoWErr.png",
                  )
                : Image.asset("assets/images/IcoW.png"),
          ),
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 40,
            icon: gColors.wBoxDecoration(context),
            onPressed: () async {
              gColors.AffUser(context);
            },
          ),
          IconButton(
            icon: Icon(
              Client_Groupe_Parc_Inter_Entete_affAll ? Icons.arrow_circle_down_rounded : Icons.arrow_circle_up_rounded,
              color: Colors.grey,
            ),
            onPressed: () async {
              await HapticFeedback.vibrate();
              setState(() {
                Client_Groupe_Parc_Inter_Entete_affAll = !Client_Groupe_Parc_Inter_Entete_affAll;
              });
            },
          ),
        ],
        backgroundColor: gColors.white,
      ),

      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: [
                    Client_Groupe_Parc_Inter_Entete_affAll ? Container() : gObj.InfoWidget(context, false),
                    Material(
                      color: Colors.white,
                      elevation: 10,
                      child: Container(
                        color: gColors.LinearGradient2,
                        height: 47,
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          SizedBox(
                            width: 60,
                            child: GestureDetector(
                              //You need to make my child interactive
                              onTap: () async {
                                islock = !islock;
                                setState(() {});
                              },
                              child: Icon(
                                islock ? Icons.lock_outline : Icons.lock_open_outlined,
                                size: 25,
                                color: gColors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              wTitre2,
                              maxLines: 1,
                              style: gColors.bodyTitle1_B_Gr,
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: (Srv_DbTools.gIntervention.Intervention_Status == "En cours") ? const CounterScreen() : Text(StrTimer),
                          ),
                        ]),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: DbTools.gParc_Ent.Parcs_QRCode!.isEmpty ? Image.asset("assets/images/QrCode.png") : Image.asset("assets/images/QrCodeok.png"),
                          onPressed: () async {
                            await gDialogs.Dialog_QrCode(context);
                            setState(() {});
                          },
                        ),


                        GestureDetector(
                          //You need to make my child interactive
                          onTap: () async {
                            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff = DescAff;
                            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff2 = DescAff2;
                            await Client_Groupe_Parc_Inter_Entete_DialogNo.Dialogs_Entete(context, onMaj);
                            await AffDesc();
                            setState(() {});
                          },
                          child:
//                          Expanded(child:
                              Container(
//                            width: 600,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              children: [
                                Container(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    DescAff,
                                    style: gColors.bodyTitle1_B_G_20,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 500,
                                  child: Text(
                                    DescAff2,
                                    style: gColors.bodyTitle1_N_Gr,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 500,
                                  child: Text(
                                    DescAff3,
                                    style: gColors.bodyTitle1_N_Gr,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //   ),
                        IconButton(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: isImage ? imgList[0] : Image.asset("assets/images/Icon_Photo.png"),
                          onPressed: () async {
                            print("on Photo");
                            DbTools.gParc_Img_Type = 0;
                            DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, 0);
                            await gDialogs.Dialog_Photo(context, "Photo Organe", DescAff, "");
                            Reload();
                          },
                        ),
                      ],
                    ),
                    buildEnt_Drn_Visite(context),
                    Expanded(
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  foregroundDecoration: Srv_DbTools.Hab_PDT > 0
                                      ? null
                                      : const BoxDecoration(
                                          color: Colors.grey,
                                          backgroundBlendMode: BlendMode.saturation,
                                        ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: PageView(
                                          controller: pageController,
                                          onPageChanged: onBottomIconPressed,
                                          children: widgets,
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        color: gColors.greyDark,
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Srv_DbTools.Hab_PDT > 0
                                  ? islock
                                      ? Expanded(
                                          child: Container(
                                          child: Image.asset("assets/images/lock.png"),
                                        ))
                                      : Container()
                                  : Expanded(
                                      child: Container(
                                        color: Colors.transparent,
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomBottomNavigationBar2(
                onIconPresedCallback: onBottomIconPressed,
              ),
            )
          ],
        ),
      ),
    );
  }

  void onBottomIconPressed(int index) async {
    if (DbTools.gCurrentIndex2 != index) {
      DbTools.gCurrentIndex2 = index;
//      DbTools.gCurrentIndex3 = index;
      pageController.jumpToPage(index);
      FBroadcast.instance().broadcast("HandleBar2");
      Reload();
    }
  }

  @override
  Widget buildEnt_Drn_Visite(BuildContext context) {
    String wDate = "";
    try {
      wDate = DateFormat('dd/MM/yy HH:mm').format(DateTime.parse(DbTools.gParc_Ent.Parcs_Date_Rev!));
    } on FormatException {}

    return Container(
      width: gColors.MediaQuerysizewidth,
//        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.fromLTRB(16, 5, 10, 8),
      color: gColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Dernière Visite périodique de l’organe : ",
            style: gColors.bodyTitle1_N_Gr,
          ),
          Text(
            wDate,
            style: gColors.bodyTitle1_N_Gr,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

}
