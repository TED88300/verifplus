
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';



class P_Notifications extends StatefulWidget {
  const P_Notifications({super.key});


  @override
  P_NotificationsState createState() => P_NotificationsState();
}

class P_NotificationsState extends State<P_Notifications> {

  @override
  void initLib() async {


  }




  @override
  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),

      color: gColors.white,
      child:  Column(
        children: <Widget>[
          const SizedBox(height: 8.0),


          const Spacer(),


          const SizedBox(height: 8.0),
          Row(
            children: [

              const Spacer(),
              Text(DbTools.gVersion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                  )),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }




}