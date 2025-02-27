import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:verifplus/Tools/Api_Adresse.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/siret.dart';


class InseeToken {
  String? accessToken;
  String? scope;
  String? tokenType;
  int? expiresIn;

  InseeToken({this.accessToken, this.scope, this.tokenType, this.expiresIn});

  InseeToken.fromJson(Map<dynamic, dynamic> json) {
    accessToken = json['access_token'];
    scope = json['scope'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['scope'] = scope;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    return data;
  }
}

class Api_Gouv {
  Api_Gouv();

  static String access_token = "";
  static String siret_Nom = "";
  static String siret_Rue = "";
  static String siret_Cp = "";
  static String siret_Ville = "";
  static String siret_SIREN = "";
  static String siret_NAF = "";

  static Future<bool> inseeToken() async {
    access_token = "";


    try {

      Srv_DbTools.setSrvToken();
      var request = http.MultipartRequest('POST', Uri.parse(Srv_DbTools.SrvUrl.toString()));
      request.fields.addAll({'tic12z': Srv_DbTools.SrvToken, 'zasq': 'inseeToken'});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var parsedJson = json.decode(await response.stream.bytesToString());

        print("parsedJson ${parsedJson['data']}");

        Map valueMap = json.decode(parsedJson['data']);

        print("valueMap $valueMap");

        InseeToken wInseeToken = InseeToken.fromJson(valueMap);

        print("wInseeToken ${wInseeToken.toJson()}");

        print("access_token get");
        access_token = wInseeToken.accessToken!;
        print("access_token $access_token");
            } else {
        print(response.reasonPhrase);
      }
      return true;

    } catch (e) {
      print(e);
      return false;
    }







  }



  static Future<bool> siret(String asiret) async {
    siret_Nom = "";
    siret_Rue = "";
    siret_Cp = "";
    siret_Ville = "";
    siret_NAF = "";
    siret_SIREN = "";

    Srv_DbTools.setSrvToken();
    var request = http.MultipartRequest('POST', Uri.parse(Srv_DbTools.SrvUrl.toString()));
    request.fields.addAll({'tic12z': Srv_DbTools.SrvToken, 'zasq': 'siret', 'token': access_token, 'asiret': asiret});

    print("siret          request.fields ${request.fields}");

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      String wTmp = await response.stream.bytesToString();
      var parsedJson = json.decode(wTmp);

      print("parsedJson ${parsedJson['data']}");

      Map valueMap = json.decode(parsedJson['data']);
      print("valueMap $valueMap");

      Siret wSiret = Siret.fromJson(valueMap);

      print("wSiret.etablissement ${wSiret.header!.statut}");

      if (wSiret.header!.statut != 200) {
        siret_Nom = wSiret.header!.message!;
        return false;
      }
//      print("wSiret.etablissement ${wSiret.etablissement}");

//      print("wSiret adresseEtablissement ${wSiret.etablissement!.adresseEtablissement!.toJson()}");

      String wNom = "${wSiret.etablissement!.uniteLegale!.denominationUniteLegale}";
      print("Adresse wNom $wNom");

      String wRue = "${wSiret.etablissement!.adresseEtablissement!.numeroVoieEtablissement} ${wSiret.etablissement!.adresseEtablissement!.typeVoieEtablissement} ${wSiret.etablissement!.adresseEtablissement!.libelleVoieEtablissement}";
      print("Adresse wRue $wRue");

      String wcpVille = "${wSiret.etablissement!.adresseEtablissement!.codePostalEtablissement} ${wSiret.etablissement!.adresseEtablissement!.libelleCommuneEtablissement}";
      print("Adresse wCP_Ville $wcpVille");

      siret_Nom = wNom;
      siret_Rue = wRue;
      siret_Cp = wSiret.etablissement!.adresseEtablissement!.codePostalEtablissement!;
      siret_Ville = wSiret.etablissement!.adresseEtablissement!.libelleCommuneEtablissement!;
      siret_NAF = wSiret.etablissement!.uniteLegale!.activitePrincipaleUniteLegale!;
      siret_SIREN = wSiret.etablissement!.siren!;
    } else {
      print(response.reasonPhrase);
      return false;
    }
    return true;
  }

  static List<Properties> properties = [];
  static Properties gProperties = Properties();
  static Future<bool> ApiAdresse(String aAdresse) async {
    properties.clear();
    aAdresse = aAdresse.replaceAll(" ", "+");
    Srv_DbTools.setSrvToken();
    var request = http.MultipartRequest('POST', Uri.parse(Srv_DbTools.SrvUrl.toString()));
    request.fields.addAll({'tic12z': Srv_DbTools.SrvToken, 'zasq': 'Api_Adresse', 'aAdresse': aAdresse, 'aLimit': '20'});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String Rep = await response.stream.bytesToString();
      print("Rep $Rep");
      if (Rep.contains(':400,')) return false;

      var parsedJson = json.decode(Rep);
//      print("parsedJson ${parsedJson}");
      Map valueMap = json.decode(parsedJson['data']);
      //    print("valueMap $valueMap");
      Api_Adresse wapiAdresse = Api_Adresse.fromJson(valueMap);

      print("wApi_Adresse.features ${wapiAdresse.features!.length}");

      for (var feature in wapiAdresse.features!) {
        properties.add(feature.properties!);
      }
    } else {
      print(response.reasonPhrase);
      return false;
    }
    return true;
  }

  static List<String> tVille = [];
  static List<String> tCp = [];

  static Future<void> ReadServer_CpVilles(String aCp) async {
    tVille.clear();
    tCp.clear();

    String wParam = "http://api-adresse.data.gouv.fr/search/?q=$aCp&type=municipality&limit=30";

    print("wParam $wParam");

    http.Response wRet = await http.get(Uri.parse(wParam));

    var parsedJson = json.decode(wRet.body);

//    print("parsedJson ${parsedJson}");
    final features = parsedJson['features'];
    features.forEach((element) {
      var properties = element['properties'];
      var label = properties['label'];
      var postcode = properties['postcode'];
//      print("postcode $postcode label $label ");

      tVille.add(label);
      tCp.add(postcode);
    });
    return;
  }
}
