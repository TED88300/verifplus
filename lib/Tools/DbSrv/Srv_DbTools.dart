import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Adresses.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Link_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Link_Verif_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Contacts.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Det.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Groupes.dart';
import 'package:verifplus/Tools/DbSrv/Srv_InterMissions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_InterMissions_Document.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Av.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Art.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Ent.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Imgs.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Planning.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Planning_Interv.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Planning_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User_Desc.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User_Hab.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Zones.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Img.dart';
import 'package:verifplus/Tools/shared_pref.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

import 'Srv_Clients.dart';

class Notif with ChangeNotifier {
  Notif();
  void BroadCast() {
    print("&&&&&&&&&&&&&&&&&&&& Notif BroadCast");
    notifyListeners();
  }
}

class Srv_DbTools {
  Srv_DbTools();

  static var notif = Notif();

//  static String Url = "217.160.250.97";
  static String Url = "verifplus.net";

  static int gLastID = 0;
  static int gLastIDObj = 0;

  static String SrvUrl = "https://$Url/API_VERIFPLUS.php";
  static String SrvImg = "http://$Url/Img/";
  static String SrvTokenKey = "WqXs35Xs";
  static String SrvToken = "";

  static String Token_FBM = "";

  static String wImgPathAvatar = "";

  static String simCountryCode = "";




  static List<String> List_UserInter = [];
  static List<String> List_UserInterID = [];

  //******************************************
  //************   RIA_Gammes   ************
  //******************************************

  static List<RIA_Gammes> ListRIA_Gammes = [];
  static List<RIA_Gammes> ListRIA_Gammessearchresult = [];
  static RIA_Gammes gRIA_Gammes = RIA_Gammes.RIA_GammesInit();

  static Future<bool> IMPORT_Srv_RIA_Gammes() async {
    String wSlq = "select * from RIA_Gammes ORDER BY RIA_GammesId";
    print("IMPORT_Srv_RIA_Gammes " + wSlq);

    try {
      ListRIA_Gammes = await getRIA_Gammes_API_Post("select", wSlq);
      if (ListRIA_Gammes == null) return false;
      if (ListRIA_Gammes.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<RIA_Gammes>> getRIA_Gammes_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getRIA_Gammes_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    print("getRIA_Gammes_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<RIA_Gammes> RIA_GammesList = await items.map<RIA_Gammes>((json) {
          return RIA_Gammes.fromJson(json);
        }).toList();
        return RIA_GammesList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  
  
  
  //******************************************
  //************   NF074_Gammes   ************
  //******************************************

  static List<NF074_Gammes> ListNF074_Gammes = [];
  static List<NF074_Gammes> ListNF074_Gammessearchresult = [];
  static NF074_Gammes gNF074_Gammes = NF074_Gammes.NF074_GammesInit();

  static Future<bool> IMPORT_Srv_NF074_Gammes() async {
    String wSlq = "select * from NF074_Gammes ORDER BY NF074_GammesId";
    try {
      ListNF074_Gammes = await getNF074_Gammes_API_Post("select", wSlq);
      if (ListNF074_Gammes == null) return false;
      if (ListNF074_Gammes.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<NF074_Gammes>> getNF074_Gammes_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    //print("getNF074_Gammes_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    //print("getNF074_Gammes_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<NF074_Gammes> NF074_GammesList = await items.map<NF074_Gammes>((json) {
          return NF074_Gammes.fromJson(json);
        }).toList();
        return NF074_GammesList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   NF074_Histo_Normes   ************
  //******************************************

  static List<NF074_Histo_Normes> ListNF074_Histo_Normes = [];
  static List<NF074_Histo_Normes> ListNF074_Histo_Normessearchresult = [];
  static NF074_Histo_Normes gNF074_Histo_Normes = NF074_Histo_Normes.NF074_Histo_NormesInit();

  static Future<bool> IMPORT_Srv_NF074_Histo_Normes() async {
    String wSlq = "select * from NF074_Histo_Normes ORDER BY NF074_Histo_NormesId";
    try {
      ListNF074_Histo_Normes = await getNF074_Histo_Normes_API_Post("select", wSlq);
      if (ListNF074_Histo_Normes == null) return false;
      if (ListNF074_Histo_Normes.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<NF074_Histo_Normes>> getNF074_Histo_Normes_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    //print("getNF074_Histo_Normes_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    //print("getNF074_Histo_Normes_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<NF074_Histo_Normes> NF074_Histo_NormesList = await items.map<NF074_Histo_Normes>((json) {
          return NF074_Histo_Normes.fromJson(json);
        }).toList();
        return NF074_Histo_NormesList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   NF074_Pieces_Det   ********
  //******************************************

  static List<NF074_Pieces_Det> ListNF074_Pieces_Det = [];
  static List<NF074_Pieces_Det> ListNF074_Pieces_Detsearchresult = [];
  static NF074_Pieces_Det gNF074_Pieces_Det = NF074_Pieces_Det.NF074_Pieces_DetInit();

  static Future<bool> IMPORT_Srv_NF074_Pieces_Det() async {
    String wSlq = "select * from NF074_Pieces_Det ORDER BY NF074_Pieces_DetId";
    try {
      ListNF074_Pieces_Det = await getNF074_Pieces_Det_API_Post("select", wSlq);
      if (ListNF074_Pieces_Det == null) return false;
      if (ListNF074_Pieces_Det.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<NF074_Pieces_Det>> getNF074_Pieces_Det_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    //print("getNF074_Pieces_Det_API_Post " + aSQL);
    http.StreamedResponse response = await request.send();
    //print("getNF074_Pieces_Det_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<NF074_Pieces_Det> NF074_Pieces_DetList = await items.map<NF074_Pieces_Det>((json) {
          return NF074_Pieces_Det.fromJson(json);
        }).toList();
        return NF074_Pieces_DetList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   NF074_Pieces_Det_Inc   ****
  //******************************************

  static List<NF074_Pieces_Det_Inc> ListNF074_Pieces_Det_Inc = [];
  static List<NF074_Pieces_Det_Inc> ListNF074_Pieces_Det_Incsearchresult = [];
  static NF074_Pieces_Det_Inc gNF074_Pieces_Det_Inc = NF074_Pieces_Det_Inc.NF074_Pieces_Det_IncInit();

  static Future<bool> IMPORT_Srv_NF074_Pieces_Det_Inc() async {
    String wSlq = "select * from NF074_Pieces_Det_Inc ORDER BY NF074_Pieces_Det_IncId";
    try {
      ListNF074_Pieces_Det_Inc = await getNF074_Pieces_Det_Inc_API_Post("select", wSlq);
      if (ListNF074_Pieces_Det_Inc == null) return false;
      if (ListNF074_Pieces_Det_Inc.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<NF074_Pieces_Det_Inc>> getNF074_Pieces_Det_Inc_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    //print("getNF074_Pieces_Det_Inc_API_Post " + aSQL);
    http.StreamedResponse response = await request.send();
    //print("getNF074_Pieces_Det_Inc_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<NF074_Pieces_Det_Inc> NF074_Pieces_Det_IncList = await items.map<NF074_Pieces_Det_Inc>((json) {
          return NF074_Pieces_Det_Inc.fromJson(json);
        }).toList();
        return NF074_Pieces_Det_IncList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   NF074_Mixte_Produit   ****
  //******************************************

  static List<NF074_Mixte_Produit> ListNF074_Mixte_Produit = [];
  static List<NF074_Mixte_Produit> ListNF074_Mixte_Produitsearchresult = [];
  static NF074_Mixte_Produit gNF074_Mixte_Produit = NF074_Mixte_Produit.NF074_Mixte_ProduitInit();

  static Future<bool> IMPORT_Srv_NF074_Mixte_Produit() async {
    String wSlq = "select * from NF074_Mixte_Produit ORDER BY NF074_Mixte_ProduitId";
    try {
      ListNF074_Mixte_Produit = await getNF074_Mixte_Produit_API_Post("select", wSlq);
      if (ListNF074_Mixte_Produit == null) return false;
      if (ListNF074_Mixte_Produit.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<NF074_Mixte_Produit>> getNF074_Mixte_Produit_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    //print("getNF074_Mixte_Produit_API_Post " + aSQL);
    http.StreamedResponse response = await request.send();
    //print("getNF074_Mixte_Produit_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<NF074_Mixte_Produit> NF074_Mixte_ProduitList = await items.map<NF074_Mixte_Produit>((json) {
          return NF074_Mixte_Produit.fromJson(json);
        }).toList();
        return NF074_Mixte_ProduitList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   NF074_Pieces_Actions   ****
  //******************************************

  static List<NF074_Pieces_Actions> ListNF074_Pieces_Actions = [];
  static List<NF074_Pieces_Actions> ListNF074_Pieces_Actionssearchresult = [];
  static NF074_Pieces_Actions gNF074_Pieces_Actions = NF074_Pieces_Actions.NF074_Pieces_ActionsInit();

  static Future<bool> IMPORT_Srv_NF074_Pieces_Actions() async {
    String wSlq = "select * from NF074_Pieces_Actions ORDER BY NF074_Pieces_ActionsId";
    try {
      ListNF074_Pieces_Actions = await getNF074_Pieces_Actions_API_Post("select", wSlq);
      if (ListNF074_Pieces_Actions == null) return false;
      if (ListNF074_Pieces_Actions.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<NF074_Pieces_Actions>> getNF074_Pieces_Actions_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    //print("getNF074_Pieces_Actions_API_Post " + aSQL);
    http.StreamedResponse response = await request.send();
    //print("getNF074_Pieces_Actions_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<NF074_Pieces_Actions> NF074_Pieces_ActionsList = await items.map<NF074_Pieces_Actions>((json) {
          return NF074_Pieces_Actions.fromJson(json);
        }).toList();
        return NF074_Pieces_ActionsList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Article_Ebp> ListArticle_Ebp = [];
  static List<Article_Ebp> ListArticle_Ebp_ES = [];
  static List<Article_Ebp> ListArticle_Ebpsearchresult = [];
  static Article_Ebp gArticle_Ebp = Article_Ebp.Article_EbpInit();
  static Article_Ebp gArticle_EbpEnt = Article_Ebp.Article_EbpInit();
  static Article_Ebp gArticle_EbpSelRef = Article_Ebp.Article_EbpInit();

  static Article_Ebp IMPORT_Article_Ebp(String Article_codeArticle) {
    Article_Ebp wArticle_Ebp = Article_Ebp.Article_EbpInit();
    Srv_DbTools.ListArticle_Ebp.forEach((zArticle_Ebp) {
      if (zArticle_Ebp.Article_codeArticle.compareTo(Article_codeArticle) == 0) {
        wArticle_Ebp = zArticle_Ebp;
        return;
      }
    });
    return wArticle_Ebp;
  }

  static Future<bool> IMPORT_Article_EbpAll() async {
    String wSlq = "select * from Articles_Ebp ORDER BY Article_codeArticle";
    try {
      ListArticle_Ebp = await getArticle_Ebp_API_Post("select", wSlq);
      if (ListArticle_Ebp == null) return false;
      if (ListArticle_Ebp.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> IMPORT_Article_Ebp_ES() async {


//    String wSlq = "SELECT Articles_Ebp.* FROM Articles_Ebp, Articles_Fam_Grp_Ebp where Articles_Fam_Grp_Code_Fam = Article_codeFamilleArticles AND Articles_Fam_Grp_Grp = '01 - EXTINCTION' ORDER BY Article_codeArticle";
    String wSlq = "SELECT Articles_Ebp.* FROM Articles_Ebp where Article_codeFamilleArticles = '1'";

print("IMPORT_Article_Ebp_ES ${wSlq}");

    try {
      ListArticle_Ebp_ES = await getArticle_Ebp_API_Post("select", wSlq);
      if (ListArticle_Ebp_ES == null) return false;
      if (ListArticle_Ebp_ES.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Article_Ebp>> getArticle_Ebp_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Article_Ebp> Article_EbpList = await items.map<Article_Ebp>((json) {
          return Article_Ebp.fromJson(json);
        }).toList();
        return Article_EbpList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Article_Fam_Ebp> ListArticle_Fam_Ebp = [];

  static List<Article_Fam_Ebp> ListArticle_Fam_Ebp_Fam = [];

  static List<Article_Fam_Ebp> ListArticle_Fam_Ebpsearchresult = [];
  static Article_Fam_Ebp gArticle_Fam_Ebp = Article_Fam_Ebp.Article_Fam_EbpInit();

  static Future<bool> IMPORT_Article_Fam_EbpAll() async {
    String wSlq = "select * from Articles_Fam_Ebp ORDER BY Article_Fam_Libelle";
    try {
      ListArticle_Fam_Ebp = await getArticle_Fam_Ebp_API_Post("select", wSlq);
      if (ListArticle_Fam_Ebp == null) return false;
      if (ListArticle_Fam_Ebp.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Article_Fam_Ebp>> getArticle_Fam_Ebp_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Article_Fam_Ebp> Article_Fam_EbpList = await items.map<Article_Fam_Ebp>((json) {
          return Article_Fam_Ebp.fromJson(json);
        }).toList();
        return Article_Fam_EbpList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }



  static List<Result_Article_Link_Verif> ListResult_Article_Link_Verif = [];
  static List<Result_Article_Link_Verif> ListResult_Article_Link_Verif_PROP = [];
  static List<Result_Article_Link_Verif> ListResult_Article_Link_Verif_PROP_Mixte = [];
  static List<Result_Article_Link_Verif> ListResult_Article_Link_Verif_PROP_Service = [];


  //
  //
  //
  //
  //

  //******************************************
  //************   CLIENT   ******************
  //******************************************

  static List<Client> ListClient = [];
  static List<Client> ListClientsearchresult = [];
  static Client gClient = Client.ClientInit();

  //*****************************
  //*****************************
  //*****************************

  static List<Client> ListClient_CSIP = [];
  static List<Client> ListClient_CSIP_Total = [];


  static Future<bool> ListClient_CSIP_Total_Insert(Client wClient) async {
    bool wTrv = false;
    for (int i = 0; i < Srv_DbTools.ListClient_CSIP_Total.length; i++) {
      Client tClient = ListClient_CSIP_Total[i];

      if (tClient.ClientId == wClient .ClientId)
        {
          wTrv = true;
          break;
        }
    }

    if (!wTrv)
    {
      ListClient_CSIP_Total.add(wClient);
    }


    return true;

  }



  static Future<bool> getClient_ALL() async {
    ListClient_CSIP_Total.clear();
    await getClient_All();
    ListClient_CSIP.forEach((wClient) {
      //print("getClient_User_C ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    });

    ListClient.clear();
    ListClient.addAll(ListClient_CSIP_Total);


    ListClient_CSIP_Total.clear();
    return true;
  }

    static Future<bool> getClient_All() async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }


  static Future<bool> getClient_User_CSIP(String User_Matricule) async {

    ListClient_CSIP_Total.clear();
    await getClient_User_C(User_Matricule);
    ListClient_CSIP.forEach((wClient) {
      //print("getClient_User_C ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    });


    await getClient_User_S(User_Matricule);
    ListClient_CSIP.forEach((wClient) {
      //print("getClient_User_S ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    });

    await getClient_User_I(User_Matricule);
    ListClient_CSIP.forEach((wClient) {
      //print("getClient_User_I ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    });

    await getClient_User_I2(User_Matricule);
    ListClient_CSIP.forEach((wClient) {
      //print("getClient_User_I2 ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    });

    await getClient_User_P(User_Matricule);
    ListClient_CSIP.forEach((wClient) {
      //print("getClient_User_P ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    });


    ListClient.clear();
    ListClient.addAll(ListClient_CSIP_Total);


    ListClient_CSIP_Total.clear();
    return true;

  }
/*

  SELECT Clients.* FROM Clients Where Clients.Client_Commercial = 11
  UNION
  SELECT Clients.* FROM Clients, Groupes, Sites where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId AND Sites.Site_ResourceId = 11
  UNION
  SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable = 11
  UNION
  SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable2 = 11
  UNION
  SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions, Planning where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Planning.Planning_InterventionId = Interventions.InterventionId AND Planning.Planning_ResourceId = 11;
*/

  static Future<bool> getClient_User_C(String User_Matricule) async {
    String wSlq = "SELECT Clients.* FROM Clients Where Clients.Client_Commercial = \"$User_Matricule\"";
    //print("getClient_User_C ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_C ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_C return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_S(String User_Matricule) async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId AND Sites.Site_ResourceId = \"$User_Matricule\"";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_I(String User_Matricule) async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable = \"$User_Matricule\"";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_I2(String User_Matricule) async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable2 = \"$User_Matricule\"";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_P(String User_Matricule) async {
    String wSlq = "SELECT Clients.*, Planning_ResourceId FROM Clients, Groupes, Sites, Zones, Interventions, Planning where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Planning.Planning_InterventionId = Interventions.InterventionId AND Planning.Planning_ResourceId = \"$User_Matricule\"";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<List<Client>> getClient_CSIP_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
//      print("getClient_CSIP_API_Post response ${response.statusCode}");
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<Client> ClientList = await items.map<Client>((json) {
          return Client.fromJson(json);
        }).toList();
        return ClientList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }


  static Future<bool> getClientRech(String wRech, String wDepot) async {


   String User_Matricule = Srv_DbTools.gUserLogin.User_Matricule;

    String wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients  LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" ';
   print("getClientRech A");

    
    if (wRech.isNotEmpty)
      {
        wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" '
            ' WHERE Clients.Client_Nom LIKE "%' +
            '${wRech}' +
            '%" OR Adresse_CP LIKE "%' +
            '${wRech}' +
            '%" OR Adresse_Ville LIKE "%' +
            '${wRech}' +
            '%" ORDER BY Client_Nom;';

      }
    else
    if (wDepot.isNotEmpty)
    {
       wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" WHERE Clients.Client_Depot = "$wDepot"' ;

    }



    print("getClient wSlq $wSlq");
    ListClient = await getClient_API_Post("select", wSlq);
    if (ListClient == null) return false;
    if (ListClient.length > 0) {
      gClient = ListClient[0];
      return true;
    }
    return false;
  }

  static Future<bool> getClientRechVP(String wRech, String wDepot) async {


    String User_Matricule = Srv_DbTools.gUserLogin.User_Matricule;

    String wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, CONCAT(Users.User_Nom, " " , Users.User_Prenom) as Users_Nom FROM Clients JOIN Users ON Clients.Client_Commercial = \"${User_Matricule}\" LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" ';
    print("getClientRech A");


    if (wRech.isNotEmpty)
    {
      wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, CONCAT(Users.User_Nom, " " , Users.User_Prenom) as Users_Nom FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" JOIN Users ON Clients.Client_Commercial = \"User_Matricule\"'
          ' WHERE Clients.Client_Nom LIKE "%' +
          '${wRech}' +
          '%" OR Adresse_CP LIKE "%' +
          '${wRech}' +
          '%" OR Adresse_Ville LIKE "%' +
          '${wRech}' +
          '%" ORDER BY Client_Nom;';

    }
    else
    if (wDepot.isNotEmpty)
    {
      wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, CONCAT(Users.User_Nom, " " , Users.User_Prenom) as Users_Nom FROM Clients JOIN Users ON Clients.Client_Commercial = \"User_Matricule\"  LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" WHERE Clients.Client_Depot = "$wDepot"' ;

    }



    print("getClient wSlq $wSlq");
    ListClient = await getClient_API_Post("select", wSlq);
    if (ListClient == null) return false;
    if (ListClient.length > 0) {
      gClient = ListClient[0];
      return true;
    }
    return false;
  }

  static Future<bool> getClientDepotp(String wDepot) async {
    String wSlq = "SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = 'FACT'  WHERE Clients.Client_Depot = '$wDepot'  ORDER BY Client_Nom;";
    print("getClientDepot wSlq $wSlq");
    ListClient = await getClient_API_Post("select", wSlq);

    if (ListClient == null) return false;
    print("getClientDepot ${ListClient.length}");
    if (ListClient.length > 0) {
      print("getClientDepot return TRUE");
      return true;
    }
    return false;
  }


  //*****************************
  //*****************************
  //*****************************

  static Future<bool> IMPORT_ClientAll() async {
    String wSlq = "SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, CONCAT(Users.User_Nom, ' ' , Users.User_Prenom) as Users_Nom  FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = 'FACT'  JOIN Users ON Clients.Client_Commercial = \"User_Matricule\" ORDER BY Client_Nom;";
    try {
      print("IMPORT_ClientAll wSlq ${wSlq}");
      ListClient = await getClient_API_Post("select", wSlq);
      print("IMPORT_ClientAll ListClient ${ListClient.length}");
      if (ListClient == null) return false;
      if (ListClient.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getClient(int Id) async {
//    String wSlq = "SELECT * FROM Clients Where ClientId = '${Id}'";
    String wSlq = "SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = 'FACT' WHERE ClientId = ${Id} ORDER BY Client_Nom;";

    print("getClient wSlq ${wSlq}");
    ListClient = await getClient_API_Post("select", wSlq);

    if (ListClient == null) return false;
    print("getClient ${ListClient.length}");
    if (ListClient.length > 0) {
      gClient = ListClient[0];
      return true;
    }
    return false;
  }

  static Future<bool> setClient(Client Client) async {
    String wSlq = "UPDATE Clients SET "
            "Client_CodeGC = \"${Client.Client_CodeGC}\", " +
        "Client_CL_Pr = ${Client.Client_CL_Pr}, " +
        "Client_Famille = \"${Client.Client_Famille}\", " +
        "Client_Depot = \"${Client.Client_Depot}\", " +
        "Client_Rglt = \"${Client.Client_Rglt}\", " +
        "Client_PersPhys = ${Client.Client_PersPhys}, " +
        "Client_OK_DataPerso = ${Client.Client_OK_DataPerso}, " +
        "Client_Civilite   = \"${Client.Client_Civilite}\", " +
        "Client_Nom        = \"${Client.Client_Nom}\", " +
        "Client_Siret      = \"${Client.Client_Siret}\", " +
        "Client_NAF        = \"${Client.Client_NAF}\", " +
        "Client_TVA        = \"${Client.Client_TVA}\", " +
        "Livr        = \"${Client.Livr}\", " +
        "Client_Commercial = \"${Client.Client_Commercial}\" " +
        "WHERE ClientId = ${Client.ClientId.toString()}";
    gColors.printWrapped("setClient " + wSlq);

    try {
      bool ret = await add_API_Post("upddel", wSlq);
  //    print("setClient ret " + ret.toString());
      return ret;
    } catch (e) {
//      print("setClient ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> addClient(Client Client) async {
    String wValue = "NULL,'???'";
    String wSlq = "INSERT INTO Clients (ClientId, Client_Nom) VALUES ($wValue)";
    print("addClient wSlq " + wSlq);

    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addClient ret " + ret.toString());
      return ret;
    } catch (e) {
      print("addClient ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> delClient(Client Client) async {
    String aSQL = "DELETE FROM Clients WHERE ClientId = ${Client.ClientId} ";
    print("delClient " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delClient ret " + ret.toString());
    return ret;
  }

  static Future<List<Client>> getClient_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<Client> ClientList = await items.map<Client>((json) {
          return Client.fromJson(json);
        }).toList();
        return ClientList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   ADRESSES   ****************
  //******************************************

  static List<Adresse> ListAdresse = [];
  static List<Adresse> ListAdressesearchresult = [];
  static Adresse gAdresse = Adresse.AdresseInit();
  static Adresse gAdresseLivr = Adresse.AdresseInit();

  static Future<bool> IMPORT_AdresseAll() async {
    try {
      ListAdresse = await getAdresse_API_Post("select", "select * from Adresses ORDER BY Adresse_Type");
      if (ListAdresse == null) return false;
      if (ListAdresse.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future getAdresseID(int ID) async {
    ListAdresse.forEach((element) {
      if (element.AdresseId == ID) {
        gAdresse = element;
        return;
      }
    });
  }

/*
  static Future<bool> getAdresseClientType(int ClientID, String Type) async {
    String wSlq = "select * from Adresses  where Adresse_ClientId = $ClientID AND Adresse_Type = '$Type' ORDER BY Adresse_Type";
    print("getAdresseClientType SQL ${wSlq}");

    ListAdressesearchresult = await getAdresse_API_Post("select", wSlq);

    if (ListAdressesearchresult == null) return false;
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> getAdresseClientType ${ListAdresse.length}");

    if (ListAdressesearchresult.length > 0) {
      gAdresse = ListAdressesearchresult[0];
      print("getAdresseClientType return TRUE");
      return true;
    } else {
      addAdresse(ClientID, Type);
      getAdresseClientType(ClientID, Type);
    }
    return false;
  }

  static int SitesSortComparison(Adresse a, Adresse b) {
    final Adresse_NomA = a.Adresse_Nom;
    final Adresse_NomB = b.Adresse_Nom;
    if (Adresse_NomA.compareTo(Adresse_NomB) < 0) {
      return -1;
    } else if (Adresse_NomA.compareTo(Adresse_NomB) > 0) {
      return 1;
    } else {
      return 0;
    }
  }*/
/*

  static Future<bool> getSitesClient(int ClientID) async {
    String wSlq = "select * from Adresses  where Adresse_ClientId = $ClientID AND Adresse_Type = 'SITE' ORDER BY Adresse_Nom";
    print("getAdresseClientType SQL ${wSlq}");
    ListAdresse = await getAdresse_API_Post("select", wSlq);

    ListAdresse.sort(SitesSortComparison);
    if (ListAdresse == null) return false;
    //  print("getAdresseClientType ${ListAdresse.length}");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> getSitesClient ${ListAdresse.length}");
    if (ListAdresse.length > 0) {
      //      print("getAdresseClientType return TRUE");
      return true;
    } else {}
    return false;
  }
*/

  static Future<bool> setAdresse(Adresse Adresse) async {
    String wSlq = "UPDATE Adresses SET "
            "Adresse_ClientId     =   ${Adresse.Adresse_ClientId}, " +
        "Adresse_Code      = \"${Adresse.Adresse_Code}\", " +
        "Adresse_Type      = \"${Adresse.Adresse_Type}\", " +
        "Adresse_Nom      = \"${Adresse.Adresse_Nom}\", " +
        "Adresse_Adr1      = \"${Adresse.Adresse_Adr1}\", " +
        "Adresse_Adr2      = \"${Adresse.Adresse_Adr2}\", " +
        "Adresse_Adr3      = \"${Adresse.Adresse_Adr3}\", " +
        "Adresse_CP        = \"${Adresse.Adresse_CP}\", " +
        "Adresse_Ville     = \"${Adresse.Adresse_Ville}\", " +
        "Adresse_Pays      = \"${Adresse.Adresse_Pays}\", " +
        "Adresse_Rem       = \"${Adresse.Adresse_Rem}\" " +
        "WHERE AdresseId      = ${Adresse.AdresseId.toString()}";

    gColors.printWrapped("setAdresse sql " + wSlq);

    try {
      bool ret = await add_API_Post("upddel", wSlq);
      print("setAdresse ret " + ret.toString());
      return true;
    } catch (e) {
      print("setAdresse ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> addAdresse(int Adresse_ClientId, String Type) async {
    String wValue = "NULL, $Adresse_ClientId, '$Type'";
    String wSlq = "INSERT INTO Adresses (AdresseId, Adresse_ClientId, Adresse_Type) VALUES ($wValue)";
    print("addAdresse " + wSlq);

    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addAdresse ret " + ret.toString());
      return ret;
    } catch (e) {
      print("addAdresse ERROR " + e.toString());
      return false;
    }
  }
/*

  static Future<bool> delAdresse(Adresse Adresse) async {
    String aSQL = "DELETE FROM Adresses WHERE AdresseId = ${Adresse.AdresseId} ";
    print("delAdresse " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delAdresse ret " + ret.toString());
    return ret;
  }
*/

  static Future<List<Adresse>> getAdresse_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Adresse> AdresseList = await items.map<Adresse>((json) {
          return Adresse.fromJson(json);
        }).toList();
        return AdresseList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   GROUPES   *****************
  //******************************************

  static List<Groupe> ListGroupe = [];
  static List<Groupe> ListGroupesearchresult = [];
  static Groupe gGroupe = Groupe.GroupeInit();



  static Future<bool> getGroupeAll() async {
    try {
      ListGroupe = await getGroupe_API_Post("select", "select * from Groupes ORDER BY Groupe_Nom");
      if (ListGroupe == null) return false;
      print("getGroupesClient ${ListGroupe.length}");
      if (ListGroupe.length > 0) {
        print("getGroupesClient return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getGroupesClient(int ID) async {
    String wTmp = "select * from Groupes WHERE Groupe_ClientId = ${ID} ORDER BY Groupe_Nom";
    print("wTmp getGroupesClient ${wTmp}");
    try {
      ListGroupe = await getGroupe_API_Post("select", wTmp);
      if (ListGroupe == null) return false;
      print("getGroupesClient ${ListGroupe.length}");
      if (ListGroupe.length > 0) {
        print("getGroupesClient return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future getGroupeID(int ID) async {
    ListGroupe.forEach((element) {
      if (element.GroupeId == ID) {
        gGroupe = element;
        return;
      }
    });
  }

  static Future<bool> setGroupe(Groupe Groupe) async {
    String wSlq = "UPDATE Groupes SET "
            "Groupe_ClientId     =   ${Groupe.Groupe_ClientId}, " +
        "Groupe_Code      = \"${Groupe.Groupe_Code}\", " +
        "Groupe_Nom      = \"${Groupe.Groupe_Nom}\", " +
        "Groupe_Adr1      = \"${Groupe.Groupe_Adr1}\", " +
        "Groupe_Adr2      = \"${Groupe.Groupe_Adr2}\", " +
        "Groupe_Adr3      = \"${Groupe.Groupe_Adr3}\", " +
        "Groupe_CP        = \"${Groupe.Groupe_CP}\", " +
        "Groupe_Ville     = \"${Groupe.Groupe_Ville}\", " +
        "Groupe_Pays      = \"${Groupe.Groupe_Pays}\", " +
        "Livr        = \"${Groupe.Livr}\", " +
        "Groupe_Rem       = \"${Groupe.Groupe_Rem}\" " +
        "WHERE GroupeId      = ${Groupe.GroupeId.toString()}";
    gColors.printWrapped("setGroupe " + wSlq);

    try {
//      gColors.printWrapped("setGroupe " + wSlq);
      bool ret = await add_API_Post("upddel", wSlq);
  //    print("setGroupe ret " + ret.toString());
      return true;
    } catch (e) {
    //  print("setGroupe ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> addGroupe(int Groupe_ClientId) async {
    String wValue = "NULL, $Groupe_ClientId";
    String wSlq = "INSERT INTO Groupes (GroupeId, Groupe_ClientId) VALUES ($wValue)";
    print("addGroupe " + wSlq);
    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addGroupe ret ${ret.toString()} ${gLastID}");
      return ret;
    } catch (e) {
      print("addGroupe ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> delGroupe(Groupe Groupe) async {
    String aSQL = "DELETE FROM Groupes WHERE GroupeId = ${Groupe.GroupeId} ";
    print("delGroupe " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delGroupe ret " + ret.toString());
    return ret;
  }

  static Future<List<Groupe>> getGroupe_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getGroupe_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    print("getGroupe_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Groupe> GroupeList = await items.map<Groupe>((json) {
          return Groupe.fromJson(json);
        }).toList();
        return GroupeList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   SITES   *****************
  //******************************************

  static List<Site> ListSite = [];
  static List<Site> ListSitesearchresult = [];
  static Site gSite = Site.SiteInit();
  static String gSelGroupe = "";
  static String gSelGroupeBase = "Tous les groupes";




  static Future<bool> getSiteRech(int ID, String wRech) async {
    String wSlq = 'SELECT Groupe_Nom , Sites.* FROM Sites , Groupes, Clients WHERE (Site_Nom LIKE "%' + '${wRech}' + '%" OR Site_CP LIKE "%' + '${wRech}' + '%" OR Site_Ville LIKE "%' + '${wRech}' + '%" ) AND Site_GroupeId = GroupeId AND Groupe_ClientId = ClientId AND Groupe_ClientId = $ID ORDER BY Site_Nom ASC;';

//    String wSlq = 'select * from Sites WHERE Site_Nom LIKE "%' + '${wRech}' + '%" OR Site_CP LIKE "%' + '${wRech}' + '%" OR Site_Ville LIKE "%' + '${wRech}' + '%" ORDER BY Site_Nom;';
    print("getSiteRech wSlq $wSlq");
    ListSite = await getSite_API_Post("select", wSlq);
    if (ListSite == null) return false;
    if (ListSite.length > 0) {
      gSite = ListSite[0];
      return true;
    }
    return false;
  }



  static Future<bool> getSiteAll() async {
    try {
      String wTmp = "select * from Sites ORDER BY Site_Nom";
      print("wTmp getSiteAll ${wTmp}");
      ListSite = await getSite_API_Post("select", wTmp);
      if (ListSite == null) return false;
      print("getSiteAll ${ListSite.length}");
      if (ListSite.length > 0) {
        print("getSiteAll return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getSitesGroupe(int ID) async {
    String wTmp = "select * from Sites WHERE Site_GroupeId = ${ID} ORDER BY Site_Nom";
    print("wTmp getSitesGroupe ${wTmp}");
    try {
      ListSite = await getSite_API_Post("select", wTmp);
      if (ListSite == null) return false;
      print("getSitesGroupe ${ListSite.length}");
      if (ListSite.length > 0) {
        print("getSitesGroupe return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }


  static Future<bool> getClientSites(int ID) async {
    String wTmp = "SELECT Groupe_Nom , Sites.* FROM Sites , Groupes, Clients where Site_GroupeId = GroupeId AND Groupe_ClientId = ClientId AND Groupe_ClientId = $ID ORDER BY Site_Nom ASC;";
    print("SRV_DbTools getSitesGroupe ${wTmp}");
    try {
      ListSite = await getSite_API_Post("select", wTmp);
      if (ListSite == null) return false;
      print("getSitesGroupe ${ListSite.length}");
      if (ListSite.length > 0) {
        print("getSitesGroupe return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }


  static Future<bool> getGroupeSites(int ID) async {
    String wTmp = "SELECT Groupe_Nom , Sites.* FROM Sites , Groupes where Site_GroupeId = GroupeId AND Site_GroupeId = ${ID} ORDER BY Groupe_Nom ASC, Site_Nom ASC;";
    print("SRV_DbTools getSitesGroupe ${wTmp}");
    try {
      ListSite = await getSite_API_Post("select", wTmp);
      if (ListSite == null) return false;
      print("getSitesGroupe ${ListSite.length}");
      if (ListSite.length > 0) {
        print("getSitesGroupe return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future getSiteID(int ID) async {
    ListSite.forEach((element) {
      if (element.SiteId == ID) {
        gSite = element;
        return;
      }
    });
  }

  static Future<bool> setSite(Site Site) async {
    String wSlq = "UPDATE Sites SET "
            "Site_GroupeId     =   ${Site.Site_GroupeId}, " +
        "Site_Code      = \"${Site.Site_Code}\", " +
        "Site_Nom      = \"${Site.Site_Nom}\", " +
        "Site_Adr1      = \"${Site.Site_Adr1}\", " +
        "Site_Adr2      = \"${Site.Site_Adr2}\", " +
        "Site_Adr3      = \"${Site.Site_Adr3}\", " +
        "Site_CP        = \"${Site.Site_CP}\", " +
        "Site_Ville     = \"${Site.Site_Ville}\", " +
        "Site_Pays      = \"${Site.Site_Pays}\", " +
        "Site_ResourceId     =   ${Site.Site_ResourceId}, " +
        "Livr        = \"${Site.Livr}\", " +
        "Site_Rem       = \"${Site.Site_Rem}\" " +
        "WHERE SiteId      = ${Site.SiteId.toString()}";
    gColors.printWrapped("setSite " + wSlq);

    try {
      bool ret = await add_API_Post("upddel", wSlq);
      print("setSite ret " + ret.toString());
      return true;
    } catch (e) {
      print("setSite ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> addSite(int Site_GroupeId) async {
    String wValue = "NULL, $Site_GroupeId";
    String wSlq = "INSERT INTO Sites (SiteId, Site_GroupeId) VALUES ($wValue)";
    print("addSite " + wSlq);
    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addSite ret " + ret.toString());
      return ret;
    } catch (e) {
      print("addSite ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> delSite(Site site) async {
    String aSQL = "DELETE FROM Sites WHERE SiteId = ${site.SiteId} ";
    print("delSite " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delSite ret " + ret.toString());
    return ret;
  }

  static Future<List<Site>> getSite_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String wRep = await response.stream.bytesToString();
      var parsedJson = json.decode(wRep);
      final items = parsedJson['data'];

      if (items != null) {
        List<Site> SiteList = await items.map<Site>((json) {
          return Site.fromJson(json);
        }).toList();
        return SiteList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   ZONES   *****************
  //******************************************

  static List<Zone> ListZone = [];
  static List<Zone> ListZonesearchresult = [];
  static Zone gZone = Zone.ZoneInit();

  static Future<bool> getZonesSite(int ID) async {
    String wTmp = "select * from Zones WHERE Zone_SiteId = $ID ORDER BY Zone_Nom";

    print("wTmp getZonesClient ${wTmp}");
    ListZone = await getZone_API_Post("select", wTmp);

    if (ListZone == null) return false;
    print("getZonesClient ${ListZone.length}");
    if (ListZone.length > 0) {
      gZone = ListZone[0];
      print("getZonesClient return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getZoneAll() async {
    try {
      ListZone = await getZone_API_Post("select", "select * from Zones ORDER BY Zone_Nom");
      if (ListZone == null) return false;
      print("getZoneAll ${ListZone.length}");
      if (ListZone.length > 0) {
        print("getZoneAll return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getZonesGroupe(int ID) async {
    try {
      String wTmp = "select * from Zones WHERE Zone_GroupeId = ${ID} ORDER BY Zone_Nom";
      ListZone = await getZone_API_Post("select", wTmp);
      if (ListZone == null) return false;
      print("getZonesGroupe ${ListZone.length}");
      if (ListZone.length > 0) {
        print("getZonesGroupe return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getZones(int ID) async {
    try {
      String wTmp = "SELECT Zones.* FROM Zones where Zone_SiteId =  ${ID} ORDER BY Zone_Nom ASC;";
      ListZone = await getZone_API_Post("select", wTmp);
      if (ListZone == null) return false;
      print("getZones ${ListZone.length}");
      if (ListZone.length > 0) {
        print("getZones return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future getZoneID(int ID) async {
    print("getZoneID $ID ListZone ${ListZone.length}");

    ListZone.forEach((element) {
      if (element.ZoneId == ID) {
        gZone = element;
        print("gZone ${gZone.Zone_Nom}");
        return;
      }
    });
  }

  static Future<bool> setZone(Zone Zone) async {
    String wSlq = "UPDATE Zones SET "
            "Zone_SiteId     =   ${Zone.Zone_SiteId}, " +
        "Zone_Code      = \"${Zone.Zone_Code}\", " +
        "Zone_Nom      = \"${Zone.Zone_Nom}\", " +
        "Zone_Adr1      = \"${Zone.Zone_Adr1}\", " +
        "Zone_Adr2      = \"${Zone.Zone_Adr2}\", " +
        "Zone_Adr3      = \"${Zone.Zone_Adr3}\", " +
        "Zone_CP        = \"${Zone.Zone_CP}\", " +
        "Zone_Ville     = \"${Zone.Zone_Ville}\", " +
        "Zone_Pays      = \"${Zone.Zone_Pays}\", " +
        "Livr        = \"${Zone.Livr}\", " +
        "Zone_Rem       = \"${Zone.Zone_Rem}\" " +
        "WHERE ZoneId      = ${Zone.ZoneId.toString()}";
    gColors.printWrapped("setZone " + wSlq);

    try {
      bool ret = await add_API_Post("upddel", wSlq);
      print("setZone ret " + ret.toString());
      return ret;
    } catch (e) {
      print("setZone ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> addZone(int Zone_SiteId) async {
    String wValue = "NULL, $Zone_SiteId";
    String wSlq = "INSERT INTO Zones (ZoneId, Zone_SiteId) VALUES ($wValue)";
    print("addZone " + wSlq);
    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addZone ret ${ret.toString()}");
      return ret;
    } catch (e) {
      print("addZone ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> delZone(Zone zone) async {
    String aSQL = "DELETE FROM Zones WHERE ZoneId = ${zone.ZoneId} ";
    print("delZone " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delZone ret " + ret.toString());
    return ret;
  }

  static Future<List<Zone>> getZone_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getZone_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
//        print("getZone_API_Post response ${response.statusCode}" );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
          List<Zone> ZoneList = await items.map<Zone>((json) {
          return Zone.fromJson(json);
        }).toList();
        return ZoneList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   INTERVENTIONS   ***********
  //******************************************

  static List<Intervention> ListIntervention = [];
  static List<Intervention> ListInterventionsearchresult = [];
  static Intervention gIntervention = Intervention.InterventionInit();

  static String selectedUserInter = "";
  static String selectedUserInter2 = "";
  static String selectedUserInter3 = "";
  static String selectedUserInter4 = "";
  static String selectedUserInter5 = "";
  static String selectedUserInter6 = "";
  static String selectedUserInter4RC = "";



  static String gSelIntervention = "";
  static String gSelInterventionBase = "Tous les types d'organe";

  static int affSortComparisonData(Intervention a, Intervention b) {
    final wInterventionDateA = a.Intervention_Date;
    final wInterventionDateB = b.Intervention_Date;

    int wInterventionIdA = a.InterventionId!;
    int wInterventionIdB = b.InterventionId!;



    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDateA = inputFormat.parse(wInterventionDateA!);
    var inputDateB = inputFormat.parse(wInterventionDateB!);

    if (inputDateA.isBefore(inputDateB)) {
      return 1;
    } else if (inputDateA.isAfter(inputDateB)) {
      return -1;
    } else {
      if (wInterventionIdA < wInterventionIdB) {
        return 1;
      } else if (wInterventionIdA > wInterventionIdB) {
        return -1;
      }
      return 0;
    }
  }




  static Future<bool> getInterventionClientAll() async {
    String wTmp = "SELECT Clients.ClientId, Clients.Client_Nom, Groupes.GroupeId ,Groupes.Groupe_Nom, Sites.SiteId,Sites.Site_Nom, Zones.ZoneID, Zones.Zone_Nom,a.*, IFNULL(c.Cnt,0) as Cnt FROM Interventions a LEFT JOIN (SELECT Parcs_InterventionId, count(1) Cnt FROM Parcs_Ent GROUP BY Parcs_InterventionId) as c ON c.Parcs_InterventionId=a.InterventionId LEFT JOIN Zones ON ZoneId = Intervention_ZoneId LEFT JOIN Sites ON SiteId = Zone_SiteId LEFT JOIN Groupes ON GroupeId = Site_GroupeId LEFT JOIN Clients ON ClientId = Groupe_ClientId";

    ListIntervention = await getIntervention_API_Post_Client("select", wTmp);
    if (ListIntervention == null) return false;
    print("getInterventionAll ${ListIntervention.length}");
    if (ListIntervention.length > 0) {
      print("getInterventionAll return TRUE");
      return true;
    }
    return false;
  }



  static Future<List<Intervention>> getIntervention_API_Post_Client(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Intervention> InterventionList = await items.map<Intervention>((json) {
          return Intervention.fromJsonClient(json);
        }).toList();
        return InterventionList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }


  static Future<bool> getInterventionAll() async {
    try {
      ListIntervention = await getIntervention_API_Post("select", "select * from Interventions");
      if (ListIntervention == null) return false;
      print("getInterventionAll ${ListIntervention.length}");
      if (ListIntervention.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getInterventionUID(String ResourceId) async {
    try {
      ListIntervention = await getIntervention_API_Post("select", "SELECT Interventions.* FROM Planning, Interventions WHERE Planning_InterventionId = InterventionId AND Planning_ResourceId = \"$ResourceId\" GROUP BY Interventions.InterventionId;");
    if (ListIntervention == null) return false;
    print("getInterventionAll ${ListIntervention.length}");
    if (ListIntervention.length > 0) {
    return true;
    }
    return false;
    } catch (e) {
    return false;
    }
  }

  static Future<bool> getInterventionsZone(int ID) async {
    String wTmp = "select * from Interventions WHERE Intervention_ZoneId = ${ID} ORDER BY Intervention_Date";
    print("SRV_DbTools getInterventionsZone ${wTmp}");
    try {
      ListIntervention = await getIntervention_API_Post("select", wTmp);
      if (ListIntervention == null) return false;
      print("getInterventionsZone ${ListIntervention.length}");
      if (ListIntervention.length > 0) {
        print("getInterventionsZone return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getInterventionsID_Srv(int ID) async {
    String wTmp = "select * from Interventions WHERE InterventionId = ${ID}";

    ListIntervention = await getIntervention_API_Post("select", wTmp);

    if (ListIntervention == null) return false;
    print("getInterventionsID_Srv length ${ListIntervention.length}");
    if (ListIntervention.length > 0) {
      gIntervention = ListIntervention[0];
      print("getInterventionsID_Srv ${gIntervention.Desc()}");

      return true;
    }
    return false;
  }

  static Future getInterventionID(int ID) async {
    ListIntervention.forEach((element) {
      if (element.InterventionId == ID) {
        gIntervention = element;
        return;
      }
    });
  }




  static Future<bool> setIntervention(Intervention Intervention) async {
    String wSlq = "UPDATE Interventions SET "
            "InterventionId     =   ${Intervention.InterventionId}, " +
        "Intervention_ZoneId      = \"${Intervention.Intervention_ZoneId}\", " +
        "Intervention_Date      = \"${Intervention.Intervention_Date}\", " +
        "Intervention_Date_Visite      = \"${Intervention.Intervention_Date_Visite}\", " +
        "Intervention_Type      = \"${Intervention.Intervention_Type}\", " +
        "Intervention_Parcs_Type      = \"${Intervention.Intervention_Parcs_Type}\", " +
        "Intervention_Status      = \"${Intervention.Intervention_Status}\", " +
        "Livr        = \"${Intervention.Livr}\", " +
        "Intervention_Signataire_Client        = \"${Intervention.Intervention_Signataire_Client}\", " +
        "Intervention_Signataire_Tech        = \"${Intervention.Intervention_Signataire_Tech}\", " +
        "Intervention_Signataire_Date        = \"${Intervention.Intervention_Signataire_Date}\", " +
        "Intervention_Signataire_Date_Client	        = \"${Intervention.Intervention_Signataire_Date_Client	}\", " +
        "Intervention_Signature_Client        = \"${Intervention.Intervention_Signature_Client}\", " +
        "Intervention_Signature_Tech        = \"${Intervention.Intervention_Signature_Tech}\", " +
        "Intervention_Sat        = ${Intervention.Intervention_Sat}, " +
        "Intervention_Remarque      = \"${Intervention.Intervention_Remarque}\" " +
        "WHERE InterventionId      = ${Intervention.InterventionId.toString()}";
//    gColors.printWrapped("setIntervention " + wSlq);

    try {
      bool ret = await add_API_Post("upddel", wSlq);
//      print("setIntervention ret " + ret.toString());
      return true;
    } catch (e) {
  //    print("setIntervention ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> addIntervention(int Intervention_ZoneId) async {
    String wValue = "NULL, $Intervention_ZoneId";
    String wSlq = "INSERT INTO Interventions (InterventionId, Intervention_ZoneId) VALUES ($wValue)";
    print("addIntervention " + wSlq);

    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addIntervention ret $ret  gLastID $gLastID");
      return ret;
    } catch (e) {
      print("addIntervention ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> delIntervention(Intervention Intervention) async {
    String aSQL = "DELETE FROM Interventions WHERE InterventionId = ${Intervention.InterventionId} ";
    print("delIntervention " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delIntervention ret " + ret.toString());
    return ret;
  }

  static Future<List<Intervention>> getIntervention_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getIntervention_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    print("getIntervention_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<Intervention> InterventionList = await items.map<Intervention>((json) {
          return Intervention.fromJson(json);
        }).toList();
        print("InterventionList  ${InterventionList.length}");
        return InterventionList;
      }
    } else {
      print(response.reasonPhrase);
    }

    return [];
  }


//  SELECT * FROM planning_link where Planning_ResourceId = 1


  //*************************************
  //************   PLANNING   ***********
  //*************************************
  static List<UserH> ListUserH = [];

  static Future getPlanning_InterventionIdRes(int InterventionId) async {
    ListUserH.clear();
    try {
      String wSql = "SELECT Users.User_Nom , Users.User_Prenom, SUM(TIMEDIFF( Planning.Planning_InterventionendTime,Planning.Planning_InterventionstartTime) / 10000) as H FROM Planning , Users where Planning_ResourceId = Users.User_Matricule AND   Planning_InterventionId = $InterventionId GROUP BY Planning.Planning_ResourceId ORDER BY H DESC;";

      print(" Srv_DbTools getPlanning_InterventionIdRes ${wSql}");



      ListUserH = await getPlanningH_API_Post("select", wSql);
      if (ListPlanning == null) return false;
      if (ListPlanning.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static List<Planning> ListPlanning = [];
  static Planning gPlanning = Planning.Planning_RdvInit();

  static Future getPlanning_All() async {
    ListPlanning = await getPlanning_API_Post("select", "select * from Planning");
    if (ListPlanning == null) return false;
    if (ListPlanning.length > 0) {
      return true;
    }
    return false;
  }

  static Future getPlanning_InterventionId(int InterventionId) async {
    try {
      ListPlanning = await getPlanning_API_Post("select", "select * from Planning where Planning_InterventionId = $InterventionId");
      if (ListPlanning == null) return false;
      if (ListPlanning.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future getPlanning_ResourceId(String ResourceId) async {
    try {
      ListPlanning = await getPlanning_API_Post("select", "select * from Planning where Planning_ResourceId = \"$ResourceId\"");
      if (ListPlanning == null) return false;
      if (ListPlanning.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setPlanning(Planning planning) async {
    String wSlq = "UPDATE Planning SET "
        "Planning_InterventionId = ${planning.Planning_InterventionId}, "
        "Planning_Libelle = '${planning.Planning_Libelle}', "
        "Planning_ResourceId = '${planning.Planning_ResourceId}', "
        "Planning_InterventionstartTime = '${planning.Planning_InterventionstartTime}', "
        "Planning_InterventionendTime = '${planning.Planning_InterventionendTime}' "
        "WHERE PlanningId = ${planning.PlanningId}";

    gColors.printWrapped("setPlanning " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setPlanning ret " + ret.toString());
    return ret;
  }

  static Future<bool> addPlanning(Planning Planning) async {
    String wValue = "NULL, ${Planning.Planning_InterventionId}, ${Planning.Planning_ResourceId} , '${Planning.Planning_InterventionstartTime}', '${Planning.Planning_InterventionendTime}' , '${Planning.Planning_Libelle}'";
    String wSlq = "INSERT INTO Planning (PlanningId, Planning_InterventionId, Planning_ResourceId, Planning_InterventionstartTime, Planning_InterventionendTime, Planning_Libelle) VALUES ($wValue)";
    print("addPlanning " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addPlanning ret " + ret.toString());
    return ret;
  }

  static Future<bool> delPlanning(Planning Planning) async {
    String aSQL = "DELETE FROM Planning WHERE PlanningId = ${Planning.PlanningId} ";
    print("delPlanning " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delPlanning ret " + ret.toString());
    return ret;
  }

  static Future<List<Planning>> getPlanning_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getIntervention_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    print("getIntervention_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Planning> PlanningList = await items.map<Planning>((json) {
          return Planning.fromJson(json);
        }).toList();

        print("Planning length ${PlanningList.length}");

        return PlanningList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<List<UserH>> getPlanningH_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getPlanningH_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    print("getPlanningH_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<UserH> ListUserH = await items.map<UserH>((json) {
          return UserH.fromJson(json);
        }).toList();

        print("getPlanningH_API_Post length ${ListUserH.length}");

        return ListUserH;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }
  //***************************************************
  //************   PLANNING INTERVENTIONS   ***********
  //***************************************************

  static List<Planning_Intervention> ListPlanning_Intervention = [];
  static Planning_Intervention gPlanning_Intervention = Planning_Intervention.Planning_InterventionInit();

  static int affSortComparisonData_Planning_Intervention(Planning_Intervention a, Planning_Intervention b) {
    final inputDateA = a.Planning_Interv_InterventionstartTime;
    final inputDateB = b.Planning_Interv_InterventionstartTime;
    if (inputDateA.isBefore(inputDateB)) {
      return -1;
    } else if (inputDateA.isAfter(inputDateB)) {
      return 1;
    } else {
      return 0;
    }
  }



  static Future getPlanning_InterventionRes(String ResourceId) async {
    try {
      String wTmp = "SELECT PlanningId, Planning_InterventionId, Planning_ResourceId,Planning_InterventionstartTime, Planning_InterventionendTime, Planning_Libelle, InterventionId,Intervention_Type,Intervention_Parcs_Type,Intervention_Status, ZoneId, Zone_Nom, SiteId, Site_Nom, GroupeId, Groupe_Nom, ClientId, Client_Nom FROM Planning, Interventions, Zones, Sites, Groupes, Clients WHERE Planning_InterventionId = InterventionId AND Intervention_ZoneId = ZoneId AND Zone_SiteId = SiteId AND Site_GroupeId = GroupeId AND Groupe_ClientId = ClientId AND Planning_ResourceId = \"$ResourceId\" ORDER BY Planning_InterventionstartTime";
      print("getPlanning_InterventionRes $wTmp");
      ListPlanning_Intervention = await getPlanning_Intervention_API_Post("select", wTmp);
      if (ListPlanning_Intervention == null) return false;
      if (ListPlanning_Intervention.length > 0) {


        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Planning_Intervention>> getPlanning_Intervention_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

//    print("getPlanning_Intervention_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
  //  print("getPlanning_Intervention_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Planning_Intervention> Planning_Interventionlist = await items.map<Planning_Intervention>((json) {
          return Planning_Intervention.fromJson(json);
        }).toList();

        print("Planning_Interventionlist length ${Planning_Interventionlist.length}");

        return Planning_Interventionlist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //***************   InterMissions_Document   *****
  //******************************************

  static List<InterMissions_Document> ListInterMissions_Document = [];
  static List<InterMissions_Document> ListInterMissions_Documentsearchresult = [];
  static InterMissions_Document gInterMissions_Document = InterMissions_Document();



  static Future<bool> getInterMissions_Document_MissonID(int ID) async {
    String wTmp = "select InterMissionsDocInterMissionId ,Documents.* from InterMissions_Doc join Documents where InterMissions_Doc.InterMissionsDocDocID = DocID AND InterMissionsDocInterMissionId = $ID";
    print("wTmp $wTmp");

    ListInterMissions_Document = await getInterMissions_Document_API_Post("select", wTmp);
    if (ListInterMissions_Document == null) return false;
    print("getInterMissions_Document_MissonID ListInterMissions_Document.length ${ListInterMissions_Document.length}");
    if (ListInterMissions_Document.length > 0) {

      gInterMissions_Document = ListInterMissions_Document[0];
      print("gInterMissions_Document ${gInterMissions_Document.DocID}");
      print("ListInterMissions_Document return TRUE");
      return true;
    }
    return false;
  }



  static Future<List<InterMissions_Document>> getInterMissions_Document_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});



    http.StreamedResponse response = await request.send();
    print("getInterMissions_Document_API_Post response ${response.statusCode}" );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      print("getInterMissions_Document_API_Post items ${items}" );

      if (items != null) {
        List<InterMissions_Document> InterMissions_DocumentList = await items.map<InterMissions_Document>((json) {
          return InterMissions_Document.fromJson(json);
        }).toList();
        return InterMissions_DocumentList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }


  //******************************************
  //************   InterMissionS   ***********
  //******************************************

  static List<InterMission> ListInterMission = [];
  static List<InterMission> ListInterMissionsearchresult = [];
  static InterMission gInterMission = InterMission.InterMissionInit();

  static int affSortComparisonDataIM(InterMission a, InterMission b) {
    final wInterMissionDateA = a.InterMission_Date;
    final wInterMissionDateB = b.InterMission_Date;

    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDateA = inputFormat.parse(wInterMissionDateA);
    var inputDateB = inputFormat.parse(wInterMissionDateB);

    if (inputDateA.isBefore(inputDateB)) {
      return 1;
    } else if (inputDateA.isAfter(inputDateB)) {
      return -1;
    } else {
      return 0;
    }
  }

  static Future<bool> getInterMissionAll() async {
    try {
      ListInterMission = await getInterMission_API_Post("select", "select * from InterMissions ORDER BY InterMission_Nom");
      if (ListInterMission == null) return false;
      print("getInterMissionAll ${ListInterMission.length}");
      if (ListInterMission.length > 0) {
        print("getInterMissionAll return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }


  static Future<bool> getInterMissionUID(String ResourceId) async {
    try {
      String wSql = "SELECT InterMissions.* FROM Planning,  InterMissions WHERE Planning_InterventionId = Planning_InterventionId AND Planning_ResourceId = \"$ResourceId\" GROUP BY InterMissionId ASC;";
      print("getInterMissionUID ${wSql}");
      ListInterMission = await getInterMission_API_Post("select",wSql);
      if (ListInterMission == null) return false;
      print("getInterMissionUID ${ListInterMission.length}");
      if (ListInterMission.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }




  static Future<bool> getInterMissionsIntervention(int ID) async {
    String wTmp = "SELECT * FROM InterMissions WHERE InterMission_InterventionId = $ID";
    print("wTmp $wTmp");

    ListInterMission = await getInterMission_API_Post("select", wTmp);

    if (ListInterMission == null) return false;
    //  print("getInterMissionsSite ${ListInterMission.length}");
    if (ListInterMission.length > 0) {
      //  print("getInterMissionsSite return TRUE");
      return true;
    }
    return false;
  }

  static Future getInterMissionID(int ID) async {
    ListInterMission.forEach((element) {
      if (element.InterMissionId == ID) {
        gInterMission = element;
        return;
      }
    });
  }

  static Future<bool> setInterMission(InterMission InterMission) async {
    String wSlq = "UPDATE InterMissions SET "
            "InterMissionId     =   ${InterMission.InterMissionId}, " +
        "InterMission_InterventionId      = \"${InterMission.InterMission_InterventionId}\", " +
        "InterMission_Nom      = \"${InterMission.InterMission_Nom}\", " +
        "InterMission_Exec      = ${InterMission.InterMission_Exec}, " +
        "InterMission_Date      = \"${InterMission.InterMission_Date}\" " +
        "WHERE InterMissionId      = ${InterMission.InterMissionId.toString()}";
    gColors.printWrapped("setInterMission " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setInterMission ret " + ret.toString());
    return ret;
  }

  static Future<bool> addInterMission(InterMission InterMission) async {
    String wValue = "NULL, ${InterMission.InterMission_InterventionId}, '${InterMission.InterMission_Nom}' , ${InterMission.InterMission_Exec}, '${InterMission.InterMission_Date}' ";
    String wSlq = "INSERT INTO InterMissions (InterMissionId, InterMission_InterventionId, InterMission_Nom, InterMission_Exec, InterMission_Date) VALUES ($wValue)";
    print("addInterMission " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addInterMission ret " + ret.toString());
    return ret;
  }

  static Future<bool> delInterMission(InterMission InterMission) async {
    String aSQL = "DELETE FROM InterMissions WHERE InterMissionId = ${InterMission.InterMissionId} ";
    print("delInterMission " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delInterMission ret " + ret.toString());
    return ret;
  }

  static Future<List<InterMission>> getInterMission_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

//    print("getInterMission_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    //  print("getInterMission_API_Post response ${response.statusCode}" );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<InterMission> InterMissionList = await items.map<InterMission>((json) {
          return InterMission.fromJson(json);
        }).toList();
        return InterMissionList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   Parc_Ents   ***************
  //******************************************

  static List<Parc_Ent_Srv> ListParc_Ent = [];
  static List<Parc_Ent_Srv> ListParc_Entsearchresult = [];
  static Parc_Ent_Srv gParc_Ent = Parc_Ent_Srv.Parc_EntInit(0, "", 0);

  static Future<bool> getParc_EntAll() async {
    ListParc_Ent = await getParc_Ent_API_Post("select", "select * from Parcs_Ent ORDER BY Parcs_Type");
    if (ListParc_Ent == null) return false;
    print("getParc_EntAll ${ListParc_Ent.length}");
    if (ListParc_Ent.length > 0) {
      print("getParc_EntAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_EntID(int ID) async {
    try {
      ListParc_Ent = await getParc_Ent_API_Post("select", "select * from Parcs_Ent WHERE Parcs_InterventionId = $ID  ORDER BY Parcs_Type");
      if (ListParc_Ent == null) return false;
      if (ListParc_Ent.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setParc_Ent(Parc_Ent_Srv Parc_Ent) async {
    String wSlq = "UPDATE Parcs_Ent SET "
            "ParcsId     =   ${Parc_Ent.ParcsId}, " +
        "Parcs_order     =   ${Parc_Ent.Parcs_order}, " +
        "Parcs_InterventionId = ${Parc_Ent.Parcs_InterventionId}, " +
        "Parcs_Intervention_Timer = \"${Parc_Ent.Parcs_Intervention_Timer}\", " +
        "Parcs_Type  = \"${Parc_Ent.Parcs_Type}\", " +
        "Parcs_Date_Rev  = \"${Parc_Ent.Parcs_Date_Rev}\", " +
        "Parcs_QRCode  = \"${Parc_Ent.Parcs_QRCode}\", " +
        "Parcs_FREQ_Id  = \"${Parc_Ent.Parcs_FREQ_Id}\", " +
        "Parcs_FREQ_Label  = \"${Parc_Ent.Parcs_FREQ_Label}\", " +
        "Parcs_ANN_Id  = \"${Parc_Ent.Parcs_ANN_Id}\", " +
        "Parcs_ANN_Label  = \"${Parc_Ent.Parcs_ANN_Label}\", " +
        "Parcs_FAB_Id  = \"${Parc_Ent.Parcs_FAB_Id}\", " +
        "Parcs_FAB_Label  = \"${Parc_Ent.Parcs_FAB_Label}\", " +
        "Parcs_NIV_Id  = \"${Parc_Ent.Parcs_NIV_Id}\", " +
        "Parcs_NIV_Label  = \"${Parc_Ent.Parcs_NIV_Label}\", " +
        "Parcs_ZNE_Id  = \"${Parc_Ent.Parcs_ZNE_Id}\", " +
        "Parcs_ZNE_Label  = \"${Parc_Ent.Parcs_ZNE_Label}\", " +
        "Parcs_EMP_Id  = \"${Parc_Ent.Parcs_EMP_Id}\", " +
        "Parcs_EMP_Label  = \"${Parc_Ent.Parcs_EMP_Label}\", " +
        "Parcs_LOT_Id  = \"${Parc_Ent.Parcs_LOT_Id}\", " +
        "Parcs_LOT_Label  = \"${Parc_Ent.Parcs_LOT_Label}\", " +
        "Parcs_SERIE_Id  = \"${Parc_Ent.Parcs_SERIE_Id}\", " +
        "Parcs_SERIE_Label  = \"${Parc_Ent.Parcs_SERIE_Label}\", " +
        "Parcs_Audit_Note  = \"${Parc_Ent.Parcs_Audit_Note}\", " +
        "Parcs_UUID  = \"${Parc_Ent.Parcs_UUID}\", " +
        "Parcs_UUID_Parent  = \"${Parc_Ent.Parcs_UUID_Parent}\", " +
        "Parcs_NCERT  = \"${Parc_Ent.Parcs_NCERT}\", " +
        "Parcs_NoSpec  = \"${Parc_Ent.Parcs_NoSpec}\", " +
        "Parcs_CodeArticle  = \"${Parc_Ent.Parcs_CodeArticle}\", " +
        "Parcs_CodeArticleES  = \"${Parc_Ent.Parcs_CodeArticleES}\", " +
        "Parcs_CODF  = \"${Parc_Ent.Parcs_CODF}\", " +
        "Livr        = \"${Parc_Ent.Livr}\", " +
        "Devis        = \"${Parc_Ent.Devis}\", " +
        "Action        = \"${Parc_Ent.Action}\", " +
        "Parcs_Verif_Note  = \"${Parc_Ent.Parcs_Verif_Note}\"";

    gColors.printWrapped("setParc_Ent A " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Ent_Srv(int aParcs_InterventionId) async {
    String aSQL = "DELETE FROM Parcs_Ent WHERE Parcs_InterventionId = ${aParcs_InterventionId} ";
    print("delParc_Ent_Srv " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Ent_Srv ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Ent_Srv_Upd() async {
    String wIn = "";

    for (int i = 0; i < DbTools.glfParcs_Ent.length; i++) {
      Parc_Ent aParc_Ent = DbTools.glfParcs_Ent[i];
      if (wIn.isNotEmpty) wIn = "${wIn}, ";
      wIn = "${wIn} '${aParc_Ent.Parcs_UUID}'";
    }

    print("delParc_Ent_Srv wIn " + wIn);
    if (wIn.isNotEmpty) {
      String aSQL = "DELETE FROM Parcs_Ent WHERE Parcs_UUID in (${wIn})";
      print("delParc_Ent_Srv " + aSQL);
      bool ret = await add_API_Post("upddel", aSQL);
      print("delParc_Ent_Srv ret " + ret.toString());
    }
    return true;
  }

  static Future<bool> InsertUpdateParc_Ent_Srv(Parc_Ent aParc_Ent) async {
    if (aParc_Ent.Parcs_NCERT == null) aParc_Ent.Parcs_NCERT = "";
    if (aParc_Ent.Parcs_NoSpec == null) aParc_Ent.Parcs_NoSpec = "";
    if (aParc_Ent.Parcs_CodeArticle == null) aParc_Ent.Parcs_CodeArticle = "";
    if (aParc_Ent.Parcs_CodeArticleES == null) aParc_Ent.Parcs_CodeArticleES = "";
    if (aParc_Ent.Parcs_CODF == null) aParc_Ent.Parcs_CODF = "";

    if (aParc_Ent.Parcs_Intervention_Timer == null) aParc_Ent.Parcs_Intervention_Timer= 0;


    String wSql = "INSERT INTO Parcs_Ent(ParcsId, Parcs_order, Parcs_InterventionId, "
        "Parcs_Type, "
        "Parcs_Date_Rev, "
        "Parcs_QRCode, "
        "Parcs_FREQ_Id, Parcs_FREQ_Label, "
        "Parcs_ANN_Id, Parcs_ANN_Label, "
        "Parcs_FAB_Id, Parcs_FAB_Label, "
        "Parcs_NIV_Id, Parcs_NIV_Label, "
        "Parcs_ZNE_Id, Parcs_ZNE_Label, "
        "Parcs_EMP_Id, Parcs_EMP_Label, "
        "Parcs_LOT_Id, Parcs_LOT_Label, "
        "Parcs_SERIE_Id, Parcs_SERIE_Label, "
        "Parcs_Audit_Note, Parcs_Verif_Note, "
        "Parcs_UUID, "
        "Parcs_UUID_Parent, "
        "Parcs_NCERT, "
        "Parcs_NoSpec, "
        "Parcs_CodeArticle, "
        "Parcs_CodeArticleES, "
        "Parcs_CODF, "
        "Livr, Devis, Action, "
        "Parcs_Intervention_Timer) VALUES ("
        "NULL , ${aParc_Ent.Parcs_order}, ${aParc_Ent.Parcs_InterventionId},"
        "'${aParc_Ent.Parcs_Type!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_Date_Rev!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_QRCode!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_FREQ_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_FREQ_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_ANN_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_ANN_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_FAB_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_FAB_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_NIV_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_NIV_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_ZNE_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_ZNE_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_EMP_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_EMP_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_LOT_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_LOT_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_SERIE_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_SERIE_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_Audit_Note!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_Verif_Note!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_UUID!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_UUID_Parent!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_NCERT!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_NoSpec!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_CodeArticle!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_CodeArticleES!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_CODF!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Livr!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Devis!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Action!.replaceAll("'", "‘")}',"
        "${aParc_Ent.Parcs_Intervention_Timer})";


    gColors.printWrapped("setParc_Ent B " + wSql);


    bool ret = await add_API_Post("insert", wSql);
    print("setParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> InsertUpdateParc_Ent_Srv_Srv(Parc_Ent_Srv aParc_Ent) async {

if ("${aParc_Ent.Parcs_Intervention_Timer}" == "null") aParc_Ent.Parcs_Intervention_Timer= 0;


    String wSql = "INSERT INTO Parcs_Ent(ParcsId, Parcs_order, Parcs_InterventionId, "
        "Parcs_Type, "
        "Parcs_Date_Rev, "
        "Parcs_QRCode, "
        "Parcs_FREQ_Id, Parcs_FREQ_Label, "
        "Parcs_ANN_Id, Parcs_ANN_Label, "
        "Parcs_FAB_Id, Parcs_FAB_Label, "
        "Parcs_NIV_Id, Parcs_NIV_Label, "
        "Parcs_ZNE_Id, Parcs_ZNE_Label, "
        "Parcs_EMP_Id, Parcs_EMP_Label, "
        "Parcs_LOT_Id, Parcs_LOT_Label, "
        "Parcs_SERIE_Id, Parcs_SERIE_Label, "
        "Parcs_Audit_Note, Parcs_Verif_Note, Parcs_UUID, "
        "Parcs_UUID_Parent, "
        "Parcs_NCERT, "
        "Parcs_NoSpec, "
        "Parcs_CodeArticle, "
        "Parcs_CodeArticleES, "
        "Parcs_CODF, "
        "Livr, Devis, Action, Parcs_Intervention_Timer) VALUES ("
        "NULL , ${aParc_Ent.Parcs_order}, ${aParc_Ent.Parcs_InterventionId},"
        "'${aParc_Ent.Parcs_Type!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_Date_Rev!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_QRCode!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_FREQ_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_FREQ_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_ANN_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_ANN_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_FAB_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_FAB_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_NIV_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_NIV_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_ZNE_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_ZNE_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_EMP_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_EMP_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_LOT_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_LOT_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_SERIE_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_SERIE_Label!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_Audit_Note!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_Verif_Note!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_UUID!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_UUID_Parent!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_NCERT!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_NoSpec!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_CodeArticle!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_CodeArticleES!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_CODF!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Livr!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Devis!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Action!.replaceAll("'", "‘")}',"
        "'${aParc_Ent.Parcs_Intervention_Timer}')";

    gColors.printWrapped("setParc_Ent C " + wSql);
    bool ret = await add_API_Post("insert", wSql);
    print("setParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_EntAdrType(int Parcs_InterventionId) async {
    String wValue = "NULL, $Parcs_InterventionId, ";
    String wSlq = "INSERT INTO Parcs_Ent (ParcsId, Parcs_InterventionId, ) VALUES ($wValue)";
    print("addParc_Ent " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_Ent(int Parcs_InterventionId) async {
    String wValue = "NULL, $Parcs_InterventionId";
    String wSlq = "INSERT INTO Parcs_Ent (ParcsId, Parcs_InterventionId) VALUES ($wValue)";
    print("addParc_Ent " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Ent(Parc_Ent_Srv Parc_Ent) async {
    String aSQL = "DELETE FROM Parcs_Ent WHERE Parc_EntId = ${Parc_Ent.ParcsId} ";
    print("delParc_Ent " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<List<Parc_Ent_Srv>> getParc_Ent_API_Post(String aType, String aSQL) async {
    setSrvToken();
    print("getParc_Ent_API_Post aSQL " + aSQL);
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      print("getParc_Ent_API_Post items ${items}");

      if (items != null) {
        List<Parc_Ent_Srv> Parc_EntList = await items.map<Parc_Ent_Srv>((json) {

          print("getParc_Ent_API_Post json ${json}");

          return Parc_Ent_Srv.fromJson(json);
        }).toList();
        return Parc_EntList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   Parcs_Desc   ***************
  //******************************************

  static List<Parc_Desc_Srv> ListParc_Desc = [];
  static List<Parc_Desc_Srv> ListParc_Descsearchresult = [];
  static Parc_Desc_Srv gParc_Desc = Parc_Desc_Srv(0, 0, "", "", "");

  static Future<bool> getParc_DescAll() async {
    ListParc_Desc = await getParc_Desc_API_Post("select", "select * from Parcs_Desc ORDER BY Parcs_Type");

    if (ListParc_Desc == null) return false;
    print("getParc_DescAll ${ListParc_Desc.length}");
    if (ListParc_Desc.length > 0) {
      print("getParc_DescAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_DescID(int ID) async {
    ListParc_Desc.forEach((element) {
      if (element.ParcsDescId == ID) {
        gParc_Desc = element;
        return;
      }
    });
  }

  static Future<bool> getParcs_DescInter(int Parcs_InterventionId) async {
    try {
      ListParc_Desc = await getParc_Desc_API_Post("select", "SELECT Parcs_Desc.* FROM Parcs_Desc, Parcs_Ent  WHERE ParcsDesc_ParcsId = ParcsId AND Parcs_InterventionId = $Parcs_InterventionId");
      if (ListParc_Desc == null) return false;
      if (ListParc_Desc.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setParc_Desc(Parc_Desc_Srv Parc_Desc) async {
    String wSlq = "UPDATE Parcs_Desc SET "
            "ParcsDescId            =   ${Parc_Desc.ParcsDescId}, " +
        "ParcsDesc_ParcsId      =   ${Parc_Desc.ParcsDesc_ParcsId}, " +
        "ParcsDesc_Type         = \"${Parc_Desc.ParcsDesc_Type}\", " +
        "ParcsDesc_Id           = \"${Parc_Desc.ParcsDesc_Id}\", " +
        "ParcsDesc_Lib          = \"${Parc_Desc.ParcsDesc_Lib}\" ";

    gColors.printWrapped("setParc_Desc " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Desc ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Desc_Srv(int aParcsDesc_ParcsId) async {
    String aSQL = "DELETE FROM Parcs_Desc WHERE ParcsDesc_ParcsId = ${aParcsDesc_ParcsId} ";
    print("delParc_Desc_Srv " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Desc_Srv ret " + ret.toString());
    return ret;
  }

  static Future<bool> InsertUpdateParc_Desc_Srv(Parc_Desc aParc_Desc) async {
    String wSql = 'INSERT INTO Parcs_Desc(ParcsDescId, ParcsDesc_ParcsId, ParcsDesc_Type, ParcsDesc_Id, ParcsDesc_Lib) VALUES ('
        'NULL ,  ${aParc_Desc.ParcsDesc_ParcsId},'
        '"${aParc_Desc.ParcsDesc_Type}",'
        '"${aParc_Desc.ParcsDesc_Id}",'
        '"${aParc_Desc.ParcsDesc_Lib}")';
    print("InsertUpdateParc_Desc_Srv " + wSql);
    bool ret = await add_API_Post("upddel", wSql);
    print("InsertUpdateParc_Desc_Srv ret " + ret.toString());
    return ret;
  }

  static Future<bool> InsertUpdateParc_Desc_Srv_Srv(Parc_Desc_Srv aParc_Desc) async {
    String wSql = 'INSERT INTO Parcs_Desc(ParcsDescId, ParcsDesc_ParcsId, ParcsDesc_Type, ParcsDesc_Id, ParcsDesc_Lib) VALUES ('
        'NULL ,  ${aParc_Desc.ParcsDesc_ParcsId},'
        '"${aParc_Desc.ParcsDesc_Type}",'
        '"${aParc_Desc.ParcsDesc_Id}",'
        '"${aParc_Desc.ParcsDesc_Lib}")';
    print("InsertUpdateParc_Desc_Srv_Srv " + wSql);
    bool ret = await add_API_Post("upddel", wSql);
    print("InsertUpdateParc_Desc_Srv_Srv ret " + ret.toString());
    return ret;
  }

  static String InsertUpdateParc_Desc_Srv_GetSql(Parc_Desc aParc_Desc) {
    String wSql = 'INSERT INTO Parcs_Desc(ParcsDescId, ParcsDesc_ParcsId, ParcsDesc_Type, ParcsDesc_Id, ParcsDesc_Lib) VALUES ('
        'NULL ,  ${aParc_Desc.ParcsDesc_ParcsId},'
        '"${aParc_Desc.ParcsDesc_Type}",'
        '"${aParc_Desc.ParcsDesc_Id}",'
        '"${aParc_Desc.ParcsDesc_Lib}")';
//    print("InsertUpdateParc_Desc_Srv_GetSql " + wSql);
    return wSql;
  }

  static Future<bool> InsertUpdateParc_Desc_Srv_Sql(String wSql) async {
//    gColors.printWrapped("InsertUpdateParc_Desc_Srv_Sql " + wSql);
    bool ret = await add_API_Post("multi", wSql);
//    gColors.printWrapped("InsertUpdateParc_Desc_Srv_Sql ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_Desc(int Parcs_InterventionId) async {
    String wValue = "NULL, $Parcs_InterventionId";
    String wSlq = "INSERT INTO Parcs_Desc (ParcsId, Parcs_InterventionId) VALUES ($wValue)";
    print("addParc_Desc " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Desc ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Desc(Parc_Desc_Srv Parc_Desc) async {
    String aSQL = "DELETE FROM Parcs_Desc WHERE Parc_DescId = ${Parc_Desc.ParcsDescId} ";
    print("delParc_Desc " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Desc ret " + ret.toString());
    return ret;
  }

  static Future<List<Parc_Desc_Srv>> getParc_Desc_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
//      print("items $items");

      if (items != null) {
        List<Parc_Desc_Srv> Parc_DescList = await items.map<Parc_Desc_Srv>((json) {
          return Parc_Desc_Srv.fromJson(json);
        }).toList();
        return Parc_DescList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   Parcs_Art   ***************
  //******************************************

  static List<Parc_Art_Srv> ListParc_Art = [];
  static List<Parc_Art_Srv> ListParc_ArtSO = [];
  static List<Parc_Art_Srv> ListParc_Artsearchresult = [];
  static Parc_Art_Srv gParc_Art = Parc_Art_Srv(0, 0, "", "", "", "", "", "", 0);

  static Future<bool> getParc_ArtAll() async {
    ListParc_Art = await getParc_Art_API_Post("select", "select * from Parcs_Art ORDER BY Parcs_Type");

    if (ListParc_Art == null) return false;
    print("getParc_ArtAll ${ListParc_Art.length}");
    if (ListParc_Art.length > 0) {
      print("getParc_ArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_ArtID(int ID) async {
    ListParc_Art.forEach((element) {
      if (element.ParcsArtId == ID) {
        gParc_Art = element;
        return;
      }
    });
  }

  static Future<bool> getParcs_ArtInter(int Parcs_InterventionId) async {
    try {
      ListParc_Art = await getParc_Art_API_Post("select", "SELECT Parcs_Art.* FROM Parcs_Art, Parcs_Ent  WHERE ParcsArt_ParcsId = ParcsId AND Parcs_InterventionId = $Parcs_InterventionId");
      if (ListParc_Art == null) return false;
      if (ListParc_Art.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getParcs_ArtInterSO(int Parcs_InterventionId) async {
    try {
      ListParc_ArtSO = await getParc_Art_API_Post("select", "SELECT Parcs_Art.* FROM Parcs_Art WHERE ParcsArt_lnk = 'SO' AND ParcsArt_ParcsId  = $Parcs_InterventionId");
      if (ListParc_ArtSO == null) return false;
      if (ListParc_ArtSO.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }




  static Future<bool> setParc_Art(Parc_Art_Srv Parc_Art) async {
    String wSlq = "UPDATE Parcs_Art SET "
            "ParcsArtId            =   ${Parc_Art.ParcsArtId}, " +
        "ParcsArt_ParcsId      =   ${Parc_Art.ParcsArt_ParcsId}, " +
        "ParcsArt_Id         = \"${Parc_Art.ParcsArt_Id}\", " +
        "ParcsArt_Type           = \"${Parc_Art.ParcsArt_Type}\", " +
        "ParcsArt_lnk           = \"${Parc_Art.ParcsArt_lnk}\", " +
        "ParcsArt_Fact           = \"${Parc_Art.ParcsArt_Fact}\", " +
        "ParcsArt_Livr           = \"${Parc_Art.ParcsArt_Livr}\", " +
        "ParcsArt_Qte      =   ${Parc_Art.ParcsArt_Qte}";

    gColors.printWrapped("setParc_Art " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Art ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Art_Srv(int aParcsDesc_ParcsId) async {
    String aSQL = "DELETE FROM Parcs_Art WHERE ParcsDesc_ParcsId = ${aParcsDesc_ParcsId} ";
    print("delParc_Art_Srv " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Art_Srv ret " + ret.toString());
    return ret;
  }

  static String InsertUpdateParc_Art_Srv_GetSql(Parc_Art aParc_Art) {
    String wSql = "INSERT INTO Parcs_Art("
        "ParcsArtId, "
        "ParcsArt_ParcsId, "
        "ParcsArt_Id, "
        "ParcsArt_Type, "
        "ParcsArt_lnk, "
        "ParcsArt_Fact, "
        "ParcsArt_Livr, "
        "ParcsArt_Lib, "
        "ParcsArt_Qte"
        ") VALUES ("
        "NULL ,  "
        "${aParc_Art.ParcsArt_ParcsId},"
        "'${aParc_Art.ParcsArt_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_Type!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_lnk!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_Fact!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_Livr!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_Lib!.replaceAll("'", "‘")}',"
        "${aParc_Art.ParcsArt_Qte}"
        ")";
    return wSql;
  }

  static Future<bool> InsertUpdateParc_Art_Srv_Sql(String wSql) async {
    print("InsertUpdateParc_Art_Srv_Sql " + wSql);
    bool ret = await add_API_Post("multi", wSql);
    print("InsertUpdateParc_Art_Srv_Sql ret " + ret.toString());
    return ret;
  }

  static Future<bool> InsertUpdateParc_Art_Srv(Parc_Art aParc_Art) async {
    String wSql = "INSERT INTO Parcs_Art("
        "ParcsArtId, "
        "ParcsArt_ParcsId, "
        "ParcsArt_Id, "
        "ParcsArt_Type, "
        "ParcsArt_lnk, "
        "ParcsArt_Fact, "
        "ParcsArt_Livr, "
        "ParcsArt_Lib, "
        "ParcsArt_Qte"
        ") VALUES ("
        "NULL ,  "
        "${aParc_Art.ParcsArt_ParcsId},"
        "'${aParc_Art.ParcsArt_Id!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_Type!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_lnk!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_Fact!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_Livr!.replaceAll("'", "‘")}',"
        "'${aParc_Art.ParcsArt_Lib!.replaceAll("'", "‘")}',"
        "${aParc_Art.ParcsArt_Qte}"
        ")";
    print("setParc_Art " + wSql);
    bool ret = await add_API_Post("upddel", wSql);
    //  print("setParc_Art ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_Art(int Parcs_InterventionId) async {
    String wValue = "NULL, $Parcs_InterventionId";
    String wSlq = "INSERT INTO Parcs_Art (ParcsId, Parcs_InterventionId) VALUES ($wValue)";
    print("addParc_Art " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Art ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Art(Parc_Art_Srv Parc_Art) async {
    String aSQL = "DELETE FROM Parcs_Art WHERE Parc_ArtId = ${Parc_Art.ParcsArtId} ";
    print("delParc_Art " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Art ret " + ret.toString());
    return ret;
  }

  static Future<List<Parc_Art_Srv>> getParc_Art_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Parc_Art_Srv> Parc_ArtList = await items.map<Parc_Art_Srv>((json) {
          return Parc_Art_Srv.fromJson(json);
        }).toList();
        return Parc_ArtList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }


  //******************************************
  //************   Parcs_Imgs   ***************
  //******************************************

  static List<Parc_Imgs_Srv> ListParc_Imgs = [];
  static List<Parc_Imgs_Srv> ListParc_Imgssearchresult = [];
  static Parc_Imgs_Srv gParc_Imgs = Parc_Imgs_Srv(0,0,0,"","");
  
  static Future<bool> getParc_ImgsAll() async {
    ListParc_Imgs = await getParc_Imgs_API_Post("select", "select * from Parcs_Imgs ORDER BY Parcs_Type");

    if (ListParc_Imgs == null) return false;
    print("getParc_ImgsAll ${ListParc_Imgs.length}");
    if (ListParc_Imgs.length > 0) {
      print("getParc_ImgsAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_ImgsID(int ID) async {
    ListParc_Imgs.forEach((element) {
      if (element.Parc_Imgid == ID) {
        gParc_Imgs = element;
        return;
      }
    });
  }

  static Future<bool> getParcs_ImgsInter(int Parcs_InterventionId) async {
    try {

      print(" getParcs_ImgsInter SELECT Parcs_Imgs.* FROM Parcs_Imgs, Parcs_Ent  WHERE Parc_Imgs_ParcsId = ParcsId AND Parcs_InterventionId = $Parcs_InterventionId");

      ListParc_Imgs = await getParc_Imgs_API_Post("select", "SELECT Parcs_Imgs.* FROM Parcs_Imgs, Parcs_Ent  WHERE Parc_Imgs_ParcsId = ParcsId AND Parcs_InterventionId = $Parcs_InterventionId");
      if (ListParc_Imgs == null) return false;
      if (ListParc_Imgs.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }


  static Future<bool> setParc_Imgs(Parc_Imgs_Srv Parc_Imgs) async {
    String wSlq = "UPDATE Parcs_Imgs SET "
        "Parc_Imgid            =   ${Parc_Imgs.Parc_Imgid}, " +
        "Parc_Imgs_ParcsId      =   ${Parc_Imgs.Parc_Imgs_ParcsId}, " +
        "Parc_Imgs_Type      =   ${Parc_Imgs.Parc_Imgs_Type}, " +
        "Parc_Imgs_Data         = \"${Parc_Imgs.Parc_Imgs_Data}\", " +
        "Parc_Imgs_Path           = \"${Parc_Imgs.Parc_Imgs_Path}\" ";

    gColors.printWrapped("setParc_Imgs " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Imgs ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Imgs_Srv(int Parc_Imgid) async {
    String aSQL = "DELETE FROM Parcs_Imgs WHERE Parc_Imgid = ${Parc_Imgid} ";
    print("delParc_Imgs_Srv " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Imgs_Srv ret " + ret.toString());
    return ret;
  }


  int?    Parc_Imgid = 0;
  int?    Parc_Imgs_ParcsId = 0;
  int?    Parc_Imgs_Type = 0;
  String? Parc_Imgs_Data = "";
  String? Parc_Imgs_Path = "";


  static String InsertUpdateParc_Imgs_Srv_GetSql(Parc_Img aParc_Imgs) {
    String wSql = "INSERT INTO Parcs_Imgs("
        "Parc_Imgid, "
        "Parc_Imgs_ParcsId, "
        "Parc_Imgs_Type, "
        "Parc_Imgs_Data, "
        "Parc_Imgs_Path "
        ") VALUES ("
        "NULL ,  "
        "${aParc_Imgs.Parc_Imgid},"
        "${aParc_Imgs.Parc_Imgs_ParcsId},"
        "${aParc_Imgs.Parc_Imgs_Type},"
        "'${aParc_Imgs.Parc_Imgs_Data!.replaceAll("'", "‘")}',"
        "'${aParc_Imgs.Parc_Imgs_Path!.replaceAll("'", "‘")}' "
        ")";
    return wSql;
  }

  static Future<bool> InsertUpdateParc_Imgs_Srv_Sql(String wSql) async {
    print("InsertUpdateParc_Imgs_Srv_Sql " + wSql);
    bool ret = await add_API_Post("multi", wSql);
    print("InsertUpdateParc_Imgs_Srv_Sql ret " + ret.toString());
    return ret;
  }

  static Future<bool> InsertUpdateParc_Imgs_Srv(Parc_Img aParc_Imgs) async {
    String wSql = "INSERT INTO Parcs_Imgs("
        "Parc_Imgid, "
        "Parc_Imgs_ParcsId, "
        "Parc_Imgs_Type, "
        "Parc_Imgs_Data, "
        "Parc_Imgs_Path "
        ") VALUES ("
        "NULL ,  "
        "${aParc_Imgs.Parc_Imgs_ParcsId},"
        "${aParc_Imgs.Parc_Imgs_Type},"
        "'${aParc_Imgs.Parc_Imgs_Data!.replaceAll("'", "‘")}',"
        "'${aParc_Imgs.Parc_Imgs_Path!.replaceAll("'", "‘")}' "
        ")";
//    print("setParc_Imgs " + wSql);
    bool ret = await add_API_Post("upddel", wSql);
    //  print("setParc_Imgs ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_Imgs(int Parcs_InterventionId) async {
    String wValue = "NULL, $Parcs_InterventionId";
    String wSlq = "INSERT INTO Parcs_Imgs (ParcsId, Parcs_InterventionId) VALUES ($wValue)";
    print("addParc_Imgs " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Imgs ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Imgs(Parc_Imgs_Srv Parc_Imgs) async {
    String aSQL = "DELETE FROM Parcs_Imgs WHERE Parc_ImgsId = ${Parc_Imgs.Parc_Imgid} ";
    print("delParc_Imgs " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Imgs ret " + ret.toString());
    return ret;
  }

  static Future<List<Parc_Imgs_Srv>> getParc_Imgs_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Parc_Imgs_Srv> Parc_ImgsList = await items.map<Parc_Imgs_Srv>((json) {
          return Parc_Imgs_Srv.fromJson(json);
        }).toList();
        return Parc_ImgsList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }
  
  
  //******************************************
  //************   CONTACTS   ****************
  //******************************************

  static List<Contact> ListContact = [];
  static List<Contact> ListContactsearchresult = [];
  static Contact gContact = Contact.ContactInit();
  static Contact gContactLivr = Contact.ContactInit();

  static Future<bool> getContactAll() async {
    try {
      ListContact = await getContact_API_Post("select", "select * from Contacts ORDER BY Contact_Type");
      if (ListContact == null) return false;
      if (ListContact.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getContactClientAdrType(int ClientID, int AdresseId, String Type) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $ClientID AND Contact_AdresseId = $AdresseId AND Contact_Type = '$Type' ORDER BY Contact_Type";
    print("getContactClientAdrType ${wSlq}");

    try {
      ListContact = await getContact_API_Post("select", wSlq);
      print("getContact_API_Post ");
      if (ListContact == null) return false;
      print("getContact_API_Post ${ListContact.length}");
      if (ListContact.length > 0) {
        gContact = ListContact[0];
        print("getContact_API_Post return TRUE ${gContact.ContactId} ${gContact.Contact_Nom}");
        return true;
      } else {
        bool wRes = await DbTools.getContactClientAdrType(ClientID, AdresseId, Type);
        if (!wRes) {
          await addContactAdrType(ClientID, AdresseId, Type);
          await getContactClientAdrType(ClientID, AdresseId, Type);
        }
        return wRes;
      }

    } catch (e) {
      bool wRes = await DbTools.getContactClientAdrType(ClientID, AdresseId, Type);
      if (!wRes) {
        await addContactAdrType(ClientID, AdresseId, Type);
        await getContactClientAdrType(ClientID, AdresseId, Type);
      }
      return false;
    }
  }

  static Future<bool> getContactClient(int ClientID) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $ClientID ORDER BY Contact_Type";
//    print("getContactClientType ${wSlq}");

    ListContact = await getContact_API_Post("select", wSlq);
    if (ListContact == null) return false;
    //  print("getContactClientType ${ListContact.length}");
    if (ListContact.length > 0) {
      gContact = ListContact[0];
      //  print("getContactClientType return TRUE");
      return true;
    } else {}
    return false;
  }

  static Future getContactID(int ID) async {
    ListContact.forEach((element) {
      if (element.ContactId == ID) {
        gContact = element;
        return;
      }
    });
  }

  static Future<bool> setContact(Contact Contact) async {
    String wSlq = "UPDATE Contacts SET "
            "Contact_ClientId     =   ${Contact.Contact_ClientId}, " +
        "Contact_AdresseId     =   ${Contact.Contact_AdresseId}, " +
        "Contact_Code             = \"${Contact.Contact_Code}\", " +
        "Contact_Type             = \"${Contact.Contact_Type}\", " +
        "Contact_Nom              = \"${Contact.Contact_Nom}\", " +
        "Contact_Civilite         = \"${Contact.Contact_Civilite}\", " +
        "Contact_Prenom           = \"${Contact.Contact_Prenom}\", " +
        "Contact_Fonction         = \"${Contact.Contact_Fonction}\", " +
        "Contact_Service          = \"${Contact.Contact_Service}\", " +
        "Contact_Tel1             = \"${Contact.Contact_Tel1}\", " +
        "Contact_Tel2             = \"${Contact.Contact_Tel2}\", " +
        "Contact_eMail            = \"${Contact.Contact_eMail}\", " +
        "Contact_Rem              = \"${Contact.Contact_Rem}\" " +
        "WHERE ContactId      = ${Contact.ContactId.toString()}";

    gColors.printWrapped("setContact sql " + wSlq);
    try {
      bool ret = await add_API_Post("upddel", wSlq);
      print("setContact ret " + ret.toString());
      return ret;
    } catch (e) {
      print("setContact ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> addContactAdrType(int Contact_ClientId, int Contact_AdresseId, String Type) async {
    String wValue = "NULL, $Contact_ClientId, $Contact_AdresseId, '$Type'";
    String wSlq = "INSERT INTO Contacts (ContactId, Contact_ClientId, Contact_AdresseId, Contact_Type) VALUES ($wValue)";
    print("addContact " + wSlq);
    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addContact ret " + ret.toString());
      return ret;
    } catch (e) {
      print("addContact ERROR " + e.toString());
      return false;
    }
  }

  static Future<bool> addContact(int Contact_ClientId) async {
    String wValue = "NULL, $Contact_ClientId";
    String wSlq = "INSERT INTO Contacts (ContactId, Contact_ClientId) VALUES ($wValue)";
    print("addContact " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addContact ret " + ret.toString());
    return ret;
  }

  static Future<bool> getContactGrp(int contactClientid, int contactAdresseid) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $contactClientid AND Contact_AdresseId = $contactAdresseid AND Contact_Type = 'GRP' ORDER BY Contact_Type";
    try {
      ListContact = await getContact_API_Post("select", wSlq);
      if (ListContact == null) return false;
      if (ListContact.length > 0) {
        gContact = ListContact[0];
        return true;
      }      return false;
    } catch (e) {
      return false;
    }



  }

  static Future<bool> getContactSite(int contactClientid, int contactAdresseid) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $contactClientid AND Contact_AdresseId = $contactAdresseid AND Contact_Type = 'SITE' ORDER BY Contact_Type";

    ListContact = await getContact_API_Post("select", wSlq);

    if (ListContact == null) return false;
    //  print("getContactClientType ${ListContact.length}");
    if (ListContact.length > 0) {
      gContact = ListContact[0];
      //  print("getContactClientType return TRUE");
      return true;
    } else {}
    return false;
  }

  static Future<bool> delContact(Contact Contact) async {
    String aSQL = "DELETE FROM Contacts WHERE ContactId = ${Contact.ContactId} ";
    print("delContact " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delContact ret " + ret.toString());
    return ret;
  }

  static Future<List<Contact>> getContact_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<Contact> ContactList = await items.map<Contact>((json) {
          return Contact.fromJson(json);
        }).toList();
        return ContactList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   ARTICLE   *****************
  //******************************************

  static List<Art> ListArt = [];
  static List<Art> ListArtsearchresult = [];
  static Art gArt = Art.ArtInit();

  static Future<bool> getArtAllFam() async {
    ListArt = await getArt_API_Post("select", "select * from Articles ORDER BY Art_Fam , Art_Sous_Fam, Art_Lib");
    if (ListArt == null) return false;
    print("getArtAll ${ListArt.length}");
    if (ListArt.length > 0) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getArtAll() async {
    ListArt = await getArt_API_Post("select", "select * from Articles ORDER BY Art_Lib");
    if (ListArt == null) return false;
    print("getArtAll ${ListArt.length}");
    if (ListArt.length > 0) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getArtAll_A() async {
    ListArt = await getArt_API_Post("select", "select * from Articles WHERE Art_Id LIKE 'A%'  ORDER BY Art_Lib");
    if (ListArt == null) return false;
    print("getArtAll ${ListArt.length}");
    if (ListArt.length > 0) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getArtAll_S() async {
    ListArt = await getArt_API_Post("select", "select * from Articles WHERE Art_Id LIKE 'S%' ORDER BY Art_Lib");
    if (ListArt == null) return false;
    print("getArtAll ${ListArt.length}");
    if (ListArt.length > 0) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getArtAll_E() async {
    ListArt = await getArt_API_Post("select", "select * from Articles WHERE Art_Id LIKE 'E%'  ORDER BY Art_Lib");
    if (ListArt == null) return false;
    print("getArtAll ${ListArt.length}");
    if (ListArt.length > 0) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  String Art_PDT = "";
  String Art_Grp = "";
  int Art_Ordre = 0;

  String Art_Groupe = "";
  String Art_Fam = "";
  String Art_Sous_Fam = "";
  String Art_Id = "";
  String Art_Lib = "";
  int Art_Stock = 0;

  static Future<bool> setArt(Art Art) async {
    String wSlq = "UPDATE Articles SET "
            "Art_Groupe = \"${Art.Art_Groupe}\", " +
        "Art_Fam = \"${Art.Art_Fam}\", " +
        "Art_Sous_Fam = \"${Art.Art_Sous_Fam}\", " +
        "Art_Id = \"${Art.Art_Id}\", " +
        "Art_Lib = \"${Art.Art_Lib}\", " +
        "Art_Stock = ${Art.Art_Stock.toString()} "
            "WHERE ArtId = ${Art.ArtId.toString()}";
    gColors.printWrapped("setArt " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setArt ret " + ret.toString());
    return ret;
  }

  static Future<bool> addArt(Art Art) async {
    String wValue = "NULL,'???','???','???','???','---', 0";
    String wSlq = "INSERT INTO Articles (ArtId, Art_Groupe  ,Art_Fam     ,Art_Sous_Fam,Art_Id      ,Art_Lib     ,Art_Stock) VALUES ($wValue)";
    print("addArt " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addArt ret " + ret.toString());
    return ret;
  }

  static Future<bool> delArt(Art Art) async {
    String aSQL = "DELETE FROM Articles WHERE ArtId = ${Art.ArtId} ";
    print("delArt " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delArt ret " + ret.toString());
    return ret;
  }

  static Future<List<Art>> getArt_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Art> ArtList = await items.map<Art>((json) {
          return Art.fromJson(json);
        }).toList();
        return ArtList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //****************************************************
  //************************  USERS  *******************
  //****************************************************

  static List<User> ListUser = [];
  static List<User> ListUsersearchresult = [];
  static User gUser = User.UserInit();
  static User gUserLogin = User.UserInit();
  static int gLoginID = -1;

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> getUserLogin(String aMail, String aPW) async {
    gObj.wImage = Image(
      image: AssetImage('assets/images/Avatar.png'),
      height: 100,
    );

    print("getUserLogin A");

    List<User> ListUser = [];
    try {
      String wSql = "select * from Users where User_Mail = '$aMail' AND User_PassWord = '$aPW' AND User_Actif = true";
      print("getUserLogin B ${wSql}");
      ListUser = await getUser_API_Post("select", wSql);
      print("getUserLogin C");
      if (ListUser == null) return false;
      print("getUserLogin D");
    } catch (e) {
      List<User> wListUser = await DbTools.getUsers();
      if (wListUser.length == 0) return false;
      gUserLogin = wListUser[0];
      gLoginID = gUserLogin.UserID;
      Srv_DbTools.ListUser_Hab = await DbTools.getUser_Hab();
      Srv_DbTools.ListUser_Desc = await DbTools.getUser_Desc();
      String wPicUser = await SharedPref.getStrKey("picUser", "");
      gObj.picUser = base64Decode(wPicUser);

      if (gObj.pic.length > 0) {
        gObj.wImage = Image.memory(
          gObj.picUser,
          fit: BoxFit.scaleDown,
          width: 100,
          height: 100,
        );
      }

      return true;
    }

    print("getUserLogin E ${ListUser.length}");

    if (ListUser.length == 1) {
      gUserLogin = ListUser[0];
      await DbTools.inserUsers();
      List<User> wListUser = await DbTools.getUsers();
      print("wListUser ${wListUser.length}");
      gLoginID = gUserLogin.UserID;

      print("gUserLogin ${gUserLogin.User_Actif}");

      String wImgPath = "${SrvImg}User_${gUserLogin.User_Matricule}.jpg";

      print("wImgPath ${wImgPath}");
      gObj.picUser = await gObj.networkImageToByte(wImgPath);
      await SharedPref.setStrKey("picUser", base64Encode(gObj.picUser));
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      await SharedPref.setIntKey("timestampLogin", timestamp);

      print("gObj.picUser ${gObj.picUser.length}");

      if (gObj.pic.length > 0) {
        gObj.wImage = Image.memory(
          gObj.picUser,
          fit: BoxFit.scaleDown,
          width: 100,
          height: 100,
        );
      }

      await Srv_DbTools.getUser_Hab(Srv_DbTools.gLoginID);
      print("Import_DataDialog ListUser_Hab ${Srv_DbTools.ListUser_Hab.length}");
      await DbTools.TrunckUser_Hab();
      for (int i = 0; i < Srv_DbTools.ListUser_Hab.length; i++) {
        User_Hab wUser_Hab = Srv_DbTools.ListUser_Hab[i];
        await DbTools.inserUser_Hab(wUser_Hab);
      }
      Srv_DbTools.ListUser_Hab = await DbTools.getUser_Hab();

      await Srv_DbTools.getUser_Desc(Srv_DbTools.gLoginID);
      print("Import_DataDialog ListUser_Desc ${Srv_DbTools.ListUser_Desc.length}");
      await DbTools.TrunckUser_Desc();
      for (int i = 0; i < Srv_DbTools.ListUser_Desc.length; i++) {
        User_Desc wUser_Desc = Srv_DbTools.ListUser_Desc[i];
        await DbTools.inserUser_Desc(wUser_Desc);
      }
      Srv_DbTools.ListUser_Desc = await DbTools.getUser_Desc();

      return true;
    }

    return false;
  }

  static Future<bool> getUserName(String aName) async {
    List<User> ListUser = await getUser_API_Post("select", "select * from Users where User_Nom = '$aName'");

    if (ListUser == null) return false;

    print("getUserName ${ListUser.length}");

    if (ListUser.length > 0) {
      print("getUserName return TRUE");

      return true;
    }

    return false;
  }

  static Future<bool> getUserAll() async {
    try {
      ListUser = await getUser_API_Post("select", "select * from Users WHERE User_Actif = 1 ORDER BY User_Nom");
      if (ListUser == null) return false;
      if (ListUser.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getUserid(String id) async {
    print(">>>>> getUserid $id");
    List<User> ListUser = await getUser_API_Post("select", "select * from Users where UserID = $id ");
    print("<<<<< getUserid");

    print(">>>>>>>>>>>>>> ListPost ${ListUser.length}");

    if (ListUser == null) return false;

    if (ListUser.length == 1) {
      gUser = ListUser[0];
      return true;
    }
    return false;
  }


  static Future<bool> getUserMat(String id) async {
    print(">>>>> getUserid $id");
    List<User> ListUser = await getUser_API_Post("select", "select * from Users where User_Matricule = $id ");
    print("<<<<< getUserid");

    print(">>>>>>>>>>>>>> ListPost ${ListUser.length}");

    if (ListUser == null) return false;

    if (ListUser.length == 1) {
      gUser = ListUser[0];
      return true;
    }
    return false;
  }



  static Future<List<User>> getUser_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());

      final items = parsedJson['data'];
      if (items != null) {
        List<User> UserList = await items.map<User>((json) {
          return User.fromJson(json);
        }).toList();

        return UserList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<bool> setUser(User User) async {
    String wSlq = "UPDATE Users SET "
            "User_Nom = \"" +
        User.User_Nom +
        "\", " +
        "User_Mail = \"" +
        User.User_Mail +
        "\", " +
        "User_Token_FBM = \"" +
        Token_FBM +
        "\" " +
        " WHERE UserID = " +
        User.UserID.toString();
    print("setUser " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setUser ret " + ret.toString());
    return ret;
  }

  static Future<bool> addUser(User User) async {
    print("User.User_Token_FBM " + Token_FBM);

    String wValue = 'NULL,' +
        User.User_Actif.toString() +
        ' ,"' +
        Token_FBM +
        '",   "' +
        simCountryCode +
        '",   "' +
        User.User_Nom +
        '", "' +
        User.User_Prenom +
        ' ", "' +
        User.User_Adresse1 +
        '", "' +
        User.User_Adresse2 +
        '", "' +
        User.User_Cp +
        '", "' +
        User.User_Ville +
        ' ", "' +
        User.User_Tel +
        ' ", "' +
        User.User_Mail +
        '"'
            ', "' +
        User.User_PassWord +
        '"';
    String wSlq = "INSERT INTO Users ("
        "UserID,User_AuthID,User_Actif,User_Verif,User_Verif_Demande,User_Abus,User_Token_FBM,User_simCountryCode,User_NickName,User_Nom,User_Prenom,User_Adresse1,User_Adresse2,User_Cp,User_Ville,User_Tel,User_Mail,User_PassWord,User_DateNaissance,User_Note,User_Sexe) "
        "VALUES ($wValue)";
    print("addUser " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addUser ret " + ret.toString());
    return ret;
  }

  //*****************************
  //*****************************
  //*****************************

  static List<User_Hab> ListUser_Hab = [];
  static List<User_Hab> ListUser_Habsearchresult = [];
  static User_Hab gUser_Hab = User_Hab.User_HabInit();

  static Future<bool> getUser_Hab(int User_Hab_UserID) async {
    ListUser_Hab = await getUser_Hab_API_Post("select", "select Users_Hab.*, Param_Hab_PDT, Param_Hab_Grp from Users_Hab, Param_Hab where User_Hab_Param_HabID = Param_HabID AND User_Hab_UserID = $User_Hab_UserID ORDER BY User_Hab_Ordre,User_HabID");
    if (ListUser_Hab == null) return false;

    if (ListUser_Hab.length > 0) {
      return true;
    }
    return false;
  }

  static int Hab_PDT = 0;
  static bool IsComplet = false;

  static bool User_Hab_MaintPrev = false;
  static bool User_Hab_MaintCorrect = false;
  static bool User_Hab_Install = false;

  static void getUser_Hab_PDT(String PDT) {
    Hab_PDT = 0;

    User_Hab_MaintPrev = true;
    User_Hab_MaintCorrect = true;
    User_Hab_Install = true;

    for (int i = 0; i < ListUser_Hab.length; i++) {
      User_Hab user_Hab = ListUser_Hab[i];

      if (user_Hab.Param_Hab_PDT.compareTo(PDT) == 0) {
        if (user_Hab.User_Hab_MaintPrev) Hab_PDT = 1;
        if (user_Hab.User_Hab_MaintCorrect) Hab_PDT = 2;
        if (user_Hab.User_Hab_Install) Hab_PDT = 3;

        User_Hab_MaintPrev = user_Hab.User_Hab_MaintPrev;
        User_Hab_MaintCorrect = user_Hab.User_Hab_MaintCorrect;
        User_Hab_Install = user_Hab.User_Hab_Install;

        return;
      }
    }
  }

  static Future<List<User_Hab>> getUser_Hab_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<User_Hab> User_HabList = await items.map<User_Hab>((json) {
          return User_Hab.fromJson(json);
        }).toList();
        return User_HabList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }



  //*****************************
  //*****************************
  //*****************************

  static List<SrvParam_Av> ListParam_Av = [];
  static List<SrvParam_Av> ListParam_Avsearchresult = [];

  static Future<bool> getParam_Av(int Param_Av_UserID) async {
    ListParam_Av = await getParam_Av_API_Post("select", "select * from Param_Av ORDER BY Param_AvID");
    if (ListParam_Av == null) return false;
    return false;
  }

  static Future<List<SrvParam_Av>> getParam_Av_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<SrvParam_Av> Param_AvList = await items.map<SrvParam_Av>((json) {
          return SrvParam_Av.fromJson(json);
        }).toList();
        return Param_AvList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<User_Desc> ListUser_Desc = [];
  static List<User_Desc> ListUser_Descsearchresult = [];
  static User_Desc gUser_Desc = User_Desc.User_DescInit();

  static Future<bool> getUser_Desc(int User_Desc_UserID) async {
    ListUser_Desc = await getUser_Desc_API_Post("select", "SELECT Users_Desc.*, Param_Saisie_Param_Label FROM Users_Desc, Param_Saisie_Param WHERE User_Desc_Param_DescID = Param_Saisie_ParamId AND Param_Saisie_Param_Id = 'DESC' AND User_Desc_UserID = $User_Desc_UserID");
    if (ListUser_Desc == null) return false;

    return false;
  }

  static int Hab_Desc = 0;
  static bool User_Desc_MaintPrev = false;
  static bool User_Desc_MaintCorrect = false;
  static bool User_Desc_Install = false;

  static void getUser_Hab_Desc(int DescID) {
    Hab_Desc = 0;
    User_Desc_MaintPrev = true;
    User_Desc_MaintCorrect = true;
    User_Desc_Install = true;

    for (int i = 0; i < ListUser_Desc.length; i++) {
      User_Desc user_Desc = ListUser_Desc[i];

      if (user_Desc.User_Desc_Param_DescID == DescID) {
        if (user_Desc.User_Desc_MaintPrev) Hab_Desc = 1;
        if (user_Desc.User_Desc_MaintCorrect) Hab_Desc = 2;
        if (user_Desc.User_Desc_Install) Hab_Desc = 3;

        User_Desc_MaintPrev = user_Desc.User_Desc_MaintPrev;
        User_Desc_MaintCorrect = user_Desc.User_Desc_MaintCorrect;
        User_Desc_Install = user_Desc.User_Desc_Install;
      }
    }
  }

  static Future<List<User_Desc>> getUser_Desc_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<User_Desc> User_DescList = await items.map<User_Desc>((json) {
          return User_Desc.fromJson(json);
        }).toList();
        return User_DescList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

//************************************************
//******************** Param_Saisie ***************
//************************************************

  static List<Param_Saisie> ListParam_Saisie = [];
  static List<Param_Saisie> ListParam_Saisiesearchresult = [];
  static Param_Saisie gParam_Saisie = Param_Saisie.Param_SaisieInit();
  static List<Param_Saisie> ListParam_Saisie_Base = [];
  static List<Param_Saisie> ListParam_Audit_Base = [];
  static List<Param_Saisie> ListParam_Verif_Base = [];

  static List<Param_Saisie> ListParam_Interv_Base = [];

  static int affSortComparison(Param_Saisie a, Param_Saisie b) {
    final Param_Saisie_Ordre_AffichageA = a.Param_Saisie_Ordre;
    final Param_Saisie_Ordre_AffichageB = b.Param_Saisie_Ordre;
    if (Param_Saisie_Ordre_AffichageA < Param_Saisie_Ordre_AffichageB) {
      return -1;
    } else if (Param_Saisie_Ordre_AffichageA > Param_Saisie_Ordre_AffichageB) {
      return 1;
    } else {
      return 0;
    }
  }

  static int affSort2Comparison(Param_Saisie a, Param_Saisie b) {
    final Param_Saisie_Ordre_AffichageA = a.Param_Saisie_Ordre_Affichage;
    final Param_Saisie_Ordre_AffichageB = b.Param_Saisie_Ordre_Affichage;
    if (Param_Saisie_Ordre_AffichageA < Param_Saisie_Ordre_AffichageB) {
      return -1;
    } else if (Param_Saisie_Ordre_AffichageA > Param_Saisie_Ordre_AffichageB) {
      return 1;
    } else {
      return 0;
    }
  }

  static int affL1SortComparison(Param_Saisie a, Param_Saisie b) {
    final Param_Saisie_Ordre_AffichageA = a.Param_Saisie_Affichage_L1_Ordre;
    final Param_Saisie_Ordre_AffichageB = b.Param_Saisie_Affichage_L1_Ordre;
    if (Param_Saisie_Ordre_AffichageA < Param_Saisie_Ordre_AffichageB) {
      return -1;
    } else if (Param_Saisie_Ordre_AffichageA > Param_Saisie_Ordre_AffichageB) {
      return 1;
    } else {
      return 0;
    }
  }

  static int affL2SortComparison(Param_Saisie a, Param_Saisie b) {
    final Param_Saisie_Ordre_AffichageA = a.Param_Saisie_Affichage_L2_Ordre;
    final Param_Saisie_Ordre_AffichageB = b.Param_Saisie_Affichage_L2_Ordre;
    if (Param_Saisie_Ordre_AffichageA < Param_Saisie_Ordre_AffichageB) {
      return -1;
    } else if (Param_Saisie_Ordre_AffichageA > Param_Saisie_Ordre_AffichageB) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future<bool> getParam_SaisieAll() async {
    ListParam_Saisie = await getParam_Saisie_API_Post("select", "select * from Param_Saisie ORDER BY Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_Ordre,Param_Saisie_ID");
    if (ListParam_Saisie == null) return false;
    print("getParam_SaisieAll ${ListParam_Saisie.length}");
    if (ListParam_Saisie.length > 0) {
      return true;
    }
    return false;
  }

  static Future<bool> getParam_Saisie(String Param_Saisie_Organe, String Param_Saisie_Type) async {

    ListParam_Saisie.clear();
    try {
      ListParam_Saisie = await getParam_Saisie_API_Post("select", "select * from Param_Saisie WHERE Param_Saisie_Organe = '${Param_Saisie_Organe}' AND Param_Saisie_Type = '${Param_Saisie_Type}'  ORDER BY Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_Ordre,Param_Saisie_ID");


      if (ListParam_Saisie == null) return false;
      if (ListParam_Saisie.length > 0) {
        int i = 1;
        ListParam_Saisie.forEach((element) {
          print(">>>>>>>>>>> getParam_Saisie ${Param_Saisie_Organe} ${Param_Saisie_Type} ${element.toMap()}");

          element.Param_Saisie_Ordre = i++;
          setParam_Saisie(element);
        });
        return true;
      }
      return false;
    } catch (e) {
      print("•••• •••• •••• •••• error ${ListParam_Saisie.length}");
      await DbTools.getParam_Saisie( Param_Saisie_Organe,  Param_Saisie_Type);
      print("•••• •••• •••• •••• DbTools ${ListParam_Saisie.length}");

      return false;
    }
  }

/*
  static Future<bool> getParam_Saisie_Base(String Param_Saisie_Type) async {
    ListParam_Saisie_Base = await getParam_Saisie_API_Post("select", "select * from Param_Saisie WHERE Param_Saisie_Organe = 'Base' AND Param_Saisie_Type = '${Param_Saisie_Type}'  ORDER BY Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_Ordre,Param_Saisie_ID");
    if (ListParam_Saisie_Base == null) return false;
    if (ListParam_Saisie_Base.length > 0) {
      int i = 1;
      ListParam_Saisie_Base.forEach((element) {
        element.Param_Saisie_Ordre = i++;
        setParam_Saisie(element);
      });
      return true;
    }
    return false;
  }
*/

  static Param_Saisie getParam_Saisie_Det(String type) {
    Param_Saisie wParam_Saisie = Param_Saisie.Param_SaisieInit();
    ListParam_Saisie.forEach((element) async {
      if (element.Param_Saisie_ID.compareTo(type) == 0) {
        wParam_Saisie = element;
      }
    });
    return wParam_Saisie;
  }

  static Future<List<Param_Saisie>> getParam_Saisie_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${gLoginID}"});

    http.StreamedResponse response = await request.send();
    print("response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      print("items ${items}");

      if (items != null) {
        List<Param_Saisie> Param_SaisieList = await items.map<Param_Saisie>((json) {
          return Param_Saisie.fromJson(json);
        }).toList();
        print("Param_SaisieList ${Param_SaisieList.length}");
        return Param_SaisieList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<bool> setParam_Saisie(Param_Saisie Param_Saisie) async {
    String wSlq = "UPDATE Param_Saisie SET "
            "Param_SaisieId = \"${Param_Saisie.Param_SaisieId}\"," +
        "Param_Saisie_Organe = \"${Param_Saisie.Param_Saisie_Organe}\"," +
        "Param_Saisie_Type = \"${Param_Saisie.Param_Saisie_Type}\"," +
        "Param_Saisie_ID = \"${Param_Saisie.Param_Saisie_ID}\"," +
        "Param_Saisie_Label = \"${Param_Saisie.Param_Saisie_Label}\"," +
        "Param_Saisie_Aide = \"${Param_Saisie.Param_Saisie_Aide}\"," +
        "Param_Saisie_Controle =  \"${Param_Saisie.Param_Saisie_Controle}\"," +
        "Param_Saisie_Ordre = ${Param_Saisie.Param_Saisie_Ordre.toString()}," +
        "Param_Saisie_Affichage = \"${Param_Saisie.Param_Saisie_Affichage.toString()}\"," +
        "Param_Saisie_Icon = \"${Param_Saisie.Param_Saisie_Icon.toString()}\"," +
        "Param_Saisie_Ordre_Affichage = ${Param_Saisie.Param_Saisie_Ordre_Affichage.toString()}" +
        " WHERE Param_SaisieId = " +
        Param_Saisie.Param_SaisieId.toString();
//    print("setParam_Saisie " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
//    print("setParam_Saisie ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParam_Saisie(Param_Saisie Param_Saisie) async {
    String wValue = "NULL,'${Param_Saisie.Param_Saisie_Organe}','${Param_Saisie.Param_Saisie_Type}','???','---'";
    String wSlq = "INSERT INTO Param_Saisie (Param_SaisieId, Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_ID,Param_Saisie_Label) VALUES ($wValue)";
    print("addParam_Saisie " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Saisie ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParam_Saisie(Param_Saisie Param_Saisie) async {
    String aSQL = "DELETE FROM Param_Saisie WHERE Param_SaisieId = ${Param_Saisie.Param_SaisieId} ";
    print("delParam_Saisie " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Saisie ret " + ret.toString());
    return ret;
  }

  //***********************************************************************
  //***********************************************************************
  //***********************************************************************

  static List<Param_Param> ListParam_ParamAll = [];
  static List<Param_Param> ListParam_Param = [];
  static List<Param_Param> ListParam_Param_Abrev = [];
  static List<Param_Param> ListParam_Param_Civ = [];
  static List<String> ListParam_ParamCiv = [];
  static List<String> ListParam_ParamForme = [];
  static List<Param_Param> ListParam_Param_Status_Interv = [];
  static List<Param_Param> ListParam_Param_Etat_Devis = [];
  static List<Param_Param> ListParam_Param_Etat_Cde = [];
  static List<Param_Param> ListParam_Param_Etat_Livr = [];




  static List<Param_Param> ListParam_Paramsearchresult = [];

  static Param_Param gParam_Param = Param_Param.Param_ParamInit();

  static Future<bool> getParam_ParamAll() async {
    String wSql = "select * from Param_Param ORDER BY Param_Param_Ordre,Param_Param_ID";
    print("getParam_ParamAll ${wSql}");
    ListParam_ParamAll = await getParam_Param_API_Post("select", wSql);

    if (ListParam_ParamAll == null) return false;

    print("getParam_ParamAll ${ListParam_Param.length}");

    if (ListParam_ParamAll.length > 0) {
      return true;
    }

    return false;
  }

  static List<String> ListParam_ParamFam = [];
  static List<String> ListParam_ParamFamID = [];
  static List<String> ListParam_FiltreFam = [];
  static List<String> ListParam_FiltreFamID = [];



  static Future<bool> getParam_ParamFam(String wFam) async {
    ListParam_ParamFam.clear();
    ListParam_ParamFamID.clear();
    ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo(wFam) == 0) {
        ListParam_ParamFam.add(element.Param_Param_Text);
        ListParam_ParamFamID.add(element.Param_Param_ID);
      }
    });

    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();

    ListParam_FiltreFam.add("Tous");
    ListParam_FiltreFamID.add("*");

    ListParam_FiltreFam.addAll(ListParam_ParamFam);
    ListParam_FiltreFamID.addAll(ListParam_ParamFamID);

    return true;
  }

  static Future<bool> getParam_Param(String Param_Param_Type) async {
    ListParam_Param = await getParam_Param_API_Post("select", "select * from Param_Param WHERE Param_Param_Type = '${Param_Param_Type}' ORDER BY Param_Param_Ordre,Param_Param_ID");

    print("getParam_Param aSQL select * from Param_Param WHERE Param_Param_Type = '${Param_Param_Type}' ORDER BY Param_Param_Ordre,Param_Param_ID");
    if (ListParam_Param == null) return false;
//        print("getParam_ParamAll ${ListParam_Param.length}");
    if (ListParam_Param.length > 0) {
      print("getParam_ParamAll return TRUE");
      int i = 1;
      ListParam_Param.forEach((element) {
        element.Param_Param_Ordre = i++;
        setParam_Param(element);
      });
      return true;
    }

    return false;
  }

  static Param_Param getParam_Param_in_Mem(
    String Param_Param_Type,
    String Param_Param_ID,
  ) {
    for (int i = 0; i < ListParam_ParamAll.length; i++) {
      Param_Param element = ListParam_ParamAll[i];
      if (element.Param_Param_Type.compareTo(Param_Param_Type) == 0 && element.Param_Param_ID.compareTo(Param_Param_ID) == 0) {
        return element;
      }
    }
    return Param_Param.Param_ParamInit();
  }

  static bool getParam_ParamMem(String Param_Saisie_ID) {
    ListParam_Param.clear();
    ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo(Param_Saisie_ID) == 0) {
        ListParam_Param.add(element);
      }
    });
    return true;
  }

  static bool getParam_ParamMemDet(String Param_Param_Type, String Param_Param_ID) {
    ListParam_Param.clear();
    ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo(Param_Param_Type) == 0 && element.Param_Param_ID.compareTo(Param_Param_ID) == 0) {
        ListParam_Param.add(element);
      }
    });
    return true;
  }

  static Future<bool> setParam_Param(Param_Param param_Param) async {
    String wSlq = "UPDATE Param_Param SET "
            "Param_Param_Text = \"" +
        param_Param.Param_Param_Text +
        "\", " +
        "Param_Param_ID = \"" +
        param_Param.Param_Param_ID +
        "\", " +
        "Param_Param_Int = " +
        param_Param.Param_Param_Int.toString() +
        ", " +
        "Param_Param_Ordre = " +
        param_Param.Param_Param_Ordre.toString() +
        ", " +
        "Param_Param_Double = " +
        param_Param.Param_Param_Double.toString() +
        " WHERE Param_ParamId = " +
        param_Param.Param_ParamId.toString();
    print("setParam_Param " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParam_Param ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParam_Param(Param_Param param_Param) async {
    String wValue = "NULL,'${param_Param.Param_Param_Type}','???','---'";
    String wSlq = "INSERT INTO Param_Param (Param_ParamId,Param_Param_Type,Param_Param_ID,Param_Param_Text) VALUES ($wValue)";
    print("addParam_Param " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Param ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParam_Param(Param_Param param_Param) async {
    String aSQL = "DELETE FROM Param_Param WHERE Param_ParamId = ${param_Param.Param_ParamId} ";
    print("delParam_Param " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Param ret " + ret.toString());
    return ret;
  }

  static Future<List<Param_Param>> getParam_Param_API_Post(String aType, String aSQL) async {
    setSrvToken();

    print("getParam_Param_API_Post aSQL " + aSQL);

    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${gLoginID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Param_Param> Param_ParamList = await items.map<Param_Param>((json) {
          //print("getParam_Param_API_Post json " + json.toString());
          return Param_Param.fromJson(json);
        }).toList();
        return Param_ParamList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //***********************************************************************
  //***********************************************************************
  //***********************************************************************

  static List<Param_Saisie_Param> ListParam_Saisie_Param = [];
  static List<Param_Saisie_Param> ListParam_Saisie_ParamAll = [];
  static List<Param_Saisie_Param> ListParam_Saisie_Paramsearchresult = [];
  static Param_Saisie_Param gParam_Saisie_Param = Param_Saisie_Param.Param_Saisie_ParamInit();

  static int Param_Saisie_ParamSortComparison(Param_Saisie_Param a, Param_Saisie_Param b) {
    final Param_Saisie_Ordre_AffichageA = a.Param_Saisie_Param_Ordre;
    final Param_Saisie_Ordre_AffichageB = b.Param_Saisie_Param_Ordre;
    if (Param_Saisie_Ordre_AffichageA < Param_Saisie_Ordre_AffichageB) {
      return -1;
    } else if (Param_Saisie_Ordre_AffichageA > Param_Saisie_Ordre_AffichageB) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future<bool> getParam_Saisie_ParamAll() async {

    ListParam_Saisie_ParamAll.clear();
    try {
      ListParam_Saisie_ParamAll = await getParam_Saisie_Param_API_Post("select", "select * from Param_Saisie_Param ORDER BY Param_Saisie_Param_Id,Param_Saisie_Param_Ordre");
      if (ListParam_Saisie_ParamAll == null) return false;
      if (ListParam_Saisie_ParamAll.length > 0) {
        for (int i = 0; i < ListParam_Saisie_ParamAll.length; i++) {
          Param_Saisie_Param element = ListParam_Saisie_ParamAll[i];
          element.Param_Saisie_Param_Ico = await gObj.getAssetImage("assets/images/Aide_Ico_${element.Param_Saisie_Param_Label}.png");
//          if (element.Param_Saisie_Param_Ico.toString().contains("AssetImage"))
//          print("Param_Saisie_Param_Ico ${element.Param_Saisie_Param_Ico.toString()}");


        };
        return true;
      }
      return false;
    } catch (e) {
      await DbTools.getParam_Saisie_ParamAll();
      return false;
    }


  }

  static Future<bool> getParam_Saisie_Param(String Param_Saisie_Param_Id) async {
    String wSql = "select * from Param_Saisie_Param WHERE Param_Saisie_Param_Id = '${Param_Saisie_Param_Id}' ORDER BY Param_Saisie_Param_Id,Param_Saisie_Param_Ordre";
    //   print("getParam_Saisie_Param ${wSql}");
    ListParam_Saisie_Param = await getParam_Saisie_Param_API_Post("select", wSql);
    if (ListParam_Saisie_Param == null) return false;

    if (ListParam_Saisie_Param.length > 0) {
      return true;
    }

    return false;
  }

  static bool getParam_Saisie_ParamMem(String Param_Saisie_Param_Id) {
//    print(">>>>>>>>>>>>>>>>>>>> getParam_Saisie_ParamMem ${Param_Saisie_Param_Id} ");

    ListParam_Saisie_Param.clear();
    ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo(Param_Saisie_Param_Id) == 0) {

        ListParam_Saisie_Param.add(element);
      }
    });

    //  print("<<<<<<<<<<<<<<<<<<<<<<<<<< getParam_Saisie_ParamMem ${Param_Saisie_Param_Id} ${ListParam_Saisie_Param.length} ");

    return true;
  }

  static Param_Saisie_Param getParam_Saisie_ParamMem_Lib(String Param_Saisie_Param_Id, String Param_Saisie_Param_Label) {
    Param_Saisie_Param param_Saisie_Param = Param_Saisie_Param.Param_Saisie_ParamInit();
    ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo(Param_Saisie_Param_Id) == 0 && element.Param_Saisie_Param_Label.compareTo(Param_Saisie_Param_Label) == 0) {
        param_Saisie_Param = element;
      }
    });
    return param_Saisie_Param;
  }

  static Param_Saisie_Param getParam_Saisie_ParamMem_Lib0(String Param_Saisie_Param_Id) {
    Param_Saisie_Param param_Saisie_Param = Param_Saisie_Param.Param_Saisie_ParamInit();

    Srv_DbTools.ListParam_Saisie_ParamAll.sort(Srv_DbTools.Param_Saisie_ParamSortComparison);

    for (int i = 0; i < ListParam_Saisie_ParamAll.length; i++) {
      Param_Saisie_Param element = ListParam_Saisie_ParamAll[i];
      if (element.Param_Saisie_Param_Id.compareTo(Param_Saisie_Param_Id) == 0 && element.Param_Saisie_Param_Label.compareTo("---") != 0) {
        param_Saisie_Param = element;
        break;
        ;
      }
    }
    return param_Saisie_Param;
  }


  static String SIT_Lib = "";


  static String DESC_Lib = "";
  static String FAB_Lib = "";
  static String TYPE_Lib = "";
  static String ARM_Lib = "";
  static String INOX_Lib = "";
  static String DIAM_Lib = "";
  static String LONG_Lib = "";
  static String DIF_Lib = "";
  static String DISP_Lib = "";
  static String PREM_Lib = "";

  static String NCERT_Lib = "";


  static String PRS_Lib = "";
  static String CLF_Lib = "";
  static String MOB_Lib = "";
  static String GAM_Lib = "";
  static String GAM_ID = "";
  static String PDT_Lib = "";
  static String POIDS_Lib = "";

  static String REF_Lib = "";

  static String wKgL = "";

  static bool getParam_Saisie_ParamMem_REF() {
    ListParam_Saisie_Param.clear();
    REF_Lib = "";
    REF_Lib = DbTools.gParc_Ent.Parcs_CodeArticle!;
    REF_Lib = DbTools.gParc_Ent.Parcs_CODF!;

    return true;
  }

  int Param_Saisie_ParamId = 0;
  String Param_Saisie_Param_Id = "";
  int Param_Saisie_Param_Ordre = 0;
  String Param_Saisie_Param_Label = "";
  String Param_Saisie_Param_Aide = "";

  static Future<bool> setParam_Saisie_Param(Param_Saisie_Param Param_Saisie_Param) async {
    String wSlq = "UPDATE Param_Saisie_Param SET "
            "Param_Saisie_Param_Id = \"" +
        Param_Saisie_Param.Param_Saisie_Param_Id +
        "\", " +
        "Param_Saisie_Param_Ordre = " +
        Param_Saisie_Param.Param_Saisie_Param_Ordre.toString() +
        ", \"" +
        "Param_Saisie_Param_Label = " +
        Param_Saisie_Param.Param_Saisie_Param_Label.toString() +
        "\", \"" +
        "Param_Saisie_Param_Aide = " +
        Param_Saisie_Param.Param_Saisie_Param_Aide.toString() +
        "\" WHERE Param_Saisie_ParamId = " +
        Param_Saisie_Param.Param_Saisie_ParamId.toString();
    print("setParam_Saisie_Param " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParam_Saisie_Param ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParam_Saisie_Param(Param_Saisie_Param wParam_Saisie_Param) async {
    String wValue = "NULL,'${wParam_Saisie_Param.Param_Saisie_Param_Id}',${wParam_Saisie_Param.Param_Saisie_Param_Ordre}, '${wParam_Saisie_Param.Param_Saisie_Param_Label}','${wParam_Saisie_Param.Param_Saisie_Param_Aide}'";
    String wSlq = "INSERT INTO Param_Saisie_Param (Param_Saisie_ParamId,Param_Saisie_Param_Id,Param_Saisie_Param_Ordre,Param_Saisie_Param_Label, Param_Saisie_Param_Aide) VALUES ($wValue)";
    print("addParam_Saisie_Param " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Saisie_Param ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParam_Saisie_Param(Param_Saisie_Param Param_Saisie_Param) async {
    String aSQL = "DELETE FROM Param_Saisie_Param WHERE Param_Saisie_ParamId = ${Param_Saisie_Param.Param_Saisie_ParamId} ";
    print("delParam_Saisie_Param " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Saisie_Param ret " + ret.toString());
    return ret;
  }

  static Future<List<Param_Saisie_Param>> getParam_Saisie_Param_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${gLoginID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Param_Saisie_Param> Param_Saisie_ParamList = await items.map<Param_Saisie_Param>((json) {
          return Param_Saisie_Param.fromJson(json);
        }).toList();
        return Param_Saisie_ParamList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<bool> add_API_Post(String aType, String aSQL) async {
    setSrvToken();
    gLastID = -1;

    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL});

//    print("add_API_Post B $aType $aSQL");

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String wRep = await response.stream.bytesToString();
        //      print("add_API_Post wRep " + wRep);
        var parsedJson = json.decode(wRep);

        var success = parsedJson['success'];

        if (success == 1) {
          gLastID = int.tryParse("${parsedJson['last_id']}") ?? 0;
        }
        return true;
      } else {
        print(response.reasonPhrase);
      }
      return false;
    } catch (e) {
      return false;
    }
  }


  //******************************************
  //************   DCL_Ent   ***************
  //******************************************

  static List<DCL_Ent> ListDCL_Ent = [];
  static List<DCL_Ent> ListDCL_Entsearchresult = [];
  static DCL_Ent gDCL_Ent = DCL_Ent();


  static String gSelDCL_Ent = "";
  static String gSelDCL_EntBase = "Tous les types de document";


  static int affSortComparisonData_DCL(DCL_Ent a, DCL_Ent b) {
    final wDCL_EntDateA = a.DCL_Ent_Date;
    final wDCL_EntDateB = b.DCL_Ent_Date;

    int wDCL_EntIdA = a.DCL_EntID!;
    int wDCL_EntIdB = b.DCL_EntID!;



    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDateA = inputFormat.parse(wDCL_EntDateA!);
    var inputDateB = inputFormat.parse(wDCL_EntDateB!);

    if (inputDateA.isBefore(inputDateB)) {
      return 1;
    } else if (inputDateA.isAfter(inputDateB)) {
      return -1;
    } else {
      if (wDCL_EntIdA < wDCL_EntIdB) {
        return 1;
      } else if (wDCL_EntIdA > wDCL_EntIdB) {
        return -1;
      }
      return 0;
    }
  }


  static Future<bool> getDCL_EntAll() async {
    ListDCL_Ent = await getDCL_Ent_API_Post("select", "select * from DCL_Ent ORDER BY DCL_EntID");

    if (ListDCL_Ent == null) return false;
    print("getDCL_EntAll ${ListDCL_Ent.length}");
    if (ListDCL_Ent.length > 0) {
      print("getDCL_EntAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getDCL_EntID(int ID) async {
    ListDCL_Ent.forEach((element) {
      if (element.DCL_EntID == ID) {
        gDCL_Ent = element;
        return;
      }
    });
  }



  static Future<List<DCL_Ent>> getDCL_Ent_DCL_Ent_InterventionId(int DCL_Ent_InterventionId) async {


    ListDCL_Ent = await getDCL_Ent_API_Post("select", "select * from DCL_Ent WHERE DCL_Ent_InterventionId = $DCL_Ent_InterventionId ORDER BY DCL_EntID");

    if (ListDCL_Ent == null) return [];

    return ListDCL_Ent;




  }







  static Future<bool> setDCL_Ent(DCL_Ent DCL_Ent) async {
    String wSlq = "UPDATE DCL_Ent SET "
        "DCL_EntID = '${DCL_Ent.DCL_EntID}', " +
        "DCL_Ent_Type = '${DCL_Ent.DCL_Ent_Type}', " +
        "DCL_Ent_Version = '${DCL_Ent.DCL_Ent_Version}', " +
        "DCL_Ent_ClientId = '${DCL_Ent.DCL_Ent_ClientId}', " +
        "DCL_Ent_GroupeId = '${DCL_Ent.DCL_Ent_GroupeId}', " +
        "DCL_Ent_SiteId = '${DCL_Ent.DCL_Ent_SiteId}', " +
        "DCL_Ent_ZoneId = '${DCL_Ent.DCL_Ent_ZoneId}', " +
        "DCL_Ent_InterventionId = '${DCL_Ent.DCL_Ent_InterventionId}', " +
        "DCL_Ent_Date = '${DCL_Ent.DCL_Ent_Date}', " +
        "DCL_Ent_Statut = '${DCL_Ent.DCL_Ent_Statut}', " +
        "DCL_Ent_Etat = '${DCL_Ent.DCL_Ent_Etat}', " +
        "DCL_Ent_Etat_Motif = '${DCL_Ent.DCL_Ent_EtatMotif}', " +
        "DCL_Ent_Etat_Note = '${DCL_Ent.DCL_Ent_EtatNote}', " +
        "DCL_Ent_Etat_Action = '${DCL_Ent.DCL_Ent_EtatAction}', " +
        "DCL_Ent_Collaborateur = '${DCL_Ent.DCL_Ent_Collaborateur}', " +
        "DCL_Ent_Affaire = '${DCL_Ent.DCL_Ent_Affaire}', " +
        "DCL_Ent_Affaire_Note = '${DCL_Ent.DCL_Ent_AffaireNote}', " +
        "DCL_Ent_Validite = '${DCL_Ent.DCL_Ent_Validite}', " +
        "DCL_Ent_LivrPrev = '${DCL_Ent.DCL_Ent_LivrPrev}', " +
        "DCL_Ent_ModeRegl = '${DCL_Ent.DCL_Ent_ModeRegl}', " +
        "DCL_Ent_MoyRegl = '${DCL_Ent.DCL_Ent_MoyRegl}', " +
        "DCL_Ent_Valo = '${DCL_Ent.DCL_Ent_Valo}', " +
        "DCL_Ent_Relance = '${DCL_Ent.DCL_Ent_Relance}', " +
        "DCL_Ent_Relance_Mode = '${DCL_Ent.DCL_Ent_RelanceMode}', " +
        "DCL_Ent_Relance_Contact = '${DCL_Ent.DCL_Ent_RelanceContact}', " +
        "DCL_Ent_Relance_Mail = '${DCL_Ent.DCL_Ent_RelanceMail}', " +
        "DCL_Ent_Relance_Tel = '${DCL_Ent.DCL_Ent_RelanceTel}', " +
        "DCL_Ent_Proba = '${DCL_Ent.DCL_Ent_Proba}', " +
        "DCL_Ent_Concurent = '${DCL_Ent.DCL_Ent_Concurent}', " +
        "DCL_Ent_Note = '${DCL_Ent.DCL_Ent_Note}', " +
        "DCL_Ent_Regl = '${DCL_Ent.DCL_Ent_Regl}', " +
        "DCL_Ent_Partage = '${DCL_Ent.DCL_Ent_Partage}', " +
        "DCL_Ent_Dem_Tech = '${DCL_Ent.DCL_Ent_DemTech}', " +
        "DCL_Ent_Dem_SsT = '${DCL_Ent.DCL_Ent_DemSsT}'" ;

    bool ret = await add_API_Post("upddel", wSlq);
    print("setDCL_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> delDCL_Ent(int DCL_EntID) async {
    String aSQL = "DELETE FROM DCL_Ent WHERE DCL_EntID = ${DCL_EntID} ";
    print("delDCL_Ent " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delDCL_Ent ret " + ret.toString());
    return ret;
  }

  static String InsertUpdateDCL_Ent_GetSql(DCL_Ent aDCL_Ent) {
    String wSql = "INSERT INTO DCL_Ent("
        "DCL_EntID, "
        "DCL_Ent_Type, "
        "DCL_Ent_Version, "
        "DCL_Ent_ClientId, "
        "DCL_Ent_GroupeId, "
        "DCL_Ent_SiteId, "
        "DCL_Ent_ZoneId, "
        "DCL_Ent_InterventionId, "
        "DCL_Ent_Date, "
        "DCL_Ent_Statut, "
        "DCL_Ent_Etat, "
        "DCL_Ent_Etat_Motif, "
        "DCL_Ent_Etat_Note, "
        "DCL_Ent_Etat_Action, "
        "DCL_Ent_Collaborateur, "
        "DCL_Ent_Affaire, "
        "DCL_Ent_Affaire_Note, "
        "DCL_Ent_Validite, "
        "DCL_Ent_LivrPrev, "
        "DCL_Ent_ModeRegl, "
        "DCL_Ent_MoyRegl, "
        "DCL_Ent_Valo, "
        "DCL_Ent_Relance, "
        "DCL_Ent_Relance_Mode, "
        "DCL_Ent_Relance_Contact, "
        "DCL_Ent_Relance_Mail, "
        "DCL_Ent_Relance_Tel, "
        "DCL_Ent_Proba, "
        "DCL_Ent_Concurent, "
        "DCL_Ent_Note, "
        "DCL_Ent_Regl, "
        "DCL_Ent_Partage, "
        "DCL_Ent_Dem_Tech, "
        "DCL_Ent_Dem_SsT, "

        ") VALUES ("
        "NULL ,  "
        "'${aDCL_Ent.DCL_Ent_Type}',"
        "${aDCL_Ent.DCL_Ent_Version},"
        "${aDCL_Ent.DCL_Ent_ClientId},"
        "${aDCL_Ent.DCL_Ent_GroupeId},"
        "${aDCL_Ent.DCL_Ent_SiteId},"
        "${aDCL_Ent.DCL_Ent_ZoneId},"
        "${aDCL_Ent.DCL_Ent_InterventionId},"
        "'${aDCL_Ent.DCL_Ent_Date}',"
        "'${aDCL_Ent.DCL_Ent_Statut}',"
        "'${aDCL_Ent.DCL_Ent_Etat}',"
        "'${aDCL_Ent.DCL_Ent_EtatMotif}',"
        "'${aDCL_Ent.DCL_Ent_EtatNote}',"
        "'${aDCL_Ent.DCL_Ent_EtatAction}',"
        "'${aDCL_Ent.DCL_Ent_Collaborateur}',"
        "'${aDCL_Ent.DCL_Ent_Affaire}',"
        "'${aDCL_Ent.DCL_Ent_AffaireNote}',"
        "'${aDCL_Ent.DCL_Ent_Validite}',"
        "'${aDCL_Ent.DCL_Ent_LivrPrev}',"
        "'${aDCL_Ent.DCL_Ent_ModeRegl}',"
        "'${aDCL_Ent.DCL_Ent_MoyRegl}',"
        "${aDCL_Ent.DCL_Ent_Valo},"
        "${aDCL_Ent.DCL_Ent_Relance},"
        "'${aDCL_Ent.DCL_Ent_RelanceMode}',"
        "'${aDCL_Ent.DCL_Ent_RelanceContact}',"
        "'${aDCL_Ent.DCL_Ent_RelanceMail}',"
        "'${aDCL_Ent.DCL_Ent_RelanceTel}',"
        "${aDCL_Ent.DCL_Ent_Proba},"
        "'${aDCL_Ent.DCL_Ent_Concurent}',"
        "'${aDCL_Ent.DCL_Ent_Note}',"
        "'${aDCL_Ent.DCL_Ent_Regl}',"
        "'${aDCL_Ent.DCL_Ent_Partage}',"
        "${aDCL_Ent.DCL_Ent_DemTech},"
        "${aDCL_Ent.DCL_Ent_DemSsT},"


        ")";
    return wSql;
  }

  static Future<bool> InsertUpdateDCL_Ent_Sql(String wSql) async {
    print("InsertUpdateDCL_Ent_Sql " + wSql);
    bool ret = await add_API_Post("multi", wSql);
    print("InsertUpdateDCL_Ent_Sql ret " + ret.toString());
    return ret;
  }

  static Future<bool> InsertUpdateDCL_Ent(DCL_Ent aDCL_Ent) async {
    String wSql = "INSERT INTO DCL_Ent("
        "DCL_Ent_Type, "
        "DCL_Ent_Version, "
        "DCL_Ent_ClientId, "
        "DCL_Ent_GroupeId, "
        "DCL_Ent_SiteId, "
        "DCL_Ent_ZoneId, "
        "DCL_Ent_InterventionId, "
        "DCL_Ent_Date, "
        "DCL_Ent_Statut, "
        "DCL_Ent_Etat, "
        "DCL_Ent_Etat_Motif, "
        "DCL_Ent_Etat_Note, "
        "DCL_Ent_Etat_Action, "
        "DCL_Ent_Collaborateur, "
        "DCL_Ent_Affaire, "
        "DCL_Ent_Affaire_Note, "
        "DCL_Ent_Validite, "
        "DCL_Ent_LivrPrev, "
        "DCL_Ent_ModeRegl, "
        "DCL_Ent_MoyRegl, "
        "DCL_Ent_Valo, "
        "DCL_Ent_Relance, "
        "DCL_Ent_Relance_Mode, "
        "DCL_Ent_Relance_Contact, "
        "DCL_Ent_Relance_Mail, "
        "DCL_Ent_Relance_Tel, "
        "DCL_Ent_Proba, "
        "DCL_Ent_Concurent, "
        "DCL_Ent_Note, "
        "DCL_Ent_Regl, "
        "DCL_Ent_Partage, "
        "DCL_Ent_Dem_Tech, "
        "DCL_Ent_Dem_SsT "

        ") VALUES ("
        "'${aDCL_Ent.DCL_Ent_Type}',"
        "${aDCL_Ent.DCL_Ent_Version},"
        "${aDCL_Ent.DCL_Ent_ClientId},"
        "${aDCL_Ent.DCL_Ent_GroupeId},"
        "${aDCL_Ent.DCL_Ent_SiteId},"
        "${aDCL_Ent.DCL_Ent_ZoneId},"
        "${aDCL_Ent.DCL_Ent_InterventionId},"
        "'${aDCL_Ent.DCL_Ent_Date}',"
        "'${aDCL_Ent.DCL_Ent_Statut}',"
        "'${aDCL_Ent.DCL_Ent_Etat}',"
        "'${aDCL_Ent.DCL_Ent_EtatMotif}',"
        "'${aDCL_Ent.DCL_Ent_EtatNote}',"
        "'${aDCL_Ent.DCL_Ent_EtatAction}',"
        "'${aDCL_Ent.DCL_Ent_Collaborateur}',"
        "'${aDCL_Ent.DCL_Ent_Affaire}',"
        "'${aDCL_Ent.DCL_Ent_AffaireNote}',"
        "'${aDCL_Ent.DCL_Ent_Validite}',"
        "'${aDCL_Ent.DCL_Ent_LivrPrev}',"
        "'${aDCL_Ent.DCL_Ent_ModeRegl}',"
        "'${aDCL_Ent.DCL_Ent_MoyRegl}',"
        "${aDCL_Ent.DCL_Ent_Valo},"
        "${aDCL_Ent.DCL_Ent_Relance},"
        "'${aDCL_Ent.DCL_Ent_RelanceMode}',"
        "'${aDCL_Ent.DCL_Ent_RelanceContact}',"
        "'${aDCL_Ent.DCL_Ent_RelanceMail}',"
        "'${aDCL_Ent.DCL_Ent_RelanceTel}',"
        "${aDCL_Ent.DCL_Ent_Proba},"
        "'${aDCL_Ent.DCL_Ent_Concurent}',"
        "'${aDCL_Ent.DCL_Ent_Note}',"
        "'${aDCL_Ent.DCL_Ent_Regl}',"
        "'${aDCL_Ent.DCL_Ent_Partage}',"
        "${aDCL_Ent.DCL_Ent_DemTech},"
        "${aDCL_Ent.DCL_Ent_DemSsT}"
        ")";
    print("setDCL_Ent " + wSql);
    bool ret = await add_API_Post("upddel", wSql);
    print("setDCL_Ent ret " + ret.toString());
    return ret;
  }

  static Future<List<DCL_Ent>> getDCL_Ent_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<DCL_Ent> DCL_EntList = await items.map<DCL_Ent>((json) {
          return DCL_Ent.fromJson(json);
        }).toList();
        return DCL_EntList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }


  //******************************************
  //************   DCL_Det   ***************
  //******************************************

  static List<DCL_Det> ListDCL_Det = [];
  static List<DCL_Det> ListDCL_Detsearchresult = [];
  static DCL_Det gDCL_Det = DCL_Det();

  static Future<bool> getDCL_DetAll() async {
    ListDCL_Det = await getDCL_Det_API_Post("select", "select * from DCL_Det ORDER BY DCL_DetID");

    if (ListDCL_Det == null) return false;
    print("getDCL_DetAll ${ListDCL_Det.length}");
    if (ListDCL_Det.length > 0) {
      print("getDCL_DetAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getDCL_DetID(int ID) async {
    ListDCL_Det.forEach((element) {
      if (element.DCL_DetID == ID) {
        gDCL_Det = element;
        return;
      }
    });
  }


  static Future<bool> setDCL_Det(DCL_Det DCL_Det) async {
    String wSlq = "UPDATE DCL_Det SET "
        "DCL_DetID = ${DCL_Det.DCL_DetID}, " +
        "DCL_DetID = ${DCL_Det.DCL_Det_EntID}, " +
        "DCL_DetID = ${DCL_Det.DCL_Det_ParcsArtId}, " +
        "DCL_DetID = ${DCL_Det.DCL_Det_Ordre}, " +
        "DCL_DetID = '${DCL_Det.DCL_Det_Type}', " +
        "DCL_DetID = '${DCL_Det.DCL_Det_NoArt}', " +
        "DCL_DetID = '${DCL_Det.DCL_Det_Lib}', " +
        "DCL_DetID = ${DCL_Det.DCL_Det_Qte}, " +
        "DCL_DetID = ${DCL_Det.DCL_Det_PU}, " +
        "DCL_DetID = ${DCL_Det.DCL_Det_RemP}, " +
        "DCL_DetID = ${DCL_Det.DCL_Det_RemMt}, " +
        "DCL_DetID = ${DCL_Det.DCL_Det_Livr}, " +
        "DCL_DetID = '${DCL_Det.DCL_Det_DateLivr}', " +
        "DCL_DetID = ${DCL_Det.DCL_Det_Rel}, " +
        "DCL_DetID = '${DCL_Det.DCL_Det_DateRel}', " +
        "DCL_DetID = '${DCL_Det.DCL_Det_Statut}', " +
        "DCL_DetID = '${DCL_Det.DCL_Det_Note}'";
        
    bool ret = await add_API_Post("upddel", wSlq);
    print("setDCL_Det ret " + ret.toString());
    return ret;
  }

  static Future<bool> delDCL_Det(int DCL_DetID) async {
    String aSQL = "DELETE FROM DCL_Det WHERE DCL_DetID = ${DCL_DetID} ";
    print("delDCL_Det " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delDCL_Det ret " + ret.toString());
    return ret;
  }

  static String InsertUpdateDCL_Det_GetSql(DCL_Det aDCL_Det) {
    String wSql = "INSERT INTO DCL_Det("
        "DCL_DetID, "
        "DCL_Det_EntID, "
        "DCL_Det_ParcsArtId, "
        "DCL_Det_Ordre, "
        "DCL_Det_Type, "
        "DCL_Det_NoArt, "
        "DCL_Det_Lib, "
        "DCL_Det_Qte, "
        "DCL_Det_PU, "
        "DCL_Det_RemP, "
        "DCL_Det_RemMt, "
        "DCL_Det_Livr, "
        "DCL_Det_DateLivr, "
        "DCL_Det_Rel, "
        "DCL_Det_DateRel, "
        "DCL_Det_Statut, "
        "DCL_Det_Note "
        ") VALUES ("
        "NULL ,  "
        "${aDCL_Det.DCL_Det_EntID},"
        "${aDCL_Det.DCL_Det_ParcsArtId},"
        "${aDCL_Det.DCL_Det_Ordre},"
        "'${aDCL_Det.DCL_Det_Type}',"
        "'${aDCL_Det.DCL_Det_NoArt}',"
        "'${aDCL_Det.DCL_Det_Lib}',"
        "${aDCL_Det.DCL_Det_Qte},"
        "${aDCL_Det.DCL_Det_PU},"
        "${aDCL_Det.DCL_Det_RemP},"
        "${aDCL_Det.DCL_Det_RemMt},"
        "${aDCL_Det.DCL_Det_Livr},"
        "'${aDCL_Det.DCL_Det_DateLivr}',"
        "${aDCL_Det.DCL_Det_Rel},"
        "'${aDCL_Det.DCL_Det_DateRel}',"
        "'${aDCL_Det.DCL_Det_Statut}',"
        "'${aDCL_Det.DCL_Det_Note}'"
        ")";
    return wSql;
  }

  static Future<bool> InsertUpdateDCL_Det_Sql(String wSql) async {
    print("InsertUpdateDCL_Det_Sql " + wSql);
    bool ret = await add_API_Post("multi", wSql);
    print("InsertUpdateDCL_Det_Sql ret " + ret.toString());
    return ret;
  }

  static Future<bool> InsertUpdateDCL_Det(DCL_Det aDCL_Det) async {
    String wSql = "INSERT INTO DCL_Det("
        "DCL_DetID, "
        "DCL_Det_EntID, "
        "DCL_Det_ParcsArtId, "
        "DCL_Det_Ordre, "
        "DCL_Det_Type, "
        "DCL_Det_NoArt, "
        "DCL_Det_Lib, "
        "DCL_Det_Qte, "
        "DCL_Det_PU, "
        "DCL_Det_RemP, "
        "DCL_Det_RemMt, "
        "DCL_Det_Livr, "
        "DCL_Det_DateLivr, "
        "DCL_Det_Rel, "
        "DCL_Det_DateRel, "
        "DCL_Det_Statut, "
        "DCL_Det_Note "
        ") VALUES ("
        "NULL ,  "
        "${aDCL_Det.DCL_Det_EntID},"
        "${aDCL_Det.DCL_Det_ParcsArtId},"
        "${aDCL_Det.DCL_Det_Ordre},"
        "'${aDCL_Det.DCL_Det_Type}',"
        "'${aDCL_Det.DCL_Det_NoArt}',"
        "'${aDCL_Det.DCL_Det_Lib}',"
        "${aDCL_Det.DCL_Det_Qte},"
        "${aDCL_Det.DCL_Det_PU},"
        "${aDCL_Det.DCL_Det_RemP},"
        "${aDCL_Det.DCL_Det_RemMt},"
        "${aDCL_Det.DCL_Det_Livr},"
        "'${aDCL_Det.DCL_Det_DateLivr}',"
        "${aDCL_Det.DCL_Det_Rel},"
        "'${aDCL_Det.DCL_Det_DateRel}',"
        "'${aDCL_Det.DCL_Det_Statut}',"
        "'${aDCL_Det.DCL_Det_Note}'"
        ")";
//    print("setDCL_Det " + wSql);
    bool ret = await add_API_Post("upddel", wSql);
    //  print("setDCL_Det ret " + ret.toString());
    return ret;
  }

  static Future<List<DCL_Det>> getDCL_Det_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<DCL_Det> DCL_DetList = await items.map<DCL_Det>((json) {
          return DCL_Det.fromJson(json);
        }).toList();
        return DCL_DetList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }



  //****************************************
  //****************************************
  //****************************************

  static void setSrvToken() {
    var uuid = Uuid();
    var v1 = uuid.v1();

    Random random = new Random();

    int Cut = random.nextInt(8) + 1;
    String sCut = "T" + Cut.toString();

    String S1 = SrvTokenKey.substring(0, Cut);
    String S2 = SrvTokenKey.substring(Cut);

    int F1 = random.nextInt(7);
    String sR3 = "P" + F1.toString().padLeft(2, '0');
    int F3 = random.nextInt(7);
    int F2 = 16 - F1 - F3;

    int R5 = F1 + Cut + 3 + F2 + 2;

    String sR5 = "S" + R5.toString().padLeft(2, '0');

//    print("v1 $v1");

    int C1 = random.nextInt(20) + 1;
    int C2 = random.nextInt(20) + 1;
    int C3 = random.nextInt(20) + 1;

//    print("F1  $C1 $F1");
//    print("F2  $C2 $F2");
//    print("F3  $C3 $F3");

    String sF1 = v1.substring(C1, C1 + F1);
//    print("sF1 $sF1");
    String sF2 = v1.substring(C2, C2 + F2);
//    print("sF2 $sF2");
    String sF3 = v1.substring(C3, C3 + F3);
//    print("sF3 $sF3");

//    print("SrvTokenKey $SrvTokenKey");
//    print("Cut $Cut $sCut");
//    print("S1 $S1");
//    print("S2 $S2");

//    print("R3 $sR3");
//    print("R5 $R5 $sR5");

    String Tok = sF1 + S1 + sR5 + sF2 + sCut + S2 + sR3 + sF3;
    int TokLen = Tok.length;
//    print("Tok $Tok $TokLen");

    SrvToken = Tok;

    int pT = Tok.indexOf('T') + 1;
    String rsT1 = Tok.substring(pT, pT + 1);
    int rT1 = int.parse(rsT1);
//    print("rT1 $rT1");
    int rT2 = 8 - rT1;
//    print("rT2 $rT2");

    int pP = Tok.indexOf('P') + 1;
//    print("pP $pP");
    String rsP = Tok.substring(pP, pP + 2);
    int rP = int.parse(rsP);
//    print("rP $rP");

    int pS = Tok.indexOf('S') + 1;
//    print("pS $pS");
    String rsS = Tok.substring(pS, pS + 2);
    int rS = int.parse(rsS);
//    print("rS $rS");

    String rR3 = Tok.substring(rP, rP + rT1);
    String rR5 = Tok.substring(rS, rS + rT2);
//    print("rR3 $rR3");
//    print("rR5 $rR5");

    String rR35 = rR3 + rR5;

    //   print("VERIF $rR35");
  }



}
