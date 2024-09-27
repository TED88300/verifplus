import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Link_Verif_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Article.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_ArticleAss.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Verif_Saisie.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Tools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gDialogs.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Inter_Verif extends StatefulWidget {
  final VoidCallback onMaj;
  final String x_t;

  const Client_Groupe_Parc_Inter_Verif({Key? key, required this.onMaj, required this.x_t}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_VerifState createState() => Client_Groupe_Parc_Inter_VerifState();
}

class Client_Groupe_Parc_Inter_VerifState extends State<Client_Groupe_Parc_Inter_Verif> {
  final txtController = TextEditingController();
  Parc_Art parc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);

  Parc_Art parc_ArtES = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
  String ParcsArt_Lib = "---";

  bool isRes = true;

  List<String> wVerifDeb = [];
  List<String> wVerifFin = [];

  double ImgSize = 155;

  bool isProp = true;

  bool isImage = false;
  List<Widget> imgList = [];

  Future onDelete() async {
    await initLib();
  }

  Future Reload() async {
    DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, 1);
    print("glfParc_Imgs lenght ${DbTools.glfParc_Imgs.length}");
    if (DbTools.glfParc_Imgs.length > 0) {
      imgList.clear();

      for (int i = 0; i < DbTools.glfParc_Imgs.length; i++) {
        var element = DbTools.glfParc_Imgs[i];
        var bytes = base64Decode(element.Parc_Imgs_Data!);
        Widget wWidget = Container();
        if (bytes.length > 0) {
          wWidget = ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
              height: ImgSize,
              width: ImgSize,
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
  Future initLib() async {
//    print("initLib Client_Groupe_Parc_Inter_Verif >>> A ListParam_Verif_Base ${Srv_DbTools.ListParam_Verif_Base.length}");
    DbTools.lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "ES");
    ParcsArt_Lib = "---";
    if (DbTools.lParcs_Art.length > 0) {
      parc_Art = DbTools.lParcs_Art[0];
      print("parc_Art ${parc_Art.toString()}");
      ParcsArt_Lib = "${parc_Art.ParcsArt_Id} ${parc_Art.ParcsArt_Lib}";
      parc_ArtES = parc_Art;
    }

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERIF initLib");

    for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Verif_Base[i];

      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERIF element ${element.Param_Saisie_ID} ${element.Param_Saisie_Type} ${element.Param_Saisie_Label}");

      Parc_Desc wParc_Desc = await DbTools.getParcs_Desc_Id_Type_Add(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);
    }

    DbTools.glfParcs_Desc = await DbTools.getParcs_Desc(DbTools.gParc_Ent.ParcsId!);

    txtController.text = DbTools.gParc_Ent.Parcs_Verif_Note!;

    await Reload();
  }

  void initState() {
    initLib();
    super.initState();
  }

  void onSaisie() async {
    initLib();
    widget.onMaj();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb.length; i++) {
      Result_Article_Link_Verif wLink = Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb[i];
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1,
              color: gColors.greyDark,
            ),
            buildDesc(context),
            Container(height: 1, color: gColors.greyDark),
            buildNote(context),
            Container(height: 80),
          ],
        )),
      ),
    );
  }

  @override
  Widget buildEnt(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 5, 10, 8),
      color: gColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${widget.x_t}",
            style: gColors.bodyTitle1_N_Gr,
          ),
        ],
      ),
    );
  }

  Widget buildNote(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.black,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                color: gColors.white,
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: txtController,
              style: gColors.bodyTitle1_N_Gr,
              autofocus: false,
              maxLines: 7,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                border: InputBorder.none,
              ),
              onChanged: (value) async {
                await HapticFeedback.vibrate();
                DbTools.gParc_Ent.Parcs_Verif_Note = value;
                print(" updateParc_Ent E");
                DbTools.updateParc_Ent(DbTools.gParc_Ent);
              },
            ),
          ),
        ),
        InkWell(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: isImage
                    ? imgList[0]
                    : Image.asset(
                        "assets/images/Icon_Photo.png",
                        height: ImgSize,
                        width: ImgSize,
                      ),
              ),
            ),
            onTap: () async {
              print("on Photo");
              DbTools.gParc_Img_Type = 1;
              DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, 1);

              await gDialogs.Dialog_Photo(context);
              await Reload();
            }),
      ],
    );
  }

  @override
  Widget buildDesc(BuildContext context) {
    double LargeurCol = 300;
    double LargeurCol2 = gColors.MediaQuerysizewidth - LargeurCol - 60;

    double H = 4;
    double H2 = 4;

    List<Widget> RowSaisies = [];

    Srv_DbTools.ListParam_Verif_Base.sort(Srv_DbTools.affSortComparison);

    isRes = true;
    bool isEmpty = true;

    bool is5ans = false;
    bool is10ans = false;

    print("buildDesc DbTools.gDateMS ${DbTools.gDateMS}");

    try {
      String wMois = "";
      String wAnnee = "";
      int wInd = DbTools.gDateMS.indexOf("-");
      print("buildDesc indexoff ${wInd}");
      wMois = DbTools.gDateMS.substring(0, wInd);
      wAnnee = DbTools.gDateMS.substring(wInd + 1);
      print("buildDesc wMois ${wMois}");
      print("buildDesc wAnnee ${wAnnee}");
      DateTime wDateMS = DateTime(int.tryParse(wAnnee) ?? 2024, int.tryParse(wMois) ?? 1, 1);
      DateTime wDateNow = DateTime.now();
      int wYears = (wDateNow.difference(wDateMS).inDays ~/ 365);
      print("buildDesc wDateNow.difference(wDateMS).inDays ${wDateNow.difference(wDateMS).inDays} ${wYears}");

      is5ans = wYears >= 5;
      is10ans = wYears >= 10;

      print("buildDesc is5ans ${is5ans}");
      print("buildDesc is10ans ${is10ans}");
    } catch (e) {}

    for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Verif_Base[i];

      Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);

      if (element.Param_Saisie_ID.contains("IntMaint")) {
        element.Param_Saisie_Label = "Intervention de maintenance";
      }
      if (element.Param_Saisie_ID.contains("RES") && wParc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
        isRes = false;
      }

      if (!element.Param_Saisie_ID.contains("Result")) {
        if (wParc_Desc.ParcsDesc_Lib != "---") isEmpty = false;
      }

      if (element.Param_Saisie_ID.contains("Ech")) {
        if (isRes) {
          RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
        }
      } else if (element.Param_Saisie_ID.contains("Ext")) {
        if (isRes) {
          RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
        }
      } else if (element.Param_Saisie_ID.contains("VerifQuin2")) {
        if (is5ans) RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
      } else if (element.Param_Saisie_ID.contains("VerifDec2")) {
        if (is10ans) RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
      } else if (element.Param_Saisie_ID.contains("PRARR")) {
        print("Srv_DbTools.SIT_Lib PRARR ${Srv_DbTools.SIT_Lib}");
        if (Srv_DbTools.SIT_Lib.contains("Défavorisé")) RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
      } else if (element.Param_Saisie_ID.contains("DEBIT")) {
        print("Srv_DbTools.SIT_Lib DEBIT ${Srv_DbTools.SIT_Lib}");
        if (Srv_DbTools.SIT_Lib.contains("Favorisé")) RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
      } else {
        RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
      }
    }

    if (isEmpty) {
      Maj_Result_NV();
    }

    return
        //Expanded(child:
        Container(
//          width: 640,
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                color: gColors.greyDark,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  color: gColors.greyLight,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    itemCount: RowSaisies.length,
                    itemBuilder: (context, index) {
                      return RowSaisies[index];
                    },
                    separatorBuilder: (BuildContext context, int index) => Container(height: 1, width: double.infinity, color: gColors.greyDark),
                  ),
                )))
        //)
        ;
  }

  Future<Image> GetImage(Parc_Art art) async {
    if (art.wImgeTrv) return art.wImage!;

    String wImgPath = "${Srv_DbTools.SrvImg}ArticlesImg_Ebp_${art.ParcsArt_Id}s.jpg";
    gObj.pic = await gObj.networkImageToByte(wImgPath);
    if (gObj.pic.length > 0) {
      art.wImgeTrv = true;
      art.wImage = Image.memory(
        gObj.pic,
        fit: BoxFit.scaleDown,
        width: 30,
        height: 30,
      );
      return art.wImage!;
    }
    return Image.asset(
      "assets/images/Audit_det.png",
      height: 30,
      width: 30,
    );
  }

  Widget buildImage(BuildContext context, Parc_Art art) {
    return new FutureBuilder(
      future: GetImage(art),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return new Container(width: 30);
        }
      },
    );
  }

  Widget RowSaisie(Param_Saisie param_Saisie, double LargeurCol, double LargeurCol2, double H2, {bool Indispo: false}) {
//    print("RowSaisie ${param_Saisie.Param_Saisie_ID}");

    Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, param_Saisie.Param_Saisie_ID);

    double IcoWidth = 30;
    Param_Saisie_Param wParam_Saisie_Param = Srv_DbTools.getParam_Saisie_ParamMem_Lib(param_Saisie.Param_Saisie_ID, wParc_Desc.ParcsDesc_Lib!);
    if (param_Saisie.Param_Saisie_Icon.compareTo("") == 0) LargeurCol += 40;

    if (param_Saisie.Param_Saisie_Icon == "Verif_prs") {
      Color wColor = Colors.green;
      String wUnit = "bar";
      String wNC = "";

      if (wParc_Desc.ParcsDesc_Type == "DEBIT") wUnit = "l/min";

      if (wParc_Desc.ParcsDesc_Type == "PRDIF") {
        double wDouble = double.parse(wParc_Desc.ParcsDesc_Id!);
        if (wDouble < 2) {
          wNC = "_nc";
          wColor = Colors.red;
        }
      }
      if (wParc_Desc.ParcsDesc_Type == "PRARR") {
        double wDouble = double.parse(wParc_Desc.ParcsDesc_Id!);
        double dPivotm = 2;
        double dPivotM = 2;

        if (Srv_DbTools.DIAM_Lib.contains("19/6")) {
          dPivotm = 4;
          dPivotM = 12;
        } else if (Srv_DbTools.DIAM_Lib.contains("25/8")) {
          dPivotm = 3.5;
          dPivotM = 12;
        } else if (Srv_DbTools.DIAM_Lib.contains("33/12")) {
          dPivotm = 3;
          dPivotM = 7;
        }

        if (wDouble < dPivotm || wDouble > dPivotM) {
          wNC = "_nc";
          wColor = Colors.red;
        }
      }

      return Container(
          color: Colors.white,
          height: 45,
          child: InkWell(
            onTap: () async {
              print("InkWell Saisie A");
              await HapticFeedback.vibrate();
              print("InkWell Saisie B ${param_Saisie.toMap()}");
              print("InkWell Saisie C ${wParc_Desc.toString()}");

              print("InkWell Saisie D ${wParc_Desc.ParcsDesc_Type}");

              await Client_Groupe_Parc_Inter_Verif_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, param_Saisie, wParc_Desc);
              setState(() {});
            },
            child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Image.asset(
                    "assets/images/${param_Saisie.Param_Saisie_Icon}${wNC}.png",
                    height: IcoWidth,
                    width: IcoWidth,
                  ),
                ),
                Container(
                  width: 435,
                  height: 20,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    "${param_Saisie.Param_Saisie_Label}",
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ),
                Spacer(),
                Container(
                  width: 135,
                  height: 20,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    "${wParc_Desc.ParcsDesc_Id} ${wUnit} >",
                    style: gColors.bodyTitle1_B_Gr.copyWith(color: wColor),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ));
    } else if (Indispo)
      return Container(
        color: param_Saisie.Param_Saisie_Icon.contains("Verif_") || param_Saisie.Param_Saisie_Icon.compareTo("IntMaint") == 0 || param_Saisie.Param_Saisie_Icon.compareTo("Ech") == 0 || param_Saisie.Param_Saisie_Icon.compareTo("Result") == 0 ? gColors.greyLight : Colors.white,
        height: 45,
        child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Image.asset(
                "assets/images/${param_Saisie.Param_Saisie_Icon}.png",
                height: IcoWidth,
                width: IcoWidth,
              ),
            ),
            Container(
              width: 535,
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "${param_Saisie.Param_Saisie_Label}",
                style: gColors.bodyTitle1_B_Gr.copyWith(
                  color: gColors.LinearGradient1,
                ),
              ),
            ),
          ],
        ),
      );
    else
      return Container(
          color: param_Saisie.Param_Saisie_Icon.contains("Verif_") || param_Saisie.Param_Saisie_Icon.compareTo("IntMaint") == 0 || param_Saisie.Param_Saisie_Icon.compareTo("Ech") == 0 || param_Saisie.Param_Saisie_Icon.compareTo("Result") == 0 ? gColors.greyLight : Colors.white,
          height: 45,
          child: InkWell(
            onTap: () async {
              print("InkWell Saisie A");
              await HapticFeedback.vibrate();
              if (param_Saisie.Param_Saisie_Icon.compareTo("Verif_renouv") == 0 || param_Saisie.Param_Saisie_Icon.compareTo("Ech") == 0) {
                print("InkWell Saisie B");
                await HapticFeedback.vibrate();
                await Client_Groupe_Parc_Inter_Article_Dialog.Dialogs_Saisie(context, onSaisie, "ES");
              } else if (!wParc_Desc.ParcsDesc_Lib!.contains(">")) {
                print("InkWell Saisie C ${wParc_Desc.toString()}");
                await Client_Groupe_Parc_Inter_Verif_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, param_Saisie, wParc_Desc);
              }
              setState(() {});
            },
            child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                ),
                param_Saisie.Param_Saisie_ID.compareTo("Ext") == 0
                    ? Container(margin: EdgeInsets.fromLTRB(0, 0, 10, 0), height: IcoWidth, width: IcoWidth, color: Colors.white, child: buildImage(context, parc_ArtES))
                    : param_Saisie.Param_Saisie_Icon.compareTo("") == 0
                        ? Container(
                            width: 0,
                          )
                        : Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.asset(
                              "assets/images/${param_Saisie.Param_Saisie_Icon}.png",
                              height: IcoWidth,
                              width: IcoWidth,
                            ),
                          ),
                Container(
                  width: param_Saisie.Param_Saisie_ID.compareTo("Ext") == 0 ? 535 : LargeurCol,
                  height: 20,
                  padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                  child: Text(
                    param_Saisie.Param_Saisie_ID.compareTo("Ext") == 0 ? "${ParcsArt_Lib}" : "${param_Saisie.Param_Saisie_Label}",
                    style: param_Saisie.Param_Saisie_ID.compareTo("Ext") == 0 ? gColors.bodyTitle1_B_Gr.copyWith(color: Colors.green) : gColors.bodyTitle1_B_Gr,
                  ),
                ),
                param_Saisie.Param_Saisie_ID.compareTo("Ext") == 0
                    ? Container()
                    : Expanded(
                        child: Row(
                        children: [
                          param_Saisie.Param_Saisie_Icon.compareTo("Verif_renouv") == 0 || param_Saisie.Param_Saisie_Icon.compareTo("Ech") == 0 ? Spacer() : Container(),
                          param_Saisie.Param_Saisie_Icon.compareTo("Verif_renouv") == 0 || param_Saisie.Param_Saisie_Icon.compareTo("Ech") == 0
                              ? Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await HapticFeedback.vibrate();
                                      await Client_Groupe_Parc_Inter_Article_Dialog.Dialogs_Saisie(context, onSaisie, "ES");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: gColors.greyDark,
                                    ),
                                    child: Text('Articles', style: gColors.bodyTitle1_N_W),
                                  ),
                                )
                              : BtnCard("${wParc_Desc.ParcsDesc_Lib}", LargeurCol2, wParam_Saisie_Param.Param_Saisie_Param_Color, param_Saisie.Param_Saisie_Icon, param_Saisie),
                        ],
                      ))
              ],
            ),
          ));
  }


  Future Maj_Result_V() async {
    Parc_Desc wParc_DescAuto = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, "Result");
    print(" Maj_Result_V Result ${wParc_DescAuto.toMap()}");
    if (wParc_DescAuto.ParcsDesc_Lib == "---" || wParc_DescAuto.ParcsDesc_Lib!.contains("Non")) {
      wParc_DescAuto.ParcsDesc_Id = "1002";
      wParc_DescAuto.ParcsDesc_Lib = "Vérifié";
      await DbTools.updateParc_Desc_NoRaz(wParc_DescAuto, "");
      DbTools.gParc_Ent.Parcs_Date_Rev = DateTime.now().toIso8601String();
      DbTools.updateParc_Ent(DbTools.gParc_Ent);
      print("•••••••••••••••• VERIF gIntervention ${Srv_DbTools.gIntervention.Desc()}");

      String formattedDateDeb = DateFormat('dd/MM/yyyy').format(DateTime.now());

      Srv_DbTools.gIntervention.Intervention_Date_Visite = formattedDateDeb;
      await DbTools.updateInterventions(Srv_DbTools.gIntervention);
      bool wRes = await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);
      //    print("•••• setIntervention ${wRes}");
      Srv_DbTools.gIntervention.Intervention_isUpdate = wRes;
      if (!wRes) DbTools.setBoolErrorSync(true);
      await DbTools.updateInterventions(Srv_DbTools.gIntervention);
    }
  }

  Future Maj_Result_NV() async {
    Parc_Desc wParc_DescAuto = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, "Result");
    print(" Maj_Result_NV Result ${wParc_DescAuto.toMap()}");
    wParc_DescAuto.ParcsDesc_Id = "1003";
    wParc_DescAuto.ParcsDesc_Lib = "Non vérifié";
    await DbTools.updateParc_Desc_NoRaz(wParc_DescAuto, "");
    DbTools.gParc_Ent.Parcs_Date_Rev = "";
    DbTools.updateParc_Ent(DbTools.gParc_Ent);
//      print("•••••••••••••••• NV VERIF gIntervention ${Srv_DbTools.gIntervention.Desc()}");
  }

  Widget BtnCard(String? wText, double LargeurCol2, String color, String ico, Param_Saisie param_Saisie) {
    String Param_Saisie_ID = param_Saisie.Param_Saisie_ID;

    Color wColor = gColors.getColor(color);
    double IcoWidth = 40;
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: LargeurCol2,
      height: 45,
      child: Card(
        color: gColors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: ico.compareTo("Verif_titre") == 0 || ico.compareTo("IntMaint") == 0 || ico.compareTo("Result") == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            wText!.contains("---")
                ? ico.compareTo("Verif_titre") != 0 || ico.compareTo("IntMaint") == 0 || ico.compareTo("Result") == 0
                    ? Container()
                    : Text(
                        ">",
                        textAlign: TextAlign.center,
                        style: gColors.bodyTitle1_B_Gr.copyWith(
                          color: wColor,
                        ),
                      )
                : Text(
                    "${wText} >",
                    textAlign: TextAlign.center,
                    style: gColors.bodyTitle1_B_Gr.copyWith(
                      color: wColor,
                    ),
                  ),
            ico.compareTo("Verif_titre") == 0 || Param_Saisie_ID.compareTo("Ext") == 0 || ico.compareTo("IntMaint") == 0 || ico.compareTo("Result") == 0
                ? Container()
                : InkWell(
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, Param_Saisie_ID);

                      Parc_Desc wParc_Desc_Result = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, "Result");

                      if (wText.contains("---")) {
                        print("SELECTION ${Param_Saisie_ID}");
                        print("SELECTION ${wParc_Desc.ParcsDescId} ${wParc_Desc.ParcsDesc_Type} ${wParc_Desc.ParcsDesc_Id} ${wParc_Desc.ParcsDesc_Lib}");

                        Param_Saisie_Param wParam_Saisie_Param = Srv_DbTools.getParam_Saisie_ParamMem_Lib0(Param_Saisie_ID);
                        wParc_Desc.ParcsDesc_Id = wParam_Saisie_Param.Param_Saisie_Param_Id;
                        wParc_Desc.ParcsDesc_Lib = wParam_Saisie_Param.Param_Saisie_Param_Label;

                        // TRIGER : Ex Recharge => Verif Annuel
                        await DbTools.updateParc_Desc_NoRaz(wParc_Desc, "");
                        var lTriger = param_Saisie.Param_Saisie_Triger.split(",");
                        lTriger.forEach((triger) async {
                          print(" triger Split ${triger.trim()}");
                          Parc_Desc wParc_DescAuto = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, triger.trim());
                          print(" wParc_DescAuto ${wParc_DescAuto.toMap()}");
                          if (wParc_DescAuto.ParcsDesc_Lib == "---") {
                            print(" wParc_DescAuto ---  ${wParam_Saisie_Param.toMap()}");

                            String DefParam_Saisie_ID = Param_Saisie_ID;
                            Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
                              if (element.Param_Saisie_Param_Default) {
                                DefParam_Saisie_ID = element.Param_Saisie_Param_Id;
                              }
                            });

                            Param_Saisie_Param xParam_Saisie_Param = Srv_DbTools.getParam_Saisie_ParamMem_Lib0(DefParam_Saisie_ID);
                            wParc_DescAuto.ParcsDesc_Id = xParam_Saisie_Param.Param_Saisie_Param_Id;
                            wParc_DescAuto.ParcsDesc_Lib = xParam_Saisie_Param.Param_Saisie_Param_Label;
                            await DbTools.updateParc_Desc_NoRaz(wParc_DescAuto, "");
                            await Maj_Result_V();
                          }
                        });
                        setState(() {});
                      } else {
                        print("DESELECTION ${wParc_Desc.ParcsDescId} ${wParc_Desc.ParcsDesc_Id} ${wParc_Desc.ParcsDesc_Lib}");

                        if (wParc_Desc.ParcsDesc_Id!.compareTo("RES") == 0) {
                          for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
                            Parc_Art parc_Art = DbTools.lParcs_Art[i];
                            print(" Icone UNSELECT parc_Art ${parc_Art.toMap()}");
                            await DbTools.deleteParc_Art(parc_Art.ParcsArtId!);
                          }
                        }
                        Parc_Ent wParc_Ent = await DbTools.getParcs_Ent_Parcs_UUID_Child(DbTools.gParc_Ent.Parcs_UUID!);
                        print("Saisie Article ESESESESESES  deleteParc_EntTrigger ${wParc_Ent.toString()}");
                        if (wParc_Ent.Parcs_InterventionId != -1) {
                          await DbTools.deleteParc_EntTrigger(wParc_Ent.ParcsId!);
                        }
                        wParc_Desc.ParcsDesc_Lib = "---";
                        await DbTools.updateParc_Desc_NoRaz(wParc_Desc, "");
                        bool isEmpty = true;
                        for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
                          Param_Saisie element = Srv_DbTools.ListParam_Verif_Base[i];
                          Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);
                          if (element.Param_Saisie_ID.compareTo("Result") != 0) {
                            if (wParc_Desc.ParcsDesc_Lib != "---") isEmpty = false;
                          }
                        }
                        if (isEmpty) {
                          Maj_Result_NV();
                        }
                        setState(() {});
                      }

                      bool isVerif = false;
                      for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
                        var element = Srv_DbTools.ListParam_Verif_Base[i];
                        if (element.Param_Saisie_Type == "Verif") {
//                          print("SELECTION ListParam_Verif_Base ${element.toMap()}");
                          for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
                            var element2 = DbTools.glfParcs_Desc[i];
                            if (element.Param_Saisie_ID == element2.ParcsDesc_Type && element2.ParcsDesc_Type != "IntMaint" && element2.ParcsDesc_Type != "Result") {
//                              print("SELECTION glfParcs_Desc ${element2.toMap()}");
                              if (element2.ParcsDesc_Lib != "---") isVerif = true;
                            }
                          }
                        }
                      }

                      if (isVerif) await Maj_Result_V(); else await Maj_Result_NV();





    print(" GENERATION DES ARTICLES ASSOCIES ");
                      DbTools.gIsOU = false;
                      DbTools.gIsOUlParcs_Art.clear();
                      await Client_Groupe_Parc_Tools.Gen_Articles();
                      // Proposition Auto si Reformé
                      // REF
                      if (Param_Saisie_ID.compareTo("RES") == 0 && wText.contains("---")) {
                        await Client_Groupe_Parc_Inter_Verif_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, param_Saisie, wParc_Desc);
                      }

                      if (DbTools.gIsOU) {
                        await Client_Groupe_Parc_Inter_ArticleAss_Dialog.Dialogs_SaisieAss(context);
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Image.asset(
                          wText.contains("---") ? "assets/images/Plus_No_Sel.png" : "assets/images/Plus_Sel.png",
                          width: IcoWidth,
                          height: IcoWidth,
                        ))),
          ],
        ),
      ),
    );
  }

  Future AffisOU(BuildContext context) async {
    ScrollController scrollController = ScrollController(initialScrollOffset: 0);
    double wDialogHeight = MediaQuery.of(context).size.height;
    double IcoWidth = 40;

    print("  AffisOU ");

    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
              surfaceTintColor: Colors.white,
              backgroundColor: gColors.white,
              title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(
                  "Pièces détachées à Options Multiples",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_G_20,
                ),
                Text(
                  "Sélectionner la pièce pour cet organe",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_N_Gr,
                ),
                Container(
                  height: 8,
                ),
              ]),
              contentPadding: EdgeInsets.zero,
              content: Container(
                color: gColors.greyLight,
                height: wDialogHeight,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      color: gColors.black,
                      height: 1,
                    ),
                    Expanded(
                      child: ListView.builder(
                        // controller: scrollController,
                        shrinkWrap: true,
                        itemCount: DbTools.gIsOUlParcs_Art.length,
                        itemBuilder: (context, index) {
                          final art = DbTools.gIsOUlParcs_Art[index];
                          return InkWell(
                              onTap: () async {
                                await HapticFeedback.vibrate();
                                List<Parc_Art> wlParcs_Art = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);
                                for (int i = 0; i < wlParcs_Art.length; i++) {
                                  Parc_Art element = wlParcs_Art[i];
                                  if (element.ParcsArt_Lib!.startsWith(">>>")) {
                                    if (element.ParcsArt_Id != art.ParcsArt_Id) {
                                      print("DELETE");

                                      List<Parc_Art> wlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
                                      List<Parc_Art> lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
                                      lParcs_Art.addAll(wlParcs_Art);
                                      print("deleteParc_Art lParcs_Art ${lParcs_Art.length}");

                                      await DbTools.deleteParc_Art(element.ParcsArtId!);

                                      wlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
                                      lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
                                      lParcs_Art.addAll(wlParcs_Art);
                                      print("deleteParc_Art lParcs_Art ${lParcs_Art.length}");

                                      await onDelete();
                                      FBroadcast.instance().broadcast("Gen_Articles");
                                      setState(() {});
                                    }
                                  }
                                }

                                Navigator.of(context).pop();
                              },
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: 45,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                        ),
                                        buildImage(context, art),
                                        Container(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 100,
                                          height: 20,
                                          padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                                          child: Text(
                                            "${art.ParcsArt_Id}",
                                            style: gColors.bodyTitle1_N_Gr,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                                            child: Text(
                                              "${art.ParcsArt_Lib!}",
                                              style: gColors.bodyTitle1_N_Gr,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await HapticFeedback.vibrate();

                                            print("onTap ${art.Desc()}");
                                            art.Art_Sel = !art.Art_Sel;

                                            setState(() {});
                                          },
                                          child: Image.asset(
                                            art.Art_Sel ? "assets/images/Plus_Sel.png" : "assets/images/Plus_No_Sel.png",
                                            height: IcoWidth,
                                            width: IcoWidth,
                                          ),
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: gColors.greyLight,
                                    height: .7,
                                  ),
                                ],
                              ));
                        },
                      ),
                    ),
                    Container(
                      color: gColors.greyDark,
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                        ),
                        Valider(context),
                      ],
                    ),

//                    Spacer(),
                    Container(
                      color: gColors.black,
                      height: 1,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Container(
                  height: 8,
                ),
              ],
            ));
  }

  Valider(BuildContext context) {
    return Container(
      width: 450,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: gColors.primary,
            width: 8,
          ),
          Spacer(),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
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
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

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
}
