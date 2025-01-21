import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Widget/GestCo/DCL_Param.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

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
  late QuillEditorController controller;

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.underline,
    ToolBarStyle.color,
    ToolBarStyle.align,
    ToolBarStyle.headerOne,
    ToolBarStyle.headerTwo,
    ToolBarStyle.blockQuote,
    ToolBarStyle.undo,
    ToolBarStyle.redo,
  ];

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

    Reload();
  }

  @override
  void initState() {
    controller = QuillEditorController();
    SelTitre = "${Srv_DbTools.ListParam_Param_TitresRel[0].Param_Param_Text}";

    initLib();
  }

  @override
  void dispose() {
    /// please do not forget to dispose the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet = 585;
    double wHeightDet2 = 610;

    double wHeightBtn = 45;

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
                          Container(
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
                                  HTML_Text.gHTML_Text = await controller.getText();

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
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                height: wHeightDet2,
                width: wWidth,
                child: Column(
                  children: [
                    ToolBar(
                      toolBarColor: _toolbarColor,
                      padding: const EdgeInsets.all(8),
                      iconSize: 25,
                      iconColor: _toolbarIconColor,
                      activeIconColor: Colors.greenAccent.shade400,
                      controller: controller,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      toolBarConfig: customToolBarList,
                    ),
                    DropdownTitre(),

gColors.wLigne(),
                    Container(
                      height: 10,
                    ),


                    Expanded(
                      child: QuillHtmlEditor(
                        text: HTML_Text.wHTML_Text,
                        controller: controller,
                        isEnabled: true,
                        ensureVisible: false,
                        minHeight: 500,
                        autoFocus: true,
                        hintText : 'Saisir texte',
                        textStyle: _editorTextStyle,
                        hintTextStyle: _hintTextStyle,
                        hintTextAlign: TextAlign.start,
                        backgroundColor: _backgroundColor,
                        inputAction: InputAction.newline,
                        onEditingComplete: (s) => debugPrint('Editing completed $s'),
                        loadingBuilder: (context) {
                          return const Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: gColors.primary,
                          ));
                        },
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

  ///[getHtmlText] to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText);
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await controller.embedVideo(url);
  }

  /// to set the html text to editor
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await controller.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => controller.enableEditor(enable);

  /// method to un focus editor
  void unFocusEditor() => controller.unFocus();

//***************************
//***************************
//***************************

  Widget DropdownTitre() {
    if (Srv_DbTools.ListParam_Param_TitresRel.length == 0) return Container();

    print(" SelTitre ${SelTitre}");

    return Container(
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
                    width: 480,
                    child: Text(
                      "${item.Param_Param_Text}",
                      style: gColors.bodyTitle1_N_Gr,
                      maxLines: 1,
                    ),
                  ))).toList(),
              value: SelTitre,
              onChanged: (value) {
                setState(() {
                  String sValue = value as String;
                  SelTitre = sValue;
                  controller.setText(SelTitre);
                });
              },
              buttonStyleData: ButtonStyleData(
                height: 34,
                width: 520,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 32,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 750,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  color: Colors.white,
                ),
              ),
            )),
          ),
        ]));
  }
}
