import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Link_Verif_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Article.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Verif_Saisie.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Tools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';
import 'package:verifplus/Widget/Widget_Tools/gDialogs.dart';

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

  Future Reload() async {
    DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, 1);
    print("glfParc_Imgs lenght ${DbTools.glfParc_Imgs.length}");
    if (DbTools.glfParc_Imgs.length > 0) {
      imgList.clear();
      DbTools.glfParc_Imgs.forEach((element) {
//        Widget wWidget = Container(child: Image.file(File(element.Parc_Imgs_Path!), width: 50, height: 50,),);
        var bytes = base64Decode(element.Parc_Imgs_Data!);
        print("bytes ${bytes.length}");
        Widget wWidget = Container();
        if (bytes.length > 0)
          wWidget = Container(
            child: Image.memory(
              bytes,
              width: ImgSize,
              height: ImgSize,
            ),
          );
        imgList.add(wWidget);
      });
      isImage = true;
    }

    setState(() {});
  }

  @override
  void initLib() async {
    print(">> Call getVerifLink C ");
    Client_Groupe_Parc_Tools.listResult_Article_Link_Verif_Deb = await Client_Groupe_Parc_Tools.getVerifLink();

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

    for (int i = 0; i < Srv_DbTools.ListParam_Verif_Base.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Verif_Base[i];
      Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);

      if (element.Param_Saisie_ID.compareTo("IntMaint") == 0) {
        element.Param_Saisie_Label = "Intervention de maintenance";
      }
      if (element.Param_Saisie_ID.compareTo("RES") == 0 && wParc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
        isRes = false;
      }

      bool Indispo = false;
      /*for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_Indisp.length; i++) {
        Result_Article_Link_Verif_Indisp wResult_Article_Link_Verif_Indisp = Srv_DbTools.ListResult_Article_Link_Verif_Indisp[i];
        if (element.Param_Saisie_ID.compareTo(wResult_Article_Link_Verif_Indisp.Articles_Link_Verif_TypeVerif) == 0) {
          element.Param_Saisie_Label = "${element.Param_Saisie_Label} ***Indsiponible***";
          print("> wResult_Article_Link_Verif -${element.Param_Saisie_ID} ${wResult_Article_Link_Verif_Indisp.Desc()}");
          Indispo = true;
          break;
        }
      }*/

      if (Indispo) {
        RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2, Indispo: true));
      } else if (element.Param_Saisie_ID.compareTo("Ech") == 0) {
        if (isRes) {
          RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
        }
      } else if (element.Param_Saisie_ID.compareTo("Ext") == 0) {
        if (isRes) {
          print("Ext element ${element.Param_Saisie_ID} ${element.Param_Saisie_Label} ${wParc_Desc.ParcsDescId} ${wParc_Desc.ParcsDesc_Lib}");
          RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
        }
      } else {
        //      print("element ${element.Param_Saisie_ID} ${element.Param_Saisie_Label} ${wParc_Desc.ParcsDescId} ${wParc_Desc.ParcsDesc_Lib}");
        RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
      }
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

    if (Indispo)
      return Container(
        color: param_Saisie.Param_Saisie_Icon.contains("Verif_") ? gColors.greyLight : Colors.white,
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
          color: param_Saisie.Param_Saisie_Icon.contains("Verif_") ? gColors.greyLight : Colors.white,
          height: 45,
          child: InkWell(
            onTap: () async {
              print("InkWell Saisie A");
              await HapticFeedback.vibrate();
              if (param_Saisie.Param_Saisie_Icon.compareTo("Verif_renouv") == 0) {
                print("InkWell Saisie B");
                await HapticFeedback.vibrate();
                await Client_Groupe_Parc_Inter_Article_Dialog.Dialogs_Saisie(context, onSaisie, "ES");
              } else if (!wParc_Desc.ParcsDesc_Lib!.contains(">")) {
                print("InkWell Saisie C");
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
                          param_Saisie.Param_Saisie_Icon.compareTo("Verif_renouv") == 0 ? Spacer() : Container(),
                          param_Saisie.Param_Saisie_Icon.compareTo("Verif_renouv") == 0
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
          mainAxisAlignment: ico.compareTo("Verif_titre") == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            wText!.contains("---")
                ? ico.compareTo("Verif_titre") != 0
                    ? Container()
                    : Text(
                        ">",
                        textAlign: TextAlign.center,
                        style: gColors.bodyTitle1_B_Gr.copyWith(
                          color: wColor,
                        ),
                      )
                : Text(
                    "${wText}",
                    textAlign: TextAlign.center,
                    style: gColors.bodyTitle1_B_Gr.copyWith(
                      color: wColor,
                    ),
                  ),
            ico.compareTo("Verif_titre") == 0 || Param_Saisie_ID.compareTo("Ext") == 0
                ? Container()
                : InkWell(
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, Param_Saisie_ID);
                      if (wText.contains("---")) {

                        print("SELECTION ${wParc_Desc.ParcsDescId} ${wParc_Desc.ParcsDesc_Id} ${wParc_Desc.ParcsDesc_Lib}");


                        Param_Saisie_Param wParam_Saisie_Param = Srv_DbTools.getParam_Saisie_ParamMem_Lib0(Param_Saisie_ID);
                        wParc_Desc.ParcsDesc_Id = wParam_Saisie_Param.Param_Saisie_Param_Id;
                        wParc_Desc.ParcsDesc_Lib = wParam_Saisie_Param.Param_Saisie_Param_Label;
                        print(" SELECTION SELECT SET param_Saisie ${param_Saisie.DescAuto()}}");
                        print(" SELECTION SELECT SET wParam_Saisie_Param ${wParam_Saisie_Param.Desc()}");
                        print(" SELECTION SELECT SET wParc_Desc ${wParc_Desc.toMap()}");


                        // TRIGER : Ex Recharge => Verif Annuel
                        await DbTools.updateParc_Desc_NoRaz(wParc_Desc, "");
                        var lTriger = param_Saisie.Param_Saisie_Triger.split(",");
                        print("lTriger ${param_Saisie.Param_Saisie_Triger}");
                        lTriger.forEach((triger) async {
                          print("triger ${triger.trim()}");
                          Parc_Desc wParc_DescAuto = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, triger.trim());
                          print(" wParc_DescAuto ${wParc_DescAuto.toMap()}");
                          if (wParc_DescAuto.ParcsDesc_Lib == "---") {
                            wParc_DescAuto.ParcsDesc_Id = wParam_Saisie_Param.Param_Saisie_Param_Id;
                            wParc_DescAuto.ParcsDesc_Lib = wParam_Saisie_Param.Param_Saisie_Param_Label;
                            await DbTools.updateParc_Desc_NoRaz(wParc_DescAuto, "");
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
                        setState(() {});
                      }

                      print(" GENERATION DES ARTICLES ASSOCIES ");
                      await Client_Groupe_Parc_Tools.Gen_Articles();

                      // Proposition Auto si Reformé
                      if (Param_Saisie_ID.compareTo("RES") == 0 && wText.contains("---")) {
                        await Client_Groupe_Parc_Inter_Verif_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, param_Saisie, wParc_Desc);
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
}
