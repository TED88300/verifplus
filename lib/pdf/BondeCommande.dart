import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:verifplus/pdf/PdfTools.dart';

Future<Uint8List> generateBdC() async {
  final lorem = pw.LoremText();
  PdfPageFormat pageFormat;



  final organes = <Organe>[
    Organe("1", "Ext Port", "65", "PA", "AB", "Eau + Add", "6L", "2023", "RDC", "Bureau/Entrée", "05/03/24", "VF"),
    Organe("2", "Ext Port", "65", "PA", "ABC", "Poudre", "9Kg", "2023", "RDC", "Centre comm./Restaurant", "05/03/24", "RECH"),
    Organe("3", "Ext Port", "65", "PA", "B", "Co2", "2Kg", "2023", "RDC", "Centre comm./Restaurant", "05/03/24", "MAA"),
    Organe("4", "Ext Port", "65", "PA", "A", "Eau", "6L", "2023", "RDC", "Centre comm./Restaurant", "05/03/24", "RA"),
    Organe("5", "Ext Port", "156", "PP", "AB", "Eau + Add", "150L", "2023", "RDC", "Centre comm./Restaurant", "05/03/24", "REF"),
    Organe("6", "Ext Mob", "65", "PA", "ABF", "Mousse", "9L", "2024", "RDC", "Centre comm./Restaurant", "06/03/24", "MS"),
    Organe("7", "Douche", "65", "PA", "", "Douche", "25L", "2004", "R-1", "Dépôt/Stock", "06/03/24", "VF"),
    Organe("8", "Ext Auto", "15", "PP", "BC", "Poudre", "6Kg", "2010", "R+1", "Dépôt/Chaufferie", "06/03/24", "REF"),
    Organe("9", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("10", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("11", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("12", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("13", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("14", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("15", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("16", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("17", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("18", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("19", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("20", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("21", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("22", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("23", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("24", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
    Organe("25", "App Ext", "0", "PP", "BC", "Poudre", "6Kg", "2011", "R+20", "Bureau/Entrée", "06/03/24", "CHGE"),
  ];

  final invoice = Invoice(
    invoiceNumber: '982347',
    organes: organes,
    customerName: 'Abraham Swearegin',
    customerAddress: '54 rue de Rivoli\n75001 Paris, France',
    paymentInfo: '4509 Wiseman Street\nKnoxville, Tennessee(TN), 37929\n865-372-0425',
    tax: .15,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  pageFormat = PdfPageFormat.a4.applyMargin(left: 0, top: 0, right: 0, bottom: 0);
  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  Invoice({
    required this.organes,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final List<Organe> organes;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  double get _total => 0; //organes.map<double>((p) => p.total).reduce((a, b) => a + b);
  double get _grandTotal => _total * (1 + tax);

  ByteData? _logo_1;
  Uint8List? imageData_1;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    _logo_1 = await rootBundle.load('assets/Logo_1.jpg');
    imageData_1 = (_logo_1)!.buffer.asUint8List();


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
                        "COMPTE-RENDU N° 123456 DU 06/03/2024",
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        "> Extincteur, Douche portative, Appareil d'extinction",
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
    return           pw.Column(children: [
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
                color: PdfColor(54 / 255, 96 / 255, 146 / 255),
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
                    "Ville de Martigues / Piscine Avantica",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 11,
                    ),
                  ),
                ]),
                pw.Row(children: [
                  pw.Text(
                    "8 Rue de la Mer - ZI de La Valampe - 13500 Martigues",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
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
                        "Sport",
                        textAlign: pw.TextAlign.left,
                        maxLines: 1,
                        style: pw.TextStyle(
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
                        "Bâtiment A",
                        textAlign: pw.TextAlign.left,
                        maxLines: 1,
                        style: pw.TextStyle(
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
                color: PdfColor(146 / 255, 208 / 255, 80 / 255),
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
                    "020-Kévin GABET",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
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
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
      pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            "Tél : 04 42 318 123 - Mail : info@mondialfeu.fr - www.mondialfeu.fr",
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey,
            ),
          ),
          pw.Text(
            "S.A.S.U au Capital de 200 000 euros - R.C.S. Aix-en-Provence - Siret : 509 401 568 00019 - NAF : 4669B",
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey,
            ),
          ),
          pw.Text(
            "Certifié APSAD sous le n° 615/04-285 (Référentiel I4 - NF 285)",
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey,
            ),
          ),
          pw.SizedBox(height: 10),
        ],
      )
    ]);
  }

  pw.Widget _contentPage1(pw.Context context) {
    return pw.Column(children: [
// SITE
      PdfTools.Titre(context, "", "SITE D'INTERVENTION", pw.TextAlign.center, PdfColor(54 / 255, 96 / 255, 146 / 255), PdfColors.white),

      PdfTools.C1_L2(context, "Site : ", "Ville de Martigues / Piscine Avantica", "8 Rue de la Mer - ZI de La Valampe - 13500 Martigues", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Client : ", "Ville de Martigues", 7, "Compte : ", "A000123", 3, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Groupe : ", "Sport", 5, "Zone : ", "Bât. A, Bât. B", 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Règlementation technique applicable au site : ", "Code du travail, APSAD R4", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Contact Site : ", "Monsieur Albert DUPONT", 5, "Port (Contact Site) : ", "06 25 47 56 12", 5, pw.TextAlign.left, PdfColors.grey200, PdfColors.black),
      PdfTools.C2_L1(context, "Tél : ", "04 4 2 31 81 23", 5, "Mail : ", "albert.dupont@ville-de-martigues.fr", 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),

      pw.SizedBox(height: 10),

      PdfTools.Titre(context, "", "INTERVENTION", pw.TextAlign.center, PdfColor(146 / 255, 208 / 255, 80 / 255), PdfColors.white),
      PdfTools.C1_L1(context, "Type d'intervention : ", "Vérification", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Début de l'intervention : ", "05/06/2024 - 8h00", 5, "Fin de l'intervention : ", "10/03/2024 - 15h00", 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Nombre d'organes visités : ", "80", 5, "Temps d'intervention : ", "12h00", 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Agence de gestion : ", "MONDIALFEU Grand-Sud - Tél : 04 42 318 123 - Mail : info@mondialfeu.fr", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Responsable d'intervention : ", "016-Anthony FUNDONI - Port : 06 25 47 56 12 - Mail : a.fundoni@mondialfeu.fr", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Technicien : ", "020-Kévin GABET, 021-Santo ESPOSITO, 020-Kévin GABET", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Recommandations et Observations Post-Intervention :", "", pw.TextAlign.left, PdfColors.grey200, PdfColors.black),
      PdfTools.C1_L1(
          context, "", "Créer un bon d'intervention efficace est essentiel pour s'assurer que les techniciens sur le terrain disposent de toutes les informations nécessaires pour mener à bien leur mission. Créer un bon d'intervention efficace est essentiel pour s'assurer que les techniciens sur le terrain disposent de toutes les informations nécessaires pour mener à bien leur mission. Créer un bon d'intervention efficace est essentiel pour s'assurer que les techniciens sur le terrain disposent de toutes les informations", pw.TextAlign.left, PdfColors.white, PdfColors.black,
          wMaxLines: 10),
      PdfTools.C2_L1(context, "Devis lié à l'intervention : ", "Oui, voir Devis", 5, "Reliquat lié à l'intervention : ", "Oui, voir Bon de Livraison", 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C1_L1(context, "Plus de détail sur votre intervention : ", "https://verifplus.com", pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C2_L1(context, "Prestations et visite effectuées par (Technicien)", "", 5, "Prestations et visite constatées par (Client)", "", 5, pw.TextAlign.left, PdfColors.grey200, PdfColors.black),
      PdfTools.C2_L3(context, "Nom : ", "020-Kévin GABET", "Date : ", "06/03/2024", "Signature :", "", 5, "Nom :", "", "Date : ", "06/03/2024", "Signature : ", "(Absent sur site)", 5, pw.TextAlign.left, PdfColors.white, PdfColors.black),

    ]);
  }


  pw.Widget _contentPageLegende(pw.Context context) {
    return pw.Column(children: [
// SITE


      PdfTools.C3_L1(context, "Colonne", "", 3, "Abréviation", "",3, "Signification", "",8, pw.TextAlign.left, PdfColors.grey200, PdfColors.black),
      PdfTools.C3_L1(context, "Groupe", "", 3, "", 'Ex : "Sud, Nord, ..."',3, "","Regroupement de vos sites dans un ou plusieurs groupes",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
      PdfTools.C3_L1(context, "Site", "", 3, "", 'Ex : "Residence X"',3, "","Site d'intervention",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Zone", "", 3, "", 'Ex : "Bât. A, B, ..."',3, "","Division du site, parc d'organes en une ou polusieurs zones",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "N°", "", 3, "", '1, 2, 3, ...',3, "","Numérotation du parc",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Description", "", 3, "", 'Ext Port',3, "","Extincteur Portatif",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Description", "", 3, "", 'Ext Mob',3, "","Extincteur Mobile",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Description", "", 3, "", 'Douche',3, "","Douche de sécurité portative",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Description", "", 3, "", 'Ext Auto',3, "","Extincteur Automatique",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Description", "", 3, "", 'App Ext',3, "","Appareil d'extinction",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Fabricant", "", 3, "", 'Code',3, "","Code fabricant d'un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Pression", "", 3, "", 'PA/PP',3, "","Type de pression : Pression auxilliaire / Pression permanente",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Classes de feu", "", 3, "", 'A/AB/ABC/ABF/..',3, "","Classification par types de feux",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Eau',3, "","Extincteur pulvérisée à Eau",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Eau + Additif',3, "","Extincteur pulvérisée à Eau + Additif",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Poudre',3, "","Extincteur à Poudre",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Modèle", "", 3, "", 'CO2',3, "","Extincteur à Dioxyde de Carbone",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Mousse',3, "","Extincteur à Mousse",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Modèle", "", 3, "", 'Douche',3, "","Douche de sécurité portative",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Charge", "", 3, "", "6L, 9L, 6Kg, 9Kg, ...",3, "","Masse ou volume de l'agent extincteur contenu dans l'extincteur",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Année de Fabrication", "", 3, "", 'Ex : 2008',3, "","Date de fabrication d'un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Niveau", "", 3, "", 'RDC/R-1/R+1, ...',3, "","Etage distinct d'un bâtiment (RDC : rez-de-chaussée)",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Visite", "", 3, "", "Ex : 01/01/1900", 3, "", "Date à laquelle un organe de sécurité a été visité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Zone/Emplacement", "", 3, "", 'Ex : Bureaux, entrée',3, "","Zone, emplacement dans lequel est situé un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Action", "", 3, "", 'MS',3, "","Mise en service d'un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Action", "", 3, "", 'VF',3, "","Vérification d'un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Action", "", 3, "", 'RECH',3, "","Recharge d'un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Action", "", 3, "", 'MAA',3, "","Maintenance Additionnelle Approfondie d'un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Action", "", 3, "", 'CHGE',3, "","Charge de maintenance d'un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Action", "", 3, "", 'RA',3, "","Révision en Atelier d'un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),
    PdfTools.C3_L1(context, "Action", "", 3, "", 'REF',3, "","Réforme, mise au rebut d'un organe de sécurité",8, pw.TextAlign.left, PdfColors.white, PdfColors.black),






    ]);
  }



  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = ['N°', 'Description', 'Fabricant', 'Pression', 'Classes de\nfeu',"Modèle",	"Charge",	"Année\nfabrication",	"Niveau",	"Zone/Emplacement",	"Visite",	"Action"];

    return pw.TableHelper.fromTextArray(
      headerDirection: pw.TextDirection.rtl,
      border: TableBorder.all(),

      headerAlignment: pw.Alignment.center,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
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
        10: const FixedColumnWidth(7),
        11: const FixedColumnWidth(6),
      },

      headerDirections: [ 0,
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
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
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

  String getIndex(int index) {
    switch (index) {
      case 0:
        return no;
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
