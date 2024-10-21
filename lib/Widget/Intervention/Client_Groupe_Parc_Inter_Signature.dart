import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';

import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';
import 'package:verifplus/pdf/Aff_Bdc.dart';
import 'package:verifplus/pdf/Aff_CR.dart';
import 'package:verifplus/pdf/Aff_CR_Ria.dart';

class Client_Groupe_Parc_Inter_Signature extends StatefulWidget {
  final VoidCallback onMaj;
  final String x_t;
  const Client_Groupe_Parc_Inter_Signature({Key? key, required this.onMaj, required this.x_t}) : super(key: key);
  @override
  Client_Groupe_Parc_Inter_SignatureState createState() => Client_Groupe_Parc_Inter_SignatureState();
}

class Client_Groupe_Parc_Inter_SignatureState extends State<Client_Groupe_Parc_Inter_Signature> {
  double IcoWidth = 30;

  final control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

  final controlTech = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  ValueNotifier<ByteData?> rawImageFitTech = ValueNotifier<ByteData?>(null);

  bool SignTechOpen = false;
  bool SignClientOpen = false;

  @override
  Future initLib() async {
    print("initLib");
    setState(() {});
  }

  TextEditingController ctrlTech = new TextEditingController();
  TextEditingController ctrlClient = new TextEditingController();
  TextEditingController ctrlNote = new TextEditingController();

  int SatClient = 0;

  void initState() {
    ctrlTech.text = Srv_DbTools.gIntervention.Intervention_Signataire_Tech;
    ctrlClient.text = Srv_DbTools.gIntervention.Intervention_Signataire_Client;
    ctrlNote.text = Srv_DbTools.gIntervention.Intervention_Remarque;
    SatClient = Srv_DbTools.gIntervention.Intervention_Sat;

    initLib();
    super.initState();
  }

  void onSaisie() async {
    widget.onMaj();
    await initLib();
  }

  @override
  Widget build(BuildContext context) {
    print("build BL $SignTechOpen");
    Srv_DbTools.getParam_Saisie_ParamMem("Fact");

    String wTitre2 = "${Srv_DbTools.gIntervention.Groupe_Nom} / ${Srv_DbTools.gIntervention.Site_Nom} / ${Srv_DbTools.gIntervention.Zone_Nom}";
    if (Srv_DbTools.gIntervention.Groupe_Nom == Srv_DbTools.gIntervention.Site_Nom) wTitre2 = "";

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 55),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new ElevatedButton(
                onPressed: () async {
                  await HapticFeedback.vibrate();
                  if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ext") await Navigator.push(context, MaterialPageRoute(builder: (context) => Aff_CR()));
                  if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ria") await Navigator.push(context, MaterialPageRoute(builder: (context) => Aff_CR_Ria()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primaryGreen,
                    side: const BorderSide(
                      width: 1.0,
                      color: gColors.primaryGreen,
                    )),
                child: Text('Imprimer', style: gColors.bodyTitle1_B_W),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
//        padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gObj.InterventionTitleWidget("${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2: wTitre2, wTimer: 0),
                gColors.wLigne(),
                buildTitreTech(context),
                gColors.wLigne(),
                _buildVueSignTech(),
                buildTitreClient(context),
                gColors.wLigne(),
                _buildVueSign(),
                buildTitreNote(context),
                _buildNote(),
                buildTitreSat(context),
                buildSat(),
              ],
            )),
      ),
    );
  }

  Widget _buildSign() => Container(
      color: gColors.greyLight,
      height : 500,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Signataire : ',
                style: gColors.bodyTitle1_N_Gr,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TextField(
                    controller: ctrlClient,
                    style: gColors.bodyTitle1_N_Gr,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 3),
                    ),
                    onChanged: (String value) async {
                      Srv_DbTools.gIntervention.Intervention_Signataire_Client = value;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 2.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints.expand(),
                    color: Colors.white,
                    child: HandSignature(
                      control: control,
                      type: SignatureDrawType.shape,
                    ),
                  ),
                  CustomPaint(
                    painter: DebugSignaturePainterCP(
                      control: control,
                      cp: false,
                      cpStart: false,
                      cpEnd: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  control.clear();
                  rawImageFit.value = null;
                },
                child: Text('clear'),
              ),
              SizedBox(
                width: 80.0,
              ),
              _buildScaledImageView(),
              SizedBox(
                width: 80.0,
              ),
              new ElevatedButton(
                onPressed: () async {
                  rawImageFit.value = await control.toImage(
                    color: Colors.black,
                    background: Colors.white,
                    fit: true,
                  );

                  final json = control.toMap();
                  print("Client rawImageFit.value ${json} ${rawImageFit.value}");

                  if (rawImageFit.value != null) {
                    print("SET Intervention_Signature_Client");
                    Srv_DbTools.gIntervention.Intervention_Signature_Client = rawImageFit.value!.buffer.asUint8List();
                  }
                  var now = new DateTime.now();
                  var formatter = new DateFormat('dd/MM/yyyy');
                  String formattedDate = formatter.format(now);
                  Srv_DbTools.gIntervention.Intervention_Signataire_Date_Client = formattedDate;

                  await DbTools.updateInterventions(Srv_DbTools.gIntervention);
                  bool wRes = await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);
                  Srv_DbTools.gIntervention.Intervention_isUpdate = wRes;
                  if (!wRes) DbTools.setBoolErrorSync(true);
                  await DbTools.updateInterventions(Srv_DbTools.gIntervention);

                  setState(() {});
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
          SizedBox(
            height: 16.0,
          ),
          gColors.wLigne(),
        ],
      ));

  Widget _buildNote() => Container(
      color: Colors.grey,
      padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Note : ',
                style: gColors.bodyTitle1_N_Gr,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TextField(
                    scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 200),
                    controller: ctrlNote,
                    minLines: 7,
                    maxLines: 7,
                    style: gColors.bodyTitle1_N_Gr,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 3),
                    ),
                    onChanged: (String value) async {
                      Srv_DbTools.gIntervention.Intervention_Remarque = value;
                      await DbTools.updateInterventions(Srv_DbTools.gIntervention);
                      bool wRes = await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);
                      Srv_DbTools.gIntervention.Intervention_isUpdate = wRes;
                      if (!wRes) DbTools.setBoolErrorSync(true);
                      await DbTools.updateInterventions(Srv_DbTools.gIntervention);

                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          gColors.wLigne(),
        ],
      ));



  Widget _buildVueSign() {
    return
      InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
              backgroundColor: gColors.greyLight,
              content: _buildSign(),
            ),
          );
        },
        child:    Container(
            color: Colors.black12,
            padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Spacer(),
                    _buildScaledImageView(),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                gColors.wLigne(),
              ],
            )),
      );
  }




  Widget _buildVueSignTech() {
    return
      InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
              backgroundColor: gColors.greyLight,
              content: _buildSignTech(),
            ),
          );
        },
        child:     Container(
            color: Colors.black12,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Spacer(),
                    _buildScaledImageViewTech(),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                gColors.wLigne(),
              ],
            )),
      );
  }

  Widget _buildSignTech() => Container(
      color: gColors.greyLight,
      height : 500,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Signataire : ',
                style: gColors.bodyTitle1_N_Gr,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TextField(
                    controller: ctrlTech,
                    style: gColors.bodyTitle1_N_Gr,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 3),
                    ),
                    onChanged: (String value) async {
                      Srv_DbTools.gIntervention.Intervention_Signataire_Tech = value;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: Center(
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(),
                      color: Colors.white,
                      child: HandSignature(
                        control: controlTech,
                        type: SignatureDrawType.shape,
                      ),
                    ),
                    CustomPaint(
                      painter: DebugSignaturePainterCP(
                        control: controlTech,
                        cp: false,
                        cpStart: false,
                        cpEnd: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[

              ElevatedButton(
                onPressed: () {
                  controlTech.clear();
                  rawImageFitTech.value = null;
                },
                child: Text('clear'),
              ),
              SizedBox(
                width: 80.0,
              ),
              _buildScaledImageViewTech(),
              SizedBox(
                width: 80.0,
              ),
              new ElevatedButton(
                onPressed: () async {
                  rawImageFitTech.value = await controlTech.toImage(
                    color: Colors.black,
                    background: Colors.white,
                    fit: true,
                  );

                  final json = controlTech.toMap();

                  if (rawImageFitTech.value != null) {
                    print("json ${rawImageFitTech.value!.buffer.asUint8List()}");
                    Srv_DbTools.gIntervention.Intervention_Signature_Tech = rawImageFitTech.value!.buffer.asUint8List();
                  }
                  var now = new DateTime.now();
                  var formatter = new DateFormat('dd/MM/yyyy');
                  String formattedDate = formatter.format(now);
                  Srv_DbTools.gIntervention.Intervention_Signataire_Date = formattedDate;
                  await DbTools.updateInterventions(Srv_DbTools.gIntervention);
                  bool wRes = await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);
                  Srv_DbTools.gIntervention.Intervention_isUpdate = wRes;
                  if (!wRes) DbTools.setBoolErrorSync(true);
                  await DbTools.updateInterventions(Srv_DbTools.gIntervention);
                  setState(() {});
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
          SizedBox(
            height: 16.0,
          ),

        ],
      ));

  Widget _buildScaledImageView() => Container(
        width: 192.0,
        height: 96.0,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white30,
        ),
        child: Srv_DbTools.gIntervention.Intervention_Signature_Client == null || Srv_DbTools.gIntervention.Intervention_Signature_Client.length == 0
            ? Container(
                color: Colors.white,
                child: Center(
                  child: Text('Vide'),
                ),
              )
            : Container(
                padding: EdgeInsets.all(0.0),
                color: Colors.white,
                child: Image.memory(Srv_DbTools.gIntervention.Intervention_Signature_Client),
              ),
      );

  Widget _buildScaledImageViewTech() => Container(
        width: 192.0,
        height: 96.0,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white30,
        ),
        child: Srv_DbTools.gIntervention.Intervention_Signature_Tech == null || Srv_DbTools.gIntervention.Intervention_Signature_Tech.length == 0
            ? Container(
                color: Colors.white,
                child: Center(
                  child: Text('Vide'),
                ),
              )
            : Container(
                padding: EdgeInsets.all(0.0),
                color: Colors.white,
                child: Image.memory(Srv_DbTools.gIntervention.Intervention_Signature_Tech),
              ),
      );


  Widget buildTitreTech(BuildContext context) {
    double IcoWidth = 30;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Icon_Cont.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Signature Agent",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),
          Spacer(),
          Expanded(
            child: InkWell(
              onTap: () async {
                await HapticFeedback.vibrate();
                SignTechOpen = !SignTechOpen;
                if (SignTechOpen) SignClientOpen = false;
                setState(() {});
              },
              child: Text(
                textAlign: TextAlign.right,
                "${Srv_DbTools.gIntervention.Intervention_Signataire_Tech} - ${Srv_DbTools.gIntervention.Intervention_Signataire_Date} >",
                style: gColors.bodyTitle1_B_Green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitreClient(BuildContext context) {
    double IcoWidth = 30;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Icon_Cont_2.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Signature Client",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),
          Spacer(),
          Expanded(
            child: InkWell(
              onTap: () async {
                await HapticFeedback.vibrate();
                SignClientOpen = !SignClientOpen;
                if (SignClientOpen) SignTechOpen = false;
                setState(() {});
              },
              child: Text(
                textAlign: TextAlign.right,
                "${Srv_DbTools.gIntervention.Intervention_Signataire_Client} - ${Srv_DbTools.gIntervention.Intervention_Signataire_Date_Client} >",
                style: gColors.bodyTitle1_B_Green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitreNote(BuildContext context) {
    double IcoWidth = 30;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Icon_Note2.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Note",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitreSat(BuildContext context) {
    double IcoWidth = 30;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.white,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Icon_Sat.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Satisfaction client",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSat() {
    double IcoWidth = 80;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              SatClient = 1;
              Srv_DbTools.gIntervention.Intervention_Sat = SatClient;
              await DbTools.updateInterventions(Srv_DbTools.gIntervention);
              bool wRes = await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);
              Srv_DbTools.gIntervention.Intervention_isUpdate = wRes;
              if (!wRes) DbTools.setBoolErrorSync(true);
              await DbTools.updateInterventions(Srv_DbTools.gIntervention);
              setState(() {});
            },
            child: Image.asset(
              SatClient == 1 ? "assets/images/Sat_A.png" : "assets/images/Sat_Ans.png",
              height: IcoWidth,
              width: IcoWidth,
            ),
          ),
          Container(
            width: 10,
          ),
          InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              SatClient = 2;
              Srv_DbTools.gIntervention.Intervention_Sat = SatClient;
              await DbTools.updateInterventions(Srv_DbTools.gIntervention);
              bool wRes = await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);
              Srv_DbTools.gIntervention.Intervention_isUpdate = wRes;
              if (!wRes) DbTools.setBoolErrorSync(true);
              await DbTools.updateInterventions(Srv_DbTools.gIntervention);
              setState(() {});
            },
            child: Image.asset(
              SatClient == 2 ? "assets/images/Sat_B.png" : "assets/images/Sat_Bns.png",
              height: IcoWidth,
              width: IcoWidth,
            ),
          ),
          Container(
            width: 10,
          ),
          InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              SatClient = 3;
              Srv_DbTools.gIntervention.Intervention_Sat = SatClient;
              await DbTools.updateInterventions(Srv_DbTools.gIntervention);
              bool wRes = await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);
              Srv_DbTools.gIntervention.Intervention_isUpdate = wRes;
              if (!wRes) DbTools.setBoolErrorSync(true);
              await DbTools.updateInterventions(Srv_DbTools.gIntervention);
              setState(() {});
            },
            child: Image.asset(
              SatClient == 3 ? "assets/images/Sat_C.png" : "assets/images/Sat_Cns.png",
              height: IcoWidth,
              width: IcoWidth,
            ),
          ),
          Container(
            width: 10,
          ),
        ],
      ),
    );
  }
}
