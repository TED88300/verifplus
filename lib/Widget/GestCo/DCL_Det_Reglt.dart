import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/GestCo/DCL_Det_Sign.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class DCL_Det_Reglt extends StatefulWidget {
  const DCL_Det_Reglt({super.key});

  @override
  DCL_Det_RegltState createState() => DCL_Det_RegltState();
}

class DCL_Det_RegltState extends State<DCL_Det_Reglt> with SingleTickerProviderStateMixin {
  final groupButtonController = GroupButtonController();

  void Reload() async {
    setState(() {});
  }

  @override
  Future initLib() async {
    Reload();
  }

  @override
  void initState() {
    super.initState();

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    String wTitre2 = "${Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_ZoneNom}";
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom == Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom) wTitre2 = "";

    double icoWidth = 40;
    double wHeight =   MediaQuery.of(context).size.height - 184;

    double wWidth = MediaQuery.of(context).size.width;

    return SimpleDialog(insetPadding: const EdgeInsets.fromLTRB(0, 185, 0, 0), titlePadding: EdgeInsets.zero, contentPadding: EdgeInsets.zero, surfaceTintColor: Colors.transparent, backgroundColor: gColors.white, shadowColor: Colors.transparent, children: [
      Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: wHeight,
          width: wWidth,
          color: gColors.LinearGradient3,
          child: Column(
            children: [
              gColors.ombre(),
              Expanded(child:
              Container(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AffBtnParam("", "Livraison prévisionnelle", Srv_DbTools.gUserLogin.User_DCL_Ent_LivrPrev, "DCL_Date2", gColors.white, gColors.primaryBlue, "Livraison prévisionnelle"),
                    AffBtnParam("", "Mode de règlement", Srv_DbTools.gUserLogin.User_DCL_Ent_ModeRegl, "DCL_ModeReglt.svg", gColors.white, gColors.primaryBlue, "Mode de règlement"),
                    AffBtnParam("", "Moyen de paiement", Srv_DbTools.gUserLogin.User_DCL_Ent_MoyRegl, "DCL_MoyenPaiement.svg", gColors.white, gColors.primaryBlue, "Moyen de paiement"),
                    Container(height: 10),
                    AffSignature(),
                    Container(height: 15),
                    AffHT(),
                    AffTVA(),
                    AffTTC(),
                    AffACTPTE(),
                    AffSolde(),
                    Container(height: 40),

                    AffBas(),
                    Container(height: 10),
                  ],
                ),
              ),)
            ],
          )),
    ]);
  }

  Widget AffSignature() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 8,
          child: Container(
              height: 61,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Signature",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 61,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();

                    await initLib();
                    setState(() {});
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: gColors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: gColors.primaryGreen,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        "Agent",
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: gColors.bodyTitle1_B_Green,
                      ))),
            ]),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 61,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();

                    await initLib();
                    setState(() {});
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: gColors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: gColors.red,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        "Client",
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: gColors.bodyTitle1_B_O,
                      ))),
            ]),
          ),
        ),
      ],
    );
  }

  Widget AffHT() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Container(
              height: 51,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total HT",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 8,
          child: Container(
            height: 51,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();

                    await initLib();
                    setState(() {});
                  },
                  child: Container(
                      child: Text(
                    "${gObj.formatterformat(Srv_DbTools.gDCL_Ent.DCL_Ent_MtHT!)}€",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ))),
            ]),
          ),
        ),
      ],
    );
  }

  Widget AffTVA() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Container(
              height: 51,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "TVA",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 51,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();

                    await initLib();
                    setState(() {});
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: gColors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: gColors.black,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        "20,00%",
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: gColors.bodyTitle1_B_Gr,
                      ))),
            ]),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 51,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();

                    await initLib();
                    setState(() {});
                  },
                  child: Container(
                      child: Text(
                    "${gObj.formatterformat(Srv_DbTools.gDCL_Ent.DCL_Ent_MtTVA!)}€",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ))),
            ]),
          ),
        ),
      ],
    );
  }

  Widget AffTTC() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Container(
              height: 51,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total TTC",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 8,
          child: Container(
            height: 51,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();

                    await initLib();
                    setState(() {});
                  },
                  child: Container(
                      child: Text(
                    "${gObj.formatterformat(Srv_DbTools.gDCL_Ent.DCL_Ent_MtTTC!)}€",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ))),
            ]),
          ),
        ),
      ],
    );
  }

  Widget AffACTPTE() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Container(
              height: 51,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Acompte TTC",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 51,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();

                    await initLib();
                    setState(() {});
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: gColors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: gColors.black,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        "0,00%",
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: gColors.bodyTitle1_B_Gr,
                      ))),
            ]),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 51,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();

                    await initLib();
                    setState(() {});
                  },
                  child: Container(
                      child: Text(
                    "${gObj.formatterformat(0)}€",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ))),
            ]),
          ),
        ),
      ],
    );
  }

  Widget AffSolde() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Container(
              height: 51,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Solde dù TTC",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 8,
          child: Container(
            height: 51,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();

                    await initLib();
                    setState(() {});
                  },
                  child: Container(
                      child: Text(
                    "${gObj.formatterformat(Srv_DbTools.gDCL_Ent.DCL_Ent_MtTTC!)}€",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_O,
                  ))),
            ]),
          ),
        ),
      ],
    );
  }

  Widget AffBas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Container(
              height: 61,
              child:
              TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    print("onPressed");
                    await HapticFeedback.vibrate();


                    await showDialog(
                      context: context,
                      barrierColor: const Color(0x00000000),
                      builder: (BuildContext context) => const DCL_Det_Sign(),
                    );





                    setState(() {});
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/DCL_Sign.svg",
                        width: 40,
                      ),
                      Text(
                        "Signer",
                        maxLines: 1,
                        style: gColors.bodyTitle1_B_Gr,
                      ),
                    ],
                  )),
              ),
        ),

        Expanded(
          flex: 8,
          child: Container(
            height: 61,
            child:
            TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  print("onPressed");
                  await HapticFeedback.vibrate();

                  await initLib();
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/DCL_Acpte.svg",
                      width: 40,
                    ),
                    Text(
                      "Acompte",
                      maxLines: 1,
                      style: gColors.bodyTitle1_B_Gr,
                    ),
                  ],
                )),
          ),
        ),

        Expanded(
          flex: 8,
          child: Container(
            height: 61,
            child:
            TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  print("onPressed");
                  await HapticFeedback.vibrate();

                  await initLib();
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/DCL_Impr.svg",
                      width: 40,
                    ),
                    Text(
                      "Imprimer",
                      maxLines: 1,
                      style: gColors.bodyTitle1_B_Gr,
                    ),
                  ],
                )),
          ),
        ),

        Expanded(
          flex: 8,
          child: Container(
            height: 61,
            child:
            TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  print("onPressed");
                  await HapticFeedback.vibrate();

                  await initLib();
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    SvgPicture.asset(
                      "assets/images/DCL_Transf.svg",
                      width: 40,
                    ),
                    Text(
                      "Transférer",
                      maxLines: 1,
                      style: gColors.bodyTitle1_B_Gr,
                    ),
                  ],
                )),
          ),
        ),


      ],
    );
  }

  Widget AffBtnParam(String wChamps, String wTitle, String wValue, String ImgL, Color BckGrd, Color ForeGrd, String wParam) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          print("onPressed");
          await HapticFeedback.vibrate();

          await initLib();
          setState(() {});
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", BckGrd, ImgL, ForeGrd),
          ],
        ));
  }

  Widget AffLigne(
    String wTextL,
    String wTextR,
    Color BckGrd,
    String ImgL,
    Color ForeGrd,
  ) {
    double wHeight = 71;
    double mTop = 28;
    double icoWidth = 32;

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        decoration: BoxDecoration(
          color: BckGrd,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: gColors.LinearGradient5,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : ImgL.contains(".svg")
                        ? Container(
                            padding: const EdgeInsets.only(left: 16),
                            child: SvgPicture.asset(
                              "assets/images/$ImgL",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 16),
                            child: Image.asset(
                              "assets/images/$ImgL.png",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      wTextL,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodyTitle1_B_Gr,
                    )),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(right: 16, top: mTop),
                        height: wHeight,
                        child: Text(
                          wTextR,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: gColors.bodyTitle1_B_Gr.copyWith(color: ForeGrd),
                        ))),
              ],
            ),
          ],
        ));
  }
}
