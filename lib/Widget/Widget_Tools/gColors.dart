import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as LogDbg;
class gColors {

  static late ThemeData wTheme;

  static double MediaQuerysizewidth = 0;

  static const Color primary = Color(0xFF000000);
  static const Color secondary = Color(0xFFf80013);

  static const Color primaryGreen = Color(0xFF2e942b);
  static const Color primaryRed = Color(0xFFb33333);
  static const Color primaryOrange = Color(0xFFed7d31);
  static const Color primaryBlue = Color(0xFF4472c4);

  static const Color greyDark = Color(0xFF888888);
  static const Color greyLight = Color(0xFFf1f1f1);
  static const Color greyLight2 = Color(0xFFf4f4f4);
  static const Color greyTrans = Color(0x22000000);
  static const Color greyTitre = Color(0xFFcecece);


  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color btnMoveDark = Color(0xFF512c7a);
  static const Color btnMove = Color(0xFF67389a);
  static TextStyle get btnMove_B_W => TextStyle(
        color: white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      );

  static const Color LinearGradient1 = Color(0xFFaaaaaa);
  static const Color LinearGradient2 = Color(0xFFf6f6f6);
  static const Color LinearGradient3 = Color(0xFFe6e6e6);
  static const Color LinearGradient4 = Color(0xFFBBBBBB);

  static const Color TextColor1 = Color(0xFF222222);
  static const Color TextColor2 = Color(0xFF555555);
  static const Color TextColor3 = Color(0xFFFFFFFF);

  static const Color grey = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  static const Color tks = Color(0xFFEE4444);

  static const double height_Row = 40.0;
  static const double height_Header = 30.0;

  static const Color GrdBtn_Colors1 = Color(0xFFfdbdfe);
  static const Color GrdBtn_Colors1Sel = Color(0xFF857afd);
  static const Color GrdBtn_Colors2 = Color(0xFFc3ffc1);
  static const Color GrdBtn_Colors2Sel = Color(0xFF857afd);
  static const Color GrdBtn_Colors3 = Color(0xFFe0e0e0);
  static const Color GrdBtn_Colors3sel = Color(0xFF888888);

  static const Color GrdBtn_Colors4 = Color(0xFFfce1c1);
  static const Color GrdBtn_Colors4sel = Color(0xFFfbc182);

  static const Color fillColor = Color(0xFFF3F3F3);

  static Random random = new Random();
  static int ImageRandom = random.nextInt(10444) + 1;

  static Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }


  static Widget wBoxDecorationvv(BuildContext context)
  {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(13)),
      child: Container(

        child:gObj.wImage,

        decoration: BoxDecoration(

//          DecorationImage(image: MemoryImage(gObj.pic), fit: BoxFit.fill),
          color: Colors.cyan,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xffaaaaaa),
                blurRadius: 10,
                spreadRadius: 10),
          ],
        ),
      ),
    );
  }



  static Widget wBoxDecoration(BuildContext context)
  {
    return  Container(
      width: 40,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        image: DecorationImage(image: MemoryImage(gObj.picUser), fit: BoxFit.fill),
        color: Colors.white,
//        shape: BoxShape.circle,
      ),
    );
  }

  static Widget wBoxDecorationvp =
  Container(
    decoration: BoxDecoration(
      image: DecorationImage(image: MemoryImage(gObj.pic), fit: BoxFit.fill),
      color: Colors.white,
      shape: BoxShape.circle,
    ),
  );


  static Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;
    final lowDivisor = 6;
    final highDivisor = 5;
    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;

    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    };
  }

  static double wNorm = 14;

  static TextStyle get bodyTitle1_B_P => TextStyle(
        color: primary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_G32 => TextStyle(
    color: grey,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get bodyTitle1_B_R32 => TextStyle(
    color: Colors.redAccent,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );



  static TextStyle get bodyTitle1_B_W32 => TextStyle(
    color: white,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get bodyTitle1_B_G28 => TextStyle(
    color: grey,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get bodyTitle1_B_G24 => TextStyle(
    color: grey,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get bodyTitle1_N_G24 => TextStyle(
    color: grey,
    fontSize: 24,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyTitle1_B_G22 => TextStyle(
    color: grey,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get bodyTitle1_N_G22 => TextStyle(
    color: grey,
    fontSize: 22,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyTitle1_B_S32 => TextStyle(
    color: secondary,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );


  static TextStyle get bodyTitle1_B_Pr => TextStyle(
        color: primary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_S => TextStyle(
        color: secondary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_Sr => TextStyle(
        color: secondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_Wr => TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_G => TextStyle(
        color: grey,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_G_20 => TextStyle(
        color: grey,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_N_G_20 => TextStyle(
    color: grey,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyTitle1_N_G => TextStyle(
        color: grey,
        fontSize: 24,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyTitle1_B_W => TextStyle(
        color: white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_Green => TextStyle(
    color: primaryGreen,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );




  static TextStyle get bodyTitle1_N_W => TextStyle(
        color: white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyTitle1_B_Gr => TextStyle(
        color: grey,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get bodyTitle1_B_R => TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get bodyTitle1_N_Gr => TextStyle(
        color: grey,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyTitle1_N_R => TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyTitle1_Aide => TextStyle(
        color: GrdBtn_Colors3sel,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySaisie_B_G => TextStyle(
        color: grey,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodySaisie_N_G => TextStyle(
        color: grey,
        fontSize: wNorm,
        fontWeight: FontWeight.normal,
      );


  static TextStyle get smallSaisie_N_G => TextStyle(
    color: grey,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );



  static TextStyle get bodySaisie_B_O => TextStyle(
    color: Colors.red,
    fontSize: wNorm,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get bodySaisie_N_O => TextStyle(
    color: Colors.red,
    fontSize: wNorm,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodySaisie_N_W => TextStyle(
        color: white,
        fontSize: wNorm,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySaisie_B_W => TextStyle(
        color: white,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodySaisie_N_S => TextStyle(
        color: secondary,
        fontSize: wNorm,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySaisie_B_S => TextStyle(
        color: secondary,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodySaisie_N_B => TextStyle(
        color: Colors.black,
        fontSize: wNorm,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySaisie_B_B => TextStyle(
        color: Colors.black,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyText_B_G => TextStyle(
        color: grey,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyText_B_B => TextStyle(
        color: primary,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyText_S_B => TextStyle(
        color: secondary,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyText_S_O => TextStyle(
        color: Colors.deepOrangeAccent,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyText_B_R => TextStyle(
        color: tks,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get smallText_P_N => TextStyle(
    color: primary,
    fontSize: 8,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get smallText_P_B => TextStyle(
    color: primary,
    fontSize: 8,
    fontWeight: FontWeight.bold,
  );


  static Widget wLabel(var aIcon, String aLabel, String aData) {
    return Row(
      children: [
        aIcon == null
            ? Container()
            : Icon(
                aIcon,
                color: Colors.grey,
              ),
        SizedBox(
          width: 2,
        ),
        Container(
          child: Text(
            aLabel,
            style: bodySaisie_N_G,
          ),
        ),
        Expanded(
          child: Text(
            aData,
            textAlign: TextAlign.right,
            style: bodyText_B_B,
          ),
        ),
      ],
    );
  }

  static Widget wLabelTitle(var aIcon, String aLabel, String aData) {
    return Row(
      children: [
        aIcon == null
            ? Container()
            : Icon(
                aIcon,
                color: Colors.grey,
              ),
        SizedBox(
          width: 2,
        ),
        Container(
          child: Text(
            aLabel,
            style: bodyText_B_B,
          ),
        ),
        Expanded(
          child: Text(
            aData,
            textAlign: TextAlign.right,
            style: bodyText_B_B,
          ),
        ),
      ],
    );
  }

  static Widget wLabel2(var aIcon, String aLabel, String aData) {
    return Row(
      children: [
        aIcon == null
            ? Container()
            : Icon(
                aIcon,
                color: Colors.grey,
              ),
        SizedBox(
          width: 2,
        ),
        Container(
          child: Text(
            aLabel,
            style: bodyTitle1_B_Pr,
          ),
        ),
      ],
    );
  }

  static Widget wNumber(String aLabel, String aData) {
    return Row(
      children: [
        SizedBox(
          width: 50,
        ),
        Icon(
          Icons.local_offer,
          color: Colors.grey,
        ),
        SizedBox(
          width: 2,
        ),
        Container(
          width: 60,
          child: Text(
            aLabel,
            style: gColors.bodySaisie_N_G,
          ),
        ),
        Expanded(
          child: Text(
            aData,
            textAlign: TextAlign.right,
            style: gColors.bodyText_B_B,
          ),
        ),
      ],
    );
  }

  static Widget wDoubleLigne() {
    return Column(
      children: [
        SizedBox(height: 8.0),
        Container(
          height: 1,
          color: gColors.primary,
        ),
        Container(
          height: 2,
        ),
        Container(
          height: 1,
          color: gColors.primary,
        ),
        SizedBox(height: 8.0),
      ],
    );
  }


  static Widget wLigne() {
    return Column(
      children: [
        Container(
          height: 1,
          color: gColors.LinearGradient1,
        ),
      ],
    );
  }


  static Widget wSimpleLigne() {
    return Column(
      children: [
        SizedBox(height: 8.0),
        Container(
          height: 1,
          color: gColors.LinearGradient1,
        ),
        SizedBox(height: 8.0),
      ],
    );
  }

  static Widget wSimpleLigneRouge() {
    return Column(
      children: [
        Container(
          height: 1,
          color: gColors.secondary,
        ),
      ],
    );
  }

  static Widget LabelTextWidget(String txt, Color ColorTxt, double width, double padd) {
    return Container(
      width: width,
      height: 20,
      padding: EdgeInsets.fromLTRB(0, padd, 8, 0),
      child: Text(
        txt,
        style: gColors.bodySaisie_N_W.copyWith(fontSize: 14, color: ColorTxt),
        //textAlign: TextAlign.right,
      ),
    );
  }

  static Widget LabelTextWidgetBold(String txt, Color ColorTxt, double width, double padd) {
    return Container(
      width: width,
      height: 20,
      padding: EdgeInsets.fromLTRB(0, padd, 8, 0),
      child: Text(
        txt,
        style: gColors.bodyTitle1_B_Gr.copyWith(color: ColorTxt),
        //textAlign: TextAlign.right,
      ),
    );
  }



  static Widget DataTextWidget(String txt, Color ColorTxt, double width, double padd) {
    return Container(
      width: width,
      height: 20,
      padding: EdgeInsets.fromLTRB(0, padd, 0, 0),
      child: Text(
        txt,
        style: gColors.bodySaisie_N_W.copyWith(fontSize: 14, color: ColorTxt),
      ),
    );
  }

  static Widget CadreTextWidget(String txt, Color Color1, Color Color2, Color ColorTxt, double width, double p) {
    return Container(
      width: width,
      color: Color1,
      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
      child: Container(
        color: Color2,
        padding: EdgeInsets.fromLTRB(p, p, p, p),
        child: Text(
          txt,
          style: gColors.bodySaisie_N_W.copyWith(color: ColorTxt),
        ),
      ),
    );
  }

  static AffZoomImage(BuildContext context, Image wImageArt) async {

    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),


          contentPadding: EdgeInsets.zero,
          content: Container(
            child: wImageArt!,
            width: 700,
          ),
        ));
  }

  static AffZoomImageArticle(BuildContext context, Image wImageArt, String wTxt, String wTxt2) async {





    return showDialog(
        context: context,
        builder: (_) =>  AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
          title:  InkWell(
            onTap: () async {
              Navigator.of(context).pop();            },
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$wTxt",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_Gr,
                ),
                Container(
                  height: 8,
                ),
                Text(
                  "$wTxt2",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_N_Gr,
                ),
                Container(
                  height: 8,
                ),

              ]),),
          contentPadding: EdgeInsets.zero,
          content:
          InkWell(
            onTap: () async {
              Navigator.of(context).pop();            },
            child:
            Container(
              height: 620,
              child:

                Column(children: [
                  Container(
                    color: gColors.black,
                    height: 1,
                  ),
                  Container(
                    height: 8,
                  ),
                  Container(
                    height: 600,
                    width: 600,
                    child: wImageArt!,
                  ),
                  Container(
                    height: 8,
                  ),
                  Container(
                    color: gColors.black,
                    height: 1,
                  ),

                ],))
           ),
          actions: <Widget>[
            Container(
              height: 8,
            ),
          ],
        ));
  }






  static AffUser(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          surfaceTintColor: Colors.white,
              title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                gObj.wImage,
                SizedBox(height: 8.0),
                Container(color: Colors.grey, height: 1.0),
                SizedBox(height: 8.0),
                Text(
                    "Utilisateur ${Srv_DbTools.gUserLogin.UserID}",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                Text(
                  "${Srv_DbTools.gUserLogin.User_TypeUser}",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ]),
              content: Container(
                height: 120,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('N° matricule : '),
                        Spacer(),
                        Text(Srv_DbTools.gUserLogin.User_Matricule),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Prénom : '),
                        Spacer(),
                        Text(Srv_DbTools.gUserLogin.User_Prenom),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Nom : '),
                        Spacer(),
                        Text(Srv_DbTools.gUserLogin.User_Nom),
                      ],
                    ),

                  ],
                ),
              ),
              actions: <Widget>[
                Text(DbTools.gVersion,
                    style: TextStyle(
                      fontSize: 12,
                    )),
                Container(
                  width: 90,
                ),
                ElevatedButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  static String AbrevTxt(String wTxt) {
    Srv_DbTools.ListParam_Param_Abrev.forEach((element) {
//      print("element.Param_Param_ID ${element.Param_Param_ID} ${element.Param_Param_Text}");

      wTxt = wTxt.replaceAll(element.Param_Param_ID, element.Param_Param_Text);
    });
    return wTxt;
  }

  static String AbrevTxt_Param_Param(String wTxt, String wParam_Id) {




    if (wParam_Id.isNotEmpty)
      {
        Srv_DbTools.getParam_Saisie_ParamMem(wParam_Id);

        Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
          String wTmp = element.Param_Saisie_Param_Label.replaceAll(" - ", "-");
          if (wTmp.compareTo(wTxt) == 0) {
            wTxt = element.Param_Saisie_Param_Abrev;
          }
        });
      }

//    print("AbrevTxt_Param_Param A $wTxt ${Srv_DbTools.ListParam_Param_Abrev.length}");

    Srv_DbTools.ListParam_Param_Abrev.forEach((element) {
      wTxt = wTxt.replaceAll(element.Param_Param_ID, element.Param_Param_Text);
    });

//    print("AbrevTxt_Param_Param B $wTxt");

    return wTxt;
  }

  static void printWrapped(String text) {

    LogDbg.log(text);

//    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
//    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static InputDecoration wRechInputDecorationSelPlanning = InputDecoration(
    filled: true,
    fillColor: gColors.LinearGradient2,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(1.0),
      borderSide: BorderSide(
        color: gColors.primary,
        width: 0.5,
      ),
    ),
    hintText: 'Recherche',
    isDense: true,
    contentPadding: EdgeInsets.fromLTRB(8, 12, 0, 12),
  );



  static Widget gCircle(Color wColor)  {
    return  Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
            color: wColor,
            shape: BoxShape.circle
        ));
  }


  static Color getColorEtatDevis(String Status) {
    Color wColor = Colors.transparent;

    for (int p = 0; p < Srv_DbTools.ListParam_Param_Etat_Devis.length; p++) {
      Param_Param wParam_Param = Srv_DbTools.ListParam_Param_Etat_Devis[p];

      print("getColorEtatDevis ${Status} ${wParam_Param.Param_Param_ID}");

      if (wParam_Param.Param_Param_ID == Status)
      {
        wColor = gColors.getColor(wParam_Param.Param_Param_Color);
        break;
      }
    }
    return wColor;
  }


  static Color getColorEtatCde(String Status) {
    Color wColor = Colors.transparent;

    for (int p = 0; p < Srv_DbTools.ListParam_Param_Etat_Cde.length; p++) {
      Param_Param wParam_Param = Srv_DbTools.ListParam_Param_Etat_Cde[p];

      print("getColorEtatCde ${Status} ${wParam_Param.Param_Param_ID}");

      if (wParam_Param.Param_Param_ID == Status)
      {
        wColor = gColors.getColor(wParam_Param.Param_Param_Color);
        break;
      }
    }
    return wColor;
  }

  static Color getColorEtatLivr(String Status) {
    Color wColor = Colors.transparent;

    for (int p = 0; p < Srv_DbTools.ListParam_Param_Etat_Livr.length; p++) {
      Param_Param wParam_Param = Srv_DbTools.ListParam_Param_Etat_Livr[p];

      print("getColorEtatLivr ${Status} ${wParam_Param.Param_Param_ID}");

      if (wParam_Param.Param_Param_ID == Status)
      {
        wColor = gColors.getColor(wParam_Param.Param_Param_Color);
        break;
      }
    }
    return wColor;
  }









  static Color getColorStatus(String Status) {
    Color wColor = Colors.transparent;

    for (int p = 0; p < Srv_DbTools.ListParam_Param_Status_Interv.length; p++) {
      Param_Param wParam_Param = Srv_DbTools.ListParam_Param_Status_Interv[p];
      if (wParam_Param.Param_Param_ID == Status)
      {
        wColor = gColors.getColor(wParam_Param.Param_Param_Color);
        break;
      }
    }
   return wColor;
  }

  static Color getColor(String color)
{
  Color wColor = Colors.green;
  switch (color) {
    case "Noir":
      wColor = Colors.black;
      break;
    case "Vert":
      wColor = Colors.green;
      break;
    case "Orange":
      wColor = Colors.orange;
      break;
    case "Rouge":
      wColor = Colors.red;
      break;
    case "Bleu":
      wColor = Colors.blue;
      break;
    case "Violet":
      wColor = Colors.deepPurple;
      break;
    case "Jaune":
      wColor = Color(0xFFFFC000);
      break;
    case "RougeF":
      wColor = Color(0xFFC00000);
      break;
  }
  return wColor;
}






  static Future<Uint8List> getImage(String url) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Srv_DbTools.SrvUrl.toString()));
      request.fields.addAll({'zasq': 'getImage', 'img': '$url'});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        //print("-----------x getImage contentLength ${response.contentLength}");

        return await response.stream.toBytes();
        // print("getImage wTmp $wTmp");
      } else {
        //print("-----------x getImage Error ${response.statusCode}");
        return new Uint8List(0);
      }
    } catch (e) {
      //print("-----------x getImage Error ${e}");

      return new Uint8List(0);
    }
  }

  static Future<Uint8List> getDoc(String url) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Srv_DbTools.SrvUrl.toString()));
      request.fields.addAll({'zasq': 'getDoc', 'doc': '$url'});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.toBytes();
      } else {
        return new Uint8List(0);
      }
    } catch (e) {
      return new Uint8List(0);
    }
  }


  static Widget TxtField(BuildContext context, double lWidth, double wWidth, String wLabel, TextEditingController textEditingController, {TextInputType wTextInputType = TextInputType.none, Iterable<String>? wautofillHints = const [], bool obscureText = false, String wErrorText = "", int Ligne = 1, String sep = " : ", int maxChar = -1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lWidth == -1
            ? Container(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Text(
            wLabel,
            style: gColors.bodySaisie_N_G,
          ),
        )
            : Container(
          width: lWidth,
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Text(
            wLabel,
            style: gColors.bodySaisie_N_G,
          ),
        ),
        Container(
          width: 12,
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Text(
            sep,
            style: gColors.bodySaisie_N_G,
          ),
        ),
        Container(
            width: wWidth * 6,
            child: TextFormField(
              obscureText: obscureText,
              keyboardType: wTextInputType,
              autofillHints: wautofillHints,
              minLines: Ligne,
              maxLines: Ligne,
              decoration: InputDecoration(
                errorText: wErrorText.isEmpty ? null : wErrorText,
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              inputFormatters: [
                if (maxChar > 0) LengthLimitingTextInputFormatter(maxChar),
              ],

              controller: textEditingController,

//               maxLength: maxChar,

              style: gColors.bodySaisie_B_B,
            )),
        Container(
          width: 20,
        ),
      ],
    );
  }

  static Widget DescText(BuildContext context, double wWidth,  String wText, int Ligne) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
//          color: Colors.red,
            width: wWidth,
            child: Text(wText,
              maxLines : Ligne,
            ))
      ],
    );
  }


  static Widget DescTextSmall(BuildContext context, double wWidth,  String wText, int Ligne) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
//          color: Colors.red,
            width: wWidth,
            child: Text(wText,
              maxLines : Ligne,
              style: gColors.smallSaisie_N_G,
            ))
      ],
    );
  }

}
