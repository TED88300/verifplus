import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Desc.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    int wSec = 1;
    String sSec = "${DbTools.gParc_Ent.Parcs_Intervention_Timer}";
    if (sSec.compareTo("null") != 0) {
      count = DbTools.gParc_Ent.Parcs_Intervention_Timer!;
    }

    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (!DbTools.gTED)
        setState(() {
          count++;
          DbTools.gParc_Ent.Parcs_Intervention_Timer = count;
          DbTools.updateParc_Ent_Timer(DbTools.gParc_Ent.ParcsId!, count);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }



  @override
  Widget build(BuildContext context) {
    final now = Duration(seconds: count);
    return Text("${gObj.printDuration(now)}");
  }
}
