import 'package:verifplus/Tools/DbSrv/Srv_Clients.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';

class Srv_ImportExport {
  Srv_ImportExport();

  static Future<bool> ImportClient() async {
    bool wResult = await Srv_DbTools.getClientAll();
    print("ImportClient wResult ${wResult}");
    if (wResult) {
      await DbTools.TrunckClients();
      for (int i = 0; i < Srv_DbTools.ListClient.length; i++) {
        Client wClient = Srv_DbTools.ListClient[i];
        await DbTools.inserClients(wClient);
      }
      Srv_DbTools.ListClient = await DbTools.getClients();
      print("Import_DataDialog ON LINE Srv_DbTools.ListClient ${Srv_DbTools.ListClient}");
      return true;
    }
    Srv_DbTools.ListClient = await DbTools.getClients();
    print("Import_DataDialog OFF LINE Srv_DbTools.ListClient ${Srv_DbTools.ListClient}");
    return false;
  }
}
