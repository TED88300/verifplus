import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Param_Av.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Article.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_ArticleAV.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Inter_Equip_Saisie_Dialog {
  Client_Groupe_Parc_Inter_Equip_Saisie_Dialog();

  static Future<void> Dialogs_Saisie(
    BuildContext context,
    VoidCallback onSaisie,
    Param_Saisie paramSaisie,
    Parc_Desc parcDesc,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_Equip_SaisieDialog(
        onSaisie: onSaisie,
        param_Saisie: paramSaisie,
        parc_Desc: parcDesc,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_Equip_SaisieDialog extends StatefulWidget {
  final VoidCallback onSaisie;
  final Param_Saisie param_Saisie;
  final Parc_Desc parc_Desc;
  const Client_Groupe_Parc_Inter_Equip_SaisieDialog({Key? key, required this.onSaisie, required this.param_Saisie, required this.parc_Desc}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_Equip_SaisieDialogState createState() => Client_Groupe_Parc_Inter_Equip_SaisieDialogState();
}

class Client_Groupe_Parc_Inter_Equip_SaisieDialogState extends State<Client_Groupe_Parc_Inter_Equip_SaisieDialog> {
  String wAide = "";
  bool wEditFocus = false;

  Widget wIco = Container();
  TextEditingController tec_Search = TextEditingController();
  TextEditingController tec_Saisie = TextEditingController();
  String initParcsDesc_Lib = "";
  String initParcsDesc_Id = "";

  Image? wImage;
  double IcoWidth = 350;

  TextEditingController NCERT_Search = TextEditingController();
  String NCERT_Search_Result = "...";

  Future Reload() async {
    print(" Srv_DbTools.ListParam_Saisie_ParamAll >>> ${Srv_DbTools.ListParam_Saisie_ParamAll.length}");
    await Srv_DbTools.getParam_Saisie_ParamAll();
    print(" Srv_DbTools.ListParam_Saisie_ParamAll <<< ${Srv_DbTools.ListParam_Saisie_ParamAll.length}");

    switch (widget.param_Saisie.Param_Saisie_ID) {
      case "FAB2":
        await DbTools.getRIA_Gammes_FAB();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "TYPE2":
        await DbTools.getRIA_Gammes_TYPE();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "ARM":
        await DbTools.getRIA_Gammes_ARM();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "INOX":
        await DbTools.getRIA_Gammes_INOX();
        print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ Srv_DbTools.ListParam_Saisie_Param.length  ${Srv_DbTools.ListParam_Saisie_Param.length}");
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "DIAM":
        await DbTools.getRIA_Gammes_DIAM();
        print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ Srv_DbTools.ListParam_Saisie_Param.length  ${Srv_DbTools.ListParam_Saisie_Param.length}");
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "LONG":
        await DbTools.getRIA_Gammes_LONG();
        print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ Srv_DbTools.ListParam_Saisie_Param.length  ${Srv_DbTools.ListParam_Saisie_Param.length}");
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "DIF":
        await DbTools.getRIA_Gammes_DIF();
        print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ Srv_DbTools.ListParam_Saisie_Param.length  ${Srv_DbTools.ListParam_Saisie_Param.length}");
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "DISP":
        await DbTools.getRIA_Gammes_DISP();
        print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ Srv_DbTools.ListParam_Saisie_Param.length  ${Srv_DbTools.ListParam_Saisie_Param.length}");
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "PREM":
        await DbTools.getRIA_Gammes_PREM();
        print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ Srv_DbTools.ListParam_Saisie_Param.length  ${Srv_DbTools.ListParam_Saisie_Param.length}");
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "FAB":
        await DbTools.getNF074_Gammes_FAB();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      case "PRS":
        await DbTools.getNF074_Gammes_PRS();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      case "CLF":
        print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ CLF >>>>>");
        await DbTools.getNF074_Gammes_CLF();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ CLF <<<<<");

        break;

      case "MOB":
        await DbTools.getNF074_Gammes_MOB();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) {
          Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        }
        break;
      case "PDT":
        await DbTools.getNF074_Gammes_PDT();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      case "POIDS":
        await DbTools.getNF074_Gammes_POIDS();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      case "GAM":
        await DbTools.getNF074_Gammes_GAM();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      case "DESC":
        await DbTools.getNF074_Gammes_Decs_Test();
        await DbTools.getNF074_Gammes_Decs();
        if (Srv_DbTools.ListParam_Saisie_Param.isEmpty) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      default:
        print("ææææ getParam_Saisie_ParamMem ${widget.param_Saisie.Param_Saisie_ID}");
        Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
    }

    print(" ${widget.param_Saisie.Param_Saisie_ID} ListParam_Saisie_Param lenght  ${Srv_DbTools.ListParam_Saisie_Param.length}");
    setState(() {});
  }

  @override
  void initLib() async {
    await setImage();
    await Reload();
  }

  Future setImage() async {
    String wImgPath = "${Srv_DbTools.SrvImg}Gamme_${widget.parc_Desc.ParcsDesc_Id}.jpg";
    print("wImgPath $wImgPath");
    gObj.pic = await gObj.networkImageToByte(wImgPath);
    if (gObj.pic.isNotEmpty) {
      wImage = Image.memory(
        gObj.pic,
      );
    } else {
      wImage = const Image(
        image: AssetImage('assets/images/Avatar_Org.jpg'),
        height: 100,
      );
    }
  }

  @override
  void initState() {
    initParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!;
    initParcsDesc_Id = widget.parc_Desc.ParcsDesc_Id!;

    Uint8List blankBytes = const Base64Codec().decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
    wImage = Image.memory(
      blankBytes,
      height: 1,
    );

    Srv_DbTools.ListParam_Saisie_Param.clear();

    initializeDateFormatting();
    initLib();
    super.initState();
  }

  @override
  void dispose() {
    print(" dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();

    double wDialogHeight = 250;
    int nb = (Srv_DbTools.ListParam_Saisie_Param.length / 3).truncate();
    int modnb = Srv_DbTools.ListParam_Saisie_Param.length % 3;
    int nbL = nb;
    if (modnb > 0) nbL++;
    double wDialogBase = 130;
    double wLigneHeight = 52;

    switch (widget.param_Saisie.Param_Saisie_Controle) {
      case "Poids":
        Ctrl = Poids(context);
        wLigneHeight = 62;
        wDialogHeight = wDialogBase + nbL * wLigneHeight + 45;
        break;
      case "FlipFlop":
        Ctrl = FlipFlop(context);
        wLigneHeight = 59;
        wDialogHeight = wDialogBase + nbL * wLigneHeight + 44;
        print("FlipFlop length ${Srv_DbTools.ListParam_Saisie_Param.length} $wDialogBase nb $nb modnb $modnb nbL $nbL * $wLigneHeight + 44 = $wDialogHeight");
        print("FlipFlop $wDialogBase nbL $nbL * $wLigneHeight + 44 = $wDialogHeight");
        break;

      case "FlipFlopIco":
        print("FlipFlopIco");
        Ctrl = FlipFlopIco(context);
        wLigneHeight = 79;
        wDialogHeight = wDialogBase + nbL * wLigneHeight + 135;
        break;

      case "FlipFlopEdt":
        print("FlipFlopEdt ${widget.param_Saisie.Param_Saisie_Label}");
        Ctrl = FlipFlopEdt(context);
        wLigneHeight = 59;
        wDialogHeight = wDialogBase + nbL * wLigneHeight + 34;
        break;
      case "Liste":
        print("Liste Liste Liste Liste");
        Ctrl = Liste(context);
        wDialogHeight = 640;
        break;

      case "ListeEdt":
        print("ListeEdt ListeEdt ListeEdt ListeEdt");
        Ctrl = ListeEdt(context);
        wDialogHeight = 495;
        break;

      case "Annee":
        Ctrl = Annee(context);
        wDialogHeight = 375;
        break;

      case "EdtTxt":
        txtController.text = widget.parc_Desc.ParcsDesc_Lib!;
        if (txtController.text.compareTo("---") == 0) txtController.text = "";
        Ctrl = EdtTxt(context);
        wDialogHeight = 230;
        break;

      case "EdtTxtNR":
        txtController.text = widget.parc_Desc.ParcsDesc_Lib!.toUpperCase();
        if (txtController.text.compareTo("---") == 0) txtController.text = "";
        Ctrl = EdtTxtNR(context);
        wDialogHeight = 180;
        break;

      case "Niv":
        Ctrl = Niv(context);
        wDialogHeight = 345;
        break;

      case "Qrc":
        Ctrl = Qrc(context);
        wDialogHeight = 140;
        break;

      default:
        Ctrl = Txt(context);
        wDialogHeight = wDialogBase;
        break;
    }

    if (widget.param_Saisie.Param_Saisie_ID.compareTo("DESC") == 0) {
      wDialogHeight += 200;
    }

    wDialogHeight += 1;
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Text(
                widget.param_Saisie.Param_Saisie_Label,
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Text(
                widget.param_Saisie.Param_Saisie_Aide,
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_N_Gr,
              ),
              Container(
                height: 8,
              ),
              widget.param_Saisie.Param_Saisie_ID.compareTo("GAM") == 0 && !wEditFocus
                  ? SizedBox(
                      height: IcoWidth,
                      width: IcoWidth,
                      child: wImage!,
                    )
                  : Container()
            ],
          )),
      contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
      content: SingleChildScrollView(
        child: Container(
            color: gColors.white,
            height: wDialogHeight,
            child: Column(
              children: [
                Container(
                  color: gColors.black,
                  height: 1,
                ),
                widget.param_Saisie.Param_Saisie_ID.compareTo("DESC") != 0
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            height: 10,
                          ),
                          Text(
                            "Recherche par n° de certification",
                            textAlign: TextAlign.center,
                            style: gColors.bodyTitle1_N_Gr,
                          ),
                          Container(
                            height: 10,
                          ),
                          SizedBox(
                            height: 40,
                            width: 450,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 0,
                                bottom: 4,
                                right: 0,
                                left: 0,
                              ),
                              child: TextFormField(
                                onChanged: (value) async {
                                  DbTools.glfNF074_Gammes_Date = await DbTools.getNF074_Gammes_Get_NCERT(value);
                                  NCERT_Search_Result = "...";
                                  print("value $value ${DbTools.glfNF074_Gammes_Date.length}");
                                  if (DbTools.glfNF074_Gammes_Date.length == 1) {
                                    NCERT_Search_Result = "Trv";
                                  } else if (DbTools.glfNF074_Gammes_Date.length > 1) NCERT_Search_Result = "Liste (${DbTools.glfNF074_Gammes_Date.length})";
                                  setState(() {});
                                },
                                style: gColors.bodyTitle1_N_G_20,
                                controller: NCERT_Search,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ),
                                  hintText: 'N°',
                                  hintStyle: gColors.bodyTitle1_N_Gr,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        NCERT_Search.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          /*  Text(
                            NCERT_Search_Result,
                            textAlign: TextAlign.center,
                            style: gColors.bodyTitle1_N_G_20,
                          ),*/
                          NCERT_Search.text.isEmpty
                              ? Container()
                              : SizedBox(
                                  width: 450,
                                  height: 400,
                                  child: ListView.builder(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    itemCount: DbTools.glfNF074_Gammes_Date.length,
                                    itemBuilder: (context, index) {
                                      final item = DbTools.glfNF074_Gammes_Date[index];

                                      Color wColor = Colors.white;
                                      if (item.NF074_Gammes_AVT.isNotEmpty) wColor = Colors.yellow;

                                      Color tColor = gColors.primary;
//                                      if (item.NF074_Gammes_AVT.isNotEmpty) tColor = gColors.white;

                                      return InkWell(
                                          onTap: () async {
                                            await HapticFeedback.vibrate();
                                            DbTools.gNF074_Gammes_Date = item;
                                            DbTools.gParc_Ent.Parcs_CodeArticle = DbTools.gNF074_Gammes_Date.NF074_Gammes_REF;
                                            DbTools.gParc_Ent.Parcs_CODF = DbTools.gNF074_Gammes_Date.NF074_Gammes_CODF;
                                            DbTools.gParc_Ent.Parcs_NCERT = DbTools.gNF074_Gammes_Date.NF074_Gammes_NCERT;
                                            DbTools.gParc_Ent.Parcs_FAB = DbTools.gNF074_Gammes_Date.NF074_Gammes_FAB;

                                            await DbTools.updateParc_Ent(DbTools.gParc_Ent);
                                            List<Param_Av> listparamAv = await DbTools.getParam_Av_NCERT(item.NF074_Gammes_AVT);
                                            DbTools.gParam_Av = Param_Av.Param_AvInit();
                                            if (listparamAv.length == 1)
                                              {
                                                DbTools.gParam_Av = listparamAv[0];
                                                await Client_Groupe_Parc_Inter_ArticleAv_Dialog.Dialogs_SaisieAv(context);
                                              }


                                            await setData();
                                            widget.onSaisie();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: wColor,
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 5), // TED
                                              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0), // TED
                                              height: 70,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(item.NF074_Histo_Normes_SORT_AAAA.length == 1 ? "${item.NF074_Gammes_NCERT} / ${item.NF074_Histo_Normes_ENTR_AAAA}  / ${item.NF074_Gammes_REF} / ${item.NF074_Gammes_CODF}" : "${item.NF074_Gammes_NCERT} / ${item.NF074_Histo_Normes_ENTR_AAAA} -  ${item.NF074_Histo_Normes_SORT_AAAA} / ${item.NF074_Gammes_REF}",
                                                      textAlign: TextAlign.left,
                                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                                        color: tColor,
                                                      )),
                                                  Text("${item.NF074_Gammes_DESC}, ${item.NF074_Gammes_PDT}, ${item.NF074_Gammes_POIDS}",
                                                      textAlign: TextAlign.left,
                                                      style: gColors.bodyTitle1_N_Gr.copyWith(
                                                        color: tColor,
                                                      )),
                                                  Text("${item.NF074_Gammes_FAB} ${item.NF074_Gammes_GAM}, ${item.NF074_Gammes_PRS}, ${item.NF074_Gammes_CLF}",
                                                      textAlign: TextAlign.left,
                                                      style: gColors.bodyTitle1_N_Gr.copyWith(
                                                        color: tColor,
                                                      )),
                                                ],
                                              )));
                                    },
                                  ),
                                ),
                          NCERT_Search.text.isNotEmpty
                              ? Container()
                              : Column(
                                  children: [
                                    Container(
                                      height: 10,
                                    ),
                                    Container(
                                      color: gColors.black,
                                      height: 1,
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "Recherche d'article dans le catalogue",
                                      textAlign: TextAlign.center,
                                      style: gColors.bodyTitle1_N_Gr,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await HapticFeedback.vibrate();
                                          await Client_Groupe_Parc_Inter_Article_Dialog.Dialogs_Saisie(context, onSaisie, "G");

                                          if (Srv_DbTools.gArticle_EbpSelRef.ArticleID >= 0) {
                                            await DbTools.getNF074_Gammes_Get_REF(Srv_DbTools.gArticle_EbpSelRef.Article_codeArticle);
                                            DbTools.gParc_Ent.Parcs_CodeArticle = Srv_DbTools.gArticle_EbpSelRef.Article_codeArticle;
                                            DbTools.gParc_Ent.Parcs_CODF = DbTools.gNF074_Gammes.NF074_Gammes_CODF;
                                            DbTools.gParc_Ent.Parcs_NCERT = DbTools.gNF074_Gammes.NF074_Gammes_NCERT;

                                            Srv_DbTools.DESC_Lib = DbTools.gNF074_Gammes.NF074_Gammes_DESC;
                                            Srv_DbTools.FAB_Lib = DbTools.gNF074_Gammes.NF074_Gammes_FAB;
                                            Srv_DbTools.PRS_Lib = DbTools.gNF074_Gammes.NF074_Gammes_PRS;
                                            Srv_DbTools.CLF_Lib = DbTools.gNF074_Gammes.NF074_Gammes_CLF;
                                            Srv_DbTools.PDT_Lib = DbTools.gNF074_Gammes.NF074_Gammes_PDT;
                                            Srv_DbTools.POIDS_Lib = DbTools.gNF074_Gammes.NF074_Gammes_POIDS;
                                            Srv_DbTools.GAM_Lib = DbTools.gNF074_Gammes.NF074_Gammes_GAM;

                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Client_Groupe_Parc_Inter_Article_Dialog ArticleID  ${Srv_DbTools.gArticle_EbpSelRef.ArticleID}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Client_Groupe_Parc_Inter_Article_Dialog Article_codeArticle  ${Srv_DbTools.gArticle_EbpSelRef.Article_codeArticle}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Client_Groupe_Parc_Inter_Article_Dialog Article_codeArticle  ${DbTools.gParc_Ent.Parcs_CodeArticle}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Client_Groupe_Parc_Inter_Article_Dialog Parcs_CODF  ${DbTools.gParc_Ent.Parcs_CODF}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Client_Groupe_Parc_Inter_Article_Dialog Parcs_NCERT  ${DbTools.gParc_Ent.Parcs_NCERT}");

                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Srv_DbTools.DESC_Lib   ${Srv_DbTools.DESC_Lib}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Srv_DbTools.FAB_Lib    ${Srv_DbTools.FAB_Lib}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Srv_DbTools.PRS_Lib    ${Srv_DbTools.PRS_Lib}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Srv_DbTools.CLF_Lib    ${Srv_DbTools.CLF_Lib}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Srv_DbTools.PDT_Lib    ${Srv_DbTools.PDT_Lib}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Srv_DbTools.POIDS_Lib  ${Srv_DbTools.POIDS_Lib}");
                                            print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈  Srv_DbTools.GAM_Lib    ${Srv_DbTools.GAM_Lib}");

                                            print(" updateParc_Ent C");
                                            await DbTools.updateParc_Ent(DbTools.gParc_Ent);
                                            print(" updateParc_Ent D ${Srv_DbTools.CLF_Lib}");
                                            await setData();
                                            print(" updateParc_Ent E ${Srv_DbTools.CLF_Lib}");
                                            widget.onSaisie();
                                            print(" updateParc_Ent F ${Srv_DbTools.CLF_Lib}");
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: gColors.greyDark,
                                        ),
                                        child: Text("Articles", style: gColors.bodyTitle1_N_W),
                                      ),
                                    ),
                                    Container(
                                      color: gColors.black,
                                      height: 1,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                NCERT_Search.text.isNotEmpty
                    ? Container(
                        height: 0,
                      )
                    : Container(
                        color: gColors.greyLight,
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: Ctrl,
                      ),
                Container(
                  color: gColors.black,
                  height: 1,
                ),
                Valider(context),
              ],
            )),
      ),
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Future setData() async {
    print(" setData()");

    for (int i = 0; i < DbTools.glfNF074_Gammes.length; i++) {
      NF074_Gammes wnf074Gammes = DbTools.glfNF074_Gammes[i];
      if (DbTools.gParc_Ent.Parcs_CODF!.compareTo(wnf074Gammes.NF074_Gammes_CODF) == 0) {
        print(" setData() ${DbTools.gParc_Ent.Parcs_CODF} ${DbTools.glfParcs_Desc.length}");
        for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
          var element2 = DbTools.glfParcs_Desc[i];
          print(" setData() ParcsDesc_Type ${element2.ParcsDesc_Type}");

          if (element2.ParcsDesc_Type!.compareTo("DESC") == 0) {
            element2.ParcsDesc_Id = "";
            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_DESC;
            Srv_DbTools.DESC_Lib = element2.ParcsDesc_Lib!;
            bool isNotRaz = await DbTools.updateParc_DescSimple(element2, "---");
            if (!isNotRaz) {
              Srv_DbTools.FAB_Lib = "";
              Srv_DbTools.PRS_Lib = "";
              Srv_DbTools.CLF_Lib = "";
              Srv_DbTools.MOB_Lib = "";
              Srv_DbTools.PDT_Lib = "";
              Srv_DbTools.POIDS_Lib = "";
              Srv_DbTools.GAM_Lib = "";
            }
          } else if (element2.ParcsDesc_Type!.compareTo("FAB") == 0) {
            element2.ParcsDesc_Id = "";
            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_FAB;
            Srv_DbTools.FAB_Lib = element2.ParcsDesc_Lib!;
            bool isNotRaz = await DbTools.updateParc_DescSimple(element2, "---");
            if (!isNotRaz) {
              Srv_DbTools.PRS_Lib = "";
              Srv_DbTools.PRS_Lib = "";
              Srv_DbTools.CLF_Lib = "";
              Srv_DbTools.MOB_Lib = "";
              Srv_DbTools.PDT_Lib = "";
              Srv_DbTools.POIDS_Lib = "";
              Srv_DbTools.GAM_Lib = "";
            }
          } else if (element2.ParcsDesc_Type!.compareTo("PRS") == 0) {
            element2.ParcsDesc_Id = "";
            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_PRS;
            Srv_DbTools.PRS_Lib = element2.ParcsDesc_Lib!;
            bool isNotRaz = await DbTools.updateParc_DescSimple(element2, "---");
            if (!isNotRaz) {
              Srv_DbTools.CLF_Lib = "";
              Srv_DbTools.MOB_Lib = "";
              Srv_DbTools.PDT_Lib = "";
              Srv_DbTools.POIDS_Lib = "";
              Srv_DbTools.GAM_Lib = "";
            }
          } else if (element2.ParcsDesc_Type!.compareTo("CLF") == 0) {
            element2.ParcsDesc_Id = "";
            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_CLF;
            Srv_DbTools.CLF_Lib = element2.ParcsDesc_Lib!;
            bool isNotRaz = await DbTools.updateParc_DescSimple(element2, "---");
            if (!isNotRaz) {
              Srv_DbTools.MOB_Lib = "";
              Srv_DbTools.PDT_Lib = "";
              Srv_DbTools.POIDS_Lib = "";
              Srv_DbTools.GAM_Lib = "";
            }
          } else if (element2.ParcsDesc_Type!.compareTo("MOB") == 0) {
            element2.ParcsDesc_Id = "";
            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_MOB;
            Srv_DbTools.MOB_Lib = element2.ParcsDesc_Lib!;
            bool isNotRaz = await DbTools.updateParc_DescSimple(element2, "---");
            if (!isNotRaz) {
              Srv_DbTools.PDT_Lib = "";
              Srv_DbTools.POIDS_Lib = "";
              Srv_DbTools.GAM_Lib = "";
            }
          } else if (element2.ParcsDesc_Type!.compareTo("PDT") == 0) {
            element2.ParcsDesc_Id = "";
            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_PDT;
            Srv_DbTools.PDT_Lib = element2.ParcsDesc_Lib!;
            bool isNotRaz = await DbTools.updateParc_DescSimple(element2, "---");
            if (!isNotRaz) {
              Srv_DbTools.POIDS_Lib = "";
              Srv_DbTools.GAM_Lib = "";
            }
          } else if (element2.ParcsDesc_Type!.compareTo("POIDS") == 0) {
            element2.ParcsDesc_Id = "";
            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_POIDS;
            Srv_DbTools.POIDS_Lib = element2.ParcsDesc_Lib!;
            bool isNotRaz = await DbTools.updateParc_DescSimple(element2, "---");
            if (!isNotRaz) {
              Srv_DbTools.GAM_Lib = "";
            }
          } else if (element2.ParcsDesc_Type!.compareTo("GAM") == 0) {
            element2.ParcsDesc_Id = "";
            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_GAM;
            Srv_DbTools.GAM_Lib = element2.ParcsDesc_Lib!;
            print(" setData() GAM ${Srv_DbTools.GAM_Lib}");
            bool isNotRaz = await DbTools.updateParc_DescSimple(element2, "---");
          }
        }
      }
    }
    print(" setData() FIN GAM_Lib ${Srv_DbTools.GAM_Lib}");
  }

  //**********************************
  //**********************************
  //**********************************

  void onSaisie() async {
    initLib();
    setState(() {});
  }

  Widget Valider(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
      width: 480,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Spacer(),
          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              widget.parc_Desc.ParcsDesc_Lib = initParcsDesc_Lib;
              widget.parc_Desc.ParcsDesc_Id = initParcsDesc_Id;
              widget.onSaisie();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_N_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              print("VALIDER EQUIP ${widget.parc_Desc.toString()}");
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("GAM") == 0) {
                Srv_DbTools.GAM_ID = widget.parc_Desc.ParcsDesc_Id.toString();
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("DESC") == 0) {
                Srv_DbTools.DESC_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("DESC2") == 0) {
                Srv_DbTools.DESC_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("FAB") == 0) {
                Srv_DbTools.FAB_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("FAB2") == 0) {
                Srv_DbTools.FAB_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("TYPE") == 0) {
                Srv_DbTools.TYPE_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("TYPE2") == 0) {
                Srv_DbTools.TYPE_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("ARM") == 0) {
                Srv_DbTools.ARM_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("INOX") == 0) {
                Srv_DbTools.INOX_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }

              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("DIAM") == 0) {
                Srv_DbTools.DIAM_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("LONG") == 0) {
                Srv_DbTools.LONG_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }

              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("DIF") == 0) {
                Srv_DbTools.DIF_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("DISP") == 0) {
                Srv_DbTools.DISP_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("PREM") == 0) {
                Srv_DbTools.PREM_Lib = widget.parc_Desc.ParcsDesc_Lib!;
                await DbTools.getRIA_Gammes_Ref();
              }

              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("PRS") == 0) {
                Srv_DbTools.PRS_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("CLF") == 0) {
                Srv_DbTools.CLF_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("MOB") == 0) {
                Srv_DbTools.MOB_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("PDT") == 0) {
                Srv_DbTools.PDT_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("POIDS") == 0) {
                Srv_DbTools.POIDS_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }
              if (widget.parc_Desc.ParcsDesc_Type!.compareTo("GAM") == 0) {
                Srv_DbTools.GAM_Lib = widget.parc_Desc.ParcsDesc_Lib!;
              }

              print("VALIDER EQUIP updateParc_Desc >>>>");

              await DbTools.updateParc_Desc(widget.parc_Desc, initParcsDesc_Lib);

              print("VALIDER EQUIP updateParc_Desc <<<");

              widget.onSaisie();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Poids(BuildContext context) {
    List<Widget> Rows = [];

    List<String> wSw = [];

    String wPoids = "";
    String wUnit = "Litres";
    int ToggleSwitchIndex = 0;

    if (widget.parc_Desc.ParcsDesc_Lib!.contains("Litres")) {
      wPoids = widget.parc_Desc.ParcsDesc_Lib!.replaceAll(" Litres", "");
      wUnit = "Litres";
      ToggleSwitchIndex = 0;
    } else if (widget.parc_Desc.ParcsDesc_Lib!.contains("Kilos")) {
      wPoids = widget.parc_Desc.ParcsDesc_Lib!.replaceAll(" Kilos", "");
      wUnit = "Kilos";
      ToggleSwitchIndex = 1;
    } else {
      wPoids = widget.parc_Desc.ParcsDesc_Lib!;
      wUnit = "Litres";
      ToggleSwitchIndex = 0;
    }

    if (widget.parc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
      wPoids = "";
    }

    if (Srv_DbTools.wKgL.contains("Litres")) {
      wUnit = "Litres";
      ToggleSwitchIndex = 0;
    } else if (Srv_DbTools.wKgL.contains("Kilos")) {
      wUnit = "Kilos";
      ToggleSwitchIndex = 0;
    } else
      tec_Saisie.text = wPoids;

    tec_Saisie.selection = TextSelection.fromPosition(TextPosition(offset: tec_Saisie.text.length));
    List<Widget> BtnCards = [];
    int nbBtn = 0;

    for (var element in Srv_DbTools.ListParam_Saisie_Param) {
      if (element.Param_Saisie_Param_Label.contains('Litres')) {
        if (!wSw.contains('Litres')) wSw.add('Litres');
      }
      if (element.Param_Saisie_Param_Label.contains('Kilos')) {
        if (!wSw.contains('Kilos')) wSw.add('Kilos');
      }

      String wTmp = element.Param_Saisie_Param_Label;
      wTmp = wTmp.replaceAll("Litres", "");
      wTmp = wTmp.replaceAll("Kilos", "");
      wTmp = wTmp.replaceAll(" ", "");

      print("element.Param_Saisie_Param_Label $wTmp $wPoids");

      BtnCards.add(BtnCardPoids(element.Param_Saisie_Param_Label, wUnit, element.Param_Saisie_Param_Id, wTmp == wPoids));

      nbBtn++;
      if (nbBtn == 3) {
        nbBtn = 0;
        Row wRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: BtnCards,
        );
        Rows.add(wRow);
        BtnCards = [];
      }
    }

    if (nbBtn > 0) {
      nbBtn = 0;
      Row wRow = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: BtnCards,
      );
      Rows.add(wRow);
      BtnCards = [];
    }

    print("POIDS $wUnit ${Rows.toString()}");

    return Container(
        child: Column(
      children: [
        wSw.length == 1
            ? Container()
            : Container(
                padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                child: ToggleSwitch(
                  activeBgColor: const [gColors.primaryGreen],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.grey[900],
                  minHeight: 32.0,
                  initialLabelIndex: ToggleSwitchIndex,
                  totalSwitches: Srv_DbTools.wKgL.isEmpty ? 2 : 1,
                  labels: Srv_DbTools.wKgL.isEmpty ? ['Litres', 'Kilos'] : [(Srv_DbTools.wKgL)],
                  onToggle: (index) async {
                    await HapticFeedback.vibrate();
                    index == 0 ? wUnit = "Litres" : wUnit = "Kilos";
                    widget.parc_Desc.ParcsDesc_Lib = "$wPoids $wUnit";
                    await Reload();
                  },
                ),
              ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: Rows,
        ),
        SizedBox(
          height: 55,
          width: 450,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
              child: Focus(
                child: TextFormField(
                  onChanged: (value) async {
                    await HapticFeedback.vibrate();
                    wPoids = value;
                    widget.parc_Desc.ParcsDesc_Lib = "$wPoids $wUnit";
                    await Reload();
                  },
                  controller: tec_Saisie,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onFocusChange: (hasFocus) {
                  wEditFocus = hasFocus;
                  print("wEditFocus $wEditFocus");
                  setState(() {});
                },
              )),
        ),
      ],
    ));
  }

  Widget BtnCardPoids(String wText, String wUnit, String wId, bool wSel) {
    Color BgColor = gColors.white;
    Color TxtColor = gColors.black;

    if (wSel) {
      BgColor = gColors.primaryGreen;
      TxtColor = gColors.white;
    }

    return SizedBox(
      width: 160,
      height: 60,
      child: Card(
        color: BgColor,
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(width: 1, color: Colors.grey)),
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            print(" POIDS SELECT wText $wText");

            widget.parc_Desc.ParcsDesc_Lib = wText;
            widget.parc_Desc.ParcsDesc_Id = wId;
            await Reload();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                wText,
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_N_Gr.copyWith(
                  color: TxtColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//**********************************
//**********************************
//**********************************

  Widget FlipFlop(BuildContext context) {
    List<Widget> Rows = [];

    List<Widget> BtnCards = [];
    int nbBtn = 0;
    wAide = "Aide : ";
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_Param.length; i++) {
      Param_Saisie_Param element = Srv_DbTools.ListParam_Saisie_Param[i];
      print("••••••••••••••• Param_Saisie_Param_Aide ${Srv_DbTools.ListParam_Saisie_Param.length} : ${element.Param_Saisie_Param_Label} ${element.Param_Saisie_Param_Aide}");

      if (widget.parc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
        if (element.Param_Saisie_Param_Default) {
          print(" G Param_Saisie_Param_Default");
          print("Param_Saisie_Param_Default  ${element.Param_Saisie_Param_Label}");
          widget.parc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
        }
      }

      //  print("BtnCards.add element ${element.Param_Saisie_ParamId}");
      BtnCards.add(BtnCard(element.Param_Saisie_Param_Label, element.Param_Saisie_Param_Id, element.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0, element.Param_Saisie_ParamId));

      if (element.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) {
        for (var elementAll in Srv_DbTools.ListParam_Saisie_ParamAll) {
          if (elementAll.Param_Saisie_Param_Id.compareTo(widget.param_Saisie.Param_Saisie_ID) == 0) {
            if (elementAll.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) {
              wAide += elementAll.Param_Saisie_Param_Aide;
            }
          }
        }
      }

      nbBtn++;
      if (nbBtn == 3) {
        nbBtn = 0;
        Row wRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: BtnCards,
        );
        Rows.add(wRow);
        BtnCards = [];
      }
    }

    if (nbBtn > 0) {
      nbBtn = 0;
      Row wRow = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: BtnCards,
      );
      Rows.add(wRow);
      BtnCards = [];
    }

    Rows.add(Container(
      width: 450,
      height: 95,
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            wAide,
            style: gColors.bodyTitle1_Aide,
            maxLines: 3,
          )
        ],
      ),
    ));

    return Container(
        child: Column(children: [
      Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: Rows,
          ),
        ),
      ),
    ]));
  }

  Widget BtnCard(String wText, String wId, bool wSel, int paramSaisieParamid) {
    Color BgColor = gColors.white;
    Color TxtColor = gColors.black;

    if (wSel) {
      BgColor = gColors.primaryGreen;
      TxtColor = gColors.white;
    }

    return SizedBox(
      width: 160,
      height: 60,
      child: Card(
        color: BgColor,
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(width: 1, color: Colors.grey)),
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            widget.parc_Desc.ParcsDesc_Lib = wText;
            widget.parc_Desc.ParcsDesc_Id = paramSaisieParamid.toString();
            print(" FlipFlop ${widget.parc_Desc.ParcsDesc_Id} ${widget.parc_Desc.ParcsDesc_Lib}");
            await setImage();
            await Reload();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                wText,
                textAlign: TextAlign.center,
                style: wSel
                    ? gColors.bodyTitle1_B_Gr.copyWith(
                        color: TxtColor,
                      )
                    : gColors.bodyTitle1_N_Gr.copyWith(
                        color: TxtColor,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

//**********************************
//**********************************
//**********************************

  Widget FlipFlopIco(BuildContext context) {
    List<Widget> Rows = [];

    List<Widget> BtnCards = [];
    int nbBtn = 0;
    wAide = "Aide : ";
    wIco = Container();

    for (var element in Srv_DbTools.ListParam_Saisie_Param) {
      if (widget.parc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
        if (element.Param_Saisie_Param_Default) {
          print(" H Param_Saisie_Param_Default");
          widget.parc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
        }
      }

      BtnCards.add(BtnCardIco(
        element.Param_Saisie_Param_Label,
        element.Param_Saisie_Param_Id,
        element.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0,
        element.Param_Saisie_Param_Ico,
      ));

      if (element.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) {
        for (var elementAll in Srv_DbTools.ListParam_Saisie_ParamAll) {
          if (elementAll.Param_Saisie_Param_Id.compareTo(widget.param_Saisie.Param_Saisie_ID) == 0) {
            if (elementAll.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) {
              wAide += elementAll.Param_Saisie_Param_Aide;
              wIco = Container(
                width: 450,
                padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    elementAll.Param_Saisie_Param_Ico,
                  ],
                ),
              );
            }
          }
        }
      }

      nbBtn++;
      if (nbBtn == 3) {
        nbBtn = 0;
        Row wRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: BtnCards,
        );
        Rows.add(wRow);
        BtnCards = [];
      }
    }

    if (nbBtn > 0) {
      nbBtn = 0;
      Row wRow = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: BtnCards,
      );
      Rows.add(wRow);
      BtnCards = [];
    }

    Rows.add(Container(
      width: 450,
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            wAide,
//            textAlign: TextAlign.center,
            style: gColors.bodyTitle1_Aide,
            maxLines: 3,
          )
        ],
      ),
    ));

    Rows.add(wIco);

    return Container(
        child: Column(children: [
      Container(
        //     height: 660,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: Rows,
          ),
        ),
      ),
    ]));
  }

  Widget BtnCardIco(String wText, String wId, bool wSel, Widget wIco) {
    Color BgColor = gColors.white;
    Color TxtColor = gColors.black;

    if (wSel) {
      BgColor = gColors.primaryGreen;
      TxtColor = gColors.white;
    }
    return SizedBox(
      width: 160,
      height: 60,
      child: Card(
        color: BgColor,
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(width: 1, color: Colors.grey)),
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            widget.parc_Desc.ParcsDesc_Lib = wText;

            await Reload();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                wText,
                textAlign: TextAlign.center,
                style: wSel
                    ? gColors.bodyTitle1_B_Gr.copyWith(
                        color: TxtColor,
                      )
                    : gColors.bodyTitle1_N_Gr.copyWith(
                        color: TxtColor,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//**********************************
//**********************************
//**********************************

  Widget FlipFlopEdt(BuildContext context) {
    List<Widget> Rows = [];

    List<Widget> BtnCards = [];
    int nbBtn = 0;
    wAide = "Aide : ";
    for (var element in Srv_DbTools.ListParam_Saisie_Param) {
      print("element.Param_Saisie_Param_Label A ${element.Param_Saisie_Param_Label} ${widget.parc_Desc.ParcsDesc_Lib}");

      if (widget.parc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
        if (element.Param_Saisie_Param_Default) {
          print(" I Param_Saisie_Param_Default");

          widget.parc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
        }
      }

      BtnCards.add(BtnCard(element.Param_Saisie_Param_Label, element.Param_Saisie_Param_Id, element.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0, element.Param_Saisie_ParamId));

      if (element.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) wAide += element.Param_Saisie_Param_Aide;

      nbBtn++;
      if (nbBtn == 3) {
        nbBtn = 0;
        Row wRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: BtnCards,
        );
        Rows.add(wRow);
        BtnCards = [];
      }
    }

    if (nbBtn > 0) {
      nbBtn = 0;
      Row wRow = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: BtnCards,
      );
      Rows.add(wRow);
      BtnCards = [];
    }
    tec_Saisie.text = widget.parc_Desc.ParcsDesc_Lib!;
    if (tec_Saisie.text.compareTo("---") == 0) tec_Saisie.text = "";

    tec_Saisie.selection = TextSelection.fromPosition(TextPosition(offset: tec_Saisie.text.length));

    Rows.add(Container(
      width: 450,
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            wAide,
//            textAlign: TextAlign.center,
            style: gColors.bodyTitle1_Aide,
            maxLines: 3,
          )
        ],
      ),
    ));

    return Container(
        child: Column(
      children: [
        Container(
//          height: wEditFocus ? 220 : null,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: Rows,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: 450,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
              child: Focus(
                child: TextFormField(
                  onChanged: (value) async {
                    await HapticFeedback.vibrate();
                    widget.parc_Desc.ParcsDesc_Lib = value;
                  },
                  controller: tec_Saisie,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onFocusChange: (hasFocus) {
                  wEditFocus = hasFocus;
                  print("wEditFocus $wEditFocus");
                  setState(() {});
                },
              )),
        ),
      ],
    ));
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Annee(BuildContext context) {
    List<String> ListMonth = DateFormat.EEEE('fr').dateSymbols.MONTHS;
    print(ListMonth);

    int selectedMonth = 0;

    int currentYear = DateTime.now().year;
    int startingYear = 1990;
    List ListYear = List.generate((currentYear - startingYear) + 1, (index) => startingYear + index);

    int selectedYear = 0;

    int wM = 0;
    int wY = ListYear.length - 1;
    int wYi = 0;

    if (widget.parc_Desc.ParcsDesc_Lib!.isNotEmpty) {
      if (!widget.parc_Desc.ParcsDesc_Lib!.contains("---")) {
        List<String> Decompo = widget.parc_Desc.ParcsDesc_Lib!.split("-");
        if (Decompo.length == 1) {
          wY = int.parse(widget.parc_Desc.ParcsDesc_Lib!);
        } else {
          wM = int.parse(Decompo[0]) - 1;
          wY = int.parse(Decompo[1]);
        }
      } else {
        wY = DateTime.now().year;
        widget.parc_Desc.ParcsDesc_Lib = "1-$wY";
      }
    }

    wYi = wY - 1990;

    print("wY $wM $wY");

    selectedMonth = wM + 1;
    selectedYear = wY;

    return SizedBox(
        height: 300,
        width: 450,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 210,
                  width: 160,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: wM),
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32,
                    onSelectedItemChanged: (int selectedItem) async {
                      await HapticFeedback.vibrate();
                      selectedMonth = selectedItem + 1;
                      print("_selectedMonth $selectedMonth");
                      widget.parc_Desc.ParcsDesc_Lib = "$selectedMonth-$selectedYear";
                      setState(() {});
                    },
                    children: List<Widget>.generate(ListMonth.length, (int index) {
                      DateTime wDT = DateTime(selectedYear, index + 1, 1);
                      LocalDate a = LocalDate.today();
                      LocalDate b = LocalDate.dateTime(wDT);
                      Period diff = a.periodSince(b);


                      return Center(
                        child: Text(
                          ListMonth[index],
                          style: diff.years >= 10 ? gColors.bodyTitle1_B_Pr.copyWith(color: Colors.red) : gColors.bodyTitle1_B_Pr,
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 210,
                  width: 160,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: wYi),
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32,
                    onSelectedItemChanged: (int selectedItem) async {
                      await HapticFeedback.vibrate();
                      selectedYear = selectedItem + 1990;
                      print("_selectedYear $selectedYear");
                      widget.parc_Desc.ParcsDesc_Lib = "$selectedMonth-$selectedYear";
                      setState(() {});
                    },
                    children: List<Widget>.generate(ListYear.length, (int index) {
                      DateTime wDT = DateTime(ListYear[index], selectedMonth, 1);
                      LocalDate a = LocalDate.today();
                      LocalDate b = LocalDate.dateTime(wDT);
                      Period diff = a.periodSince(b);

                      print("diff.years >=10 ${diff.years}");

                      return Center(
                        child: Text(
                          ListYear[index].toString(),
                          style: diff.years >= 10 ? gColors.bodyTitle1_B_Pr.copyWith(color: Colors.red) : gColors.bodyTitle1_B_Pr,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  String wNiv = "RDC";
  int _selectedNiv = 0;
  int wNum = 0;

  String wDbg = "";
  List<String> ListNiv = ["Niveau", "Demi niveau"];

  List<int> ListNum = [];

  FixedExtentScrollController? scrollControllerNum;
  FixedExtentScrollController? scrollControllerNiv;

  Widget Niv(BuildContext context) {
    print("***** NIV() ***** ${widget.parc_Desc.ParcsDesc_Lib}");

    ListNum.clear();
    for (int i = 163; i >= -163; i--) {
      ListNum.add(i);
    }
//    print(ListNum);
    int selectedNum = 163;

    String wTmp = widget.parc_Desc.ParcsDesc_Lib!;
    wTmp = wTmp.replaceAll("RDC", "").trim();
    wTmp = wTmp.replaceAll("R", "").trim();
    wTmp = wTmp.replaceAll("Niveau", "").trim();
    wTmp = wTmp.replaceAll("Demi", "").trim();

    selectedNum = (int.tryParse(wTmp) ?? 0) * -1 + 163;

    scrollControllerNum = FixedExtentScrollController(initialItem: selectedNum);
    print("wTmp $wTmp $selectedNum");

/*
    widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("RDC", "Niveau");
    print(">>>>>>>>>>>>A ${widget.parc_Desc.ParcsDesc_Lib!}");
    widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("R", "Niveau");
    print(">>>>>>>>>>>>B ${widget.parc_Desc.ParcsDesc_Lib!}");
    widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("Demi", "Demi niveau");
    print(">>>>>>>>>>>>C ${widget.parc_Desc.ParcsDesc_Lib!}");
    _selectedNiv = 0;
    wNiv = "Niveau";
*/

    if (widget.parc_Desc.ParcsDesc_Lib!.isNotEmpty) {
      if (widget.parc_Desc.ParcsDesc_Lib!.contains("Demi")) {
        _selectedNiv = 1;
        wNiv = "Demi niveau";
        print(">>> Demi niveau");
      } else if (widget.parc_Desc.ParcsDesc_Lib!.contains("Niveau")) {
        _selectedNiv = 0;
        wNiv = "Niveau";
        print(">>> Niveau");
      }
    }

    if (widget.parc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) widget.parc_Desc.ParcsDesc_Lib = "RDC";

    scrollControllerNiv = FixedExtentScrollController(initialItem: _selectedNiv);

    return SizedBox(
        height: 270,
        width: 450,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 210,
                  width: 160,
                  child: CupertinoPicker(
                    scrollController: scrollControllerNiv,
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32,
                    onSelectedItemChanged: (int selectedItem) async {
                      await HapticFeedback.vibrate();

                      print("Sel Niv =$selectedItem ${ListNiv[selectedItem]}");
                      _selectedNiv = selectedItem;
                      wNiv = ListNiv[selectedItem];
                      wNum = ListNum[scrollControllerNum!.selectedItem];

                      print("NIVEAU Ab = $wNiv$wNum");
                      if (wNum > 0) {
                        widget.parc_Desc.ParcsDesc_Lib = "$wNiv+$wNum";
                      } else {
                        widget.parc_Desc.ParcsDesc_Lib = "$wNiv$wNum";
                      }

                      widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("Demi niveau0", "RDC");
                      widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("Niveau0", "RDC");
                      widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("Demi niveau", "Demi");
                      widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("Niveau", "R");

                      setState(() {});
                    },
                    children: List<Widget>.generate(ListNiv.length, (int index) {
                      return Center(
                        child: Text(
                          ListNiv[index],
                          style: gColors.bodyTitle1_B_Pr,
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 210,
                  width: 160,
                  child: CupertinoPicker(
                    scrollController: scrollControllerNum,
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32,
                    onSelectedItemChanged: (int selectedItem) async {
                      await HapticFeedback.vibrate();

                      print("Sel Num =$selectedItem ${ListNum[selectedItem]}");

                      selectedNum = selectedItem;
                      wNum = ListNum[selectedNum];
                      wNiv = ListNiv[scrollControllerNiv!.selectedItem];

                      print("NIVEAU Bb = $wNiv$wNum");
                      if (wNum > 0) {
                        widget.parc_Desc.ParcsDesc_Lib = "$wNiv+$wNum";
                      } else {
                        widget.parc_Desc.ParcsDesc_Lib = "$wNiv$wNum";
                      }

                      widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("Demi niveau0", "RDC");
                      widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("Niveau0", "RDC");
                      widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("Demi niveau", "Demi");
                      widget.parc_Desc.ParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!.replaceAll("Niveau", "R");

                      setState(() {});
                    },
                    children: List<Widget>.generate(ListNum.length, (int index) {
                      String wAff = ListNum[index].toString();
                      if (ListNum[index] > 0) wAff = "+${ListNum[index]}";
                      if (ListNum[index] == 0) wAff = "RDC";

                      return Center(
                        child: Text(
                          wAff,
                          style: gColors.bodyTitle1_B_Pr,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  //**********************************
  //**********************************

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  void _scrollToBottom(double index) {
    print("scrollController.position.maxScrollExtent ${scrollController.position.maxScrollExtent}");
    if (scrollController.hasClients) {
      double ii = 27.0 * (index);
      scrollController.animateTo(ii, //scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticOut);
    } else {
      Timer(const Duration(milliseconds: 400), () => _scrollToBottom(index));
    }
  }

  Widget Liste(BuildContext context) {
    print("tec_Search.text ${tec_Search.text}");
    print("tec_Saisie.text ${tec_Saisie.text}");

    Srv_DbTools.ListParam_Saisie_Paramsearchresult.clear();
    if (tec_Search.text.isEmpty) {
      Srv_DbTools.ListParam_Saisie_Paramsearchresult.addAll(Srv_DbTools.ListParam_Saisie_Param);
    } else {
      for (var element in Srv_DbTools.ListParam_Saisie_Param) {
        String tecSearchlc = tec_Search.text.toLowerCase();
        String tecSearchra = tecSearchlc.replaceAll(" ", "");

        String paramSaisieParamLabellc = element.Param_Saisie_Param_Label.toLowerCase();
        String paramSaisieParamLabelra = paramSaisieParamLabellc.replaceAll(" ", "");

        if (paramSaisieParamLabelra.contains(tecSearchra)) {
          Srv_DbTools.ListParam_Saisie_Paramsearchresult.add(element);
        }
      }
    }

    double index = 0;
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
      if (Srv_DbTools.ListParam_Saisie_Paramsearchresult[i].Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) {
        index = double.parse("$i");
        break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(index));

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).viewInsets.bottom != 0 ? 324 : 515,
          width: 450,
          decoration: BoxDecoration(
            color: gColors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: Srv_DbTools.ListParam_Saisie_Paramsearchresult.length,
                  itemBuilder: (context, index) {
                    final item = Srv_DbTools.ListParam_Saisie_Paramsearchresult[index];
                    return InkWell(
                        onTap: () async {
                          await HapticFeedback.vibrate();
                          print("scrollController 2 index $index ${scrollController.position}  ${item.Param_Saisie_Param_Label}  ${item.Param_Saisie_Param_Id}");
                          widget.parc_Desc.ParcsDesc_Lib = item.Param_Saisie_Param_Label;
                          widget.parc_Desc.ParcsDesc_Id = item.Param_Saisie_Param_Id;
                          await Reload();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: (item.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) ? gColors.primaryGreen : Colors.transparent,
                              border: Border.all(
                                color: (item.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) ? gColors.primaryGreen : Colors.transparent,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
//              margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 5), // TED
                            height: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.Param_Saisie_Param_Label,
                                    textAlign: TextAlign.center,
                                    style: gColors.bodyTitle1_B_Gr.copyWith(
                                      color: (item.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) ? gColors.white : gColors.primary,
                                    ))
                              ],
                            )));
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 50,
          width: 450,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 4,
              right: 0,
              left: 0,
            ),
            child: Focus(
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    print("value $value");
                  });
                },
                controller: tec_Search,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Recherche',
                  hintStyle: gColors.bodyTitle1_N_Gr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onFocusChange: (hasFocus) {
                wEditFocus = hasFocus;
                print("wEditFocus $wEditFocus");
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget ListeEdt(BuildContext context) {
    print("tec_Search.text ${tec_Search.text}");
    print("tec_Saisie.text ${tec_Saisie.text}");

    Srv_DbTools.ListParam_Saisie_Paramsearchresult.clear();




    if (tec_Search.text.isEmpty) {
      Srv_DbTools.ListParam_Saisie_Paramsearchresult.addAll(Srv_DbTools.ListParam_Saisie_Param);
    } else {
      for (var element in Srv_DbTools.ListParam_Saisie_Param) {
        if (element.Param_Saisie_Param_Label.toLowerCase().contains(tec_Search.text.toLowerCase())) {
          Srv_DbTools.ListParam_Saisie_Paramsearchresult.add(element);
        }
      }
    }


    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
      if (widget.parc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
        var element = Srv_DbTools.ListParam_Saisie_Paramsearchresult[i];
        if (element.Param_Saisie_Param_Default) {
          print(" I Param_Saisie_Param_Default");
          widget.parc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
        }
      }
    }

    double index = 0;
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
      if (Srv_DbTools.ListParam_Saisie_Paramsearchresult[i].Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) {
        index = double.parse("$i");
        break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(index));

    tec_Saisie.text = widget.parc_Desc.ParcsDesc_Lib!;
    tec_Saisie.selection = TextSelection.fromPosition(TextPosition(offset: tec_Saisie.text.length));

    return Column(
      children: [
        SizedBox(
          height: 40,
          width: 450,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              bottom: 4,
              right: 0,
              left: 0,
            ),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  print("value $value");
                });
              },
              controller: tec_Search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Recherche',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 324,
          width: 450,
          decoration: BoxDecoration(
            color: gColors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: Srv_DbTools.ListParam_Saisie_Paramsearchresult.length,
            itemBuilder: (context, index) {
              final item = Srv_DbTools.ListParam_Saisie_Paramsearchresult[index];
              return InkWell(
                  onTap: () async {
                    await HapticFeedback.vibrate();
                    print("scrollController index $index ${scrollController.position}");
                    widget.parc_Desc.ParcsDesc_Id = item.Param_Saisie_Param_Id;
                    widget.parc_Desc.ParcsDesc_Lib = item.Param_Saisie_Param_Label;
                    tec_Saisie.text = item.Param_Saisie_Param_Label;
                    tec_Saisie.selection = TextSelection.fromPosition(TextPosition(offset: tec_Saisie.text.length));

                    await Reload();
                  },
                  child: Container(
//              margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5), // TED

                      color: (item.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) ? gColors.primaryGreen : Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.Param_Saisie_Param_Label,
                              textAlign: TextAlign.center,
                              style: gColors.bodyTitle1_B_Gr.copyWith(
                                color: (item.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) ? gColors.white : gColors.primary,
                              ))
                        ],
                      )));
            },
          ),
        ),
        SizedBox(
          height: 50,
          width: 450,
          child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 4,
                right: 0,
                left: 0,
              ),
              child: Focus(
                child: TextFormField(
                  onChanged: (value) async {
                    await HapticFeedback.vibrate();
                    widget.parc_Desc.ParcsDesc_Lib = value;
                  },
                  controller: tec_Saisie,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onFocusChange: (hasFocus) {
                  wEditFocus = hasFocus;
                  print("wEditFocus $wEditFocus");
                  setState(() {});
                },
              )),
        ),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  final txtController = TextEditingController();

  Widget EdtTxt(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 450,
          decoration: BoxDecoration(
            color: gColors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: TextField(
            keyboardType: TextInputType.visiblePassword,
            controller: txtController,
            autofocus: false,
            decoration: InputDecoration(
              hintText: widget.param_Saisie.Param_Saisie_Label,
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
            onChanged: (value) async {
              await HapticFeedback.vibrate();
              widget.parc_Desc.ParcsDesc_Lib = txtController.text;
            },
          ),
        ),
      ],
    );
  }

  Widget EdtTxtNR(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 450,
          decoration: BoxDecoration(
            color: gColors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: TextField(
            keyboardType: TextInputType.visiblePassword,
            controller: txtController,
            autofocus: false,
            decoration: InputDecoration(
              hintText: widget.param_Saisie.Param_Saisie_Label,
              contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
              suffixIcon: IconButton(
                onPressed: txtController.clear,
                icon: const Icon(Icons.clear),
              ),
            ),
            onChanged: (value) async {
              await HapticFeedback.vibrate();
              widget.parc_Desc.ParcsDesc_Lib = txtController.text.toUpperCase();
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          height: 50,
          width: 450,
          child: ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              txtController.text = "Non renseigné sur l'équipement";
              widget.parc_Desc.ParcsDesc_Lib = txtController.text;
              await HapticFeedback.vibrate();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.white,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.black,
                )),
            child: Text("Non renseigné sur l'équipement", style: gColors.bodyTitle1_N_Gr),
          ),
        ),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  String ErrorQrc = "";

  Widget Qrc(BuildContext context) {
    return InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          var result = await BarcodeScanner.scan();
          print("result.type ${result.type}");
          print("result.rawContent ${result.rawContent}");
          print("result.format ${result.format}");

          widget.parc_Desc.ParcsDesc_Lib = "";
          ErrorQrc = "Erreur de lecture ou de QR Code";
          if (result.type.toString().compareTo("Barcode") == 0) {
            if (result.format.toString().compareTo("qr") == 0) {
              if (result.rawContent.toString().startsWith("M")) {
                if (result.rawContent.toString().endsWith("F")) {
                  widget.parc_Desc.ParcsDesc_Lib = result.rawContent;
                  ErrorQrc = "";
                }
              }
            }
          }

          print("${widget.parc_Desc.ParcsDesc_Lib}");
          setState(() {});
        },
        child: Expanded(
          child: SizedBox(
              width: 350,
//              color: Colors.amberAccent,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.qr_code),
                      Container(
                        width: 20,
                      ),
                      Text(
                        "Code:  ${widget.parc_Desc.ParcsDesc_Lib!}",
                        style: gColors.bodyTitle1_B_Gr,
                      ),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    ErrorQrc,
                    style: gColors.bodyTitle1_B_Gr.copyWith(
                      color: gColors.primaryRed,
                    ),
                  ),
                ],
              )),
        ));
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Txt(BuildContext context) {
    return const Text("Txt");
  }
}
