import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Adresses.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Contacts.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/pdf/PdfTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

Future<Uint8List> generateBL() async {
  final lorem = pw.LoremText();
  PdfPageFormat pageFormat;
  final bdC = Pdf_BL();
  pageFormat = PdfPageFormat.a4.applyMargin(left: 0, top: 0, right: 0, bottom: 0);
  return await bdC.buildPdf(pageFormat);
}

class Pdf_BL {
  final double tax = .20;
  double get _total => 0; //organes.map<double>((p) => p.total).reduce((a, b) => a + b);
  double get _grandTotal => _total * (1 + tax);

  Uint8List? imageData_1;
  Uint8List? imageData_Logo_Pied;
  Uint8List? imageData_Fili;
  Uint8List? imageData_Footer2;

  Adresse wAdresseFact = Adresse.AdresseInit();
  Contact wContactFact = Contact.ContactInit();
  Adresse wAdresseAg = Adresse.AdresseInit();

  Uint8List pic = Uint8List.fromList([0]);
  late pw.Image wImage;
  int wImage_W = 0;
  int wImage_H = 0;

  String wDate = "";

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    Srv_DbTools.selectedUserInter4 = "";
    Srv_DbTools.selectedUserInter4RC = "";
    if (Srv_DbTools.gIntervention.Intervention_Responsable4.isNotEmpty) {
      await Srv_DbTools.getUserid(Srv_DbTools.gIntervention.Intervention_Responsable4);
      Srv_DbTools.selectedUserInter4 = "${Srv_DbTools.gUser.User_Nom} ${Srv_DbTools.gUser.User_Prenom} / ${Srv_DbTools.gUser.User_Tel} / ${Srv_DbTools.gUser.User_Mail}";
      Srv_DbTools.selectedUserInter4RC = "${Srv_DbTools.gUser.User_Nom} ${Srv_DbTools.gUser.User_Prenom}\n${Srv_DbTools.gUser.User_Tel} / ${Srv_DbTools.gUser.User_Mail}";
    }

    wDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    String wUserImg = "Site_${Srv_DbTools.gSite.SiteId}.jpg";
    pic = await gColors.getImage(wUserImg);
    print("pic $wUserImg ${pic.length}");

    if (pic.isEmpty) {
      ByteData logoA = await rootBundle.load('assets/images/Blank.png');
      pic = (logoA).buffer.asUint8List();
    }

    pw.MemoryImage wMemoryImage = pw.MemoryImage(
      pic,
    );

    wImage = pw.Image(
      fit: BoxFit.cover,
      wMemoryImage,
    );

    print("♠︎♠︎♠︎♠︎ wMemoryImage <<< ${wMemoryImage.width} ${wMemoryImage.height}");
    wImage_W = wMemoryImage.width!;
    wImage_H = wMemoryImage.height!;

    if (pic.isNotEmpty) {
      wImage = pw.Image(
        fit: BoxFit.cover,
        wMemoryImage,
      );
    }

    var fontTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Regular.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")),
      italic: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Italic.ttf")),
      boldItalic: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-BoldItalic.ttf")),
    );

    final doc = pw.Document(
      theme: fontTheme,
    );

    ByteData logo_1 = await rootBundle.load('assets/BL_Header.jpg');
    imageData_1 = (logo_1).buffer.asUint8List();

    ByteData logoLogoPied = await rootBundle.load('assets/BL_Footer.png');
    imageData_Logo_Pied = (logoLogoPied).buffer.asUint8List();

    ByteData logoLogoPied2 = await rootBundle.load('assets/BL_Footer2.jpg');
    imageData_Footer2 = (logoLogoPied2).buffer.asUint8List();

    ByteData logoLogoFili = await rootBundle.load('assets/Fond_MONDIALFEU.jpg');
    imageData_Fili = (logoLogoFili).buffer.asUint8List();

    await DbTools.getAdresseClientType(Srv_DbTools.gClient.ClientId, "FACT");
    wAdresseFact = Srv_DbTools.gAdresse;
    await DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gAdresse.AdresseId, "FACT");
    wContactFact = Srv_DbTools.gContact;

    await DbTools.getAdresseClientType(Srv_DbTools.gClient.ClientId, "LIVR");
    await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gSite.SiteId, "SITE");

    await DbTools.getAdresseType("AGENCE");
    for (var wAdresse in Srv_DbTools.ListAdressesearchresult) {
      if (wAdresse.Adresse_Nom == Srv_DbTools.gClient.Client_Depot) {}
      wAdresseAg = wAdresse;
    }

    final PageTheme pageTheme = PageTheme(
      buildBackground: (Context context) => pw.Image(pw.MemoryImage(imageData_Fili!)),
      margin: const pw.EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
      orientation: pw.PageOrientation.portrait,
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          pw.Container(margin: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10), child: _contentTable(context)),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    if (context.pageNumber > 1) return _buildHeader2(context);

    double CadreSize = 130;
    double CadreSize2 = 65;
    return pw.Column(
      children: [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(children: [
            pw.Container(
              margin: const pw.EdgeInsets.only(left: 250, top: 40, bottom: 0, right: 0),
              width: 300,
              child: pw.Image(pw.MemoryImage(imageData_1!)),
            ),
            pw.Container(
                margin: const pw.EdgeInsets.only(left: 100, top: 12, bottom: 20, right: 0),
                width: 600,
                child: pw.Text(
                  "${wAdresseAg.Adresse_Nom} ${wAdresseAg.Adresse_Adr1} ${wAdresseAg.Adresse_Adr2} - ${wAdresseAg.Adresse_CP} ${wAdresseAg.Adresse_Ville}",
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                    color: PdfColors.grey500,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                )),
          ])
        ]),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
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
                      pw.Radius.circular(12),
                    ),
                  ),
                  padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
                  alignment: pw.Alignment.centerLeft,
                  height: CadreSize,
                  child: pw.Column(
                    children: [
                      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
                        pw.Expanded(
                          flex: 8,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.only(left: 0, top: 5, bottom: 5, right: 0),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Adresse de livaraison",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "A l'attention de ${Srv_DbTools.gContact.Contact_Civilite} ${Srv_DbTools.gContact.Contact_Prenom} ${Srv_DbTools.gContact.Contact_Nom}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          Srv_DbTools.gSite.Site_Nom,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          Srv_DbTools.gSite.Site_Adr1,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          Srv_DbTools.gSite.Site_Adr2,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "${Srv_DbTools.gSite.Site_CP} ${Srv_DbTools.gSite.Site_Ville}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(width: 10),
              pw.Expanded(
                flex: 8,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      width: 1,
                      color: PdfColors.black,
                    ),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(12),
                    ),
                  ),
                  padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
                  alignment: pw.Alignment.centerLeft,
                  height: CadreSize,
                  child: pw.Column(
                    children: [
                      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
                        pw.Expanded(
                          flex: 8,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.only(left: 0, top: 5, bottom: 5, right: 0),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Adresse de facturation",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "A l'attention de ${wContactFact.Contact_Civilite} ${Srv_DbTools.gContact.Contact_Prenom} ${Srv_DbTools.gContact.Contact_Nom}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          Srv_DbTools.gClient.Client_Nom,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          wAdresseFact.Adresse_Adr1,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          wAdresseFact.Adresse_Adr2,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "${wAdresseFact.Adresse_CP} ${wAdresseFact.Adresse_Ville}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 8,
                child: pw.Container(
                  padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
                  alignment: pw.Alignment.centerLeft,
                  height: CadreSize2,
                  child: pw.Column(
                    children: [
                      pw.SizedBox(height: 5),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "Tél : ${Srv_DbTools.gContact.Contact_Tel1}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "Tél Portable : ${Srv_DbTools.gContact.Contact_Tel2}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "Email : ${Srv_DbTools.gContact.Contact_eMail}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(width: 10),
              pw.Expanded(
                flex: 8,
                child: pw.Container(
                  padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
                  alignment: pw.Alignment.centerLeft,
                  height: CadreSize2,
                  child: pw.Column(
                    children: [
                      pw.SizedBox(height: 5),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "Tél : ${wContactFact.Contact_Tel1}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "Tél Portable : ${wContactFact.Contact_Tel2}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "Email : ${wContactFact.Contact_eMail}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 0),
            padding: const pw.EdgeInsets.only(left: 5, top: 0, bottom: 1, right: 0),
            alignment: pw.Alignment.centerLeft,
            color: PdfColors.grey300,
            child: pw.Text(
              "Technicien (ne) conseil : ",
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(
                color: PdfColors.black,
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.only(left: 5, top: 0, bottom: 1, right: 0),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              Srv_DbTools.selectedUserInter4,
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(
                color: PdfColors.black,
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ]),
        pw.SizedBox(height: 3),
        pw.Container(
          margin: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
          child: PdfTools.C5_L1(context, "Numéro", 3, "Date", 3, "Code client", 3, "Agent", 3, "Réference d'Intervention", 12, pw.TextAlign.center, PdfColors.grey300, PdfColors.black, true),
        ),
        pw.Container(
          margin: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
          child: PdfTools.C5_L1(context, "BL/Int/${Srv_DbTools.gIntervention.InterventionId}", 3, wDate, 3, Srv_DbTools.gClient.Client_CodeGC, 3, "0052", 3, "CR ${Srv_DbTools.gIntervention.InterventionId} du ${Srv_DbTools.gIntervention.Intervention_Date}", 12, pw.TextAlign.left, PdfColors.black, PdfColors.black, false),
        ),
        pw.SizedBox(height: 5),
      ],
    );
  }

  pw.Widget _buildHeader2(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Container(
              width: 300,
              margin: const pw.EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 20),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                PdfTools.C1_L1(context, "", wAdresseAg.Adresse_Nom, pw.TextAlign.center, PdfColors.white, PdfColors.black, wBorderPdfColor: PdfColors.grey300),
                PdfTools.C1_L1(context, "", "Client : ${Srv_DbTools.gClient.Client_Nom}", pw.TextAlign.center, PdfColors.white, PdfColors.black, wBorderPdfColor: PdfColors.grey300),
                PdfTools.C1_L1(context, "", "Bon de livraison : BL/Int/${Srv_DbTools.gIntervention.InterventionId} du $wDate", pw.TextAlign.center, PdfColors.white, PdfColors.black, wBorderPdfColor: PdfColors.grey300),
                PdfTools.C1_L1(context, "", "Technicien (ne) conseil : ${Srv_DbTools.selectedUserInter4RC}", pw.TextAlign.center, PdfColors.white, PdfColors.black, wMaxLines: 2, wBorderPdfColor: PdfColors.grey300),
              ]))
        ]),
      ],
    );
  }

  BoxDecoration CelDec(int index, dynamic data, int rowNum) {
    return const pw.BoxDecoration(
      border: pw.Border(
        left: pw.BorderSide(
          color: PdfColors.grey300,
          width: 1,
        ),
        right: pw.BorderSide(
          color: PdfColors.grey300,
          width: 1,
        ),
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
      pw.Container(
        margin: const pw.EdgeInsets.only(left: 540, top: 0, bottom: 90, right: 0),
        padding: const pw.EdgeInsets.only(left: 0, top: 10, bottom: 0, right: 12),
        height: 1,
        child: pw.Text(
          "${context.pageNumber} sur ${context.pagesCount}",
          textAlign: pw.TextAlign.right,
        ),
      ),
    ]);
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = ['Code', 'Description', '  Qte\nlivrée', '        Qte\ncommandée', 'Reliquat', " Date de\nlivraison"];

    return pw.TableHelper.fromTextArray(
      headerDirection: pw.TextDirection.rtl,
//      border: TableBorder.all(color: PdfColors.grey300),

      border: const TableBorder(
        left: BorderSide(width: 1.0, color: PdfColors.grey300),
        right: BorderSide(width: 1.0, color: PdfColors.grey300),
        top: BorderSide(width: 1.0, color: PdfColors.grey300),
        bottom: BorderSide(width: 1.0, color: PdfColors.grey300),
      ),

      cellDecoration: CelDec,

      headerAlignment: pw.Alignment.center,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300), //,border: Border(bottom: BorderSide(color: PdfColors.green,width: 5))),
      headerHeight: 25,
      cellHeight: 25,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.center,
      },

      headerAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
      },

      columnWidths: <int, TableColumnWidth>{
        0: const FixedColumnWidth(2.5),
        1: const FixedColumnWidth(12),
        2: const FixedColumnWidth(2),
        3: const FixedColumnWidth(3.3),
        4: const FixedColumnWidth(2),
        5: const FixedColumnWidth(2.5),
      },
      headerDirections: [
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 11,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.black,
        fontSize: 10,
      ),

      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        DbTools.lParcs_Art.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => Parc_Art.getIndex(DbTools.lParcs_Art[row], col),
        ),
      ),
    );
  }
}
