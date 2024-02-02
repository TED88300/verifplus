
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';



class P_Notifications extends StatefulWidget {

  @override
  P_NotificationsState createState() => P_NotificationsState();
}

class P_NotificationsState extends State<P_Notifications> {

  @override
  void initLib() async {

    DbTools.glfClients = await DbTools.getClients();

    print("glfClients liste Nom ${DbTools.glfClients.length}");
    DbTools.glfClients.forEach((element) async {
      print("glfClients Nom ${element.Clients_Nom}");
    });

  }




  void initState() {
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