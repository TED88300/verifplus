import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Det.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

//**********************************
//**********************************
//**********************************

class DCL_Article_Det extends StatefulWidget {
  final String wTitre;
  const DCL_Article_Det({Key? key, required this.wTitre}) : super(key: key);

  @override
  _DCL_Article_DetState createState() => _DCL_Article_DetState();
}

class _DCL_Article_DetState extends State<DCL_Article_Det> {
  var formatter = NumberFormat('###,###.00');
  Image? wImage;

  double SizeBtn = 60;
  double wHeightDet2 = 702;
  double wWidth = 560;
  double wHeightTitre = 130;

  List<Widget> widgets = [];
  List<String> wTitres = [];

  List<int> wCpt = [];

  var pageController = PageController(keepPage: false, initialPage: 0);
  List<Article_Ebp> ListArticle_Ebpsearchresult = [];
  int indexPage = 0;



  void Erase() {
    Reload();
  }

  Future Reload() async {
    widgets.clear();
    wTitres.clear();
    // ListArticle_Ebpsearchresult = Srv_DbTools.ListArticle_Ebpsearchresult.where((element) => element.Art_Sel == true).toList();
    // for (int i = 0; i < ListArticle_Ebpsearchresult.length; i++) {

    int wPage = 0;

    for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
      Article_Ebp wArticle_Ebp = Srv_DbTools.ListArticle_Ebpsearchresult[i];
      if (!wArticle_Ebp.Art_Sel) continue;
      wTitres.add("${wArticle_Ebp.Article_descriptionCommercialeEnClair}\n(${wArticle_Ebp.Article_codeArticle})");

      StatePage wStatePage = StatePage(wArticle_Ebp: wArticle_Ebp, index: i, callback: Erase);
      widgets.add(wStatePage);
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

  Future<Image> GetImage(Article_Ebp art, double wIcoWidth) async {
    if (art.wImgeTrvL) return art.wImageL!;



    await Srv_DbTools.getArticlesImg_Ebp( art.Article_codeArticle);
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
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: wWidth,
                        height: wHeightTitre - 8,
                        padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                        child: Text(
                          "${wTitres[indexPage]}",
                          maxLines: 3,
                          style: gColors.bodyTitle1_B_G22,
                          textAlign: TextAlign.center,
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            width: 40,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "<",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          width: 210,
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
                              "Ajouter",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {

                            print("Ajouter Srv_DbTools.ListArticle_Ebpsearchresult.length ${Srv_DbTools.ListArticle_Ebpsearchresult.length}");

                            if (Srv_DbTools.ListArticle_Ebpsearchresult.length > 0) {

                              for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
                                Article_Ebp wArticle_Ebp = Srv_DbTools.ListArticle_Ebpsearchresult[i];
                                if (!wArticle_Ebp.Art_Sel) continue;

                                print("Ajouter B");

                                DCL_Det aDCL_Det = DCL_Det();
                                aDCL_Det.DCL_Det_EntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
                                aDCL_Det.DCL_Det_Type = "A";
                                aDCL_Det.DCL_Det_ParcsArtId = 0;
                                aDCL_Det.DCL_Det_Ordre = Srv_DbTools.getLastOrder() + 1;
                                aDCL_Det.DCL_Det_NoArt = wArticle_Ebp.Article_codeArticle;
                                aDCL_Det.DCL_Det_Lib = wArticle_Ebp.Article_descriptionCommercialeEnClair;
                                aDCL_Det.DCL_Det_Qte = wArticle_Ebp.Art_Qte;
                                aDCL_Det.DCL_Det_PU = wArticle_Ebp.Article_Promo_PVHT > 0 ? wArticle_Ebp.Article_Promo_PVHT : wArticle_Ebp.Article_PVHT;
                                aDCL_Det.DCL_Det_RemP = 0;
                                aDCL_Det.DCL_Det_RemMt = 0;
                                aDCL_Det.DCL_Det_Livr = 0;
                                aDCL_Det.DCL_Det_DateLivr = "";
                                aDCL_Det.DCL_Det_Rel = 0;
                                aDCL_Det.DCL_Det_DateRel = "";
                                aDCL_Det.DCL_Det_Statut = "";
                                aDCL_Det.DCL_Det_Note =  "";
                                await Srv_DbTools.InsertUpdateDCL_Det(aDCL_Det);
                              }
                            }
                            Navigator.pop(context);
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
              top: wHeightTitre - 2,
              left: wLeft,
              child: Container(
                height: wHeightDet2 - 28 ,
                width: wWidth,
color: Colors.green,
                child: (widgets.length > 0)
                    ? PageView.builder(
                    onPageChanged: (page) {
                      setState(() {
                        indexPage = page;
                        setState(() {});
                        });
                      },
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
    var dismissibleKey = GlobalKey<State>();
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        return widgets[index];
      },

    );
  }

  void onBottomIconPressed(int index) async {
    pageController.jumpToPage(index);
    indexPage = index;
    setState(() {});
  }

//***************************
//***************************
//***************************
}

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

  Timer? timer;


  @override
  Widget build(BuildContext context) {
    if (Srv_DbTools.gUserLogin_Art_Fav.contains(widget.wArticle_Ebp?.Article_codeArticle))
    {
      isFav = true;
    }

    int wRem = 0;
    if (widget.wArticle_Ebp!.Article_PVHT > 0)
    {
      wRem = ((widget.wArticle_Ebp!.Article_PVHT - widget.wArticle_Ebp!.Article_Promo_PVHT) / widget.wArticle_Ebp!.Article_PVHT * 100).round();
    }


    print(">>>>>>>>> StatePage build ${widget.index} ${widget.wArticle_Ebp?.Art_Qte}");
    return Container(
      color: Colors.white,
      width: wWidth,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: gColors.LinearGradient2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.wArticle_Ebp!.Article_Promo_PVHT != 0 ?
              Row(
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
                      style: gColors.bodyTitle1_B_G24.copyWith(color: Colors.orange,),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ) :
              Row(
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
                child:
                Column(children: [
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
                          child:  SvgPicture.asset(
                            "assets/images/DCL_Fav.svg",
                            color: !isFav ? gColors.greyDark : null,
                            height: 60,
                          ),
                        ),
                        onTap: () async {
                          await HapticFeedback.vibrate();
                          isFav = !isFav;
                          if (isFav)
                          {
                            Srv_DbTools.gUserLogin_Art_Fav.add(widget.wArticle_Ebp!.Article_codeArticle);
                          }
                          else
                          {
                            Srv_DbTools.gUserLogin_Art_Fav.remove(widget.wArticle_Ebp!.Article_codeArticle);
                          }
                          Srv_DbTools.setUserArtFav(Srv_DbTools.gUserLogin);
                          setState(() {});
                        },
                      ),

                      SvgPicture.asset(
                        "assets/images/DCL_Check.svg",
                        width: 40,
                      ),
                      Text(
                        "En stock",
                        maxLines: 3,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                size: 46,
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
                ],),

              ),


            ],
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                "Enlever l'article ?",
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
                                Srv_DbTools.ListArticle_Ebpsearchresult[widget.index!].Art_Sel = false;
                                widget.callback!();
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

    double wHeightDet2 = 520;
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



    await Srv_DbTools.getArticlesImg_Ebp( art.Article_codeArticle);
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
