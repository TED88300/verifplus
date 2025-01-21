import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gDialogs.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

//**********************************
//**********************************
//**********************************

class DCL_Devis_Det_Article extends StatefulWidget {
  final String wTitre;
  const DCL_Devis_Det_Article({Key? key, required this.wTitre}) : super(key: key);

  @override
  _DCL_Devis_Det_ArticleState createState() => _DCL_Devis_Det_ArticleState();
}

class _DCL_Devis_Det_ArticleState extends State<DCL_Devis_Det_Article> {
  var formatter = NumberFormat('###,###.00');
  Image? wImage;

  double SizeBtn = 60;
  double wHeightDet2 = 702;
  double wWidth = 560;
  double wHeightTitre = 130;

  List<Widget> widgets = [];
  List<Widget> widgetsDetail = [];
  List<Widget> widgetsTarif = [];

  List<String> wTitres = [];
  List<Widget> wImages = [];

  List<int> wCpt = [];

  bool isFav = false;

  var pageController = PageController(keepPage: false, initialPage: 0);

  var screenController = PageController(keepPage: false, initialPage: 1);

  List<Article_Ebp> ListArticle_Ebpsearchresult = [];
  int indexPage = 0;
  int indexScreen = 1;
  void Erase() {
    Reload();
  }

  Future Reload() async {
    widgets.clear();
    widgetsDetail.clear();
    widgetsTarif.clear();

    wTitres.clear();
    wImages.clear();
    int wPage = 0;

    Srv_DbTools.wUserLogin_Art_Fav.clear();
    Srv_DbTools.wUserLogin_Art_Fav.addAll(Srv_DbTools.gUserLogin_Art_Fav);

    for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
      Article_Ebp wArticle_Ebp = Srv_DbTools.ListArticle_Ebpsearchresult[i];
      if (!wArticle_Ebp.Art_Sel) continue;
      wTitres.add("${wArticle_Ebp.Article_descriptionCommercialeEnClair} (${wArticle_Ebp.Article_codeArticle})");

      wArticle_Ebp.DCL_Det_Livr = Srv_DbTools.gDCL_Det.DCL_Det_Livr!;
      wArticle_Ebp.DCL_Det_DateLivr = Srv_DbTools.gDCL_Det.DCL_Det_DateLivr!;
      wArticle_Ebp.DCL_Det_Statut = Srv_DbTools.gDCL_Det.DCL_Det_Statut!;

      wArticle_Ebp.DCL_Det_PU = Srv_DbTools.gDCL_Det.DCL_Det_PU!;
      if (wArticle_Ebp.DCL_Det_PU == 0) wArticle_Ebp.DCL_Det_PU = wArticle_Ebp.Article_PVHT;

      wArticle_Ebp.DCL_Det_RemP = 0;
      if (wArticle_Ebp.Article_PVHT > 0) wArticle_Ebp.DCL_Det_RemP = (wArticle_Ebp.Article_PVHT - wArticle_Ebp.DCL_Det_PU) / wArticle_Ebp.Article_PVHT * 100;
      wArticle_Ebp.DCL_Det_RemMt = wArticle_Ebp.Article_PVHT - wArticle_Ebp.DCL_Det_PU;

      StatePage wStatePage = StatePage(wArticle_Ebp: wArticle_Ebp, index: i, callback: Erase);
      widgets.add(wStatePage);

      StatePageDetail wStatePageDetail = StatePageDetail(wArticle_Ebp: wArticle_Ebp, index: i, callback: Erase);
      widgetsDetail.add(wStatePageDetail);

      StatePageTarif wStatePageTarif = StatePageTarif(wArticle_Ebp: wArticle_Ebp, index: i, callback: Erase);
      widgetsTarif.add(wStatePageTarif);

      wImages.add(buildImage(context, wArticle_Ebp!));
      print(" ADD ${wArticle_Ebp.Article_descriptionCommercialeEnClair}");
      wPage++;
    }
    indexPage = 0;
    pageController.dispose();
    pageController = PageController(keepPage: false, initialPage: 0);

    print(" ADD ${widgets.length}");

    if (widgets.length == 0)
      Navigator.pop(context);
    else
      setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    initLib();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    screenController.dispose();
  }

  Future<Image> GetImage(Article_Ebp art, double wIcoWidth) async {
    if (art.wImgeTrvL) return art.wImageL!;

    await Srv_DbTools.getArticlesImg_Ebp(art.Article_codeArticle);
    gObj.pic = base64Decode(Srv_DbTools.gArticlesImg_Ebp.ArticlesImg_Image);
    if (gObj.pic.length > 0) {
      art.wImgeTrvL = true;
      art.wImageL = Image.memory(
        gObj.pic,
        fit: BoxFit.scaleDown,
        width: wIcoWidth,
        height: wIcoWidth,
      );
      return art.wImageL!;
    }

    art.wImgeTrvL = true;
    art.wImageL = Image.asset(
      "assets/images/Audit_det.png",
      height: wIcoWidth,
      width: wIcoWidth,
    );
    ;
    return art.wImageL!;
  }

  Widget buildImage(BuildContext context, Article_Ebp art) {
    return new FutureBuilder(
      future: GetImage(art, 400),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return new Container(width: 30);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double heightPos = 70;
    double wHeightPied = 105;
    double wLeft = 0;
    double wHeightBtnValider = 50;
    double wLabelWidth = 120;
    double wHeight = wHeightTitre + wHeightDet2 + wHeightPied - 30;

    print(" B U I L D  ${widgets.length}");

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.white,
      shadowColor: gColors.transparent,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: Colors.transparent,
              height: wHeight,
              width: wWidth,
            ),

////////////
// ENTETE
////////////

            Positioned(
              top: 0,
              left: 0,
              child: Material(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                child: Container(
                  height: wHeightTitre,
                  width: wWidth,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: wWidth,
                        height: wHeightTitre - 30,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (indexScreen == 1)
                                ? Container()
                                : Container(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    width: 100,
                                    height: 100,
                                    child: wImages[indexPage],
                                  ),
                            Container(
                              height: 100,
                              padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                              width: (indexScreen == 1) ? wWidth - 20 : wWidth - 120,
                              child: Text(
                                "${wTitres[indexPage]}",
                                maxLines: 3,
                                style: gColors.bodyTitle1_B_G22,
                                textAlign: indexScreen == 1 ? TextAlign.center : TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                      gColors.ombre(),
                    ],
                  ),
                ),
              ),
            ),

///////////
// PIED
///////////
            Positioned(
              top: wHeightTitre + wHeightDet2 - 45,
              left: wLeft,
              child: Container(
                  child: Container(
                width: wWidth,
                height: wHeightPied,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                decoration: BoxDecoration(
                  color: gColors.LinearGradient3,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: gColors.LinearGradient4,
                      height: 1,
                    ),
                    Container(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gColors.primaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Container(
                            width: 110,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "Annuler",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: gColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          child: Container(
                            width: 110,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "Valider",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {
                            print("Ajouter Srv_DbTools.ListArticle_Ebpsearchresult.length ${Srv_DbTools.ListArticle_Ebpsearchresult.length}");
                            for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
                              Article_Ebp wArticle_Ebp = Srv_DbTools.ListArticle_Ebpsearchresult[i];
                              if (!wArticle_Ebp.Art_Sel) continue;

                              Srv_DbTools.gDCL_Det.DCL_Det_PU = wArticle_Ebp.Article_Promo_PVHT > 0 ? wArticle_Ebp.Article_Promo_PVHT : wArticle_Ebp.Article_PVHT;
                              Srv_DbTools.gDCL_Det.DCL_Det_Qte = wArticle_Ebp.Art_Qte;
                              Srv_DbTools.gDCL_Det.DCL_Det_Livr = wArticle_Ebp.DCL_Det_Livr;
                              Srv_DbTools.gDCL_Det.DCL_Det_DateLivr = wArticle_Ebp.DCL_Det_DateLivr;
                              Srv_DbTools.gDCL_Det.DCL_Det_Statut = wArticle_Ebp.DCL_Det_Statut;

                              Srv_DbTools.gDCL_Det.DCL_Det_PU = wArticle_Ebp.DCL_Det_PU;
                              Srv_DbTools.gDCL_Det.DCL_Det_RemP = wArticle_Ebp.DCL_Det_RemP;
                              Srv_DbTools.gDCL_Det.DCL_Det_RemMt = wArticle_Ebp.DCL_Det_RemMt;

                              await Srv_DbTools.setDCL_Det(Srv_DbTools.gDCL_Det);
                            }

                            Srv_DbTools.gUserLogin_Art_Fav.clear();
                            Srv_DbTools.gUserLogin_Art_Fav.addAll(Srv_DbTools.wUserLogin_Art_Fav);
                            Srv_DbTools.setUserArtFav(Srv_DbTools.gUserLogin);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              )),
            ),
////////////
// CONTENT
////////////
            // Content
            Positioned(
              top: wHeightTitre - 4,
              left: wLeft,
              child: Container(
                height: 674,
                width: wWidth,
                color: gColors.white,
                child: (widgets.length > 0)
                    ? PageView.builder(
                        itemCount: widgets.length,
                        controller: pageController,
                        itemBuilder: (BuildContext context, int index) => pageBuilder(index),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pageBuilder(int index) {
    indexScreen = 1;
    List<Widget> screens = [];

    screens.add(widgetsDetail[index]);
    screens.add(widgets[index]);
    screens.add(widgetsTarif[index]);

    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        return PageView.builder(
          itemCount: screens.length,
          controller: screenController,
          scrollDirection: Axis.vertical,
          onPageChanged: (page) {
            setState(() {
              indexScreen = page;
              setState(() {});
            });
          },
          itemBuilder: (BuildContext context, int indexScreen) => AnimatedBuilder(
            animation: screenController,
            builder: (context, child) {
              return screens[indexScreen];
            },
          ),
        );
      },
    );
  }
}

//***************************
//***************************
//***************************

class StatePage extends StatefulWidget {
  final Article_Ebp? wArticle_Ebp;
  final int? index;
  final Function()? callback;

  StatePage({
    Key? key,
    @required this.wArticle_Ebp,
    @required this.index,
    @required this.callback,
  }) : super(key: key);

  @override
  StatePageState createState() => StatePageState();
}

class StatePageState extends State<StatePage> {
  var formatter = NumberFormat('###,###.00');
  Image? wImage;

  double SizeBtn = 60;
  double wHeightDet2 = 702;
  double wWidth = 560;
  double wHeightTitre = 115;

  bool isFav = false;

  int DCL_Det_Livr = 0;

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    if (Srv_DbTools.wUserLogin_Art_Fav.contains(widget.wArticle_Ebp?.Article_codeArticle)) {
      isFav = true;
    }

    int wRem = 0;
    if (widget.wArticle_Ebp!.Article_PVHT > 0) {
      wRem = ((widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.Article_Promo_PVHT) / widget.wArticle_Ebp!.Article_PVHT * 100).round();
    }

    return Container(
      color: Colors.white,
      width: wWidth,
      child: Container(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: gColors.LinearGradient2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.wArticle_Ebp!.Article_Promo_PVHT != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 12, 0, 12),
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Promo',
                                style: gColors.bodyTitle1_B_W24,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 80,
                          padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
                          color: gColors.LinearGradient2,
                          child: Text(
                            "${formatter.format(widget.wArticle_Ebp!.Article_PVHT).replaceAll(',', ' ').replaceAll('.', ',')}€",
                            style: gColors.bodyTitle1_N_G24.copyWith(decoration: TextDecoration.lineThrough),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 80,
                          padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
                          color: gColors.LinearGradient2,
                          child: Text(
                            "${wRem}%",
                            style: gColors.bodyTitle1_N_G24,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 80,
                          padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
                          color: gColors.LinearGradient2,
                          child: Text(
                            "${formatter.format(widget.wArticle_Ebp!.Article_Promo_PVHT).replaceAll(',', ' ').replaceAll('.', ',')}€",
                            style: gColors.bodyTitle1_B_G24.copyWith(
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 12, 0, 12),
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          decoration: BoxDecoration(
                            color: gColors.primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'PV HT',
                                style: gColors.bodyTitle1_B_W24,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 80,
                          padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
                          color: gColors.LinearGradient2,
                          child: Text(
                            "${formatter.format(widget.wArticle_Ebp!.Article_PVHT).replaceAll(',', ' ').replaceAll('.', ',')}€",
                            style: gColors.bodyTitle1_B_G24.copyWith(color: gColors.primaryGreen),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
              Container(
                color: gColors.LinearGradient1,
                height: 1,
              ),
              Container(
                  height: 593,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: SvgPicture.asset(
                                "assets/images/DCL_Info.svg",
                                height: 60,
                              ),
                            ),
                            onTap: () async {
                              await HapticFeedback.vibrate();
                              await showDialog(context: context, builder: (BuildContext context) => DialogInfo(context, widget.wArticle_Ebp!.Article_Notes));
                              setState(() {});
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                              child: SvgPicture.asset(
                                "assets/images/DCL_Fav.svg",
                                color: !isFav ? gColors.greyDark : null,
                                height: 60,
                              ),
                            ),
                            onTap: () async {
                              await HapticFeedback.vibrate();
                              isFav = !isFav;
                              if (isFav) {
                                Srv_DbTools.wUserLogin_Art_Fav.add(widget.wArticle_Ebp!.Article_codeArticle);
                              } else {
                                Srv_DbTools.wUserLogin_Art_Fav.remove(widget.wArticle_Ebp!.Article_codeArticle);
                              }
                              setState(() {});
                            },
                          ),
                          SvgPicture.asset(
                            "assets/images/DCL_Check.svg",
                            width: 40,
                          ),
                          Text(
                            "En stock",
                            maxLines: 1,
                            style: gColors.bodyTitle1_N_Gr,
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            "assets/images/DCL_ChH.svg",
                            width: 60,
                          ),
                          Container(
                            width: 10,
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildImage(context, widget.wArticle_Ebp!),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 10,
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              width: SizeBtn,
                              height: SizeBtn,
                              child: GestureDetector(
                                child: Container(
                                  child: Icon(
                                    Icons.delete,
                                    color: gColors.red,
                                    size: 60,
                                  ),
                                ),
                                onTap: () async {
                                  await HapticFeedback.vibrate();
                                  await showDialog(context: context, builder: (BuildContext context) => DialogSuppr(context, widget.wArticle_Ebp!.Article_descriptionCommercialeEnClair));
                                },
                              )),
                          Spacer(),
                          Row(
                            children: [
                              Container(
                                  width: SizeBtn,
                                  height: SizeBtn,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(60),
                                        ),
                                        color: (widget.wArticle_Ebp!.Art_Qte == 1) ? gColors.LinearGradient1 : gColors.greyDark2,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: gColors.white,
                                        size: 46,
                                      ),
                                    ),
                                    onLongPressStart: (detail) {
                                      print("onLongPressStart ");

                                      setState(() {
                                        if (timer != null) {
                                          timer!.cancel();
                                        }
                                        timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
                                          if (widget.wArticle_Ebp!.Art_Qte > 1) {
                                            widget.wArticle_Ebp?.Art_Qte--;
                                            setState(() {});
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
                                    onTap: () async {
                                      await HapticFeedback.vibrate();
                                      if (widget.wArticle_Ebp!.Art_Qte > 1) widget.wArticle_Ebp?.Art_Qte--;
                                      setState(() {});
                                    },
                                  )),
                              Container(
                                width: 10,
                              ),
                              Container(
                                width: 50,
                                child: Text(
                                  "${widget.wArticle_Ebp?.Art_Qte}",
                                  style: gColors.bodyTitle1_B_G24,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              Container(
                                  width: SizeBtn,
                                  height: SizeBtn,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(60),
                                        ),
                                        color: gColors.greyDark2,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: gColors.white,
                                        size: 46,
                                      ),
                                    ),
                                    onLongPressStart: (detail) {
                                      print("onLongPressStart ");

                                      setState(() {
                                        if (timer != null) {
                                          timer!.cancel();
                                        }
                                        timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
                                          if (widget.wArticle_Ebp!.Art_Qte < 999) {
                                            widget.wArticle_Ebp?.Art_Qte++;
                                            setState(() {});
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
                                    onTap: () async {
                                      await HapticFeedback.vibrate();
                                      if (widget.wArticle_Ebp!.Art_Qte < 999) widget.wArticle_Ebp?.Art_Qte++;
                                      setState(() {});
                                    },
                                  )),
                            ],
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            "assets/images/DCL_ChB.svg",
                            width: 60,
                          ),
                          Container(
                            width: 10,
                          ),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget DialogSuppr(BuildContext context, String wTitre) {
    double heightPos = 70;
    double wHeightPied = 105;
    double wLeft = 0;
    double wHeightBtnValider = 50;
    double wLabelWidth = 120;

    double wHeightDet2 = 502;
    double wWidth = 520;
    double wHeightTitre = 135;

    double wHeight = wHeightTitre + wHeightDet2 + wHeightPied - 30;

    print(" B U I L D ");

    return SimpleDialog(
      insetPadding: EdgeInsets.all(60),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.white,
      shadowColor: gColors.transparent,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: Colors.transparent,
              height: wHeight,
              width: wWidth,
            ),

////////////
// ENTETE
////////////
            Positioned(
              top: 0,
              left: 0,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                child: Container(
                  height: wHeightTitre - 22,
                  width: wWidth,
                  decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                  child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/DCL_Warning.svg",
                                height: 60,
                                width: 60,
                              ),
                              Container(width: 5),
                              Text(
                                (Srv_DbTools.gDCL_Det.DCL_Det_Type == "A") ? "Supprimer l'article ?" : "Supprimer l'élément ?",
                                style: gColors.bodyTitle1_B_G24,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ),

///////////
// PIED
///////////
            Positioned(
              top: wHeightTitre + wHeightDet2 - 30,
              left: wLeft,
              child: Container(
                  child: Container(
                width: wWidth,
                height: wHeightPied,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                decoration: BoxDecoration(
                  color: gColors.LinearGradient3,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: gColors.LinearGradient4,
                      height: 1,
                    ),
                    Container(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gColors.primaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Container(
                            width: 110,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "Non",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: gColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          child: Container(
                            width: 110,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "Oui",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {
                            await Srv_DbTools.delDCL_Det(Srv_DbTools.gDCL_Det.DCL_DetID!);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          width: 20,
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ),
////////////
// CONTENT
////////////
            // Content
            Positioned(
              top: wHeightTitre - 15,
              left: wLeft,
              child: Container(
                height: wHeightDet2,
                width: wWidth,
                color: gColors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildImage(context, widget.wArticle_Ebp!),
                      ],
                    ),
                    Text(
                      "${wTitre}",
                      maxLines: 3,
                      style: gColors.bodyTitle1_B_G24,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget DialogInfo(BuildContext context, String wTitre) {
    double heightPos = 70;
    double wHeightPied = 105;
    double wLeft = 0;
    double wHeightBtnValider = 50;
    double wLabelWidth = 120;

    double wHeightDet2 = 502;
    double wWidth = 520;
    double wHeightTitre = 135;

    double wHeight = wHeightTitre + wHeightDet2 + wHeightPied - 30;

    print(" B U I L D ");

    return SimpleDialog(
      insetPadding: EdgeInsets.all(60),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.white,
      shadowColor: gColors.transparent,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: Colors.transparent,
              height: wHeight,
              width: wWidth,
            ),

////////////
// ENTETE
////////////

            Positioned(
              top: 0,
              left: 0,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                child: Container(
                  height: wHeightTitre - 22,
                  width: wWidth,
                  decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                  child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/DCL_Info.svg",
                                    color: gColors.black,
                                    height: 60,
                                    width: 60,
                                  ),
                                  Container(width: 30),
                                  Text(
                                    "Information article",
                                    style: gColors.bodyTitle1_B_G24,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                        ],
                      )),
                ),
              ),
            ),

///////////
// PIED
///////////
            Positioned(
              top: wHeightTitre + wHeightDet2 - 30,
              left: wLeft,
              child: Container(
                  child: Container(
                width: wWidth,
                height: wHeightPied,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                decoration: BoxDecoration(
                  color: gColors.LinearGradient3,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: gColors.LinearGradient4,
                      height: 1,
                    ),
                    Container(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: gColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          child: Container(
                            width: 110,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "OK",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ),
////////////
// CONTENT
////////////
            // Content
            Positioned(
              top: wHeightTitre - 15,
              left: wLeft,
              child: Container(
                height: wHeightDet2,
                width: wWidth,
                color: gColors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildImage(context, widget.wArticle_Ebp!),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                        "${wTitre}",
                        maxLines: 3,
                        style: gColors.bodyTitle1_B_G24,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<Image> GetImage(Article_Ebp art, double wIcoWidth) async {
    if (art.wImgeTrvL) return art.wImageL!;

    await Srv_DbTools.getArticlesImg_Ebp(art.Article_codeArticle);
    gObj.pic = base64Decode(Srv_DbTools.gArticlesImg_Ebp.ArticlesImg_Image);
    if (gObj.pic.length > 0) {
      art.wImgeTrvL = true;
      art.wImageL = Image.memory(
        gObj.pic,
        fit: BoxFit.scaleDown,
        width: wIcoWidth,
        height: wIcoWidth,
      );
      return art.wImageL!;
    }

    art.wImgeTrvL = true;
    art.wImageL = Image.asset(
      "assets/images/Audit_det.png",
      height: wIcoWidth,
      width: wIcoWidth,
    );
    ;
    return art.wImageL!;
  }

  Widget buildImage(BuildContext context, Article_Ebp art) {
    return new FutureBuilder(
      future: GetImage(art, 400),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return new Container(width: 30);
        }
      },
    );
  }
}

//***************************
//***************************
//***************************

class StatePageDetail extends StatefulWidget {
  final Article_Ebp? wArticle_Ebp;
  final int? index;
  final Function()? callback;

  StatePageDetail({
    Key? key,
    @required this.wArticle_Ebp,
    @required this.index,
    @required this.callback,
  }) : super(key: key);

  @override
  StatePageDetailState createState() => StatePageDetailState();
}

class StatePageDetailState extends State<StatePageDetail> {
  var formatter = NumberFormat('###,###.00');
  Image? wImage;

  double SizeBtn = 60;
  double wHeightDet2 = 702;
  double wWidth = 560;
  double wHeightTitre = 115;

  bool isFav = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Srv_DbTools.wUserLogin_Art_Fav.contains(widget.wArticle_Ebp?.Article_codeArticle)) {
      isFav = true;
    }

    int wRem = 0;
    if (widget.wArticle_Ebp!.Article_PVHT > 0) {
      wRem = ((widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.Article_Promo_PVHT) / widget.wArticle_Ebp!.Article_PVHT * 100).round();
    }

    return Container(
      color: Colors.red,
      width: wWidth,
      child: Container(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: gColors.LinearGradient2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 671,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                color: Colors.white,
                child: Text("Détail"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//***************************
//***************************
//***************************

class StatePageTarif extends StatefulWidget {
  final Article_Ebp? wArticle_Ebp;
  final int? index;
  final Function()? callback;

  StatePageTarif({
    Key? key,
    @required this.wArticle_Ebp,
    @required this.index,
    @required this.callback,
  }) : super(key: key);

  @override
  StatePageTarifState createState() => StatePageTarifState();
}

class StatePageTarifState extends State<StatePageTarif> {
  var formatter = NumberFormat('###,##0.00');
  Image? wImage;

  double SizeBtn = 60;
  double wHeightDet2 = 702;
  double wWidth = 560;
  double wHeightTitre = 115;

  bool isFav = false;
  Timer? timer;

  double wSizetouche = 38;

  int wSelNombre = 0;

  void AjoutChiffre(int wCh) {
    String wStringNombre = "";
    int wNombre = 0;

    if (wSelNombre == 0) {
      wStringNombre = widget.wArticle_Ebp!.DCL_Det_PU.toStringAsFixed(2);
    } else if (wSelNombre == 1) {
      wStringNombre = widget.wArticle_Ebp!.DCL_Det_RemP.toStringAsFixed(2);
    } else if (wSelNombre == 2) {
      wStringNombre = widget.wArticle_Ebp!.DCL_Det_RemMt.toStringAsFixed(2);
    }

    print("wStringNombre ${wStringNombre}");

    wStringNombre = wStringNombre.replaceAll(".", "");
    wStringNombre = "$wStringNombre$wCh";

    print("wStringNombre ${wStringNombre}");
    wNombre = int.tryParse(wStringNombre) ?? 0;
    print("wNombre ${wNombre}");

    if (wSelNombre == 0) {
      widget.wArticle_Ebp!.DCL_Det_PU = wNombre / 100;
    } else if (wSelNombre == 1) {
      widget.wArticle_Ebp!.DCL_Det_RemP = wNombre / 100;
    } else if (wSelNombre == 2) {
      widget.wArticle_Ebp!.DCL_Det_RemMt = wNombre / 100;
    }

    compute();
  }

  void supprChiffre() {
    String wStringNombre = "";
    int wNombre = 0;

    if (wSelNombre == 0) {
      wStringNombre = widget.wArticle_Ebp!.DCL_Det_PU.toStringAsFixed(2);
    } else if (wSelNombre == 1) {
      wStringNombre = widget.wArticle_Ebp!.DCL_Det_RemP.toStringAsFixed(2);
    } else if (wSelNombre == 2) {
      wStringNombre = widget.wArticle_Ebp!.DCL_Det_RemMt.toStringAsFixed(2);
    }

    print("wStringNombre ${wStringNombre}");

    wStringNombre = wStringNombre.replaceAll(".", "");

    if (wStringNombre != null && wStringNombre.length > 0) {
      wStringNombre = wStringNombre.substring(0, wStringNombre.length - 1);
    }

    print("wStringNombre ${wStringNombre}");
    wNombre = int.tryParse(wStringNombre) ?? 0;
    print("wNombre ${wNombre}");

    if (wSelNombre == 0) {
      widget.wArticle_Ebp!.DCL_Det_PU = wNombre / 100;
    } else if (wSelNombre == 1) {
      widget.wArticle_Ebp!.DCL_Det_RemP = wNombre / 100;
    } else if (wSelNombre == 2) {
      widget.wArticle_Ebp!.DCL_Det_RemMt = wNombre / 100;
    }
    compute();
  }

  void raz() {
    if (wSelNombre == 0) {
      widget.wArticle_Ebp!.DCL_Det_PU = 0;
    } else if (wSelNombre == 1) {
      widget.wArticle_Ebp!.DCL_Det_RemP = 0;
    } else if (wSelNombre == 2) {
      widget.wArticle_Ebp!.DCL_Det_RemMt = 0;
    }
    compute();
  }

  void compute() {
    if (wSelNombre == 0) {
      widget.wArticle_Ebp!.DCL_Det_RemP = 0;
      if (widget.wArticle_Ebp!.Article_PVHT > 0) widget.wArticle_Ebp!.DCL_Det_RemP = (widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.DCL_Det_PU) / widget.wArticle_Ebp!.Article_PVHT * 100;
      widget.wArticle_Ebp!.DCL_Det_RemMt = widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.DCL_Det_PU;
    } else if (wSelNombre == 1) {
      widget.wArticle_Ebp!.DCL_Det_PU = widget.wArticle_Ebp!.Article_PVHT - (widget.wArticle_Ebp!.Article_PVHT * widget.wArticle_Ebp!.DCL_Det_RemP / 100);
      widget.wArticle_Ebp!.DCL_Det_RemMt = widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.DCL_Det_PU;
    } else if (wSelNombre == 2) {
      widget.wArticle_Ebp!.DCL_Det_PU = widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.DCL_Det_RemMt;
      widget.wArticle_Ebp!.DCL_Det_RemP = 0;
      if (widget.wArticle_Ebp!.Article_PVHT > 0) widget.wArticle_Ebp!.DCL_Det_RemP = (widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.DCL_Det_PU) / widget.wArticle_Ebp!.Article_PVHT * 100;
    }

    if (widget.wArticle_Ebp!.DCL_Det_PU > widget.wArticle_Ebp!.Article_PVHT) {
      widget.wArticle_Ebp!.DCL_Det_PU = widget.wArticle_Ebp!.Article_PVHT;
      widget.wArticle_Ebp!.DCL_Det_RemP = 0;
      if (widget.wArticle_Ebp!.Article_PVHT > 0) widget.wArticle_Ebp!.DCL_Det_RemP = (widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.DCL_Det_PU) / widget.wArticle_Ebp!.Article_PVHT * 100;
      widget.wArticle_Ebp!.DCL_Det_RemMt = widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.DCL_Det_PU;
    }

    setState(() {});
  }


  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, DateTime firstDate, DateTime lastDate) async {
    print("selectedDate >> ${selectedDate}");

    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: firstDate, lastDate: lastDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print("selectedDate << ${selectedDate}");
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (Srv_DbTools.wUserLogin_Art_Fav.contains(widget.wArticle_Ebp?.Article_codeArticle)) {
      isFav = true;
    }

    int wRem = 0;
    if (widget.wArticle_Ebp!.Article_PVHT > 0) {
      wRem = ((widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.Article_Promo_PVHT) / widget.wArticle_Ebp!.Article_PVHT * 100).round();
    }

    DateTime wDate = DateTime.now();
    try {
       wDate = new DateFormat("dd/MM/yyyy").parse(widget.wArticle_Ebp!.DCL_Det_DateLivr);
    } catch (e) {}
    var formatdate = new DateFormat('EEEE\ndd/MM/yyyy', 'fr_FR');
    String formattedDate = formatdate.format(wDate);
    formattedDate = formattedDate.replaceRange(
      0,
      1,
      formattedDate.substring(0, 1).toUpperCase(),
    );

    return Stack(
      children: [


        Container(
          color: Colors.white,
          width: wWidth,
          child: Container(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: gColors.LinearGradient2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.wArticle_Ebp!.Article_Promo_PVHT != 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 12, 0, 12),
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Promo',
                                    style: gColors.bodyTitle1_B_W24,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
                              color: gColors.LinearGradient2,
                              child: Text(
                                "${formatter.format(widget.wArticle_Ebp!.Article_PVHT).replaceAll(',', ' ').replaceAll('.', ',')}€",
                                style: gColors.bodyTitle1_N_G24.copyWith(decoration: TextDecoration.lineThrough),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
                              color: gColors.LinearGradient2,
                              child: Text(
                                "${wRem}%",
                                style: gColors.bodyTitle1_N_G24,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
                              color: gColors.LinearGradient2,
                              child: Text(
                                "${formatter.format(widget.wArticle_Ebp!.Article_Promo_PVHT).replaceAll(',', ' ').replaceAll('.', ',')}€",
                                style: gColors.bodyTitle1_B_G24.copyWith(
                                  color: Colors.orange,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 12, 0, 12),
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              decoration: BoxDecoration(
                                color: gColors.primaryGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'PV HT',
                                    style: gColors.bodyTitle1_B_W24,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
                              color: gColors.LinearGradient2,
                              child: Text(
                                "${formatter.format(widget.wArticle_Ebp!.Article_PVHT).replaceAll(',', ' ').replaceAll('.', ',')}€",
                                style: gColors.bodyTitle1_B_G24.copyWith(color: gColors.primaryGreen),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                  Container(
                    color: gColors.LinearGradient1,
                    height: 1,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 593,
                        width: 179,
                        color: gColors.LinearGradient3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 30,
                            ),
                            Text(
                              formattedDate,
                              style: gColors.bodyTitle1_B_G24,
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              height: 30,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: widget.wArticle_Ebp!.DCL_Det_Livr == 0 ? gColors.primaryBlue2 : gColors.LinearGradient3,
                                  side: BorderSide(
                                    color: widget.wArticle_Ebp!.DCL_Det_Livr == 0 ? gColors.primaryBlue2 : gColors.LinearGradient1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              child: Container(
                                width: 115,
                                height: 50,
                                padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                child: Text(
                                  "Livré",
                                  style: widget.wArticle_Ebp!.DCL_Det_Livr == 0 ? gColors.bodyTitle1_B_W24 : gColors.bodyTitle1_N_G24,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () async {
                                widget.wArticle_Ebp!.DCL_Det_Livr = 0;
                                widget.wArticle_Ebp!.DCL_Det_DateLivr = DateFormat('dd/MM/yyyy').format(DateTime.now());
                                setState(() {});
                              },
                            ),
                            Container(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: widget.wArticle_Ebp!.DCL_Det_Livr == 1 ? gColors.primaryRed : gColors.LinearGradient3,
                                    side: BorderSide(
                                      color: widget.wArticle_Ebp!.DCL_Det_Livr == 1 ? gColors.primaryRed : gColors.LinearGradient1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    )),
                                child: Container(
                                  width: 115,
                                  height: 50,
                                  padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                  child: Text(
                                    "Reliquat",
                                    style: widget.wArticle_Ebp!.DCL_Det_Livr == 1 ? gColors.bodyTitle1_B_W24 : gColors.bodyTitle1_N_G24,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () async {
                                  widget.wArticle_Ebp!.DCL_Det_Livr = 1;



                                  try {
                                    selectedDate = new DateFormat("dd/MM/yyyy").parse(widget.wArticle_Ebp!.DCL_Det_DateLivr);
                                  } catch (e) {}
                                  await _selectDate(context, DateTime(1900), DateTime(DateTime.now().year + 1, 12, 31));

print("selectedDate ${selectedDate.toString()}");

                                  widget.wArticle_Ebp!.DCL_Det_DateLivr = DateFormat('dd/MM/yyyy').format(selectedDate);


                                  setState(() {});
                                }),
                            Container(
                              height: 30,
                            ),
                            Container(
                              color: gColors.LinearGradient1,
                              height: 1,
                            ),
                            Container(
                              height: 30,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: widget.wArticle_Ebp!.DCL_Det_Statut == "Facturable" ? gColors.primaryGreen : gColors.LinearGradient3,
                                  side: BorderSide(
                                    color: widget.wArticle_Ebp!.DCL_Det_Statut == "Facturable" ? gColors.primaryGreen : gColors.LinearGradient1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              child: Container(
                                width: 115,
                                height: 50,
                                padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                child: Text(
                                  "Facturable",
                                  style: widget.wArticle_Ebp!.DCL_Det_Statut == "Facturable" ? gColors.bodyTitle1_B_W24 : gColors.bodyTitle1_N_G24,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () async {
                                if (widget.wArticle_Ebp!.DCL_Det_Statut == "Facturable") return;
                                widget.wArticle_Ebp!.DCL_Det_Statut = "Facturable";
                                widget.wArticle_Ebp!.DCL_Det_PU = widget.wArticle_Ebp!.Article_PVHT;
                                compute();

                                setState(() {});
                              },
                            ),
                            Container(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: widget.wArticle_Ebp!.DCL_Det_Statut == "Offert" ? gColors.btnMove : gColors.LinearGradient3,
                                  side: BorderSide(
                                    color: widget.wArticle_Ebp!.DCL_Det_Statut == "Offert" ? gColors.btnMove : gColors.LinearGradient1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              child: Container(
                                width: 115,
                                height: 50,
                                padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                child: Text(
                                  "Offert",
                                  style: widget.wArticle_Ebp!.DCL_Det_Statut == "Offert" ? gColors.bodyTitle1_B_W24 : gColors.bodyTitle1_N_G24,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () async {
                                if (widget.wArticle_Ebp!.DCL_Det_Statut == "Offert") return;

                                widget.wArticle_Ebp!.DCL_Det_Statut = "Offert";
                                widget.wArticle_Ebp!.DCL_Det_PU = 0;
                                compute();
                                setState(() {});
                              },
                            ),
                            Container(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: widget.wArticle_Ebp!.DCL_Det_Statut == "Compris" ? gColors.black : gColors.LinearGradient3,
                                  side: BorderSide(
                                    color: widget.wArticle_Ebp!.DCL_Det_Statut == "Compris" ? gColors.black : gColors.LinearGradient1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              child: Container(
                                width: 115,
                                height: 50,
                                padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                child: Text(
                                  "Compris",
                                  style: widget.wArticle_Ebp!.DCL_Det_Statut == "Compris" ? gColors.bodyTitle1_B_W24 : gColors.bodyTitle1_N_G24,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () async {
                                if (widget.wArticle_Ebp!.DCL_Det_Statut == "Compris") return;
                                widget.wArticle_Ebp!.DCL_Det_Statut = "Compris";
                                widget.wArticle_Ebp!.DCL_Det_PU = 0;
                                compute();

                                setState(() {});
                              },
                            ),
                            Container(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: widget.wArticle_Ebp!.DCL_Det_Statut == "Garantie" ? Colors.red : gColors.LinearGradient3,
                                  side: BorderSide(
                                    color: widget.wArticle_Ebp!.DCL_Det_Statut == "Garantie" ? Colors.red : gColors.LinearGradient1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              child: Container(
                                width: 115,
                                height: 50,
                                padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                child: Text(
                                  "Garantie",
                                  style: widget.wArticle_Ebp!.DCL_Det_Statut == "Garantie" ? gColors.bodyTitle1_B_W24 : gColors.bodyTitle1_N_G24,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () async {
                                if (widget.wArticle_Ebp!.DCL_Det_Statut == "Garantie") return;
                                widget.wArticle_Ebp!.DCL_Det_Statut = "Garantie";
                                widget.wArticle_Ebp!.DCL_Det_PU = 0;
                                compute();

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 590,
                        width: 1,
                        color: gColors.LinearGradient1,
                      ),
                      Container(
                        height: 590,
                        width: 380,
                        color: gColors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  side: BorderSide(
                                    color: gColors.LinearGradient1,
                                    width: wSelNombre == 0 ? 3 : 1,
                                  ),
                                  backgroundColor: gColors.SecondaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              child: Container(
                                width: 302,
                                height: 100,
                                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                child: Text(
                                  "PV Net HT\n${formatter.format(widget.wArticle_Ebp!.DCL_Det_PU).replaceAll(',', ' ').replaceAll('.', ',')}€",
                                  style: gColors.bodyTitle1_B_G24.copyWith(height: 1.5),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () async {
                                wSelNombre = 0;
                                setState(() {});
                              },
                            ),
                            Container(
                              height: 18,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                        width: wSelNombre == 1 ? 3 : 1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: 126,
                                    height: 100,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "Remise\n${formatter.format(widget.wArticle_Ebp!.DCL_Det_RemP).replaceAll(',', ' ').replaceAll('.', ',')}%",
                                      style: gColors.bodyTitle1_B_G24.copyWith(height: 1.5),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    wSelNombre = 1;
                                    setState(() {});
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                        width: wSelNombre == 2 ? 3 : 1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: 126,
                                    height: 100,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "Remise\n${formatter.format(widget.wArticle_Ebp!.DCL_Det_RemMt).replaceAll(',', ' ').replaceAll('.', ',')}€",
                                      style: gColors.bodyTitle1_B_G24.copyWith(height: 1.5),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    wSelNombre = 2;
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            Container(
                              height: 18,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "7",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(7);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "8",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(8);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "9",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(9);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "+",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {},
                                ),
                              ],
                            ),
                            Container(
                              height: 18,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "4",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(4);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "5",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(5);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "6",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(6);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "-",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {},
                                ),
                              ],
                            ),
                            Container(
                              height: 18,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "1",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(1);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "2",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(2);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "3",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(3);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.GrdBtn_Colors5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Text(
                                      "AC",
                                      style: gColors.bodyTitle1_B_G24,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    raz();
                                  },
                                ),
                              ],
                            ),
                            Container(
                              height: 18,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "0",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(0);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      "00",
                                      style: gColors.bodyTitle1_B_G32,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onPressed: () async {
                                    AjoutChiffre(0);
                                    AjoutChiffre(0);
                                  },
                                ),
                                Container(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: BorderSide(
                                        color: gColors.LinearGradient1,
                                      ),
                                      backgroundColor: gColors.LinearGradient3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Container(
                                    width: wSizetouche,
                                    height: 65,
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: SvgPicture.asset(
                                      "assets/images/DCL_ArrowLeft.svg",
                                      color: gColors.black,
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                  onPressed: () async {
                                    supprChiffre();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

if (widget.wArticle_Ebp!.DCL_Det_Statut != "Facturable" )
        Positioned(
          top: 210,
          left : 190,
          child:
          Container(
            height: 600,
            width: 400,

            color: gColors.transparent2,),

        ),



      ],
    );
  }
}
