import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:davi/davi.dart';
import 'package:fbroadcast/fbroadcast.dart';
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
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Imgs.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Img.dart';
import 'package:verifplus/Widget/Client/Client_Dialog.dart';
import 'package:verifplus/Widget/Client/Vue_Intervention.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_BC.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_BL.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Devis.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Entete.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Signature.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Tools.dart';
import 'package:verifplus/Widget/Widget_Tools/bottom_navigation_bar3.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Intervp extends StatefulWidget {
  const Client_Groupe_Parc_Intervp({super.key});

  @override
  Client_Groupe_Parc_IntervpState createState() => Client_Groupe_Parc_IntervpState();
}

class Client_Groupe_Parc_IntervpState extends State<Client_Groupe_Parc_Intervp> with TickerProviderStateMixin {
//  late TabController _tabController;
  bool affEdtFilter = false;

  bool canClose = false;

  late AnimationController acontroller;
  bool iStrfExp = false;
  bool iStrfImp = false;

  TextEditingController ctrlNbInsert = TextEditingController();
  int NbAdd = 1;
  final ctrlNbInsertfocusNode = FocusNode();

  TextEditingController ctrlPos = TextEditingController();
  int iPos = 1;
  final ctrlPosfocusNode = FocusNode();
  Timer? timer;
  bool _isButtonTapped = false;

  TextEditingController ctrlFilter = TextEditingController();
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

  final ScrollController wHScrollController = ScrollController();
  final ScrollController wVScrollController = ScrollController();

  List<Widget> widgets = [];
  final pageController = PageController(keepPage: false, initialPage: DbTools.gCurrentIndex3);

  bool btnSel_Aff = false;


  Future Reload() async {
    await Srv_ImportExport.getErrorSync();
//    await DbTools.Parc_Ent_GetOrder();

    await DbTools.getParam_Saisie_Base("Audit");
    Srv_DbTools.ListParam_Audit_Base.clear();
    Srv_DbTools.ListParam_Audit_Base.addAll(Srv_DbTools.ListParam_Saisie_Base);

    await DbTools.getParam_Saisie(Srv_DbTools.gIntervention.Intervention_Parcs_Type, "Audit");
    Srv_DbTools.ListParam_Audit_Base.addAll(Srv_DbTools.ListParam_Saisie);

    await DbTools.getParam_Saisie_Base("Verif");
    Srv_DbTools.ListParam_Verif_Base.clear();
    Srv_DbTools.ListParam_Verif_Base.addAll(Srv_DbTools.ListParam_Saisie_Base);

    await DbTools.getParam_Saisie(Srv_DbTools.gIntervention.Intervention_Parcs_Type, "Verif");
    Srv_DbTools.ListParam_Verif_Base.addAll(Srv_DbTools.ListParam_Saisie);

    await DbTools.getParam_Saisie_Base("Interv");
    Srv_DbTools.ListParam_Interv_Base.clear();
    Srv_DbTools.ListParam_Interv_Base.addAll(Srv_DbTools.ListParam_Saisie_Base);

    await DbTools.getParam_Saisie_Base("Desc");

    DbTools.glfParcs_Ent = await DbTools.getParcs_Ent(Srv_DbTools.gIntervention.InterventionId);

    for (int i = 0; i < DbTools.gRowSels.length; i++) {
      for (int j = 0; j < DbTools.lParcs_Ent.length; j++) {
        if (DbTools.lParcs_Ent[j].ParcsId == DbTools.gRowSels[i].Id) {
          DbTools.gRowSels[i].Ordre = DbTools.lParcs_Ent[j].Parcs_order!;
          break;
        }
      }
    }

    DbTools.glfParcs_Desc = await DbTools.getParcs_DescInter(Srv_DbTools.gIntervention.InterventionId);

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

    await DbTools.getParam_Saisie(Srv_DbTools.gIntervention.Intervention_Parcs_Type, "Desc");
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie eP = Srv_DbTools.ListParam_Saisie[i];
    }

    String DescAffnewParam = "";
    Srv_DbTools.getParam_ParamMemDet("Param_Div", "${Srv_DbTools.gIntervention.Intervention_Parcs_Type}_Desc");
    if (Srv_DbTools.ListParam_Param.isNotEmpty) DescAffnewParam = Srv_DbTools.ListParam_Param[0].Param_Param_Text;

    //DescAffnewParam PDT POIDS PRS MOB / ZNE EMP NIV / ANN / FAB
    List<Param_Saisie> listparamSaisieTmp = [];
    listparamSaisieTmp.addAll(Srv_DbTools.ListParam_Saisie);
    listparamSaisieTmp.addAll(Srv_DbTools.ListParam_Saisie_Base);

    bool isRelEnt = false;



    countX = 0;
    countTot = 0;
    wTimer = 0;

    for (int jj = 0; jj < DbTools.glfParcs_Ent.length; jj++) {
      Parc_Ent elementEnt = DbTools.glfParcs_Ent[jj];

      print("♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎ elementEnt ${elementEnt.Parcs_InterventionId} ${elementEnt.Parcs_order}");

      countTot++;
      if (elementEnt.Parcs_Date_Rev!.isNotEmpty) countX++;

      try {
        wTimer += elementEnt.Parcs_Intervention_Timer!;
      } catch (e) {
        print(e);
      }

      DescAff = DescAffnewParam;
      List<String?>? parcsCols = [];

      for (int j = 0; j < listparamSaisieTmp.length; j++) {
        Param_Saisie paramSaisie = listparamSaisieTmp[j];

        if (paramSaisie.Param_Saisie_Affichage.compareTo("DESC") == 0) {
          if (paramSaisie.Param_Saisie_ID.compareTo("FREQ") == 0) {
            DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(elementEnt.Parcs_FREQ_Label!, paramSaisie.Param_Saisie_ID));
          } else if (paramSaisie.Param_Saisie_ID.compareTo("ANN") == 0) {
            DbTools.gDateMS = elementEnt.Parcs_ANN_Label!;
            String s = gColors.AbrevTxt_Param_Param(elementEnt.Parcs_ANN_Label!, paramSaisie.Param_Saisie_ID);
            int pos = s.indexOf('-');
            String ws = (pos != -1) ? s.substring(pos + 1) : s;
            DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, ws);
          } else if (paramSaisie.Param_Saisie_ID.compareTo("AFAB") == 0) {
            DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(elementEnt.Parcs_FAB_Label!, paramSaisie.Param_Saisie_ID));
          } else if (paramSaisie.Param_Saisie_ID.compareTo("NIV") == 0) {
            DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(elementEnt.Parcs_NIV_Label!, paramSaisie.Param_Saisie_ID));
          } else if (paramSaisie.Param_Saisie_ID.compareTo("ZNE") == 0) {
            DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(elementEnt.Parcs_ZNE_Label!, paramSaisie.Param_Saisie_ID));
          } else if (paramSaisie.Param_Saisie_ID.compareTo("EMP") == 0) {
            DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(elementEnt.Parcs_EMP_Label!, paramSaisie.Param_Saisie_ID));
          } else if (paramSaisie.Param_Saisie_ID.compareTo("LOT") == 0) {
            DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(elementEnt.Parcs_LOT_Label!, paramSaisie.Param_Saisie_ID));
          } else if (paramSaisie.Param_Saisie_ID.compareTo("SERIE") == 0) {
            DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(elementEnt.Parcs_SERIE_Label!, paramSaisie.Param_Saisie_ID));
          } else {
            bool trv = false;
            for (int j = 0; j < DbTools.glfParcs_Desc.length; j++) {
              Parc_Desc element2 = DbTools.glfParcs_Desc[j];
              if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && paramSaisie.Param_Saisie_ID == element2.ParcsDesc_Type) {
                DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, paramSaisie.Param_Saisie_ID));
                trv = true;
              }
            }
            if (!trv) DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, "");
          }
        } else if (paramSaisie.Param_Saisie_ID.compareTo("DESC2") == 0) {
          bool trv = false;
          for (int j = 0; j < DbTools.glfParcs_Desc.length; j++) {
            Parc_Desc element2 = DbTools.glfParcs_Desc[j];
            if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && paramSaisie.Param_Saisie_ID == element2.ParcsDesc_Type) {
              DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, paramSaisie.Param_Saisie_ID));
              trv = true;
            }
          }
          if (!trv) DescAff = DescAff.replaceAll(paramSaisie.Param_Saisie_ID, "");
        }

        if (paramSaisie.Param_Saisie_Affichage.compareTo("COL") == 0) {
          for (int j = 0; j < DbTools.glfParcs_Desc.length; j++) {
            Parc_Desc element2 = DbTools.glfParcs_Desc[j];
            if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && paramSaisie.Param_Saisie_ID == element2.ParcsDesc_Type) {
              parcsCols.add(element2.ParcsDesc_Lib);
            }
          }
        }
      }

      if (DescAff.compareTo(DescAffnewParam) == 0) DescAff = "";
      String wTmp = DescAff;
      wTmp = wTmp.replaceAll("---", "");
      wTmp = wTmp.replaceAll("/", "");
      wTmp = wTmp.replaceAll(" ", "");

      if (wTmp.isEmpty) DescAff = "";
      elementEnt.Parcs_Date_Desc = DescAff;
      elementEnt.Parcs_Cols = parcsCols;

      String parcsdescTypeVeriftrim2 = "";
      Parc_Desc parcDescVeriftrim2 = Parc_Desc();
      String parcsdescTypeVerifann2 = "";
      Parc_Desc parcDescVerifann2 = Parc_Desc();
      String parcsdescTypeVerifquin2 = "";
      Parc_Desc parcDescVerifquin2 = Parc_Desc();
      String parcsdescTypeVerifdec2 = "";
      Parc_Desc parcDescVerifdec2 = Parc_Desc();

      String parcsdescTypeDesc = "";
      String parcsdescTypePdt = "";
      Parc_Desc parcDescDesc = Parc_Desc();
      Parc_Desc parcDescPdt = Parc_Desc();

      String parcsdescTypeInst = "";
      String parcsdescTypeVerifann = "";
      String parcsdescTypeRech = "";
      String parcsdescTypeMaa = "";
      String parcsdescTypeCharge = "";
      String parcsdescTypeRa = "";
      String parcsdescTypeRes = "";
      String parcsdescTypeEch = "";
      String parcsdescTypeEtatgen = "";
      String parcsdescTypeAcc = "";

      elementEnt.Parcs_VRMC = "";

      print(" elementEnt.Parcs_VRMC ${elementEnt.Parcs_VRMC}");

      for (int jjj = 0; jjj < DbTools.glfParcs_Desc.length; jjj++) {
        Parc_Desc element2 = DbTools.glfParcs_Desc[jjj];

        if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId) {
          if (element2.ParcsDesc_Type!.compareTo("VerifTrim2") == 0) {
            parcsdescTypeVeriftrim2 = element2.ParcsDesc_Lib!;
            parcDescVeriftrim2 = element2;
          }
          if (element2.ParcsDesc_Type!.compareTo("VerifAnn2") == 0) {
            parcsdescTypeVerifann2 = element2.ParcsDesc_Lib!;
            parcDescVerifann2 = element2;
          }
          if (element2.ParcsDesc_Type!.compareTo("VerifQuin2") == 0) {
            parcsdescTypeVerifquin2 = element2.ParcsDesc_Lib!;
            parcDescVerifquin2 = element2;
          }
          if (element2.ParcsDesc_Type!.compareTo("VerifDec2") == 0) {
            parcsdescTypeVerifdec2 = element2.ParcsDesc_Lib!;
            parcDescVerifdec2 = element2;
          }
          if (element2.ParcsDesc_Type!.compareTo("PDT") == 0) {
            parcsdescTypePdt = element2.ParcsDesc_Lib!;
            parcDescPdt = element2;
          }

          if (element2.ParcsDesc_Type!.compareTo("Inst") == 0) {
            parcsdescTypeInst = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("Inst2") == 0) {
            parcsdescTypeInst = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("VerifAnn") == 0) {
            parcsdescTypeVerifann = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("Rech") == 0) {
            parcsdescTypeRech = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("MAA") == 0) {
            parcsdescTypeMaa = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("Charge") == 0) {
            parcsdescTypeCharge = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("RA") == 0) {
            parcsdescTypeRa = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("RES") == 0) {
            parcsdescTypeRes = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("RES2") == 0) {
            parcsdescTypeRes = element2.ParcsDesc_Lib!;
          }
          if (element2.ParcsDesc_Type!.compareTo("Ech") == 0) {
            parcsdescTypeEch = element2.ParcsDesc_Lib!;
          }

          if (element2.ParcsDesc_Type!.compareTo("EtatGen") == 0) {
            parcsdescTypeEtatgen = element2.ParcsDesc_Lib!;
          }

          if (element2.ParcsDesc_Type!.compareTo("Acc") == 0) {
            parcsdescTypeAcc = element2.ParcsDesc_Lib!;
          }
        }
      }

      DbTools.lParcs_Art = await DbTools.getParcs_Art_AllType(elementEnt.ParcsId!);
      bool isRel = false;
      bool isDevis = false;
      for (int ji = 0; ji < DbTools.lParcs_Art.length; ji++) {
        Parc_Art wparcArt = DbTools.lParcs_Art[ji];
        if (wparcArt.ParcsArt_Livr!.substring(0, 1).contains("R")) {
          isRel = true;
          break;
        }
        if (wparcArt.ParcsArt_Fact!.contains("Dev")) {
          isDevis = true;
          break;
        }
      }

      elementEnt.Livr = isRel ? "R" : "";
      elementEnt.Devis = isDevis ? "D" : "";
      await DbTools.updateParc_Ent_Livr(elementEnt);

      if (isRel) isRelEnt = true;

      DbTools.lParcs_Art = await DbTools.getParcs_Art(elementEnt.ParcsId!, "ES");
      if (DbTools.lParcs_Art.isNotEmpty) {
        Parc_Art parcArt = DbTools.lParcs_Art[0];
//        print("parc_Art ${parc_Art.toString()}");
        parcsdescTypeEch = "${parcArt.ParcsArt_Id} ${parcArt.ParcsArt_Lib}";
      }

      if (elementEnt.Parcs_UUID_Parent!.isNotEmpty) {
        elementEnt.Parcs_VRMC = "???";
        if (parcsdescTypeInst.compareTo("---") != 0 && parcsdescTypeInst.isNotEmpty) {
          elementEnt.Parcs_VRMC = "MS";
        }
      } else if (parcsdescTypeRes.compareTo("---") != 0 && parcsdescTypeRes.isNotEmpty) {
        elementEnt.Parcs_VRMC = "ES";
        if (parcsdescTypeRes.compareTo("Disparu") == 0) elementEnt.Parcs_VRMC = "DISP";
        if (parcsdescTypeRes.compareTo("20ans") == 0) elementEnt.Parcs_VRMC = "REF";
        if (parcsdescTypeRes.compareTo("Choc cuve") == 0) elementEnt.Parcs_VRMC = "REF";
        if (parcsdescTypeRes.compareTo("Sérigraphie") == 0) elementEnt.Parcs_VRMC = "REF";
//        if (ParcsDesc_Type_Ech.compareTo("---") == 0) elementEnt.Parcs_VRMC = "REF";
      } else if (parcsdescTypeRa.compareTo("---") != 0 && parcsdescTypeRa.isNotEmpty)
        elementEnt.Parcs_VRMC = "RA";
      else if (parcsdescTypeVerifdec2.compareTo("---") != 0 && parcsdescTypeVerifdec2.isNotEmpty)
        elementEnt.Parcs_VRMC = "VD";
      else if (parcsdescTypeVerifquin2.compareTo("---") != 0 && parcsdescTypeVerifquin2.isNotEmpty)
        elementEnt.Parcs_VRMC = "VQ";
      else if (parcsdescTypeVerifann2.compareTo("---") != 0 && parcsdescTypeVerifann2.isNotEmpty)
        elementEnt.Parcs_VRMC = "VA";
      else if (parcsdescTypeVeriftrim2.compareTo("---") != 0 && parcsdescTypeVeriftrim2.isNotEmpty)
        elementEnt.Parcs_VRMC = "VT";
      else if (parcsdescTypeMaa.compareTo("---") != 0 && parcsdescTypeMaa.isNotEmpty)
        elementEnt.Parcs_VRMC = "MAA";
      else if (parcsdescTypeCharge.compareTo("---") != 0 && parcsdescTypeCharge.isNotEmpty)
        elementEnt.Parcs_VRMC = "CHGE";
      else if (parcsdescTypeRech.compareTo("---") != 0 && parcsdescTypeRech.isNotEmpty)
        elementEnt.Parcs_VRMC = "RECH";
      else if (parcsdescTypeVerifann.compareTo("---") != 0 && parcsdescTypeVerifann.isNotEmpty)
        elementEnt.Parcs_VRMC = "VF";
      else if (parcsdescTypeEtatgen.compareTo("Disparu") == 0)
        elementEnt.Parcs_VRMC = "DISP";
      else if (parcsdescTypeAcc.compareTo("Inaccessible") == 0)
        elementEnt.Parcs_VRMC = "INAC";
      else if (parcsdescTypeInst.compareTo("---") != 0 && parcsdescTypeInst.isNotEmpty) {
        elementEnt.Parcs_VRMC = "MS";
      } else
        elementEnt.Parcs_VRMC = "---";

      elementEnt.Action = elementEnt.Parcs_VRMC;
      DbTools.updateParc_Ent_Action(elementEnt);
//      if (elementEnt.Parcs_Date_Desc!.isEmpty) elementEnt.Parcs_VRMC = "---";

      bool parcsMaintprev = true;
      bool parcsMaintcorrect = true;
      bool parcsInstall = true;

      if (parcsdescTypeDesc.isNotEmpty && parcsdescTypeDesc.compareTo("---") != 0) {
        Srv_DbTools.getUser_Hab_Desc(parcDescDesc.ParcsDescId!);
        if (parcsMaintprev != Srv_DbTools.User_Desc_MaintPrev) parcsMaintprev = Srv_DbTools.User_Desc_MaintPrev;
        if (parcsMaintcorrect != Srv_DbTools.User_Desc_MaintCorrect) parcsMaintcorrect = Srv_DbTools.User_Desc_MaintCorrect;
        if (parcsInstall != Srv_DbTools.User_Desc_Install) parcsInstall = Srv_DbTools.User_Desc_Install;
      }

      if (parcsdescTypePdt.isNotEmpty && parcsdescTypePdt.compareTo("---") != 0) {
        Srv_DbTools.getUser_Hab_PDT(parcDescPdt.ParcsDesc_Lib!);
        if (parcsMaintprev != Srv_DbTools.User_Hab_MaintPrev) parcsMaintprev = Srv_DbTools.User_Hab_MaintPrev;
        if (parcsMaintcorrect != Srv_DbTools.User_Hab_MaintCorrect) parcsMaintcorrect = Srv_DbTools.User_Hab_MaintCorrect;
        if (parcsInstall != Srv_DbTools.User_Hab_Install) parcsInstall = Srv_DbTools.User_Hab_Install;
      }

      bool Maj = false;
      if (elementEnt.Parcs_MaintPrev != parcsMaintprev) {
        elementEnt.Parcs_MaintPrev = parcsMaintprev;
        Maj = true;
      }
      if (elementEnt.Parcs_MaintCorrect != parcsMaintcorrect) {
        elementEnt.Parcs_MaintCorrect = parcsMaintcorrect;
        Maj = true;
      }
      if (elementEnt.Parcs_Install != parcsInstall) {
        elementEnt.Parcs_Install = parcsInstall;
        Maj = true;
      }

      if (elementEnt.Parcs_UUID_Parent!.isNotEmpty) {
        DbTools.lParcs_Art = await DbTools.getParcs_Art(elementEnt.ParcsId!, "MS");
        print(" DbTools.lParcs_Art  B ${DbTools.lParcs_Art.length}");
        if (DbTools.lParcs_Art.isNotEmpty) {
          Parc_Art wparcArt = DbTools.lParcs_Art[0];
          print(" wParc_Art  B ${wparcArt.toMap()}");
          if (wparcArt.ParcsArt_Fact == "Devis") {
            elementEnt.Parcs_Date_Desc = "➜ [Devis] ${elementEnt.Parcs_Date_Desc}";
          } else {
            elementEnt.Parcs_Date_Desc = "➜ [Neuf] ${elementEnt.Parcs_Date_Desc}";
          }
        } else {
          elementEnt.Parcs_Date_Desc = "➜ ${elementEnt.Parcs_Date_Desc}";
        }
      }
    }

    Srv_DbTools.gIntervention.Livr = isRelEnt ? "R" : "";

    if (Srv_DbTools.gIntervention.Intervention_Status.contains("Planifiée")) {
      if (wTimer > 0) Srv_DbTools.gIntervention.Intervention_Status = "En cours";
    }

    await Srv_ImportExport.Intervention_Export_Update(Srv_DbTools.gIntervention);

    print("Filter >>>>"
        "");
    await Filtre();
    print("Reload Fin");
  }

  DaviModel<Parc_Ent>? _model;

  Future Filtre() async {
    int index = subLibArray.indexWhere((element) => element.compareTo(DbTools.ParamTypeOg) == 0);

    List<Parc_Ent> wparcsEnt = [];
    List<Parc_Ent> wparcsEnt2 = [];
    DbTools.lParcs_Ent.clear();

    for (int i = 0; i < DbTools.glfParcs_Ent.length; i++) {
      Parc_Ent element = DbTools.glfParcs_Ent[i];

      if (filterText.isEmpty) {
        wparcsEnt.add(element);
      } else {
        if (element.Parcs_Date_Desc!.toUpperCase().contains(filterText.toUpperCase())) {
          wparcsEnt.add(element);
        }
      }

      //    }
    }

    DbTools.gCountRel = 0;
    DbTools.gCountDev = 0;
    for (int i = 0; i < wparcsEnt.length; i++) {
      Parc_Ent element = wparcsEnt[i];
      if (element.Livr!.compareTo("R") == 0) DbTools.gCountRel++;
      if (element.Devis!.isNotEmpty) DbTools.gCountDev++;
    }

    if (!isBtnRel) {
      wparcsEnt2.addAll(wparcsEnt);
    } else {
      for (int i = 0; i < wparcsEnt.length; i++) {
        Parc_Ent element = wparcsEnt[i];
        if (element.Livr!.compareTo("R") == 0) wparcsEnt2.add(element);
      }
    }

    if (!isBtnDev) {
      DbTools.lParcs_Ent.addAll(wparcsEnt2);
    } else {
      for (int i = 0; i < wparcsEnt2.length; i++) {
        Parc_Ent element = wparcsEnt2[i];
        print("element Devis ${element.Parcs_order} ${element.Devis}");
        if (element.Devis!.isNotEmpty) DbTools.lParcs_Ent.add(element);
      }
    }

    List<DaviColumn<Parc_Ent>> wColumns = [
      DaviColumn(
          name: 'N°',
          cellStyleBuilder: (row) => DbTools.gRowisSel && isInSels(row.data.ParcsId!)
              ? CellStyle(background: gColors.GrdBtn_Colors1Sel, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_W)
              : isInSels(row.data.ParcsId!)
                  ? CellStyle(background: gColors.tks, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_W)
                  : LastClickID == row.data.ParcsId
                      ? CellStyle(background: Colors.blue, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_G)
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
                          ? const SizedBox(
                              width: 15,
                              child: Icon(
                                Icons.adjust,
                                color: Colors.orange,
                                size: 10,
                              ))
                          : Container(
                              width: 15,
                            ),
                      Text(
                        "${row.data.Parcs_order}",
                        style: row.data.Livr!.isNotEmpty ? gColors.bodySaisie_B_O.copyWith(color: LastClickID == row.data.ParcsId ? Colors.white : null) : gColors.bodySaisie_B_G,
                      ),
                    ],
                  )),
              onLongPress: () => _onSelMove(row.data),
              onTap: () => _onRowTap(context, row.data),
            );
          },
          width: 60),
      DaviColumn(name: DbTools.ParamTypeOg, stringValue: (row) => "${row.Parcs_Date_Desc}", width: gColors.MediaQuerysizewidth - 218, cellStyleBuilder: (row) => CellStyle(textStyle: row.data.Livr!.isNotEmpty ? gColors.bodySaisie_B_O.copyWith(color: LastClickID == row.data.ParcsId ? Colors.white : null) : gColors.bodySaisie_B_G.copyWith(color: LastClickID == row.data.ParcsId ? Colors.white : null))),
      DaviColumn(name: 'Visite', stringValue: (row) => row.Parcs_Date_Rev!.isEmpty ? '' : DateFormat('dd/MM/yy').format(DateTime.parse(row.Parcs_Date_Rev!)), width: 75, cellStyleBuilder: (row) => CellStyle(textStyle: row.data.Livr!.isNotEmpty ? gColors.bodySaisie_B_O.copyWith(color: LastClickID == row.data.ParcsId ? Colors.white : null) : gColors.bodySaisie_B_G.copyWith(color: LastClickID == row.data.ParcsId ? Colors.white : null))),
      DaviColumn(
          name: 'Action',
          cellAlignment: Alignment.centerRight,
          cellPadding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          cellBuilder: (BuildContext context, DaviRow<Parc_Ent> row) {
            return Container(
              child: row.data.Parcs_VRMC!.isEmpty ? Container() : Text("${row.data.Parcs_VRMC} >", textAlign: TextAlign.right, style: row.data.Livr!.isNotEmpty ? gColors.bodySaisie_B_O.copyWith(color: LastClickID == row.data.ParcsId ? Colors.white : null) : gColors.bodySaisie_B_G.copyWith(color: LastClickID == row.data.ParcsId ? Colors.white : Colors.green)),
            );
          },
          width: 65),
    ];

    _model = DaviModel<Parc_Ent>(rows: DbTools.lParcs_Ent, columns: wColumns);

    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  final ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    setState(() {});
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print("HOME _updateConnectionStatus");
    await DbTools.checkConnection();
    setState(() {});
  }

  @override
  void initState() {
    DbTools.gRowisSel = false;
    DbTools.gRowIndex = -1;
    DbTools.gRowSels.clear();

    lGrdBtnGrp.add(GrdBtnGrp(GrdBtnGrpId: 4, GrdBtnGrp_Color: Colors.black, GrdBtnGrp_ColorSel: Colors.black, GrdBtnGrp_Txt_Color: Colors.white, GrdBtnGrp_Txt_ColorSel: Colors.red, GrdBtnGrpSelId: [0], GrdBtnGrpType: 0));

    subTitleArray.clear();
    ListParam_ParamTypeOg.clear();

    int i = 0;
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
        print("element ${element.Param_Param_ID}  ${element.Param_Param_Text}");
        if (element.Param_Param_ID.compareTo("Base") != 0) {
          lGrdBtn.add(GrdBtn(GrdBtnId: i++, GrdBtn_GroupeId: 4, GrdBtn_Label: element.Param_Param_ID));
          subTitleArray.add(element.Param_Param_ID);
          subLibArray.add(element.Param_Param_Text);
          ListParam_ParamTypeOg.add(element);
        }
      }
    }

    DbTools.ParamTypeOg = subLibArray[0];

    initLib();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    ctrlNbInsert.text = "$NbAdd";
    ctrlPos.text = "$iPos";

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
    for (var element in lGrdBtn) {
      if (element.GrdBtnId == Id) {
        wGrdBtn = element;
      }
    }
    return wGrdBtn;
  }

  GrdBtnGrp getGrdBtnGrp(int Id) {
    GrdBtnGrp wGrdBtnGrp = GrdBtnGrp(GrdBtnGrpId: -1, GrdBtnGrp_Color: Colors.white);
    for (var element in lGrdBtnGrp) {
      if (element.GrdBtnGrpId == Id) {
        wGrdBtnGrp = element;
      }
    }
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
    return SizedBox(
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
                        for (var element in DbTools.lParcs_Ent) {
                          if (element.Parcs_QRCode!.compareTo(QrcValue) == 0) {
                            _onRowDoubleTap(context, element);
                          }
                        }
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


          InkWell(
              child: SizedBox(
                width: icoWidth + 10,
                child: Stack(children: <Widget>[
                  Image.asset(
                    btnSel_Aff ? "assets/images/DCL_AffSel.png" : "assets/images/DCL_Aff.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ]),
              ),
              onTap: () async {
                await HapticFeedback.vibrate();
                btnSel_Aff = !btnSel_Aff;
                setState(() {

                });
              }),



          const Spacer(),
          SizedBox(
            width: 50,
            child: Text(
              '$countX / $countTot',
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
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(
                "assets/images/Btn_Loupe.png",
                height: icoWidth,
                width: icoWidth,
              ),
            ),
            onTap: () async {
              await HapticFeedback.vibrate();
              affEdtFilter = !affEdtFilter;
              setState(() {});
            })
        : SizedBox(
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
                      await HapticFeedback.vibrate();
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

  void onMaj() async {
    print("•••••••••• Parent onMaj() Relaod()");
  }

  @override
  Widget Import_Export() {
    return Padding(
      padding: const EdgeInsets.only(left: 70, right: 30.0, bottom: 140.0),
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
                  elevation: 10.0,
                  backgroundColor: DbTools.hasConnection ? gColors.primaryGreen : Colors.black26,
                  onPressed: () async {
                    if (!DbTools.hasConnection) {
                      await OffLine();
                      await Srv_ImportExport.getErrorSync();
                      setState(() {});
                      return;
                    }

                    List<Parc_Ent> lparcsEnt = await DbTools.getParcs_Ent_Upd(Srv_DbTools.gIntervention.InterventionId);
                    print("lParcs_Ent lenght ${lparcsEnt.length}");

                    if (lparcsEnt.isNotEmpty) {
                      await gObj.AffMessageInfo(context, "Verif Plus", "Vous avez des organes à transférer sur le serveur avant d'importer");
                      return;
                    }
                    print("setSt 6");

                    setState(() {
                      acontroller.forward();
                      acontroller.repeat(reverse: true);
                      iStrfImp = true;
                    });

                    await Srv_DbTools.getParc_EntID(Srv_DbTools.gIntervention.InterventionId);
                    print("♦︎♦︎ IMPORT ♦︎♦︎ ListParc_Ent lenght ${Srv_DbTools.ListParc_Ent.length}");

                    for (int i = 0; i < Srv_DbTools.ListParc_Ent.length; i++) {
                      Parc_Ent_Srv xparcEntSrv = Srv_DbTools.ListParc_Ent[i];
//                      print("♦︎♦︎ IMPORT ♦︎♦︎ ListParc_Ent ${xParc_Ent_Srv.Parcs_InterventionId} ${xParc_Ent_Srv.Parcs_order}");
                    }

                    await Srv_DbTools.getParcs_DescInter(Srv_DbTools.gIntervention.InterventionId);
                    print("♦︎♦︎ IMPORT ♦︎♦︎ ListParc_Desc lenght ${Srv_DbTools.ListParc_Desc.length}");

                    await Srv_DbTools.getParcs_ArtInter(Srv_DbTools.gIntervention.InterventionId);
                    print("♦︎♦︎ IMPORT ♦︎♦︎ ListParc_Art lenght ${Srv_DbTools.ListParc_Art.length}");

                    await Srv_DbTools.getParcs_ArtInterSO(Srv_DbTools.gIntervention.InterventionId);
                    print("♦︎♦︎ IMPORT ♦︎♦︎ ListParc_ArtSO lenght ${Srv_DbTools.ListParc_ArtSO.length}");

                    await Srv_DbTools.getParcs_ImgsInter(Srv_DbTools.gIntervention.InterventionId);
                    print("♦︎♦︎ IMPORT ♦︎♦︎ ListParc_Imgs lenght ${Srv_DbTools.ListParc_Imgs.length}");

                    for (int i = 0; i < Srv_DbTools.ListParc_Art.length; i++) {
                      Parc_Art_Srv element = Srv_DbTools.ListParc_Art[i];
                    }

                    print("***************** DELETE ****************");

                    // DELETE

                    await DbTools.deleteParc_EntInter(Srv_DbTools.gIntervention.InterventionId);

                    List<Parc_Art> wparcsArt = await DbTools.getParcs_ArtInter(Srv_DbTools.gIntervention.InterventionId);
                    for (int i = 0; i < wparcsArt.length; i++) {
                      Parc_Art xparcArt = wparcsArt[i];
                      await DbTools.deleteParc_Art(xparcArt.ParcsArtId!);
                    }

                    wparcsArt = await DbTools.getParcs_ArtInterSO(Srv_DbTools.gIntervention.InterventionId);
                    for (int i = 0; i < wparcsArt.length; i++) {
                      Parc_Art xparcArt = wparcsArt[i];
                      await DbTools.deleteParc_Art(xparcArt.ParcsArtId!);
                    }

                    List<Parc_Desc> wparcsDesc = await DbTools.getParcs_DescInter(Srv_DbTools.gIntervention.InterventionId);
                    for (int i = 0; i < wparcsDesc.length; i++) {
                      Parc_Desc xparcDesc = wparcsDesc[i];
                      await DbTools.deleteParc_Desc(xparcDesc.ParcsDescId!);
                    }

                    List<Parc_Img> wparcsImg = await DbTools.getParcs_ImgInter(Srv_DbTools.gIntervention.InterventionId);
                    for (int i = 0; i < wparcsImg.length; i++) {
                      Parc_Img xparcImg = wparcsImg[i];
                      await DbTools.deleteParc_ImgAllType(xparcImg.Parc_Imgs_ParcsId!);
                    }

                    // INSERT
                    print("***************** INSERT ****************");

                    print("♦︎♦︎ IMPORT ♦︎♦︎ ListParc_ArtSO lenght ${Srv_DbTools.ListParc_ArtSO.length}");

                    for (int i = 0; i < Srv_DbTools.ListParc_ArtSO.length; i++) {
                      Parc_Art_Srv xparcArtSrv = Srv_DbTools.ListParc_ArtSO[i];
                      xparcArtSrv.ParcsArtId = null;
                      xparcArtSrv.ParcsArt_ParcsId = Srv_DbTools.gIntervention.InterventionId;

                      print("♦︎♦︎ IMPORT ♦︎♦︎ ListParc_ArtSO INSERT ${xparcArtSrv.toMap()}");

                      await DbTools.insertParc_Art_Srv(xparcArtSrv);
                    }

                    for (int i = 0; i < Srv_DbTools.ListParc_Ent.length; i++) {
                      Parc_Ent_Srv xparcEntSrv = Srv_DbTools.ListParc_Ent[i];
                      int ParcsId = xparcEntSrv.ParcsId!;
                      xparcEntSrv.ParcsId = null;

                      await DbTools.insertParc_Ent_Srv(xparcEntSrv);
                      int gLastID = DbTools.gLastID;

                      for (int i = 0; i < Srv_DbTools.ListParc_Desc.length; i++) {
                        Parc_Desc_Srv xparcDescSrv = Srv_DbTools.ListParc_Desc[i];
                        if (xparcDescSrv.ParcsDesc_ParcsId == ParcsId) {
                          xparcDescSrv.ParcsDescId = null;
                          xparcDescSrv.ParcsDesc_ParcsId = gLastID;
                          await DbTools.insertParc_Desc_Srv(xparcDescSrv);
                        }
                      }

                      for (int i = 0; i < Srv_DbTools.ListParc_Art.length; i++) {
                        Parc_Art_Srv xparcArtSrv = Srv_DbTools.ListParc_Art[i];
                        if (xparcArtSrv.ParcsArt_ParcsId == ParcsId) {
                          xparcArtSrv.ParcsArtId = null;
                          xparcArtSrv.ParcsArt_ParcsId = gLastID;
                          await DbTools.insertParc_Art_Srv(xparcArtSrv);
                        }
                      }

                      for (int i = 0; i < Srv_DbTools.ListParc_Imgs.length; i++) {
                        Parc_Imgs_Srv xparcImgsSrv = Srv_DbTools.ListParc_Imgs[i];
                        if (xparcImgsSrv.Parc_Imgs_ParcsId == ParcsId) {
                          xparcImgsSrv.Parc_Imgid = null;
                          xparcImgsSrv.Parc_Imgs_ParcsId = gLastID;

                          print(" xParc_Imgs_Srv.Parc_Imgs_Data!.length ${xparcImgsSrv.Parc_Imgs_Data!.length}");

                          await DbTools.insertParc_Img_Srv(xparcImgsSrv);
                        }
                      }
                    }
                    print("setSt 7");

                    setState(() {
                      acontroller.stop();
                      iStrfImp = false;
                    });

                    await Reload();
                    List<Parc_Art> zparcsArt = await DbTools.getParcs_ArtInter(Srv_DbTools.gIntervention.InterventionId);
                    List<Parc_Desc> zparcsDesc = await DbTools.getParcs_DescInter(Srv_DbTools.gIntervention.InterventionId);
                    List<Parc_Img> zparcImg = await DbTools.getParcs_ImgInter(Srv_DbTools.gIntervention.InterventionId);

                    String wStr = "Import de ${Srv_DbTools.ListParc_Ent.length} organes terminé\n\n"
/*
                        "- ${Srv_DbTools.ListParc_Desc.length} descriptions\n"
                        "- ${Srv_DbTools.ListParc_Art.length} Articles - ${Srv_DbTools.ListParc_Imgs.length} zImages\n"
*/
                        "- ${zparcsDesc.length} descriptions\n"
                        "- ${zparcsArt.length} Articles\n"
                        "- ${zparcImg.length} Images ";

                    print(" $wStr");

                    for (int i = 0; i < zparcImg.length; i++) {
                      Parc_Img xparcImgsSrv = zparcImg[i];

                      print("xParc_Imgs_Srv ${xparcImgsSrv.toMap()}");
                    }

                    await gObj.AffMessageInfo(context, "Verif Plus", wStr);

                    if (DbTools.glfParcs_Ent.isEmpty) {
                      print("Client_Groupe_Parc_Inter <<<<<<<<<<<<<<<<<<< AAA ${Srv_DbTools.gIntervention.InterventionId} ${Srv_DbTools.gIntervention.Intervention_Type} >>>>>>>>>>>>>>>>>>>>>");
                      Parc_Ent wparcEnt = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId, Srv_DbTools.gIntervention.Intervention_Parcs_Type, 0);
                      print("Client_Groupe_Parc_Inter <<<<<<<<<<<<<<<<<<< BBB>>>>>>>>>>>>>>>>>>>>>");
                      DbTools.insertParc_Ent(wparcEnt);
                      print("Client_Groupe_Parc_Inter <<<<<<<<<<<<<<<<<<< CCC>>>>>>>>>>>>>>>>>>>>>");
                      DbTools.glfParcs_Ent = await DbTools.getParcs_Ent(Srv_DbTools.gIntervention.InterventionId);
                      print("Client_Groupe_Parc_Inter <<<<<<<<<<<<<<<<<<< DDD ${DbTools.glfParcs_Ent.length}>>>>>>>>>>>>>>>>>>>>>");
                    }
                    await Srv_ImportExport.getErrorSync();
                  },
                  child: Image.asset(
                    "assets/images/Btn_Download.png",
                    height: icoWidth,
                    width: icoWidth,
                  )),
          const Spacer(),
          iStrfExp
              ? CircularProgressIndicator(
                  value: acontroller.value,
                  semanticsLabel: 'Circular progress indicator',
                )
              : FloatingActionButton(
                  heroTag: null,
                  elevation: 10.0,
                  backgroundColor: DbTools.hasConnection ? gColors.primaryRed : Colors.black26,
                  onPressed: () async {
                    if (!DbTools.hasConnection) {
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
                    int NbImg = 0;

                    print("Export 0 glfParcs_Ent lenght ${DbTools.glfParcs_Ent.length}");
                    DbTools.glfParcs_Ent = await DbTools.getParcs_Ent_Upd(Srv_DbTools.gIntervention.InterventionId);
                    print("Export 1 glfParcs_Ent lenght ${DbTools.glfParcs_Ent.length}");

                    DbTools.lParcs_Art.clear();
                    DbTools.glfParcs_Art = await DbTools.getParcs_ArtInter(Srv_DbTools.gIntervention.InterventionId);
                    print("Export getParcs_ArtInter ${Srv_DbTools.gIntervention.InterventionId}");
                    print("Export glfParcs_Art lenght ${DbTools.glfParcs_Art.length}");
                    DbTools.lParcs_Art.addAll(DbTools.glfParcs_Art);

                    print("Export lParcs_Art lenght ${DbTools.lParcs_Art.length}");

                    DbTools.glfParc_Imgs = await DbTools.getParcs_ImgInter(Srv_DbTools.gIntervention.InterventionId);

                    await Srv_DbTools.delParc_Ent_Srv_Upd(Srv_DbTools.gIntervention.InterventionId);

                    print("Export A glfParcs_Ent lenght ${DbTools.glfParcs_Ent.length}");

                    for (int i = 0; i < DbTools.glfParcs_Ent.length; i++) {
                      print("glfParcs_Ent $i");

                      var element = DbTools.glfParcs_Ent[i];
                      await Srv_DbTools.InsertUpdateParc_Ent_Srv(element);
                      int gLastID = Srv_DbTools.gLastID;
                      print("Srv_DbTools.gLastID $gLastID      <   ${element.ParcsId}");
                      String wSql = "";
                      for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
                        var element2 = DbTools.glfParcs_Desc[i];
                        if (element2.ParcsDesc_ParcsId == element.ParcsId) {
                          NbDesc++;
                          element2.ParcsDesc_ParcsId = gLastID;
                          String wTmp = Srv_DbTools.InsertUpdateParc_Desc_Srv_GetSql(element2);
                          wSql = "$wSql $wTmp;";
                        }
                      }

                      if (wSql.isNotEmpty) {
                        await Srv_DbTools.InsertUpdateParc_Desc_Srv_Sql(wSql);
                      }

                      // ART
                      wSql = "";
                      for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
                        var element2 = DbTools.lParcs_Art[i];
                        if (element2.ParcsArt_ParcsId == element.ParcsId) {
                          NbArt++;
                          element2.ParcsArt_ParcsId = gLastID;
                          String wTmp = Srv_DbTools.InsertUpdateParc_Art_Srv_GetSql(element2);
                          wSql = "$wSql $wTmp;";
                        }
                      }

                      if (wSql.isNotEmpty) {
                        await Srv_DbTools.InsertUpdateParc_Art_Srv_Sql(wSql);
                      }

                      // IMG
                      wSql = "";
                      for (int i = 0; i < DbTools.glfParc_Imgs.length; i++) {
                        var element2 = DbTools.glfParc_Imgs[i];
                        if (element2.Parc_Imgs_ParcsId == element.ParcsId) {
                          NbImg++;
                          element2.Parc_Imgs_ParcsId = gLastID;
                          await Srv_DbTools.InsertUpdateParc_Imgs_Srv(element2);
                        }
                      }

                      print(" updateParc_Ent_Update");
                      await DbTools.updateParc_Ent_Update(element.ParcsId!, 0);
                    }

                    String wSql = "";
                    List<Parc_Art> wlarcsArt = await DbTools.getParcs_ArtSoDevis(Srv_DbTools.gIntervention.InterventionId);
                    for (int i = 0; i < wlarcsArt.length; i++) {
                      var element2 = wlarcsArt[i];
                      NbArt++;
                      String wTmp = Srv_DbTools.InsertUpdateParc_Art_Srv_GetSql(element2);
                      wSql = "$wSql $wTmp;";
                    }
                    print("wSql $wSql");

                    if (wSql.isNotEmpty) {
                      await Srv_DbTools.InsertUpdateParc_Art_Srv_Sql(wSql);
                    }

                    print("setSt 9");

                    setState(() {
                      acontroller.stop();
                      iStrfExp = false;
                    });
                    print("Export B glfParcs_Ent lenght ${DbTools.glfParcs_Ent.length}");
                    await Reload();
                    print("Export C glfParcs_Ent lenght ${DbTools.glfParcs_Ent.length}");

                    String wStr = "Export => Transfert de ${DbTools.glfParcs_Ent.length} organes terminé \n\n"
                        "- $NbDesc descriptions\n"
                        "- $NbArt Articles\n"
                        "- $NbImg Images";

                    await gObj.AffMessageInfo(context, "Verif Plus", wStr);
                    await Srv_ImportExport.getErrorSync();
                  },
                  child: Image.asset(
                    "assets/images/Btn_Upload.png",
                    height: icoWidth,
                    width: icoWidth,
                  ))
        ],
      ),
    );
  }

  @override
  Widget Enntete_Inter() {
    String wTitre2 = "${Srv_DbTools.gIntervention.Groupe_Nom} / ${Srv_DbTools.gIntervention.Site_Nom} / ${Srv_DbTools.gIntervention.Zone_Nom}";
    if (Srv_DbTools.gIntervention.Groupe_Nom! == Srv_DbTools.gIntervention.Site_Nom!) wTitre2 = "";

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(children: [
          gObj.InterventionTitleWidget(Srv_DbTools.gIntervention.Client_Nom!.toUpperCase(), wTitre2: "aaa $wTitre2", wTimer: 0),
        ]));
  }

  @override
  Widget Organes() {
    String wTitre2 = "${Srv_DbTools.gIntervention.Groupe_Nom} / ${Srv_DbTools.gIntervention.Site_Nom} / ${Srv_DbTools.gIntervention.Zone_Nom}";
    if (Srv_DbTools.gIntervention.Groupe_Nom! == Srv_DbTools.gIntervention.Site_Nom!) wTitre2 = "";

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            gObj.InterventionTitleWidget(Srv_DbTools.gIntervention.Client_Nom!.toUpperCase(), wTitre2: wTitre2, wTimer: wTimer),
            Entete_Btn_Search(),
            Expanded(
              child: ExtGridWidget(),
            ),
            (DbTools.gRowisSel && DbTools.gCurrentIndex3 == 1) ? PopupMove(context) : Container(),
          ],
        ));
  }

  Widget Organes_New() {
    String wTitre2 = "${Srv_DbTools.gIntervention.Groupe_Nom} / ${Srv_DbTools.gIntervention.Site_Nom} / ${Srv_DbTools.gIntervention.Zone_Nom}";
    if (Srv_DbTools.gIntervention.Groupe_Nom! == Srv_DbTools.gIntervention.Site_Nom!) wTitre2 = "";
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            gObj.InterventionTitleWidget(Srv_DbTools.gIntervention.Client_Nom!.toUpperCase(), wTitre2: wTitre2, wTimer: wTimer),
            Entete_Btn_Search(),
            Expanded(
              child: ExtGridWidget(),
            ),
            (DbTools.gRowisSel && DbTools.gCurrentIndex3 == 1) ? PopupMove(context) : Container(),
          ],
        ));
  }




  @override
  Widget Data() {
    String wTitre2 = "${Srv_DbTools.gIntervention.Groupe_Nom} / ${Srv_DbTools.gIntervention.Site_Nom} / ${Srv_DbTools.gIntervention.Zone_Nom}";
    if (Srv_DbTools.gIntervention.Groupe_Nom == Srv_DbTools.gIntervention.Site_Nom) wTitre2 = "";

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            gObj.InterventionTitleWidget(Srv_DbTools.gClient.Client_Nom.toUpperCase(), wTitre2: wTitre2, wTimer: wTimer),
          ],
        ));
  }

  @override
  AppBar appBar() {
    String wTitle = "COMPTE-RENDU / VÉRIFICATION";
    if (DbTools.gCurrentIndex3 == 0) {
      wTitle = "IMPORT/EXPORT DE DONNEES";
    } else if (DbTools.gCurrentIndex3 == 1)
      wTitle = "COMPTE-RENDU";
    else if (DbTools.gCurrentIndex3 == 2)
      wTitle = "BON DE LIVRAISON";
    else if (DbTools.gCurrentIndex3 == 3)
      wTitle = "BON DE COMMANDE";
    else if (DbTools.gCurrentIndex3 == 4)
      wTitle = "DEVIS";
    else if (DbTools.gCurrentIndex3 == 5) wTitle = "SIGNATURE RAPPORT";

    return AppBar(
      title: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          await Client_Dialog.Dialogs_Client(context);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          AutoSizeText(
            affAll ? wTitle : "INFOS PRATIQUES",
            maxLines: 1,
            style: gColors.bodyTitle1_B_G24,
          ),
        ]),
      ),
      leading: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          print("LOGO Popop $canClose");
          await Popop();
          print("return  Popop  canClose $canClose");
          if (canClose) {
            Navigator.of(context).pop();
          }
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
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Intervention_Vue(
                          onMaj: onMaj,
                        )));
            // setState(() {affAll = !affAll;});
          },
        ),
      ],
      backgroundColor: gColors.white,
    );
  }

  Future OffLine() async {
    List<Parc_Ent> lparcsEnt = await DbTools.getParcs_Ent_Upd(Srv_DbTools.gIntervention.InterventionId);
    if (lparcsEnt.isNotEmpty) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                surfaceTintColor: Colors.white,
                title: Column(
                    //Slide3
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/AppIco.png'),
                        height: 50,
                      ),
                      const SizedBox(height: 8.0),
                      Container(color: Colors.grey, height: 1.0),
                      const SizedBox(height: 8.0),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          "Mode Off Line",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ]),
                content: const Text("Vous n'avez pas de connexion : Import/Export impossible!!!"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              ));
    } else {
      Navigator.of(context).pop();
    }
  }

  Future Popop() async {
    print("Popop() $canClose");

    if (!DbTools.hasConnection) {
      canClose = true;
      print("Popop OFFLINE $canClose");

      return;
    }

    List<Parc_Ent> lparcsEnt = await DbTools.getParcs_Ent_Upd(Srv_DbTools.gIntervention.InterventionId);
    if (lparcsEnt.isNotEmpty) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                surfaceTintColor: Colors.white,
                title: Column(
                    //Slide3
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/AppIco.png'),
                        height: 50,
                      ),
                      const SizedBox(height: 8.0),
                      Container(color: Colors.grey, height: 1.0),
                      const SizedBox(height: 8.0),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          "Vous avez des enregistrements à remonter sur le serveur !!!",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ]),
                content: const Text("Êtes-vous sûre de vouloir quitter cette fenêtre ?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      print("Popop NO $canClose");
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Non'),
                  ),
                  TextButton(
                    onPressed: () {
                      canClose = true;
                      print("Popop YES $canClose");
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Oui'),
                  ),
                ],
              ));
    } else {
      canClose = true;

      print("Popop NO MAJ $canClose");

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
//    print("build");
    double LargeurLabel = 120;
    double h = 60;

    widgets = [
      Data(),
      Organes(),
      Client_Groupe_Parc_Inter_BL(onMaj: onMaj, x_t: ""),
      Client_Groupe_Parc_Inter_BC(onMaj: onMaj, x_t: ""),
      Client_Groupe_Parc_Inter_Devis(onMaj: onMaj, x_t: ""),
      Client_Groupe_Parc_Inter_Signature(onMaj: onMaj, x_t: ""),
    ];

    return WillPopScope(
        onWillPop: () async {
          await Popop();
          if (canClose) {
            return true;
          }
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar(),
            body: Stack(fit: StackFit.expand, children: <Widget>[
//              wchildren,

              (affAll)
                  ? PageView(
                      controller: pageController,
                      onPageChanged: onBottomIconPressed,
                      children: widgets,
                    )
                  : Enntete_Inter(),

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
                : (DbTools.gCurrentIndex3 > 1 || !affAll)
                    ? Container()
                    : DbTools.gCurrentIndex3 == 1
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 60.0),
                            child: FloatingActionButton(
                              elevation: 10.0,
                              onPressed: () async {
                                print("Client_Groupe_Parc_Inter Parcs_InterventionId ${Srv_DbTools.gIntervention.InterventionId}");
                                print("Client_Groupe_Parc_Inter Parcs_Type ${DbTools.gParc_Ent.Parcs_Type}");
                                print("Client_Groupe_Parc_Inter Parcs_order ${DbTools.gParc_Ent.Parcs_order}");
                                print("Client_Groupe_Parc_Inter Parcs_order ${DbTools.gParc_Ent.Parcs_order}");
                                int parcEntGetlastorder = await DbTools.Parc_Ent_GetLastOrder() + 1;
                                Parc_Ent wparcEnt = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId, Srv_DbTools.gIntervention.Intervention_Parcs_Type, parcEntGetlastorder);
                                DbTools.insertParc_Ent(wparcEnt);

                                DbTools.Parc_Ent_GetOrder();
                                await Reload();
                              },
                              backgroundColor: Colors.red,
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ))
                        : Import_Export()));
  }

  Widget CadreWidget(Widget wWidget, Color Color1, Color Color2, Color ColorTxt) {
    double p = 2;
    return Container(
//    width: MediaQuery.of(context).size.width - 16,
      color: Color1,
      padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
      child: Container(color: Color2, padding: EdgeInsets.fromLTRB(p, p, p, p), child: wWidget),
    );
  }

  bool getParc_Ent(int aId) {
    bool wRet = false;
    if (DbTools.gRowSels.isNotEmpty) {
      if (aId < DbTools.gRowSels.length) {
        int wId = DbTools.gRowSels[aId].Id;
        for (int i = 0; i < DbTools.lParcs_Ent.length; i++) {
          Parc_Ent element = DbTools.lParcs_Ent[i];
          if (element.ParcsId! == wId) {
            print(" getParc_Ent Parc_Ent REF ${element.Parcs_CodeArticle}");
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
    for (var eSel in DbTools.gRowSels) {
      for (var eParc in DbTools.lParcs_Ent) {
        if (eSel.Id == eParc.ParcsId) {
          if (eParc.Parcs_Date_Desc!.isEmpty) isDelPos = true;
        }
      }
    }

    bool isParcEnt = getParc_Ent(0);
//    print("isParcEnt $isParcEnt ${DbTools.gParc_Ent.toString()}");

    bool isMoveUp = false;
    if (DbTools.gRowSels.isEmpty) {
      isMoveUp = DbTools.gParc_Ent.Parcs_order != 1;
    } else {
      isMoveUp = DbTools.gParc_Ent.Parcs_order != 1;
    }

    bool isMoveDown = false;
    if (DbTools.gRowSels.isEmpty) {
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
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
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
            const Spacer(),
            //
            // MOVE UP
            //
            SizedBox(
              width: h,
              height: h,
              child: InkWell(
                child: Btn("Haut", Icons.keyboard_arrow_up),
                onTap: () async {
                  await HapticFeedback.vibrate();
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
            SizedBox(
              width: h,
              height: h,
              child: InkWell(
                child: Btn("1ère", Icons.keyboard_double_arrow_up),
                onTap: () async {
                  await HapticFeedback.vibrate();
                  if (isMoveUp) {
                    DbTools.gRowSels.sort(SelLig.affSortComparison);
                    int FirstSelOrdre = DbTools.gRowSels[0].Ordre;
                    print("FirstSelOrdre $FirstSelOrdre");
                    for (int j = 1; j < FirstSelOrdre; j++) {
                      print("moveUP $j");
                      await moveUP();
                      for (var eSel in DbTools.gRowSels) {
                        eSel.Ordre--;
                      }
                    }
                    await Reload();
                  }
                },
              ),
            ),
            Container(
              width: 10,
            ),
            SizedBox(
                width: h,
                height: h,
                child: GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(60),
                      ),
                      color: gColors.btnMove,
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: gColors.white,
                      size: 46,
                    ),
                  ),
                  onTap: () async {
                    await HapticFeedback.vibrate();
                    if (timer != null) {
                      timer!.cancel();
                    }
                    if (iPos > 1) {
                      iPos--;
                      ctrlPos.text = "$iPos";
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
                          ctrlPos.text = "$iPos";
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
                    decoration: const BoxDecoration(
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
                      if (iPos > DbTools.lParcs_Ent.length) {
                        iPos = DbTools.lParcs_Ent.length;
                        ctrlPos.text = "$iPos";
                        setState(() {});
                      }
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
            SizedBox(
                width: h,
                height: h,
                child: GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(60),
                      ),
                      color: gColors.btnMove,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: gColors.white,
                      size: 46,
                    ),
                  ),
                  onTap: () async {
                    await HapticFeedback.vibrate();
                    if (timer != null) {
                      timer!.cancel();
                    }
                    if (iPos < DbTools.lParcs_Ent.length) {
                      iPos++;
                      ctrlPos.text = "$iPos";
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
                          ctrlPos.text = "$iPos";
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
            SizedBox(
                width: h,
                height: h,
                child: InkWell(
                  child: Btn("Dernière", Icons.keyboard_double_arrow_down),
                  onTap: () async {
                    await HapticFeedback.vibrate();
                    if (isMoveDown) {
                      int LastSel = DbTools.gRowSels.length - 1;
                      int LastSelOrdre = DbTools.gRowSels[LastSel].Ordre;
                      int wDec = DbTools.lParcs_Ent.length - LastSelOrdre;

                      print("moveDOWN $LastSel $LastSelOrdre $wDec");

                      for (int j = 0; j <= wDec; j++) {
                        print(">>>>> moveDOWN $j");
                        await moveDOWN();
                        for (var eSel in DbTools.gRowSels) {
                          eSel.Ordre++;
                        }
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
            SizedBox(
                width: h,
                height: h,
                child: InkWell(
                  child: Btn("Bas", Icons.keyboard_arrow_down),
                  onTap: () async {
                    await HapticFeedback.vibrate();
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
            const Spacer(),

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
              SizedBox(
                  width: h,
                  height: h,
                  child: InkWell(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: gColors.primaryGreen,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: gColors.white,
                        size: 46,
                      ),
                    ),
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      print("Press Valid");
                      if (iPos > DbTools.lParcs_Ent.length) {
                        iPos = DbTools.lParcs_Ent.length;
                        ctrlPos.text = "$iPos";
                        setState(() {});
                        return;
                      }
                      if (iPos < 1) {
                        iPos = 1;
                      }
                      ctrlPos.text = "$iPos";

                      int FirstSelOrdre = DbTools.gRowSels[0].Ordre;
                      int LastSel = DbTools.gRowSels.length - 1;
                      int LastSelOrdre = DbTools.gRowSels[LastSel].Ordre;

                      int wRealPos = getRealPos(iPos);

                      print(" Press Valid AAA $iPos wRealPos $wRealPos F $FirstSelOrdre L $LastSelOrdre");
                      if (iPos < FirstSelOrdre) {
                        print(" Press Valid BBB 111");

                        int wDec = FirstSelOrdre - iPos;
                        for (int j = 1; j <= wDec; j++) {
                          await moveUP();
                          for (var eSel in DbTools.gRowSels) {
                            eSel.Ordre--;
                          }
                        }
                        await Reload();
                      } else if (LastSelOrdre < iPos) {
                        print(" Press Valid BBB 222");
                        int wDec = iPos - LastSelOrdre;
                        for (int j = 0; j < wDec; j++) {
                          await moveDOWN();
                          for (var eSel in DbTools.gRowSels) {
                            eSel.Ordre++;
                          }
                        }
                        await Reload();
                      }

                      print(" Press Valid CCC");

                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  )),
              const Spacer(),
              SizedBox(
                  width: h,
                  height: h,
                  child: InkWell(
                    child: Btn("Avant", Icons.keyboard_arrow_left),
                    onTap: () async {
                      await HapticFeedback.vibrate();

                      if (DbTools.gRowSels.length == 1) {
                        for (int i = 0; i < NbAdd; i++) {
                          Parc_Ent wparcEnt = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId, DbTools.gParc_Ent.Parcs_Type!, DbTools.gParc_Ent.Parcs_order! - 1);
                          DbTools.insertParc_Ent(wparcEnt);
                        }
                        Reload();
                      }
                    },
                  )),
              Container(
                width: 10,
              ),
              SizedBox(
                  width: h,
                  height: h,
                  child: GestureDetector(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        color: gColors.btnMove,
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: gColors.white,
                        size: 46,
                      ),
                    ),
                    onTap: () async {
                      await HapticFeedback.vibrate();

                      if (NbAdd > 1) {
                        NbAdd--;
                        ctrlNbInsert.text = "$NbAdd";
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
                            ctrlNbInsert.text = "$NbAdd";
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
                      decoration: const BoxDecoration(
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
              SizedBox(
                  width: h,
                  height: h,
                  child: GestureDetector(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        color: gColors.btnMove,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: gColors.white,
                        size: 46,
                      ),
                    ),
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      NbAdd++;
                      ctrlNbInsert.text = "$NbAdd";
                    },
                    onLongPressStart: (detail) {
                      print("setSt 13");
                      setState(() {
                        if (timer != null) {
                          timer!.cancel();
                        }

                        timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
                          NbAdd++;
                          ctrlNbInsert.text = "$NbAdd";
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
              SizedBox(
                  width: h,
                  height: h,
                  child: InkWell(
                    child: Btn("Aprés", Icons.keyboard_arrow_right),
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      print("Aprés ");
                      if (DbTools.gRowSels.length == 1) {
                        for (int i = 0; i < NbAdd; i++) {
                          Parc_Ent wparcEnt = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId, DbTools.gParc_Ent.Parcs_Type!, DbTools.gParc_Ent.Parcs_order!);
                          DbTools.insertParc_Ent(wparcEnt);
                        }

                        Reload();
                      }
                    },
                  )),
              const Spacer(),
              SizedBox(
                  width: h,
                  height: h,
                  child: InkWell(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: gColors.primaryRed,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: gColors.white,
                        size: 46,
                      ),
                    ),
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      print("isDelPos $isDelPos");
                      if (!isDelPos) return;

                      DbTools.gRowSels.forEach((eSel) async {
                        DbTools.lParcs_Ent.forEach((eParc) async {
                          if (eSel.Id == eParc.ParcsId) {
                            if (eParc.Parcs_Date_Desc!.isEmpty) {
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

  int getRealPos(int iPos) {
    for (int j = 0; j < DbTools.lParcs_Ent.length; j++) {
      Parc_Ent wparcEnt = DbTools.lParcs_Ent[j];
      if (wparcEnt.Parcs_order == iPos) return j;
    }
    return -1;
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
    Color getColor(Set<WidgetState> states) {
      return gColors.LinearGradient1;
    }

    final AutreController = TextEditingController();
    bool AffAutreController = false;

    return Container(
      width: 584,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: gColors.LinearGradient1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
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
                padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
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
                    Checkbox(value: itemlistApp[1], fillColor: WidgetStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[2],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[2], fillColor: WidgetStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[3],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[3], fillColor: WidgetStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[4],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[4], fillColor: WidgetStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[5],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[5], fillColor: WidgetStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      listMes[6],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(value: itemlistApp[6], fillColor: WidgetStateProperty.resolveWith(getColor), onChanged: (bool? value) {}),
                    Text(
                      listMes[7],
                      style: gColors.bodySaisie_N_G,
                    ),
                    Checkbox(
                        value: itemlistApp[7],
                        fillColor: WidgetStateProperty.resolveWith(getColor),
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
    Davi wDavi = Davi<Parc_Ent>(
      _model,
//      visibleRowsCount: 16,
      onRowDoubleTap: (aparcEnt) => _onRowDoubleTap(context, aparcEnt),
      onRowTap: (parcEnt) => _onRowDoubleTap(context, parcEnt),
      rowColor: _rowColor,
      onHover: _onHover,
      unpinnedHorizontalScrollController: wHScrollController,
      verticalScrollController: wVScrollController,
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 50),
      child: GestureDetector(
          onPanStart: (d) {
            dxPosition = 0;
            dyPosition = 0;
          },
          onPanUpdate: (details) {
            hPosition = 0;
            vPosition = 0;

            if (details.delta.dy < 0) {
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
                wVScrollController.animateTo(vPosition, duration: const Duration(milliseconds: 1000), curve: Curves.easeOutCubic);
              }
            } else if (dyPosition > 0) {
              final delta = d.velocity.pixelsPerSecond.dy / -100;
              vPosition = wVScrollController.offset + 20 * delta; //details.delta.dy;
              final minposition = wVScrollController.position.minScrollExtent;
              if (vPosition < minposition) vPosition = minposition;
              if (vPosition >= minposition) {
//              print(">>>>> d.velocity.pixelsPerSecond.dy  ${wVScrollController.offset} ----- ${vPosition} ----- ${delta}");
                wVScrollController.animateTo(vPosition, duration: const Duration(milliseconds: 1000), curve: Curves.easeOutCubic);
              }
            }
          },
          child: DaviTheme(
              data: DaviThemeData(
                columnDividerColor: Colors.transparent,
                header: const HeaderThemeData(
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
                cell: const CellThemeData(
                  contentHeight: 44,
                ),
              ),
              child: wDavi)),
    );
  }

  Color? _rowColor(DaviRow<Parc_Ent> row) {
    if (LastClickID == row.data.ParcsId) {
//      return gColors.greyLight;
      return Colors.blue;
    }

    return null;
  }

  void _onHover(int? rowIndex) {
    print("_onHover rowIndex $rowIndex");
  }

  //**********************************
//**********************************
//**********************************

  void _onSelMove(Parc_Ent parcEnt) async {
    LastClickID = -1;
    print("_onSelMove ${DbTools.gRowSels.toString()} ${parcEnt.Parcs_order!}");
    await HapticFeedback.vibrate();
    await HapticFeedback.vibrate();
    await HapticFeedback.vibrate();

    if (isInSels(parcEnt.ParcsId!)) {
      print(">>>>>>>>>>>>>>>> _onSelMove SUPPRIME ${parcEnt.ParcsId}");

      for (int i = 0; i < DbTools.gRowSels.length; i++) {
        SelLig element = DbTools.gRowSels[i];
        if (element.Id == parcEnt.ParcsId) {
          DbTools.gRowSels.removeAt(i);
          break;
        }
      }

      if (DbTools.gRowSels.isEmpty) DbTools.gRowisSel = false;
    } else if (DbTools.gRowSels.isEmpty) {
      print(" _onSelMove Parc_Ent REF ${parcEnt.Parcs_CodeArticle}");
      DbTools.gParc_Ent = parcEnt;
      DbTools.gRowIndex = parcEnt.ParcsId!;

      DbTools.gRowisSel = true;
      NbAdd = 0;
      ctrlNbInsert.text = "$NbAdd";

      DbTools.gRowSels.add(SelLig(DbTools.gRowIndex, parcEnt.Parcs_order!));
      print(">>>>>>>>>>>>>>>> _onSelMove  ADD FIRST ${DbTools.gRowIndex} ${parcEnt.Parcs_order}");

      if (parcEnt.Parcs_UUID_Parent!.isNotEmpty) {
        var wparcsEnt = DbTools.glfParcs_Ent.where((element) => element.Parcs_UUID!.compareTo(parcEnt.Parcs_UUID_Parent!) == 0);
        if (wparcsEnt.isNotEmpty) {
          var aparSel = wparcsEnt.first;
          print("aparSel Parent ${aparSel.ParcsId}");
          DbTools.gRowSels.add(SelLig(aparSel.ParcsId!, parcEnt.Parcs_order!));
          print(">>>>>>>>>>>>>>>> _onSelMove  ADD FIRST ${aparSel.ParcsId} ${parcEnt.Parcs_order}");
        }
      } else {
        var wparcsEnt = DbTools.glfParcs_Ent.where((element) => element.Parcs_UUID_Parent!.compareTo(parcEnt.Parcs_UUID!) == 0);
        if (wparcsEnt.isNotEmpty) {
          var aparSel = wparcsEnt.first;
          print("aparSel Child ${aparSel.ParcsId}");
          DbTools.gRowSels.add(SelLig(aparSel.ParcsId!, parcEnt.Parcs_order!));
          print(">>>>>>>>>>>>>>>> _onSelMove  ADD FIRST ${aparSel.ParcsId} ${parcEnt.Parcs_order}");
        }
      }
    } else {
      int wMin = 9999999;
      int wMax = -9999999;

      for (var wRowSel in DbTools.gRowSels) {
        int wOrder = wRowSel.Ordre;

        if (wOrder > wMax) wMax = wOrder;
        if (wOrder < wMin) wMin = wOrder;
      }

      print(">>>>>>>>>>>>>>>> _onSelMove ${parcEnt.Parcs_order!} Min $wMin $wMax");

      if (parcEnt.Parcs_order! < wMin) {
        print("CLIC TO MIn  ${parcEnt.Parcs_order} => $wMin");
        for (int i = parcEnt.Parcs_order!; i < wMin; i++) {
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
            print("Add $wID ordre $i");
            DbTools.gRowSels.add(SelLig(wID, wOrdre));
          }
        }
      } else if (parcEnt.Parcs_order! > wMin) {
        print("MIN TO CLICK $wMin => ${parcEnt.Parcs_order}");
        for (int i = wMin + 1; i <= parcEnt.Parcs_order!; i++) {
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
            print("Add $wID ordre $i ${DbTools.gRowSels.contains(SelLig(wID, wOrdre))}");
            DbTools.gRowSels.add(SelLig(wID, wOrdre));
          }
        }
      }
    }
    print("setSt 14");

    setState(() {});
  }

  Future _onRowTap(BuildContext context, Parc_Ent parcEnt) async {
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
    LastClickID = parcEnt.ParcsId!;

    setState(() {});
  }

  void _onRowDoubleTap(BuildContext context, Parc_Ent parcEnt) async {
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

    DbTools.gParc_Ent = parcEnt;
    LastSelID = DbTools.gParc_Ent.ParcsId!;
    setState(() {});

    print("DbTools.gParc_Ent.ParcsId! ${DbTools.gParc_Ent.ParcsId!}");

    Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.clear();

    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Saisie[i];

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

    Srv_DbTools.FAB_Lib = "";
    Srv_DbTools.TYPE_Lib = "";
    Srv_DbTools.PRS_Lib = "";
    Srv_DbTools.CLF_Lib = "";
    Srv_DbTools.GAM_Lib = "";
    Srv_DbTools.REF_Lib = "";
    LastClickID = -1;

    Srv_DbTools.IsComplet = !"${DbTools.gParc_Ent.toString()} ${DbTools.glfParcs_Desc}".contains("---");

    await Navigator.push(context, MaterialPageRoute(builder: (context) => const Client_Groupe_Parc_Inter_Entete()));

    DbTools.lParcs_Art = await DbTools.getParcs_Art_AllType(DbTools.gParc_Ent.ParcsId!);
    for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
      Parc_Art element = DbTools.lParcs_Art[i];
//      print("¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶ Client_Groupe_Parc_Inter_Entete ${element.Desc()}");
    }

    Reload();

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
    LastClickID = parcEnt.ParcsId!;

    setState(() {});
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

      print("aIdA $wIdPrec aIdB $LastSelID aOrdreA $wOrdrePrec aOrdreB $LastSelOrdre");

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

  void onBottomIconPressed(int index) async {
    if (DbTools.gCurrentIndex3 != index) {
      DbTools.gCurrentIndex3 = index;

      DbTools.gRowisSel = false;
      DbTools.gRowIndex = -1;
      DbTools.gRowSels.clear();

      pageController.jumpToPage(index);
      FBroadcast.instance().broadcast("HandleBar3");

      if (index == 1) {
        isBtnRel = false;
        isBtnDev = false;
        Filtre();
      } else if (index == 0) {
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
  }

  //*********************************************
//*********************************************
//*********************************************
}
