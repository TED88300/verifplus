import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:uuid/uuid.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Adresses.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ArticlesImg_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Link_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Link_Verif_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Contacts.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Det.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent_Img.dart';
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


  //***********************
  // *******************
  //************   RIA_Gammes   ************
  //******************************************

  static List<RIA_Gammes> ListRIA_Gammes = [];
  static List<RIA_Gammes> ListRIA_Gammessearchresult = [];
  static RIA_Gammes gRIA_Gammes = RIA_Gammes.RIA_GammesInit();

  static Future<bool> IMPORT_Srv_RIA_Gammes() async {
    String wSlq = "select * from RIA_Gammes ORDER BY RIA_GammesId";
    print("IMPORT_Srv_RIA_Gammes $wSlq");

    try {
      ListRIA_Gammes = await getRIA_Gammes_API_Post("select", wSlq);
      if (ListRIA_Gammes.isNotEmpty) {
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

    print("getRIA_Gammes_API_Post $aSQL");

    http.StreamedResponse response = await request.send();
    print("getRIA_Gammes_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<RIA_Gammes> riaGammeslist = await items.map<RIA_Gammes>((json) {
          return RIA_Gammes.fromJson(json);
        }).toList();
        return riaGammeslist;
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
      if (ListNF074_Gammes.isNotEmpty) {
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
        List<NF074_Gammes> nf074Gammeslist = await items.map<NF074_Gammes>((json) {
          return NF074_Gammes.fromJson(json);
        }).toList();
        return nf074Gammeslist;
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
      if (ListNF074_Histo_Normes.isNotEmpty) {
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
        List<NF074_Histo_Normes> nf074HistoNormeslist = await items.map<NF074_Histo_Normes>((json) {
          return NF074_Histo_Normes.fromJson(json);
        }).toList();
        return nf074HistoNormeslist;
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
      if (ListNF074_Pieces_Det.isNotEmpty) {
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
        List<NF074_Pieces_Det> nf074PiecesDetlist = await items.map<NF074_Pieces_Det>((json) {
          return NF074_Pieces_Det.fromJson(json);
        }).toList();
        return nf074PiecesDetlist;
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
      if (ListNF074_Pieces_Det_Inc.isNotEmpty) {
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
        List<NF074_Pieces_Det_Inc> nf074PiecesDetInclist = await items.map<NF074_Pieces_Det_Inc>((json) {
          return NF074_Pieces_Det_Inc.fromJson(json);
        }).toList();
        return nf074PiecesDetInclist;
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
      if (ListNF074_Mixte_Produit.isNotEmpty) {
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
        List<NF074_Mixte_Produit> nf074MixteProduitlist = await items.map<NF074_Mixte_Produit>((json) {
          return NF074_Mixte_Produit.fromJson(json);
        }).toList();
        return nf074MixteProduitlist;
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
      if (ListNF074_Pieces_Actions.isNotEmpty) {
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
        List<NF074_Pieces_Actions> nf074PiecesActionslist = await items.map<NF074_Pieces_Actions>((json) {
          return NF074_Pieces_Actions.fromJson(json);
        }).toList();
        return nf074PiecesActionslist;
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

  static List<String> list_Article_Groupe = [];
  static List<Article_GrpFamSsFam_Ebp> list_Article_GrpFamSsFam_Ebp = [];

  static Article_Ebp gArticle_Ebp = Article_Ebp.Article_EbpInit();
  static Article_Ebp gArticle_EbpEnt = Article_Ebp.Article_EbpInit();
  static Article_Ebp gArticle_EbpSelRef = Article_Ebp.Article_EbpInit();

  static Article_Ebp IMPORT_Article_Ebp(String articleCodearticle) {
    Article_Ebp warticleEbp = Article_Ebp.Article_EbpInit();
    for (var zArticle_Ebp in Srv_DbTools.ListArticle_Ebp) {
      if (zArticle_Ebp.Article_codeArticle.compareTo(articleCodearticle) == 0) {
        warticleEbp = zArticle_Ebp;
        continue;
      }
    }
    return warticleEbp;
  }

  static Future<bool> IMPORT_Article_EbpAll() async {
    String wSlq = "select * from Articles_Ebp ORDER BY Article_codeArticle";
    try {
      ListArticle_Ebp = await getArticle_Ebp_API_Post("select", wSlq);
      if (ListArticle_Ebp.isNotEmpty) {
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

    print("IMPORT_Article_Ebp_ES $wSlq");

    try {
      ListArticle_Ebp_ES = await getArticle_Ebp_API_Post("select", wSlq);
      if (ListArticle_Ebp_ES.isNotEmpty) {
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
        List<Article_Ebp> articleEbplist = await items.map<Article_Ebp>((json) {
          return Article_Ebp.fromJson(json);
        }).toList();
        return articleEbplist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<ArticlesImg_Ebp> ListArticlesImg_Ebp = [];
  static ArticlesImg_Ebp gArticlesImg_Ebp = ArticlesImg_Ebp("", "");

  static Future<bool> IMPORT_ArticlesImg_Ebp(int limit, int offset) async {
    String wSlq = "SELECT * FROM ArticlesImg_Ebp limit $limit offset $offset";
    print("IMPORT_ArticlesImg_Ebp $wSlq");
    try {
      ListArticlesImg_Ebp = await getListArticlesImg_Ebp_API_Post("select", wSlq);
      if (ListArticlesImg_Ebp.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getArticlesImg_Ebp(String warticlesimgCodearticle) async {
    String wSlq = "SELECT * FROM ArticlesImg_Ebp where ArticlesImg_codeArticle = '$warticlesimgCodearticle'";
//    print("getArticlesImg_Ebp ${wSlq}");
    try {
      ListArticlesImg_Ebp = await getListArticlesImg_Ebp_API_Post("select", wSlq);
      if (ListArticlesImg_Ebp.length == 1) {
        gArticlesImg_Ebp = ListArticlesImg_Ebp[0];
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<ArticlesImg_Ebp>> getListArticlesImg_Ebp_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    http.StreamedResponse response = await request.send();
//    print("getListArticlesImg_Ebp_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
//      print("getListArticlesImg_Ebp_API_Post parsedJson >>>");

      String wTmp = await response.stream.bytesToString();
//      print("getListArticlesImg_Ebp_API_Post wTmp ${wTmp}");
      var parsedJson = json.decode(wTmp);

      final items = parsedJson['data'];

      if (items != null) {
        List<ArticlesImg_Ebp> articlesimgEbplist = await items.map<ArticlesImg_Ebp>((json) {
          return ArticlesImg_Ebp.fromJson(json);
        }).toList();
        return articlesimgEbplist;
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
      if (ListArticle_Fam_Ebp.isNotEmpty) {
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
        List<Article_Fam_Ebp> articleFamEbplist = await items.map<Article_Fam_Ebp>((json) {
          return Article_Fam_Ebp.fromJson(json);
        }).toList();
        return articleFamEbplist;
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

      if (tClient.ClientId == wClient.ClientId) {
        wTrv = true;
        break;
      }
    }

    if (!wTrv) {
      ListClient_CSIP_Total.add(wClient);
    }

    return true;
  }

  static Future<bool> getClient_ALL() async {
    ListClient_CSIP_Total.clear();
    await getClient_All();
    for (var wClient in ListClient_CSIP) {
      //print("getClient_User_C ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    }

    ListClient.clear();
    ListClient.addAll(ListClient_CSIP_Total);

    ListClient_CSIP_Total.clear();
    return true;
  }

  static Future<bool> getClient_All() async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.isNotEmpty) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_CSIP(String userMatricule) async {
    ListClient_CSIP_Total.clear();
    await getClient_User_C(userMatricule);
    for (var wClient in ListClient_CSIP) {
      //print("getClient_User_C ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    }

    await getClient_User_S(userMatricule);
    for (var wClient in ListClient_CSIP) {
      //print("getClient_User_S ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    }

    await getClient_User_I(userMatricule);
    for (var wClient in ListClient_CSIP) {
      //print("getClient_User_I ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    }

    await getClient_User_I2(userMatricule);
    for (var wClient in ListClient_CSIP) {
      //print("getClient_User_I2 ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    }

    await getClient_User_P(userMatricule);
    for (var wClient in ListClient_CSIP) {
      //print("getClient_User_P ${wClient.Client_Nom}");
      ListClient_CSIP_Total_Insert(wClient);
    }

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

  static Future<bool> getClient_User_C(String userMatricule) async {
    String wSlq = "SELECT Clients.* FROM Clients Where Clients.Client_Commercial = \"$userMatricule\"";
    //print("getClient_User_C ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    //print("getClient_User_C ${ListClient_CSIP.length}");
    if (ListClient_CSIP.isNotEmpty) {
      //print("getClient_User_C return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_S(String userMatricule) async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId AND Sites.Site_ResourceId = \"$userMatricule\"";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.isNotEmpty) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_I(String userMatricule) async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable = \"$userMatricule\"";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.isNotEmpty) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_I2(String userMatricule) async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable2 = \"$userMatricule\"";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.isNotEmpty) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_P(String userMatricule) async {
    String wSlq = "SELECT Clients.*, Planning_ResourceId FROM Clients, Groupes, Sites, Zones, Interventions, Planning where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Planning.Planning_InterventionId = Interventions.InterventionId AND Planning.Planning_ResourceId = \"$userMatricule\"";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.isNotEmpty) {
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
    String userMatricule = Srv_DbTools.gUserLogin.User_Matricule;

    String wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients  LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" ';
    print("getClientRech A");

    if (wRech.isNotEmpty) {
      wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" '
              ' WHERE Clients.Client_Nom LIKE "%' '$wRech%" OR Adresse_CP LIKE "%$wRech%" OR Adresse_Ville LIKE "%$wRech%" ORDER BY Client_Nom;';
    } else if (wDepot.isNotEmpty) {
      wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" WHERE Clients.Client_Depot = "$wDepot"';
    }

    print("getClient wSlq $wSlq");
    ListClient = await getClient_API_Post("select", wSlq);
    if (ListClient.isNotEmpty) {
      gClient = ListClient[0];
      return true;
    }
    return false;
  }

  static Future<bool> getClientRechVP(String wRech, String wDepot) async {
    String userMatricule = Srv_DbTools.gUserLogin.User_Matricule;

    String wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, CONCAT(Users.User_Nom, " " , Users.User_Prenom) as Users_Nom FROM Clients JOIN Users ON Clients.Client_Commercial = "$userMatricule" LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" ';
    print("getClientRech A");

    if (wRech.isNotEmpty) {
      wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, CONCAT(Users.User_Nom, " " , Users.User_Prenom) as Users_Nom FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" JOIN Users ON Clients.Client_Commercial = "User_Matricule"'
              ' WHERE Clients.Client_Nom LIKE "%' '$wRech%" OR Adresse_CP LIKE "%$wRech%" OR Adresse_Ville LIKE "%$wRech%" ORDER BY Client_Nom;';
    } else if (wDepot.isNotEmpty) {
      wSlq = 'SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, CONCAT(Users.User_Nom, " " , Users.User_Prenom) as Users_Nom FROM Clients JOIN Users ON Clients.Client_Commercial = "User_Matricule"  LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = "FACT" WHERE Clients.Client_Depot = "$wDepot"';
    }

    print("getClient wSlq $wSlq");
    ListClient = await getClient_API_Post("select", wSlq);
    if (ListClient.isNotEmpty) {
      gClient = ListClient[0];
      return true;
    }
    return false;
  }

  static Future<bool> getClientDepotp(String wDepot) async {
    String wSlq = "SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = 'FACT'  WHERE Clients.Client_Depot = '$wDepot'  ORDER BY Client_Nom;";
    print("getClientDepot wSlq $wSlq");
    ListClient = await getClient_API_Post("select", wSlq);
    print("getClientDepot ${ListClient.length}");
    if (ListClient.isNotEmpty) {
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
      print("IMPORT_ClientAll wSlq $wSlq");
      ListClient = await getClient_API_Post("select", wSlq);
      print("IMPORT_ClientAll ListClient ${ListClient.length}");
      if (ListClient.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getClientNom(int Id) async {
    String wSlq = "SELECT * FROM Clients  WHERE ClientId = $Id;";
    ListClient = await getClient_API_Post("select", wSlq);
    //  print("getClient ${ListClient.length}");
    if (ListClient.isNotEmpty) {
      gClient = ListClient[0];
      return true;
    }
    return false;
  }



  static Future<bool> getClient(int Id) async {
//    String wSlq = "SELECT * FROM Clients Where ClientId = '${Id}'";
    String wSlq = "SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = 'FACT' WHERE ClientId = $Id ORDER BY Client_Nom;";

//    print("getClient wSlq ${wSlq}");
    ListClient = await getClient_API_Post("select", wSlq);
  //  print("getClient ${ListClient.length}");
    if (ListClient.isNotEmpty) {
      gClient = ListClient[0];
      return true;
    }
    return false;
  }

  static Future<bool> setClient(Client Client) async {
    String wSlq = "UPDATE Clients SET "
            "Client_CodeGC = \"${Client.Client_CodeGC}\", " "Client_CL_Pr = ${Client.Client_CL_Pr}, " "Client_Famille = \"${Client.Client_Famille}\", " "Client_Depot = \"${Client.Client_Depot}\", " "Client_Rglt = \"${Client.Client_Rglt}\", " +
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
    gColors.printWrapped("setClient $wSlq");

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
    print("addClient wSlq $wSlq");

    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addClient ret $ret");
      return ret;
    } catch (e) {
      print("addClient ERROR $e");
      return false;
    }
  }

  static Future<bool> delClient(Client Client) async {
    String aSQL = "DELETE FROM Clients WHERE ClientId = ${Client.ClientId} ";
    print("delClient $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delClient ret $ret");
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

  static Future<List<Client>> getClient_API_PostNom(String aType, String aSQL) async {
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
      if (ListAdresse.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future getAdresseID(int ID) async {
    for (var element in ListAdresse) {
      if (element.AdresseId == ID) {
        gAdresse = element;
        continue;
      }
    }
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
            "Adresse_ClientId     =   ${Adresse.Adresse_ClientId}, " "Adresse_Code      = \"${Adresse.Adresse_Code}\", " "Adresse_Type      = \"${Adresse.Adresse_Type}\", " "Adresse_Nom      = \"${Adresse.Adresse_Nom}\", " "Adresse_Adr1      = \"${Adresse.Adresse_Adr1}\", " +
        "Adresse_Adr2      = \"${Adresse.Adresse_Adr2}\", " +
        "Adresse_Adr3      = \"${Adresse.Adresse_Adr3}\", " +
        "Adresse_CP        = \"${Adresse.Adresse_CP}\", " +
        "Adresse_Ville     = \"${Adresse.Adresse_Ville}\", " +
        "Adresse_Pays      = \"${Adresse.Adresse_Pays}\", " +
        "Adresse_Rem       = \"${Adresse.Adresse_Rem}\" " +
        "WHERE AdresseId      = ${Adresse.AdresseId.toString()}";

    gColors.printWrapped("setAdresse sql $wSlq");

    try {
      bool ret = await add_API_Post("upddel", wSlq);
      print("setAdresse ret $ret");
      return true;
    } catch (e) {
      print("setAdresse ERROR $e");
      return false;
    }
  }

  static Future<bool> addAdresse(int adresseClientid, String Type) async {
    String wValue = "NULL, $adresseClientid, '$Type'";
    String wSlq = "INSERT INTO Adresses (AdresseId, Adresse_ClientId, Adresse_Type) VALUES ($wValue)";
    print("addAdresse $wSlq");

    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addAdresse ret $ret");
      return ret;
    } catch (e) {
      print("addAdresse ERROR $e");
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

  static Future<bool> getGroupeRech(int ID, String wRech) async {
    String wSlq = 'SELECT Groupe_Nom , Groupes.* FROM Groupes, Clients WHERE (Groupe_Nom LIKE "%' '$wRech%" OR Groupe_CP LIKE "%$wRech%" OR Groupe_Ville LIKE "%$wRech%" ) AND Groupe_ClientId = ClientId AND Groupe_ClientId = $ID ORDER BY Groupe_Nom ASC;';

//    String wSlq = 'select * from Groupes WHERE Groupe_Nom LIKE "%' + '${wRech}' + '%" OR Groupe_CP LIKE "%' + '${wRech}' + '%" OR Groupe_Ville LIKE "%' + '${wRech}' + '%" ORDER BY Groupe_Nom;';
    print("getGroupeRech wSlq $wSlq");
    ListGroupe = await getGroupe_API_Post("select", wSlq);
    if (ListGroupe.isNotEmpty) {
      gGroupe = ListGroupe[0];
      return true;
    }
    return false;
  }

  static Future<bool> getGroupeAll() async {
    try {
      ListGroupe = await getGroupe_API_Post("select", "select * from Groupes ORDER BY Groupe_Nom");
      print("getGroupesClient ${ListGroupe.length}");
      if (ListGroupe.isNotEmpty) {
        print("getGroupesClient return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getGroupesClient(int ID) async {
    String wTmp = "select * from Groupes WHERE Groupe_ClientId = $ID ORDER BY Groupe_Nom";
    print("wTmp getGroupesClient $wTmp");
    try {
      ListGroupe = await getGroupe_API_Post("select", wTmp);
      print("getGroupesClient ${ListGroupe.length}");
      if (ListGroupe.isNotEmpty) {
        print("getGroupesClient return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future getGroupeID(int ID) async {
    print("getGroupeID $ID");
    for (var element in ListGroupe) {
      if (element.GroupeId == ID) {
        gGroupe = element;
        continue;
      }
    }
  }

  static Future<bool> setGroupe(Groupe Groupe) async {
    String wSlq = "UPDATE Groupes SET "
            "Groupe_ClientId     =   ${Groupe.Groupe_ClientId}, " "Groupe_Code      = \"${Groupe.Groupe_Code}\", " "Groupe_Nom      = \"${Groupe.Groupe_Nom}\", " "Groupe_Adr1      = \"${Groupe.Groupe_Adr1}\", " "Groupe_Adr2      = \"${Groupe.Groupe_Adr2}\", " +
        "Groupe_Adr3      = \"${Groupe.Groupe_Adr3}\", " +
        "Groupe_CP        = \"${Groupe.Groupe_CP}\", " +
        "Groupe_Ville     = \"${Groupe.Groupe_Ville}\", " +
        "Groupe_Pays      = \"${Groupe.Groupe_Pays}\", " +
        "Livr        = \"${Groupe.Livr}\", " +
        "Groupe_Rem       = \"${Groupe.Groupe_Rem}\" " +
        "WHERE GroupeId      = ${Groupe.GroupeId.toString()}";
    gColors.printWrapped("setGroupe $wSlq");

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

  static Future<bool> addGroupe(int groupeClientid) async {
    String wValue = "NULL, $groupeClientid";
    String wSlq = "INSERT INTO Groupes (GroupeId, Groupe_ClientId) VALUES ($wValue)";
    print("addGroupe $wSlq");
    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addGroupe ret ${ret.toString()} $gLastID");
      return ret;
    } catch (e) {
      print("addGroupe ERROR $e");
      return false;
    }
  }

  static Future<bool> delGroupe(Groupe Groupe) async {
    String aSQL = "DELETE FROM Groupes WHERE GroupeId = ${Groupe.GroupeId} ";
    print("delGroupe $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delGroupe ret $ret");
    return ret;
  }

  static Future<List<Groupe>> getGroupe_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getGroupe_API_Post $aSQL");

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
    String wSlq = 'SELECT Sites.* FROM Sites WHERE (Site_Nom LIKE "%' '$wRech%" OR Site_CP LIKE "%$wRech%" OR Site_Ville LIKE "%$wRech%" ) AND Site_GroupeId = $ID ORDER BY Site_Nom ASC;';

//    String wSlq = 'select * from Sites WHERE Site_Nom LIKE "%' + '${wRech}' + '%" OR Site_CP LIKE "%' + '${wRech}' + '%" OR Site_Ville LIKE "%' + '${wRech}' + '%" ORDER BY Site_Nom;';
    print("getSiteRech wSlq $wSlq");
    ListSite = await getSite_API_Post("select", wSlq);
    if (ListSite.isNotEmpty) {
      gSite = ListSite[0];
      return true;
    }
    return false;
  }

  static Future<bool> getSiteAll() async {
    try {
      String wTmp = "select * from Sites ORDER BY Site_Nom";
      print("wTmp getSiteAll $wTmp");
      ListSite = await getSite_API_Post("select", wTmp);
      print("getSiteAll ${ListSite.length}");
      if (ListSite.isNotEmpty) {
        print("getSiteAll return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getSitesGroupe(int ID) async {
    String wTmp = "select * from Sites WHERE Site_GroupeId = $ID ORDER BY Site_Nom";
    print("wTmp getSitesGroupe $wTmp");
    try {
      ListSite = await getSite_API_Post("select", wTmp);
      print("getSitesGroupe ${ListSite.length}");
      if (ListSite.isNotEmpty) {
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
    print("SRV_DbTools getSitesGroupe $wTmp");
    try {
      ListSite = await getSite_API_Post("select", wTmp);
      print("getSitesGroupe ${ListSite.length}");
      if (ListSite.isNotEmpty) {
        print("getSitesGroupe return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getGroupeSites(int ID) async {
    String wTmp = "SELECT Groupe_Nom , Sites.* FROM Sites , Groupes where Site_GroupeId = GroupeId AND Site_GroupeId = $ID ORDER BY Groupe_Nom ASC, Site_Nom ASC;";
    print("SRV_DbTools getSitesGroupe $wTmp");
    try {
      ListSite = await getSite_API_Post("select", wTmp);
      print("getSitesGroupe ${ListSite.length}");
      if (ListSite.isNotEmpty) {
        print("getSitesGroupe return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future getSiteID(int ID) async {
    for (var element in ListSite) {
      if (element.SiteId == ID) {
        gSite = element;
        continue;
      }
    }
  }

  static Future<bool> setSite(Site Site) async {
    String wSlq = "UPDATE Sites SET "
            "Site_GroupeId     =   ${Site.Site_GroupeId}, " "Site_Code      = \"${Site.Site_Code}\", " "Site_Nom      = \"${Site.Site_Nom}\", " "Site_Adr1      = \"${Site.Site_Adr1}\", " "Site_Adr2      = \"${Site.Site_Adr2}\", " +
        "Site_Adr3      = \"${Site.Site_Adr3}\", " +
        "Site_CP        = \"${Site.Site_CP}\", " +
        "Site_Ville     = \"${Site.Site_Ville}\", " +
        "Site_Pays      = \"${Site.Site_Pays}\", " +
        "Site_ResourceId     =   ${Site.Site_ResourceId}, " +
        "Livr        = \"${Site.Livr}\", " +
        "Site_Rem       = \"${Site.Site_Rem}\" " +
        "WHERE SiteId      = ${Site.SiteId.toString()}";
    gColors.printWrapped("setSite $wSlq");

    try {
      bool ret = await add_API_Post("upddel", wSlq);
      print("setSite ret $ret");
      return true;
    } catch (e) {
      print("setSite ERROR $e");
      return false;
    }
  }

  static Future<bool> addSite(int siteGroupeid) async {
    String wValue = "NULL, $siteGroupeid";
    String wSlq = "INSERT INTO Sites (SiteId, Site_GroupeId) VALUES ($wValue)";
    print("addSite $wSlq");
    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addSite ret $ret");
      return ret;
    } catch (e) {
      print("addSite ERROR $e");
      return false;
    }
  }

  static Future<bool> delSite(Site site) async {
    String aSQL = "DELETE FROM Sites WHERE SiteId = ${site.SiteId} ";
    print("delSite $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delSite ret $ret");
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

    print("wTmp getZonesClient $wTmp");
    ListZone = await getZone_API_Post("select", wTmp);
    print("getZonesClient ${ListZone.length}");
    if (ListZone.isNotEmpty) {
      gZone = ListZone[0];
      print("getZonesClient return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getZoneAll() async {
    try {
      ListZone = await getZone_API_Post("select", "select * from Zones ORDER BY Zone_Nom");
      print("getZoneAll ${ListZone.length}");
      if (ListZone.isNotEmpty) {
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
      String wTmp = "select * from Zones WHERE Zone_GroupeId = $ID ORDER BY Zone_Nom";
      ListZone = await getZone_API_Post("select", wTmp);
      print("getZonesGroupe ${ListZone.length}");
      if (ListZone.isNotEmpty) {
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
      String wTmp = "SELECT Zones.* FROM Zones where Zone_SiteId =  $ID ORDER BY Zone_Nom ASC;";
      ListZone = await getZone_API_Post("select", wTmp);
      print("getZones ${ListZone.length}");
      if (ListZone.isNotEmpty) {
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

    for (var element in ListZone) {
      if (element.ZoneId == ID) {
        gZone = element;
        print("gZone ${gZone.Zone_Nom}");
        continue;
      }
    }
  }

  static Future<bool> setZone(Zone Zone) async {
    String wSlq = "UPDATE Zones SET "
            "Zone_SiteId     =   ${Zone.Zone_SiteId}, " "Zone_Code      = \"${Zone.Zone_Code}\", " "Zone_Nom      = \"${Zone.Zone_Nom}\", " "Zone_Adr1      = \"${Zone.Zone_Adr1}\", " "Zone_Adr2      = \"${Zone.Zone_Adr2}\", " +
        "Zone_Adr3      = \"${Zone.Zone_Adr3}\", " +
        "Zone_CP        = \"${Zone.Zone_CP}\", " +
        "Zone_Ville     = \"${Zone.Zone_Ville}\", " +
        "Zone_Pays      = \"${Zone.Zone_Pays}\", " +
        "Livr        = \"${Zone.Livr}\", " +
        "Zone_Rem       = \"${Zone.Zone_Rem}\" " +
        "WHERE ZoneId      = ${Zone.ZoneId.toString()}";
    gColors.printWrapped("setZone $wSlq");

    try {
      bool ret = await add_API_Post("upddel", wSlq);
      print("setZone ret $ret");
      return ret;
    } catch (e) {
      print("setZone ERROR $e");
      return false;
    }
  }

  static Future<bool> addZone(int zoneSiteid) async {
    String wValue = "NULL, $zoneSiteid";
    String wSlq = "INSERT INTO Zones (ZoneId, Zone_SiteId) VALUES ($wValue)";
    print("addZone $wSlq");
    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addZone ret ${ret.toString()}");
      return ret;
    } catch (e) {
      print("addZone ERROR $e");
      return false;
    }
  }

  static Future<bool> delZone(Zone zone) async {
    String aSQL = "DELETE FROM Zones WHERE ZoneId = ${zone.ZoneId} ";
    print("delZone $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delZone ret $ret");
    return ret;
  }

  static Future<List<Zone>> getZone_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getZone_API_Post $aSQL");

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

    int wInterventionIdA = a.InterventionId;
    int wInterventionIdB = b.InterventionId;

    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDateA = inputFormat.parse(wInterventionDateA);
    var inputDateB = inputFormat.parse(wInterventionDateB);

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
    print("getInterventionAll ${ListIntervention.length}");
    if (ListIntervention.isNotEmpty) {
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
      print("getInterventionAll ${ListIntervention.length}");
      if (ListIntervention.isNotEmpty) {
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
      print("getInterventionAll ${ListIntervention.length}");
      if (ListIntervention.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getInterventionsZone(int ID) async {
    String wTmp = "select * from Interventions WHERE Intervention_ZoneId = $ID ORDER BY Intervention_Date";
    print("SRV_DbTools getInterventionsZone $wTmp");
    try {
      ListIntervention = await getIntervention_API_Post("select", wTmp);
      print("getInterventionsZone ${ListIntervention.length}");
      if (ListIntervention.isNotEmpty) {
        print("getInterventionsZone return TRUE");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getInterventionsID_Srv(int ID) async {
    String wTmp = "select * from Interventions WHERE InterventionId = $ID";

    ListIntervention = await getIntervention_API_Post("select", wTmp);
    print("getInterventionsID_Srv length ${ListIntervention.length}");
    if (ListIntervention.isNotEmpty) {
      gIntervention = ListIntervention[0];
      print("getInterventionsID_Srv ${gIntervention.Desc()}");

      return true;
    }
    return false;
  }

  static Future getInterventionID(int ID) async {
    for (var element in ListIntervention) {
      if (element.InterventionId == ID) {
        gIntervention = element;
        continue;
      }
    }
  }

  static Future<bool> setIntervention(Intervention Intervention) async {
    String wSlq = "UPDATE Interventions SET "
            "InterventionId     =   ${Intervention.InterventionId}, " "Intervention_ZoneId      = \"${Intervention.Intervention_ZoneId}\", " "Intervention_Date      = \"${Intervention.Intervention_Date}\", " "Intervention_Date_Visite      = \"${Intervention.Intervention_Date_Visite}\", " "Intervention_Type      = \"${Intervention.Intervention_Type}\", " +
        "Intervention_Parcs_Type      = \"${Intervention.Intervention_Parcs_Type}\", " +
        "Intervention_Status      = \"${Intervention.Intervention_Status}\", " +
        "Livr        = \"${Intervention.Livr}\", " +
        "Intervention_Signataire_Client        = \"${Intervention.Intervention_Signataire_Client}\", " +
        "Intervention_Signataire_Tech        = \"${Intervention.Intervention_Signataire_Tech}\", " +
        "Intervention_Signataire_Date        = \"${Intervention.Intervention_Signataire_Date}\", " +
        "Intervention_Signataire_Date_Client	        = \"${Intervention.Intervention_Signataire_Date_Client}\", " +
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

  static Future<bool> addIntervention(int interventionZoneid) async {
    String wValue = "NULL, $interventionZoneid";
    String wSlq = "INSERT INTO Interventions (InterventionId, Intervention_ZoneId) VALUES ($wValue)";
    print("addIntervention $wSlq");

    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addIntervention ret $ret  gLastID $gLastID");
      return ret;
    } catch (e) {
      print("addIntervention ERROR $e");
      return false;
    }
  }

  static Future<bool> delIntervention(Intervention Intervention) async {
    String aSQL = "DELETE FROM Interventions WHERE InterventionId = ${Intervention.InterventionId} ";
    print("delIntervention $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delIntervention ret $ret");
    return ret;
  }

  static Future<List<Intervention>> getIntervention_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getIntervention_API_Post $aSQL");

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

      print(" Srv_DbTools getPlanning_InterventionIdRes $wSql");

      ListUserH = await getPlanningH_API_Post("select", wSql);
      if (ListPlanning.isNotEmpty) {
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
    if (ListPlanning.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future getPlanning_InterventionId(int InterventionId) async {
    try {
      ListPlanning = await getPlanning_API_Post("select", "select * from Planning where Planning_InterventionId = $InterventionId");
      if (ListPlanning.isNotEmpty) {
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
      if (ListPlanning.isNotEmpty) {
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

    gColors.printWrapped("setPlanning $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setPlanning ret $ret");
    return ret;
  }

  static Future<bool> addPlanning(Planning Planning) async {
    String wValue = "NULL, ${Planning.Planning_InterventionId}, ${Planning.Planning_ResourceId} , '${Planning.Planning_InterventionstartTime}', '${Planning.Planning_InterventionendTime}' , '${Planning.Planning_Libelle}'";
    String wSlq = "INSERT INTO Planning (PlanningId, Planning_InterventionId, Planning_ResourceId, Planning_InterventionstartTime, Planning_InterventionendTime, Planning_Libelle) VALUES ($wValue)";
    print("addPlanning $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addPlanning ret $ret");
    return ret;
  }

  static Future<bool> delPlanning(Planning Planning) async {
    String aSQL = "DELETE FROM Planning WHERE PlanningId = ${Planning.PlanningId} ";
    print("delPlanning $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delPlanning ret $ret");
    return ret;
  }

  static Future<List<Planning>> getPlanning_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});

    print("getIntervention_API_Post $aSQL");

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

    print("getPlanningH_API_Post $aSQL");

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
      if (ListPlanning_Intervention.isNotEmpty) {
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
        List<Planning_Intervention> planningInterventionlist = await items.map<Planning_Intervention>((json) {
          return Planning_Intervention.fromJson(json);
        }).toList();

        print("Planning_Interventionlist length ${planningInterventionlist.length}");

        return planningInterventionlist;
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
    print("getInterMissions_Document_MissonID ListInterMissions_Document.length ${ListInterMissions_Document.length}");
    if (ListInterMissions_Document.isNotEmpty) {
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
    print("getInterMissions_Document_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      print("getInterMissions_Document_API_Post items $items");

      if (items != null) {
        List<InterMissions_Document> intermissionsDocumentlist = await items.map<InterMissions_Document>((json) {
          return InterMissions_Document.fromJson(json);
        }).toList();
        return intermissionsDocumentlist;
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
      print("getInterMissionAll ${ListInterMission.length}");
      if (ListInterMission.isNotEmpty) {
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
      print("getInterMissionUID $wSql");
      ListInterMission = await getInterMission_API_Post("select", wSql);
      print("getInterMissionUID ${ListInterMission.length}");
      if (ListInterMission.isNotEmpty) {
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
    //  print("getInterMissionsSite ${ListInterMission.length}");
    if (ListInterMission.isNotEmpty) {
      //  print("getInterMissionsSite return TRUE");
      return true;
    }
    return false;
  }

  static Future getInterMissionID(int ID) async {
    for (var element in ListInterMission) {
      if (element.InterMissionId == ID) {
        gInterMission = element;
        continue;
      }
    }
  }

  static Future<bool> setInterMission(InterMission InterMission) async {
    String wSlq = "UPDATE InterMissions SET "
            "InterMissionId     =   ${InterMission.InterMissionId}, " "InterMission_InterventionId      = \"${InterMission.InterMission_InterventionId}\", " "InterMission_Nom      = \"${InterMission.InterMission_Nom}\", " "InterMission_Exec      = ${InterMission.InterMission_Exec}, " "InterMission_Date      = \"${InterMission.InterMission_Date}\" " +
        "WHERE InterMissionId      = ${InterMission.InterMissionId.toString()}";
    gColors.printWrapped("setInterMission $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setInterMission ret $ret");
    return ret;
  }

  static Future<bool> addInterMission(InterMission InterMission) async {
    String wValue = "NULL, ${InterMission.InterMission_InterventionId}, '${InterMission.InterMission_Nom}' , ${InterMission.InterMission_Exec}, '${InterMission.InterMission_Date}' ";
    String wSlq = "INSERT INTO InterMissions (InterMissionId, InterMission_InterventionId, InterMission_Nom, InterMission_Exec, InterMission_Date) VALUES ($wValue)";
    print("addInterMission $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addInterMission ret $ret");
    return ret;
  }

  static Future<bool> delInterMission(InterMission InterMission) async {
    String aSQL = "DELETE FROM InterMissions WHERE InterMissionId = ${InterMission.InterMissionId} ";
    print("delInterMission $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delInterMission ret $ret");
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
    print("getParc_EntAll ${ListParc_Ent.length}");
    if (ListParc_Ent.isNotEmpty) {
      print("getParc_EntAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_EntID(int ID) async {
    try {
      ListParc_Ent = await getParc_Ent_API_Post("select", "select * from Parcs_Ent WHERE Parcs_InterventionId = $ID  ORDER BY Parcs_Type");
      if (ListParc_Ent.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setParc_Ent(Parc_Ent_Srv parcEnt) async {
    String wSlq = "UPDATE Parcs_Ent SET "
            "ParcsId     =   ${parcEnt.ParcsId}, " "Parcs_order     =   ${parcEnt.Parcs_order}, " "Parcs_InterventionId = ${parcEnt.Parcs_InterventionId}, " "Parcs_Intervention_Timer = \"${parcEnt.Parcs_Intervention_Timer}\", " "Parcs_Type  = \"${parcEnt.Parcs_Type}\", " +
        "Parcs_Date_Rev  = \"${parcEnt.Parcs_Date_Rev}\", " +
        "Parcs_QRCode  = \"${parcEnt.Parcs_QRCode}\", " +
        "Parcs_FREQ_Id  = \"${parcEnt.Parcs_FREQ_Id}\", " +
        "Parcs_FREQ_Label  = \"${parcEnt.Parcs_FREQ_Label}\", " +
        "Parcs_ANN_Id  = \"${parcEnt.Parcs_ANN_Id}\", " +
        "Parcs_ANN_Label  = \"${parcEnt.Parcs_ANN_Label}\", " +
        "Parcs_FAB_Id  = \"${parcEnt.Parcs_FAB_Id}\", " +
        "Parcs_FAB_Label  = \"${parcEnt.Parcs_FAB_Label}\", " +
        "Parcs_NIV_Id  = \"${parcEnt.Parcs_NIV_Id}\", " +
        "Parcs_NIV_Label  = \"${parcEnt.Parcs_NIV_Label}\", " +
        "Parcs_ZNE_Id  = \"${parcEnt.Parcs_ZNE_Id}\", " +
        "Parcs_ZNE_Label  = \"${parcEnt.Parcs_ZNE_Label}\", " +
        "Parcs_EMP_Id  = \"${parcEnt.Parcs_EMP_Id}\", " +
        "Parcs_EMP_Label  = \"${parcEnt.Parcs_EMP_Label}\", " +
        "Parcs_LOT_Id  = \"${parcEnt.Parcs_LOT_Id}\", " +
        "Parcs_LOT_Label  = \"${parcEnt.Parcs_LOT_Label}\", " +
        "Parcs_SERIE_Id  = \"${parcEnt.Parcs_SERIE_Id}\", " +
        "Parcs_SERIE_Label  = \"${parcEnt.Parcs_SERIE_Label}\", " +
        "Parcs_Audit_Note  = \"${parcEnt.Parcs_Audit_Note}\", " +
        "Parcs_UUID  = \"${parcEnt.Parcs_UUID}\", " +
        "Parcs_UUID_Parent  = \"${parcEnt.Parcs_UUID_Parent}\", " +
        "Parcs_NCERT  = \"${parcEnt.Parcs_NCERT}\", " +
        "Parcs_NoSpec  = \"${parcEnt.Parcs_NoSpec}\", " +
        "Parcs_CodeArticle  = \"${parcEnt.Parcs_CodeArticle}\", " +
        "Parcs_CodeArticleES  = \"${parcEnt.Parcs_CodeArticleES}\", " +
        "Parcs_CODF  = \"${parcEnt.Parcs_CODF}\", " +
        "Livr        = \"${parcEnt.Livr}\", " +
        "Devis        = \"${parcEnt.Devis}\", " +
        "Action        = \"${parcEnt.Action}\", " +
        "Parcs_Verif_Note  = \"${parcEnt.Parcs_Verif_Note}\"";

    gColors.printWrapped("setParc_Ent A $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Ent ret $ret");
    return ret;
  }

  static Future<bool> delParc_Ent_Srv(int aparcsInterventionid) async {
    String aSQL = "DELETE FROM Parcs_Ent WHERE Parcs_InterventionId = $aparcsInterventionid ";
    print("delParc_Ent_Srv $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Ent_Srv ret $ret");
    return ret;
  }

  static Future<bool> delParc_Ent_Srv_Upd(int aparcsInterventionid) async {
    String wIn = "";

    for (int i = 0; i < DbTools.glfParcs_Ent.length; i++) {
      Parc_Ent aparcEnt = DbTools.glfParcs_Ent[i];
      if (wIn.isNotEmpty) wIn = "$wIn, ";
      wIn = "$wIn '${aparcEnt.Parcs_UUID}'";
    }

    print("delParc_Ent_Srv wIn $wIn");
    if (wIn.isNotEmpty) {
      String aSQL = "DELETE FROM Parcs_Ent WHERE Parcs_UUID in ($wIn)";
      print("delParc_Ent_Srv $aSQL");
      bool ret = await add_API_Post("upddel", aSQL);
      print("delParc_Ent_Srv ret $ret");
    }

    String aSQL = "DELETE FROM Parcs_Art WHERE ParcsArt_ParcsId = '$aparcsInterventionid'and ParcsArt_lnk = 'SO';";
    print("delParc_Art_Srv DEVIS SO $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Art_Srv DEVIS SO  $ret");

    return true;
  }

  static Future<bool> InsertUpdateParc_Ent_Srv(Parc_Ent aparcEnt) async {
    aparcEnt.Parcs_NCERT ??= "";
    aparcEnt.Parcs_NoSpec ??= "";
    aparcEnt.Parcs_CodeArticle ??= "";
    aparcEnt.Parcs_CodeArticleES ??= "";
    aparcEnt.Parcs_CODF ??= "";

    aparcEnt.Parcs_Intervention_Timer ??= 0;

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
        "NULL , ${aparcEnt.Parcs_order}, ${aparcEnt.Parcs_InterventionId},"
        "'${aparcEnt.Parcs_Type!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_Date_Rev!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_QRCode!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_FREQ_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_FREQ_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_ANN_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_ANN_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_FAB_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_FAB_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_NIV_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_NIV_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_ZNE_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_ZNE_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_EMP_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_EMP_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_LOT_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_LOT_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_SERIE_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_SERIE_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_Audit_Note!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_Verif_Note!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_UUID!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_UUID_Parent!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_NCERT!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_NoSpec!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_CodeArticle!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_CodeArticleES!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_CODF!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Livr!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Devis!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Action!.replaceAll("'", "‘")}',"
        "${aparcEnt.Parcs_Intervention_Timer})";

    gColors.printWrapped("setParc_Ent B $wSql");

    bool ret = await add_API_Post("insert", wSql);
    print("setParc_Ent ret $ret");
    return ret;
  }

  static Future<bool> InsertUpdateParc_Ent_Srv_Srv(Parc_Ent_Srv aparcEnt) async {
    if ("${aparcEnt.Parcs_Intervention_Timer}" == "null") aparcEnt.Parcs_Intervention_Timer = 0;

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
        "NULL , ${aparcEnt.Parcs_order}, ${aparcEnt.Parcs_InterventionId},"
        "'${aparcEnt.Parcs_Type!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_Date_Rev!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_QRCode!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_FREQ_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_FREQ_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_ANN_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_ANN_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_FAB_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_FAB_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_NIV_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_NIV_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_ZNE_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_ZNE_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_EMP_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_EMP_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_LOT_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_LOT_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_SERIE_Id!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_SERIE_Label!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_Audit_Note!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_Verif_Note!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_UUID!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_UUID_Parent!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_NCERT!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_NoSpec!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_CodeArticle!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_CodeArticleES!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_CODF!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Livr!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Devis!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Action!.replaceAll("'", "‘")}',"
        "'${aparcEnt.Parcs_Intervention_Timer}')";

    gColors.printWrapped("setParc_Ent C $wSql");
    bool ret = await add_API_Post("insert", wSql);
    print("setParc_Ent ret $ret");
    return ret;
  }

  static Future<bool> addParc_EntAdrType(int parcsInterventionid) async {
    String wValue = "NULL, $parcsInterventionid, ";
    String wSlq = "INSERT INTO Parcs_Ent (ParcsId, Parcs_InterventionId, ) VALUES ($wValue)";
    print("addParc_Ent $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Ent ret $ret");
    return ret;
  }

  static Future<bool> addParc_Ent(int parcsInterventionid) async {
    String wValue = "NULL, $parcsInterventionid";
    String wSlq = "INSERT INTO Parcs_Ent (ParcsId, Parcs_InterventionId) VALUES ($wValue)";
    print("addParc_Ent $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Ent ret $ret");
    return ret;
  }

  static Future<bool> delParc_Ent(Parc_Ent_Srv parcEnt) async {
    String aSQL = "DELETE FROM Parcs_Ent WHERE Parc_EntId = ${parcEnt.ParcsId} ";
    print("delParc_Ent $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Ent ret $ret");
    return ret;
  }

  static Future<List<Parc_Ent_Srv>> getParc_Ent_API_Post(String aType, String aSQL) async {
    setSrvToken();
    print("getParc_Ent_API_Post aSQL $aSQL");
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      print("getParc_Ent_API_Post items $items");

      if (items != null) {
        List<Parc_Ent_Srv> parcEntlist = await items.map<Parc_Ent_Srv>((json) {
          print("getParc_Ent_API_Post json $json");

          return Parc_Ent_Srv.fromJson(json);
        }).toList();
        return parcEntlist;
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
    print("getParc_DescAll ${ListParc_Desc.length}");
    if (ListParc_Desc.isNotEmpty) {
      print("getParc_DescAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_DescID(int ID) async {
    for (var element in ListParc_Desc) {
      if (element.ParcsDescId == ID) {
        gParc_Desc = element;
        continue;
      }
    }
  }

  static Future<bool> getParcs_DescInter(int parcsInterventionid) async {
    try {
      ListParc_Desc = await getParc_Desc_API_Post("select", "SELECT Parcs_Desc.* FROM Parcs_Desc, Parcs_Ent  WHERE ParcsDesc_ParcsId = ParcsId AND Parcs_InterventionId = $parcsInterventionid");
      if (ListParc_Desc.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setParc_Desc(Parc_Desc_Srv parcDesc) async {
    String wSlq = "UPDATE Parcs_Desc SET "
            "ParcsDescId            =   ${parcDesc.ParcsDescId}, " "ParcsDesc_ParcsId      =   ${parcDesc.ParcsDesc_ParcsId}, " "ParcsDesc_Type         = \"${parcDesc.ParcsDesc_Type}\", " "ParcsDesc_Id           = \"${parcDesc.ParcsDesc_Id}\", " "ParcsDesc_Lib          = \"${parcDesc.ParcsDesc_Lib}\" ";

    gColors.printWrapped("setParc_Desc $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Desc ret $ret");
    return ret;
  }

  static Future<bool> delParc_Desc_Srv(int aparcsdescParcsid) async {
    String aSQL = "DELETE FROM Parcs_Desc WHERE ParcsDesc_ParcsId = $aparcsdescParcsid ";
    print("delParc_Desc_Srv $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Desc_Srv ret $ret");
    return ret;
  }

  static Future<bool> InsertUpdateParc_Desc_Srv(Parc_Desc aparcDesc) async {
    String wSql = 'INSERT INTO Parcs_Desc(ParcsDescId, ParcsDesc_ParcsId, ParcsDesc_Type, ParcsDesc_Id, ParcsDesc_Lib) VALUES ('
        'NULL ,  ${aparcDesc.ParcsDesc_ParcsId},'
        '"${aparcDesc.ParcsDesc_Type}",'
        '"${aparcDesc.ParcsDesc_Id}",'
        '"${aparcDesc.ParcsDesc_Lib}")';
    print("InsertUpdateParc_Desc_Srv $wSql");
    bool ret = await add_API_Post("upddel", wSql);
    print("InsertUpdateParc_Desc_Srv ret $ret");
    return ret;
  }

  static Future<bool> InsertUpdateParc_Desc_Srv_Srv(Parc_Desc_Srv aparcDesc) async {
    String wSql = 'INSERT INTO Parcs_Desc(ParcsDescId, ParcsDesc_ParcsId, ParcsDesc_Type, ParcsDesc_Id, ParcsDesc_Lib) VALUES ('
        'NULL ,  ${aparcDesc.ParcsDesc_ParcsId},'
        '"${aparcDesc.ParcsDesc_Type}",'
        '"${aparcDesc.ParcsDesc_Id}",'
        '"${aparcDesc.ParcsDesc_Lib}")';
    print("InsertUpdateParc_Desc_Srv_Srv $wSql");
    bool ret = await add_API_Post("upddel", wSql);
    print("InsertUpdateParc_Desc_Srv_Srv ret $ret");
    return ret;
  }

  static String InsertUpdateParc_Desc_Srv_GetSql(Parc_Desc aparcDesc) {
    String wSql = 'INSERT INTO Parcs_Desc(ParcsDescId, ParcsDesc_ParcsId, ParcsDesc_Type, ParcsDesc_Id, ParcsDesc_Lib) VALUES ('
        'NULL ,  ${aparcDesc.ParcsDesc_ParcsId},'
        '"${aparcDesc.ParcsDesc_Type}",'
        '"${aparcDesc.ParcsDesc_Id}",'
        '"${aparcDesc.ParcsDesc_Lib}")';
//    print("InsertUpdateParc_Desc_Srv_GetSql " + wSql);
    return wSql;
  }

  static Future<bool> InsertUpdateParc_Desc_Srv_Sql(String wSql) async {
//    gColors.printWrapped("InsertUpdateParc_Desc_Srv_Sql " + wSql);
    bool ret = await add_API_Post("multi", wSql);
//    gColors.printWrapped("InsertUpdateParc_Desc_Srv_Sql ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_Desc(int parcsInterventionid) async {
    String wValue = "NULL, $parcsInterventionid";
    String wSlq = "INSERT INTO Parcs_Desc (ParcsId, Parcs_InterventionId) VALUES ($wValue)";
    print("addParc_Desc $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Desc ret $ret");
    return ret;
  }

  static Future<bool> delParc_Desc(Parc_Desc_Srv parcDesc) async {
    String aSQL = "DELETE FROM Parcs_Desc WHERE Parc_DescId = ${parcDesc.ParcsDescId} ";
    print("delParc_Desc $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Desc ret $ret");
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
        List<Parc_Desc_Srv> parcDesclist = await items.map<Parc_Desc_Srv>((json) {
          return Parc_Desc_Srv.fromJson(json);
        }).toList();
        return parcDesclist;
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
    print("getParc_ArtAll ${ListParc_Art.length}");
    if (ListParc_Art.isNotEmpty) {
      print("getParc_ArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_ArtID(int ID) async {
    for (var element in ListParc_Art) {
      if (element.ParcsArtId == ID) {
        gParc_Art = element;
        continue;
      }
    }
  }

  static Future<bool> getParcs_ArtInter(int parcsInterventionid) async {
    try {
      ListParc_Art = await getParc_Art_API_Post("select", "SELECT Parcs_Art.* FROM Parcs_Art, Parcs_Ent  WHERE ParcsArt_ParcsId = ParcsId AND Parcs_InterventionId = $parcsInterventionid");
      if (ListParc_Art.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getParcs_ArtInterSO(int parcsInterventionid) async {
    try {
      ListParc_ArtSO = await getParc_Art_API_Post("select", "SELECT Parcs_Art.* FROM Parcs_Art WHERE ParcsArt_lnk = 'SO' AND ParcsArt_ParcsId  = $parcsInterventionid");
      if (ListParc_ArtSO.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setParc_Art(Parc_Art_Srv parcArt) async {
    String wSlq = "UPDATE Parcs_Art SET "
            "ParcsArtId            =   ${parcArt.ParcsArtId}, " "ParcsArt_ParcsId      =   ${parcArt.ParcsArt_ParcsId}, " "ParcsArt_Id         = \"${parcArt.ParcsArt_Id}\", " "ParcsArt_Type           = \"${parcArt.ParcsArt_Type}\", " "ParcsArt_lnk           = \"${parcArt.ParcsArt_lnk}\", " +
        "ParcsArt_Fact           = \"${parcArt.ParcsArt_Fact}\", " +
        "ParcsArt_Livr           = \"${parcArt.ParcsArt_Livr}\", " +
        "ParcsArt_Qte      =   ${parcArt.ParcsArt_Qte}";

    gColors.printWrapped("setParc_Art $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Art ret $ret");
    return ret;
  }

  static Future<bool> delParc_Art_Srv(int aparcsdescParcsid) async {
    String aSQL = "DELETE FROM Parcs_Art WHERE ParcsDesc_ParcsId = $aparcsdescParcsid ";
    print("delParc_Art_Srv $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Art_Srv ret $ret");
    return ret;
  }

  static String InsertUpdateParc_Art_Srv_GetSql(Parc_Art aparcArt) {
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
        "${aparcArt.ParcsArt_ParcsId},"
        "'${aparcArt.ParcsArt_Id!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_Type!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_lnk!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_Fact!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_Livr!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_Lib!.replaceAll("'", "‘")}',"
        "${aparcArt.ParcsArt_Qte}"
        ")";
    return wSql;
  }

  static Future<bool> InsertUpdateParc_Art_Srv_Sql(String wSql) async {
    print("InsertUpdateParc_Art_Srv_Sql $wSql");
    bool ret = await add_API_Post("multi", wSql);
    print("InsertUpdateParc_Art_Srv_Sql ret $ret");
    return ret;
  }

  static Future<bool> InsertUpdateParc_Art_Srv(Parc_Art aparcArt) async {
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
        "${aparcArt.ParcsArt_ParcsId},"
        "'${aparcArt.ParcsArt_Id!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_Type!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_lnk!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_Fact!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_Livr!.replaceAll("'", "‘")}',"
        "'${aparcArt.ParcsArt_Lib!.replaceAll("'", "‘")}',"
        "${aparcArt.ParcsArt_Qte}"
        ")";
    print("setParc_Art $wSql");
    bool ret = await add_API_Post("upddel", wSql);
    //  print("setParc_Art ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_Art(int parcsInterventionid) async {
    String wValue = "NULL, $parcsInterventionid";
    String wSlq = "INSERT INTO Parcs_Art (ParcsId, Parcs_InterventionId) VALUES ($wValue)";
    print("addParc_Art $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Art ret $ret");
    return ret;
  }

  static Future<bool> delParc_Art(Parc_Art_Srv parcArt) async {
    String aSQL = "DELETE FROM Parcs_Art WHERE Parc_ArtId = ${parcArt.ParcsArtId} ";
    print("delParc_Art $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Art ret $ret");
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
        List<Parc_Art_Srv> parcArtlist = await items.map<Parc_Art_Srv>((json) {
          return Parc_Art_Srv.fromJson(json);
        }).toList();
        return parcArtlist;
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
  static Parc_Imgs_Srv gParc_Imgs = Parc_Imgs_Srv(0, 0, 0, 0, "", "", "");

  static Future<bool> getParc_ImgsAll() async {
    ListParc_Imgs = await getParc_Imgs_API_Post("select", "select * from Parcs_Imgs ORDER BY Parcs_Type");
    print("getParc_ImgsAll ${ListParc_Imgs.length}");
    if (ListParc_Imgs.isNotEmpty) {
      print("getParc_ImgsAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_ImgsID(int ID) async {
    for (var element in ListParc_Imgs) {
      if (element.Parc_Imgid == ID) {
        gParc_Imgs = element;
        continue;
      }
    }
  }

  static Future<bool> getParcs_ImgsInter(int parcsInterventionid) async {
    try {
      print(" getParcs_ImgsInter SELECT Parcs_Imgs.* FROM Parcs_Imgs, Parcs_Ent  WHERE Parc_Imgs_ParcsId = ParcsId AND Parcs_InterventionId = $parcsInterventionid");

      ListParc_Imgs = await getParc_Imgs_API_Post("select", "SELECT Parcs_Imgs.* FROM Parcs_Imgs, Parcs_Ent  WHERE Parc_Imgs_ParcsId = ParcsId AND Parcs_InterventionId = $parcsInterventionid");
      if (ListParc_Imgs.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setParc_Imgs(Parc_Imgs_Srv parcImgs) async {
    String wSlq = "UPDATE Parcs_Imgs SET "
            "Parc_Imgid            =   ${parcImgs.Parc_Imgid}, " "Parc_Imgs_ParcsId      =   ${parcImgs.Parc_Imgs_ParcsId}, " "Parc_Imgs_Type      =   ${parcImgs.Parc_Imgs_Type}, " "Parc_Imgs_Principale      =   ${parcImgs.Parc_Imgs_Principale}, " "Parc_Imgs_Date         = \"${parcImgs.Parc_Imgs_Date}\", " +
        "Parc_Imgs_Data         = \"${parcImgs.Parc_Imgs_Data}\", " +
        "Parc_Imgs_Path           = \"${parcImgs.Parc_Imgs_Path}\" ";

    gColors.printWrapped("setParc_Imgs $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Imgs ret $ret");
    return ret;
  }

  static Future<bool> delParc_Imgs_Srv(int parcImgid) async {
    String aSQL = "DELETE FROM Parcs_Imgs WHERE Parc_Imgid = $parcImgid ";
    print("delParc_Imgs_Srv $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Imgs_Srv ret $ret");
    return ret;
  }

  int? Parc_Imgid = 0;
  int? Parc_Imgs_ParcsId = 0;
  int? Parc_Imgs_Type = 0;
  int? Parc_Imgs_Principale = 0;
  String? Parc_Imgs_Date = "";
  String? Parc_Imgs_Data = "";
  String? Parc_Imgs_Path = "";

  static String InsertUpdateParc_Imgs_Srv_GetSql(Parc_Img aparcImgs) {
    String wSql = "INSERT INTO Parcs_Imgs("
        "Parc_Imgid, "
        "Parc_Imgs_ParcsId, "
        "Parc_Imgs_Type, "
        "Parc_Imgs_Principale, "
        "Parc_Imgs_Date, "
        "Parc_Imgs_Data, "
        "Parc_Imgs_Path "
        ") VALUES ("
        "NULL ,  "
        "${aparcImgs.Parc_Imgid},"
        "${aparcImgs.Parc_Imgs_ParcsId},"
        "${aparcImgs.Parc_Imgs_Type},"
        "${aparcImgs.Parc_Imgs_Principale},"
        "'${aparcImgs.Parc_Imgs_Date!.replaceAll("'", "‘")}',"
        "'${aparcImgs.Parc_Imgs_Data!.replaceAll("'", "‘")}',"
        "'${aparcImgs.Parc_Imgs_Path!.replaceAll("'", "‘")}' "
        ")";
    return wSql;
  }

  static Future<bool> InsertUpdateParc_Imgs_Srv_Sql(String wSql) async {
    print("InsertUpdateParc_Imgs_Srv_Sql $wSql");
    bool ret = await add_API_Post("multi", wSql);
    print("InsertUpdateParc_Imgs_Srv_Sql ret $ret");
    return ret;
  }

  static Future<bool> InsertUpdateParc_Imgs_Srv(Parc_Img aparcImgs) async {
    String wSql = "INSERT INTO Parcs_Imgs("
        "Parc_Imgid, "
        "Parc_Imgs_ParcsId, "
        "Parc_Imgs_Type, "
        "Parc_Imgs_Principale, "
        "Parc_Imgs_Date, "
        "Parc_Imgs_Data, "
        "Parc_Imgs_Path "
        ") VALUES ("
        "NULL ,  "
        "${aparcImgs.Parc_Imgs_ParcsId},"
        "${aparcImgs.Parc_Imgs_Type},"
        "${aparcImgs.Parc_Imgs_Principale},"
        "'${aparcImgs.Parc_Imgs_Date!.replaceAll("'", "‘")}',"
        "'${aparcImgs.Parc_Imgs_Data!.replaceAll("'", "‘")}',"
        "'${aparcImgs.Parc_Imgs_Path!.replaceAll("'", "‘")}' "
        ")";
//    print("setParc_Imgs " + wSql);
    bool ret = await add_API_Post("upddel", wSql);
    //  print("setParc_Imgs ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_Imgs(int parcsInterventionid) async {
    String wValue = "NULL, $parcsInterventionid";
    String wSlq = "INSERT INTO Parcs_Imgs (ParcsId, Parcs_InterventionId) VALUES ($wValue)";
    print("addParc_Imgs $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Imgs ret $ret");
    return ret;
  }

  static Future<bool> delParc_Imgs(Parc_Imgs_Srv parcImgs) async {
    String aSQL = "DELETE FROM Parcs_Imgs WHERE Parc_ImgsId = ${parcImgs.Parc_Imgid} ";
    print("delParc_Imgs $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Imgs ret $ret");
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
        List<Parc_Imgs_Srv> parcImgslist = await items.map<Parc_Imgs_Srv>((json) {
          return Parc_Imgs_Srv.fromJson(json);
        }).toList();
        return parcImgslist;
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
      if (ListContact.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getContactClientAdrType(int ClientID, int AdresseId, String Type) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $ClientID AND Contact_AdresseId = $AdresseId AND Contact_Type = '$Type' ORDER BY Contact_Type";
    print("getContactClientAdrType $wSlq");

    try {
      ListContact = await getContact_API_Post("select", wSlq);
      print("getContact_API_Post ");
      print("getContact_API_Post ${ListContact.length}");
      if (ListContact.isNotEmpty) {
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
    //  print("getContactClientType ${ListContact.length}");
    if (ListContact.isNotEmpty) {
      gContact = ListContact[0];
      //  print("getContactClientType return TRUE");
      return true;
    } else {}
    return false;
  }

  static Future getContactID(int ID) async {
    for (var element in ListContact) {
      if (element.ContactId == ID) {
        gContact = element;
        continue;
      }
    }
  }

  static Future<bool> setContact(Contact Contact) async {
    String wSlq = "UPDATE Contacts SET "
            "Contact_ClientId     =   ${Contact.Contact_ClientId}, " "Contact_AdresseId     =   ${Contact.Contact_AdresseId}, " "Contact_Code             = \"${Contact.Contact_Code}\", " "Contact_Type             = \"${Contact.Contact_Type}\", " "Contact_Nom              = \"${Contact.Contact_Nom}\", " +
        "Contact_Civilite         = \"${Contact.Contact_Civilite}\", " +
        "Contact_Prenom           = \"${Contact.Contact_Prenom}\", " +
        "Contact_Fonction         = \"${Contact.Contact_Fonction}\", " +
        "Contact_Service          = \"${Contact.Contact_Service}\", " +
        "Contact_Tel1             = \"${Contact.Contact_Tel1}\", " +
        "Contact_Tel2             = \"${Contact.Contact_Tel2}\", " +
        "Contact_eMail            = \"${Contact.Contact_eMail}\", " +
        "Contact_Rem              = \"${Contact.Contact_Rem}\" " +
        "WHERE ContactId      = ${Contact.ContactId.toString()}";

    gColors.printWrapped("setContact sql $wSlq");
    try {
      bool ret = await add_API_Post("upddel", wSlq);
      print("setContact ret $ret");
      return ret;
    } catch (e) {
      print("setContact ERROR $e");
      return false;
    }
  }

  static Future<bool> addContactAdrType(int contactClientid, int contactAdresseid, String Type) async {
    String wValue = "NULL, $contactClientid, $contactAdresseid, '$Type'";
    String wSlq = "INSERT INTO Contacts (ContactId, Contact_ClientId, Contact_AdresseId, Contact_Type) VALUES ($wValue)";
    print("addContact $wSlq");
    try {
      bool ret = await add_API_Post("insert", wSlq);
      print("addContact ret $ret");
      return ret;
    } catch (e) {
      print("addContact ERROR $e");
      return false;
    }
  }

  static Future<bool> addContact(int contactClientid) async {
    String wValue = "NULL, $contactClientid";
    String wSlq = "INSERT INTO Contacts (ContactId, Contact_ClientId) VALUES ($wValue)";
    print("addContact $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addContact ret $ret");
    return ret;
  }

  static Future<bool> getContactGrp(int contactClientid, int contactAdresseid) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $contactClientid AND Contact_AdresseId = $contactAdresseid AND Contact_Type = 'GRP' ORDER BY Contact_Type";
    try {
      ListContact = await getContact_API_Post("select", wSlq);
      if (ListContact.isNotEmpty) {
        gContact = ListContact[0];
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getContactSite(int contactClientid, int contactAdresseid) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $contactClientid AND Contact_AdresseId = $contactAdresseid AND Contact_Type = 'SITE' ORDER BY Contact_Type";

    ListContact = await getContact_API_Post("select", wSlq);
    //  print("getContactClientType ${ListContact.length}");
    if (ListContact.isNotEmpty) {
      gContact = ListContact[0];
      //  print("getContactClientType return TRUE");
      return true;
    } else {}
    return false;
  }

  static Future<bool> delContact(Contact Contact) async {
    String aSQL = "DELETE FROM Contacts WHERE ContactId = ${Contact.ContactId} ";
    print("delContact $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delContact ret $ret");
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
    print("getArtAll ${ListArt.length}");
    if (ListArt.isNotEmpty) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getArtAll() async {
    ListArt = await getArt_API_Post("select", "select * from Articles ORDER BY Art_Lib");
    print("getArtAll ${ListArt.length}");
    if (ListArt.isNotEmpty) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getArtAll_A() async {
    ListArt = await getArt_API_Post("select", "select * from Articles WHERE Art_Id LIKE 'A%'  ORDER BY Art_Lib");
    print("getArtAll ${ListArt.length}");
    if (ListArt.isNotEmpty) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getArtAll_S() async {
    ListArt = await getArt_API_Post("select", "select * from Articles WHERE Art_Id LIKE 'S%' ORDER BY Art_Lib");
    print("getArtAll ${ListArt.length}");
    if (ListArt.isNotEmpty) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getArtAll_E() async {
    ListArt = await getArt_API_Post("select", "select * from Articles WHERE Art_Id LIKE 'E%'  ORDER BY Art_Lib");
    print("getArtAll ${ListArt.length}");
    if (ListArt.isNotEmpty) {
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
            "Art_Groupe = \"${Art.Art_Groupe}\", " "Art_Fam = \"${Art.Art_Fam}\", " "Art_Sous_Fam = \"${Art.Art_Sous_Fam}\", " "Art_Id = \"${Art.Art_Id}\", " "Art_Lib = \"${Art.Art_Lib}\", " +
        "Art_Stock = ${Art.Art_Stock.toString()} "
            "WHERE ArtId = ${Art.ArtId.toString()}";
    gColors.printWrapped("setArt $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setArt ret $ret");
    return ret;
  }

  static Future<bool> addArt(Art Art) async {
    String wValue = "NULL,'???','???','???','???','---', 0";
    String wSlq = "INSERT INTO Articles (ArtId, Art_Groupe  ,Art_Fam     ,Art_Sous_Fam,Art_Id      ,Art_Lib     ,Art_Stock) VALUES ($wValue)";
    print("addArt $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addArt ret $ret");
    return ret;
  }

  static Future<bool> delArt(Art Art) async {
    String aSQL = "DELETE FROM Articles WHERE ArtId = ${Art.ArtId} ";
    print("delArt $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delArt ret $ret");
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

  static List<ValueItem> ValueItem_parseStringToArray(String wTmp) {

    RegExp regExp = RegExp(r"ValueItem\(label: ([^,]+), value: (\d+)\)");

    Iterable<Match> matches = regExp.allMatches(wTmp);
    List<ValueItem> items = matches.map((match) {
      String label = match.group(1)!.trim().toString();
      String value = match.group(2)!.toString();
      return ValueItem(label: label, value: value);
    }).toList();

    return items;
  }

  static List<User> ListUser = [];
  static List<User> ListUsersearchresult = [];
  static User gUser = User.UserInit();
  static User gUserLogin = User.UserInit();
  static int gLoginID = -1;

  static List<String> gUserLogin_Art_Fav = [];
  static List<String> wUserLogin_Art_Fav = [];

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> getUserLogin(String aMail, String aPW) async {
    gObj.wImage = const Image(
      image: AssetImage('assets/images/Avatar.png'),
      height: 100,
    );

    print("getUserLogin A");

    List<User> ListUser = [];
    try {
      String wSql = "select * from Users where User_Mail = '$aMail' AND User_PassWord = '$aPW' AND User_Actif = true";
      print("getUserLogin B $wSql");
      ListUser = await getUser_API_Post("select", wSql);
      print("getUserLogin C");
      print("getUserLogin D");
    } catch (e) {

      print("getUserLogin ERROR $e");


      List<User> wListUser = await DbTools.getUsers();
      if (wListUser.isEmpty) return false;
      gUserLogin = wListUser[0];
      gLoginID = gUserLogin.UserID;
      Srv_DbTools.ListUser_Hab = await DbTools.getUser_Hab();
      Srv_DbTools.ListUser_Desc = await DbTools.getUser_Desc();
      String wPicUser = await SharedPref.getStrKey("picUser", "");
      gObj.picUser = base64Decode(wPicUser);

      if (gObj.pic.isNotEmpty) {
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

      print("wImgPath $wImgPath");
      gObj.picUser = await gObj.networkImageToByte(wImgPath);
      await SharedPref.setStrKey("picUser", base64Encode(gObj.picUser));
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      await SharedPref.setIntKey("timestampLogin", timestamp);

      print("gObj.picUser ${gObj.picUser.length}");

      if (gObj.pic.isNotEmpty) {
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
        User_Hab wuserHab = Srv_DbTools.ListUser_Hab[i];
        await DbTools.inserUser_Hab(wuserHab);
      }
      Srv_DbTools.ListUser_Hab = await DbTools.getUser_Hab();

      await Srv_DbTools.getUser_Desc(Srv_DbTools.gLoginID);
      print("Import_DataDialog ListUser_Desc ${Srv_DbTools.ListUser_Desc.length}");
      await DbTools.TrunckUser_Desc();
      for (int i = 0; i < Srv_DbTools.ListUser_Desc.length; i++) {
        User_Desc wuserDesc = Srv_DbTools.ListUser_Desc[i];
        await DbTools.inserUser_Desc(wuserDesc);
      }
      Srv_DbTools.ListUser_Desc = await DbTools.getUser_Desc();

      return true;
    }

    return false;
  }

  static Future<bool> getUserName(String aName) async {
    List<User> ListUser = await getUser_API_Post("select", "select * from Users where User_Nom = '$aName'");

    print("getUserName ${ListUser.length}");

    if (ListUser.isNotEmpty) {
      print("getUserName return TRUE");

      return true;
    }

    return false;
  }

  static Future<bool> getUserAll() async {
    try {
      ListUser = await getUser_API_Post("select", "select * from Users WHERE User_Actif = 1 AND User_Matricule > 0 ORDER BY User_Nom");
      if (ListUser.isNotEmpty) {
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

    if (ListUser.length == 1) {
      gUser = ListUser[0];
      return true;
    }
    return false;
  }

  static Future<bool> getUserLoginid(int id) async {
    gUserLogin_Art_Fav = [];
    String wSql = "select * from Users where UserID = $id ";
    List<User> ListUser = await getUser_API_Post("select", wSql);
    print(">>>>> ListUser.length ${ListUser.length}");
    if (ListUser.length == 1) {
      gUserLogin = ListUser[0];
      gUserLogin_Art_Fav = gUserLogin.User_Art_Fav.split(',');

      print(" gUserLogin_Art_Fav $gUserLogin_Art_Fav");

      return true;
    }
    return false;
  }

  static Future<bool> getUserMat(String id) async {
    print(">>>>> getUserid $id");
    List<User> ListUser = await getUser_API_Post("select", "select * from Users where User_Matricule = $id ");
    print("<<<<< getUserid");

    print(">>>>>>>>>>>>>> ListPost ${ListUser.length}");

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

      print(">>>>>>>>>>>>>> getUser_API_Post items $items");


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
    String wSlq = "UPDATE Users SET User_Nom = \"${User.User_Nom}\", User_Mail = \"${User.User_Mail}\", User_Token_FBM = \"$Token_FBM\"  WHERE UserID = ${User.UserID}";
    print("setUser $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setUser ret $ret");
    return ret;
  }

  static Future<bool> setUser_DCL(User aUser) async {
    String wSlq = 'UPDATE Users SET '
        'User_DCL_Ent_Validite = "${aUser.User_DCL_Ent_Validite}", '
        'User_DCL_Ent_LivrPrev = "${aUser.User_DCL_Ent_LivrPrev}", '
        'User_DCL_Ent_ModeRegl = "${aUser.User_DCL_Ent_ModeRegl}", '
        'User_DCL_Ent_MoyRegl = "${aUser.User_DCL_Ent_MoyRegl}", '
        'User_DCL_Ent_Valo = ${aUser.User_DCL_Ent_Valo}, '
        'User_DCL_Ent_PrefAff = "${aUser.User_DCL_Ent_PrefAff}", '
        'User_DCL_Ent_RelAuto = "${aUser.User_DCL_Ent_RelAuto}", '
        'User_DCL_Ent_RelAnniv = "${aUser.User_DCL_Ent_RelAnniv}", '
        'User_DCL_Ent_CopRel = "${aUser.User_DCL_Ent_CopRel}" '
        'WHERE UserID = ${aUser.UserID}';
    print("setUser $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setUser ret $ret");
    return ret;
  }

  static Future<bool> setUserArtFav(User User) async {
    Srv_DbTools.gUserLogin.User_Art_Fav = Srv_DbTools.gUserLogin_Art_Fav.join(',');
    String wSlq = "UPDATE Users SET User_Art_Fav = '${User.User_Art_Fav}' WHERE UserID = ${User.UserID}";
    print("setUserArtFav $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setUserArtFav ret $ret");
    return ret;
  }

  static Future<bool> addUser(User User) async {
    print("User.User_Token_FBM $Token_FBM");

    String wValue = 'NULL,${User.User_Actif} ,"$Token_FBM",   "$simCountryCode",   "${User.User_Nom}", "${User.User_Prenom} ", "${User.User_Adresse1}", "${User.User_Adresse2}", "${User.User_Cp}", "${User.User_Ville} ", "${User.User_Tel} ", "${User.User_Mail}", "${User.User_PassWord}"';
    String wSlq = "INSERT INTO Users ("
        "UserID,User_AuthID,User_Actif,User_Verif,User_Verif_Demande,User_Abus,User_Token_FBM,User_simCountryCode,User_NickName,User_Nom,User_Prenom,User_Adresse1,User_Adresse2,User_Cp,User_Ville,User_Tel,User_Mail,User_PassWord,User_DateNaissance,User_Note,User_Sexe) "
        "VALUES ($wValue)";
    print("addUser $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addUser ret $ret");
    return ret;
  }

  //*****************************
  //*****************************
  //*****************************

  static List<User_Hab> ListUser_Hab = [];
  static List<User_Hab> ListUser_Habsearchresult = [];
  static User_Hab gUser_Hab = User_Hab.User_HabInit();

  static Future<bool> getUser_Hab(int userHabUserid) async {
    ListUser_Hab = await getUser_Hab_API_Post("select", "select Users_Hab.*, Param_Hab_PDT, Param_Hab_Grp from Users_Hab, Param_Hab where User_Hab_Param_HabID = Param_HabID AND User_Hab_UserID = $userHabUserid ORDER BY User_Hab_Ordre,User_HabID");

    if (ListUser_Hab.isNotEmpty) {
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
      User_Hab userHab = ListUser_Hab[i];

      if (userHab.Param_Hab_PDT.compareTo(PDT) == 0) {
        if (userHab.User_Hab_MaintPrev) Hab_PDT = 1;
        if (userHab.User_Hab_MaintCorrect) Hab_PDT = 2;
        if (userHab.User_Hab_Install) Hab_PDT = 3;

        User_Hab_MaintPrev = userHab.User_Hab_MaintPrev;
        User_Hab_MaintCorrect = userHab.User_Hab_MaintCorrect;
        User_Hab_Install = userHab.User_Hab_Install;

        return;
      }
    }
  }

  static Future<List<User_Hab>> getUser_Hab_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "$gLoginID"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<User_Hab> userHablist = await items.map<User_Hab>((json) {
          return User_Hab.fromJson(json);
        }).toList();
        return userHablist;
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

  static Future<bool> getParam_Av(int paramAvUserid) async {
    ListParam_Av = await getParam_Av_API_Post("select", "select * from Param_Av ORDER BY Param_AvID");
    return false;
  }

  static Future<List<SrvParam_Av>> getParam_Av_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "$gLoginID"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<SrvParam_Av> paramAvlist = await items.map<SrvParam_Av>((json) {
          return SrvParam_Av.fromJson(json);
        }).toList();
        return paramAvlist;
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

  static Future<bool> getUser_Desc(int userDescUserid) async {
    ListUser_Desc = await getUser_Desc_API_Post("select", "SELECT Users_Desc.*, Param_Saisie_Param_Label FROM Users_Desc, Param_Saisie_Param WHERE User_Desc_Param_DescID = Param_Saisie_ParamId AND Param_Saisie_Param_Id = 'DESC' AND User_Desc_UserID = $userDescUserid");

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
      User_Desc userDesc = ListUser_Desc[i];

      if (userDesc.User_Desc_Param_DescID == DescID) {
        if (userDesc.User_Desc_MaintPrev) Hab_Desc = 1;
        if (userDesc.User_Desc_MaintCorrect) Hab_Desc = 2;
        if (userDesc.User_Desc_Install) Hab_Desc = 3;

        User_Desc_MaintPrev = userDesc.User_Desc_MaintPrev;
        User_Desc_MaintCorrect = userDesc.User_Desc_MaintCorrect;
        User_Desc_Install = userDesc.User_Desc_Install;
      }
    }
  }

  static Future<List<User_Desc>> getUser_Desc_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "$gLoginID"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<User_Desc> userDesclist = await items.map<User_Desc>((json) {
          return User_Desc.fromJson(json);
        }).toList();
        return userDesclist;
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
    final paramSaisieOrdreAffichagea = a.Param_Saisie_Ordre;
    final paramSaisieOrdreAffichageb = b.Param_Saisie_Ordre;
    if (paramSaisieOrdreAffichagea < paramSaisieOrdreAffichageb) {
      return -1;
    } else if (paramSaisieOrdreAffichagea > paramSaisieOrdreAffichageb) {
      return 1;
    } else {
      return 0;
    }
  }

  static int affSort2Comparison(Param_Saisie a, Param_Saisie b) {
    final paramSaisieOrdreAffichagea = a.Param_Saisie_Ordre_Affichage;
    final paramSaisieOrdreAffichageb = b.Param_Saisie_Ordre_Affichage;
    if (paramSaisieOrdreAffichagea < paramSaisieOrdreAffichageb) {
      return -1;
    } else if (paramSaisieOrdreAffichagea > paramSaisieOrdreAffichageb) {
      return 1;
    } else {
      return 0;
    }
  }

  static int affL1SortComparison(Param_Saisie a, Param_Saisie b) {
    final paramSaisieOrdreAffichagea = a.Param_Saisie_Affichage_L1_Ordre;
    final paramSaisieOrdreAffichageb = b.Param_Saisie_Affichage_L1_Ordre;
    if (paramSaisieOrdreAffichagea < paramSaisieOrdreAffichageb) {
      return -1;
    } else if (paramSaisieOrdreAffichagea > paramSaisieOrdreAffichageb) {
      return 1;
    } else {
      return 0;
    }
  }

  static int affL2SortComparison(Param_Saisie a, Param_Saisie b) {
    final paramSaisieOrdreAffichagea = a.Param_Saisie_Affichage_L2_Ordre;
    final paramSaisieOrdreAffichageb = b.Param_Saisie_Affichage_L2_Ordre;
    if (paramSaisieOrdreAffichagea < paramSaisieOrdreAffichageb) {
      return -1;
    } else if (paramSaisieOrdreAffichagea > paramSaisieOrdreAffichageb) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future<bool> getParam_SaisieAll() async {
    ListParam_Saisie = await getParam_Saisie_API_Post("select", "select * from Param_Saisie ORDER BY Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_Ordre,Param_Saisie_ID");
    print("getParam_SaisieAll ${ListParam_Saisie.length}");
    if (ListParam_Saisie.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<bool> getParam_Saisie(String paramSaisieOrgane, String paramSaisieType) async {
    ListParam_Saisie.clear();
    try {
      ListParam_Saisie = await getParam_Saisie_API_Post("select", "select * from Param_Saisie WHERE Param_Saisie_Organe = '$paramSaisieOrgane' AND Param_Saisie_Type = '$paramSaisieType'  ORDER BY Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_Ordre,Param_Saisie_ID");
      if (ListParam_Saisie.isNotEmpty) {
        int i = 1;
        for (var element in ListParam_Saisie) {
          print(">>>>>>>>>>> getParam_Saisie $paramSaisieOrgane $paramSaisieType ${element.toMap()}");

          element.Param_Saisie_Ordre = i++;
          setParam_Saisie(element);
        }
        return true;
      }
      return false;
    } catch (e) {
      print("•••• •••• •••• •••• error ${ListParam_Saisie.length}");
      await DbTools.getParam_Saisie(paramSaisieOrgane, paramSaisieType);
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
    Param_Saisie wparamSaisie = Param_Saisie.Param_SaisieInit();
    ListParam_Saisie.forEach((element) async {
      if (element.Param_Saisie_ID.compareTo(type) == 0) {
        wparamSaisie = element;
      }
    });
    return wparamSaisie;
  }

  static Future<List<Param_Saisie>> getParam_Saisie_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "$gLoginID"});

    http.StreamedResponse response = await request.send();
    print("response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      print("items $items");

      if (items != null) {
        List<Param_Saisie> paramSaisielist = await items.map<Param_Saisie>((json) {
          return Param_Saisie.fromJson(json);
        }).toList();
        print("Param_SaisieList ${paramSaisielist.length}");
        return paramSaisielist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<bool> setParam_Saisie(Param_Saisie paramSaisie) async {
    String wSlq = "UPDATE Param_Saisie SET "
            "Param_SaisieId = \"${paramSaisie.Param_SaisieId}\"," "Param_Saisie_Organe = \"${paramSaisie.Param_Saisie_Organe}\"," "Param_Saisie_Type = \"${paramSaisie.Param_Saisie_Type}\"," "Param_Saisie_ID = \"${paramSaisie.Param_Saisie_ID}\"," "Param_Saisie_Label = \"${paramSaisie.Param_Saisie_Label}\"," +
        "Param_Saisie_Aide = \"${paramSaisie.Param_Saisie_Aide}\"," +
        "Param_Saisie_Controle =  \"${paramSaisie.Param_Saisie_Controle}\"," +
        "Param_Saisie_Ordre = ${paramSaisie.Param_Saisie_Ordre.toString()}," +
        "Param_Saisie_Affichage = \"${paramSaisie.Param_Saisie_Affichage.toString()}\"," +
        "Param_Saisie_Icon = \"${paramSaisie.Param_Saisie_Icon.toString()}\"," +
        "Param_Saisie_Ordre_Affichage = ${paramSaisie.Param_Saisie_Ordre_Affichage.toString()}" +
        " WHERE Param_SaisieId = " +
        paramSaisie.Param_SaisieId.toString();
//    print("setParam_Saisie " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
//    print("setParam_Saisie ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParam_Saisie(Param_Saisie paramSaisie) async {
    String wValue = "NULL,'${paramSaisie.Param_Saisie_Organe}','${paramSaisie.Param_Saisie_Type}','???','---'";
    String wSlq = "INSERT INTO Param_Saisie (Param_SaisieId, Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_ID,Param_Saisie_Label) VALUES ($wValue)";
    print("addParam_Saisie $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Saisie ret $ret");
    return ret;
  }

  static Future<bool> delParam_Saisie(Param_Saisie paramSaisie) async {
    String aSQL = "DELETE FROM Param_Saisie WHERE Param_SaisieId = ${paramSaisie.Param_SaisieId} ";
    print("delParam_Saisie $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Saisie ret $ret");
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
  static List<Param_Param> ListParam_Param_Affaire = [];
  static List<Param_Param> ListParam_Param_Proba = [];

  static List<Param_Param> ListParam_Param_Validite_devis = [];

  static List<Param_Param> ListParam_Param_Livraison_prev = [];
  static List<Param_Param> ListParam_Param_Mode_rglt = [];
  static List<Param_Param> ListParam_Param_Moyen_paiement = [];
  static List<Param_Param> ListParam_Param_Pref_Aff = [];
  static List<Param_Param> ListParam_Param_Rel_Auto = [];

  static List<Param_Param> ListParam_Param_Rel_Anniv = [];
  static List<Param_Param> ListParam_Paramsearchresult = [];

  static List<Param_Param> ListParam_Param_TitresRel = [];

  static Param_Param gParam_Param = Param_Param.Param_ParamInit();

  static Future<bool> getParam_ParamAll() async {
    String wSql = "select * from Param_Param ORDER BY Param_Param_Ordre,Param_Param_ID";
    print("getParam_ParamAll $wSql");
    ListParam_ParamAll = await getParam_Param_API_Post("select", wSql);

    print("getParam_ParamAll ${ListParam_Param.length}");

    if (ListParam_ParamAll.isNotEmpty) {
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
    for (var element in ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo(wFam) == 0) {
        ListParam_ParamFam.add(element.Param_Param_Text);
        ListParam_ParamFamID.add(element.Param_Param_ID);
      }
    }

    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();

    ListParam_FiltreFam.add("Tous");
    ListParam_FiltreFamID.add("*");

    ListParam_FiltreFam.addAll(ListParam_ParamFam);
    ListParam_FiltreFamID.addAll(ListParam_ParamFamID);

    return true;
  }

  static Future<bool> getParam_Param(String paramParamType) async {
    ListParam_Param = await getParam_Param_API_Post("select", "select * from Param_Param WHERE Param_Param_Type = '$paramParamType' ORDER BY Param_Param_Ordre,Param_Param_ID");

    print("getParam_Param aSQL select * from Param_Param WHERE Param_Param_Type = '$paramParamType' ORDER BY Param_Param_Ordre,Param_Param_ID");
//        print("getParam_ParamAll ${ListParam_Param.length}");
    if (ListParam_Param.isNotEmpty) {
      print("getParam_ParamAll return TRUE");
      int i = 1;
      for (var element in ListParam_Param) {
        element.Param_Param_Ordre = i++;
        setParam_Param(element);
      }
      return true;
    }

    return false;
  }

  static Param_Param getParam_Param_in_Mem(
    String paramParamType,
    String paramParamId,
  ) {
    for (int i = 0; i < ListParam_ParamAll.length; i++) {
      Param_Param element = ListParam_ParamAll[i];
      if (element.Param_Param_Type.compareTo(paramParamType) == 0 && element.Param_Param_ID.compareTo(paramParamId) == 0) {
        return element;
      }
    }
    return Param_Param.Param_ParamInit();
  }

  static bool getParam_ParamMem(String paramSaisieId) {
    ListParam_Param.clear();
    for (var element in ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo(paramSaisieId) == 0) {
        ListParam_Param.add(element);
      }
    }
    return true;
  }

  static bool getParam_ParamMemDet(String paramParamType, String paramParamId) {
    ListParam_Param.clear();
    for (var element in ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo(paramParamType) == 0 && element.Param_Param_ID.compareTo(paramParamId) == 0) {
        ListParam_Param.add(element);
      }
    }
    return true;
  }

  static Future<bool> setParam_Param(Param_Param paramParam) async {
    String wSlq = "UPDATE Param_Param SET Param_Param_Text = \"${paramParam.Param_Param_Text}\", Param_Param_ID = \"${paramParam.Param_Param_ID}\", Param_Param_Int = ${paramParam.Param_Param_Int}, Param_Param_Ordre = ${paramParam.Param_Param_Ordre}, Param_Param_Double = ${paramParam.Param_Param_Double} WHERE Param_ParamId = ${paramParam.Param_ParamId}";
    print("setParam_Param $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParam_Param ret $ret");
    return ret;
  }

  static Future<bool> addParam_Param(Param_Param paramParam) async {
    String wValue = "NULL,'${paramParam.Param_Param_Type}','???','---'";
    String wSlq = "INSERT INTO Param_Param (Param_ParamId,Param_Param_Type,Param_Param_ID,Param_Param_Text) VALUES ($wValue)";
    print("addParam_Param $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Param ret $ret");
    return ret;
  }

  static Future<bool> delParam_Param(Param_Param paramParam) async {
    String aSQL = "DELETE FROM Param_Param WHERE Param_ParamId = ${paramParam.Param_ParamId} ";
    print("delParam_Param $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Param ret $ret");
    return ret;
  }

  static Future<List<Param_Param>> getParam_Param_API_Post(String aType, String aSQL) async {
    setSrvToken();

    print("getParam_Param_API_Post aSQL $aSQL");

    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "$gLoginID"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Param_Param> paramParamlist = await items.map<Param_Param>((json) {
          //print("getParam_Param_API_Post json " + json.toString());
          return Param_Param.fromJson(json);
        }).toList();
        return paramParamlist;
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
    final paramSaisieOrdreAffichagea = a.Param_Saisie_Param_Ordre;
    final paramSaisieOrdreAffichageb = b.Param_Saisie_Param_Ordre;
    if (paramSaisieOrdreAffichagea < paramSaisieOrdreAffichageb) {
      return -1;
    } else if (paramSaisieOrdreAffichagea > paramSaisieOrdreAffichageb) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future<bool> getParam_Saisie_ParamAll() async {
    ListParam_Saisie_ParamAll.clear();
    try {
      ListParam_Saisie_ParamAll = await getParam_Saisie_Param_API_Post("select", "select * from Param_Saisie_Param ORDER BY Param_Saisie_Param_Id,Param_Saisie_Param_Ordre");
      if (ListParam_Saisie_ParamAll.isNotEmpty) {
        for (int i = 0; i < ListParam_Saisie_ParamAll.length; i++) {
          Param_Saisie_Param element = ListParam_Saisie_ParamAll[i];
          element.Param_Saisie_Param_Ico = await gObj.getAssetImage("assets/images/Aide_Ico_${element.Param_Saisie_Param_Label}.png");
//          if (element.Param_Saisie_Param_Ico.toString().contains("AssetImage"))
//          print("Param_Saisie_Param_Ico ${element.Param_Saisie_Param_Ico.toString()}");
        }
        return true;
      }
      return false;
    } catch (e) {
      await DbTools.getParam_Saisie_ParamAll();
      return false;
    }
  }

  static Future<bool> getParam_Saisie_Param(String paramSaisieParamId) async {
    String wSql = "select * from Param_Saisie_Param WHERE Param_Saisie_Param_Id = '$paramSaisieParamId' ORDER BY Param_Saisie_Param_Id,Param_Saisie_Param_Ordre";
    //   print("getParam_Saisie_Param ${wSql}");
    ListParam_Saisie_Param = await getParam_Saisie_Param_API_Post("select", wSql);

    if (ListParam_Saisie_Param.isNotEmpty) {
      return true;
    }

    return false;
  }

  static bool getParam_Saisie_ParamMem(String paramSaisieParamId) {
//    print(">>>>>>>>>>>>>>>>>>>> getParam_Saisie_ParamMem ${Param_Saisie_Param_Id} ");

    ListParam_Saisie_Param.clear();
    for (var element in ListParam_Saisie_ParamAll) {
      if (element.Param_Saisie_Param_Id.compareTo(paramSaisieParamId) == 0) {
        ListParam_Saisie_Param.add(element);
      }
    }

    //  print("<<<<<<<<<<<<<<<<<<<<<<<<<< getParam_Saisie_ParamMem ${Param_Saisie_Param_Id} ${ListParam_Saisie_Param.length} ");

    return true;
  }

  static Param_Saisie_Param getParam_Saisie_ParamMem_Lib(String paramSaisieParamId, String paramSaisieParamLabel) {
    Param_Saisie_Param paramSaisieParam = Param_Saisie_Param.Param_Saisie_ParamInit();
    for (var element in ListParam_Saisie_ParamAll) {
      if (element.Param_Saisie_Param_Id.compareTo(paramSaisieParamId) == 0 && element.Param_Saisie_Param_Label.compareTo(paramSaisieParamLabel) == 0) {
        paramSaisieParam = element;
      }
    }
    return paramSaisieParam;
  }

  static Param_Saisie_Param getParam_Saisie_ParamMem_Lib0(String paramSaisieParamId) {
    Param_Saisie_Param paramSaisieParam = Param_Saisie_Param.Param_Saisie_ParamInit();

    Srv_DbTools.ListParam_Saisie_ParamAll.sort(Srv_DbTools.Param_Saisie_ParamSortComparison);

    for (int i = 0; i < ListParam_Saisie_ParamAll.length; i++) {
      Param_Saisie_Param element = ListParam_Saisie_ParamAll[i];
      if (element.Param_Saisie_Param_Id.compareTo(paramSaisieParamId) == 0 && element.Param_Saisie_Param_Label.compareTo("---") != 0) {
        paramSaisieParam = element;
        break;
      }
    }
    return paramSaisieParam;
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

  static Future<bool> setParam_Saisie_Param(Param_Saisie_Param paramSaisieParam) async {
    String wSlq = "UPDATE Param_Saisie_Param SET Param_Saisie_Param_Id = \"${paramSaisieParam.Param_Saisie_Param_Id}\", Param_Saisie_Param_Ordre = ${paramSaisieParam.Param_Saisie_Param_Ordre}, \"Param_Saisie_Param_Label = ${paramSaisieParam.Param_Saisie_Param_Label}\", \"Param_Saisie_Param_Aide = ${paramSaisieParam.Param_Saisie_Param_Aide}\" WHERE Param_Saisie_ParamId = ${paramSaisieParam.Param_Saisie_ParamId}";
    print("setParam_Saisie_Param $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParam_Saisie_Param ret $ret");
    return ret;
  }

  static Future<bool> addParam_Saisie_Param(Param_Saisie_Param wparamSaisieParam) async {
    String wValue = "NULL,'${wparamSaisieParam.Param_Saisie_Param_Id}',${wparamSaisieParam.Param_Saisie_Param_Ordre}, '${wparamSaisieParam.Param_Saisie_Param_Label}','${wparamSaisieParam.Param_Saisie_Param_Aide}'";
    String wSlq = "INSERT INTO Param_Saisie_Param (Param_Saisie_ParamId,Param_Saisie_Param_Id,Param_Saisie_Param_Ordre,Param_Saisie_Param_Label, Param_Saisie_Param_Aide) VALUES ($wValue)";
    print("addParam_Saisie_Param $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Saisie_Param ret $ret");
    return ret;
  }

  static Future<bool> delParam_Saisie_Param(Param_Saisie_Param paramSaisieParam) async {
    String aSQL = "DELETE FROM Param_Saisie_Param WHERE Param_Saisie_ParamId = ${paramSaisieParam.Param_Saisie_ParamId} ";
    print("delParam_Saisie_Param $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Saisie_Param ret $ret");
    return ret;
  }

  static Future<List<Param_Saisie_Param>> getParam_Saisie_Param_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "$gLoginID"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Param_Saisie_Param> paramSaisieParamlist = await items.map<Param_Saisie_Param>((json) {
          return Param_Saisie_Param.fromJson(json);
        }).toList();
        return paramSaisieParamlist;
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
              print("add_API_Post wRep $wRep");
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
  static DCL_Ent gDCL_Ent = DCL_Ent.DCL_EntInit();

  static String gSelDCL_Ent = "";
  static String gSelDCL_EntBase = "Tous";

  static DateTime SelDCL_DateDeb = DateTime(DateTime.now().year-100);
  static DateTime SelDCL_DateFin = DateTime(DateTime.now().year, 12, 31);
  static DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  static void selDateTools(int aSel) {
    DateTime date = DateTime.now();

    switch (aSel) {
      case 0: // Aujourd'hui
        SelDCL_DateDeb = date;
        SelDCL_DateFin = SelDCL_DateDeb;
        break;
      case 1: // Aujourd'hui
        SelDCL_DateDeb = date.add(const Duration(days: -1));
        SelDCL_DateFin = SelDCL_DateDeb;
        break;
      case 2: // Avant hier
        SelDCL_DateDeb = date.add(const Duration(days: -2));
        SelDCL_DateFin = SelDCL_DateDeb;
        break;
      case 3: // Semaine courante
        SelDCL_DateDeb = getDate(date.subtract(Duration(days: date.weekday - 1)));
        SelDCL_DateFin = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
        break;
      case 4: // Semaine précédante
        date = date.add(const Duration(days: -7));
        SelDCL_DateDeb = getDate(date.subtract(Duration(days: date.weekday - 1)));
        SelDCL_DateFin = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
        break;
      case 5: // Semaine précédant précédante
        date = date.add(const Duration(days: -14));
        SelDCL_DateDeb = getDate(date.subtract(Duration(days: date.weekday - 1)));
        SelDCL_DateFin = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
        break;
      case 6: // Mois courant
        SelDCL_DateDeb = DateTime(date.year, date.month, 1);
        SelDCL_DateFin = DateTime(date.year, date.month + 1, 0);
        break;
      case 7: // Mois précédent
        SelDCL_DateDeb = DateTime(date.year, date.month - 1, 1);
        SelDCL_DateFin = DateTime(date.year, date.month, 0);
        break;
      case 8: // Mois précédent le précédent
        SelDCL_DateDeb = DateTime(date.year, date.month - 2, 1);
        SelDCL_DateFin = DateTime(date.year, date.month - 1, 0);
        break;
      case 9: // Année précédente
        SelDCL_DateDeb = DateTime(date.year, 1, 1);
        SelDCL_DateFin = DateTime(date.year, 12, 31); {}
        break;
      case 10: // Année précédent la précédente
        SelDCL_DateDeb = DateTime(date.year - 1, 1, 1);
        SelDCL_DateFin = DateTime(date.year - 1, 12, 31);
        break;
      default:
        SelDCL_DateDeb = DateTime.now();
        SelDCL_DateFin = DateTime.now();
        break;
    }

    print(" Sel $aSel SelDCL_DateDeb ${DateFormat('dd/MM/yyyy').format(SelDCL_DateDeb)} ${DateFormat('dd/MM/yyyy').format(SelDCL_DateFin)}");
  }

  static int affSortComparisonData_DCL(DCL_Ent a, DCL_Ent b) {
    final wdclEntdatea = a.DCL_Ent_Date;
    final wdclEntdateb = b.DCL_Ent_Date;
    int wdclEntida = a.DCL_EntID!;
    int wdclEntidb = b.DCL_EntID!;

    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDateA = inputFormat.parse(wdclEntdatea!);
    var inputDateB = inputFormat.parse(wdclEntdateb!);
    if (inputDateA.isBefore(inputDateB)) {
      return 1;
    } else if (inputDateA.isAfter(inputDateB)) {
      return -1;
    } else {
      if (wdclEntida < wdclEntidb) {
        return -1;
      } else if (wdclEntida > wdclEntidb) {
        return 1;
      }
      return 0;
    }
  }

  static int idSortComparison(DCL_Ent a, DCL_Ent b) {
    final dclEnta = a.DCL_EntID;
    final dclEntb = b.DCL_EntID;
    if (dclEnta! < dclEntb!) {
      return -1;
    } else if (dclEnta > dclEntb) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future<bool> getDCL_EntAll() async {
    ListDCL_Ent = await getDCL_Ent_API_Post("select", "select *, Client_Nom as DCL_Ent_ClientNom from DCL_Ent, Clients WHERE DCL_Ent_InterventionId != 0  AND ClientId  = `DCL_Ent_ClientId` ORDER BY DCL_EntID;");
    print("getDCL_EntAll ${ListDCL_Ent.length}");
    if (ListDCL_Ent.isNotEmpty) {
      print("getDCL_EntAll return TRUE ${ListDCL_Ent[0].toJson()}");
      return true;
    }
    return false;
  }

  static Future getDCL_EntID(int ID) async {
    for (var element in ListDCL_Ent) {
      if (element.DCL_EntID == ID) {
        gDCL_Ent = element;
        continue;
      }
    }
  }

  static Future<List<DCL_Ent>> getDCL_Ent_DCL_Ent_InterventionId(int dclEntInterventionid) async {
    ListDCL_Ent = await getDCL_Ent_API_Post("select", "select * from DCL_Ent WHERE DCL_Ent_InterventionId = $dclEntInterventionid ORDER BY DCL_EntID");
    return ListDCL_Ent;
  }

  static Future<bool> setDCL_Ent(DCL_Ent dclEnt) async {
    String wSlq = "UPDATE DCL_Ent SET "
            "DCL_Ent_Type = '${dclEnt.DCL_Ent_Type}', " "DCL_Ent_Num = '${dclEnt.DCL_Ent_Num}', " "DCL_Ent_Version = '${dclEnt.DCL_Ent_Version}', " "DCL_Ent_ClientId = '${dclEnt.DCL_Ent_ClientId}', " "DCL_Ent_GroupeId = '${dclEnt.DCL_Ent_GroupeId}', " +
        "DCL_Ent_SiteId = '${dclEnt.DCL_Ent_SiteId}', " +
        "DCL_Ent_ZoneId = '${dclEnt.DCL_Ent_ZoneId}', " +
        "DCL_Ent_InterventionId = '${dclEnt.DCL_Ent_InterventionId}', " +
        "DCL_Ent_Date = '${dclEnt.DCL_Ent_Date}', " +
        "DCL_Ent_Statut = '${dclEnt.DCL_Ent_Statut}', " +
        "DCL_Ent_Etat = '${dclEnt.DCL_Ent_Etat}', " +
        "DCL_Ent_Etat_Motif = '${dclEnt.DCL_Ent_EtatMotif}', " +
        "DCL_Ent_Etat_Note = '${dclEnt.DCL_Ent_EtatNote}', " +
        "DCL_Ent_Etat_Action = '${dclEnt.DCL_Ent_EtatAction}', " +
        "DCL_Ent_Collaborateur = '${dclEnt.DCL_Ent_Collaborateur}', " +
        "DCL_Ent_Affaire = '${dclEnt.DCL_Ent_Affaire}', " +
        "DCL_Ent_Affaire_Note = '${dclEnt.DCL_Ent_AffaireNote}', " +
        "DCL_Ent_Validite = '${dclEnt.DCL_Ent_Validite}', " +
        "DCL_Ent_LivrPrev = '${dclEnt.DCL_Ent_LivrPrev}', " +
        "DCL_Ent_ModeRegl = '${dclEnt.DCL_Ent_ModeRegl}', " +
        "DCL_Ent_MoyRegl = '${dclEnt.DCL_Ent_MoyRegl}', " +
        "DCL_Ent_Valo = '${dclEnt.DCL_Ent_Valo}', " +
        "DCL_Ent_PrefAff = '${dclEnt.DCL_Ent_PrefAff}', " +
        "DCL_Ent_RelAuto = '${dclEnt.DCL_Ent_RelAuto}', " +
        "DCL_Ent_RelAnniv = '${dclEnt.DCL_Ent_RelAnniv}', " +
        "DCL_Ent_CopRel = '${dclEnt.DCL_Ent_CopRel}', " +
        "DCL_Ent_RelanceAuto = '${dclEnt.DCL_Ent_RelanceAuto}', " +
        "DCL_Ent_RelanceAnniv = '${dclEnt.DCL_Ent_RelanceAnniv}', " +
        "DCL_Ent_Relance_Mode = '${dclEnt.DCL_Ent_RelanceMode}', " +
        "DCL_Ent_Relance_Contact = '${dclEnt.DCL_Ent_RelanceContact}', " +
        "DCL_Ent_Relance_Mail = '${dclEnt.DCL_Ent_RelanceMail}', " +
        "DCL_Ent_Relance_Tel = '${dclEnt.DCL_Ent_RelanceTel}', " +
        "DCL_Ent_Proba = '${dclEnt.DCL_Ent_Proba}', " +
        "DCL_Ent_Proba_Note = '${dclEnt.DCL_Ent_Proba_Note}', " +
        "DCL_Ent_Concurent = '${dclEnt.DCL_Ent_Concurent}', " +
        "DCL_Ent_Note = '${dclEnt.DCL_Ent_Note}', " +
        "DCL_Ent_Regl = '${dclEnt.DCL_Ent_Regl}', " +
        "DCL_Ent_Partage = '${dclEnt.DCL_Ent_Partage}', " +
        "DCL_Ent_Contributeurs = '${dclEnt.DCL_Ent_Contributeurs}', " +
        "DCL_Ent_Dem_Tech = '${dclEnt.DCL_Ent_DemTech}', " +

        "DCL_Signataire_Tech = '${dclEnt.DCL_Signataire_Tech}', " +
        "DCL_Signature_Tech  = '${dclEnt.DCL_Signature_Tech }', " +
        "DCL_Signataire_Date = '${dclEnt.DCL_Signataire_Date}', " +


        "DCL_Ent_Dem_SsT =  '${dclEnt.DCL_Ent_DemSsT}' "
            "WHERE DCL_EntID = ${dclEnt.DCL_EntID}";

    print(" setDCL_Ent wSlq $wSlq");

    bool ret = await add_API_Post("upddel", wSlq);
    print(" setDCL_Ent ret $ret");
    return ret;
  }

  static Future<bool> delDCL_Ent(int dclEntid) async {
    String aSQL = "DELETE FROM DCL_Ent WHERE DCL_EntID = $dclEntid ";
    print("delDCL_Ent $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delDCL_Ent ret $ret");
    return ret;
  }

  static String InsertUpdateDCL_Ent_GetSql(DCL_Ent adclEnt) {
    String wSql = "INSERT INTO DCL_Ent("
        "DCL_Ent_Type, "
        "DCL_Ent_Num, "
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
        "DCL_Ent_PrefAff, "
        "DCL_Ent_RelAuto, "
        "DCL_Ent_RelAnniv, "
        "DCL_Ent_CopRel, "
        "DCL_Ent_Valo, "
        "DCL_Ent_RelanceAuto, "
        "DCL_Ent_RelanceAnniv, "
        "DCL_Ent_Relance_Mode, "
        "DCL_Ent_Relance_Contact, "
        "DCL_Ent_Relance_Mail, "
        "DCL_Ent_Relance_Tel, "
        "DCL_Ent_Proba, "
        "DCL_Ent_Proba_Note, "
        "DCL_Ent_Concurent, "
        "DCL_Ent_Note, "
        "DCL_Ent_Regl, "
        "DCL_Ent_Partage, "
        "DCL_Ent_Contributeurs, "
        "DCL_Ent_Dem_Tech, "
        "DCL_Ent_Dem_SsT, "
        ") VALUES ("
        "'${adclEnt.DCL_Ent_Type}',"
        "'${adclEnt.DCL_Ent_Num}',"
        "${adclEnt.DCL_Ent_Version},"
        "${adclEnt.DCL_Ent_ClientId},"
        "${adclEnt.DCL_Ent_GroupeId},"
        "${adclEnt.DCL_Ent_SiteId},"
        "${adclEnt.DCL_Ent_ZoneId},"
        "${adclEnt.DCL_Ent_InterventionId},"
        "'${adclEnt.DCL_Ent_Date}',"
        "'${adclEnt.DCL_Ent_Statut}',"
        "'${adclEnt.DCL_Ent_Etat}',"
        "'${adclEnt.DCL_Ent_EtatMotif}',"
        "'${adclEnt.DCL_Ent_EtatNote}',"
        "'${adclEnt.DCL_Ent_EtatAction}',"
        "'${adclEnt.DCL_Ent_Collaborateur}',"
        "'${adclEnt.DCL_Ent_Affaire}',"
        "'${adclEnt.DCL_Ent_AffaireNote}',"
        "'${adclEnt.DCL_Ent_Validite}',"
        "'${adclEnt.DCL_Ent_LivrPrev}',"
        "'${adclEnt.DCL_Ent_ModeRegl}',"
        "'${adclEnt.DCL_Ent_MoyRegl}',"
        "'${adclEnt.DCL_Ent_PrefAff}',"
        "'${adclEnt.DCL_Ent_RelAuto}',"
        "'${adclEnt.DCL_Ent_RelAnniv}',"
        "'${adclEnt.DCL_Ent_CopRel}',"
        "${adclEnt.DCL_Ent_Valo},"
        "${adclEnt.DCL_Ent_RelanceAuto},"
        "${adclEnt.DCL_Ent_RelanceAnniv},"
        "'${adclEnt.DCL_Ent_RelanceMode}',"
        "'${adclEnt.DCL_Ent_RelanceContact}',"
        "'${adclEnt.DCL_Ent_RelanceMail}',"
        "'${adclEnt.DCL_Ent_RelanceTel}',"
        "${adclEnt.DCL_Ent_Proba},"
        "'${adclEnt.DCL_Ent_Proba_Note}',"
        "'${adclEnt.DCL_Ent_Concurent}',"
        "'${adclEnt.DCL_Ent_Note}',"
        "'${adclEnt.DCL_Ent_Regl}',"
        "'${adclEnt.DCL_Ent_Partage}',"
        "'${adclEnt.DCL_Ent_Contributeurs}',"
        "'${adclEnt.DCL_Ent_DemTech}',"
        "'${adclEnt.DCL_Ent_DemSsT}',"
        ")";
    return wSql;
  }

  static Future<bool> InsertUpdateDCL_Ent_Sql(String wSql) async {
    print("InsertUpdateDCL_Ent_Sql $wSql");
    bool ret = await add_API_Post("multi", wSql);
    print("InsertUpdateDCL_Ent_Sql ret $ret");
    return ret;
  }

  static Future<bool> InsertUpdateDCL_Ent(DCL_Ent adclEnt) async {
    String wSql = "INSERT INTO DCL_Ent("
        "DCL_Ent_Type, "
        "DCL_Ent_Num, "
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
        "DCL_Ent_PrefAff, "
        "DCL_Ent_RelAuto, "
        "DCL_Ent_RelAnniv, "
        "DCL_Ent_CopRel, "
        "DCL_Ent_Valo, "
        "DCL_Ent_RelanceAuto, "
        "DCL_Ent_RelanceAnniv, "
        "DCL_Ent_Relance_Mode, "
        "DCL_Ent_Relance_Contact, "
        "DCL_Ent_Relance_Mail, "
        "DCL_Ent_Relance_Tel, "
        "DCL_Ent_Proba, "
        "DCL_Ent_Proba_Note, "
        "DCL_Ent_Concurent, "
        "DCL_Ent_Note, "
        "DCL_Ent_Regl, "
        "DCL_Ent_Partage, "
        "DCL_Ent_Contributeurs, "
        "DCL_Ent_Dem_Tech, "
        "DCL_Ent_Dem_SsT "
        ") VALUES ("
        "'${adclEnt.DCL_Ent_Type}',"
        "'${adclEnt.DCL_Ent_Num}',"
        "${adclEnt.DCL_Ent_Version},"
        "${adclEnt.DCL_Ent_ClientId},"
        "${adclEnt.DCL_Ent_GroupeId},"
        "${adclEnt.DCL_Ent_SiteId},"
        "${adclEnt.DCL_Ent_ZoneId},"
        "${adclEnt.DCL_Ent_InterventionId},"
        "'${adclEnt.DCL_Ent_Date}',"
        "'${adclEnt.DCL_Ent_Statut}',"
        "'${adclEnt.DCL_Ent_Etat}',"
        "'${adclEnt.DCL_Ent_EtatMotif}',"
        "'${adclEnt.DCL_Ent_EtatNote}',"
        "'${adclEnt.DCL_Ent_EtatAction}',"
        "'${adclEnt.DCL_Ent_Collaborateur}',"
        "'${adclEnt.DCL_Ent_Affaire}',"
        "'${adclEnt.DCL_Ent_AffaireNote}',"
        "'${adclEnt.DCL_Ent_Validite}',"
        "'${adclEnt.DCL_Ent_LivrPrev}',"
        "'${adclEnt.DCL_Ent_ModeRegl}',"
        "'${adclEnt.DCL_Ent_MoyRegl}',"
        "'${adclEnt.DCL_Ent_PrefAff}',"
        "'${adclEnt.DCL_Ent_RelAuto}',"
        "'${adclEnt.DCL_Ent_RelAnniv}',"
        "'${adclEnt.DCL_Ent_CopRel}',"
        "${adclEnt.DCL_Ent_Valo},"
        "${adclEnt.DCL_Ent_RelanceAuto},"
        "${adclEnt.DCL_Ent_RelanceAnniv},"
        "'${adclEnt.DCL_Ent_RelanceMode}',"
        "'${adclEnt.DCL_Ent_RelanceContact}',"
        "'${adclEnt.DCL_Ent_RelanceMail}',"
        "'${adclEnt.DCL_Ent_RelanceTel}',"
        "${adclEnt.DCL_Ent_Proba},"
        "'${adclEnt.DCL_Ent_Proba_Note}',"
        "'${adclEnt.DCL_Ent_Concurent}',"
        "'${adclEnt.DCL_Ent_Note}',"
        "'${adclEnt.DCL_Ent_Regl}',"
        "'${adclEnt.DCL_Ent_Partage}',"
        "'${adclEnt.DCL_Ent_Contributeurs}',"
        "'${adclEnt.DCL_Ent_DemTech}',"
        "'${adclEnt.DCL_Ent_DemSsT}'"
        ")";
    print("setDCL_Ent $wSql");
    bool ret = await add_API_Post("upddel", wSql);
    print("setDCL_Ent ret $ret");
    return ret;
  }

  /**
     BEGIN TRANSACTION;


      DECLARE @new_id INT;

      UPDATE param_table
      SET current_id = current_id + 1
      OUTPUT INSERTED.current_id - 1 INTO @new_id;

      -- 2. Insérer dans la table cible avec le nouvel ID
      INSERT INTO target_table (id, data_column)
      VALUES (@new_id, 'Valeur à insérer');

      COMMIT;

   */

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
        List<DCL_Ent> dclEntlist = await items.map<DCL_Ent>((json) {
          return DCL_Ent.fromJson(json);
        }).toList();
        return dclEntlist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   DCL_Ent_Img   ***************
  //******************************************

  static List<DCL_Ent_Img> ListDCL_Ent_Img = [];
  static List<DCL_Ent_Img> ListDCL_Ent_Imgsearchresult = [];
  static DCL_Ent_Img gDCL_Ent_Img = DCL_Ent_Img(dCLEntImgid: 0, dCLEntImgEntID : 0, dCLEntImgData :"");


  static Future<bool> getDCL_Ent_ImgAll() async {
    ListDCL_Ent_Img = await getDCL_Ent_Img_API_Post("select", "select * from DCL_Ent_Img");
    print("getDCL_Ent_ImgAll ${ListDCL_Ent_Img.length}");
    if (ListDCL_Ent_Img.isNotEmpty) {
      print("getDCL_Ent_ImgAll return TRUE");
      return true;
    }
    return false;
  }
  static Future<bool> getDCL_Ent_ImgID(int ID, String wType) async {
    ListDCL_Ent_Img = await getDCL_Ent_Img_API_Post("select", "select * from DCL_Ent_Img WHERE DCL_Ent_Img_EntID = $ID AND DCL_Ent_Img_Type = '$wType' ORDER BY DCL_Ent_Img_No");
    print("getDCL_Ent_ImgID ${ListDCL_Ent_Img.length}");
    if (ListDCL_Ent_Img.isNotEmpty) {
      print("getDCL_Ent_ImgID return TRUE");
      return true;
    }
    return false;
  }



  static Future<bool> setDCL_Ent_Img(DCL_Ent_Img adclEntImg) async {
    String wSlq = "UPDATE DCL_Ent_Img SET "

        "DCL_Ent_Img_EntID      =   ${adclEntImg.dCLEntImgEntID}, " "DCL_Ent_Img_Type         = \"${adclEntImg.DCL_Ent_Img_Type}\", "
            "DCL_Ent_Img_Name         = \"${adclEntImg.DCL_Ent_Img_Name}\", "
            "DCL_Ent_Img_No      =   ${adclEntImg.DCL_Ent_Img_No}, " "DCL_Ent_Img_Data         = \"${adclEntImg.dCLEntImgData}\" "
            "WHERE DCL_Ent_Imgid            =   ${adclEntImg.dCLEntImgid}";

    print("setDCL_Ent_Img $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setDCL_Ent_Img ret $ret");
    return ret;
  }

  static Future<bool> delDCL_Ent_Img_Srv(int dCLEntImgid) async {
    String aSQL = "DELETE FROM DCL_Ent_Img WHERE DCL_Ent_Imgid = $dCLEntImgid ";
    print("delDCL_Ent_Img_Srv $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delDCL_Ent_Img_Srv ret $ret");
    return ret;
  }



  static String InsertUpdateDCL_Ent_Img_Srv_GetSql(DCL_Ent_Img adclEntImg) {
    String wSql = "INSERT INTO DCL_Ent_Img("
        "DCL_Ent_Imgid, "
        "DCL_Ent_Img_EntID, "
        "DCL_Ent_Img_Type, "
        "DCL_Ent_Img_Name, "
        "DCL_Ent_Img_No, "
        "DCL_Ent_Img_Data "
        ") VALUES ("
        "NULL ,  "
        "${adclEntImg.dCLEntImgEntID},"
        "'${adclEntImg.DCL_Ent_Img_Type!.replaceAll("'", "‘")}',"
        "'${adclEntImg.DCL_Ent_Img_Name!.replaceAll("'", "‘")}',"
        "${adclEntImg.DCL_Ent_Img_No},"
        "'${adclEntImg.dCLEntImgData!.replaceAll("'", "‘")}'"
        ")";
    return wSql;
  }

  static Future<bool> InsertUpdateDCL_Ent_Img_Srv_Sql(String wSql) async {
    print("InsertUpdateDCL_Ent_Img_Srv_Sql $wSql");
    bool ret = await add_API_Post("multi", wSql);
    print("InsertUpdateDCL_Ent_Img_Srv_Sql ret $ret");
    return ret;
  }


  static Future<bool> InsertUpdateDCL_Ent_Img_Srv(DCL_Ent_Img adclEntImg) async {
    String wSql = "INSERT INTO DCL_Ent_Img("
        "DCL_Ent_Imgid, "
        "DCL_Ent_Img_EntID, "
        "DCL_Ent_Img_Type, "
        "DCL_Ent_Img_Name, "
        "DCL_Ent_Img_No, "
        "DCL_Ent_Img_Data "
        ") VALUES ("
        "NULL ,  "
        "${adclEntImg.dCLEntImgEntID},"
        "'${adclEntImg.DCL_Ent_Img_Type!.replaceAll("'", "‘")}',"
        "'${adclEntImg.DCL_Ent_Img_Name!.replaceAll("'", "‘")}',"
        "${adclEntImg.DCL_Ent_Img_No},"
        "'${adclEntImg.dCLEntImgData!.replaceAll("'", "‘")}'"
        ")";
    print("setDCL_Ent_Img $wSql");
    bool ret = await add_API_Post("upddel", wSql);
      print("setDCL_Ent_Img ret $ret");
    return ret;
  }

  static Future<bool> addDCL_Ent_Img(int dCLEntImgEntID) async {
    String wValue = "NULL, $dCLEntImgEntID";
    String wSlq = "INSERT INTO DCL_Ent_Img (DCL_Ent_Imgid, DCL_Ent_Img_EntID) VALUES ($wValue)";
    print("addDCL_Ent_Img $wSlq");
    bool ret = await add_API_Post("insert", wSlq);
    print("addDCL_Ent_Img ret $ret");
    return ret;
  }

  static Future<bool> delDCL_Ent_Img(int dclEntImgid) async {
    String aSQL = "DELETE FROM DCL_Ent_Img WHERE DCL_Ent_Imgid = $dclEntImgid ";
    print("delDCL_Ent_Img $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delDCL_Ent_Img ret $ret");
    return ret;
  }

  static Future<List<DCL_Ent_Img>> getDCL_Ent_Img_API_Post(String aType, String aSQL) async {
    print("getDCL_Ent_Img_API_Post $aSQL");

    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${Srv_DbTools.gLoginID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<DCL_Ent_Img> dclEntImglist = await items.map<DCL_Ent_Img>((json) {
          return DCL_Ent_Img.fromJson(json);
        }).toList();
        return dclEntImglist;
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
  static List<DCL_Det> ListDCL_DetsearchresultSave = [];
  static DCL_Det gDCL_Det = DCL_Det();

  static String gSelDCL_Det = "";
  static String gSelDCL_DetBase = "Tous les types de document";

  static Future<bool> getDCL_DetAll() async {
    ListDCL_Det = await getDCL_Det_API_Post("select", "select * from DCL_Det ORDER BY DCL_DetID");
    print("getDCL_DetAll ${ListDCL_Det.length}");
    if (ListDCL_Det.isNotEmpty) {
      print("getDCL_DetAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getDCL_All_DetID() async {
    String wTmp = "select * from DCL_Det WHERE DCL_Det_EntID = ${Srv_DbTools.gDCL_Ent.DCL_EntID} ORDER BY DCL_Det_Ordre";

    print("getDCL_DetAll wTmp $wTmp");

    ListDCL_Det = await getDCL_Det_API_Post("select", wTmp);
    print("getDCL_DetAll ${ListDCL_Det.length}");
    if (ListDCL_Det.isNotEmpty) {
      print("getDCL_DetAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getDCL_DetID(int ID) async {
    for (var element in ListDCL_Det) {
      if (element.DCL_DetID == ID) {
        gDCL_Det = element;
        continue;
      }
    }
  }

  static int getLastOrder() {
    int maxOrder = 0;
    for (int i = 0; i < Srv_DbTools.ListDCL_Det.length; i++) {
      if (Srv_DbTools.ListDCL_Det[i].DCL_Det_Ordre! > maxOrder) maxOrder = Srv_DbTools.ListDCL_Det[i].DCL_Det_Ordre!;
    }
    return maxOrder;
  }

  static Future<bool> setDCL_Det(DCL_Det dclDet) async {
    String wSlq = "UPDATE DCL_Det SET "
            "DCL_Det_EntID = ${dclDet.DCL_Det_EntID}, " "DCL_Det_ParcsArtId = ${dclDet.DCL_Det_ParcsArtId}, " "DCL_Det_Ordre = ${dclDet.DCL_Det_Ordre}, " "DCL_Det_Type = '${dclDet.DCL_Det_Type}', " "DCL_Det_NoArt = '${dclDet.DCL_Det_NoArt}', " +
        "DCL_Det_Lib = '${dclDet.DCL_Det_Lib!.replaceAll("'", "''")}', " +
        "DCL_Det_Qte = ${dclDet.DCL_Det_Qte}, " +
        "DCL_Det_PU = ${dclDet.DCL_Det_PU}, " +
        "DCL_Det_Rem_P = ${dclDet.DCL_Det_RemP}, " +
        "DCL_Det_Rem_Mt = ${dclDet.DCL_Det_RemMt}, " +
        "DCL_Det_TVA = ${dclDet.DCL_Det_TVA}, " +
        "DCL_Det_Livr = ${dclDet.DCL_Det_Livr}, " +
        "DCL_Det_DateLivr = '${dclDet.DCL_Det_DateLivr}', " +
        "DCL_Det_Rel = ${dclDet.DCL_Det_Rel}, " +
        "DCL_Det_DateRel = '${dclDet.DCL_Det_DateRel}', " +
        "DCL_Det_Statut = '${dclDet.DCL_Det_Statut}', " +
        "DCL_Det_Note = '${dclDet.DCL_Det_Note}', " +
        "DCL_Det_Garantie = '${dclDet.DCL_Det_Garantie}' "
            "WHERE DCL_DetID = ${dclDet.DCL_DetID}";
    print(" setDCL_Det $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setDCL_Det ret $ret");
    return ret;
  }

  static Future<bool> setDCL_Det_Lib(DCL_Det dclDet) async {
    String wSlq = 'UPDATE DCL_Det SET DCL_Det_Lib = "${dclDet.DCL_Det_Lib}" WHERE DCL_DetID = ${dclDet.DCL_DetID}';
    print(" setDCL_Det_Lib $wSlq");
    bool ret = await add_API_Post("upddel", wSlq);
    print("setDCL_Det ret $ret");
    return ret;
  }

  static Future<bool> setDCL_Det_Ordre(DCL_Det dclDet) async {
    String wSlq = 'UPDATE DCL_Det SET DCL_Det_Ordre = ${dclDet.DCL_Det_Ordre} WHERE DCL_DetID = ${dclDet.DCL_DetID}';
//    print(" setDCL_Det_Lib ${wSlq}");
    bool ret = await add_API_Post("upddel", wSlq);
//    print("setDCL_Det ret " + ret.toString());
    return ret;
  }

  static Future<bool> delDCL_Det(int dclDetid) async {
    String aSQL = "DELETE FROM DCL_Det WHERE DCL_DetID = $dclDetid ";
    print("delDCL_Det $aSQL");
    bool ret = await add_API_Post("upddel", aSQL);
    print("delDCL_Det ret $ret");
    return ret;
  }

  static String InsertUpdateDCL_Det_GetSql(DCL_Det adclDet) {
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
        "DCL_Det_TVA, "
        "DCL_Det_Livr, "
        "DCL_Det_DateLivr, "
        "DCL_Det_Rel, "
        "DCL_Det_DateRel, "
        "DCL_Det_Statut, "
        "DCL_Det_Note, "
        "DCL_Det_Garantie "
        ") VALUES ("
        "NULL ,  "
        "${adclDet.DCL_Det_EntID},"
        "${adclDet.DCL_Det_ParcsArtId},"
        "${adclDet.DCL_Det_Ordre},"
        "'${adclDet.DCL_Det_Type}',"
        "'${adclDet.DCL_Det_NoArt}',"
        "'${adclDet.DCL_Det_Lib!.replaceAll("'", "''")}',"
        "${adclDet.DCL_Det_Qte},"
        "${adclDet.DCL_Det_PU},"
        "${adclDet.DCL_Det_RemP},"
        "${adclDet.DCL_Det_RemMt},"
        "${adclDet.DCL_Det_TVA},"
        "${adclDet.DCL_Det_Livr},"
        "'${adclDet.DCL_Det_DateLivr}',"
        "${adclDet.DCL_Det_Rel},"
        "'${adclDet.DCL_Det_DateRel}',"
        "'${adclDet.DCL_Det_Statut}',"
        "'${adclDet.DCL_Det_Note}',"
        "'${adclDet.DCL_Det_Garantie}'"
        ")";
    return wSql;
  }

  static Future<bool> InsertUpdateDCL_Det_Sql(String wSql) async {
    print("InsertUpdateDCL_Det_Sql $wSql");
    bool ret = await add_API_Post("multi", wSql);
    print("InsertUpdateDCL_Det_Sql ret $ret");
    return ret;
  }

  static Future<bool> InsertUpdateDCL_Det(DCL_Det adclDet) async {

    print(" Ajouter B InsertUpdateDCL_Det   ${adclDet.DCL_Det_Qte} ${adclDet.DCL_Det_Statut}");

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
        "DCL_Det_Rem_P, "
        "DCL_Det_Rem_Mt, "
        "DCL_Det_TVA, "
        "DCL_Det_Livr, "
        "DCL_Det_DateLivr, "
        "DCL_Det_Rel, "
        "DCL_Det_DateRel, "
        "DCL_Det_Statut, "
        "DCL_Det_Note, "
        "DCL_Det_Garantie "
        ") VALUES ("
        "NULL ,  "
        "${adclDet.DCL_Det_EntID},"
        "${adclDet.DCL_Det_ParcsArtId},"
        "${adclDet.DCL_Det_Ordre},"
        "'${adclDet.DCL_Det_Type}',"
        "'${adclDet.DCL_Det_NoArt}',"
        "'${adclDet.DCL_Det_Lib!.replaceAll("'", "''")}',"
        "${adclDet.DCL_Det_Qte},"
        "${adclDet.DCL_Det_PU},"
        "${adclDet.DCL_Det_RemP},"
        "${adclDet.DCL_Det_RemMt},"
        "${adclDet.DCL_Det_TVA},"
        "${adclDet.DCL_Det_Livr},"
        "'${adclDet.DCL_Det_DateLivr}',"
        "${adclDet.DCL_Det_Rel},"
        "'${adclDet.DCL_Det_DateRel}',"
        "'${adclDet.DCL_Det_Statut}',"
        "'${adclDet.DCL_Det_Note}',"
        "'${adclDet.DCL_Det_Garantie}'"
        ")";
    print("InsertUpdateDCL_Det $wSql");
    bool ret = await add_API_Post("insert", wSql);
    print("InsertUpdateDCL_Det ret $ret");
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
        List<DCL_Det> dclDetlist = await items.map<DCL_Det>((json) {
          return DCL_Det.fromJson(json);
        }).toList();
        return dclDetlist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<bool> Call_StoreProc(String Ids, String Orders) async {
    String wSql = "call DCL_Det_Order('$Ids', '$Orders');";
    bool ret = await Call_StoreProcSql(wSql);
    return ret;
  }


  static Future<bool> Call_StoreProcSql(wSql) async {
    print(" Call_StoreProcSql " + wSql);
    bool ret = await add_API_Post("upddel", wSql);
    print(" Call_StoreProcSql $ret");
    return ret;
  }


  //****************************************
  //****************************************
  //****************************************

  static void setSrvToken() {
    var uuid = const Uuid();
    var v1 = uuid.v1();

    Random random = Random();

    int Cut = random.nextInt(8) + 1;
    String sCut = "T$Cut";

    String S1 = SrvTokenKey.substring(0, Cut);
    String S2 = SrvTokenKey.substring(Cut);

    int F1 = random.nextInt(7);
    String sR3 = "P${F1.toString().padLeft(2, '0')}";
    int F3 = random.nextInt(7);
    int F2 = 16 - F1 - F3;

    int R5 = F1 + Cut + 3 + F2 + 2;

    String sR5 = "S${R5.toString().padLeft(2, '0')}";

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
