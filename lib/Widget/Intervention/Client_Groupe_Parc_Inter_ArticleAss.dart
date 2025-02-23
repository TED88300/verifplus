import 'dart:async';
import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Inter_ArticleAss_Dialog {
  Client_Groupe_Parc_Inter_ArticleAss_Dialog();

  static Future<void> Dialogs_SaisieAss(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const Client_Groupe_Parc_Inter_ArticleDialog(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_ArticleDialog extends StatefulWidget {
  const Client_Groupe_Parc_Inter_ArticleDialog({
    Key? key,
  }) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_ArticleDialogState createState() => Client_Groupe_Parc_Inter_ArticleDialogState();
}

class Client_Groupe_Parc_Inter_ArticleDialogState extends State<Client_Groupe_Parc_Inter_ArticleDialog> {
  Widget wIco = Container();
  Parc_Art save_Parc_Art = Parc_Art();
  bool isSel = false;

  @override
  void initLib() async {
    for (int i = 0; i < DbTools.gIsOUlParcs_Art.length; i++) {
      Parc_Art element = DbTools.gIsOUlParcs_Art[i];
      element.Art_Sel = false;
    }
  }

  @override
  void initState() {
    initLib();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController(initialScrollOffset: 0);
    double wDialogHeight = 400; // MediaQuery.of(context).size.height;
    double IcoWidth = 40;

    print("  AffisOU ");

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
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
                                  padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                                  child: Text(
                                    "${art.ParcsArt_Id}",
                                    style: gColors.bodyTitle1_N_Gr,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 20,
                                    padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                                    child: Text(
                                      art.ParcsArt_Lib!,
                                      style: gColors.bodyTitle1_N_Gr,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await HapticFeedback.vibrate();

                                    print("onTap ${art.Desc()}");
                                    bool saveartSel = art.Art_Sel;
                                    for (int i = 0; i < DbTools.gIsOUlParcs_Art.length; i++) {
                                      Parc_Art element = DbTools.gIsOUlParcs_Art[i];
                                      element.Art_Sel = false;
                                    }
                                    art.Art_Sel = !saveartSel;
                                    save_Parc_Art = art;

                                    isSel = art.Art_Sel;




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
    );
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
              if (isSel)
                {
                  await HapticFeedback.vibrate();

                  List<Parc_Art> wlparcsArt = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);
                  for (int i = 0; i < wlparcsArt.length; i++) {
                    Parc_Art element = wlparcsArt[i];
                    if (element.ParcsArt_Lib!.startsWith(">>>")) {
                      if (element.ParcsArt_Id != save_Parc_Art.ParcsArt_Id) {
                        print("DELETE");
                        List<Parc_Art> wlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
                        List<Parc_Art> lparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
                        lparcsArt.addAll(wlparcsArt);
                        print("deleteParc_Art lParcs_Art ${element.ParcsArtId} ${element.ParcsArt_Id} ${element.ParcsArt_Lib}");
                        await DbTools.deleteParc_Art(element.ParcsArtId!);
                        wlparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
                        lparcsArt = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
                        lparcsArt.addAll(wlparcsArt);
                        print("deleteParc_Art lParcs_Art ${lparcsArt.length}");

                        for (int ii = 0; ii < lparcsArt.length; ii++) {
                          Parc_Art element = lparcsArt[ii];
                          print("deleteParc_Art Liste ${element.ParcsArtId} ${element.ParcsArt_Type} ${element.ParcsArt_Id} ${element.ParcsArt_Lib}");
                        }

                        FBroadcast.instance().broadcast("Gen_Articles");
                      }
                    }
                  }

                  Navigator.of(context).pop();
                }

            },
            style: ElevatedButton.styleFrom(
                backgroundColor: isSel ? gColors.primaryGreen : gColors.GrdBtn_Colors3,

                side:  BorderSide(
                  width: 1.0,
                  color: isSel ? gColors.primaryGreen : gColors.GrdBtn_Colors3,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }
}
