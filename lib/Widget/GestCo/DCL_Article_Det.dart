import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';



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

  var formatter = NumberFormat('#,##,###.00');


  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    var ListArticle_Ebpsearchresult = Srv_DbTools.ListArticle_Ebpsearchresult.where((element) => element.Art_Sel == true).toList();

    initLib();
  }


  @override
  Widget build(BuildContext context) {
    double heightPos = 70;

    double wHeightTitre = 115;
    double wHeightDet2 = 702;
    double wHeightPied = 105;

    double wWidth = 560;
    double wLeft = 0; //Magic Number

    double wHeightBtnValider = 50;
    double wLabelWidth = 120;
    double wHeight = wHeightTitre + wHeightDet2 + wHeightPied -30;



    List<Article_Ebp> ListArticle_Ebpsearchresult = Srv_DbTools.ListArticle_Ebpsearchresult.where((element) => element.Art_Sel == true).toList();
    Article_Ebp wArticle_Ebp = ListArticle_Ebpsearchresult[0];

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
              child: Container(
                  child: Container(
                    width: wWidth,
                    height: wHeightTitre,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    decoration: BoxDecoration(
                      color: gColors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: wWidth,
                          height: wHeightTitre-31,
                          child: Text(
                            "${wArticle_Ebp.Article_descriptionCommercialeEnClair}",
                            maxLines: 3,
                            style: gColors.bodyTitle1_B_G24,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Container(
                          color: gColors.black,
                          height: 1,
                        ),

                      ],
                    ),
                  )),
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
                top: wHeightTitre - 15,
                left: wLeft,
                child: Container(
                  color: Colors.white,
                  height: wHeightDet2,
                  width: wWidth,
                  child: Container(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            width: wWidth,
                            height: 80,
                            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                            color: gColors.LinearGradient2,
                            child: Text(
                              "PV HT ${formatter.format(wArticle_Ebp.Article_PVHT).replaceAll(',', ' ')}€",
                              maxLines: 3,
                              style: gColors.bodyTitle1_B_G24,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          Container(
                            color: gColors.black,
                            height: 1,
                          ),


                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ],
    );
  }

//***************************
//***************************
//***************************
}
