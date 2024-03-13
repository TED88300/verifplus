import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Art.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Ent.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Client/Client_Dialog.dart';
import 'package:verifplus/Widget/Client/Client_Interventions_Status.dart';
import 'package:verifplus/Widget/Client/Vue_Intervention.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_BC.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_BL.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Entete.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Note.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Signature.dart';
import 'package:verifplus/Widget/Widget_Tools/bottom_navigation_bar3.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Inter extends StatefulWidget {
  @override
  Client_Groupe_Parc_InterState createState() => Client_Groupe_Parc_InterState();
}

class Client_Groupe_Parc_InterState extends State<Client_Groupe_Parc_Inter> with TickerProviderStateMixin {
  late TabController _tabController;
  bool affEdtFilter = false;

  bool canClose = false;

  late AnimationController acontroller;
  bool iStrfExp = false;
  bool iStrfImp = false;

  TextEditingController ctrlNbInsert = new TextEditingController();
  int NbAdd = 1;
  final ctrlNbInsertfocusNode = FocusNode();

  TextEditingController ctrlPos = new TextEditingController();
  int iPos = 1;
  final ctrlPosfocusNode = FocusNode();
  Timer? timer;
  bool _isButtonTapped = false;

  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';

  bool isChecked = false;
  bool affAll = true;

  String QrcValue = "";

  double vPositionVP = 0;
  double hPositionVP = 0;

  List<String> subTitleArray = [
    "Ext",
    "Ria",
  ];
  List<String> subLibArray = [];

  int LastSelID = -1;
  int LastClickID = -1;

  int SelCol = -1;
  int SelID = -1;
  bool onCellTap = false;

  String wAction = "";

  List<GrdBtn> lGrdBtn = [];
  List<GrdBtnGrp> lGrdBtnGrp = [];
  List<Param_Param> ListParam_ParamTypeOg = [];

  int countCol = 0;
  double icoWidth = 40;

  List<String?>? Parcs_ColsTitle = [];

  bool isKeyBoard = false;

  bool isBtnRel = false;
  bool isBtnDev = false;

  int countX = 0;
  int countTot = 0;
  int wTimer = 0;

  double vPosition = 0;
  double hPosition = 0;
  double dxPosition = 0;
  double dyPosition = 0;

  Future Reload() async {
    await Srv_ImportExport.getErrorSync();

    print("Client_Groupe_Parc_Inter <<<<<<<<<<<<<<<<<<<RELOAD ${DbTools.glfParcs_Ent.length} DbTools.hasConnection ${DbTools.hasConnection} >>>>>>>>>>>>>>>>>>>>>");


    print("Parc_Ent_GetOrder >>> ${DbTools.glfParcs_Ent.length}");
    await DbTools.Parc_Ent_GetOrder();
    print("Parc_Ent_GetOrder <<< ${DbTools.glfParcs_Ent.length}");
    print("Reload glfParcs_Ent order fin");


    await DbTools.getParam_Saisie_Base("Audit");
    Srv_DbTools.ListParam_Audit_Base.clear();
    Srv_DbTools.ListParam_Audit_Base.addAll(Srv_DbTools.ListParam_Saisie_Base);

    print("♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎ DbTools ListParam_Audit_Base ${Srv_DbTools.ListParam_Audit_Base.length}");

    await DbTools.getParam_Saisie_Base("Verif");
    Srv_DbTools.ListParam_Verif_Base.clear();
    Srv_DbTools.ListParam_Verif_Base.addAll(Srv_DbTools.ListParam_Saisie_Base);

    await DbTools.getParam_Saisie_Base("Interv");
    Srv_DbTools.ListParam_Interv_Base.clear();
    Srv_DbTools.ListParam_Interv_Base.addAll(Srv_DbTools.ListParam_Saisie_Base);

    await DbTools.getParam_Saisie_Base("Desc");
    DbTools.glfParcs_Ent = await DbTools.getParcs_Ent(Srv_DbTools.gIntervention.InterventionId!);
    for (int i = 0; i < DbTools.gRowSels.length; i++) {
      for (int j = 0; j < DbTools.lParcs_Ent.length; j++) {
        if (DbTools.lParcs_Ent[j].ParcsId == DbTools.gRowSels[i].Id) {
          DbTools.gRowSels[i].Ordre = DbTools.lParcs_Ent[j].Parcs_order!;
          break;
        }
      }
    }

    DbTools.glfParcs_Desc = await DbTools.getParcs_DescInter(Srv_DbTools.gIntervention.InterventionId!);
    print(" getParcs_DescInter lenght ${DbTools.glfParcs_Desc.length}");
    String DescAff = "";

    Srv_DbTools.ListParam_Saisie.sort(Srv_DbTools.affSort2Comparison);

    Parcs_ColsTitle!.clear();

    for (int j = 0; j < Srv_DbTools.ListParam_Saisie.length; j++) {
      Param_Saisie element = Srv_DbTools.ListParam_Saisie[j];
      if (element.Param_Saisie_Affichage.compareTo("COL") == 0) {
        countCol++;
        Parcs_ColsTitle!.add(element.Param_Saisie_Affichage_Titre);
      }
    }

    int index = subLibArray.indexWhere((element) => element.compareTo(DbTools.ParamTypeOg) == 0);
    DbTools.OrgLib = subLibArray[index];

    print(" getParam_Saisie subTitleArray[index] ${subTitleArray[index]}");

    await DbTools.getParam_Saisie(subTitleArray[index], "Desc");

    String DescAffnewParam = "";
    Srv_DbTools.getParam_ParamMemDet("Param_Div", "${subTitleArray[index]}_Desc");
    if (Srv_DbTools.ListParam_Param.length > 0) DescAffnewParam = Srv_DbTools.ListParam_Param[0].Param_Param_Text;

    print(">>>>>>>>>>> DescAffnewParam ${DescAffnewParam}");
    //DescAffnewParam PDT POIDS PRS MOB / ZNE EMP NIV / ANN / FAB
    List<Param_Saisie> ListParam_Saisie_Tmp = [];
    ListParam_Saisie_Tmp.addAll(Srv_DbTools.ListParam_Saisie);
    ListParam_Saisie_Tmp.addAll(Srv_DbTools.ListParam_Saisie_Base);

    print("DbTools.glfParcs_Ent.length ${DbTools.glfParcs_Ent.length}");

//    Parcs_Date_VRMC

    bool isRelEnt = false;

    countX = 0;
    countTot = 0;
    wTimer = 0;

    for (int jj = 0; jj < DbTools.glfParcs_Ent.length; jj++) {
      Parc_Ent elementEnt = DbTools.glfParcs_Ent[jj];

      countTot++;
      if (!elementEnt.Parcs_Date_Rev!.isEmpty) countX++;

      try {
        wTimer += elementEnt.Parcs_Intervention_Timer!;
      } catch (e) {
        print(e);
      }

      DescAff = DescAffnewParam;
      List<String?>? Parcs_Cols = [];

      for (int j = 0; j < ListParam_Saisie_Tmp.length; j++) {
        Param_Saisie element = ListParam_Saisie_Tmp[j];

        if (element.Param_Saisie_Affichage.compareTo("DESC") == 0) {
          if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Param_Param(elementEnt.Parcs_FREQ_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
            //print(">>>>>>>>> ANN ${elementEnt.Parcs_ANN_Id!} ---> ${elementEnt.Parcs_ANN_Label!}");
            String s = gColors.AbrevTxt_Param_Param(elementEnt.Parcs_ANN_Label!, element.Param_Saisie_ID);
            int pos = s.indexOf('-');
            String ws = (pos != -1) ? s.substring(pos + 1) : s;
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${ws}");
          } else if (element.Param_Saisie_ID.compareTo("AFAB") == 0) {
            //print(">>>>>>>>> FAB ${elementEnt.Parcs_FAB_Id!} ---> ${elementEnt.Parcs_FAB_Label!}");
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Param_Param(elementEnt.Parcs_FAB_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Param_Param(elementEnt.Parcs_NIV_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Param_Param(elementEnt.Parcs_ZNE_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Param_Param(elementEnt.Parcs_EMP_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Param_Param(elementEnt.Parcs_LOT_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Param_Param(elementEnt.Parcs_SERIE_Label!, element.Param_Saisie_ID)}");
          } else {
            bool trv = false;
//            print("ELSE element.Param_Saisie_ID ${element.Param_Saisie_ID} ${DescAff} l ${DbTools.glfParcs_Desc.length}");

            for (int j = 0; j < DbTools.glfParcs_Desc.length; j++) {
              Parc_Desc element2 = DbTools.glfParcs_Desc[j];
              if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && element.Param_Saisie_ID == element2.ParcsDesc_Type) {
                //            print("element.Param_Saisie_Affichage ${elementEnt.ParcsId} ${element.Param_Saisie_ID}");
                //          print("element.Param_Saisie_Affichage2 ${element2.ParcsDesc_ParcsId} ${element2.ParcsDesc_Type}");
                DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}");
                trv = true;
              }
            }
            ;
            if (!trv) DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "");
          }
        }

        if (element.Param_Saisie_Affichage.compareTo("COL") == 0) {
          for (int j = 0; j < DbTools.glfParcs_Desc.length; j++) {
            Parc_Desc element2 = DbTools.glfParcs_Desc[j];
            if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && element.Param_Saisie_ID == element2.ParcsDesc_Type) {
              Parcs_Cols.add(element2.ParcsDesc_Lib);
            }
          };
        }
      }
      ;

      if (DescAff.compareTo(DescAffnewParam) == 0) DescAff = "";
      String wTmp = DescAff;
      wTmp = wTmp.replaceAll("---", "");
      wTmp = wTmp.replaceAll("/", "");
      wTmp = wTmp.replaceAll(" ", "");

      if (wTmp.length == 0) DescAff = "";
      elementEnt.Parcs_Date_Desc = DescAff;
      elementEnt.Parcs_Cols = Parcs_Cols;

      String ParcsDesc_Type_DESC = "";
      String ParcsDesc_Type_PDT = "";
      Parc_Desc Parc_Desc_DESC = Parc_Desc();
      Parc_Desc Parc_Desc_PDT = Parc_Desc();

      String ParcsDesc_Type_Inst = "";
      String ParcsDesc_Type_VerifAnn = "";
      String ParcsDesc_Type_Rech = "";
      String ParcsDesc_Type_MAA = "";
      String ParcsDesc_Type_Charge = "";
      String ParcsDesc_Type_RA = "";
      String ParcsDesc_Type_RES = "";
      String ParcsDesc_Type_Ech = "";
      String ParcsDesc_Type_EtatGen = "";
      String ParcsDesc_Type_Acc = "";

      elementEnt.Parcs_VRMC = "";

      for (int jjj = 0; jjj < DbTools.glfParcs_Desc.length; jjj++) {
        Parc_Desc element2 = DbTools.glfParcs_Desc[jjj];

        if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId) {
          if (element2.ParcsDesc_Type!.compareTo("PDT") == 0) {
            ParcsDesc_Type_PDT = element2.ParcsDesc_Lib!;
            Parc_Desc_PDT = element2;
          }

          if (element2.ParcsDesc_Type!.compareTo("Inst") == 0) {
            ParcsDesc_Type_Inst = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("VerifAnn") == 0) {
            ParcsDesc_Type_VerifAnn = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("Rech") == 0) {
            ParcsDesc_Type_Rech = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("MAA") == 0) {
            ParcsDesc_Type_MAA = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("Charge") == 0) {
            ParcsDesc_Type_Charge = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("RA") == 0) {
            ParcsDesc_Type_RA = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("RES") == 0) {
            ParcsDesc_Type_RES = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("Ech") == 0) {
            ParcsDesc_Type_Ech = element2.ParcsDesc_Lib!;
          }

          if (element2.ParcsDesc_Type!.compareTo("EtatGen") == 0) {
            ParcsDesc_Type_EtatGen = element2.ParcsDesc_Lib!;
          }

          if (element2.ParcsDesc_Type!.compareTo("Acc") == 0) {
            ParcsDesc_Type_Acc = element2.ParcsDesc_Lib!;
          }
        }
      }

      DbTools.lParcs_Art = await DbTools.getParcs_Art_AllType(elementEnt.ParcsId!);
      bool isRel = false;
      bool isDevis = false;
      for (int ji = 0; ji < DbTools.lParcs_Art.length; ji++) {
        Parc_Art wParc_Art = DbTools.lParcs_Art[ji];
        if (wParc_Art.ParcsArt_Livr!.substring(0, 1).contains("R")) {
          print("wParc_Art.ParcsArt_Livr ${wParc_Art.ParcsArt_Lib} ${wParc_Art.ParcsArt_Livr}");
          isRel = true;
          break;
        }
        if (wParc_Art.ParcsArt_Fact!.contains("Dev")) {
          isDevis = true;
          break;
        }
      }

      elementEnt.Livr = isRel ? "R" : "";
      elementEnt.Devis = isDevis ? "D" : "";
      await DbTools.updateParc_Ent_Livr(elementEnt);

      if (isRel) isRelEnt = true;

      DbTools.lParcs_Art = await DbTools.getParcs_Art(elementEnt.ParcsId!, "ES");
      if (DbTools.lParcs_Art.length > 0) {
        Parc_Art parc_Art = DbTools.lParcs_Art[0];
//        print("parc_Art ${parc_Art.toString()}");
        ParcsDesc_Type_Ech = "${parc_Art.ParcsArt_Id} ${parc_Art.ParcsArt_Lib}";
      }

      if (elementEnt.Parcs_UUID_Parent!.isNotEmpty)
        elementEnt.Parcs_VRMC = "NEUF";
      else if (ParcsDesc_Type_RES.compareTo("---") != 0 && ParcsDesc_Type_RES.isNotEmpty) {
        print("ParcsDesc_Type_RES ${ParcsDesc_Type_RES}");
        elementEnt.Parcs_VRMC = "ES";
        if (ParcsDesc_Type_Ech.compareTo("---") == 0) elementEnt.Parcs_VRMC = "REFO";
      } else if (ParcsDesc_Type_RA.compareTo("---") != 0 && ParcsDesc_Type_RA.isNotEmpty)
        elementEnt.Parcs_VRMC = "RA";
      else if (ParcsDesc_Type_MAA.compareTo("---") != 0 && ParcsDesc_Type_MAA.isNotEmpty)
        elementEnt.Parcs_VRMC = "MAA";
      else if (ParcsDesc_Type_Charge.compareTo("---") != 0 && ParcsDesc_Type_Charge.isNotEmpty)
        elementEnt.Parcs_VRMC = "CHGE";
      else if (ParcsDesc_Type_Rech.compareTo("---") != 0 && ParcsDesc_Type_Rech.isNotEmpty)
        elementEnt.Parcs_VRMC = "RECH";
      else if (ParcsDesc_Type_VerifAnn.compareTo("---") != 0 && ParcsDesc_Type_VerifAnn.isNotEmpty)
        elementEnt.Parcs_VRMC = "VF";
      else if (ParcsDesc_Type_EtatGen.compareTo("Disparu") == 0)
        elementEnt.Parcs_VRMC = "DISP";
      else if (ParcsDesc_Type_Acc.compareTo("Inaccessible") == 0)
        elementEnt.Parcs_VRMC = "INAC";
      else if (ParcsDesc_Type_Inst.compareTo("---") != 0 && ParcsDesc_Type_Inst.isNotEmpty) {
        elementEnt.Parcs_VRMC = "MES";
      } else
        elementEnt.Parcs_VRMC = "---";

      elementEnt.Action = elementEnt.Parcs_VRMC;
      DbTools.updateParc_Ent_Action(elementEnt);
//      if (elementEnt.Parcs_Date_Desc!.isEmpty) elementEnt.Parcs_VRMC = "---";

      bool Parcs_MaintPrev = true;
      bool Parcs_MaintCorrect = true;
      bool Parcs_Install = true;

      if (ParcsDesc_Type_DESC.length > 0 && ParcsDesc_Type_DESC.compareTo("---") != 0) {
        Srv_DbTools.getUser_Hab_Desc(Parc_Desc_DESC.ParcsDescId!);
        if (Parcs_MaintPrev != Srv_DbTools.User_Desc_MaintPrev) Parcs_MaintPrev = Srv_DbTools.User_Desc_MaintPrev;
        if (Parcs_MaintCorrect != Srv_DbTools.User_Desc_MaintCorrect) Parcs_MaintCorrect = Srv_DbTools.User_Desc_MaintCorrect;
        if (Parcs_Install != Srv_DbTools.User_Desc_Install) Parcs_Install = Srv_DbTools.User_Desc_Install;
      }

      if (ParcsDesc_Type_PDT.length > 0 && ParcsDesc_Type_PDT.compareTo("---") != 0) {
        Srv_DbTools.getUser_Hab_PDT(Parc_Desc_PDT.ParcsDesc_Lib!);
        if (Parcs_MaintPrev != Srv_DbTools.User_Hab_MaintPrev) Parcs_MaintPrev = Srv_DbTools.User_Hab_MaintPrev;
        if (Parcs_MaintCorrect != Srv_DbTools.User_Hab_MaintCorrect) Parcs_MaintCorrect = Srv_DbTools.User_Hab_MaintCorrect;
        if (Parcs_Install != Srv_DbTools.User_Hab_Install) Parcs_Install = Srv_DbTools.User_Hab_Install;
      }

      bool Maj = false;
      if (elementEnt.Parcs_MaintPrev != Parcs_MaintPrev) {
        elementEnt.Parcs_MaintPrev = Parcs_MaintPrev;
        Maj = true;
      }
      if (elementEnt.Parcs_MaintCorrect != Parcs_MaintCorrect) {
        elementEnt.Parcs_MaintCorrect = Parcs_MaintCorrect;
        Maj = true;
      }
      if (elementEnt.Parcs_Install != Parcs_Install) {
        elementEnt.Parcs_Install = Parcs_Install;
        Maj = true;
      }

      if (elementEnt.Parcs_UUID_Parent!.isNotEmpty) {
        elementEnt.Parcs_Date_Desc = "➜ ${elementEnt.Parcs_Date_Desc}";
      }
    }

    Srv_DbTools.gIntervention.Livr = isRelEnt ? "R" : "";

    if (Srv_DbTools.gIntervention.Intervention_Status!.contains("Planifiée")) {
      if (wTimer > 0) Srv_DbTools.gIntervention.Intervention_Status = "En cours";
    }
    await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);

    print("Filter >>>>"
        "");
    await Filtre();
    print("Reload Fin");
  }

  Future Filtre() async {
    int index = subLibArray.indexWhere((element) => element.compareTo(DbTools.ParamTypeOg) == 0);

    List<Parc_Ent> wParcs_Ent = [];
    List<Parc_Ent> wParcs_Ent2 = [];
    DbTools.lParcs_Ent.clear();
    for (int i = 0; i < DbTools.glfParcs_Ent.length; i++) {
      Parc_Ent element = DbTools.glfParcs_Ent[i];
      if (subTitleArray[index].toUpperCase().contains(element.Parcs_Type!.toUpperCase())) {
        if (filterText.isEmpty)
          wParcs_Ent.add(element);
        else {
          if (element.Parcs_Date_Desc!.toUpperCase().contains(filterText.toUpperCase())) {
            wParcs_Ent.add(element);
          }
        }
      }
    }

    DbTools.gCountRel = 0;
    DbTools.gCountDev = 0;
    for (int i = 0; i < wParcs_Ent.length; i++) {
      Parc_Ent element = wParcs_Ent[i];
      if (element.Livr!.compareTo("R") == 0) DbTools.gCountRel++;
      if (element.Devis!.length > 0) DbTools.gCountDev++;
    }

    if (!isBtnRel) {
      wParcs_Ent2.addAll(wParcs_Ent);
    } else {
      for (int i = 0; i < wParcs_Ent.length; i++) {
        Parc_Ent element = wParcs_Ent[i];
        if (element.Livr!.compareTo("R") == 0) wParcs_Ent2.add(element);
      }
    }

    if (!isBtnDev) {
      DbTools.lParcs_Ent.addAll(wParcs_Ent2);
    } else {
      for (int i = 0; i < wParcs_Ent2.length; i++) {
        Parc_Ent element = wParcs_Ent2[i];
        print("element Devis ${element.Parcs_order} ${element.Devis}");
        if (element.Devis!.length > 0) DbTools.lParcs_Ent.add(element);
      }
    }

//
    print("setSt 1");
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    print(" initConnectivity");
setState(() {

});  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print("HOME _updateConnectionStatus");
    await DbTools.checkConnection();
    setState(() {});
  }



  void initState() {
    DbTools.gRowisSel = false;
    DbTools.gRowIndex = -1;
    DbTools.gRowSels.clear();

    lGrdBtnGrp.add(GrdBtnGrp(GrdBtnGrpId: 4, GrdBtnGrp_Color: Colors.black, GrdBtnGrp_ColorSel: Colors.black, GrdBtnGrp_Txt_Color: Colors.white, GrdBtnGrp_Txt_ColorSel: Colors.red, GrdBtnGrpSelId: [0], GrdBtnGrpType: 0));

    subTitleArray.clear();
    ListParam_ParamTypeOg.clear();

    int i = 0;

    print("element ${Srv_DbTools.ListParam_ParamAll}");


    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
        print("element ${element.Param_Param_ID}  ${element.Param_Param_Text}");
        if (element.Param_Param_ID.compareTo("Base") != 0) {
          lGrdBtn.add(GrdBtn(GrdBtnId: i++, GrdBtn_GroupeId: 4, GrdBtn_Label: element.Param_Param_ID));
          subTitleArray.add(element.Param_Param_ID);
          subLibArray.add(element.Param_Param_Text);
          ListParam_ParamTypeOg.add(element);
        }
      }
    });

    DbTools.ParamTypeOg = subLibArray[0];

    _tabController = TabController(vsync: this, length: 14);
    _tabController.index = 0;
    _tabController.addListener(() {
      Filtre();
    });

    initLib();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    ctrlNbInsert.text = "${NbAdd}";
    ctrlPos.text = "${iPos}";

    ctrlNbInsertfocusNode.addListener(() {
      if (ctrlNbInsertfocusNode.hasFocus) {
        ctrlNbInsert.selection = TextSelection(baseOffset: 0, extentOffset: ctrlNbInsert.text.length);
      }
    });

    ctrlPosfocusNode.addListener(() {
      if (ctrlPosfocusNode.hasFocus) {
        ctrlPos.selection = TextSelection(baseOffset: 0, extentOffset: ctrlPos.text.length);
      }
    });
    acontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    acontroller.repeat(reverse: true);
    acontroller.stop();

    super.initState();
  }

  @override
  void dispose() {
    acontroller.dispose();
    super.dispose();
  }

  GrdBtn getGrdBtn(int Id) {
    GrdBtn wGrdBtn = GrdBtn(GrdBtnId: -1, GrdBtn_GroupeId: -1, GrdBtn_Label: "");
    lGrdBtn.forEach((element) {
      if (element.GrdBtnId == Id) {
        wGrdBtn = element;
      }
    });
    return wGrdBtn;
  }

  GrdBtnGrp getGrdBtnGrp(int Id) {
    GrdBtnGrp wGrdBtnGrp = GrdBtnGrp(GrdBtnGrpId: -1, GrdBtnGrp_Color: Colors.white);
    lGrdBtnGrp.forEach((element) {
      if (element.GrdBtnGrpId == Id) {
        wGrdBtnGrp = element;
      }
    });
    return wGrdBtnGrp;
  }

  void selGrdBtnGrp(int Id, int sel) {
    for (int i = 0; i < lGrdBtnGrp.length; i++) {
      if (lGrdBtnGrp[i].GrdBtnGrpId == Id) {
        if (lGrdBtnGrp[i].GrdBtnGrpType == 0) {
          lGrdBtnGrp[i].GrdBtnGrpSelId = [sel];
        } else {
          if (lGrdBtnGrp[i].GrdBtnGrpSelId!.contains(sel)) {
            lGrdBtnGrp[i].GrdBtnGrpSelId!.remove(sel);
          } else {
            lGrdBtnGrp[i].GrdBtnGrpSelId!.add(sel);
          }
        }
      }
    }
  }

  @override
  Widget Entete_Btn_Search() {
    return Container(

        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 8,
          ),
          InkWell(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Image.asset(
                  "assets/images/QrCode.png",
                  height: icoWidth,
                  width: icoWidth,
                ),
              ]),
              onTap: () async {
                await HapticFeedback.vibrate();
                var result = await BarcodeScanner.scan();

                print("result.type ${result.type}");
                print("result.rawContent ${result.rawContent}");
                print("result.format ${result.format}");

                QrcValue = "";
                if (result.type.toString().compareTo("Barcode") == 0) {
                  if (result.format.toString().compareTo("qr") == 0) {
                    if (result.rawContent.toString().startsWith("M")) {
                      if (result.rawContent.toString().endsWith("F")) {
                        QrcValue = result.rawContent;
                        DbTools.lParcs_Ent.forEach((element) {
                          if (element.Parcs_QRCode!.compareTo(QrcValue) == 0) {
                            _onRowDoubleTap(context, element);
                          }
                        });
                      }
                    }
                  }
                }

                print("setSt 5");
                setState(() {});
              }),
          Container(
            width: 8,
          ),
          Spacer(),
          Container(
            width: 50,
            child: Text(
              '${countX} / ${countTot}',
              style: gColors.bodySaisie_B_G,
              textAlign: TextAlign.center,
            ),
          ),
          EdtFilterWidget(),
        ]));
  }

  Widget EdtFilterWidget() {
    return !affEdtFilter
        ? InkWell(
        child: Padding(
          padding: EdgeInsets.only(right: 8),
          child: Image.asset(
            "assets/images/Btn_Loupe.png",
            height: icoWidth,
            width: icoWidth,
          ),
        ),
        onTap: () async {
          affEdtFilter = !affEdtFilter;
          setState(() {});
        })
        : Container(
        width: 320,
        child: Row(
          children: [
            InkWell(
                child: Image.asset(
                  "assets/images/Btn_Loupe.png",
                  height: icoWidth,
                  width: icoWidth,
                ),
                onTap: () async {
                  affEdtFilter = !affEdtFilter;
                  setState(() {});
                }),
            Expanded(
                child: TextField(
                  onChanged: (text) {
                    filterText = text;
                    Filtre();
                  },
                  controller: ctrlFilter,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        ctrlFilter.clear();
                        filterText = "";
                        Filtre();
                      },
                      icon: Image.asset(
                        "assets/images/Btn_Clear.png",
                        height: icoWidth,
                        width: icoWidth,
                      ),
                    ),
                  ),
                ))
          ],
        ));
  }


  //********************************************
  //********************************************
  //********************************************

  Widget GrpBtn(BuildContext context, List<GrdBtn> alGrdBtn, int nbCol, double aAspectRatio) {
    return GridView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: alGrdBtn.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: aAspectRatio, crossAxisCount: nbCol, crossAxisSpacing: 1.0, mainAxisSpacing: 1.0),
      itemBuilder: (BuildContext context, int index) {
        GrdBtn wGrdBtn = alGrdBtn[index];
        GrdBtnGrp wGrdBtnGrp = getGrdBtnGrp(wGrdBtn.GrdBtn_GroupeId!);
        return Container(
          color: wGrdBtnGrp.GrdBtnGrpSelId!.contains(wGrdBtn.GrdBtnId) ? wGrdBtnGrp.GrdBtnGrp_ColorSel : wGrdBtnGrp.GrdBtnGrp_Color,
          child: InkWell(
            onTap: () {
              selGrdBtnGrp(wGrdBtn.GrdBtn_GroupeId!, wGrdBtn.GrdBtnId!);
              _tabController.index = wGrdBtn.GrdBtnId!;
              Filtre();
              print("setSt 3");
              setState(() {});
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  wGrdBtn.GrdBtn_Label!,
                  textAlign: TextAlign.center,
                  style: gColors.bodySaisie_B_W.copyWith(
                    color: wGrdBtnGrp.GrdBtnGrpSelId!.contains(wGrdBtn.GrdBtnId) ? wGrdBtnGrp.GrdBtnGrp_Txt_ColorSel : wGrdBtnGrp.GrdBtnGrp_Txt_Color,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void onMaj() async {
    print("•••••••••• Parent onMaj() Relaod()");

  }

  @override
  Widget Import_Export() {

    return Padding(
      padding: const EdgeInsets.only(left: 70, right: 30.0, bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          iStrfImp
              ? CircularProgressIndicator(
                  value: acontroller.value,
                  semanticsLabel: 'Circular progress indicator',
                )
              : FloatingActionButton(
                  heroTag: null,
                  elevation: 0.0,
                  child: Image.asset(
                    "assets/images/Btn_Download.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),

                  backgroundColor: DbTools.hasConnection ? gColors.primaryGreen : Colors.black26,
                  onPressed: () async {
                    if (!DbTools.hasConnection)
                      {
                        await OffLine();
                        await Srv_ImportExport.getErrorSync();
                        setState(() {});
                        return;
                      }

                    List<Parc_Ent> lParcs_Ent = await DbTools.getParcs_Ent_Upd(Srv_DbTools.gIntervention.InterventionId!);
                    print("lParcs_Ent lenght ${lParcs_Ent.length}");

                    if (lParcs_Ent.length > 0) {
                      await gObj.AffMessageInfo(context, "Verif Plus", "Vous avez des organes à transférer sur le serveur avant d'importer");
                      return;
                    }
                    print("setSt 6");

                    setState(() {
                      acontroller.forward();
                      acontroller.repeat(reverse: true);
                      iStrfImp = true;
                    });

                    await Srv_DbTools.getParc_EntID(Srv_DbTools.gIntervention.InterventionId!);
                    print("ListParc_Ent lenght ${Srv_DbTools.ListParc_Ent.length}");

                    for (int i = 0; i < Srv_DbTools.ListParc_Ent.length; i++) {
                      Parc_Ent_Srv xParc_Ent_Srv = Srv_DbTools.ListParc_Ent[i];
                      print("ListParc_Ent lenght ${xParc_Ent_Srv.toMap()}");
                    }

                    await Srv_DbTools.getParcs_DescInter(Srv_DbTools.gIntervention.InterventionId!);
                    print("ListParc_Desc lenght ${Srv_DbTools.ListParc_Desc.length}");
                    await Srv_DbTools.getParcs_ArtInter(Srv_DbTools.gIntervention.InterventionId!);
                    print("ListParc_Art lenght ${Srv_DbTools.ListParc_Art.length}");

                    print("***************** DELETE ****************");

                    // DELETE

                    await DbTools.deleteParc_EntInter(Srv_DbTools.gIntervention.InterventionId!);

                    List<Parc_Art> wParcs_Art = await DbTools.getParcs_ArtInter(Srv_DbTools.gIntervention.InterventionId!);
                    for (int i = 0; i < wParcs_Art.length; i++) {
                      Parc_Art xParc_Art = wParcs_Art[i];
                      await DbTools.deleteParc_Art(xParc_Art.ParcsArtId!);
                    }

                    List<Parc_Desc> wParcs_Desc = await DbTools.getParcs_DescInter(Srv_DbTools.gIntervention.InterventionId!);
                    for (int i = 0; i < wParcs_Desc.length; i++) {
                      Parc_Desc xParc_Desc = wParcs_Desc[i];
                      await DbTools.deleteParc_Desc(xParc_Desc.ParcsDescId!);
                    }

                    // INSERT
                    print("***************** INSERT ****************");

                    for (int i = 0; i < Srv_DbTools.ListParc_Ent.length; i++) {
                      Parc_Ent_Srv xParc_Ent_Srv = Srv_DbTools.ListParc_Ent[i];
                      int ParcsId = xParc_Ent_Srv.ParcsId!;

                      xParc_Ent_Srv.ParcsId = null;
                      await DbTools.insertParc_Ent_Srv(xParc_Ent_Srv);
                      int gLastID = DbTools.gLastID;

                      for (int i = 0; i < Srv_DbTools.ListParc_Desc.length; i++) {
                        Parc_Desc_Srv xParc_Desc_Srv = Srv_DbTools.ListParc_Desc[i];
                        if (xParc_Desc_Srv.ParcsDesc_ParcsId == ParcsId) {
                          xParc_Desc_Srv.ParcsDescId = null;
                          xParc_Desc_Srv.ParcsDesc_ParcsId = gLastID;
                          await DbTools.insertParc_Desc_Srv(xParc_Desc_Srv);
                        }
                      }

                      for (int i = 0; i < Srv_DbTools.ListParc_Art.length; i++) {
                        Parc_Art_Srv xParc_Art_Srv = Srv_DbTools.ListParc_Art[i];
                        if (xParc_Art_Srv.ParcsArt_ParcsId == ParcsId) {
                          xParc_Art_Srv.ParcsArtId = null;
                          xParc_Art_Srv.ParcsArt_ParcsId = gLastID;
                          await DbTools.insertParc_Art_Srv(xParc_Art_Srv);
                        }
                      }
                    }
                    print("setSt 7");

                    setState(() {
                      acontroller.stop();
                      iStrfImp = false;
                    });

                    await Reload();
                    List<Parc_Art> zParcs_Art = await DbTools.getParcs_ArtInter(Srv_DbTools.gIntervention.InterventionId!);
                    List<Parc_Desc> zParcs_Desc = await DbTools.getParcs_DescInter(Srv_DbTools.gIntervention.InterventionId!);

                    String wStr = "Import de ${Srv_DbTools.ListParc_Ent.length} organes terminé\n\n"
                        "- ${Srv_DbTools.ListParc_Desc.length} descriptions\n"
                        "- ${Srv_DbTools.ListParc_Art.length} Articles\n\n"
                        "- ${zParcs_Desc.length} descriptions\n"
                        "- ${zParcs_Art.length} Articles\n\n";

                    await gObj.AffMessageInfo(context, "Verif Plus", wStr);

                    if (DbTools.glfParcs_Ent.length == 0)
                    {
                      print("Client_Groupe_Parc_Inter <<<<<<<<<<<<<<<<<<< AAA ${Srv_DbTools.gIntervention.InterventionId} ${Srv_DbTools.gIntervention.Intervention_Type} >>>>>>>>>>>>>>>>>>>>>");
                      Parc_Ent wParc_Ent = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId!, Srv_DbTools.gIntervention.Intervention_Parcs_Type!, 0);
                      print("Client_Groupe_Parc_Inter <<<<<<<<<<<<<<<<<<< BBB>>>>>>>>>>>>>>>>>>>>>");
                      DbTools.insertParc_Ent(wParc_Ent);
                      print("Client_Groupe_Parc_Inter <<<<<<<<<<<<<<<<<<< CCC>>>>>>>>>>>>>>>>>>>>>");
                      DbTools.glfParcs_Ent = await DbTools.getParcs_Ent(Srv_DbTools.gIntervention.InterventionId!);
                      print("Client_Groupe_Parc_Inter <<<<<<<<<<<<<<<<<<< DDD ${DbTools.glfParcs_Ent.length}>>>>>>>>>>>>>>>>>>>>>");
                    }
                    await Srv_ImportExport.getErrorSync();



                  }),
          Spacer(),
          iStrfExp
              ? CircularProgressIndicator(
                  value: acontroller.value,
                  semanticsLabel: 'Circular progress indicator',
                )
              : FloatingActionButton(
                  heroTag: null,
                  elevation: 0.0,
                  child: Image.asset(
                    "assets/images/Btn_Upload.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
              backgroundColor: DbTools.hasConnection ? gColors.primaryRed : Colors.black26,
                  onPressed: () async {
                    if (!DbTools.hasConnection)
                    {
                      await OffLine();
                      await Srv_ImportExport.getErrorSync();
                      setState(() {});
                      return;
                    }
                    print("setSt 8");

                    setState(() {
                      acontroller.forward();
                      acontroller.repeat(reverse: true);
                      iStrfExp = true;
                    });
                    int NbDesc = 0;
                    int NbArt = 0;

                    DbTools.glfParcs_Ent = await DbTools.getParcs_Ent_Upd(Srv_DbTools.gIntervention.InterventionId!);
                    print("glfParcs_Ent lenght ${DbTools.glfParcs_Ent.length}");

                    DbTools.lParcs_Art.clear();
                    DbTools.glfParcs_Art = await DbTools.getParcs_ArtInter(Srv_DbTools.gIntervention.InterventionId!);
                    print("getParcs_ArtInter ${Srv_DbTools.gIntervention.InterventionId!}");
                    print("glfParcs_Art lenght ${DbTools.glfParcs_Art.length}");
                    DbTools.lParcs_Art.addAll(DbTools.glfParcs_Art);

//                    await Srv_DbTools.delParc_Ent_Srv(Srv_DbTools.gIntervention.InterventionId!);
                    await Srv_DbTools.delParc_Ent_Srv_Upd();

                    for (int i = 0; i < DbTools.glfParcs_Ent.length; i++) {
                      var element = DbTools.glfParcs_Ent[i];



                      await Srv_DbTools.InsertUpdateParc_Ent_Srv(element);

                      int gLastID = Srv_DbTools.gLastID;
                      print("Srv_DbTools.gLastID ${gLastID}      <   ${element.ParcsId}");

                      String wSql = "";
                      for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
                        var element2 = DbTools.glfParcs_Desc[i];
                        if (element2.ParcsDesc_ParcsId == element.ParcsId) {
                          NbDesc++;
                          element2.ParcsDesc_ParcsId = gLastID;
                          String wTmp = Srv_DbTools.InsertUpdateParc_Desc_Srv_GetSql(element2);
                          wSql = "${wSql} ${wTmp};";
                        }
                      }

                      if (wSql.isNotEmpty) {
                        await Srv_DbTools.InsertUpdateParc_Desc_Srv_Sql(wSql);
                      }

                      wSql = "";
                      for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
                        var element2 = DbTools.lParcs_Art[i];
                        if (element2.ParcsArt_ParcsId == element.ParcsId) {
                          NbArt++;
                          element2.ParcsArt_ParcsId = gLastID;
                          String wTmp = Srv_DbTools.InsertUpdateParc_Art_Srv_GetSql(element2);
                          wSql = "${wSql} ${wTmp};";
                        }
                      }

                      if (wSql.isNotEmpty) {
                        await Srv_DbTools.InsertUpdateParc_Art_Srv_Sql(wSql);
                      }

                      print(" updateParc_Ent_Update");
                      await DbTools.updateParc_Ent_Update(element.ParcsId!, 0);
                    }

                    print("setSt 9");

                    setState(() {
                      acontroller.stop();
                      iStrfExp = false;
                    });
                    await Reload();

                    String wStr = "Transfert de ${DbTools.glfParcs_Ent.length} organes terminé\n\n"
                        "- ${NbDesc} descriptions\n"
                        "- ${NbArt} Articles";

                    await gObj.AffMessageInfo(context, "Verif Plus", wStr);
                    await Srv_ImportExport.getErrorSync();

                  })
        ],
      ),
    );
  }

  @override
  Widget Enntete_Inter() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(children: [
          gObj.InterventionTitleWidget("${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2 : "${Srv_DbTools.gGroupe.Groupe_Nom} / ${Srv_DbTools.gSite.Site_Nom} / ${Srv_DbTools.gZone.Zone_Nom}", wTimer : wTimer),


        ]));
  }

  @override
  Widget Organes() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            gObj.InterventionTitleWidget("${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2 : "${Srv_DbTools.gGroupe.Groupe_Nom} / ${Srv_DbTools.gSite.Site_Nom} / ${Srv_DbTools.gZone.Zone_Nom}", wTimer : wTimer),
            Entete_Btn_Search(),
            Expanded(
              child: ExtGridWidget(),
            ),
            (DbTools.gRowisSel && DbTools.gCurrentIndex3 == 0) ? PopupMove(context) : Container(),
          ],
        ));
  }

  @override
  AppBar appBar() {
    return AppBar(
      title: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          await Client_Dialog.Dialogs_Client(context);
        },
        child:
        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          AutoSizeText(
            affAll ? "COMPTE-RENDU / VÉRIFICATION" : "INFOS PRATIQUES",
            maxLines: 1,
            style: gColors.bodyTitle1_B_G24,
          ),
        ]),


      ),
      leading: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          await Popop();
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
            affAll ? Icons.arrow_circle_down_rounded : Icons.arrow_circle_up_rounded,
            color: Colors.grey,
          ),
          onPressed: () async {
            print("setSt 4");
            await Navigator.push(context, MaterialPageRoute(builder: (context) => Intervention_Vue(onMaj: onMaj,)));
            // setState(() {affAll = !affAll;});
          },
        ),
      ],
      backgroundColor: gColors.white,
    );
  }

  Future  OffLine() async
  {
    List<Parc_Ent> lParcs_Ent = await DbTools.getParcs_Ent_Upd(Srv_DbTools.gIntervention.InterventionId!);
    if (lParcs_Ent.length > 0) {
      await showDialog(
          context: context,
          builder: (context) =>
          new AlertDialog(
            surfaceTintColor: Colors.white,
            title: Column(
              //Slide3
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/AppIco.png'),
                    height: 50,
                  ),
                  SizedBox(height: 8.0),
                  Container(color: Colors.grey, height: 1.0),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      "Mode Off Line",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ]),
            content: Text("Vous n'avez pas de connexion : Import/Export impossible!!!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text('Ok'),
              ),

            ],
          )


      );
    }
    else
      Navigator.of(context).pop();
  }

  Future  Popop() async
  {
    print("Popop ${canClose}");
    if(canClose) {
      try {
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }

    if(!DbTools.hasConnection) {
      canClose = true;
      try {
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
      return;
    }

    List<Parc_Ent> lParcs_Ent = await DbTools.getParcs_Ent_Upd(Srv_DbTools.gIntervention.InterventionId!);
    if (lParcs_Ent.length > 0) {
      await showDialog(
          context: context,
          builder: (context) =>
          new AlertDialog(
            surfaceTintColor: Colors.white,
            title: Column(
              //Slide3
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/AppIco.png'),
                    height: 50,
                  ),
                  SizedBox(height: 8.0),
                  Container(color: Colors.grey, height: 1.0),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      "Vous avez des enregistrements à remonter sur le serveur !!!",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ]),
            content: Text("Êtes-vous sûre de vouloir quitter cette fenêtre ?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text('Non'),
              ),
              TextButton(
                onPressed: () {
                  canClose = true;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: new Text('Oui'),
              ),
            ],
          )


      );
    }
    else
      {
        canClose = true;
        Navigator.of(context).pop();
      }


  }


  @override
  Widget build(BuildContext context) {
//    print("build");
    double LargeurLabel = 120;
    double h = 60;

//    isKeyBoard = (MediaQuery.of(context).viewInsets.bottom != 0.0);
    Widget wchildren = Container();

    if (affAll) {
      if (DbTools.gCurrentIndex3 == 2)
        wchildren = Client_Groupe_Parc_Inter_BL(onMaj: onMaj, x_t: "");
      else if (DbTools.gCurrentIndex3 == 3)
        wchildren = Client_Groupe_Parc_Inter_BC(onMaj: onMaj, x_t: "");
      else if (DbTools.gCurrentIndex3 == 5)
        wchildren = Client_Groupe_Parc_Inter_Note(onMaj: onMaj, x_t: "");
      else if (DbTools.gCurrentIndex3 == 6)
        wchildren = Client_Groupe_Parc_Inter_Signature(onMaj: onMaj, x_t: "");
      else
        wchildren = Organes();
    } else
      wchildren = Enntete_Inter();

    return new PopScope(
        canPop: canClose,
        onPopInvoked: (_) async {
      await Popop();
    },

    child:Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        body: Stack(fit: StackFit.expand, children: <Widget>[
          wchildren,
          (DbTools.gRowisSel || !affAll)
              ? Container()
              : Positioned(
                  bottom: 0,
                  right: 0,
                  child: CustomBottomNavigationBar3(
                    onIconPresedCallback: onBottomIconPressed,
                  ),
                ),
        ]),
        floatingActionButton: (DbTools.gRowisSel)
            ? Container()
            : (DbTools.gCurrentIndex3 > 0 || !affAll)
                ? Container()
                : Import_Export()));
  }

  Widget CadreWidget(Widget wWidget, Color Color1, Color Color2, Color ColorTxt) {
    double p = 2;
    return Container(
//    width: MediaQuery.of(context).size.width - 16,
      color: Color1,
      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
      child: Container(color: Color2, padding: EdgeInsets.fromLTRB(p, p, p, p), child: wWidget),
    );
  }

  bool getParc_Ent(int aId) {
    bool wRet = false;
    if (DbTools.gRowSels.length > 0) {
      if (aId < DbTools.gRowSels.length) {
        int wId = DbTools.gRowSels[aId].Id;
        for (int i = 0; i < DbTools.lParcs_Ent.length; i++) {
          Parc_Ent element = DbTools.lParcs_Ent[i];
          if (element.ParcsId! == wId) {
//            print("getParc_Ent Sels $aId Id $wId Ordre ${element.Parcs_order}");
            DbTools.gParc_Ent = element;
            wRet = true;
            break;
          }
        }
      }
    }

    return wRet;
  }

  bool isInSels(int aId) {
    bool wRet = false;

    for (int i = 0; i < DbTools.gRowSels.length; i++) {
      SelLig element = DbTools.gRowSels[i];
      if (element.Id == aId) {
        wRet = true;
        break;
      }
    }
    return wRet;
  }

  Widget PopupMove(BuildContext context) {
    var val = TextSelection.fromPosition(TextPosition(offset: ctrlNbInsert.text.length));
    ctrlNbInsert.selection = val;
    val = TextSelection.fromPosition(TextPosition(offset: ctrlPos.text.length));
    ctrlPos.selection = val;

    double h = 60;

    DbTools.gRowSels.sort(SelLig.affSortComparison);

    bool isDelPos = false;
    DbTools.gRowSels.forEach((eSel) {
      DbTools.lParcs_Ent.forEach((eParc) {
        if (eSel.Id == eParc.ParcsId) {
          if (eParc.Parcs_Date_Desc!.length == 0) isDelPos = true;
        }
      });
    });

    bool isParcEnt = getParc_Ent(0);
//    print("isParcEnt $isParcEnt ${DbTools.gParc_Ent.toString()}");

    bool isMoveUp = false;
    if (DbTools.gRowSels.length == 0) {
      isMoveUp = DbTools.gParc_Ent.Parcs_order != 1;
    } else {
      isMoveUp = DbTools.gParc_Ent.Parcs_order != 1;
    }

    bool isMoveDown = false;
    if (DbTools.gRowSels.length == 0) {
      isMoveDown = (DbTools.gParc_Ent.Parcs_order! >= DbTools.lParcs_Ent[DbTools.lParcs_Ent.length - 1].Parcs_order!);
    } else {
//      print("Sel ${DbTools.gRowSels.length} ");
      int fin = DbTools.gParc_Ent.Parcs_order! + DbTools.gRowSels.length - 1;
//      print("Fin ${fin} ");
      int esp = DbTools.lParcs_Ent.length - fin;
//      print("esp ${esp} ");

      isMoveDown = esp > 0;
    }

//    print("isMoveDown $isMoveDown");

    return Container(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
      color: gColors.LinearGradient3,
      child: Column(
        children: [
// LIGNE 1
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: 10,
            ),

            //
            // Fermeture POPUPMOVE
            //

            Spacer(),

            //
            // MOVE UP
            //
            Container(
              width: h,
              height: h,
              child: InkWell(
                child: Btn("Haut", Icons.keyboard_arrow_up),
                onTap: () async {
                  if (isMoveUp) {
                    if (!_isButtonTapped) {
                      _isButtonTapped = true;

                      print("Btn moveUP B $_isButtonTapped");
                      await moveUP();
                      print("Btn moveUP C $_isButtonTapped");
                      await Reload();
                      print("Btn moveUP D $_isButtonTapped");

                      _isButtonTapped = false;
                      print("Btn moveUP E $_isButtonTapped");
                    } else {
                      _isButtonTapped = false;
                      print("Btn moveUP F $_isButtonTapped");
                    }
                  }
                },
              ),
            ),
            Container(
              width: 10,
            ),

            //
            // MOVE FIRST
            //
            Container(
              width: h,
              height: h,
              child: InkWell(
                child: Btn("1ère", Icons.keyboard_double_arrow_up),
                onTap: () async {
                  if (isMoveUp) {
                    DbTools.gRowSels.sort(SelLig.affSortComparison);
                    int FirstSelOrdre = DbTools.gRowSels[0].Ordre;
                    print("FirstSelOrdre ${FirstSelOrdre}");
                    for (int j = 1; j < FirstSelOrdre; j++) {
                      print("moveUP ${j}");
                      await moveUP();
                      DbTools.gRowSels.forEach((eSel) {
                        eSel.Ordre--;
                      });
                    }
                    await Reload();
                  }
                },
              ),
            ),

            Container(
              width: 10,
            ),
            Container(
                width: h,
                height: h,
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(60),
                      ),
                      color: gColors.btnMove,
                    ),
                    child: Icon(
                      Icons.remove,
                      color: gColors.white,
                      size: 46,
                    ),
                  ),
                  onTap: () async {
                    if (timer != null) {
                      timer!.cancel();
                    }

                    if (iPos > 1) {
                      iPos--;
                      ctrlPos.text = "${iPos}";
//                      FocusScope.of(context).requestFocus(ctrlPosfocusNode);
                    }
                  },
                  onLongPressStart: (detail) {
                    print("setSt 10");

                    setState(() {
                      if (timer != null) {
                        timer!.cancel();
                      }

                      timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
                        if (iPos > 1) {
                          iPos--;
                          ctrlPos.text = "${iPos}";
//                          FocusScope.of(context).requestFocus(ctrlPosfocusNode);
                        } else {
                          if (timer != null) {
                            timer!.cancel();
                          }
                        }
                      });
                    });
                  },
                  onLongPressEnd: (detail) {
                    print("onLongPressEnd --");
                    if (timer != null) {
                      print("onLongPressEnd -- cancel");
                      timer!.cancel();
                    }
                  },
                )),
            Container(
              width: 10,
            ),
            Container(
              width: 120,
              height: 64,
              decoration: BoxDecoration(
                border: Border.all(
                  color: gColors.btnMoveDark,
                ),
                borderRadius: BorderRadius.circular(8),
                color: gColors.white,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                      color: gColors.btnMoveDark,
                    ),
                    width: 120,
                    child: Text(
                      "Nouvelle position",
                      style: gColors.btnMove_B_W,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextField(
                    onChanged: (text) {
                      iPos = int.tryParse(text) ?? 1;
                    },
                    textAlign: TextAlign.center,
                    style: gColors.bodyTitle1_B_G_20,
                    controller: ctrlPos,
                    focusNode: ctrlPosfocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),

            Container(
              width: 10,
            ),
            Container(
                width: h,
                height: h,
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(60),
                      ),
                      color: gColors.btnMove,
                    ),
                    child: Icon(
                      Icons.add,
                      color: gColors.white,
                      size: 46,
                    ),
                  ),
                  onTap: () async {
                    if (timer != null) {
                      timer!.cancel();
                    }

                    if (iPos < DbTools.lParcs_Ent.length) {
                      iPos++;
                      ctrlPos.text = "${iPos}";
                    }

//                    FocusScope.of(context).requestFocus(ctrlPosfocusNode);
                  },
                  onLongPressStart: (detail) {
                    print("setSt 11");

                    setState(() {
                      if (timer != null) {
                        timer!.cancel();
                      }

                      timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
                        if (iPos < DbTools.lParcs_Ent.length) {
                          iPos++;
                          ctrlPos.text = "${iPos}";
//                          FocusScope.of(context).requestFocus(ctrlPosfocusNode);
                        } else {
                          if (timer != null) {
                            timer!.cancel();
                          }
                        }
                      });
                    });
                  },
                  onLongPressEnd: (detail) {
                    print("onLongPressEnd ++");
                    if (timer != null) {
                      timer!.cancel();
                    }
                  },
                )),

            Container(
              width: 10,
            ),

            //
            // MOVE LAST
            //
            Container(
                width: h,
                height: h,
                child: InkWell(
                  child: Btn("Dernière", Icons.keyboard_double_arrow_down),
                  onTap: () async {
                    if (isMoveDown) {
                      int LastSel = DbTools.gRowSels.length - 1;
                      int LastSelOrdre = DbTools.gRowSels[LastSel].Ordre;
                      int wDec = DbTools.lParcs_Ent.length - LastSelOrdre;

                      print("moveDOWN ${LastSel} ${LastSelOrdre} ${wDec}");

                      for (int j = 0; j <= wDec; j++) {
                        print(">>>>> moveDOWN $j");
                        await moveDOWN();
                        DbTools.gRowSels.forEach((eSel) {
                          eSel.Ordre++;
                        });
                      }
                      await Reload();
                    }
                  },
                )),
            Container(
              width: 10,
            ),

            //
            // MOVE DOWN
            //
            Container(
                width: h,
                height: h,
                child: InkWell(
                  child: Btn("Bas", Icons.keyboard_arrow_down),
                  onTap: () async {
                    if (isMoveDown) {
                      if (!_isButtonTapped) {
                        print("Btn moveDOWN A $_isButtonTapped");
                        _isButtonTapped = true;

                        print("Btn moveDOWN B $_isButtonTapped");
                        await moveDOWN();
                        print("Btn moveDOWN C $_isButtonTapped");
                        await Reload();
                        print("Btn moveDOWN D $_isButtonTapped");

                        _isButtonTapped = false;
                        print("Btn moveDOWN E $_isButtonTapped");
                      } else {
                        _isButtonTapped = false;
                        print("Btn moveDOWN F $_isButtonTapped");
                      }
                    }
                  },
                )),
            Spacer(),

            Container(
              width: 10,
            ),
          ]),

          Container(height: 25),

/////////////
/////////////
// LIGNE 2 //
/////////////
/////////////

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 10,
              ),
              Container(
                  width: h,
                  height: h,
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: gColors.primaryGreen,
                      ),
                      child: Icon(
                        Icons.check,
                        color: gColors.white,
                        size: 46,
                      ),
                    ),
                    onTap: () async {
                      print("Press Valid");
                      if (iPos > DbTools.lParcs_Ent.length) {
                        iPos = DbTools.lParcs_Ent.length;
                      }
                      if (iPos < 1) {
                        iPos = 1;
                      }
                      ctrlPos.text = "$iPos";
                      int FirstSelOrdre = DbTools.gRowSels[0].Ordre;
                      int LastSel = DbTools.gRowSels.length - 1;
                      int LastSelOrdre = DbTools.gRowSels[LastSel].Ordre;
                      if (iPos < FirstSelOrdre) {
                        int wDec = FirstSelOrdre - iPos;
                        for (int j = 1; j <= wDec; j++) {
                          await moveUP();
                          DbTools.gRowSels.forEach((eSel) {
                            eSel.Ordre--;
                          });
                        }
                        await Reload();
                      } else if (LastSelOrdre < iPos) {
                        int wDec = iPos - LastSelOrdre;
                        for (int j = 0; j < wDec; j++) {
                          await moveDOWN();
                          DbTools.gRowSels.forEach((eSel) {
                            eSel.Ordre++;
                          });
                        }
                        await Reload();
                      }

                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  )),
              Spacer(),
              Container(
                  width: h,
                  height: h,
                  child: InkWell(
                    child: Btn("Avant", Icons.keyboard_arrow_left),
                    onTap: () async {
                      if (DbTools.gRowSels.length == 1) {
                        for (int i = 0; i < NbAdd; i++) {
                          Parc_Ent wParc_Ent = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId!, DbTools.gParc_Ent.Parcs_Type!, DbTools.gParc_Ent.Parcs_order! - 1);
                          DbTools.insertParc_Ent(wParc_Ent);
                        }
                        Reload();
                      }
                    },
                  )),
              Container(
                width: 10,
              ),
              Container(
                  width: h,
                  height: h,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        color: gColors.btnMove,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: gColors.white,
                        size: 46,
                      ),
                    ),
                    onTap: () async {
                      if (NbAdd > 1) {
                        NbAdd--;
                        ctrlNbInsert.text = "${NbAdd}";
                      }
                    },
                    onLongPressStart: (detail) {
                      print("setSt 12");

                      setState(() {
                        if (timer != null) {
                          timer!.cancel();
                        }
                        timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
                          if (NbAdd > 1) {
                            NbAdd--;
                            ctrlNbInsert.text = "${NbAdd}";
                          } else {
                            if (timer != null) {
                              timer!.cancel();
                            }
                          }
                        });
                      });
                    },
                    onLongPressEnd: (detail) {
                      print("onLongPressEnd --");

                      if (timer != null) {
                        print("onLongPressEnd -- cancel");
                        timer!.cancel();
                      }
                    },
                  )),
              Container(
                width: 10,
              ),
              Container(
                width: 120,
                height: 64,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: gColors.btnMoveDark,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: gColors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                        color: gColors.btnMoveDark,
                      ),
                      width: 120,
                      child: Text(
                        "Nombre de ligne",
                        style: gColors.btnMove_B_W,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextField(
                      onChanged: (text) {
                        NbAdd = int.parse(text);
                      },
                      textAlign: TextAlign.center,
                      style: gColors.bodyTitle1_B_G_20,
                      controller: ctrlNbInsert,
                      focusNode: ctrlNbInsertfocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
              ),
              Container(
                  width: h,
                  height: h,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        color: gColors.btnMove,
                      ),
                      child: Icon(
                        Icons.add,
                        color: gColors.white,
                        size: 46,
                      ),
                    ),
                    onTap: () async {
                      NbAdd++;
                      ctrlNbInsert.text = "${NbAdd}";
                    },
                    onLongPressStart: (detail) {
                      print("setSt 13");
                      setState(() {
                        if (timer != null) {
                          timer!.cancel();
                        }

                        timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
                          NbAdd++;
                          ctrlNbInsert.text = "${NbAdd}";
                        });
                      });
                    },
                    onLongPressEnd: (detail) {
                      print("onLongPressEnd ++");
                      if (timer != null) {
                        timer!.cancel();
                      }
                    },
                  )),

              Container(
                width: 10,
              ),

              //
              // ADD AFTER
              //
              Container(
                  width: h,
                  height: h,
                  child: InkWell(
                    child: Btn("Aprés", Icons.keyboard_arrow_right),
                    onTap: () async {
                      if (DbTools.gRowSels.length == 1) {
                        for (int i = 0; i < NbAdd; i++) {
                          Parc_Ent wParc_Ent = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId!, DbTools.gParc_Ent.Parcs_Type!, DbTools.gParc_Ent.Parcs_order!);
                          DbTools.insertParc_Ent(wParc_Ent);
                        }

                        Reload();
                      }
                    },
                  )),
              Spacer(),
              Container(
                  width: h,
                  height: h,
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: gColors.primaryRed,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: gColors.white,
                        size: 46,
                      ),
                    ),
                    onTap: () async {
                      print("isDelPos $isDelPos");
                      if (!isDelPos) return;

                      DbTools.gRowSels.forEach((eSel) async {
                        DbTools.lParcs_Ent.forEach((eParc) async {
                          if (eSel.Id == eParc.ParcsId) {
                            if (eParc.Parcs_Date_Desc!.length == 0) {
                              await DbTools.deleteParc_Ent(eParc.ParcsId!);
                            }
                          }
                        });
                      });
                      DbTools.gRowisSel = false;
                      DbTools.gRowIndex = -1;
                      DbTools.gRowSels.clear();
                      print("Reload > PopupMove ${DbTools.gParc_Ent.Parcs_Cols.toString()}");

                      Reload();
                    },
                  )),
              Container(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Btn(
    String Txt,
    IconData Ico,
  ) {
    double h = 60, r = 8;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(r),
                topLeft: Radius.circular(r),
              ),
              color: gColors.btnMoveDark,
            ),
            width: h,
            child: Text(
              Txt,
              style: gColors.btnMove_B_W,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(r),
                bottomLeft: Radius.circular(r),
              ),
              color: gColors.btnMove,
            ),
            child: Icon(
              Ico,
              color: gColors.white,
              size: 46,
            ),
          ),
        ],
      ),
    );
  }

  static List<String> listMes = [
    "Règle APSAD R4",
    "ERP",
    "ERT",
    "ICPE",
    "Habitat",
    "IGH",
    "Directives DREAL",
    "Autres",
  ];
  static List<bool> itemlistApp = [false, true, false, false, true, false, false, true];

  Widget RegltWidget() {
    Color getColor(Set<MaterialState> states) {
      return gColors.LinearGradient1;
    }

    final AutreController = TextEditingController();
    bool AffAutreController = false;

    return Container(
      width: 584,
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: gColors.LinearGradient1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Réglementations techniques applicable à l'établissement ",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      listMes[0],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[0], onChanged: (bool? value) {}),
                    Text(
                      listMes[1],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[1], fillColor: MaterialStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[2],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[2], fillColor: MaterialStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[3],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[3], fillColor: MaterialStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[4],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[4], fillColor: MaterialStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[5],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[5], fillColor: MaterialStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      listMes[6],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[6], fillColor: MaterialStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[7],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(
                        value: itemlistApp[7],
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        onChanged: (bool? value) {
                          AffAutreController = !AffAutreController;
                        }),
                    AffAutreController
                        ? Container(
                            color: Colors.white,
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: AutreController,
                              onChanged: (value) {},
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget ExtGridWidget() {
//    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> ExtGridWidget ${isKeyBoard}");

    List<DaviColumn<Parc_Ent>> wColumns = [
      new DaviColumn(
          name: 'N°',
          cellStyleBuilder: (row) =>
              DbTools.gRowisSel && isInSels(row.data.ParcsId!)
                  ? CellStyle(background: gColors.GrdBtn_Colors1Sel, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_W)
                  : LastClickID == row.data.ParcsId
                      ? CellStyle(background: gColors.greyLight, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_G)
                      : CellStyle(background: Colors.white, alignment: Alignment.center, textStyle: gColors.bodySaisie_N_G),
          cellBuilder: (BuildContext context, DaviRow<Parc_Ent> row) {
            int hab = 0;
            bool upd = false;
            if (row.data.Parcs_MaintCorrect!) hab = 1;
            if (row.data.Parcs_MaintCorrect!) hab = 2;
            if (row.data.Parcs_Install!) hab = 3;

            upd = (row.data.Parcs_Update == 1);

            return InkWell(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        upd
                            ? Container(
                                width: 15,
                                child: Icon(
                                  Icons.adjust,
                                  color: Colors.orange,
                                  size: 10,
                                ))
                            :
                        Container(
                                width: 15,
                              ),
                        Text(
                          "${row.data.Parcs_order}",
                          style: row.data.Livr!.isNotEmpty ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G,
                        ),
/*
                        Container(
                          width: 2,
                        ),
                        Text(
                          "${hab}",
                          style: LastSelID == row.data.ParcsId ? gColors.smallText_P_B : gColors.smallText_P_N,
                        ),
*/
                      ],
                    )),
                onLongPress: () => _onSelMove(row.data));
          },
          width: 60),

      new DaviColumn(name: '${DbTools.ParamTypeOg}', stringValue: (row) => "${row.Parcs_Date_Desc}", width: gColors.MediaQuerysizewidth - 208, cellStyleBuilder: (row) => CellStyle(textStyle: row.data.Livr!.isNotEmpty ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G)),
      new DaviColumn(name: 'Visite', stringValue: (row) => "${row.Parcs_Date_Rev!.isEmpty ? '' : DateFormat('dd/MM/yy').format(DateTime.parse(row.Parcs_Date_Rev!))}", width: 75, cellStyleBuilder: (row) => CellStyle(textStyle: row.data.Livr!.isNotEmpty ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G)),
      new DaviColumn(
          name: 'Action',
          cellAlignment: Alignment.centerRight,
          cellPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          cellBuilder: (BuildContext context, DaviRow<Parc_Ent> row) {
            return Container(
              child: row.data.Parcs_VRMC!.isEmpty
                  ? Container()
                  : Text(
                      "${row.data.Parcs_VRMC} >",
                      textAlign: TextAlign.right,
                      style: gColors.bodySaisie_B_G.copyWith(
                        color: Colors.green,
                      ),
                    ),
            );
          },
          width: 65),
    ];

    for (int i = 0; i < Parcs_ColsTitle!.length; i++) {
      wColumns.add(
        new DaviColumn(
            name: Parcs_ColsTitle![i],
            stringValue: (row) {
              String wRet = "";
              if (i < row.Parcs_Cols!.length) {
                wRet = "${row.Parcs_Cols![i]}";
              }
              return wRet;
            },
            width: 80,
            cellStyleBuilder: (row) => LastSelID == row.data.ParcsId ? CellStyle(textStyle: gColors.bodySaisie_B_G) : CellStyle(textStyle: gColors.bodySaisie_N_G)),
      );
//          => "A ${i < row.Parcs_Cols!.length ? '' : '${row.Parcs_Cols![i]}'}" ));
    }

//    print("ExtGridWidget ${DbTools.lParcs_Ent.length}");
    DaviModel<Parc_Ent>? _model;
    _model = DaviModel<Parc_Ent>(rows: DbTools.lParcs_Ent, columns: wColumns);

    final ScrollController wHScrollController = ScrollController();
    final ScrollController wVScrollController = ScrollController();

    Davi wDavi = Davi<Parc_Ent>(
      _model,
//      visibleRowsCount: 16,
      onRowDoubleTap: (aParc_Ent) => _onRowDoubleTap(context, aParc_Ent),
      onRowTap: (Parc_Ent) => _onRowTap(context, Parc_Ent),
      rowColor: _rowColor,
      onHover: _onHover,
      unpinnedHorizontalScrollController: wHScrollController,
      verticalScrollController: wVScrollController,
    );

    return GestureDetector(
        onPanStart: (d) {
          dxPosition = 0;
          dyPosition = 0;
        },
        onPanUpdate: (details) {
          hPosition = 0;
          vPosition = 0;
          if (details.delta.dx > 5) {
            final minposition = wHScrollController.position.minScrollExtent;
            hPosition = wHScrollController.offset - 5;
            if (hPosition < minposition) hPosition = minposition;
            wHScrollController.jumpTo(hPosition);
            dxPosition = details.delta.dx;
          } else if (details.delta.dx < -5) {
            //          print("Dragging in -X ${details.delta.dx} ${wHScrollController.offset}");
            final Maxposition = wHScrollController.position.maxScrollExtent;
            hPosition = wHScrollController.offset + 5;
            if (hPosition > Maxposition) hPosition = Maxposition;
            wHScrollController.jumpTo(hPosition);
            dxPosition = details.delta.dx;
          } else if (details.delta.dy < 0) {
            final maxposition = wVScrollController.position.maxScrollExtent;
            vPosition = wVScrollController.offset + 20; //details.delta.dy;
            if (vPosition > maxposition) vPosition = maxposition;
            wVScrollController.jumpTo(vPosition);

            dyPosition = details.delta.dy;
//            print(">>>>> Dragging in -Y ${dyPosition} ${details.delta.dy} ${maxposition} ${vPosition}");
          } else if (details.delta.dy > 0) {
            final minposition = wVScrollController.position.minScrollExtent;
            vPosition = wVScrollController.offset - 20; //details.delta.dy;
            if (vPosition < minposition) vPosition = minposition;
            wVScrollController.jumpTo(vPosition);
            dyPosition = details.delta.dy;
            // print(     ">>>>> Dragging in +Y ${details.delta.dy} ${minposition} ${vPosition}");
          }
        },
        onPanEnd: (d) {
//          print(">>>>> dyPosition ${dyPosition} ${vPosition} -- ${d.velocity.pixelsPerSecond.dy} ---- ${dxPosition} ${hPosition}");
          if (dyPosition < 0) {
            final maxposition = wVScrollController.position.maxScrollExtent;
            final delta = d.velocity.pixelsPerSecond.dy / -100;
            vPosition = wVScrollController.offset + 20 * delta; //details.delta.dy;
            if (vPosition > maxposition) vPosition = maxposition;
            if (vPosition <= maxposition) {
//              print(">>>>> d.velocity.pixelsPerSecond.dy  ${wVScrollController.offset} ----- ${vPosition} ----- ${delta}");
              wVScrollController.animateTo(vPosition, duration: Duration(milliseconds: 1000), curve: Curves.easeOutCubic);
            }
          } else if (dyPosition > 0) {
            final delta = d.velocity.pixelsPerSecond.dy / -100;
            vPosition = wVScrollController.offset + 20 * delta; //details.delta.dy;
            final minposition = wVScrollController.position.minScrollExtent;
            if (vPosition < minposition) vPosition = minposition;
            if (vPosition >= minposition) {
//              print(">>>>> d.velocity.pixelsPerSecond.dy  ${wVScrollController.offset} ----- ${vPosition} ----- ${delta}");
              wVScrollController.animateTo(vPosition, duration: Duration(milliseconds: 1000), curve: Curves.easeOutCubic);
            }
          }
//    ctrl!.animateWith(FrictionSimulation(0.05, ctrl!.value, d.velocity.pixelsPerSecond.dx / 100));
        },
        child: DaviTheme(
            child: wDavi,
            data: DaviThemeData(
              columnDividerColor: Colors.transparent,
              header: HeaderThemeData(
                color: gColors.greyLight,
                bottomBorderHeight: 2,
                bottomBorderColor: gColors.greyDark,
                columnDividerColor: Colors.transparent,
              ),
              headerCell: HeaderCellThemeData(height: 40, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 40, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: true),
              row: RowThemeData(
                hoverBackground: (rowIndex) => Colors.blue[50],
                dividerColor: gColors.greyDark,
              ),
              cell: CellThemeData(
                contentHeight: 44,
              ),
            )));
  }

  Color? _rowColor(DaviRow<Parc_Ent> row) {
    if (LastClickID == row.data.ParcsId) {
      return gColors.greyLight;
    }

    return null;
  }

  void _onHover(int? rowIndex) {
    print("_onHover rowIndex ${rowIndex}");
  }

  //**********************************
//**********************************
//**********************************

  void _onSelMove(Parc_Ent Parc_Ent) async {
    LastClickID = -1;
    print("_onSelMove ${DbTools.gRowSels.toString()} ${Parc_Ent.Parcs_order!}");
    await HapticFeedback.vibrate();
    await HapticFeedback.vibrate();
    await HapticFeedback.vibrate();

    if (isInSels(Parc_Ent.ParcsId!)) {
      print(">>>>>>>>>>>>>>>> _onSelMove SUPPRIME ${Parc_Ent.ParcsId}");

      for (int i = 0; i < DbTools.gRowSels.length; i++) {
        SelLig element = DbTools.gRowSels[i];
        if (element.Id == Parc_Ent.ParcsId) {
          DbTools.gRowSels.removeAt(i);
          break;
        }
      }

      if (DbTools.gRowSels.length == 0) DbTools.gRowisSel = false;
    } else if (DbTools.gRowSels.length == 0) {
      print(">>>>>>>>>>>>>>>> _onSelMove FIRST");

      DbTools.gParc_Ent = Parc_Ent;
      DbTools.gRowIndex = Parc_Ent.ParcsId!;

      DbTools.gRowisSel = true;
      NbAdd = 0;
      ctrlNbInsert.text = "${NbAdd}";

      DbTools.gRowSels.add(SelLig(DbTools.gRowIndex, Parc_Ent.Parcs_order!));
      print(">>>>>>>>>>>>>>>> _onSelMove  ADD FIRST ${DbTools.gRowIndex} ${Parc_Ent.Parcs_order}");

      if (Parc_Ent.Parcs_UUID_Parent!.isNotEmpty) {
        var wParcs_Ent = DbTools.glfParcs_Ent.where((element) => element.Parcs_UUID!.compareTo(Parc_Ent.Parcs_UUID_Parent!) == 0);
        if (wParcs_Ent.length > 0) {
          var aparSel = wParcs_Ent.first;
          print("aparSel Parent ${aparSel.ParcsId}");
          DbTools.gRowSels.add(SelLig(aparSel.ParcsId!, Parc_Ent.Parcs_order!));
          print(">>>>>>>>>>>>>>>> _onSelMove  ADD FIRST ${aparSel.ParcsId} ${Parc_Ent.Parcs_order}");
        }
      } else {
        var wParcs_Ent = DbTools.glfParcs_Ent.where((element) => element.Parcs_UUID_Parent!.compareTo(Parc_Ent.Parcs_UUID!) == 0);
        if (wParcs_Ent.length > 0) {
          var aparSel = wParcs_Ent.first;
          print("aparSel Child ${aparSel.ParcsId}");
          DbTools.gRowSels.add(SelLig(aparSel.ParcsId!, Parc_Ent.Parcs_order!));
          print(">>>>>>>>>>>>>>>> _onSelMove  ADD FIRST ${aparSel.ParcsId} ${Parc_Ent.Parcs_order}");
        }
      }
    } else {
      int wMin = 9999999;
      int wMax = -9999999;

      DbTools.gRowSels.forEach((wRowSel) {
        int wOrder = wRowSel.Ordre;

        if (wOrder > wMax) wMax = wOrder;
        if (wOrder < wMin) wMin = wOrder;
      });

      print(">>>>>>>>>>>>>>>> _onSelMove ${Parc_Ent.Parcs_order!} Min ${wMin} ${wMax}");

      if (Parc_Ent.Parcs_order! < wMin) {
        print("CLIC TO MIn  ${Parc_Ent.Parcs_order} => $wMin");
        for (int i = Parc_Ent.Parcs_order!; i < wMin; i++) {
          print("      i $i");
          int wID = 0;
          int wOrdre = 0;
          for (int j = 0; j < DbTools.lParcs_Ent.length; j++) {
            if (DbTools.lParcs_Ent[j].Parcs_order == i) {
              wID = DbTools.lParcs_Ent[j].ParcsId!;
              wOrdre = DbTools.lParcs_Ent[j].Parcs_order!;
              break;
            }
          }
          if (wID > 0) {
            print("Add $wID ordre ${i}");
            DbTools.gRowSels.add(SelLig(wID, wOrdre));
          }
        }
      } else if (Parc_Ent.Parcs_order! > wMin) {
        print("MIN TO CLICK $wMin => ${Parc_Ent.Parcs_order}");
        for (int i = wMin + 1; i <= Parc_Ent.Parcs_order!; i++) {
          int wID = 0;
          int wOrdre = 0;
          for (int j = 0; j < DbTools.lParcs_Ent.length; j++) {
            if (DbTools.lParcs_Ent[j].Parcs_order == i) {
              wID = DbTools.lParcs_Ent[j].ParcsId!;
              wOrdre = DbTools.lParcs_Ent[j].Parcs_order!;
              break;
            }
          }
          if (wID > 0) {
            for (int i = 0; i < DbTools.gRowSels.length; i++) {
              SelLig element = DbTools.gRowSels[i];
              if (element.Id == wID && element.Ordre == wOrdre) {
                wID = 0;
                break;
              }
            }
          }

          if (wID > 0) {
            print("Add $wID ordre ${i} ${DbTools.gRowSels.contains(SelLig(wID, wOrdre))}");
            DbTools.gRowSels.add(SelLig(wID, wOrdre));
          }
        }
      }
    }
    print("setSt 14");

    setState(() {});
  }

  void _onRowTap(BuildContext context, Parc_Ent Parc_Ent) async {
    if (DbTools.gRowisSel) {
      await HapticFeedback.vibrate();
      DbTools.gRowisSel = false;
      DbTools.gRowIndex = -1;
      DbTools.gRowSels.clear();
      print(" ${DbTools.gRowSels.length}");
      print("setSt 15");
      setState(() {});
      return;
    }
    LastClickID = Parc_Ent.ParcsId!;
    print("setSt 16");

    setState(() {});
  }

  void _onRowDoubleTap(BuildContext context, Parc_Ent Parc_Ent) async {
    if (DbTools.gRowisSel) {
      await HapticFeedback.vibrate();

      DbTools.gRowisSel = false;
      DbTools.gRowIndex = -1;
      DbTools.gRowSels.clear();
      print(" ${DbTools.gRowSels.length}");
      print("setSt 17");

      setState(() {});
      return;
    }

    DbTools.gParc_Ent = Parc_Ent;
    LastSelID = DbTools.gParc_Ent.ParcsId!;

    print("DbTools.gParc_Ent.ParcsId! ${DbTools.gParc_Ent.ParcsId!}");

//    Srv_DbTools.getParam_Gamme_Mem(DbTools.gParc_Ent.Parcs_Type!);

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> _onRowDoubleTap");

    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Saisie[i];

/*
      if (element.Param_Saisie_Type == "DESC")
        print("Param_Saisie  ${element.toMap()}");
*/


      await DbTools.getParcs_Desc_Id_Type_Add(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);
    }

    if (DbTools.gParc_Ent.Parcs_LOT_Label!.isEmpty) {
      DbTools.gParc_Ent.Parcs_LOT_Label = "Non renseigné sur l'équipement";
      DbTools.updateParc_Ent(DbTools.gParc_Ent);
    }

    if (DbTools.gParc_Ent.Parcs_SERIE_Label!.isEmpty) {
      DbTools.gParc_Ent.Parcs_SERIE_Label = "Non renseigné sur l'équipement";
      DbTools.updateParc_Ent(DbTools.gParc_Ent);
    }

    DbTools.glfParcs_Desc = await DbTools.getParcs_Desc(DbTools.gParc_Ent.ParcsId!);
    print("glfParcs_Desc.length ${DbTools.glfParcs_Desc.length}");
    DbTools.glfParcs_Desc.forEach((param_Saisie) {

//      print("glfParcs_Desc.length ${param_Saisie.toMap()}");




    });


    Srv_DbTools.FAB_Lib = "";
    Srv_DbTools.PRS_Lib = "";
    Srv_DbTools.CLF_Lib = "";
    Srv_DbTools.GAM_Lib = "";
    Srv_DbTools.REF_Lib = "";
    LastClickID = -1;

    Srv_DbTools.IsComplet = !"${DbTools.gParc_Ent.toString()} ${DbTools.glfParcs_Desc}".contains("---");

    await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupe_Parc_Inter_Entete()));
    Reload();
  }

  //*********************************************
  //*********************************************
  //*********************************************

  Future moveUP() async {
    if (DbTools.gRowSels.length == 1) {
      if ((DbTools.gParc_Ent.Parcs_order! > 1)) {
        await DbTools.moveParc_EntNew(DbTools.gParc_Ent.ParcsId!, -1);
      }
    } else {
      print("MoveUp Multi de ${DbTools.gRowSels[0].Ordre} à ${DbTools.gRowSels[DbTools.gRowSels.length - 1].Ordre}");
      int wIdPrec = 0;
      int wOrdrePrec = 0;
      DbTools.lParcs_Ent.sort(DbTools.EntSortOrderComparison);

      for (int j = 0; j < DbTools.lParcs_Ent.length; j++) {
//        print("DbTools.lParcs_Ent[j].Parcs_order ${DbTools.lParcs_Ent[j].Parcs_order} ${DbTools.gRowSels[0].Ordre}");

        if (DbTools.lParcs_Ent[j].Parcs_order == DbTools.gRowSels[0].Ordre) {
          break;
        } else {
          wIdPrec = DbTools.lParcs_Ent[j].ParcsId!;
          wOrdrePrec = DbTools.lParcs_Ent[j].Parcs_order!;
//          print("wOrdrePrec $wOrdrePrec");
        }
      }
      int LastSel = DbTools.gRowSels.length - 1;
      int LastSelID = DbTools.gRowSels[LastSel].Id;
      int LastSelOrdre = DbTools.gRowSels[LastSel].Ordre;

      print("aIdA $wIdPrec aIdB ${LastSelID} aOrdreA $wOrdrePrec aOrdreB ${LastSelOrdre}");

      await DbTools.moveParc_EntID2IDUp(wIdPrec, LastSelID, wOrdrePrec, LastSelOrdre);
    }
  }

  //*********************************************
  //*********************************************
  //*********************************************

  Future moveDOWN() async {
    if (DbTools.gRowSels.length == 1) {
      if ((DbTools.gParc_Ent.Parcs_order! < DbTools.lParcs_Ent[DbTools.lParcs_Ent.length - 1].Parcs_order!)) {
        await DbTools.moveParc_EntNew(DbTools.gParc_Ent.ParcsId!, 1);
      }
    } else {
      print("MoveUp Multi de ${DbTools.gRowSels[0].Ordre} à ${DbTools.gRowSels[DbTools.gRowSels.length - 1].Ordre}");
      int FirstSelID = DbTools.gRowSels[0].Id;
      int FirstSelOrdre = DbTools.gRowSels[0].Ordre;
      int LastSel = DbTools.gRowSels.length - 1;
      int LastSelID = DbTools.gRowSels[LastSel].Id;
      int LastSelOrdre = DbTools.gRowSels[LastSel].Ordre;
      int wIdSuiv = 0;
      int wOrdreSuiv = 0;
      DbTools.lParcs_Ent.sort(DbTools.EntSortOrderComparison);

      for (int j = 0; j < DbTools.lParcs_Ent.length; j++) {
        if (DbTools.lParcs_Ent[j].Parcs_order! > LastSelOrdre) {
          wIdSuiv = DbTools.lParcs_Ent[j].ParcsId!;
          wOrdreSuiv = DbTools.lParcs_Ent[j].Parcs_order!;
          break;
        }
      }
//      print("MoveUp Prec ${FirstSelID} ${wIdSuiv}  -- ${FirstSelOrdre} ${wOrdreSuiv}");
      await DbTools.moveParc_EntID2IDDown(FirstSelID, wIdSuiv, FirstSelOrdre, wOrdreSuiv);
    }
  }

  //*********************************************
//*********************************************
//*********************************************

  void onBottomIconPressed(int index) {
    DbTools.gCurrentIndex3 = index;
    DbTools.gRowisSel = false;
    DbTools.gRowIndex = -1;
    DbTools.gRowSels.clear();

    if (index == 0) {
      isBtnRel = false;
      isBtnDev = false;
      Filtre();
    } else if (index == 1) {
      isBtnRel = true;
      isBtnDev = false;
      Filtre();
    } else if (index == 4) {
      isBtnRel = false;
      isBtnDev = true;
      Filtre();
    } else {
      setState(() {});
    }
  }

//*********************************************
//*********************************************
//*********************************************
}
