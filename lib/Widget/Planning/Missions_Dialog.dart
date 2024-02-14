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

  Widget wWidgetPdf = Container();
  Widget wPdf = Container();
  Uint8List pic = Uint8List.fromList([0]);
  Image wImage = Image(
    image: AssetImage('assets/images/Avatar.png'),
    height: 0,
  );

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
    InterMission_TextController.text = wInterMission.InterMission_Nom;

    await Srv_DbTools.getInterMissionsIntervention(Srv_DbTools.gIntervention.InterventionId!);

    if (Srv_DbTools.ListInterMission.length > 0) {
      isSelect = true;
      wInterMission = Srv_DbTools.ListInterMission[0];
      InterMission_TextController.text = wInterMission.InterMission_Nom;
      InterMission_NoteController.text = wInterMission.InterMission_Note;
      builddoc();
    }

    InterMission_TextController.text = wInterMission.InterMission_Nom;
    InterMission_NoteController.text = wInterMission.InterMission_Note;
    Reload();
  }

  void initState() {
    initLib();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double width = 600;
    double height = 580; //MediaQuery.of(context).size.height - 200;

    print("build InterMission_TextController.text ${InterMission_TextController.text}");

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      backgroundColor: gColors.white,


      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20),

      title: Container(
          color: gColors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Column(
            children: [
              Text(
                "Intervention / Missions",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
            ],
          )),
      content:
      Container(
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
                          width: 560,
                          child: _buildFieldText(context, wInterMission),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 1,
                        ),
                        Container(
                          width: 560,
                          child: _buildFieldNote(context, wInterMission),
                        ),
                      ],
                    ),
                    Container(
                      height: 5,
                    ),
                    Container(
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          wImage,
                          wWidgetPdf,
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

  final InterMission_NoteController = TextEditingController();
  Widget _buildFieldNote(BuildContext context, InterMission interMission) {
    return TextFormField(
      controller: InterMission_NoteController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final InterMission_TextController = TextEditingController();
  Widget _buildFieldText(BuildContext context, InterMission interMission) {
    print("_buildFieldText ${interMission.InterMission_Nom} ${wInterMission.InterMission_Nom}");
    print("_buildFieldText InterMission_TextController.text ${InterMission_TextController.text}");

    return TextFormField(
      controller: InterMission_TextController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
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
      InterMission_TextController.text = interMission.InterMission_Nom;
      InterMission_NoteController.text = wInterMission.InterMission_Note;
      builddoc();
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
//          width: 640,
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
        color:  Colors.white,
        height: 45,
        child: InkWell(
          onTap: () async {

            setState(() {
              wInterMission = interMission;
              InterMission_TextController.text = interMission.InterMission_Nom;
              InterMission_NoteController.text = wInterMission.InterMission_Note;
              builddoc();
            });



          },
          child: Row(
            children: [


              Expanded(
                  child:
                  Container(

                height: 20,
                padding: EdgeInsets.fromLTRB(10, 2, 8, 0),
                child: Text(
                  "${interMission.InterMission_Nom}",
                  style:  gColors.bodyTitle1_B_Gr,
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
                  setState(() {

                  });
                },
                child:
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Image.asset(
                      interMission.InterMission_Exec ? "assets/images/Plus_Sel.png" : "assets/images/Plus_No_Sel.png",
                      width: IcoWidth,
                      height: IcoWidth,
                    ))

            ),
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

  void builddoc() async {
    print("builddocbuilddocbuilddocbuilddocbuilddocbuilddocbuilddoc"); // ${pic}");

    String wUserImg = "Mission_${wInterMission.InterMissionId}.jpg";
    pic = await gColors.getImage(wUserImg);

    print("wUserImg $wUserImg length ${pic.length}");
    if (pic.length > 0) {
      wImage = Image.memory(
        pic,
        fit: BoxFit.scaleDown,
        width: 200,
        height: 200,
      );
    } else {
      wImage = Image(
        image: AssetImage('assets/images/Avatar.png'),
        height: 0,
      );
    }

    wWidgetPdf = Container();
    wPdf = Container();

    String wDocPath = "Mission_${wInterMission.InterMissionId}_Doc.pdf";

    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
    Uint8List? _bytes = await gColors.getImage(wDocPath);

    print("wDocPath $wDocPath length ${_bytes.length}");

    print("_bytes length ${_bytes.length}");
    if (_bytes.length > 0) {
      wPdf = Stack(
        children: [
          SfPdfViewer.memory(
            _bytes,
            key: _pdfViewerKey,
            enableDocumentLinkAnnotation: false,
            enableTextSelection: false,
            interactionMode: PdfInteractionMode.pan,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent, //to listen for tap events on an empty container

            onTap: () async {
              print("onTaponTaponTaponTaponTaponTaponTaponTaponTaponTaponTaponTaponTap");
              await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(pdf: wPdf)));
              builddoc();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          )
        ],
      );

      wWidgetPdf = Container(
        width: 200,
        height: 200,
        child: wPdf,
      );
    }
    setState(() {});
  }


}
