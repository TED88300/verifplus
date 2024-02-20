
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';



class P_Synthese extends StatefulWidget {

  @override
  P_SyntheseState createState() => P_SyntheseState();
}

class P_SyntheseState extends State<P_Synthese> {

  @override
  void initLib() async {
  }




  void initState() {
    print("P_Synthese initState");
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),

      color: gColors.white,
      child:  Column(
        children: <Widget>[
          SizedBox(height: 8.0),


          Spacer(),


          SizedBox(height: 8.0),
          Row(
            children: [

              Spacer(),
              Text(DbTools.gVersion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  )),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }




}