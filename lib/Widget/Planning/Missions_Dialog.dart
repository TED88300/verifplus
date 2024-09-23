import 'dart:convert';
import 'dart:typed_data';

import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_InterMissions.dart';
import 'package:verifplus/Tools/PdfView.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Missions_Dialog {
  Missions_Dialog();

  static Future<void> Missions_dialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Missions(),
    );
  }
}

class Missions extends StatefulWidget {
  @override
  State<Missions> createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  InterMission wInterMission = InterMission.InterMissionInit();

  String wTitle = "";

  String selectedMission = "";
  String selectedMissionID = "";
  List<String> List_Mission = [];
  List<String> List_MissionID = [];

  bool isSelect = false;

  int iPhotoDoc = 1;

  List<Widget> listPdf = [];



  List<Uint8List> _images = [];

  late SfPdfViewer wSfPdfViewer;
  PdfViewerController wPdfViewerController = PdfViewerController();

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Widget wWidgetPdf = Container();
  Widget wPdf = Container();
  Uint8List pic = Uint8List.fromList([0]);

  Future Reload() async {
    await Srv_DbTools.getInterMissionsIntervention(Srv_DbTools.gIntervention.InterventionId!);
    await Filtre();
  }

  Future Filtre() async {
    Srv_DbTools.ListInterMissionsearchresult.clear();
    Srv_DbTools.ListInterMissionsearchresult.addAll(Srv_DbTools.ListInterMission);
    Srv_DbTools.ListInterMissionsearchresult.forEach((element) {
      print("Srv_DbTools ${element.InterMission_InterventionId} ${element.InterMissionId}");
    });
    setState(() {});
  }

  void initLib() async {
    await Srv_DbTools.getParam_ParamFam("Missions");
    List_Mission.clear();
    List_Mission.addAll(Srv_DbTools.ListParam_ParamFam);
    List_MissionID.clear();
    List_MissionID.addAll(Srv_DbTools.ListParam_ParamFamID);

    selectedMission = List_Mission[0];
    selectedMissionID = List_MissionID[0];

    await Srv_DbTools.getInterMissionsIntervention(Srv_DbTools.gIntervention.InterventionId!);

    await Srv_DbTools.getInterMissionsIntervention(Srv_DbTools.gIntervention.InterventionId!);

    if (Srv_DbTools.ListInterMission.length > 0) {
      isSelect = true;
      wInterMission = Srv_DbTools.ListInterMission[0];
      crtDoc();
    }

    Reload();
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 600;
    double height = MediaQuery.of(context).size.height - 100;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      backgroundColor: gColors.white,
      surfaceTintColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20),
      title: Container(
          color: gColors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/images/IM4.png",
                  height: 32,
                  width: 32,
                ),
              ),
              Text(
                "Tâches & Ordes de missions",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
            ],
          )),
      content: Container(
        color: gColors.greyLight,
        child: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 1,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                          width: 560,
                          child: _buildText(context, wInterMission),
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    iPhotoDoc == 2 ? Container() : Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                          width: 560,
                          height: 245,
                          child: _buildNote(context, wInterMission),
                        ),
                      ],
                    ),
                    Container(
                      height: 5,
                    ),
                    Container(
                      height: iPhotoDoc == 1 ? 275 : 520,
                      child:
                      iPhotoDoc == 1 ? buildimage(context) : buildDoc(context),
                    ),
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          InkWell(
                            onTap: () async {
                              await HapticFeedback.vibrate();
                              iPhotoDoc = 1;
                              setState(() {});
                            },
                            child: Image.asset(
                              "assets/images/IM5b.png",
                              height: 50,
                              width: 50,
                            ),
                          ),

                          InkWell(
                            onTap: () async {
                              await HapticFeedback.vibrate();
                              iPhotoDoc = 2;
                              setState(() {});

                            },
                            child: Image.asset(
                              "assets/images/IM5.png",
                              height: 50,
                              width: 50,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: buildMissions(context)),
              Container(
                color: gColors.black,
                height: 1,
              ),
              Valider(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context, InterMission interMission) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tâche : ",
          style: gColors.bodySaisie_N_B,
        ),
        Text(
          interMission.InterMission_Nom,
          style: gColors.bodySaisie_B_B,
        ),
      ],
    );
  }

  Widget _buildNote(BuildContext context, InterMission interMission) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Note : ",
          style: gColors.bodySaisie_N_B,
        ),
        Text(
          interMission.InterMission_Note,
          maxLines: 15,
          style: gColors.bodySaisie_B_B,
        ),
      ],
    );
  }

  Widget InterMissionGridWidgetvp() {
    List<DaviColumn<InterMission>> wColumns = [
      DaviColumn(
          pinStatus: PinStatus.left,
          width: 50,
          cellBuilder: (BuildContext context, DaviRow<InterMission> aInterMission) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: aInterMission.data.InterMission_Exec,
              onChanged: (bool? value) async {
                aInterMission.data.InterMission_Exec = (value == true);
                await Srv_DbTools.setInterMission(aInterMission.data);
                setState(() {});
              },
            );
          }),
      new DaviColumn(name: 'Libellé', grow: 18, stringValue: (row) => row.InterMission_Nom),
    ];

    print("InterMissionGridWidget");
    DaviModel<InterMission>? _model;
    _model = DaviModel<InterMission>(rows: Srv_DbTools.ListInterMissionsearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<InterMission>(
          _model,
          visibleRowsCount: 10,
          onRowTap: (interMission) => _onRowTap(context, interMission),
        ),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.LinearGradient3, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          cell: CellThemeData(
            contentHeight: 44,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }

//**********************************
//**********************************
//**********************************

  void _onRowTap(BuildContext context, InterMission interMission) {
    setState(() {
      wInterMission = interMission;
      iPhotoDoc = 1;
      crtDoc();
    });
  }

//**********************************
//**********************************
//**********************************

  @override
  Widget buildMissions(BuildContext context) {
    List<Widget> RowSaisies = [];
    for (int i = 0; i < Srv_DbTools.ListInterMissionsearchresult.length; i++) {
      var element = Srv_DbTools.ListInterMissionsearchresult[i];
      RowSaisies.add(RowSaisie(element));
    }

    return
        //Expanded(child:
        Container(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                color: gColors.greyDark,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  color: gColors.greyLight,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    itemCount: RowSaisies.length,
                    itemBuilder: (context, index) {
                      return RowSaisies[index];
                    },
                    separatorBuilder: (BuildContext context, int index) => Container(height: 1, width: double.infinity, color: gColors.greyDark),
                  ),
                )))
        //)
        ;
  }

  Widget RowSaisie(InterMission interMission) {
    return Container(
        color: Colors.white,
        height: 45,
        child: InkWell(
          onTap: () async {
            setState(() {
              wInterMission = interMission;
              crtDoc();
            });
          },
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 20,
                  padding: EdgeInsets.fromLTRB(10, 2, 8, 0),
                  child: Text(
                    "${interMission.InterMission_Nom}",
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ),
              ),
              Row(
                children: [
                  BtnCard(interMission),
                ],
              ),
            ],
          ),
        ));
  }

  Widget BtnCard(InterMission interMission) {
    Color wColor = Colors.black;
    double IcoWidth = 40;
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: 45,
      child: Card(
        color: gColors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () async {
                  await HapticFeedback.vibrate();
                  interMission.InterMission_Exec = !interMission.InterMission_Exec;
                  await Srv_DbTools.setInterMission(interMission);
                  setState(() {});
                },
                child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Image.asset(
                      interMission.InterMission_Exec ? "assets/images/Plus_Sel.png" : "assets/images/Plus_No_Sel.png",
                      width: IcoWidth,
                      height: IcoWidth,
                    ))),
          ],
        ),
      ),
    );
  }

  Widget Valider(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//      width: 560,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Spacer(),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }

  void crtDoc() async {
    print("crtDoccrtDoccrtDoccrtDoccrtDoccrtDoccrtDoc"); // ${pic}");

    _images.clear();

    for (int i = 0; i < 5; i++) {
      String wUserImg = "Intervention_${Srv_DbTools.gIntervention.InterventionId}_${wInterMission.InterMissionId}_$i.jpg";
      print("  wUserImg ${wUserImg}");

      try {
        Uint8List? pic = await gColors.getImage(wUserImg);
        if (pic.length > 0) {
          print("pic ${pic.length}");
          _images.add(pic!);
        }
      } catch (e) {
        print("ERROR ${wUserImg}");
      }
    }

    wWidgetPdf = Container();
    wPdf = Container();


    listPdf.clear();

    await Srv_DbTools.getInterMissions_Document_MissonID(wInterMission.InterMissionId);

    for (int i = 0; i < Srv_DbTools.ListInterMissions_Document.length; i++) {
      var interMissions_Document = Srv_DbTools.ListInterMissions_Document[i];
      print("•••••• ListInterMissions_Document ${interMissions_Document.toJson()} ");
      Widget wWidget = await getDdoc(interMissions_Document.DocNom!);
      listPdf.add(wWidget);
    }




    setState(() {});
  }

  Future<Widget> getDdoc(String wName) async {
    Widget wWidget = Container();
    String wDocPath = "${wName}";
    if (wDocPath.toLowerCase().contains(".txt")) {
      Uint8List? _bytes = await gColors.getDoc(wDocPath);
      print("wDocPath $wDocPath length ${_bytes.length}");

      wWidget = Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            width: 500,
            height: 440,
            color: Colors.white,
            child: Text(
              "${utf8.decode(_bytes)}",
              style: gColors.bodyTitle1_N_Gr,
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.red, "ico_Del", ToolsBarDelete, tooltip: "Suppression"),
              ),
            ],
          )
        ],
      );
    } else {
      Uint8List? _bytes = await gColors.getDoc(wDocPath);
      print("wDocPath $wDocPath length ${_bytes.length}");
      if (_bytes.length > 0) {
        wSfPdfViewer = await SfPdfViewer.memory(
          controller: wPdfViewerController,
          initialZoomLevel: 1,
          maxZoomLevel: 12,
          _bytes,
//          key: _pdfViewerKey,
          enableDocumentLinkAnnotation: false,
          enableTextSelection: false,
          interactionMode: PdfInteractionMode.pan,
        );

        wWidget = Column(
          children: [
            Container(
              color: Colors.white,
              width: 500,
              height: 440,
              child: wSfPdfViewer,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(pdf: wSfPdfViewer)));
                    Reload();
                  },
                  icon: Icon(Icons.open_with, color: Colors.green),
                ),

              ],
            )
          ],
        );
      }
    }

    return wWidget;
  }


  Widget buildimage(BuildContext context) {
    double wSize = 170;
    double wWidth = 560;

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _images.isEmpty
            ? Container(
                width: wWidth,
                height: wSize,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                child: Center(child: Text("Pas de photo")))
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.LinearGradient3, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                width: wWidth,
                height: wSize,
//                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
//                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(_images.length, (index) {
                    return Stack(
                      key: ValueKey(index),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: InkWell(
                            onTap: () async {
                              await HapticFeedback.vibrate();
                            },
                            child: Image.memory(_images[index], width: wSize, height: wSize, fit: BoxFit.contain),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
        Container(
          height: 20,
        ),
      ],
    ));
  }

  Widget buildDoc(BuildContext context) {
    double wSize = 500;
    double wWidth = 560;

    print("buildDoc");
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _images.isEmpty
                ? Container(
                width: wWidth,
                height: wSize,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                child: Center(child: Text("Pas de document")))
                : Container(
              decoration: BoxDecoration(
                border: Border.all(color: gColors.LinearGradient3, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
                color: gColors.white,
              ),
              width: wWidth,
              height: wSize,
//                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
//                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(listPdf.length, (index) {
                  return Stack(
                    key: ValueKey(index),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                          },
                          child: listPdf[index],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            Container(
              height: 20,
            ),
          ],
        ));
  }



}
