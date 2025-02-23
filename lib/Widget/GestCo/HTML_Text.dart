import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';

import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class HTML_Text {
  HTML_Text();

  static String gHTML_Text = "";
  static String wHTML_Text = "";

  static Future<void> Dialogs_HTMLText(BuildContext context, String wTitre) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => HTMLText(
        wTitre: wTitre,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class HTMLText extends StatefulWidget {
  final String wTitre;
  const HTMLText({Key? key, required this.wTitre}) : super(key: key);

  @override
  _HTMLTextState createState() => _HTMLTextState();
}

class _HTMLTextState extends State<HTMLText> {
  QuillController _controller = QuillController.basic();

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);

  String SelTitre = "";

  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    HTML_Text.wHTML_Text = HTML_Text.gHTML_Text;

    String htmlContent = "${HTML_Text.gHTML_Text}";
    var delta = HtmlToDelta().convert(htmlContent);
    _controller.document = Document.fromDelta(delta);

    Reload();
  }

  @override
  void initState() {
    SelTitre = Srv_DbTools.ListParam_Param_TitresRel[0].Param_Param_Text;
    initLib();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet = 585;
    double wHeightDet2 = 610;
    double wHeightBtnValider = 40;

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Stack(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Colors.transparent,
                height: wHeight,
                child: Column(
                  children: [
// Titre
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 110,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: wWidth,
                            child: Text(
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    )),

                    Container(
                      height: wHeightDet,
                    ),

// Pied
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 110,
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
                            color: gColors.black,
                            height: 1,
                          ),
                          Container(
                            height: 22,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: gColors.primaryRed,
                                ),
                                child: Container(
                                  width: 140,
                                  height: wHeightBtnValider,
                                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
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
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: gColors.primaryGreen,
                                    )),
                                child: Container(
                                  width: 140,
                                  height: wHeightBtnValider,
                                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                  child: Text(
                                    "Valider",
                                    style: gColors.bodyTitle1_B_W24,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () async {
                                  // HTML_Text.gHTML_Text = await controller.getText();

                                  final converter = QuillDeltaToHtmlConverter(
                                    _controller.document.toDelta().toJson(),
                                    ConverterOptions.forEmail(),
                                  );

                                  final html = converter.convert();
                                  //   print(html);
                                  HTML_Text.gHTML_Text = html;
                                  // print("❤️❤️❤️❤️ document  ${_controller.document.toDelta().toJson()}");
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                )),
            Positioned(
              top: 190,
              left: 5,
              child: Container(
                color: gColors.LinearGradient3,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                height: wHeightDet2,
                width: wWidth,
                child: Column(
                  children: [
                    QuillSimpleToolbar(
                      controller: _controller,
                      config: const QuillSimpleToolbarConfig(
                        showDividers: true,
                        showFontFamily: false,
                        showSmallButton: false,
                        showUnderLineButton: false,
                        showLineHeightButton: false,
                        showStrikeThrough: false,
                        showInlineCode: false,
                        showClearFormat: false,
                        showLink: false,
                        showSearchButton: false,
                        showAlignmentButtons: true,
                        showSubscript: false,
                        showSuperscript: false,
                        showListCheck: false,
                        showCodeBlock: false,
                        showQuote: false,
                        showListNumbers: false,
                      ),
                    ),
                    DropdownTitre(),
                    gColors.wLigne(),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        color: gColors.white,
                        child: QuillEditor.basic(
                          controller: _controller,
                          config: const QuillEditorConfig(),
                        ),
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

  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _toolbarIconColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: _toolbarColor),
          )),
    );
  }

//***************************
//***************************
//***************************

  Widget DropdownTitre() {
    if (Srv_DbTools.ListParam_Param_TitresRel.isEmpty) return Container();

    print(" SelTitre $SelTitre");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gColors.LinearGradient5,
          width: 1.5,
        ),
      ),
      width: 510,
      height: 57,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: gColors.LinearGradient5,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            ),
            width: 110,
            child: Center(
              child: Text(
                "Texte rapide",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_W,
              ),
            ),
          ),
          Container(
            width: 12,
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: Row(children: [
                Container(
                  width: 5,
                ),
                Container(
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                    hint: Text(
                      'Séléctionner une titre',
                      style: gColors.bodyTitle1_N_Gr,
                    ),
                    items: Srv_DbTools.ListParam_Param_TitresRel.map((item) => DropdownMenuItem<String>(
                          value: item.Param_Param_Text,
                          child: Container(

                              color: gColors.LinearGradient5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: gColors.LinearGradient5,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.fromLTRB(0, 15, 20, 20),
                                              child: Text(
                                                "${item.Param_Param_Text}",
                                                style: gColors.bodyTitle1_N_Gr,
                                                maxLines: 5,
                                              ),
                                            ),
                                          ),
                                          gColors.gCircle(item.Param_Param_Text == SelTitre ? gColors.primaryGreen : gColors.LinearGradient4, wSize: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                  )
                                ],
                              )),
                        )).toList(),
                    selectedItemBuilder: (BuildContext context) {
                      return Srv_DbTools.ListParam_Param_TitresRel.map((item) => DropdownMenuItem<String>(
                          value: item.Param_Param_Text,
                          child: Container(
                            width: 340,
                            child: Text(
                              "${item.Param_Param_Text}",
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: gColors.bodyTitle1_N_Gr,
                              maxLines: 1,
                            ),
                          ))).toList();
                    },
                    value: SelTitre,
                    onChanged: (value) {
                      setState(() {
                        String sValue = value as String;
                        SelTitre = sValue;
//                  controller.setText(SelTitre);
                        String htmlContent = "${SelTitre}";
                        var delta = HtmlToDelta().convert(htmlContent);
                        _controller.document = Document.fromDelta(delta);
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 57,
                      width: 370,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 100,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      padding: EdgeInsets.zero,
                      maxHeight: 550,
                      width: 540,
                      offset: Offset(-145, 10),
                      elevation: 0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  )),
                ),
              ]))
        ],
      ),
    );
  }
}
