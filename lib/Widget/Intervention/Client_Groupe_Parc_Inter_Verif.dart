import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
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

  bool isProp = true;

  bool isImage = false;
  List<Widget> imgList = [];
  Widget imgPrinc = Container();

  Future onDelete() async {
    await initLib();
  }

  Future Reload() async {
    DbTools.gParc_Art_MS = Parc_Art();
    isImage = false;
    DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, 1);
    print(" Reload glfParc_Imgs lenght ${DbTools.glfParc_Imgs.length}");
    if (DbTools.glfParc_Imgs.isNotEmpty) {
      imgList.clear();

      for (int i = 0; i < DbTools.glfParc_Imgs.length; i++) {
        var element = DbTools.glfParc_Imgs[i];


        print(" Reload glfParc_Imgs $i ${DbTools.glfParc_Imgs[i].Parc_Imgid} ${DbTools.glfParc_Imgs[i].Parc_Imgs_Principale} isImage $isImage");

        var bytes = base64Decode(element.Parc_Imgs_Data!);
        Widget wWidget = Container();
        if (bytes.isNotEmpty) {
          wWidget = Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: gColors.greyDark2,
              ),
            ),
            margin: const EdgeInsets.only(
              top: 12,
              right: 12,
              bottom: 14,
            ),
            width: 155,
            height: 155,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                bytes,
                fit: BoxFit.cover,
                height: 155,
                width: 155,
              ),
            ),
          );



          if (!isImage && element.Parc_Imgs_Principale == 1) {


            print(" SET PRINCIPALE $i");

            imgPrinc = wWidget;
            isImage = true;
          }

          imgList.add(wWidget);
        }
      }

      if (!isImage) {

        print(" SET PRINCIPALE NON TROUVE");


        imgPrinc = imgList[0];
        isImage = true;
      }
    }
    setState(() {});
  }

  @override
  Future initLib() async {
    print("initLib Parcs_CodeArticleES ${DbTools.gParc_Ent.Parcs_CodeArticleES}");
    DbTools.lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "ES");

    ParcsArt_Lib = "---";
    Article_Ebp articleEbp = Srv_DbTools.IMPORT_Article_Ebp(DbTools.gParc_Ent.Parcs_CodeArticleES!);
    ParcsArt_Lib = "${DbTools.gParc_Ent.Parcs_CodeArticleES} ${articleEbp.Article_descriptionCommercialeEnClair}";

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERIF initLib");

    for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Verif_Base[i];

      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERIF element ${element.Param_Saisie_ID} ${element.Param_Saisie_Type} ${element.Param_Saisie_Label}");

      Parc_Desc wparcDesc = await DbTools.getParcs_Desc_Id_Type_Add(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);
    }

    DbTools.glfParcs_Desc = await DbTools.getParcs_Desc(DbTools.gParc_Ent.ParcsId!);

    txtController.text = DbTools.gParc_Ent.Parcs_Verif_Note!;

    await Reload();
  }

  @override
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
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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



  Widget buildNote(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.black,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                color: gColors.white,
            child: TextField(
//              keyboardType: TextInputType.,
              controller: txtController,
              style: gColors.bodyTitle1_N_Gr,
              autofocus: false,
              maxLines: 7,
              decoration: const InputDecoration(
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
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: isImage
                    ? imgPrinc
                    : Image.asset(
                        "assets/images/Icon_Photo.png",
                        height: 155,
                        width: 155,
                      ),
              ),
            ),
            onTap: () async {

              DbTools.gParc_Img_Type = 1;
              DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, 1);
              await gDialogs.Dialog_Photo(context, DbTools.DescAff, DbTools.DescAff2, DbTools.DescAff3);
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
      print("buildDesc indexoff $wInd");
      wMois = DbTools.gDateMS.substring(0, wInd);
      wAnnee = DbTools.gDateMS.substring(wInd + 1);
      print("buildDesc wMois $wMois");
      print("buildDesc wAnnee $wAnnee");
      DateTime wDateMS = DateTime(int.tryParse(wAnnee) ?? 2024, int.tryParse(wMois) ?? 1, 1);
      DateTime wDateNow = DateTime.now();
      int wYears = (wDateNow.difference(wDateMS).inDays ~/ 365);
      print("buildDesc wDateNow.difference(wDateMS).inDays ${wDateNow.difference(wDateMS).inDays} $wYears");

      is5ans = wYears >= 5;
      is10ans = wYears >= 10;

      print("buildDesc is5ans $is5ans");
      print("buildDesc is10ans $is10ans");
    } catch (e) {}

    for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Verif_Base[i];

      Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);

      if (element.Param_Saisie_ID.contains("IntMaint")) {
        element.Param_Saisie_Label = "Intervention de maintenance";
      }
      if (element.Param_Saisie_ID.contains("RES") && wparcDesc.ParcsDesc_Lib!.compareTo("---") == 0) {
        isRes = false;
      }

      if (!element.Param_Saisie_ID.contains("Result")) {
        if (wparcDesc.ParcsDesc_Lib != "---") isEmpty = false;
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
                padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                color: gColors.greyDark,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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

    await Srv_DbTools.getArticlesImg_Ebp( art.ParcsArt_Id!);
    gObj.pic = base64Decode(Srv_DbTools.gArticlesImg_Ebp.ArticlesImg_Image);
    if (gObj.pic.isNotEmpty) {
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
    return FutureBuilder(
      future: GetImage(art),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return Container(width: 30);
        }
      },
    );
  }

  Widget RowSaisie(Param_Saisie paramSaisie, double LargeurCol, double LargeurCol2, double H2, {bool Indispo = false}) {
//    print("RowSaisie ${param_Saisie.Param_Saisie_ID}");

    Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, paramSaisie.Param_Saisie_ID);

    double IcoWidth = 30;
    Param_Saisie_Param wparamSaisieParam = Srv_DbTools.getParam_Saisie_ParamMem_Lib(paramSaisie.Param_Saisie_ID, wparcDesc.ParcsDesc_Lib!);
    if (paramSaisie.Param_Saisie_Icon.compareTo("") == 0) LargeurCol += 40;

    if (paramSaisie.Param_Saisie_Icon == "Verif_prs") {
      Color wColor = Colors.green;
      String wUnit = "bar";
      String wNC = "";

      if (wparcDesc.ParcsDesc_Type == "DEBIT") wUnit = "l/min";

      if (wparcDesc.ParcsDesc_Type == "PRDIF") {
        double wDouble = double.parse(wparcDesc.ParcsDesc_Id!);
        if (wDouble < 2) {
          wNC = "_nc";
          wColor = Colors.red;
        }
      }
      if (wparcDesc.ParcsDesc_Type == "PRARR") {
        double wDouble = double.parse(wparcDesc.ParcsDesc_Id!);
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
              print("InkWell Saisie B ${paramSaisie.toMap()}");
              print("InkWell Saisie C ${wparcDesc.toString()}");

              print("InkWell Saisie D ${wparcDesc.ParcsDesc_Type}");

              await Client_Groupe_Parc_Inter_Verif_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, paramSaisie, wparcDesc);
              setState(() {});
            },
            child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Image.asset(
                    "assets/images/${paramSaisie.Param_Saisie_Icon}$wNC.png",
                    height: IcoWidth,
                    width: IcoWidth,
                  ),
                ),
                Container(
                  width: 435,
                  height: 20,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    paramSaisie.Param_Saisie_Label,
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 135,
                  height: 20,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    "${wparcDesc.ParcsDesc_Id} $wUnit >",
                    style: gColors.bodyTitle1_B_Gr.copyWith(color: wColor),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ));
    } else if (Indispo)
      return Container(
        color: paramSaisie.Param_Saisie_Icon.contains("Verif_") || paramSaisie.Param_Saisie_Icon.compareTo("IntMaint") == 0 || paramSaisie.Param_Saisie_Icon.compareTo("Ech") == 0 || paramSaisie.Param_Saisie_Icon.compareTo("Result") == 0 ? gColors.greyLight : Colors.white,
        height: 45,
        child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Image.asset(
                "assets/images/${paramSaisie.Param_Saisie_Icon}.png",
                height: IcoWidth,
                width: IcoWidth,
              ),
            ),
            Container(
              width: 535,
              height: 20,
              padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                paramSaisie.Param_Saisie_Label,
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
          color: paramSaisie.Param_Saisie_Icon.contains("Verif_") || paramSaisie.Param_Saisie_Icon.compareTo("IntMaint") == 0 || paramSaisie.Param_Saisie_Icon.compareTo("Ech") == 0 || paramSaisie.Param_Saisie_Icon.compareTo("Result") == 0 ? gColors.greyLight : Colors.white,
          height: 45,
          child: InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              if (paramSaisie.Param_Saisie_Icon.compareTo("Verif_renouv") == 0 || paramSaisie.Param_Saisie_Icon.compareTo("Ech") == 0) {
                await HapticFeedback.vibrate();
                await Client_Groupe_Parc_Inter_Article_Dialog.Dialogs_Saisie(context, onSaisie, "ES");
              } else if (!wparcDesc.ParcsDesc_Lib!.contains(">")) {
                await Client_Groupe_Parc_Inter_Verif_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, paramSaisie, wparcDesc);
              }
              setState(() {});
            },
            child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                ),
                paramSaisie.Param_Saisie_ID.compareTo("Ext") == 0
                    ? Container(margin: const EdgeInsets.fromLTRB(0, 0, 10, 0), height: IcoWidth, width: IcoWidth, color: Colors.white, child: buildImage(context, parc_ArtES))
                    : paramSaisie.Param_Saisie_Icon.compareTo("") == 0
                        ? Container(
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.asset(
                              "assets/images/${paramSaisie.Param_Saisie_Icon}.png",
                              height: IcoWidth,
                              width: IcoWidth,
                            ),
                          ),
                Container(
                  width: paramSaisie.Param_Saisie_ID.compareTo("Ext") == 0 ? 535 : LargeurCol,
                  height: 20,
                  padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                  child: Text(
                    paramSaisie.Param_Saisie_ID.compareTo("Ext") == 0 ? "➜ $ParcsArt_Lib" : paramSaisie.Param_Saisie_Label,
                    style: paramSaisie.Param_Saisie_ID.compareTo("Ext") == 0 ? gColors.bodyTitle1_B_Gr.copyWith(color: Colors.green) : gColors.bodyTitle1_B_Gr,
                  ),
                ),
                paramSaisie.Param_Saisie_ID.compareTo("Ext") == 0
                    ? Container()
                    : Expanded(
                        child: Row(
                        children: [
                          paramSaisie.Param_Saisie_Icon.compareTo("Verif_renouv") == 0 || paramSaisie.Param_Saisie_Icon.compareTo("Ech") == 0 ? const Spacer() : Container(),
                          paramSaisie.Param_Saisie_Icon.compareTo("Verif_renouv") == 0 || paramSaisie.Param_Saisie_Icon.compareTo("Ech") == 0
                              ? Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
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
                              : BtnCard("${wparcDesc.ParcsDesc_Lib}", LargeurCol2, wparamSaisieParam.Param_Saisie_Param_Color, paramSaisie.Param_Saisie_Icon, paramSaisie),
                        ],
                      ))
              ],
            ),
          ));
  }

  Future Maj_Result_V() async {
    Parc_Desc wparcDescauto = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, "Result");
    print(" Maj_Result_V Result ${wparcDescauto.toMap()}");
    if (wparcDescauto.ParcsDesc_Lib == "---" || wparcDescauto.ParcsDesc_Lib!.contains("Non")) {
      wparcDescauto.ParcsDesc_Id = "1002";
      wparcDescauto.ParcsDesc_Lib = "Vérifié";
      await DbTools.updateParc_Desc_NoRaz(wparcDescauto, "");
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
    Parc_Desc wparcDescauto = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, "Result");
    print(" Maj_Result_NV Result ${wparcDescauto.toMap()}");
    wparcDescauto.ParcsDesc_Id = "1003";
    wparcDescauto.ParcsDesc_Lib = "Non vérifié";
    await DbTools.updateParc_Desc_NoRaz(wparcDescauto, "");
    DbTools.gParc_Ent.Parcs_Date_Rev = "";
    DbTools.updateParc_Ent(DbTools.gParc_Ent);
//      print("•••••••••••••••• NV VERIF gIntervention ${Srv_DbTools.gIntervention.Desc()}");
  }

  Widget BtnCard(String? wText, double LargeurCol2, String color, String ico, Param_Saisie paramSaisie) {
    String paramSaisieId = paramSaisie.Param_Saisie_ID;

    Color wColor = gColors.getColor(color);
    double IcoWidth = 40;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    "$wText >",
                    textAlign: TextAlign.center,
                    style: gColors.bodyTitle1_B_Gr.copyWith(
                      color: wColor,
                    ),
                  ),
            ico.compareTo("Verif_titre") == 0 || paramSaisieId.compareTo("Ext") == 0 || ico.compareTo("IntMaint") == 0 || ico.compareTo("Result") == 0
                ? Container()
                : InkWell(
                    onTap: () async {
                      if (paramSaisieId.compareTo("Inst") == 0 && wText.contains("---")) {
                        DbTools.gParc_Art_MS = Parc_Art();
                        DbTools.gParc_Art_MS.ParcsArtId = -99;
                        await gDialogs.Dialog_MiseEnServ(context);

                        if (DbTools.gParc_Art_MS.ParcsArtId == -98) {
                          print(" &&&&&&&&&&& DbTools.gParc_Art_MS.ParcsArtId ${DbTools.gParc_Art_MS.ParcsArtId}");
                          return;
                        }
                      }

                      await HapticFeedback.vibrate();
                      Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, paramSaisieId);
                      Parc_Desc wparcDescResult = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, "Result");

                      if (wText.contains("---")) {
                        print("SELECTION $paramSaisieId");
                        print("SELECTION ${wparcDesc.ParcsDescId} ${wparcDesc.ParcsDesc_Type} ${wparcDesc.ParcsDesc_Id} ${wparcDesc.ParcsDesc_Lib}");

                        Param_Saisie_Param wparamSaisieParam = Srv_DbTools.getParam_Saisie_ParamMem_Lib0(paramSaisieId);
                        wparcDesc.ParcsDesc_Id = wparamSaisieParam.Param_Saisie_Param_Id;
                        wparcDesc.ParcsDesc_Lib = wparamSaisieParam.Param_Saisie_Param_Label;

                        // TRIGER : Ex Recharge => Verif Annuel
                        await DbTools.updateParc_Desc_NoRaz(wparcDesc, "");
                        var lTriger = paramSaisie.Param_Saisie_Triger.split(",");
                        lTriger.forEach((triger) async {
                          print(" triger Split ${triger.trim()}");
                          Parc_Desc wparcDescauto = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, triger.trim());
                          print(" wParc_DescAuto ${wparcDescauto.toMap()}");
                          if (wparcDescauto.ParcsDesc_Lib == "---") {
                            print(" wParc_DescAuto ---  ${wparamSaisieParam.toMap()}");

                            String defparamSaisieId = paramSaisieId;
                            for (var element in Srv_DbTools.ListParam_Saisie_Param) {
                              if (element.Param_Saisie_Param_Default) {
                                defparamSaisieId = element.Param_Saisie_Param_Id;
                              }
                            }

                            Param_Saisie_Param xparamSaisieParam = Srv_DbTools.getParam_Saisie_ParamMem_Lib0(defparamSaisieId);
                            wparcDescauto.ParcsDesc_Id = xparamSaisieParam.Param_Saisie_Param_Id;
                            wparcDescauto.ParcsDesc_Lib = xparamSaisieParam.Param_Saisie_Param_Label;
                            await DbTools.updateParc_Desc_NoRaz(wparcDescauto, "");
                            await Maj_Result_V();
                          }
                        });
                        setState(() {});
                      } else {
                        print("DESELECTION ${wparcDesc.ParcsDescId} ${wparcDesc.ParcsDesc_Id} ${wparcDesc.ParcsDesc_Lib}");

                        if (wparcDesc.ParcsDesc_Id!.compareTo("RES") == 0) {
                          for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
                            Parc_Art parcArt = DbTools.lParcs_Art[i];
                            print(" Icone UNSELECT parc_Art ${parcArt.toMap()}");
                            await DbTools.deleteParc_Art(parcArt.ParcsArtId!);
                          }
                        }
                        Parc_Ent wparcEnt = await DbTools.getParcs_Ent_Parcs_UUID_Child(DbTools.gParc_Ent.Parcs_UUID!);
                        print("Saisie Article ESESESESESES  deleteParc_EntTrigger ${wparcEnt.toString()}");
                        if (wparcEnt.Parcs_InterventionId != -1) {
                          await DbTools.deleteParc_EntTrigger(wparcEnt.ParcsId!);
                        }
                        wparcDesc.ParcsDesc_Lib = "---";
                        await DbTools.updateParc_Desc_NoRaz(wparcDesc, "");
                        bool isEmpty = true;
                        for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
                          Param_Saisie element = Srv_DbTools.ListParam_Verif_Base[i];
                          Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);
                          if (element.Param_Saisie_ID.compareTo("Result") != 0) {
                            if (wparcDesc.ParcsDesc_Lib != "---") isEmpty = false;
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

                      if (isVerif) {
                        await Maj_Result_V();
                      } else {
                        await Maj_Result_NV();
                      }
                      DbTools.gIsOU = false;
                      DbTools.gIsOUlParcs_Art.clear();
                      await Client_Groupe_Parc_Tools.Gen_Articles();
                      // Proposition Auto si Reformé
                      // REF
                      if (paramSaisieId.compareTo("RES") == 0 && wText.contains("---")) {
                        await Client_Groupe_Parc_Inter_Verif_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, paramSaisie, wparcDesc);
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
          const Spacer(),
          ElevatedButton(
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
          ElevatedButton(
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
