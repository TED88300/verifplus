import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/pdf/PdfTools.dart';

Future<Uint8List> generateCR() async {



  final lorem = pw.LoremText();
  PdfPageFormat pageFormat;
  final bdC = Pdf_CR();
  pageFormat = PdfPageFormat.a4.applyMargin(left: 0, top: 0, right: 0, bottom: 0);
  return await bdC.buildPdf(pageFormat);
}

class Pdf_CR {
  final List<Organe> organes = [];

  final double tax = .20;
  double get _total => 0; //organes.map<double>((p) => p.total).reduce((a, b) => a + b);
  double get _grandTotal => _total * (1 + tax);

  Uint8List? imageData_1;
  Uint8List? imageData_Logo_Pied;
  Uint8List? imageData_Cachet;

  DateTime Parcs_Date_Rev_Min = DateTime.parse("2900-01-01");
  DateTime Parcs_Date_Rev_Max = DateTime.parse("1900-01-01");

  int wParcs_Intervention_Timer = 0;

  String wIntervenants = "";
  String wType = "";

  Uint8List pic = Uint8List.fromList([0]);
  late pw.Image wImage;
  int wImage_W = 0;
  int wImage_H = 0;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.

    String wUserImg = "Site_${Srv_DbTools.gSite.SiteId}.jpg";
    pic = await gColors.getImage(wUserImg);
    print("pic $wUserImg ${pic.length}");

    if (pic.isEmpty)
    {
      ByteData logoA = await rootBundle.load('assets/images/Blank.png');
      pic = (logoA).buffer.asUint8List();
    }

    pw.MemoryImage wMemoryImage =    pw.MemoryImage(
      pic,
    );

    wImage = pw.Image(
      fit : BoxFit.cover,
      wMemoryImage,
    );

    print("♠︎♠︎♠︎♠︎ wMemoryImage <<< ${wMemoryImage.width} ${wMemoryImage.height}");
    wImage_W = wMemoryImage.width!;
    wImage_H = wMemoryImage.height!;

    if (pic.isNotEmpty) {
      wImage = pw.Image(
        fit : BoxFit.cover,
//width : double.parse(wImage_W.toString()),
//        height : double.parse(wImage_H.toString()),
        wMemoryImage,
      );
    }

    var fontThemevp = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Regular.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")),
      italic: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Italic.ttf")),
      boldItalic: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-BoldItalic.ttf")),
    );


    var fontTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/Arial-Regular.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/Arial-Bold.ttf")),
      italic: Font.ttf(await rootBundle.load("assets/fonts/Arial-Italic.ttf")),
      boldItalic: Font.ttf(await rootBundle.load("assets/fonts/Arial-BoldItalic.ttf")),
    );




    final doc = pw.Document(
      theme: fontTheme,
    );
    ByteData logo_1 = await rootBundle.load('assets/Logo_1.jpg');
    imageData_1 = (logo_1).buffer.asUint8List();

    ByteData logoLogoPied = await rootBundle.load('assets/Logo_Pied.png');
    imageData_Logo_Pied = (logoLogoPied).buffer.asUint8List();

    logo_1 = await rootBundle.load('assets/Cachet.png');
    imageData_Cachet = (logo_1).buffer.asUint8List();

    for (int i = 0; i < Srv_DbTools.ListUserH.length; i++) {
      var element = Srv_DbTools.ListUserH[i];
      print("♠︎♠︎♠︎♠︎ ListUserH <<< ${element.User_Nom} ${element.H}");

      wIntervenants = "$wIntervenants ${wIntervenants.isNotEmpty ? ", " : ""}${element.User_Nom} ${element.User_Prenom} (${element.H}h)";
    }


    await DbTools.getAdresseClientType(Srv_DbTools.gClient.ClientId, "LIVR");
    await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gSite.SiteId, "SITE");

     List<Parc_Ent> wlparcsEnt = [];
    wlparcsEnt = await DbTools.getParcs_Ent(Srv_DbTools.gIntervention.InterventionId);

    print("♠︎♠︎♠︎♠︎ wlParcs_Ent <<< $wlparcsEnt");


    for (int i = 0; i < wlparcsEnt.length; i++) {
      var wparcsEnt = wlparcsEnt[i];



      String wDESC = "";
      String wFAB = "";
      String wPRS = "";
      String wCLF = "";

      String wPDT = "";
      String wPOIDS = "";

      for (int j = 0; j < DbTools.glfParcs_Desc.length; j++) {
        Parc_Desc wparcDesc = DbTools.glfParcs_Desc[j];
        if (wparcsEnt.ParcsId == wparcDesc.ParcsDesc_ParcsId && wparcDesc.ParcsDesc_Type == "DESC") {
          wDESC = gColors.AbrevTxt_Param_Param(wparcDesc.ParcsDesc_Lib!, wparcDesc.ParcsDesc_Type!);
          if (wDESC != "---" && !wType.contains(wDESC)) {
            if (wType.isNotEmpty) wType = "$wType,";
            wType = "$wType $wDESC";
          }
        }
        if (wparcsEnt.ParcsId == wparcDesc.ParcsDesc_ParcsId && wparcDesc.ParcsDesc_Type == "FAB")
          {
            wFAB = gColors.AbrevTxt_Param_Param(wparcDesc.ParcsDesc_Lib!, wparcDesc.ParcsDesc_Type!);
            print("♠︎♠︎♠︎♠︎ wFAB $wFAB  ${wparcDesc.ParcsDesc_Lib!}");
          }


        if (wparcsEnt.ParcsId == wparcDesc.ParcsDesc_ParcsId && wparcDesc.ParcsDesc_Type == "PRS") wPRS = gColors.AbrevTxt(wparcDesc.ParcsDesc_Lib!);
        if (wparcsEnt.ParcsId == wparcDesc.ParcsDesc_ParcsId && wparcDesc.ParcsDesc_Type == "CLF") wCLF = gColors.AbrevTxt(wparcDesc.ParcsDesc_Lib!);
        if (wparcsEnt.ParcsId == wparcDesc.ParcsDesc_ParcsId && wparcDesc.ParcsDesc_Type == "PDT") wPDT = gColors.AbrevTxt(wparcDesc.ParcsDesc_Lib!);
        if (wparcsEnt.ParcsId == wparcDesc.ParcsDesc_ParcsId && wparcDesc.ParcsDesc_Type == "POIDS") wPOIDS = gColors.AbrevTxt(wparcDesc.ParcsDesc_Lib!);
      }

      DateTime parcsDateRev = DateTime.now();

      try {
        parcsDateRev = DateTime.parse(wparcsEnt.Parcs_Date_Rev!);
      } catch (e) {}

      if (parcsDateRev.isBefore(Parcs_Date_Rev_Min)) Parcs_Date_Rev_Min = parcsDateRev;
      if (parcsDateRev.isAfter(Parcs_Date_Rev_Max)) Parcs_Date_Rev_Max = parcsDateRev;

      String wparcsDateRev = "";
      try {
        wparcsDateRev = DateFormat('dd/MM/yy').format(DateTime.parse(wparcsEnt.Parcs_Date_Rev!));
      } catch (e) {}

      print("${wparcsEnt.Parcs_Intervention_Timer}");
      if (wparcsEnt.Parcs_Intervention_Timer != null) wParcs_Intervention_Timer += wparcsEnt.Parcs_Intervention_Timer!;

      String Action = wparcsEnt.Action!;
      if (wparcsEnt.Parcs_UUID_Parent!.isNotEmpty)
      {
        DbTools.lParcs_Art = await DbTools.getParcs_Art(wparcsEnt.ParcsId!, "MS");
        print(" DbTools.lParcs_Art  B ${DbTools.lParcs_Art.length}");
        if (DbTools.lParcs_Art.isNotEmpty) {
          Parc_Art wparcArt = DbTools.lParcs_Art[0];
          print(" wParc_Art  B ${wparcArt.toMap()}");
          if (wparcArt.ParcsArt_Fact == "Devis")
          {
            Action = "Devis/${wparcsEnt.Action!}" ;
          }
          else
          {
            Action = "Neuf/${wparcsEnt.Action!}" ;
          }

        }
      }


      Organe wOrgane = Organe("${wparcsEnt.Parcs_order}", wDESC, wFAB, wPRS, wCLF, wPDT, wPOIDS, "${wparcsEnt.Parcs_FAB_Label}", "${wparcsEnt.Parcs_NIV_Label}", "${wparcsEnt.Parcs_ZNE_Label} / ${wparcsEnt.Parcs_EMP_Label}${wparcsEnt.Parcs_NoSpec!.isEmpty ? '': ' / ${wparcsEnt.Parcs_NoSpec}'}", wparcsDateRev, Action, wparcsEnt.Parcs_UUID_Parent!.isNotEmpty);
      organes.add(wOrgane);
    }

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: pageFormat.copyWith(
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentPage1(context),
        ],
      ),
    );


    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: pageFormat.copyWith(
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentTable(context),
        ],
      ),
    );


    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: pageFormat.copyWith(
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
        ),
        header: _buildHeaderLegende,
        footer: _buildFooter,
        build: (context) => [
          _contentPageLegende(context),
        ],
      ),
    );



    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    String wparcsDateRevMax = "";
    try {
      wparcsDateRevMax = DateFormat('dd/MM/yy').format(Parcs_Date_Rev_Max);
    } catch (e) {}

    return pw.Column(
      children: [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Container(
            height: 85,
            padding: const pw.EdgeInsets.only(left: 10),
            child: pw.Image(pw.MemoryImage(imageData_1!)),
          ),
        ]),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 8,
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    width: 1,
                    color: PdfColors.black,
                  ),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(1),
                  ),
                  color: PdfColors.grey400,
                ),
                padding: const pw.EdgeInsets.only(left: 40, top: 5, bottom: 0, right: 20),
                alignment: pw.Alignment.centerLeft,
                height: 42,
                child: pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                  child: pw.GridView(
                    crossAxisCount: 1,
                    children: [
                      pw.Text(
                        "COMPTE-RENDU N° ${Srv_DbTools.gIntervention.InterventionId} DU $wparcsDateRevMax",
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        "> $wType",
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                children: [
                  pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Expanded(
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1,
                            color: PdfColors.black,
                          ),
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(1),
                          ),
                          color: PdfColors.white,
                        ),
                        padding: const pw.EdgeInsets.only(left: 1, top: 5, bottom: 0, right: 1),
                        alignment: pw.Alignment.centerLeft,
                        height: 42,
                        child: pw.DefaultTextStyle(
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          child: pw.GridView(
                            crossAxisCount: 1,
                            children: [
                              pw.Text(
                                "Page",
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.Text(
                                "${context.pageNumber}/${context.pagesCount}",
                                textAlign: pw.TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) _buildHeader2(context),
        pw.SizedBox(height: 10)
      ],
    );
  }

  pw.Widget _buildHeader2(pw.Context context) {
    return pw.Column(children: [
      pw.SizedBox(height: 10),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  width: 1,
                  color: PdfColors.black,
                ),
                borderRadius: const pw.BorderRadius.all(
                  pw.Radius.circular(1),
                ),
                color: const PdfColor(54 / 255, 96 / 255, 146 / 255),
              ),
              padding: const pw.EdgeInsets.only(left: 40, top: 0, bottom: 0, right: 20),
              alignment: pw.Alignment.center,
              height: 50,
              child: pw.Text(
                "",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 12,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  width: 1,
                  color: PdfColors.black,
                ),
                borderRadius: const pw.BorderRadius.all(
                  pw.Radius.circular(1),
                ),
                color: PdfColors.white,
              ),
              padding: const pw.EdgeInsets.only(left: 10, top: 10, bottom: 0, right: 20),
              alignment: pw.Alignment.center,
              height: 50,
              child: pw.Column(children: [
                pw.Row(children: [
                  pw.Text(
                    "Site :",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  pw.Text(
                    Srv_DbTools.gSite.Site_Nom,
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 11,
                    ),
                  ),
                ]),
                pw.Row(children: [
                  pw.Text(
                    "${Srv_DbTools.gSite.Site_Adr1} ${Srv_DbTools.gSite.Site_Adr2} ${Srv_DbTools.gSite.Site_CP} ${Srv_DbTools.gSite.Site_Ville}",
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 11,
                    ),
                  ),
                ]),
              ]),
            ),
          ),
          pw.Expanded(
              flex: 8,
              child: pw.Column(children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      width: 1,
                      color: PdfColors.black,
                    ),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(1),
                    ),
                    color: PdfColors.white,
                  ),
                  padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 20),
                  alignment: pw.Alignment.center,
                  height: 25,
                  child: pw.Row(children: [
                    pw.Text(
                      "Groupe : ",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        Srv_DbTools.gGroupe.Groupe_Nom,
                        textAlign: pw.TextAlign.left,
                        maxLines: 1,
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ]),
                ),
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      width: 1,
                      color: PdfColors.black,
                    ),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(1),
                    ),
                    color: PdfColors.white,
                  ),
                  padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 20),
                  alignment: pw.Alignment.center,
                  height: 25,
                  child: pw.Row(children: [
                    pw.Text(
                      "Zone : ",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        Srv_DbTools.gZone.Zone_Nom,
                        textAlign: pw.TextAlign.left,
                        maxLines: 1,
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ]),
                ),
              ])),
        ],
      ),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  width: 1,
                  color: PdfColors.black,
                ),
                borderRadius: const pw.BorderRadius.all(
                  pw.Radius.circular(1),
                ),
                color: const PdfColor(146 / 255, 208 / 255, 80 / 255),
              ),
              padding: const pw.EdgeInsets.only(left: 40, top: 0, bottom: 0, right: 20),
              alignment: pw.Alignment.center,
              height: 25,
              child: pw.Text(
                "",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 20,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  width: 1,
                  color: PdfColors.black,
                ),
                borderRadius: const pw.BorderRadius.all(
                  pw.Radius.circular(1),
                ),
                color: PdfColors.white,
              ),
              padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 0, right: 20),
              alignment: pw.Alignment.center,
              height: 25,
              child: pw.Column(children: [
                pw.Row(children: [
                  pw.Text(
                    "Technicien : ",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  pw.Text(
                    wIntervenants,
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 11,
                    ),
                  ),
                ]),
              ]),
            ),
          ),
        ],
      ),
    ]);
  }

  pw.Widget _buildHeaderLegende(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Container(
            height: 85,
            padding: const pw.EdgeInsets.only(left: 10),
            child: pw.Image(pw.MemoryImage(imageData_1!)),
          ),
        ]),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 8,
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    width: 1,
                    color: PdfColors.black,
                  ),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(1),
                  ),
                  color: PdfColors.grey400,
                ),
                padding: const pw.EdgeInsets.only(left: 40, top: 5, bottom: 0, right: 20),
                alignment: pw.Alignment.centerLeft,
                height: 42,
                child: pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                  child: pw.GridView(
                    crossAxisCount: 1,
                    children: [
                      pw.Text(
                        "LEGENDE",
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                children: [
                  pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Expanded(
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1,
                            color: PdfColors.black,
                          ),
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(1),
                          ),
                          color: PdfColors.white,
                        ),
                        padding: const pw.EdgeInsets.only(left: 1, top: 5, bottom: 0, right: 1),
                        alignment: pw.Alignment.centerLeft,
                        height: 42,
                        child: pw.DefaultTextStyle(
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          child: pw.GridView(
                            crossAxisCount: 1,
                            children: [
                              pw.Text(
                                "Page",
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.Text(
                                "${context.pageNumber}/${context.pagesCount}",
                                textAlign: pw.TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
      pw.Container(
        width: 590,
        child: pw.Image(pw.MemoryImage(imageData_Logo_Pied!)),
      ),
    ]);
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  pw.Widget _contentPage1(pw.Context context) {
    Duration duration = Duration(seconds: wParcs_Intervention_Timer);
    String sduration = _printDuration(duration);

    String wparcsDateRevMin = "";
    try {
      wparcsDateRevMin = DateFormat('dd/MM/yy à HH:mm').format(Parcs_Date_Rev_Min);
    } catch (e) {}

    String wparcsDateRevMax = "";
    try {
      wparcsDateRevMax = DateFormat('dd/MM/yy à HH:mm').format(Parcs_Date_Rev_Max);
    } catch (e) {}

    return pw.Column(children: [
// SITE

    PdfTools.Titre(context, "", "SITE D'INTERVENTION", pw.TextAlign.center, const PdfColor(54 / 255, 96 / 255, 146 / 255), PdfColors.white),
      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        Container(
          width : 500,
          child: pw.Column(children: [
            PdfTools.C1_L2(context, "Site : ", Srv_DbTools.gSite.Site_Nom, "${Srv_DbTools.gSite.Site_Adr1} ${Srv_DbTools.gSite.Site_Adr2} ${Srv_DbTools.gSite.Site_CP} ${Srv_DbTools.gSite.Site_Ville}", pw.TextAlign.left, PdfColors.white, PdfColors.black),
            PdfTools.C2_L1(context, "Client : ", Srv_DbTools.gClient.Client_Nom, 7, "Compte : ", Srv_DbTools.gClient.Client_CodeGC, 3, pw.TextAlign.left, PdfColors.white, PdfColors.black),
          ]),
        ),

        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              width: 1,
              color: PdfColors.black,
            ),
            borderRadius: const pw.BorderRadius.all(
              pw.Radius.circular(1),
            ),
            color: PdfColors.grey,
          ),          padding: const pw.EdgeInsets.only(left: 1, top: 1, bottom: 0, right: 0),

          height :63,
          width :94,
          child: wImage,
        )
      ]),

      PdfTools.C2_L1(context, "Groupe : ", Srv_DbTools.gGroupe.Groupe_Nom, 5, "Zone : ", Srv_DbTools.gZone.Zone_Nom, 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Règlementation technique applicable au site : ", "Code du travail, APSAD R4", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Contact Site : ", "${Srv_DbTools.gContact.Contact_Civilite} ${Srv_DbTools.gContact.Contact_Prenom} ${Srv_DbTools.gContact.Contact_Nom}", 5, "Port (Contact Site) : ", Srv_DbTools.gContact.Contact_Tel2, 5, pw.TextAlign.left, PdfColors.grey200, PdfColors.black),
      PdfTools.C2_L1(context, "Tél : ", Srv_DbTools.gContact.Contact_Tel1, 5, "Mail : ", Srv_DbTools.gContact.Contact_eMail, 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),

      pw.SizedBox(height: 10),

      PdfTools.Titre(context, "", "INTERVENTION", pw.TextAlign.center, const PdfColor(146 / 255, 208 / 255, 80 / 255), PdfColors.white),
      PdfTools.C1_L1(context, "Type d'intervention : ", Srv_DbTools.gIntervention.Intervention_Type, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Début de l'intervention : ", wparcsDateRevMin, 5, "Fin de l'intervention : ", wparcsDateRevMax, 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Nombre d'organes visités : ", "${Srv_DbTools.ListParc_Desc.length}", 5, "Temps d'intervention : ", sduration, 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Agence de gestion : ", Srv_DbTools.gClient.Client_Depot, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Responsable d'intervention : ", "016-Anthony FUNDONI - Port : 06 25 47 56 12 - Mail : a.fundoni@mondialfeu.fr", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Technicien : ", wIntervenants, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Recommandations et Observations Post-Intervention :", "", pw.TextAlign.left, PdfColors.grey200, PdfColors.black),
      PdfTools.C1_L1(context, "", Srv_DbTools.gIntervention.Intervention_Remarque, pw.TextAlign.left, PdfColors.white, PdfColors.black, wMaxLines: 13),
      PdfTools.C2_L1(context, "Devis lié à l'intervention : ", "Oui, voir Devis", 5, "Reliquat lié à l'intervention : ", "Oui, voir Bon de Livraison", 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Plus de détail sur votre intervention : ", "https://verifplus.com", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Prestations et visite effectuées par (Technicien)", "", 5, "Prestations et visite constatées par (Client)", "", 5, pw.TextAlign.left, PdfColors.grey200, PdfColors.black),
      PdfTools.C2_L3(context, "Nom : ", Srv_DbTools.gIntervention.Intervention_Signataire_Tech, "Date : ", Srv_DbTools.gIntervention.Intervention_Signataire_Date, "Signature :", "", 5, "Nom :", Srv_DbTools.gIntervention.Intervention_Signataire_Client, "Date : ", Srv_DbTools.gIntervention.Intervention_Signataire_Date_Client, "Signature : ", "(Absent sur site)", 5, pw.TextAlign.left, PdfColors.white, PdfColors.black, imageData_Cachet: imageData_Cachet),
    ]);
  }

  pw.Widget _contentPageLegende(pw.Context context) {
    return pw.Column(children: [
// SITE
      PdfTools.C3_L1(context, "Colonne", "", 3, "Abréviation", "", 3, "Signification", "", 8, pw.TextAlign.left, PdfColors.grey200, PdfColors.black),
      PdfTools.C3_L1(context, "Groupe", "", 3, "", 'Ex : "Sud, Nord, ..."', 3, "", "Regroupement de vos sites dans un ou plusieurs groupes", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Site", "", 3, "", 'Ex : "Residence X"', 3, "", "Site d'intervention", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Zone", "", 3, "", 'Ex : "Bât. A, B, ..."', 3, "", "Division du site, parc d'organes en une ou polusieurs zones", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "N°", "", 3, "", '1, 2, 3, ...', 3, "", "Numérotation du parc", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Description", "", 3, "", 'Ext Port', 3, "", "Extincteur Portatif", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Description", "", 3, "", 'Ext Mob', 3, "", "Extincteur Mobile", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Description", "", 3, "", 'Douche', 3, "", "Douche de sécurité portative", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Description", "", 3, "", 'Ext Auto', 3, "", "Extincteur Automatique", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Description", "", 3, "", 'App Ext', 3, "", "Appareil d'extinction", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Fabricant", "", 3, "", 'Code', 3, "", "Code fabricant d'un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Pression", "", 3, "", 'PA/PP', 3, "", "Type de pression : Pression auxilliaire / Pression permanente", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Classes de feu", "", 3, "", 'A/AB/ABC/ABF/..', 3, "", "Classification par types de feux", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Eau', 3, "", "Extincteur pulvérisée à Eau", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Eau + Additif', 3, "", "Extincteur pulvérisée à Eau + Additif", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Poudre', 3, "", "Extincteur à Poudre", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Modèle", "", 3, "", 'CO2', 3, "", "Extincteur à Dioxyde de Carbone", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Mousse', 3, "", "Extincteur à Mousse", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Douche', 3, "", "Douche de sécurité portative", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Charge", "", 3, "", "6L, 9L, 6Kg, 9Kg, ...", 3, "", "Masse ou volume de l'agent extincteur contenu dans l'extincteur", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Année de Fabrication", "", 3, "", 'Ex : 2008', 3, "", "Date de fabrication d'un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Niveau", "", 3, "", 'RDC/R-1/R+1, ...', 3, "", "Etage distinct d'un bâtiment (RDC : rez-de-chaussée)", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Visite", "", 3, "", "Ex : 01/01/1900", 3, "", "Date à laquelle un organe de sécurité a été visité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Zone/Emplacement", "", 3, "", 'Ex : Bureaux, entrée', 3, "", "Zone, emplacement dans lequel est situé un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Action", "", 3, "", 'MS', 3, "", "Mise en service d'un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Action", "", 3, "", 'VF', 3, "", "Vérification d'un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Action", "", 3, "", 'RECH', 3, "", "Recharge d'un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Action", "", 3, "", 'MAA', 3, "", "Maintenance Additionnelle Approfondie d'un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Action", "", 3, "", 'CHGE', 3, "", "Charge de maintenance d'un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Action", "", 3, "", 'RA', 3, "", "Révision en Atelier d'un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Action", "", 3, "", 'REF', 3, "", "Réforme, mise au rebut d'un organe de sécurité", 8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    ]);
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = ['N°', 'Description', 'Fabricant', 'Pression', 'Classes de\nfeu', "Modèle", "Charge", "Année\nfabrication", "Niveau", "Zone/Emplacement/N°", "Visite", "Action"];
    return pw.TableHelper.fromTextArray(
      headerDirection: pw.TextDirection.rtl,
      border: TableBorder.all(),
      headerAlignment: pw.Alignment.center,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.grey200,
      ),
      headerHeight: 55,
      cellHeight: 25,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
        8: pw.Alignment.center,
        9: pw.Alignment.center,
        10: pw.Alignment.center,
        11: pw.Alignment.center,
      },
      columnWidths: <int, TableColumnWidth>{
        0: const FixedColumnWidth(4),
        1: const FixedColumnWidth(6),
        2: const FixedColumnWidth(5),
        3: const FixedColumnWidth(5),
        4: const FixedColumnWidth(5),
        5: const FixedColumnWidth(7),
        6: const FixedColumnWidth(5),
        7: const FixedColumnWidth(5),
        8: const FixedColumnWidth(5),
        9: const FixedColumnWidth(16),
        10: const FixedColumnWidth(6),
        11: const FixedColumnWidth(7),
      },
      headerDirections: [
        0,
        1,
        1,
        1,
        1,
        0,
        1,
        1,
        1,
        0,
        0,
        1,
      ],
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.black,
        fontSize: 9,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.white,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        organes.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => organes[row].getIndex(col),
        ),
      ),
    );
  }
}

class Organe {
  const Organe(
    this.no,
    this.DESC,
    this.FAB,
    this.PRS,
    this.CLF,
    this.PDT,
    this.POIDS,
    this.AA,
    this.NIV,
    this.ZONE,
    this.DATE,
    this.ACT,
      this.LNK,
  );

  final String no;
  final String DESC;
  final String FAB;
  final String PRS;
  final String CLF;
  final String PDT;
  final String POIDS;
  final String AA;
  final String NIV;
  final String ZONE;
  final String DATE;
  final String ACT;
  final bool LNK;

  String getIndex(int index) {
    switch (index) {
      case 0:
        String wno = no;
        if (LNK) {
          wno = "  └►";
        }
        return wno;
      case 1:
        return DESC;
      case 2:
        return FAB;
      case 3:
        return PRS;
      case 4:
        return CLF;
      case 5:
        return PDT;
      case 6:
        return POIDS;
      case 7:
        return AA;
      case 8:
        return NIV;
      case 9:
        return ZONE;
      case 10:
        return DATE;
      case 11:
        return ACT;
    }
    return '';
  }
}
