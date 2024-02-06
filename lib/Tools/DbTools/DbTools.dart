import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Clients.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Groupes.dart';
import 'package:verifplus/Tools/DbSrv/Srv_InterMissions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Art.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Ent.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User_Desc.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User_Hab.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Zones.dart';
import 'package:verifplus/Tools/DbTools/Db_Inters.dart';
import 'package:verifplus/Tools/DbTools/Db_Maints.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Img.dart';


class SelLig {
  int Id = 0;
  int Ordre = 0;

  SelLig(
    this.Id,
    this.Ordre,
  );

  static int affSortComparison(SelLig a, SelLig b) {
    final OrdreA = a.Ordre;
    final OrdreB = b.Ordre;
    if (OrdreA < OrdreB) {
      return -1;
    } else if (OrdreA > OrdreB) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  String toString() {
    return 'SelLig{Id: $Id, Ordre: $Ordre}';
  }
}

class DbTools {
  DbTools();


  static File gImageEdtFile = File("");

  static List<GrdBtnGrp> lGrdBtnGrp = [];

  static bool gTED = false;

  static bool gOffLine = false;

  static int gCurrentIndex = 0;
  static int gCurrentIndex2 = 0;
  static int gCurrentIndex3 = 0;

  static int gCountRel = 0;
  static int gCountDev = 0;

  static String? gImagePath;

  static bool gIsRememberLogin = true;
  static var gVersion = "v1.0.14 b14";
  static var gUsername = "";
  static var gPassword = "";

  static int gRowIndex = -1;
  static bool gRowisSel = false;
  static List<SelLig> gRowSels = [];

  static List<GrdBtnGrp> lGrdBtnGrp_Inter = [];
  static List<GrdBtnGrp> lGrdBtnGrp_Install = [];

  static String OrgLib = "";
  static String ParamTypeOg = "";

  static int gLastID = 0;

  static PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  static Future<bool> ApiSrv_User_setNotification_Token(String id, String password, String token) async {
    return true;
  }

  static var database;

  static Future initSqlite() async {

    var wgetDatabasesPath = await getDatabasesPath();
//    print("getDatabasesPath() $wgetDatabasesPath");

    String wCREATE_Param_Param = "CREATE TABLE Param_Param (Param_ParamId INTEGER NOT NULL, Param_Param_Type TEXT NOT NULL, Param_Param_ID TEXT NOT NULL, Param_Param_Text TEXT NOT NULL DEFAULT '', Param_Param_Int INTEGER NOT NULL DEFAULT 0, Param_Param_Double REAL NOT NULL DEFAULT 0, Param_Param_Ordre INTEGER NOT NULL DEFAULT 0);";
    String wCREATE_Param_Saisie = "CREATE TABLE Param_Saisie (Param_SaisieId INTEGER NOT NULL, Param_Saisie_Organe TEXT NOT NULL DEFAULT '', Param_Saisie_Type TEXT NOT NULL DEFAULT '', Param_Saisie_ID TEXT NOT NULL DEFAULT '', Param_Saisie_Label TEXT NOT NULL DEFAULT '', Param_Saisie_Aide TEXT NOT NULL DEFAULT '', Param_Saisie_Controle TEXT NOT NULL DEFAULT '', Param_Saisie_Ordre INTEGER NOT NULL DEFAULT 0, Param_Saisie_Affichage TEXT NOT NULL DEFAULT '', Param_Saisie_Ordre_Affichage INTEGER NOT NULL DEFAULT 0, Param_Saisie_Affichage_Titre TEXT NOT NULL DEFAULT '', Param_Saisie_Affichage_L1 INTEGER NOT NULL DEFAULT 0, Param_Saisie_Affichage_L1_Ordre INTEGER NOT NULL DEFAULT 0, Param_Saisie_Affichage_L2 INTEGER NOT NULL DEFAULT 0, Param_Saisie_Affichage_L2_Ordre INTEGER NOT NULL DEFAULT 0, Param_Saisie_Icon TEXT NOT NULL DEFAULT '', Param_Saisie_Triger TEXT NOT NULL DEFAULT '');";
    String wCREATE_Param_Saisie_Param = "CREATE TABLE Param_Saisie_Param (Param_Saisie_ParamId INTEGER NOT NULL, "
        "Param_Saisie_Param_Id TEXT NOT NULL DEFAULT '', Param_Saisie_Param_Ordre INTEGER NOT NULL DEFAULT 0, "
        "Param_Saisie_Param_Label TEXT NOT NULL DEFAULT '', Param_Saisie_Param_Abrev TEXT NOT NULL DEFAULT '', "
        "Param_Saisie_Param_Aide TEXT NOT NULL DEFAULT '', Param_Saisie_Param_Default INTEGER NOT NULL DEFAULT 0, "
        "Param_Saisie_Param_Init INTEGER NOT NULL DEFAULT 0, Param_Saisie_Param_Color TEXT NOT NULL DEFAULT 'Noir');";


    String wCREATE_Users_Desc = "CREATE TABLE User_Desc (User_DescID INTEGER NOT NULL, User_Desc_UserID INTEGER NOT NULL, User_Desc_Param_DescID INTEGER NOT NULL, User_Desc_MaintPrev INTEGER NOT NULL, User_Desc_Install INTEGER NOT NULL, User_Desc_MaintCorrect INTEGER NOT NULL, User_Desc_Ordre INTEGER NOT NULL DEFAULT 0);";
    String wCREATE_Users_Hab = "CREATE TABLE User_Hab (User_HabID INTEGER NOT NULL, User_Hab_UserID INTEGER NOT NULL, User_Hab_Param_HabID INTEGER NOT NULL, User_Hab_MaintPrev INTEGER NOT NULL, User_Hab_Install INTEGER NOT NULL, User_Hab_MaintCorrect INTEGER NOT NULL, User_Hab_Ordre INTEGER NOT NULL DEFAULT 0);";

    String wCREATE_Users = "CREATE TABLE Users ("
    "UserID INTEGER PRIMARY KEY AUTOINCREMENT,"
    "User_Actif INTEGER NOT NULL DEFAULT 0,"
    "User_Token_FBM TEXT NOT NULL DEFAULT '',"
    "User_Matricule TEXT NOT NULL DEFAULT '',"
    "User_Nom TEXT NOT NULL DEFAULT '',"
    "User_Prenom TEXT NOT NULL DEFAULT '',"
    "User_Adresse1 TEXT NOT NULL DEFAULT '',"
    "User_Adresse2 TEXT NOT NULL DEFAULT '',"
    "User_Cp TEXT NOT NULL DEFAULT '',"
    "User_Ville TEXT NOT NULL DEFAULT '',"
    "User_Tel TEXT NOT NULL DEFAULT '',"
    "User_Mail TEXT NOT NULL DEFAULT '',"
    "User_PassWord TEXT NOT NULL DEFAULT '',"
    "User_Service TEXT NOT NULL DEFAULT '',"
    "User_Fonction TEXT NOT NULL DEFAULT '',"
    "User_Famille TEXT NOT NULL DEFAULT '',"
    "User_Depot TEXT NOT NULL DEFAULT '',"
    "User_NivHabID INTEGER NOT NULL DEFAULT 0,"
    "User_Niv_Isole INTEGER NOT NULL DEFAULT 0,"
    "User_TypeUserID INTEGER NOT NULL);";


    String wCREATE_Clients = "CREATE TABLE Clients (ClientId INTEGER NOT NULL, Client_CodeGC TEXT NOT NULL DEFAULT '', Client_CL_Pr INTEGER NOT NULL, Client_Famille TEXT NOT NULL, Client_Rglt TEXT NOT NULL, Client_Depot TEXT NOT NULL DEFAULT '', Client_PersPhys INTEGER NOT NULL, Client_OK_DataPerso INTEGER NOT NULL, Client_Civilite TEXT NOT NULL DEFAULT '', Client_Nom TEXT NOT NULL DEFAULT '', Client_Siret TEXT NOT NULL DEFAULT '', Client_NAF TEXT NOT NULL DEFAULT '', Client_TVA TEXT NOT NULL DEFAULT '', Client_Commercial TEXT NOT NULL DEFAULT '', Client_Createur TEXT NOT NULL DEFAULT '', Client_Contrat INTEGER NOT NULL, Client_TypeContrat TEXT NOT NULL DEFAULT '', Client_Ct_Debut TEXT NOT NULL, Client_Ct_Fin TEXT NOT NULL, Client_Organes TEXT NOT NULL DEFAULT '', Livr TEXT NOT NULL);";
    String wCREATE_Groupes = "CREATE TABLE `Groupes` (`GroupeId` int(11) NOT NULL,`Groupe_ClientId` int(11) NOT NULL,`Groupe_Code` varchar(24) NOT NULL DEFAULT '',`Groupe_Depot` varchar(128) NOT NULL DEFAULT '',`Groupe_Nom` varchar(64) NOT NULL DEFAULT '',`Groupe_Adr1` varchar(40) NOT NULL DEFAULT '',`Groupe_Adr2` varchar(40) NOT NULL DEFAULT '',`Groupe_Adr3` varchar(40) NOT NULL DEFAULT '',`Groupe_Adr4` varchar(40) NOT NULL,`Groupe_CP` varchar(10) NOT NULL DEFAULT '',`Groupe_Ville` varchar(40) NOT NULL DEFAULT '',`Groupe_Pays` varchar(40) NOT NULL DEFAULT '',`Groupe_Acces` varchar(128) NOT NULL,`Groupe_Rem` varchar(1024) NOT NULL DEFAULT '',`Livr` varchar(8) NOT NULL)";
    String wCREATE_Sites = "CREATE TABLE `Sites` (`SiteId` int(11) NOT NULL,`Site_GroupeId` int(11) NOT NULL,`Site_Code` varchar(24) NOT NULL DEFAULT '',`Site_Depot` varchar(128) NOT NULL DEFAULT '',`Site_Nom` varchar(64) NOT NULL DEFAULT '',`Site_Adr1` varchar(40) NOT NULL DEFAULT '',`Site_Adr2` varchar(40) NOT NULL DEFAULT '',`Site_Adr3` varchar(40) NOT NULL DEFAULT '',`Site_Adr4` varchar(40) NOT NULL,`Site_CP` varchar(10) NOT NULL DEFAULT '',`Site_Ville` varchar(40) NOT NULL DEFAULT '',`Site_Pays` varchar(40) NOT NULL DEFAULT '',`Site_Acces` varchar(128) NOT NULL,`Site_RT` varchar(1024) NOT NULL DEFAULT '',`Site_APSAD` varchar(1024) NOT NULL DEFAULT '',`Site_Rem` varchar(1024) NOT NULL DEFAULT '',`Site_ResourceId` int(11) NOT NULL DEFAULT 0,`Livr` varchar(8) NOT NULL)";
    String wCREATE_Zones = "CREATE TABLE `Zones` (`ZoneId` int(11) NOT NULL,`Zone_SiteId` int(11) NOT NULL,`Zone_Code` varchar(24) NOT NULL DEFAULT '',`Zone_Depot` varchar(128) NOT NULL DEFAULT '',`Zone_Nom` varchar(64) NOT NULL DEFAULT '',`Zone_Adr1` varchar(40) NOT NULL DEFAULT '',`Zone_Adr2` varchar(40) NOT NULL DEFAULT '',`Zone_Adr3` varchar(40) NOT NULL DEFAULT '',`Zone_Adr4` varchar(40) NOT NULL,`Zone_CP` varchar(10) NOT NULL DEFAULT '',`Zone_Ville` varchar(40) NOT NULL DEFAULT '',`Zone_Pays` varchar(40) NOT NULL DEFAULT '',`Zone_Acces` varchar(128) NOT NULL,`Zone_Rem` varchar(1024) NOT NULL DEFAULT '',`Livr` varchar(8) NOT NULL)";
    String wCREATE_Intervention = "CREATE TABLE `Interventions` (`InterventionId` int(11) NOT NULL,`Intervention_ZoneId` int(11) DEFAULT 0,`Intervention_Date` varchar(32) NOT NULL DEFAULT '',`Intervention_Type` varchar(32) NOT NULL DEFAULT '',`Intervention_Parcs_Type` varchar(32) NOT NULL,`Intervention_Status` varchar(32) NOT NULL DEFAULT 'Planifiée',`Intervention_Histo_Status` longtext NOT NULL DEFAULT '',`Intervention_Facturation` varchar(32) NOT NULL DEFAULT 'Détaillée',`Intervention_Histo_Facturation` longtext NOT NULL DEFAULT '',`Intervention_Responsable` varchar(128) NOT NULL DEFAULT '',`Intervention_Intervenants` mediumtext NOT NULL DEFAULT '',`Intervention_Reglementation` mediumtext NOT NULL DEFAULT '',`Intervention_Signataire_Client` varchar(128) NOT NULL,`Intervention_Signataire_Tech` varchar(128) NOT NULL,`Intervention_Signataire_Date` varchar(32) NOT NULL,`Intervention_Remarque` varchar(1024) NOT NULL DEFAULT '',`Livr` varchar(8) NOT NULL DEFAULT '',`Intervention_Contrat` varchar(64) NOT NULL DEFAULT '',`Intervention_TypeContrat` varchar(128) NOT NULL DEFAULT '',`Intervention_Duree` varchar(128) NOT NULL DEFAULT '',`Intervention_Organes` varchar(1024) NOT NULL DEFAULT '',`Intervention_RT` varchar(1024) NOT NULL DEFAULT '',`Intervention_APSAD` varchar(1024) NOT NULL DEFAULT '')";
    String wCREATE_InterMissions = "CREATE TABLE `InterMissions` (`InterMissionId` int(11) NOT NULL,`InterMission_InterventionId` int(11) NOT NULL DEFAULT 0,`InterMission_Nom` varchar(512) NOT NULL,`InterMission_Exec` tinyint(1) NOT NULL,`InterMission_Date` varchar(32) NOT NULL,`InterMission_Note` varchar(4096) NOT NULL)";





    String wCREATE_Parcimgs = "CREATE TABLE Parc_Imgs (Parc_Imgid  INTEGER PRIMARY KEY AUTOINCREMENT,Parc_Imgs_ParcsId  INTEGER, Parc_Imgs_Type  INTEGER,  Parc_Imgs_Data  TEXT,  Parc_Imgs_Path varchar(512) NOT NULL DEFAULT '')";

    String wCREATE_Parcs_Ent = "CREATE TABLE Parcs_Ent (ParcsId  INTEGER PRIMARY KEY AUTOINCREMENT"
        ", Parcs_order INTEGER"
        ", Parcs_InterventionId  INTEGER"
        ", Parcs_Type varchar(512) NOT NULL DEFAULT ''"
        ", Parcs_Date_Fab varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_Date_Rev varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_QRCode varchar(128) NOT NULL DEFAULT ''"
        ", Parcs_FREQ_Id varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_FREQ_Label varchar(512) NOT NULL DEFAULT ''"
        ", Parcs_ANN_Id varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_ANN_Label varchar(512) NOT NULL DEFAULT ''"
        ", Parcs_FAB_Id varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_FAB_Label varchar(512) NOT NULL DEFAULT ''"
        ", Parcs_NIV_Id varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_NIV_Label varchar(512) NOT NULL DEFAULT ''"
        ", Parcs_ZNE_Id varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_ZNE_Label varchar(512) NOT NULL DEFAULT ''"
        ", Parcs_EMP_Id varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_EMP_Label varchar(512) NOT NULL DEFAULT ''"
        ", Parcs_LOT_Id varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_LOT_Label varchar(512) NOT NULL DEFAULT ''"
        ", Parcs_SERIE_Id varchar(32) NOT NULL DEFAULT ''"
        ", Parcs_SERIE_Label varchar(512) NOT NULL DEFAULT ''"
        ", Parcs_Audit_Note varchar(2048) NOT NULL DEFAULT ''"
        ", Parcs_Verif_Note varchar(2048) NOT NULL DEFAULT ''"
        ", Parcs_Intervention_Timer  INTEGER"
        ", Parcs_Update  INTEGER"
        ", Parcs_UUID varchar(64) NOT NULL DEFAULT ''"
        ", Parcs_UUID_Parent varchar(64) NOT NULL DEFAULT ''"
        ", Parcs_CodeArticle varchar(128) NOT NULL DEFAULT ''"
        ", Parcs_CODF varchar(128) NOT NULL DEFAULT ''"
        ", Parcs_NCERT varchar(128) NOT NULL DEFAULT ''"
        ", Parcs_Gamme varchar(128) NOT NULL DEFAULT ''"
        ", Livr varchar(8) NOT NULL DEFAULT ''"
        ", Devis varchar(8) NOT NULL DEFAULT ''"
        ", Action varchar(8) NOT NULL DEFAULT ''"
        ")";

    String wCREATE_Parcs_Desc = "CREATE TABLE Parcs_Desc (ParcsDescId  INTEGER PRIMARY KEY AUTOINCREMENT"
        ", ParcsDesc_ParcsId  INTEGER"
        ", ParcsDesc_Type varchar(512) NOT NULL DEFAULT ''"
        ", ParcsDesc_Id varchar(32) NOT NULL DEFAULT ''"
        ", ParcsDesc_Lib varchar(512) NOT NULL DEFAULT ''"
        ")";

    String wCREATE_Parcs_Desc_Index = "CREATE INDEX ParcsDesc_ParcsId ON Parcs_Desc(ParcsDesc_ParcsId)";

    String wCREATE_Parcs_Art = "CREATE TABLE Parcs_Art (ParcsArtId  INTEGER PRIMARY KEY AUTOINCREMENT"
        ", ParcsArt_ParcsId  INTEGER"
        ", ParcsArt_Type varchar(8) NOT NULL DEFAULT ''"
        ", ParcsArt_lnk varchar(8) NOT NULL DEFAULT ''"
        ", ParcsArt_Fact varchar(32) NOT NULL DEFAULT ''"
        ", ParcsArt_Livr varchar(32) NOT NULL DEFAULT ''"
        ", ParcsArt_Id varchar(32) NOT NULL DEFAULT ''"
        ", ParcsArt_Lib varchar(512) NOT NULL DEFAULT ''"
        ", ParcsArt_Qte  INTEGER"
        ")";

    String wCREATE_NF074_Avertissements = "CREATE TABLE NF074_Avertissements (NF074_AvertissementsId int(11) NOT NULL, NF074_Avertissements_No varchar(128) NOT NULL DEFAULT '',NF074_Avertissements_Details varchar(128) NOT NULL DEFAULT '',NF074_Avertissements_Date_Fab varchar(128) NOT NULL DEFAULT '',NF074_Avertissements_Date_Fact varchar(128) NOT NULL DEFAULT '',NF074_Avertissements_Procedure varchar(128) NOT NULL DEFAULT '',NF074_Avertissements_Liens varchar(128) NOT NULL DEFAULT '');";
    String wCREATE_NF074_Gammes =
        "CREATE TABLE NF074_Gammes (NF074_GammesId int(11) NOT NULL, NF074_Gammes_DESC varchar(128) NOT NULL DEFAULT '',NF074_Gammes_FAB varchar(128) NOT NULL DEFAULT '',NF074_Gammes_PRS varchar(128) NOT NULL DEFAULT '',NF074_Gammes_CLF varchar(128) NOT NULL DEFAULT '',NF074_Gammes_MOB varchar(128) NOT NULL DEFAULT '',NF074_Gammes_PDT varchar(128) NOT NULL DEFAULT '',NF074_Gammes_POIDS varchar(128) NOT NULL DEFAULT '',NF074_Gammes_GAM varchar(128) NOT NULL DEFAULT '',NF074_Gammes_CODF varchar(128) NOT NULL DEFAULT '',NF074_Gammes_REF varchar(128) NOT NULL DEFAULT '',NF074_Gammes_SERG varchar(128) NOT NULL DEFAULT '',NF074_Gammes_APD4 varchar(128) NOT NULL DEFAULT '',NF074_Gammes_AVT varchar(128) NOT NULL DEFAULT '',NF074_Gammes_NCERT varchar(128) NOT NULL DEFAULT '');";
    String wCREATE_NF074_Histo_Normes =
        "CREATE TABLE NF074_Histo_Normes (NF074_Histo_NormesId int(11) NOT NULL, NF074_Histo_Normes_FAB varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_NCERT varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_ENTR_MM varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_ENTR_AAAA varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_SORT_MM varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_SORT_AAAA varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_SODT varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_RTCH varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_RTYP varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_MVOL varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_ADDF varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_QTAD varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_MEL varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_AGEX varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_FOY varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_TEMP varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_DURE varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_TRSP varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_MPRS varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_GAZ varchar(128) NOT NULL DEFAULT '',NF074_Histo_Normes_USIN varchar(128) NOT NULL DEFAULT '');";
    String wCREATE_NF074_Mixte_Produit =
        "CREATE TABLE NF074_Mixte_Produit (NF074_Mixte_ProduitId int(11) NOT NULL,NF074_Mixte_Produit_DESC varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_POIDS varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_CLF varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_PDT varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_MOB varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_EMP varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_ZNE varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_Inst int(11) NOT NULL DEFAULT 0,NF074_Mixte_Produit_VerifAnn int(11) NOT NULL DEFAULT 0,NF074_Mixte_Produit_Rech int(11) NOT NULL DEFAULT 0,NF074_Mixte_Produit_MAA int(11) NOT NULL DEFAULT 0,NF074_Mixte_Produit_Charge int(11) NOT NULL DEFAULT 0,NF074_Mixte_Produit_RA int(11) NOT NULL DEFAULT 0,NF074_Mixte_Produit_RES int(11) NOT NULL DEFAULT 0,NF074_Mixte_Produit_Suggestion varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_CodearticlePD1 varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_DescriptionPD1 varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_QtePD1 int(11) NOT NULL,NF074_Mixte_Produit_CodearticlePD2 varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_DescriptionPD2 varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_QtePD2 int(11) NOT NULL,NF074_Mixte_Produit_CodearticlePD3 varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_DescriptionPD3 varchar(128) NOT NULL DEFAULT '',NF074_Mixte_Produit_QtePD3 int(11) NOT NULL);";
    String wCREATE_NF074_Pieces_Actions =
        "CREATE TABLE NF074_Pieces_Actions (NF074_Pieces_ActionsId int(11) NOT NULL DEFAULT 0,NF074_Pieces_Actions_DESC varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_PDT varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_POIDS varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_PRS varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_Inst int(11) NOT NULL DEFAULT 0,NF074_Pieces_Actions_VerifAnn int(11) NOT NULL DEFAULT 0,NF074_Pieces_Actions_Rech int(11) NOT NULL DEFAULT 0,NF074_Pieces_Actions_MAA int(11) NOT NULL DEFAULT 0,NF074_Pieces_Actions_Charge int(11) NOT NULL DEFAULT 0,NF074_Pieces_Actions_RA int(11) NOT NULL DEFAULT 0,NF074_Pieces_Actions_RES int(11) NOT NULL DEFAULT 0,NF074_Pieces_Actions_CodearticlePD1 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_DescriptionPD1 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_QtePD1 int(11) NOT NULL,NF074_Pieces_Actions_CodearticlePD2 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_DescriptionPD2 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_QtePD2 int(11) NOT NULL,NF074_Pieces_Actions_CodearticlePD3 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_DescriptionPD3 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Actions_QtePD3 int(11) NOT NULL);";
    String wCREATE_NF074_Pieces_Det =
        "CREATE TABLE NF074_Pieces_Det (NF074_Pieces_DetId int(11) NOT NULL,NF074_Pieces_Det_NCERT varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_RTYP varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_DESC varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_FAB varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_PRS varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_CLF varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_MOB varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_PDT varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_POIDS varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_GAM varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_CODF varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_SERG varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_CdeArtFab varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_DescriptionFAB varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Source varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Editon varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Revision varchar(128) NOT NULL,NF074_Pieces_Det_Prescriptions varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Commentaires varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Codearticle varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_CodearticlePD1 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_DescriptionPD1 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inst int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_VerifAnn int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_Rech int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_MAA int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_Charge int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_RA int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_RES int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_CodearticlePD2 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_DescriptionPD2 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_QtePD2 int(11) NOT NULL,NF074_Pieces_Det_CodearticlePD3 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_DescriptionPD3 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_QtePD3 int(11) NOT NULL);";
    String wCREATE_NF074_Pieces_Det_Inc =
        "CREATE TABLE NF074_Pieces_Det_Inc (NF074_Pieces_Det_IncId int(11) NOT NULL,NF074_Pieces_Det_Inc_DESC varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_FAB varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_PRS varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_CLF varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_MOB varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_PDT varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_POIDS varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_GAM varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_CODF varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_Inst int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_Inc_VerifAnn int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_Inc_Rech int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_Inc_MAA int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_Inc_Charge int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_Inc_RA int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_Inc_RES int(11) NOT NULL DEFAULT 0,NF074_Pieces_Det_Inc_CodearticlePD1 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_DescriptionPD1 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_QtePD1 int(11) NOT NULL,NF074_Pieces_Det_Inc_CodearticlePD2 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_DescriptionPD2 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_QtePD2 int(11) NOT NULL,NF074_Pieces_Det_Inc_CodearticlePD3 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_DescriptionPD3 varchar(128) NOT NULL DEFAULT '',NF074_Pieces_Det_Inc_QtePD3 int(11) NOT NULL);";



    //◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉
     String wDbPath = "eInterMissionse.db";
    //◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉

    database = openDatabase(
      join(await getDatabasesPath(), wDbPath),
      onCreate: (db, version) async {
        print("♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎");
        print("♦︎♦︎♦︎♦︎♦︎♦︎♦︎ onCreate $version ♦︎♦︎♦︎♦︎");
        print("♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎♦︎");

        await db.execute(wCREATE_Users_Desc);
        await db.execute(wCREATE_Users_Hab);
        await db.execute(wCREATE_Param_Param);
        await db.execute(wCREATE_Param_Saisie);
        await db.execute(wCREATE_Param_Saisie_Param);
        await db.execute(wCREATE_Users);
        await db.execute(wCREATE_Clients);
        await db.execute(wCREATE_Groupes);
        await db.execute(wCREATE_Sites);
        await db.execute(wCREATE_Zones);

        await db.execute(wCREATE_Intervention);
        await db.execute(wCREATE_InterMissions);




        await db.execute(wCREATE_Parcimgs);
        await db.execute(wCREATE_Parcs_Ent);
        await db.execute(wCREATE_Parcs_Desc);
        await db.execute(wCREATE_Parcs_Desc_Index);
        await db.execute(wCREATE_Parcs_Art);

        await db.execute(wCREATE_NF074_Avertissements);
        await db.execute(wCREATE_NF074_Gammes);
        await db.execute(wCREATE_NF074_Histo_Normes);
        await db.execute(wCREATE_NF074_Mixte_Produit);
        await db.execute(wCREATE_NF074_Pieces_Actions);
        await db.execute(wCREATE_NF074_Pieces_Det);
        await db.execute(wCREATE_NF074_Pieces_Det_Inc);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>> onUpgrade $oldVersion $newVersion");
      },
      version: 1,
    );

    final db = await database;
    final tables = await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    print("-------------------> onOpen Liste des table ${tables.length}");
    tables.forEach((element) {
      print("-------------------> tables ${element}");
    });
//    DbTools.glfClients = await DbTools.getClients();
  }

  //************************************************
  //************************************************
  //************************************************

  static Future LoadParam_Saisie_Param() async {
    var myData = await rootBundle.loadString('assets/Param_Saisie_Param.txt');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(eol: "\n", fieldDelimiter: ";", shouldParseNumbers: false).convert(myData);

    print("Param_Saisie_Param ${rowsAsListOfValues.length}");
    for (var i = 1; i < rowsAsListOfValues.length; i++) {
      print("==> ${rowsAsListOfValues[i][0].toString()} ${rowsAsListOfValues[i][1].toString()} ${rowsAsListOfValues[i][2].toString()} ${rowsAsListOfValues[i][3].toString()} ${rowsAsListOfValues[i][4].toString()} ");

      Param_Saisie_Param wParam_Saisie_Param = Param_Saisie_Param.Param_Saisie_ParamInit();

      wParam_Saisie_Param.Param_Saisie_Param_Id = rowsAsListOfValues[i][1].toString();
      wParam_Saisie_Param.Param_Saisie_Param_Ordre = int.parse(rowsAsListOfValues[i][2]);
      wParam_Saisie_Param.Param_Saisie_Param_Label = rowsAsListOfValues[i][3].toString();
      wParam_Saisie_Param.Param_Saisie_Param_Aide = rowsAsListOfValues[i][4].toString();

      Srv_DbTools.addParam_Saisie_Param(wParam_Saisie_Param);
    }
  }

  static Future getListTables() async {
    final db = await database;
    print("getListTables");

    (await db.query('sqlite_master', columns: ['type', 'name', 'sql'])).forEach((row) {
      print(row.values);
    });
  }
  
  //************************************************
  //**************** U S E R   H A B  **************
  //************************************************

  static Future<List<User_Hab>> getUser_Hab() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("User_Hab");
    return List.generate(maps.length, (i) {
      return User_Hab(
          maps[i]["User_HabID"],
          maps[i]["User_Hab_UserID"],
          maps[i]["User_Hab_Param_HabID"],
          maps[i]["User_Hab_MaintPrev"]=="true",
          maps[i]["User_Hab_Install"]=="true",
          maps[i]["User_Hab_MaintCorrect"]=="true",
          maps[i]["User_Hab_Ordre"],
      );
    });
  }

  static Future<void> inserUser_Hab(User_Hab wUser_Hab) async {
    final db = await DbTools.database;
    int? repid = await db.insert("User_Hab", wUser_Hab.toMap());
    gLastID = repid!;
  }


  static Future<void> TrunckUser_Hab() async {
    final db = await DbTools.database;
    int? repid = await db.delete("User_Hab");
  }

  //************************************************
  //************** U S E R   D E S C  **************
  //************************************************

  static Future<List<User_Desc>> getUser_Desc() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("User_Desc");
    return List.generate(maps.length, (i) {
      return User_Desc(
          maps[i]["User_DescID"],
          maps[i]["User_Desc_UserID"],
          maps[i]["User_Desc_Param_DescID"],
          maps[i]["User_Desc_MaintPrev"]=="true",
          maps[i]["User_Desc_Install"]=="true",
          maps[i]["User_Desc_MaintCorrect"]=="true",
          maps[i]["User_Desc_Ordre"],
      );
    });
  }

  static Future<void> inserUser_Desc(User_Desc wUser_Desc) async {
    final db = await DbTools.database;
    int? repid = await db.insert("User_Desc", wUser_Desc.toMap());
    gLastID = repid!;
  }


  static Future<void> TrunckUser_Desc() async {
    final db = await DbTools.database;
    int? repid = await db.delete("User_Desc");
  }



  //************************************************
  //*********** P A R A M   S A I S I E ************
  //************************************************

  static Future<List<Param_Saisie_Param>> getParam_Saisie_Param() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Param_Saisie_Param");
    return List.generate(maps.length, (i) {
      return Param_Saisie_Param(
          maps[i]["Param_Saisie_ParamId"],
          maps[i]["Param_Saisie_Param_Id"],
          maps[i]["Param_Saisie_Param_Ordre"],
          maps[i]["Param_Saisie_Param_Label"],
          maps[i]["Param_Saisie_Param_Abrev"],
          maps[i]["Param_Saisie_Param_Aide"],
          maps[i]["Param_Saisie_Param_Default"]=="true",
          maps[i]["Param_Saisie_Param_Init"]=="true",
          SizedBox(),
          maps[i]["Param_Saisie_Param_Color"],
      );
    });
  }

  static Future<void> inserParam_Saisie_Param(Param_Saisie_Param wParam_Saisie_Param) async {
    final db = await DbTools.database;
    int? repid = await db.insert("Param_Saisie_Param", wParam_Saisie_Param.toMap());
    gLastID = repid!;
  }


  static Future<void> TrunckParam_Saisie_Param() async {
    final db = await DbTools.database;
    int? repid = await db.delete("Param_Saisie_Param");
  }

  //************************************************
  //*********** P A R A M   S A I S I E ************
  //************************************************

  static Future<List<Param_Saisie>> getParam_Saisie() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Param_Saisie");
    return List.generate(maps.length, (i) {
      return Param_Saisie(
          maps[i]["Param_SaisieId"],
          maps[i]["Param_Saisie_Organe"],
          maps[i]["Param_Saisie_Type"],
          maps[i]["Param_Saisie_ID"],
          maps[i]["Param_Saisie_Label"],
          maps[i]["Param_Saisie_Aide"],
          maps[i]["Param_Saisie_Controle"],
          maps[i]["Param_Saisie_Ordre"],
          maps[i]["Param_Saisie_Affichage"],
          maps[i]["Param_Saisie_Ordre_Affichage"],
          maps[i]["Param_Saisie_Affichage_Titre"],
          (maps[i]["Param_Saisie_Affichage_L1"]==1),
          maps[i]["Param_Saisie_Affichage_L1_Ordre"],
          (maps[i]["Param_Saisie_Affichage_L2"]==1),
          maps[i]["Param_Saisie_Affichage_L2_Ordre"],
          maps[i]["Param_Saisie_Icon"],
          maps[i]["Param_Saisie_Triger"],
      );
    });
  }

  static Future<void> inserParam_Saisie(Param_Saisie wParam_Saisie) async {
    final db = await DbTools.database;
    int? repid = await db.insert("Param_Saisie", wParam_Saisie.toMap());
    gLastID = repid!;
  }


  static Future<void> TrunckParam_Saisie() async {
    final db = await DbTools.database;
    int? repid = await db.delete("Param_Saisie");
  }

  //************************************************
  //******************** U S E R S *****************
  //************************************************

  static Future<List<User>> getUsers() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM Users");
    print("maps $maps");


    return await List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }



  static Future<void> inserUsers() async {
    final db = await DbTools.database;
    await TrunckUsers();
    int? repid = await db.insert("Users", Srv_DbTools.gUserLogin.toMap());
    gLastID = repid!;
  }


  static Future<void> TrunckUsers() async {
    final db = await DbTools.database;
    int? repid = await db.delete("Users");
  }


  //************************************************
  //******************** I N T E R *****************
  //************************************************

  static List<Inter> lInters = [];
  static List<Inter> lIntersTmp = [];
  static late Inter gInter;

  //************************************************
  //******************** M A I N T *************
  //************************************************

  static List<Maint> lMaints = [];
  static late Maint gMaint;

  //************************************************
  //******************** NF074_Gammes **************
  //************************************************

  static List<NF074_Gammes> glfNF074_Gammes = [];
  static List<NF074_Gammes_Date> glfNF074_Gammes_Date = [];

  static NF074_Gammes gNF074_Gammes = NF074_Gammes.NF074_GammesInit();
  static NF074_Gammes_Date gNF074_Gammes_Date = NF074_Gammes_Date.NF074_Gammes_DateInit();

  static Future getNF074_Gammes_Decs() async {
    Srv_DbTools.ListParam_Saisie_Param.clear();
    final db = await database;
    String wRef = "NF074_Gammes_DESC";
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT ${wRef}  FROM `NF074_Gammes` GROUP BY ${wRef}  ORDER BY count(${wRef} ) DESC;');
    return List.generate(maps.length, (i) {
//     print("***********>>>   getNF074_Gammes_Decs maps ${maps[i]["NF074_Gammes_DESC"]}");
      Srv_DbTools.ListParam_Saisie_Param.add(Param_Saisie_Param(i, "DESC", i, maps[i]["NF074_Gammes_DESC"], maps[i]["NF074_Gammes_DESC"], maps[i]["NF074_Gammes_DESC"], false, false, SizedBox(), "Noir"));
    });
  }

  static Future getNF074_Gammes_FAB() async {
    Srv_DbTools.ListParam_Saisie_Param.clear();
    final db = await database;
    String wRef = "NF074_Gammes_FAB";
    String wSql = "SELECT ${wRef} FROM NF074_Gammes WHERE NF074_Gammes_DESC = '${Srv_DbTools.DESC_Lib}' GROUP BY ${wRef} ORDER BY ${wRef};";
    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    return List.generate(maps.length, (i) {
//      print("***********>>>   getNF074_Gammes_FAB maps ${maps[i]["NF074_Gammes_FAB"]}");
      Srv_DbTools.ListParam_Saisie_Param.add(Param_Saisie_Param(i, "FAB", i, maps[i]["NF074_Gammes_FAB"], maps[i]["NF074_Gammes_FAB"], maps[i]["NF074_Gammes_FAB"], false, false, SizedBox(), "Noir"));
    });
  }

  static Future getNF074_Gammes_PRS() async {
    Srv_DbTools.ListParam_Saisie_Param.clear();
    final db = await database;
    String wRef = "NF074_Gammes_PRS";
    String wSql = "SELECT ${wRef} FROM `NF074_Gammes` WHERE NF074_Gammes_DESC = '${Srv_DbTools.DESC_Lib}' AND NF074_Gammes_FAB = '${Srv_DbTools.FAB_Lib}' GROUP BY ${wRef} ORDER BY ${wRef};";
    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    return List.generate(maps.length, (i) {
//      print("***********>>>   getParcs_DescInter maps ${maps[i]["${wRef}"]}");
      Srv_DbTools.ListParam_Saisie_Param.add(Param_Saisie_Param(i, "DESC", i, maps[i]["${wRef}"], maps[i]["${wRef}"], maps[i]["${wRef}"], false, false, SizedBox(), "Noir"));
    });
  }

  static Future getNF074_Gammes_CLF() async {
    Srv_DbTools.ListParam_Saisie_Param.clear();
    final db = await database;
    String wRef = "NF074_Gammes_CLF";
    String wSql = "SELECT ${wRef} FROM `NF074_Gammes` WHERE NF074_Gammes_DESC = '${Srv_DbTools.DESC_Lib}' AND NF074_Gammes_FAB = '${Srv_DbTools.FAB_Lib}' AND NF074_Gammes_PRS = '${Srv_DbTools.PRS_Lib}' GROUP BY ${wRef} ORDER BY ${wRef};";
    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    return List.generate(maps.length, (i) {
      //    print("***********>>>   getParcs_DescInter maps ${maps[i]["${wRef}"]}");
      Srv_DbTools.ListParam_Saisie_Param.add(Param_Saisie_Param(i, "DESC", i, maps[i]["${wRef}"], maps[i]["${wRef}"], maps[i]["${wRef}"], false, false, SizedBox(), "Noir"));
    });
  }

  static Future getNF074_Gammes_MOB() async {
    Srv_DbTools.ListParam_Saisie_Param.clear();
    final db = await database;
    String wRef = "NF074_Gammes_MOB";
    String wSql = "SELECT ${wRef} FROM `NF074_Gammes` WHERE NF074_Gammes_DESC = '${Srv_DbTools.DESC_Lib}' AND NF074_Gammes_FAB = '${Srv_DbTools.FAB_Lib}' AND NF074_Gammes_PRS = '${Srv_DbTools.PRS_Lib}' AND NF074_Gammes_CLF = '${Srv_DbTools.CLF_Lib}' GROUP BY ${wRef} ORDER BY ${wRef};";
//    print("***********>>>   getNF074_Gammes_MOB wSql ${wSql}");
    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    print("***********>>>   getNF074_Gammes_MOB maps.length ${maps.length}");
    return List.generate(maps.length, (i) {
//      print("***********>>>   getParcs_DescInter maps ${maps[i]["${wRef}"]}");
      Srv_DbTools.ListParam_Saisie_Param.add(Param_Saisie_Param(i, "DESC", i, maps[i]["${wRef}"], maps[i]["${wRef}"], maps[i]["${wRef}"], false, false, SizedBox(), "Noir"));
    });
  }

  static Future getNF074_Gammes_PDT() async {
    Srv_DbTools.ListParam_Saisie_Param.clear();
    final db = await database;
    String wRef = "NF074_Gammes_PDT";
    String wSql = "SELECT ${wRef} FROM `NF074_Gammes` WHERE NF074_Gammes_DESC = '${Srv_DbTools.DESC_Lib}' AND NF074_Gammes_FAB = '${Srv_DbTools.FAB_Lib}' AND NF074_Gammes_PRS = '${Srv_DbTools.PRS_Lib}' AND NF074_Gammes_CLF = '${Srv_DbTools.CLF_Lib}'  AND NF074_Gammes_MOB = '${Srv_DbTools.MOB_Lib}' GROUP BY ${wRef} ORDER BY ${wRef};";
    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    return List.generate(maps.length, (i) {
      // print("***********>>>   getParcs_DescInter maps ${maps[i]["${wRef}"]}");
      Srv_DbTools.ListParam_Saisie_Param.add(Param_Saisie_Param(i, "DESC", i, maps[i]["${wRef}"], maps[i]["${wRef}"], maps[i]["${wRef}"], false, false, SizedBox(), "Noir"));
    });
  }

  static Future getNF074_Gammes_POIDS() async {
    Srv_DbTools.ListParam_Saisie_Param.clear();
    final db = await database;
    String wRef = "NF074_Gammes_POIDS";
    String wSql = "SELECT ${wRef} FROM `NF074_Gammes` WHERE NF074_Gammes_DESC = '${Srv_DbTools.DESC_Lib}' AND NF074_Gammes_FAB = '${Srv_DbTools.FAB_Lib}' AND NF074_Gammes_PRS = '${Srv_DbTools.PRS_Lib}' AND NF074_Gammes_CLF = '${Srv_DbTools.CLF_Lib}' AND NF074_Gammes_MOB = '${Srv_DbTools.MOB_Lib}' AND NF074_Gammes_PDT = '${Srv_DbTools.PDT_Lib}' GROUP BY ${wRef} ORDER BY ${wRef};";
//    print("***********>>>   getNF074_Gammes_POIDS wSql ${wSql}");
    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    return List.generate(maps.length, (i) {
      //    print("***********>>>   getParcs_DescInter maps ${maps[i]["${wRef}"]}");
      Srv_DbTools.ListParam_Saisie_Param.add(Param_Saisie_Param(i, "DESC", i, maps[i]["${wRef}"], maps[i]["${wRef}"], maps[i]["${wRef}"], false, false, SizedBox(), "Noir"));
    });
  }

  static Future getNF074_Gammes_GAM() async {
    Srv_DbTools.ListParam_Saisie_Param.clear();
    final db = await database;
    String wRef = "NF074_Gammes_GAM";
    String wSql = "SELECT ${wRef} FROM `NF074_Gammes` WHERE NF074_Gammes_DESC = '${Srv_DbTools.DESC_Lib}' AND NF074_Gammes_FAB = '${Srv_DbTools.FAB_Lib}' AND NF074_Gammes_PRS = '${Srv_DbTools.PRS_Lib}' AND NF074_Gammes_CLF = '${Srv_DbTools.CLF_Lib}' AND NF074_Gammes_MOB = '${Srv_DbTools.MOB_Lib}' AND NF074_Gammes_PDT = '${Srv_DbTools.PDT_Lib}'  AND NF074_Gammes_POIDS = '${Srv_DbTools.POIDS_Lib}' GROUP BY ${wRef} ORDER BY ${wRef};";
    //print("***********>>>   getNF074_Gammes_GAM wSql ${wSql}");
    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    return List.generate(maps.length, (i) {
      //print("***********>>>   getParcs_DescInter maps ${maps[i]["${wRef}"]}");
      Srv_DbTools.ListParam_Saisie_Param.add(Param_Saisie_Param(i, "DESC", i, maps[i]["${wRef}"], maps[i]["${wRef}"], maps[i]["${wRef}"], false, false, SizedBox(), "Noir"));
    });
  }

  static Future getNF074_Gammes_Get_REF(String wRef) async {
    final db = await database;
    String wSql = "SELECT * FROM `NF074_Gammes` WHERE NF074_Gammes_REF = '${wRef}';";
    print("***********>>>   getNF074_Gammes_GAM wSql ${wSql}");

    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    if (maps.length > 0) {
      gNF074_Gammes = NF074_Gammes(
        maps[0]["NF074_GammesId"],
        maps[0]["NF074_Gammes_DESC"],
        maps[0]["NF074_Gammes_FAB"],
        maps[0]["NF074_Gammes_PRS"],
        maps[0]["NF074_Gammes_CLF"],
        maps[0]["NF074_Gammes_MOB"],
        maps[0]["NF074_Gammes_PDT"],
        maps[0]["NF074_Gammes_POIDS"],
        maps[0]["NF074_Gammes_GAM"],
        maps[0]["NF074_Gammes_CODF"],
        maps[0]["NF074_Gammes_REF"],
        maps[0]["NF074_Gammes_SERG"],
        maps[0]["NF074_Gammes_APD4"],
        maps[0]["NF074_Gammes_AVT"],
        maps[0]["NF074_Gammes_NCERT"],
      );
      ;
    }
  }

  static Future getNF074_Gammes_Get_CODF(String wCodf) async {
    final db = await database;
    String wSql = "SELECT * FROM `NF074_Gammes` WHERE NF074_Gammes_CODF = '${wCodf}';";
    print("***********>>>   getNF074_Gammes_Get_CODF wSql ${wSql}");

    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    if (maps.length > 0) {
      gNF074_Gammes = NF074_Gammes(
        maps[0]["NF074_GammesId"],
        maps[0]["NF074_Gammes_DESC"],
        maps[0]["NF074_Gammes_FAB"],
        maps[0]["NF074_Gammes_PRS"],
        maps[0]["NF074_Gammes_CLF"],
        maps[0]["NF074_Gammes_MOB"],
        maps[0]["NF074_Gammes_PDT"],
        maps[0]["NF074_Gammes_POIDS"],
        maps[0]["NF074_Gammes_GAM"],
        maps[0]["NF074_Gammes_CODF"],
        maps[0]["NF074_Gammes_REF"],
        maps[0]["NF074_Gammes_SERG"],
        maps[0]["NF074_Gammes_APD4"],
        maps[0]["NF074_Gammes_AVT"],
        maps[0]["NF074_Gammes_NCERT"],
      );
      ;
    }
  }

  static Future<List<NF074_Gammes_Date>> getNF074_Gammes_Get_NCERT(String wRef) async {
    final db = await database;
    wRef = wRef.replaceAll(" ", "");
    String wSql = "SELECT NF074_Gammes.*, `NF074_Histo_Normes_ENTR_MM`, `NF074_Histo_Normes_ENTR_AAAA`, `NF074_Histo_Normes_SORT_MM`, `NF074_Histo_Normes_SORT_AAAA` FROM NF074_Gammes, NF074_Histo_Normes WHERE NF074_Gammes_NCERT = NF074_Histo_Normes_NCERT AND REPLACE(NF074_Gammes_NCERT, ' ', '') LIKE '${wRef}%' ORDER BY NF074_Gammes_NCERT,NF074_Gammes_REF;";
    print("***********>>>   getNF074_Gammes_GAM wSql ${wSql}");

    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    return List.generate(maps.length, (i) {
      return NF074_Gammes_Date(
        maps[i]["NF074_GammesId"],
        maps[i]["NF074_Gammes_DESC"],
        maps[i]["NF074_Gammes_FAB"],
        maps[i]["NF074_Gammes_PRS"],
        maps[i]["NF074_Gammes_CLF"],
        maps[i]["NF074_Gammes_MOB"],
        maps[i]["NF074_Gammes_PDT"],
        maps[i]["NF074_Gammes_POIDS"],
        maps[i]["NF074_Gammes_GAM"],
        maps[i]["NF074_Gammes_CODF"],
        maps[i]["NF074_Gammes_REF"],
        maps[i]["NF074_Gammes_SERG"],
        maps[i]["NF074_Gammes_APD4"],
        maps[i]["NF074_Gammes_AVT"],
        maps[i]["NF074_Gammes_NCERT"],
        maps[i]["NF074_Histo_Normes_ENTR_MM"],
        maps[i]["NF074_Histo_Normes_ENTR_AAAA"],
        maps[i]["NF074_Histo_Normes_SORT_MM"],
        maps[i]["NF074_Histo_Normes_SORT_AAAA"],
      );
    });
  }

  static Future<List<NF074_Gammes>> getNF074_Gammes_Get_DESC() async {
    final db = await database;

    String wSql = "SELECT * FROM `NF074_Gammes`WHERE "
        "NF074_Gammes_DESC = '${Srv_DbTools.DESC_Lib}' "
        "AND NF074_Gammes_FAB = '${Srv_DbTools.FAB_Lib}' "
        "AND NF074_Gammes_PRS = '${Srv_DbTools.PRS_Lib}' "
        "AND NF074_Gammes_CLF = '${Srv_DbTools.CLF_Lib}' "
        "AND NF074_Gammes_PDT = '${Srv_DbTools.PDT_Lib}' "
        "AND NF074_Gammes_POIDS = '${Srv_DbTools.POIDS_Lib}' "
        "AND NF074_Gammes_GAM = '${Srv_DbTools.GAM_Lib}';";

    //print("¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶*>>>   getNF074_Gammes_Get_DESC wSql ${wSql}");

    final List<Map<String, dynamic>> maps = await db.rawQuery(wSql);
    return List.generate(maps.length, (i) {
      return NF074_Gammes(maps[i]["NF074_GammesId"], maps[i]["NF074_Gammes_DESC"], maps[i]["NF074_Gammes_FAB"], maps[i]["NF074_Gammes_PRS"], maps[i]["NF074_Gammes_CLF"], maps[i]["NF074_Gammes_MOB"], maps[i]["NF074_Gammes_PDT"], maps[i]["NF074_Gammes_POIDS"], maps[i]["NF074_Gammes_GAM"], maps[i]["NF074_Gammes_CODF"], maps[i]["NF074_Gammes_REF"], maps[i]["NF074_Gammes_SERG"], maps[i]["NF074_Gammes_APD4"], maps[i]["NF074_Gammes_AVT"], maps[i]["NF074_Gammes_NCERT"]);
    });
  }

  static Future<List<NF074_Gammes>> getNF074_Gammes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("NF074_Gammes", orderBy: "NF074_GammesId ASC");
    return List.generate(maps.length, (i) {
      return NF074_Gammes(
        maps[i]["NF074_GammesId"],
        maps[i]["NF074_Gammes_DESC"],
        maps[i]["NF074_Gammes_FAB"],
        maps[i]["NF074_Gammes_PRS"],
        maps[i]["NF074_Gammes_CLF"],
        maps[i]["NF074_Gammes_MOB"],
        maps[i]["NF074_Gammes_PDT"],
        maps[i]["NF074_Gammes_POIDS"],
        maps[i]["NF074_Gammes_GAM"],
        maps[i]["NF074_Gammes_CODF"],
        maps[i]["NF074_Gammes_REF"],
        maps[i]["NF074_Gammes_SERG"],
        maps[i]["NF074_Gammes_APD4"],
        maps[i]["NF074_Gammes_AVT"],
        maps[i]["NF074_Gammes_NCERT"],
      );
    });
  }

  static Future<void> insertNF074_Gammes(NF074_Gammes nF074_Gammes) async {
    final db = await DbTools.database;
    int? repid = await db.insert("NF074_Gammes", nF074_Gammes.toMap());
    gLastID = repid!;
  }

  static Future<void> TrunckNF074_Gammes() async {
    final db = await DbTools.database;
    int? repid = await db.delete("NF074_Gammes");
  }

  //************************************************
  //******************** NF074_Histo_Normes ********
  //************************************************

  static List<NF074_Histo_Normes> glfNF074_Histo_Normes = [];

  static Future<List<NF074_Histo_Normes>> getNF074_Histo_Normes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("NF074_Histo_Normes", orderBy: "NF074_Histo_NormesId ASC");
    return List.generate(maps.length, (i) {
      return NF074_Histo_Normes(
        maps[i]["NF074_Histo_NormesId"],
        maps[i]["NF074_Histo_Normes_FAB"],
        maps[i]["NF074_Histo_Normes_NCERT"],
        maps[i]["NF074_Histo_Normes_ENTR_MM"],
        maps[i]["NF074_Histo_Normes_ENTR_AAAA"],
        maps[i]["NF074_Histo_Normes_SORT_MM"],
        maps[i]["NF074_Histo_Normes_SORT_AAAA"],
        maps[i]["NF074_Histo_Normes_SODT"],
        maps[i]["NF074_Histo_Normes_RTCH"],
        maps[i]["NF074_Histo_Normes_RTYP"],
        maps[i]["NF074_Histo_Normes_MVOL"],
        maps[i]["NF074_Histo_Normes_ADDF"],
        maps[i]["NF074_Histo_Normes_QTAD"],
        maps[i]["NF074_Histo_Normes_MEL"],
        maps[i]["NF074_Histo_Normes_AGEX"],
        maps[i]["NF074_Histo_Normes_FOY"],
        maps[i]["NF074_Histo_Normes_TEMP"],
        maps[i]["NF074_Histo_Normes_DURE"],
        maps[i]["NF074_Histo_Normes_TRSP"],
        maps[i]["NF074_Histo_Normes_MPRS"],
        maps[i]["NF074_Histo_Normes_GAZ"],
        maps[i]["NF074_Histo_Normes_USIN"],
      );
    });
  }

  static Future<void> insertNF074_Histo_Normes(NF074_Histo_Normes NF074_Histo_Normes) async {
    final db = await DbTools.database;
    int? repid = await db.insert("NF074_Histo_Normes", NF074_Histo_Normes.toMap());
    gLastID = repid!;
  }

  static Future<void> TrunckNF074_Histo_Normes() async {
    final db = await DbTools.database;
    int? repid = await db.delete("NF074_Histo_Normes");
  }

  //************************************************
  //******************** NF074_Pieces_Det ********
  //************************************************

  static List<NF074_Pieces_Det> glfNF074_Pieces_Det = [];
  static List<NF074_Pieces_Det> glfNF074_Pieces_Det_In = [];
  static List<NF074_Pieces_Det> glfNF074_Pieces_Det_Prop = [];

  static Future<bool> getNF074_Pieces_Det_Is_Def() async {
    final db = await database;
    bool wRet = false;
    String selSQL = "SELECT * FROM `NF074_Pieces_Det` WHERE NF074_Pieces_Det_CODF = '${Srv_DbTools.REF_Lib}'";
    //print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ getNF074_Pieces_Det_Is_Def selSQL ${selSQL}");
    final List<Map<String, dynamic>> maps = await db.rawQuery(selSQL);
    if (maps.length > 0) wRet = true;
    return wRet;
  }

  static Future<List<NF074_Pieces_Det>> getNF074_Pieces_Det_In(String wType) async {
    final db = await database;
    String selBase = "SELECT * FROM `NF074_Pieces_Det` WHERE ";
    String selDESC = "NF074_Pieces_Det_CODF = '${Srv_DbTools.REF_Lib}'";

    String selTypeVerif = "";
    if (wType.contains("Inst")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Inst  = 1 ";
    }
    if (wType.contains("VerifAnn")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_VerifAnn  = 1 ";
    }
    if (wType.contains("Rech")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Rech  = 1 ";
    }
    if (wType.contains("MAA")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_MAA  = 1 ";
    }
    if (wType.contains("Charge")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Charge  = 1 ";
    }
    if (wType.contains("RA")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_RA  = 1 ";
    }
    if (wType.contains("RES")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_RES  = 1 ";
    }


    String selSQL = "";
    if (selTypeVerif.isEmpty)
      return [];
    else
      selSQL = "$selBase ($selTypeVerif)  AND  $selDESC ";
     print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ getNF074_Pieces_Det_In selSQL ${selSQL}");

    final List<Map<String, dynamic>> maps = await db.rawQuery(selSQL);

    return List.generate(maps.length, (i) {
      return NF074_Pieces_Det(
        maps[i]["NF074_Pieces_DetId"],
        maps[i]["NF074_Pieces_Det_NCERT"],
        maps[i]["NF074_Pieces_Det_RTYP"],
        maps[i]["NF074_Pieces_Det_DESC"],
        maps[i]["NF074_Pieces_Det_FAB"],
        maps[i]["NF074_Pieces_Det_PRS"],
        maps[i]["NF074_Pieces_Det_CLF"],
        maps[i]["NF074_Pieces_Det_MOB"],
        maps[i]["NF074_Pieces_Det_PDT"],
        maps[i]["NF074_Pieces_Det_POIDS"],
        maps[i]["NF074_Pieces_Det_GAM"],
        maps[i]["NF074_Pieces_Det_CODF"],
        maps[i]["NF074_Pieces_Det_SERG"],
        maps[i]["NF074_Pieces_Det_CdeArtFab"],
        maps[i]["NF074_Pieces_Det_DescriptionFAB"],
        maps[i]["NF074_Pieces_Det_Source"],
        maps[i]["NF074_Pieces_Det_Editon"],
        maps[i]["NF074_Pieces_Det_Revision"],
        maps[i]["NF074_Pieces_Det_Prescriptions"],
        maps[i]["NF074_Pieces_Det_Commentaires"],
        maps[i]["NF074_Pieces_Det_Codearticle"],
        maps[i]["NF074_Pieces_Det_CodearticlePD1"],
        maps[i]["NF074_Pieces_Det_DescriptionPD1"],
        maps[i]["NF074_Pieces_Det_Inst"],
        maps[i]["NF074_Pieces_Det_VerifAnn"],
        maps[i]["NF074_Pieces_Det_Rech"],
        maps[i]["NF074_Pieces_Det_MAA"],
        maps[i]["NF074_Pieces_Det_Charge"],
        maps[i]["NF074_Pieces_Det_RA"],
        maps[i]["NF074_Pieces_Det_RES"],
        maps[i]["NF074_Pieces_Det_CodearticlePD2"],
        maps[i]["NF074_Pieces_Det_DescriptionPD2"],
        maps[i]["NF074_Pieces_Det_QtePD2"],
        maps[i]["NF074_Pieces_Det_CodearticlePD3"],
        maps[i]["NF074_Pieces_Det_DescriptionPD3"],
        maps[i]["NF074_Pieces_Det_QtePD3"],
      );
    });
  }

  static Future<List<NF074_Pieces_Det>> getNF074_Pieces_Det_PROP() async {
    final db = await database;
    String selBase = "SELECT * FROM `NF074_Pieces_Det` WHERE ";
    String selDESC = "NF074_Pieces_Det_CODF = '${Srv_DbTools.REF_Lib}'";

    String selTypeVerif = "";
    selTypeVerif += "NF074_Pieces_Det_Inst  = 0 AND ";
    selTypeVerif += "NF074_Pieces_Det_VerifAnn  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_Rech  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_MAA  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_Charge  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_RA  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_RES  = 0 ";

    String selSQL = "$selBase ($selTypeVerif)  AND  $selDESC ";
     print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ getNF074_Pieces_Det_PROP selSQL ${selSQL}");

    final List<Map<String, dynamic>> maps = await db.rawQuery(selSQL);

    return List.generate(maps.length, (i) {
      return NF074_Pieces_Det(
        maps[i]["NF074_Pieces_DetId"],
        maps[i]["NF074_Pieces_Det_NCERT"],
        maps[i]["NF074_Pieces_Det_RTYP"],
        maps[i]["NF074_Pieces_Det_DESC"],
        maps[i]["NF074_Pieces_Det_FAB"],
        maps[i]["NF074_Pieces_Det_PRS"],
        maps[i]["NF074_Pieces_Det_CLF"],
        maps[i]["NF074_Pieces_Det_MOB"],
        maps[i]["NF074_Pieces_Det_PDT"],
        maps[i]["NF074_Pieces_Det_POIDS"],
        maps[i]["NF074_Pieces_Det_GAM"],
        maps[i]["NF074_Pieces_Det_CODF"],
        maps[i]["NF074_Pieces_Det_SERG"],
        maps[i]["NF074_Pieces_Det_CdeArtFab"],
        maps[i]["NF074_Pieces_Det_DescriptionFAB"],
        maps[i]["NF074_Pieces_Det_Source"],
        maps[i]["NF074_Pieces_Det_Editon"],
        maps[i]["NF074_Pieces_Det_Revision"],
        maps[i]["NF074_Pieces_Det_Prescriptions"],
        maps[i]["NF074_Pieces_Det_Commentaires"],
        maps[i]["NF074_Pieces_Det_Codearticle"],
        maps[i]["NF074_Pieces_Det_CodearticlePD1"],
        maps[i]["NF074_Pieces_Det_DescriptionPD1"],
        maps[i]["NF074_Pieces_Det_Inst"],
        maps[i]["NF074_Pieces_Det_VerifAnn"],
        maps[i]["NF074_Pieces_Det_Rech"],
        maps[i]["NF074_Pieces_Det_MAA"],
        maps[i]["NF074_Pieces_Det_Charge"],
        maps[i]["NF074_Pieces_Det_RA"],
        maps[i]["NF074_Pieces_Det_RES"],
        maps[i]["NF074_Pieces_Det_CodearticlePD2"],
        maps[i]["NF074_Pieces_Det_DescriptionPD2"],
        maps[i]["NF074_Pieces_Det_QtePD2"],
        maps[i]["NF074_Pieces_Det_CodearticlePD3"],
        maps[i]["NF074_Pieces_Det_DescriptionPD3"],
        maps[i]["NF074_Pieces_Det_QtePD3"],
      );
    });
  }

  static Future<List<NF074_Pieces_Det>> getNF074_Pieces_Det() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("NF074_Pieces_Det", orderBy: "NF074_Pieces_DetId ASC");
    return List.generate(maps.length, (i) {
      return NF074_Pieces_Det(
        maps[i]["NF074_Pieces_DetId"],
        maps[i]["NF074_Pieces_Det_NCERT"],
        maps[i]["NF074_Pieces_Det_RTYP"],
        maps[i]["NF074_Pieces_Det_DESC"],
        maps[i]["NF074_Pieces_Det_FAB"],
        maps[i]["NF074_Pieces_Det_PRS"],
        maps[i]["NF074_Pieces_Det_CLF"],
        maps[i]["NF074_Pieces_Det_MOB"],
        maps[i]["NF074_Pieces_Det_PDT"],
        maps[i]["NF074_Pieces_Det_POIDS"],
        maps[i]["NF074_Pieces_Det_GAM"],
        maps[i]["NF074_Pieces_Det_CODF"],
        maps[i]["NF074_Pieces_Det_SERG"],
        maps[i]["NF074_Pieces_Det_CdeArtFab"],
        maps[i]["NF074_Pieces_Det_DescriptionFAB"],
        maps[i]["NF074_Pieces_Det_Source"],
        maps[i]["NF074_Pieces_Det_Editon"],
        maps[i]["NF074_Pieces_Det_Revision"],
        maps[i]["NF074_Pieces_Det_Prescriptions"],
        maps[i]["NF074_Pieces_Det_Commentaires"],
        maps[i]["NF074_Pieces_Det_Codearticle"],
        maps[i]["NF074_Pieces_Det_CodearticlePD1"],
        maps[i]["NF074_Pieces_Det_DescriptionPD1"],
        maps[i]["NF074_Pieces_Det_Inst"],
        maps[i]["NF074_Pieces_Det_VerifAnn"],
        maps[i]["NF074_Pieces_Det_Rech"],
        maps[i]["NF074_Pieces_Det_MAA"],
        maps[i]["NF074_Pieces_Det_Charge"],
        maps[i]["NF074_Pieces_Det_RA"],
        maps[i]["NF074_Pieces_Det_RES"],
        maps[i]["NF074_Pieces_Det_CodearticlePD2"],
        maps[i]["NF074_Pieces_Det_DescriptionPD2"],
        maps[i]["NF074_Pieces_Det_QtePD2"],
        maps[i]["NF074_Pieces_Det_CodearticlePD3"],
        maps[i]["NF074_Pieces_Det_DescriptionPD3"],
        maps[i]["NF074_Pieces_Det_QtePD3"],
      );
    });
  }

  static Future<void> insertNF074_Pieces_Det(NF074_Pieces_Det NF074_Pieces_Det) async {
    final db = await DbTools.database;
    int? repid = await db.insert("NF074_Pieces_Det", NF074_Pieces_Det.toMap());
    gLastID = repid!;
  }

  static Future<void> TrunckNF074_Pieces_Det() async {
    final db = await DbTools.database;
    int? repid = await db.delete("NF074_Pieces_Det");
  }

  //************************************************
  //******************** NF074_Pieces_Det_Inc ********
  //************************************************

  static List<NF074_Pieces_Det_Inc> glfNF074_Pieces_Det_Inc = [];
  static List<NF074_Pieces_Det_Inc> glfNF074_Pieces_Det_Inc_In = [];

  static Future<List<NF074_Pieces_Det_Inc>> getNF074_Pieces_Det_Inc_In(String wType) async {
    final db = await database;

    String selBase = "SELECT * FROM NF074_Pieces_Det_Inc WHERE ";
    String selDESCTous = "NF074_Pieces_Det_Inc_DESC = 'Tous' ";
    String selDESCPRS = "NF074_Pieces_Det_Inc_DESC LIKE '%${Srv_DbTools.DESC_Lib}%' AND NF074_Pieces_Det_Inc_PRS LIKE '%${Srv_DbTools.PRS_Lib}%'  AND NF074_Pieces_Det_Inc_CLF LIKE '%${Srv_DbTools.CLF_Lib}%' ";
    String selMOBPDT = "(NF074_Pieces_Det_Inc_MOB LIKE '%${Srv_DbTools.MOB_Lib}%' OR NF074_Pieces_Det_Inc_MOB  = 'Tous') AND (NF074_Pieces_Det_Inc_PDT LIKE '%${Srv_DbTools.PDT_Lib}%' OR NF074_Pieces_Det_Inc_PDT  = 'Tous')  AND (NF074_Pieces_Det_Inc_POIDS LIKE '%${Srv_DbTools.POIDS_Lib}%' OR NF074_Pieces_Det_Inc_POIDS  = 'Tous')";

    String selTypeVerif = "";
    if (wType.contains("Inst")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Inc_Inst  = 1 ";
    }
    if (wType.contains("VerifAnn")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Inc_VerifAnn  = 1 ";
    }
    if (wType.contains("Rech")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Inc_Rech  = 1 ";
    }
    if (wType.contains("MAA")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Inc_MAA  = 1 ";
    }
    if (wType.contains("Charge")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Inc_Charge  = 1 ";
    }
    if (wType.contains("RA")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Inc_RA  = 1 ";
    }
    if (wType.contains("RES")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Det_Inc_RES  = 1 ";
    }


    String selSQL = "";
    if (selTypeVerif.isEmpty)
      return [];
    else
      selSQL = "$selBase ($selTypeVerif)  AND  $selDESCTous or ($selDESCPRS AND $selDESCPRS AND $selMOBPDT)";


    //print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ getNF074_Pieces_Det_Inc_In selSQL ${selSQL}");

    final List<Map<String, dynamic>> maps = await db.rawQuery(selSQL);

    return List.generate(maps.length, (i) {
      return NF074_Pieces_Det_Inc(
        maps[i]["NF074_Pieces_Det_IncId"],
        maps[i]["NF074_Pieces_Det_Inc_DESC"],
        maps[i]["NF074_Pieces_Det_Inc_FAB"],
        maps[i]["NF074_Pieces_Det_Inc_PRS"],
        maps[i]["NF074_Pieces_Det_Inc_CLF"],
        maps[i]["NF074_Pieces_Det_Inc_MOB"],
        maps[i]["NF074_Pieces_Det_Inc_PDT"],
        maps[i]["NF074_Pieces_Det_Inc_POIDS"],
        maps[i]["NF074_Pieces_Det_Inc_GAM"],
        maps[i]["NF074_Pieces_Det_Inc_Inst"],
        maps[i]["NF074_Pieces_Det_Inc_VerifAnn"],
        maps[i]["NF074_Pieces_Det_Inc_Rech"],
        maps[i]["NF074_Pieces_Det_Inc_MAA"],
        maps[i]["NF074_Pieces_Det_Inc_Charge"],
        maps[i]["NF074_Pieces_Det_Inc_RA"],
        maps[i]["NF074_Pieces_Det_Inc_RES"],
        maps[i]["NF074_Pieces_Det_Inc_CodearticlePD1"],
        maps[i]["NF074_Pieces_Det_Inc_DescriptionPD1"],
        maps[i]["NF074_Pieces_Det_Inc_QtePD1"],
        maps[i]["NF074_Pieces_Det_Inc_CodearticlePD2"],
        maps[i]["NF074_Pieces_Det_Inc_DescriptionPD2"],
        maps[i]["NF074_Pieces_Det_Inc_QtePD2"],
        maps[i]["NF074_Pieces_Det_Inc_CodearticlePD3"],
        maps[i]["NF074_Pieces_Det_Inc_DescriptionPD3"],
        maps[i]["NF074_Pieces_Det_Inc_QtePD3"],
      );
    });
  }

  static Future<List<NF074_Pieces_Det_Inc>> getNF074_Pieces_Det_Inc_Prop(String wType) async {
    final db = await database;

    String selBase = "SELECT * FROM NF074_Pieces_Det_Inc WHERE ";
    String selDESCTous = "NF074_Pieces_Det_Inc_DESC = 'Tous' ";
    String selDESCPRS = "NF074_Pieces_Det_Inc_DESC LIKE '%${Srv_DbTools.DESC_Lib}%' AND NF074_Pieces_Det_Inc_PRS LIKE '%${Srv_DbTools.PRS_Lib}%'  AND NF074_Pieces_Det_Inc_CLF LIKE '%${Srv_DbTools.CLF_Lib}%' ";
    String selMOBPDT = "(NF074_Pieces_Det_Inc_MOB LIKE '%${Srv_DbTools.MOB_Lib}%' OR NF074_Pieces_Det_Inc_MOB  = 'Tous') AND (NF074_Pieces_Det_Inc_PDT LIKE '%${Srv_DbTools.PDT_Lib}%' OR NF074_Pieces_Det_Inc_PDT  = 'Tous')  AND (NF074_Pieces_Det_Inc_POIDS LIKE '%${Srv_DbTools.POIDS_Lib}%' OR NF074_Pieces_Det_Inc_POIDS  = 'Tous')";

    String selTypeVerif = "";
    selTypeVerif += "NF074_Pieces_Det_Inst  = 0 AND ";
    selTypeVerif += "NF074_Pieces_Det_VerifAnn  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_Rech  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_MAA  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_Charge  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_RA  = 0  AND ";
    selTypeVerif += "NF074_Pieces_Det_RES  = 0 ";

    String selSQL = "";
    if (selTypeVerif.isEmpty)
      return [];
    else
      selSQL = "$selBase ($selTypeVerif)  AND  $selDESCTous or ($selDESCPRS AND $selDESCPRS AND $selMOBPDT)";

    //print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ getNF074_Pieces_Det_Inc_In selSQL ${selSQL}");

    final List<Map<String, dynamic>> maps = await db.rawQuery(selSQL);

    return List.generate(maps.length, (i) {
      return NF074_Pieces_Det_Inc(
        maps[i]["NF074_Pieces_Det_IncId"],
        maps[i]["NF074_Pieces_Det_Inc_DESC"],
        maps[i]["NF074_Pieces_Det_Inc_FAB"],
        maps[i]["NF074_Pieces_Det_Inc_PRS"],
        maps[i]["NF074_Pieces_Det_Inc_CLF"],
        maps[i]["NF074_Pieces_Det_Inc_MOB"],
        maps[i]["NF074_Pieces_Det_Inc_PDT"],
        maps[i]["NF074_Pieces_Det_Inc_POIDS"],
        maps[i]["NF074_Pieces_Det_Inc_GAM"],
        maps[i]["NF074_Pieces_Det_Inc_Inst"],
        maps[i]["NF074_Pieces_Det_Inc_VerifAnn"],
        maps[i]["NF074_Pieces_Det_Inc_Rech"],
        maps[i]["NF074_Pieces_Det_Inc_MAA"],
        maps[i]["NF074_Pieces_Det_Inc_Charge"],
        maps[i]["NF074_Pieces_Det_Inc_RA"],
        maps[i]["NF074_Pieces_Det_Inc_RES"],
        maps[i]["NF074_Pieces_Det_Inc_CodearticlePD1"],
        maps[i]["NF074_Pieces_Det_Inc_DescriptionPD1"],
        maps[i]["NF074_Pieces_Det_Inc_QtePD1"],
        maps[i]["NF074_Pieces_Det_Inc_CodearticlePD2"],
        maps[i]["NF074_Pieces_Det_Inc_DescriptionPD2"],
        maps[i]["NF074_Pieces_Det_Inc_QtePD2"],
        maps[i]["NF074_Pieces_Det_Inc_CodearticlePD3"],
        maps[i]["NF074_Pieces_Det_Inc_DescriptionPD3"],
        maps[i]["NF074_Pieces_Det_Inc_QtePD3"],
      );
    });
  }

  static Future<List<NF074_Pieces_Det_Inc>> getNF074_Pieces_Det_Inc() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("NF074_Pieces_Det_Inc", orderBy: "NF074_Pieces_Det_IncId ASC");

    return List.generate(maps.length, (i) {
      return NF074_Pieces_Det_Inc(
        maps[i]["NF074_Pieces_Det_IncId"],
        maps[i]["NF074_Pieces_Det_Inc_DESC"],
        maps[i]["NF074_Pieces_Det_Inc_FAB"],
        maps[i]["NF074_Pieces_Det_Inc_PRS"],
        maps[i]["NF074_Pieces_Det_Inc_CLF"],
        maps[i]["NF074_Pieces_Det_Inc_MOB"],
        maps[i]["NF074_Pieces_Det_Inc_PDT"],
        maps[i]["NF074_Pieces_Det_Inc_POIDS"],
        maps[i]["NF074_Pieces_Det_Inc_GAM"],
        maps[i]["NF074_Pieces_Det_Inc_Inst"],
        maps[i]["NF074_Pieces_Det_Inc_VerifAnn"],
        maps[i]["NF074_Pieces_Det_Inc_Rech"],
        maps[i]["NF074_Pieces_Det_Inc_MAA"],
        maps[i]["NF074_Pieces_Det_Inc_Charge"],
        maps[i]["NF074_Pieces_Det_Inc_RA"],
        maps[i]["NF074_Pieces_Det_Inc_RES"],
        maps[i]["NF074_Pieces_Det_Inc_CodearticlePD1"],
        maps[i]["NF074_Pieces_Det_Inc_DescriptionPD1"],
        maps[i]["NF074_Pieces_Det_Inc_QtePD1"],
        maps[i]["NF074_Pieces_Det_Inc_CodearticlePD2"],
        maps[i]["NF074_Pieces_Det_Inc_DescriptionPD2"],
        maps[i]["NF074_Pieces_Det_Inc_QtePD2"],
        maps[i]["NF074_Pieces_Det_Inc_CodearticlePD3"],
        maps[i]["NF074_Pieces_Det_Inc_DescriptionPD3"],
        maps[i]["NF074_Pieces_Det_Inc_QtePD3"],
      );
    });
  }

  static Future<void> insertNF074_Pieces_Det_Inc(NF074_Pieces_Det_Inc NF074_Pieces_Det_Inc) async {
    final db = await DbTools.database;
    int? repid = await db.insert("NF074_Pieces_Det_Inc", NF074_Pieces_Det_Inc.toMap());
    gLastID = repid!;
  }

  static Future<void> TrunckNF074_Pieces_Det_Inc() async {
    final db = await DbTools.database;
    int? repid = await db.delete("NF074_Pieces_Det_Inc");
  }

  //************************************************
  //******************** NF074_Mixte_Produit ********
  //************************************************

  static List<NF074_Mixte_Produit> glfNF074_Mixte_Produit = [];
  static List<NF074_Mixte_Produit> glfNF074_Mixte_Produit_In = [];

  static Future<List<NF074_Mixte_Produit>> getNF074_Mixte_Produit_In(String wType) async {
    final db = await database;

    String selBase = "SELECT * FROM NF074_Mixte_Produit WHERE ";
    String selDESC = "NF074_Mixte_Produit_DESC LIKE '%${Srv_DbTools.DESC_Lib}%' ";
    String selMOBPDT = " (NF074_Mixte_Produit_POIDS LIKE '%${Srv_DbTools.POIDS_Lib}%' OR NF074_Mixte_Produit_POIDS  = '') AND (NF074_Mixte_Produit_CLF LIKE '%${Srv_DbTools.CLF_Lib}%' OR NF074_Mixte_Produit_CLF  = '') ";
    String selEMPZNE = " (NF074_Mixte_Produit_EMP LIKE '%${DbTools.gParc_Ent.Parcs_EMP_Label}%' OR NF074_Mixte_Produit_EMP  = '') AND (NF074_Mixte_Produit_ZNE LIKE '%${DbTools.gParc_Ent.Parcs_ZNE_Label}%' OR NF074_Mixte_Produit_ZNE  = '') ";

    String selTypeVerif = "";
    if (wType.contains("Inst")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Mixte_Produit_Inst  = 1 ";
    }
    if (wType.contains("VerifAnn")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Mixte_Produit_VerifAnn  = 1 ";
    }
    if (wType.contains("Rech")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Mixte_Produit_Rech  = 1 ";
    }
    if (wType.contains("MAA")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Mixte_Produit_MAA  = 1 ";
    }
    if (wType.contains("Charge")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Mixte_Produit_Charge  = 1 ";
    }
    if (wType.contains("RA")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Mixte_Produit_RA  = 1 ";
    }
    if (wType.contains("RES")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Mixte_Produit_RES  = 1 ";
    }

    String selSQL = "";
    if (selTypeVerif.isEmpty)
      return [];
    else
      selSQL = "$selBase ($selTypeVerif)  AND  $selDESC AND $selMOBPDT AND $selEMPZNE";


    print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ getNF074_Mixte_Produit_In selSQL ${selSQL}");

    final List<Map<String, dynamic>> maps = await db.rawQuery(selSQL);

    return List.generate(maps.length, (i) {
      return NF074_Mixte_Produit(
        maps[i]["NF074_Mixte_ProduitId"],
        maps[i]["NF074_Mixte_Produit_DESC"],
        maps[i]["NF074_Mixte_Produit_POIDS"],
        maps[i]["NF074_Mixte_Produit_CLF"],
        maps[i]["NF074_Mixte_Produit_PDT"],
        maps[i]["NF074_Mixte_Produit_MOB"],
        maps[i]["NF074_Mixte_Produit_EMP"],
        maps[i]["NF074_Mixte_Produit_ZNE"],
        maps[i]["NF074_Mixte_Produit_Inst"],
        maps[i]["NF074_Mixte_Produit_VerifAnn"],
        maps[i]["NF074_Mixte_Produit_Rech"],
        maps[i]["NF074_Mixte_Produit_MAA"],
        maps[i]["NF074_Mixte_Produit_Charge"],
        maps[i]["NF074_Mixte_Produit_RA"],
        maps[i]["NF074_Mixte_Produit_RES"],
        maps[i]["NF074_Mixte_Produit_Suggestion"],
        maps[i]["NF074_Mixte_Produit_CodearticlePD1"],
        maps[i]["NF074_Mixte_Produit_DescriptionPD1"],
        maps[i]["NF074_Mixte_Produit_QtePD1"],
        maps[i]["NF074_Mixte_Produit_CodearticlePD2"],
        maps[i]["NF074_Mixte_Produit_DescriptionPD2"],
        maps[i]["NF074_Mixte_Produit_QtePD2"],
        maps[i]["NF074_Mixte_Produit_CodearticlePD3"],
        maps[i]["NF074_Mixte_Produit_DescriptionPD3"],
        maps[i]["NF074_Mixte_Produit_QtePD3"],
      );
    });
  }

  static Future<List<NF074_Mixte_Produit>> getNF074_Mixte_Produit_In_Prop(String wType) async {
    final db = await database;

    String selBase = "SELECT * FROM NF074_Mixte_Produit WHERE ";
    String selDESC = "NF074_Mixte_Produit_DESC LIKE '%${Srv_DbTools.DESC_Lib}%' ";
    String selMOBPDT = " (NF074_Mixte_Produit_POIDS LIKE '%${Srv_DbTools.POIDS_Lib}%' OR NF074_Mixte_Produit_POIDS  = '') AND (NF074_Mixte_Produit_CLF LIKE '%${Srv_DbTools.CLF_Lib}%' OR NF074_Mixte_Produit_CLF  = '') ";
    String selEMPZNE = " (NF074_Mixte_Produit_EMP LIKE '%${DbTools.gParc_Ent.Parcs_EMP_Label}%' OR NF074_Mixte_Produit_EMP  = '') AND (NF074_Mixte_Produit_ZNE LIKE '%${DbTools.gParc_Ent.Parcs_ZNE_Label}%' OR NF074_Mixte_Produit_ZNE  = '') ";

    String selTypeVerif = "";
    selTypeVerif += "NF074_Mixte_Produit_Inst  = 0 AND ";
    selTypeVerif += "NF074_Mixte_Produit_VerifAnn  = 0 AND ";
    selTypeVerif += "NF074_Mixte_Produit_Rech  = 0 AND ";
    selTypeVerif += "NF074_Mixte_Produit_MAA  = 0 AND ";
    selTypeVerif += "NF074_Mixte_Produit_Charge  = 0 AND ";
    selTypeVerif += "NF074_Mixte_Produit_RA  = 0 AND ";
    selTypeVerif += "NF074_Mixte_Produit_RES  = 0 ";

    String selSQL = "$selBase $selTypeVerif  AND  $selDESC AND $selMOBPDT AND $selEMPZNE";
    //print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ getNF074_Mixte_Produit_In selSQL ${selSQL}");
    final List<Map<String, dynamic>> maps = await db.rawQuery(selSQL);
    return List.generate(maps.length, (i) {
      return NF074_Mixte_Produit(
        maps[i]["NF074_Mixte_ProduitId"],
        maps[i]["NF074_Mixte_Produit_DESC"],
        maps[i]["NF074_Mixte_Produit_POIDS"],
        maps[i]["NF074_Mixte_Produit_CLF"],
        maps[i]["NF074_Mixte_Produit_PDT"],
        maps[i]["NF074_Mixte_Produit_MOB"],
        maps[i]["NF074_Mixte_Produit_EMP"],
        maps[i]["NF074_Mixte_Produit_ZNE"],
        maps[i]["NF074_Mixte_Produit_Inst"],
        maps[i]["NF074_Mixte_Produit_VerifAnn"],
        maps[i]["NF074_Mixte_Produit_Rech"],
        maps[i]["NF074_Mixte_Produit_MAA"],
        maps[i]["NF074_Mixte_Produit_Charge"],
        maps[i]["NF074_Mixte_Produit_RA"],
        maps[i]["NF074_Mixte_Produit_RES"],
        maps[i]["NF074_Mixte_Produit_Suggestion"],
        maps[i]["NF074_Mixte_Produit_CodearticlePD1"],
        maps[i]["NF074_Mixte_Produit_DescriptionPD1"],
        maps[i]["NF074_Mixte_Produit_QtePD1"],
        maps[i]["NF074_Mixte_Produit_CodearticlePD2"],
        maps[i]["NF074_Mixte_Produit_DescriptionPD2"],
        maps[i]["NF074_Mixte_Produit_QtePD2"],
        maps[i]["NF074_Mixte_Produit_CodearticlePD3"],
        maps[i]["NF074_Mixte_Produit_DescriptionPD3"],
        maps[i]["NF074_Mixte_Produit_QtePD3"],
      );
    });
  }

  static Future<List<NF074_Mixte_Produit>> getNF074_Mixte_Produit() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("NF074_Mixte_Produit", orderBy: "NF074_Mixte_ProduitId ASC");

    return List.generate(maps.length, (i) {
      return NF074_Mixte_Produit(
        maps[i]["NF074_Mixte_ProduitId"],
        maps[i]["NF074_Mixte_Produit_DESC"],
        maps[i]["NF074_Mixte_Produit_POIDS"],
        maps[i]["NF074_Mixte_Produit_CLF"],
        maps[i]["NF074_Mixte_Produit_PDT"],
        maps[i]["NF074_Mixte_Produit_MOB"],
        maps[i]["NF074_Mixte_Produit_EMP"],
        maps[i]["NF074_Mixte_Produit_ZNE"],
        maps[i]["NF074_Mixte_Produit_Inst"],
        maps[i]["NF074_Mixte_Produit_VerifAnn"],
        maps[i]["NF074_Mixte_Produit_Rech"],
        maps[i]["NF074_Mixte_Produit_MAA"],
        maps[i]["NF074_Mixte_Produit_Charge"],
        maps[i]["NF074_Mixte_Produit_RA"],
        maps[i]["NF074_Mixte_Produit_RES"],
        maps[i]["NF074_Mixte_Produit_Suggestion"],
        maps[i]["NF074_Mixte_Produit_CodearticlePD1"],
        maps[i]["NF074_Mixte_Produit_DescriptionPD1"],
        maps[i]["NF074_Mixte_Produit_QtePD1"],
        maps[i]["NF074_Mixte_Produit_CodearticlePD2"],
        maps[i]["NF074_Mixte_Produit_DescriptionPD2"],
        maps[i]["NF074_Mixte_Produit_QtePD2"],
        maps[i]["NF074_Mixte_Produit_CodearticlePD3"],
        maps[i]["NF074_Mixte_Produit_DescriptionPD3"],
        maps[i]["NF074_Mixte_Produit_QtePD3"],
      );
    });
  }

  static Future<void> insertNF074_Mixte_Produit(NF074_Mixte_Produit NF074_Mixte_Produit) async {
    final db = await DbTools.database;
    int? repid = await db.insert("NF074_Mixte_Produit", NF074_Mixte_Produit.toMap());
    gLastID = repid!;
  }

  static Future<void> TrunckNF074_Mixte_Produit() async {
    final db = await DbTools.database;
    int? repid = await db.delete("NF074_Mixte_Produit");
  }

  //************************************************
  //******************** NF074_Pieces_Actions ********
  //************************************************

  static List<NF074_Pieces_Actions> glfNF074_Pieces_Actions = [];
  static List<NF074_Pieces_Actions> glfNF074_Pieces_Actions_In = [];

  static Future<List<NF074_Pieces_Actions>> getNF074_Pieces_Actions_In(String wType) async {
    final db = await database;

    //    SELECT * FROM `NF074_Pieces_Actions` WHERE
//    (  NF074_Pieces_Actions_VerifAnn  = 1 OR NF074_Pieces_Actions_Rech  = 1 )
//    AND (
//    NF074_Pieces_Actions_DESC LIKE '%Extincteur Portatif%'
//    OR (
//    NF074_Pieces_Actions_PDT = 'Poudre ABC' AND NF074_Pieces_Actions_POIDS = '6 Kilos' AND NF074_Pieces_Actions_PRS = 'PA'
//    ) OR
//    (NF074_Pieces_Actions_POIDS LIKE '%A :%' AND 10 <=2) OR (NF074_Pieces_Actions_POIDS LIKE '%B :%'  AND 10 > 2 AND 10 < 20) OR (NF074_Pieces_Actions_POIDS LIKE '%C :%' AND 10 >= 20)
//    );

    String selBase = "SELECT * FROM `NF074_Pieces_Actions` WHERE ";
    String selDESC = "NF074_Pieces_Actions_DESC LIKE '%${Srv_DbTools.DESC_Lib}%'";
    String selPDT_POIDS_PRS = "(NF074_Pieces_Actions_PDT = '${Srv_DbTools.PDT_Lib}' AND NF074_Pieces_Actions_POIDS = '${Srv_DbTools.POIDS_Lib}' AND NF074_Pieces_Actions_PRS = '${Srv_DbTools.PRS_Lib}')";

    String iPOIDS_Lib = Srv_DbTools.POIDS_Lib.replaceAll(RegExp(r'[^0-9]'), '');
    String selPOIDS = "";
    if (iPOIDS_Lib.trim().isNotEmpty) {
      selPOIDS = "OR (NF074_Pieces_Actions_POIDS LIKE '%A :%' AND ${iPOIDS_Lib} <=2) OR (NF074_Pieces_Actions_POIDS LIKE '%B :%'  AND ${iPOIDS_Lib} > 2 AND ${iPOIDS_Lib} < 20) OR (NF074_Pieces_Actions_POIDS LIKE '%C :%' AND ${iPOIDS_Lib} >= 20)";
    }

    String selTypeVerif = "";
    if (wType.contains("Inst")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Actions_Inst  = 1 ";
    }
    if (wType.contains("VerifAnn")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Actions_VerifAnn  = 1 ";
    }
    if (wType.contains("Rech")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Actions_Rech  = 1 ";
    }
    if (wType.contains("MAA")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Actions_MAA  = 1 ";
    }
    if (wType.contains("Charge")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Actions_Charge  = 1 ";
    }
    if (wType.contains("RA")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Actions_RA  = 1 ";
    }
    if (wType.contains("RES")) {
      if (selTypeVerif.length > 0) selTypeVerif += " OR ";
      selTypeVerif += "NF074_Pieces_Actions_RES  = 1 ";
    }
    String selSQL = "";
    if (selTypeVerif.isEmpty)
      return [];
    else
      selSQL = "$selBase ($selTypeVerif)  AND ( $selDESC OR $selPDT_POIDS_PRS $selPOIDS)  ";

    final List<Map<String, dynamic>> maps = await db.rawQuery(selSQL);
//    print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ getNF074_Pieces_Actions_In ${maps.length} ${selSQL}");

    return List.generate(maps.length, (i) {
      return NF074_Pieces_Actions(
        maps[i]["NF074_Pieces_ActionsId"],
        maps[i]["NF074_Pieces_Actions_DESC"],
        maps[i]["NF074_Pieces_Actions_PDT"],
        maps[i]["NF074_Pieces_Actions_POIDS"],
        maps[i]["NF074_Pieces_Actions_PRS"],
        maps[i]["NF074_Pieces_Actions_Inst"],
        maps[i]["NF074_Pieces_Actions_VerifAnn"],
        maps[i]["NF074_Pieces_Actions_Rech"],
        maps[i]["NF074_Pieces_Actions_MAA"],
        maps[i]["NF074_Pieces_Actions_Charge"],
        maps[i]["NF074_Pieces_Actions_RA"],
        maps[i]["NF074_Pieces_Actions_RES"],
        maps[i]["NF074_Pieces_Actions_CodearticlePD1"],
        maps[i]["NF074_Pieces_Actions_DescriptionPD1"],
        maps[i]["NF074_Pieces_Actions_QtePD1"],
        maps[i]["NF074_Pieces_Actions_CodearticlePD2"],
        maps[i]["NF074_Pieces_Actions_DescriptionPD2"],
        maps[i]["NF074_Pieces_Actions_QtePD2"],
        maps[i]["NF074_Pieces_Actions_CodearticlePD3"],
        maps[i]["NF074_Pieces_Actions_DescriptionPD3"],
        maps[i]["NF074_Pieces_Actions_QtePD3"],
      );
    });
  }

  static Future<List<NF074_Pieces_Actions>> getNF074_Pieces_Actions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("NF074_Pieces_Actions", orderBy: "NF074_Pieces_ActionsId ASC");

    return List.generate(maps.length, (i) {
      return NF074_Pieces_Actions(
        maps[i]["NF074_Pieces_ActionsId"],
        maps[i]["NF074_Pieces_Actions_DESC"],
        maps[i]["NF074_Pieces_Actions_PDT"],
        maps[i]["NF074_Pieces_Actions_POIDS"],
        maps[i]["NF074_Pieces_Actions_PRS"],
        maps[i]["NF074_Pieces_Actions_Inst"],
        maps[i]["NF074_Pieces_Actions_VerifAnn"],
        maps[i]["NF074_Pieces_Actions_Rech"],
        maps[i]["NF074_Pieces_Actions_MAA"],
        maps[i]["NF074_Pieces_Actions_Charge"],
        maps[i]["NF074_Pieces_Actions_RA"],
        maps[i]["NF074_Pieces_Actions_RES"],
        maps[i]["NF074_Pieces_Actions_CodearticlePD1"],
        maps[i]["NF074_Pieces_Actions_DescriptionPD1"],
        maps[i]["NF074_Pieces_Actions_QtePD1"],
        maps[i]["NF074_Pieces_Actions_CodearticlePD2"],
        maps[i]["NF074_Pieces_Actions_DescriptionPD2"],
        maps[i]["NF074_Pieces_Actions_QtePD2"],
        maps[i]["NF074_Pieces_Actions_CodearticlePD3"],
        maps[i]["NF074_Pieces_Actions_DescriptionPD3"],
        maps[i]["NF074_Pieces_Actions_QtePD3"],
      );
    });
  }

  static Future<void> insertNF074_Pieces_Actions(NF074_Pieces_Actions NF074_Pieces_Actions) async {
    final db = await DbTools.database;
    int? repid = await db.insert("NF074_Pieces_Actions", NF074_Pieces_Actions.toMap());
    gLastID = repid!;
  }

  static Future<void> TrunckNF074_Pieces_Actions() async {
    final db = await DbTools.database;
    int? repid = await db.delete("NF074_Pieces_Actions");
  }

  //************************************************
  //******************** C L I E N T S *************
  //************************************************

  static Future<List<Client>> getClients() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("Clients", orderBy: "Client_Nom ASC");

    return List.generate(maps.length, (i) {
      return Client(
          maps[i]["ClientId"],
          maps[i]["Client_CodeGC"],
           maps[i]["Client_CL_Pr"]=="true",
           maps[i]["Client_Famille"],
           maps[i]["Client_Rglt"],
           maps[i]["Client_Depot"],
           maps[i]["Client_PersPhys"]=="true",
           maps[i]["Client_OK_DataPers"]=="true",
           maps[i]["Client_Civilite"],
          maps[i]["Client_Nom"],
           maps[i]["Client_Siret"],
          maps[i]["Client_NAF"],
          maps[i]["Client_TVA"],
           maps[i]["Client_Commercial"],
           maps[i]["Client_Createur"],
          maps[i]["Client_Contrat"]=="true",
           maps[i]["Client_TypeContrat"],
           maps[i]["Client_Ct_Debut"],
           maps[i]["Client_Ct_Fin"],
           maps[i]["Client_Organes"],



      );
    });
  }

  static Future<void> inserClients(Client wClient) async {
    final db = await DbTools.database;
    int? repid = await db.insert("Clients", wClient.toMap());
    gLastID = repid!;
  }


  static Future<void> TrunckClients() async {
    final db = await DbTools.database;
    int? repid = await db.delete("Clients");
  }

  //************************************************
  //******************** G R O U P E S *************
  //************************************************

  static Future<List<Groupe>> getGroupes() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("Groupes", orderBy: "Groupe_Nom ASC");

    return List.generate(maps.length, (i) {
      return Groupe(
          maps[i]["GroupeId"],
          maps[i]["Groupe_ClientId"],
          maps[i]["Groupe_Code"],
          maps[i]["Groupe_Nom"],
          maps[i]["Groupe_Adr1"],
          maps[i]["Groupe_Adr2"],
          maps[i]["Groupe_Adr3"],
          maps[i]["Groupe_Adr4"],
          maps[i]["Groupe_CP"],
          maps[i]["Groupe_Ville"],
          maps[i]["Groupe_Pays"],
          maps[i]["Groupe_Acces"],
        maps[i]["Groupe_Rem"],
          maps[i]["Livr"],
      );
    });
  }

  static Future<void> inserGroupes(Groupe wGroupe) async {
    final db = await DbTools.database;
    int? repid = await db.insert("Groupes", wGroupe.toMap());
    gLastID = repid!;
  }


  static Future<void> TrunckGroupes() async {
    final db = await DbTools.database;
    int? repid = await db.delete("Groupes");
  }


  //************************************************
  //******************** S I T E S *****************
  //************************************************

  static Future<List<Site>> getSites() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("Sites", orderBy: "Site_Nom ASC");

    return List.generate(maps.length, (i) {

      String wSite_Code = "";

      try {
        wSite_Code = maps[i]['Site_Code'];
      } catch (e) {
        print(e);
      }
      return Site(
        maps[i]["SiteId"],
        maps[i]["Site_GroupeId"],
        wSite_Code,
        maps[i]["Site_Depot"],
        maps[i]["Site_Nom"],
        maps[i]["Site_Adr1"],
        maps[i]["Site_Adr2"],
        maps[i]["Site_Adr3"],
        maps[i]["Site_Adr4"],
        maps[i]["Site_CP"],
        maps[i]["Site_Ville"],
        maps[i]["Site_Pays"],
        maps[i]["Site_Acces"],
        maps[i]["Site_RT"],
        maps[i]["Site_APSAD"],
        maps[i]["Site_Rem"],
        maps[i]["Site_ResourceId"],
        maps[i]["Livr"],

      );
    });
  }

  static Future<void> inserSites(Site wSite) async {
    final db = await DbTools.database;
    print("wSite.toMap() ${wSite.toMap()}");
    int? repid = await db.insert("Sites", wSite.toMap());
    gLastID = repid!;
  }


  static Future<void> TrunckSites() async {
    final db = await DbTools.database;
    int? repid = await db.delete("Sites");
  }


  //************************************************
  //******************** Z O N E S *****************
  //************************************************
  
  static Future<List<Zone>> getZones() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("Zones", orderBy: "Zone_Nom ASC");

    return List.generate(maps.length, (i) {

      String wZone_Code = "";

      try {
        wZone_Code = maps[i]['Zone_Code'];
      } catch (e) {
        print(e);
      }
      return Zone(
        maps[i]["ZoneId"],
        maps[i]["Zone_SiteId"],
        maps[i]["Zone_Code"],
        maps[i]["Zone_Depot"],
        maps[i]["Zone_Nom"],
        maps[i]["Zone_Adr1"],
        maps[i]["Zone_Adr2"],
        maps[i]["Zone_Adr3"],
        maps[i]["Zone_Adr4"],
        maps[i]["Zone_CP"],
        maps[i]["Zone_Ville"],
        maps[i]["Zone_Pays"],
        maps[i]["Zone_Acces"],
        maps[i]["Zone_Rem"],
        maps[i]["Livr"],
      );
    });
  }

  static Future<void> inserZones(Zone wZone) async {
    final db = await DbTools.database;
    int? repid = await db.insert("Zones", wZone.toMap());
    gLastID = repid!;
  }


  static Future<void> TrunckZones() async {
    final db = await DbTools.database;
    int? repid = await db.delete("Zones");
  }




  //************************************************
  //******************** INTERVETIONS ***************
  //************************************************

  static Future<List<Intervention>> getInterventions() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("Interventions");

    return List.generate(maps.length, (i) {


      
      return Intervention(
        
        maps[i]["InterventionId"],
        maps[i]["Intervention_ZoneId"],
        maps[i]["Intervention_Date"],
        maps[i]["Intervention_Type"],
        maps[i]["Intervention_Parcs_Type"],
        maps[i]["Intervention_Status"],
        maps[i]["Intervention_Histo_Status"],
        maps[i]["Intervention_Facturation"],
        maps[i]["Intervention_Histo_Facturation"],
        maps[i]["Intervention_Responsable"],
        maps[i]["Intervention_Intervenants"],
        maps[i]["Intervention_Reglementation"],
        maps[i]["Intervention_Signataire_Client"],
        maps[i]["Intervention_Signataire_Tech"],
        maps[i]["Intervention_Signataire_Date"],
        maps[i]["Intervention_Contrat"],
        maps[i]["Intervention_TypeContrat"],
        maps[i]["Intervention_Duree"],
        maps[i]["Intervention_Organes"],
        maps[i]["Intervention_RT"],
        maps[i]["Intervention_APSAD"],
        maps[i]["Intervention_Remarque"],
        maps[i]["Livr"],

      );
    });
  }

  static Future<void> inserInterventions(Intervention wIntervention) async {
    final db = await DbTools.database;
//    print("wIntervention.toMap() ${wIntervention.toMap()}");
    int? repid = await db.insert("Interventions", wIntervention.toMap());
//    print("repid $repid");
    gLastID = repid!;
  }


  static Future<void> TrunckInterventions() async {
    final db = await DbTools.database;
    int? repid = await db.delete("Interventions");
  }


  //************************************************
  //******************** INTERMISSIONS ***************
  //************************************************

  static Future<List<InterMission>> getInterMissions() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("InterMissions");

    return List.generate(maps.length, (i) {
      return InterMission(
        maps[i]["InterMissionId"],
        maps[i]["InterMission_InterventionId"],
        maps[i]["InterMission_Nom"],
        maps[i]["InterMission_Exec"] == "true",
        maps[i]["InterMission_Date"],
        maps[i]["InterMission_Note"],
      );
    });
  }

  static Future<void> inserInterMissions(InterMission wInterMission) async {
    final db = await DbTools.database;
//    print("wInterMission.toMap() ${wInterMission.toMap()}");
    int? repid = await db.insert("InterMissions", wInterMission.toMap());
//    print("repid $repid");
    gLastID = repid!;
  }


  static Future<void> TrunckInterMissions() async {
    final db = await DbTools.database;
    int? repid = await db.delete("InterMissions");
  }

  //************************************************
  //****************** P A R C S  ENT **************
  //************************************************

  static List<Parc_Ent> glfParcs_Ent = [];
  static List<Parc_Ent> lParcs_Ent = [];

  static List<Parc_Ent_Count> lParc_Ent_CountAll = [];
  static List<Parc_Ent_Count> lParc_Ent_CountUsed = [];
  static List<Parc_Ent_Count> lParc_Ent_CountUnUsed = [];

  static List<Parc_Ent_Count> lParc_Ent_CountAff = [];

  static Parc_Ent gParc_Ent = Parc_Ent();

  static Future<void> getParcs_EntCount() async {
    DbTools.lParc_Ent_CountAll.clear();

    int i = 0;
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
        if (element.Param_Param_ID.compareTo("Base") != 0) {
          Parc_Ent_Count wParc_Ent_Count = Parc_Ent_Count();
          wParc_Ent_Count.ParamType = element.Param_Param_ID;
          wParc_Ent_Count.ParamTypeOg = element.Param_Param_Text;
          wParc_Ent_Count.ParamTypeOg_count = 0;
          DbTools.lParc_Ent_CountAll.add(wParc_Ent_Count);
        }
      }
    });

    DbTools.glfParcs_Ent.forEach((element) {
      DbTools.lParc_Ent_CountAll.forEach((elementCount) {
        if (elementCount.ParamType.compareTo(element.Parcs_Type!) == 0) {
          elementCount.ParamTypeOg_count++;
          return;
        }
      });
    });
  }

  static Future<List<Parc_Ent>> getParcs_EntAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Parcs_Ent", orderBy: "Parcs_order ASC");
    print("getParcs_EntAll Parcs_Ent.length ${maps.length}");
    return List.generate(maps.length, (i) {
      return Parc_Ent.fromMap(maps[i]);
    });
  }

  static Future<List<Parc_Ent>> getParcs_Ent(int Parcs_InterventionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Parcs_Ent", orderBy: "Parcs_order ASC", where: '"Parcs_InterventionId" = ${Parcs_InterventionId}', whereArgs: []);
    print("getParcs_Ent Parcs_Ent.length ${maps.length} ${Parcs_InterventionId}");
    return List.generate(maps.length, (i) {
      return Parc_Ent.fromMap(maps[i]);
    });
  }

  static Future<Parc_Ent> getParcs_Ent_Parcs_UUID_Child(String Parcs_UUID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Parcs_Ent", orderBy: "Parcs_order ASC", where: '"Parcs_UUID_Parent" = "${Parcs_UUID}"', whereArgs: []);
    print("getParcs_Ent_Parcs_UUID_Child Parcs_Ent.length ${maps.length} ${Parcs_UUID}");
    if (maps.length > 0)
      return Parc_Ent.fromMap(maps[0]);
    else
      return Parc_Ent.Parc_EntInit(-1, " Parcs_Type", -1);
  }

  static Future<Parc_Ent> getParcs_Ent_Parcs_UUID_Parent(String Parcs_UUID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Parcs_Ent", orderBy: "Parcs_order ASC", where: '"Parcs_UUID_Parent" = "${Parcs_UUID}"', whereArgs: []);
    print("getParcs_Ent_Parcs_UUID_Child Parcs_Ent.length ${maps.length} ${Parcs_UUID}");
    if (maps.length > 0)
      return Parc_Ent.fromMap(maps[0]);
    else
      return Parc_Ent.Parc_EntInit(-1, " Parcs_Type", -1);
  }

  static Future<List<Parc_Ent>> getParcs_Ent_Upd(int Parcs_InterventionId) async {
    final db = await database;
//    final List<Map<String, dynamic>> maps = await db.query("Parcs_Ent", where: '"Parcs_InterventionId" = ${Parcs_InterventionId} AND Parcs_Update = 1', whereArgs: []);
//    final List<Map<String, dynamic>> maps = await db.query("Parcs_Ent", where: '"Parcs_InterventionId" = ${Parcs_InterventionId} AND Parcs_Update >= 0', whereArgs: []);
    final List<Map<String, dynamic>> maps = await db.query("Parcs_Ent", where: '"Parcs_InterventionId" = ${Parcs_InterventionId} ', whereArgs: []);
    print("getParcs_Ent Parcs_Ent.length ${maps.length} ${Parcs_InterventionId}");
    return List.generate(maps.length, (i) {
      return Parc_Ent.fromMap(maps[i]);
    });
  }

  static Future<List<Parc_Ent>> getParcs_EntMoveDown(Parc_Ent parc) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Parcs", orderBy: "Parcs_order ASC", where: '"Parcs_InterventionId" = ? AND Parcs_Type = ? AND Parcs_order >= ?', whereArgs: [parc.Parcs_InterventionId, parc.Parcs_Type, parc.Parcs_order], limit: 2);
    //print("getParcs Parcs.length ${maps.length}");
    return List.generate(maps.length, (i) {
      return Parc_Ent.fromMap(maps[i]);
    });
  }

  static Future<List<Parc_Ent>> getParcs_EntMoveUp(Parc_Ent parc) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Parcs", orderBy: "Parcs_order DESC", where: '"Parcs_InterventionId" = ? AND Parcs_Type = ? AND Parcs_order <= ?', whereArgs: [parc.Parcs_InterventionId, parc.Parcs_Type, parc.Parcs_order], limit: 2);
    //print("getParcs Parcs.length ${maps.length}");
    return List.generate(maps.length, (i) {
      return Parc_Ent.fromMap(maps[i]);
    });
  }

  static Future<void> moveParc_EntNew(int aparcId, int Sens) async {
    Parc_Ent aparSel = Parc_Ent();

    // Recup Sel wParcs_Ent
    var wParcs_Ent = glfParcs_Ent.where((element) => element.ParcsId == aparcId);
    if (wParcs_Ent.length > 0) aparSel = wParcs_Ent.first;

    if (aparSel.Parcs_UUID_Parent!.isNotEmpty) {
      // Recup Sel wParcs_Ent parent si enfant
      var wParcs_Ent = glfParcs_Ent.where((element) => element.Parcs_UUID!.compareTo(aparSel.Parcs_UUID_Parent!) == 0);
      if (wParcs_Ent.length > 0) aparSel = wParcs_Ent.first;
    }

    // creation liste sans enfants
    var wglfParcs_Ent = glfParcs_Ent.where((element) => element.Parcs_UUID_Parent!.isEmpty);

    Parc_Ent parc = Parc_Ent();
    if (Sens == -1) {
      for (int i = 0; i < wglfParcs_Ent.length; i++) {
        Parc_Ent element = wglfParcs_Ent.elementAt(i);
        if (element.Parcs_order! < aparSel.Parcs_order!) parc = element;
      }
    } else
      for (int i = wglfParcs_Ent.length - 1; i >= 0; i--) {
        Parc_Ent element = wglfParcs_Ent.elementAt(i);
        if (element.Parcs_order! > aparSel.Parcs_order!) parc = element;
      }

    int SaveparcParcs_order = parc.Parcs_order!;
    parc.Parcs_order = aparSel.Parcs_order!;
    updateParc_Ent_Ordre(parc);

    aparSel.Parcs_order = SaveparcParcs_order;
    updateParc_Ent_Ordre(aparSel);

    for (int i = wglfParcs_Ent.length - 1; i >= 0; i--) {
      Parc_Ent element = wglfParcs_Ent.elementAt(i);
      Parc_Ent wParc_Ent = await DbTools.getParcs_Ent_Parcs_UUID_Child(element.Parcs_UUID!);
      wParc_Ent.Parcs_order = element.Parcs_order;
      updateParc_Ent_Ordre(wParc_Ent);
    }
    await DbTools.Parc_Ent_GetOrder();
  }

  static Future<void> moveParc_Ent(int aparcId, int Sens) async {
    Parc_Ent aparc = Parc_Ent();

    for (int i = 0; i < glfParcs_Ent.length; i++) {
      Parc_Ent element = glfParcs_Ent[i];
      if (element.ParcsId! == aparcId) {
        aparc = element;
        break;
      }
    }

    Parc_Ent parc = Parc_Ent();
    if (Sens == -1) {
      for (int i = 0; i < glfParcs_Ent.length; i++) {
        Parc_Ent element = glfParcs_Ent[i];
        if (element.Parcs_order! < aparc.Parcs_order!) parc = element;
      }
    } else
      for (int i = glfParcs_Ent.length - 1; i >= 0; i--) {
        Parc_Ent element = glfParcs_Ent[i];
        if (element.Parcs_order! > aparc.Parcs_order!) parc = element;
      }

    //print("moveParc_Ent BASE aparc ${aparc.Parcs_order} parc ${parc.Parcs_order}");

    int SaveparcParcs_order = parc.Parcs_order!;
    parc.Parcs_order = aparc.Parcs_order!;
    updateParc_Ent_Ordre(parc);

    aparc.Parcs_order = SaveparcParcs_order;
    updateParc_Ent_Ordre(aparc);

    // print("moveParc_Ent aparc ${aparc.Parcs_order} parc ${parc.Parcs_order}");
  }

  static Future<void> moveParc_Ent_To_OrderID(int aparcId, int NewOrder) async {
    print("moveParc_Ent_To_OrderID id $aparcId NewOrder ${NewOrder}");
    Parc_Ent aparc = Parc_Ent();
    for (int i = 0; i < glfParcs_Ent.length; i++) {
      Parc_Ent element = glfParcs_Ent[i];
      if (element.ParcsId! == aparcId) {
        aparc = element;
        break;
      }
    }

    Parc_Ent parc = Parc_Ent();
    for (int i = 0; i < glfParcs_Ent.length; i++) {
      Parc_Ent element = glfParcs_Ent[i];
      if (element.Parcs_order! == NewOrder) parc = element;
    }

    print("moveParc_Ent_To_OrderID BASE aparc ${aparc.Parcs_order} parc ${parc.Parcs_order}");

    int SaveparcParcs_order = parc.Parcs_order!;
    parc.Parcs_order = aparc.Parcs_order!;
    updateParc_Ent_Ordre(parc);

    aparc.Parcs_order = SaveparcParcs_order;
    updateParc_Ent_Ordre(aparc);
    print("moveParc_Ent_To_OrderID aparc ${aparc.Parcs_order} parc ${parc.Parcs_order}");
  }

  static int EntSortOrderComparison(Parc_Ent a, Parc_Ent b) {
    int Parc_EntA = a.Parcs_order!;
    int Parc_EntB = b.Parcs_order!;
    if (Parc_EntA < Parc_EntB) {
      return -1;
    } else if (Parc_EntA > Parc_EntB) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future<void> moveParc_EntID2IDUp(int aIdA, int aIdB, int aOrdreA, int aOrdreB) async {
    print("aIdA $aIdA aIdB ${aIdB} aOrdreA $aOrdreA aOrdreB ${aOrdreB}");

    Parc_Ent ParcB = Parc_Ent();
    Parc_Ent ParcA = Parc_Ent();
    int SaveparcParcs_order = 0;

    List<Parc_Ent> wParcs_Ent = [];
    // wParcs_Ent.addAll(lParcs_Ent);
    for (int i = 0; i < lParcs_Ent.length; i++) {
      Parc_Ent wParc_Ent = lParcs_Ent[i];
      if (wParc_Ent.Parcs_UUID_Parent!.isEmpty) {
        wParcs_Ent.add(wParc_Ent);
      }
    }

    wParcs_Ent.sort(EntSortOrderComparison);
    int EltA = 0;
    for (int i = 0; i < wParcs_Ent.length; i++) {
      Parc_Ent element = wParcs_Ent[i];
//      print(">>> element ${element.Parcs_order} $aOrdreA $aOrdreB");
      if (element.Parcs_order! == aOrdreA) {
//        print(">>> SEL A");
        EltA = element.Parcs_order!;
        ParcA = element;
        SaveparcParcs_order = ParcA.Parcs_order!;
      } else if (element.Parcs_order! > aOrdreA && element.Parcs_order! <= aOrdreB) {
//        print(">>> SEL B");
        int EltPO = element.Parcs_order!;
        ParcB = element;
        ParcB.Parcs_order = SaveparcParcs_order;
        await updateParc_Ent_Ordre(ParcB);
//        print("moveParc_Ent from ${EltPO} to ${SaveparcParcs_order}");
        SaveparcParcs_order = EltPO;
      }
    }
    ParcA.Parcs_order = SaveparcParcs_order;
    await updateParc_Ent_Ordre(ParcA);
//    print("moveParc_Ent from ${EltA} to ${SaveparcParcs_order}");

    for (int i = 0; i < wParcs_Ent.length; i++) {
      Parc_Ent wParc_Ent = wParcs_Ent[i];
//      print("wParc_Ent ${wParc_Ent.ParcsId} ${wParc_Ent.Parcs_order} ${wParc_Ent.Parcs_UUID} ${wParc_Ent.Parcs_UUID_Parent}");
      Parc_Ent wParc_EntChild = await getParcs_Ent_Parcs_UUID_Child(wParc_Ent.Parcs_UUID!);
      if (wParc_EntChild.Parcs_order! >= 0)
//        print("wParc_EntChild ${wParc_EntChild.ParcsId} ${wParc_EntChild.Parcs_order} ${wParc_EntChild.Parcs_UUID} ${wParc_EntChild.Parcs_UUID_Parent}");
        wParc_EntChild.Parcs_order = wParc_Ent.Parcs_order;
      await updateParc_Ent_Ordre(wParc_EntChild);
    }

    await DbTools.Parc_Ent_GetOrder();
  }

  static Future<void> moveParc_EntID2IDDown(int aIdA, int aIdB, int aOrdreA, int aOrdreB) async {
    print("moveParc_EntID2IDDown aIdA $aIdA aIdB ${aIdB} aOrdreA $aOrdreA aOrdreB ${aOrdreB}");

    Parc_Ent ParcB = Parc_Ent();
    Parc_Ent ParcA = Parc_Ent();
    int SaveparcParcs_order = 0;

    List<Parc_Ent> wParcs_Ent = [];
//    wParcs_Ent.addAll(lParcs_Ent);
    for (int i = 0; i < lParcs_Ent.length; i++) {
      Parc_Ent wParc_Ent = lParcs_Ent[i];
      if (wParc_Ent.Parcs_UUID_Parent!.isEmpty) {
        wParcs_Ent.add(wParc_Ent);
      }
    }

    wParcs_Ent.sort(EntSortOrderComparison);

    int EltA = 0;

    for (int i = 0; i < wParcs_Ent.length; i++) {
      Parc_Ent element = wParcs_Ent[i];
//      print(">>> element ${element.ParcsId} ${element.Parcs_order}");

      if (element.Parcs_order! == aOrdreA) {
        EltA = element.Parcs_order!;
//        print(">>> SEL A ${EltA}");
      }
      if (element.Parcs_order! >= aOrdreA && element.Parcs_order! < aOrdreB) {
        //      print(">>> SEL B");
        int EltPO = element.Parcs_order! + 1;
        ParcB = element;
        ParcB.Parcs_order = EltPO;
        await updateParc_Ent_Ordre(ParcB);
//        print("moveParc_Ent  from ${EltPO-1} to ${EltPO}");
      } else if (element.Parcs_order! == aOrdreB) {
        // print(">>> SEL C");
        ParcB = element;
        int EltB = ParcB.Parcs_order!;

        ParcB.Parcs_order = EltA;
        await updateParc_Ent_Ordre(ParcB);
        print("moveParc_Ent from ${EltA} to ${EltB}");

        break;
      }
    }

    for (int i = 0; i < wParcs_Ent.length; i++) {
      Parc_Ent wParc_Ent = wParcs_Ent[i];
//      print("wParc_Ent ${wParc_Ent.ParcsId} ${wParc_Ent.Parcs_order} ${wParc_Ent.Parcs_UUID} ${wParc_Ent.Parcs_UUID_Parent}");
      Parc_Ent wParc_EntChild = await getParcs_Ent_Parcs_UUID_Child(wParc_Ent.Parcs_UUID!);
      if (wParc_EntChild.Parcs_order! >= 0)
//        print("wParc_EntChild ${wParc_EntChild.ParcsId} ${wParc_EntChild.Parcs_order} ${wParc_EntChild.Parcs_UUID} ${wParc_EntChild.Parcs_UUID_Parent}");
        wParc_EntChild.Parcs_order = wParc_Ent.Parcs_order;
      await updateParc_Ent_Ordre(wParc_EntChild);
    }

    await DbTools.Parc_Ent_GetOrder();
  }

  static Future<void> updateParc_Ent(Parc_Ent parc) async {
    parc.Devis = "";
    final db = await database;
    String wSlq = "UPDATE Parcs_Ent SET "
            "Parcs_order = ${parc.Parcs_order}, " +
        "Parcs_InterventionId = ${parc.Parcs_InterventionId}, " +
        "Parcs_Type = '${parc.Parcs_Type}', " +
        "Parcs_Date_Rev = '${parc.Parcs_Date_Rev}', " +
        "Parcs_QRCode = '${parc.Parcs_QRCode}', " +
        "Parcs_FREQ_Id = '${parc.Parcs_FREQ_Id}', " +
        "Parcs_FREQ_Label = '${parc.Parcs_FREQ_Label}', " +
        "Parcs_ANN_Id = '${parc.Parcs_ANN_Id}', " +
        "Parcs_ANN_Label = '${parc.Parcs_ANN_Label}', " +
        "Parcs_FAB_Id = '${parc.Parcs_FAB_Id}', " +
        "Parcs_FAB_Label = '${parc.Parcs_FAB_Label}', " +
        "Parcs_NIV_Id = '${parc.Parcs_NIV_Id}', " +
        "Parcs_NIV_Label = '${parc.Parcs_NIV_Label}', " +
        "Parcs_ZNE_Id = '${parc.Parcs_ZNE_Id}', " +
        "Parcs_ZNE_Label = '${parc.Parcs_ZNE_Label}', " +
        "Parcs_EMP_Id = '${parc.Parcs_EMP_Id}', " +
        "Parcs_EMP_Label = '${parc.Parcs_EMP_Label}', " +
        "Parcs_LOT_Id = '${parc.Parcs_LOT_Id}', " +
        "Parcs_LOT_Label = '${parc.Parcs_LOT_Label}', " +
        "Parcs_SERIE_Id = '${parc.Parcs_SERIE_Id}', " +
        "Parcs_SERIE_Label = '${parc.Parcs_SERIE_Label}', " +
        "Parcs_Intervention_Timer = ${parc.Parcs_Intervention_Timer}, " +
        "Parcs_Update = 1, " +
        "Parcs_UUID = '${parc.Parcs_UUID}', " +
        "Parcs_UUID_Parent = '${parc.Parcs_UUID_Parent}', " +
        "Parcs_CodeArticle = '${parc.Parcs_CodeArticle}', " +
        "Parcs_CODF = '${parc.Parcs_CODF}', " +
        "Parcs_NCERT = '${parc.Parcs_NCERT}', " +
        "Parcs_Audit_Note = '${parc.Parcs_Audit_Note}', " +
        "Livr = '${parc.Livr}', " +
        "Devis = '${parc.Devis}', " +
        "Action = '${parc.Action}', " +
        "Parcs_Verif_Note = '${parc.Parcs_Verif_Note}'" +
        " WHERE ParcsId = ${parc.ParcsId}";

    print("updateParc_Ent_Update A ${wSlq}");

    await db.execute(wSlq);
  }

  static Future<void> updateParc_Ent_Timer(int ParcsId, int Parcs_Intervention_Timer) async {
//    print("updateParc_Ent_Update");
    final db = await database;
    String wSlq = "UPDATE Parcs_Ent SET Parcs_Intervention_Timer = ${Parcs_Intervention_Timer}, Parcs_Update = 1 WHERE ParcsId = ${ParcsId}";
    //  print("updateParc_Ent_Update ${wSlq}");
    await db.execute(wSlq);
  }

  static Future<void> updateParc_Ent_Update(int ParcsId, int Parcs_Update) async {
    print("updateParc_Ent_Update");
    final db = await database;
    String wSlq = "UPDATE Parcs_Ent SET Parcs_Update = ${Parcs_Update} WHERE ParcsId = ${ParcsId}";
    print("updateParc_Ent_Update B ${wSlq}");
    await db.execute(wSlq);
  }

  static Future<void> Parc_Ent_GetOrder() async {
    DbTools.glfParcs_Ent.clear();
    List<Parc_Ent> wParcs_Ent = await DbTools.getParcs_Ent(Srv_DbTools.gIntervention.InterventionId!);
//    List<Parc_Ent> wParcs_Ent = await DbTools.getParcs_EntAll();

    int o = 0;

    for (int j = 0; j < wParcs_Ent.length; j++) {
      Parc_Ent wParc_Ent = wParcs_Ent[j];

      if (wParc_Ent.Parcs_UUID_Parent!.length == 0) {
        o++;
      }
      wParc_Ent.Parcs_order = o;
      await DbTools.updateParc_Ent_Ordre(wParc_Ent);
      DbTools.glfParcs_Ent.add(wParc_Ent);
    }
  }

  static Future<void> Parc_Ent_List() async {
    List<Parc_Ent> wParcs_Ent = await DbTools.getParcs_Ent(Srv_DbTools.gIntervention.InterventionId!);
    print("Parc_Ent_List wParcs_Ent lenght ${wParcs_Ent.length}");
    for (int j = 0; j < wParcs_Ent.length; j++) {
//      Parc_Ent wParc_Ent = await DbTools.getParcs_Ent_Parcs_UUID_Child(wParcs_Ent[j].Parcs_UUID!);
      //        print("getParcs_Ent_Parcs_UUID_Child ${wParcs_Ent[j].Parcs_UUID} > ${wParc_Ent.ParcsId} ${wParc_Ent.Parcs_UUID}");
    }
  }

  static Future<void> updateParc_Ent_Ordre(Parc_Ent parc) async {
//    print("updateParc_Ent_Ordre ${parc.Parcs_order}");
    final db = await database;
    String wSlq = "UPDATE Parcs_Ent SET Parcs_order = ${parc.Parcs_order} WHERE ParcsId = ${parc.ParcsId}";
    await db.execute(wSlq);
  }

  static Future<void> updateParc_Ent_Livr(Parc_Ent parc) async {
    print("updateParc_Ent_Livr ${parc.Livr}");
    final db = await database;
    String wSlq = "UPDATE Parcs_Ent SET Livr = '${parc.Livr}' WHERE ParcsId = ${parc.ParcsId}";
    await db.execute(wSlq);
  }

  static Future<void> updateParc_Ent_Action(Parc_Ent parc) async {
    print("updateParc_Ent_Action ${parc.Action}");
    final db = await database;
    String wSlq = "UPDATE Parcs_Ent SET Action = '${parc.Action}' WHERE ParcsId = ${parc.ParcsId}";
    await db.execute(wSlq);
  }

  static Future<void> updateParc_Ent_Hab(Parc_Ent parc) async {
    final db = await database;
    String wSlq = "UPDATE Parcs_Ent SET Parcs_MaintPrev = ${parc.Parcs_MaintPrev}, Parcs_Install = ${parc.Parcs_Install}, Parcs_MaintCorrect = ${parc.Parcs_MaintCorrect} WHERE ParcsId = ${parc.ParcsId}";

    await db.execute(wSlq);
  }

  static Future<void> insertParc_Ent(Parc_Ent Parc_Ent) async {
    final db = await DbTools.database;
    print("insertParc_Ent");
    Parc_Ent.Parcs_Update = 1;

    var uuid = Uuid();
    String uuidv1 = uuid.v1();
    print("insertParc_Ent uuidv1 ${uuidv1}");
    Parc_Ent.Parcs_UUID = uuidv1;

    int? repid = await db.insert("Parcs_Ent", Parc_Ent.toMap());
    print("insertParc_Ent repid ${repid}");

    gLastID = repid!;
  }

  static Future<void> insertParc_Ent_Srv(Parc_Ent_Srv Parc_Ent) async {
    final db = await DbTools.database;
    print("insertParc_Ent");
    gLastID = await db.insert("Parcs_Ent", Parc_Ent.toMap());
    print("insertParc_Ent ${gLastID}");
  }

  static Future<void> deleteParc_Ent(int aID) async {
    final db = await database;
    await db.delete(
      "Parcs_Ent",
      where: "ParcsId = ?",
      whereArgs: [aID],
    );
  }

  static Future<void> deleteParc_EntTrigger(int aID) async {
    final db = await database;

    await db.delete(
      "Parcs_Desc",
      where: "ParcsDesc_ParcsId = ?",
      whereArgs: [aID],
    );

    await db.delete(
      "Parcs_Art",
      where: "ParcsArt_ParcsId = ?",
      whereArgs: [aID],
    );

    await db.delete(
      "Parc_Imgs",
      where: "Parc_Imgs_ParcsId = ?",
      whereArgs: [aID],
    );

    await db.delete(
      "Parcs_Ent",
      where: "ParcsId = ?",
      whereArgs: [aID],
    );
  }

  static Future<void> deleteParc_EntInter(int aParcs_InterventionId) async {
    final db = await database;
    await db.delete(
      "Parcs_Ent",
      where: "Parcs_InterventionId = ?",
      whereArgs: [aParcs_InterventionId],
    );
  }

  //************************************************
  //****************** P A R C S  DESC **************
  //************************************************

  static List<Parc_Desc> glfParcs_Desc = [];
  static List<Parc_Desc> lParcs_Desc = [];

  static Parc_Desc gParc_Desc = Parc_Desc();

  static Future<List<Parc_Desc>> getParcs_DescAll() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("Parcs_Desc", orderBy: "ParcsDescId ASC");
//    print("***********   getParcs_DescAll Parcs_Desc.length ${maps.length}");
    return List.generate(maps.length, (i) {
      return Parc_Desc.fromMap(maps[i]);
    });
  }

  static Future<List<Parc_Desc>> getParcs_DescInter(int Parcs_InterventionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT Parcs_Desc.* FROM Parcs_Desc, Parcs_Ent  WHERE ParcsDesc_ParcsId = ParcsId AND Parcs_InterventionId = ? ', [Parcs_InterventionId]);
//    print("***********>>>   getParcs_DescInter Parcs_Desc.length ${maps.length}");
    return List.generate(maps.length, (i) {
//    print("***********>>>   getParcs_DescInter maps ${maps[i]}");
      return Parc_Desc.fromMap(maps[i]);
    });
  }

  static Future<List<Parc_Desc>> getParcs_Desc(int ParcsDesc_ParcsId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT Parcs_Desc.* FROM Parcs_Desc  WHERE ParcsDesc_ParcsId = ? ', [ParcsDesc_ParcsId]);
    return await List.generate(maps.length, (i) {
      return Parc_Desc.fromMap(maps[i]);
    });
  }

  static Parc_Desc getParcs_Desc_Id_Type(int ParcsDesc_ParcsId, String Param_Saisie_ID) {
//    print("getParcs_Desc_Id_Type");
    Parc_Desc wParc_Desc = Parc_Desc.Parc_DescInit(ParcsDesc_ParcsId, Param_Saisie_ID);
    //  print("getParcs_Desc_Id_Type glfParcs_Desc.length ${glfParcs_Desc.length}");
    glfParcs_Desc.forEach((element) async {
      if (element.ParcsDesc_ParcsId == ParcsDesc_ParcsId) {
        if (element.ParcsDesc_Type!.compareTo(Param_Saisie_ID) == 0) {
          wParc_Desc = element;
          return;
        }
      }
    });
    return wParc_Desc;
  }

  static Future<Parc_Desc> getParcs_Desc_Id_Type_Add(int ParcsDesc_ParcsId, ParcsDesc_Type) async {
    //print("getParcs_Desc_Id_Type_Add ParcsDesc_ParcsId ${ParcsDesc_ParcsId} ParcsDesc_Type ${ParcsDesc_Type}");

    Parc_Desc wParc_Desc = Parc_Desc.Parc_DescInit(ParcsDesc_ParcsId, ParcsDesc_Type);
    for (int i = 0; i < glfParcs_Desc.length; i++) {
      Parc_Desc element = glfParcs_Desc[i];

      //print("getParcs_Desc_Id_Type_Add wParcs_Desc[$i] ${element.toString()}");
      if (element.ParcsDesc_ParcsId == ParcsDesc_ParcsId) {
        if (element.ParcsDesc_Type!.compareTo(ParcsDesc_Type) == 0) {
          wParc_Desc = element;
          break;
        }
      }
    }
    ;

    if (wParc_Desc.ParcsDescId == -1) {
      //print("getParcs_Desc_Id_Type_Add INSERT AAA ${wParc_Desc.ParcsDesc_ParcsId}, '${wParc_Desc.ParcsDesc_Type}',  '${wParc_Desc.ParcsDesc_Id}', '${wParc_Desc.ParcsDesc_Lib} ");
      final db = await database;
      int? repid = await db.insert("Parcs_Desc", wParc_Desc.toMapInsert());
    }
    return wParc_Desc;
  }

  /*static Future<void> setParc_Desc(Parc_Desc parc) async {
    print(">>>> setParc_Desc A ${parc.ParcsDescId} ${parc.ParcsDesc_Lib} ");
    final db = await database;
    int? repid = await db.update(
      "Parcs_Desc",
      parc.toMap(),
      where: "ParcsDescId = ?",
      whereArgs: [parc.ParcsDescId],
    );
  }*/

  static Future<bool> updateParc_Desc(Parc_Desc parc, String InitLib) async {
    print(">>>> updateParc_Desc A ${parc.ParcsDescId} ${parc.ParcsDesc_Lib} ");

    bool isEq = false;
    for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
      var element = DbTools.glfParcs_Desc[i];
      if (element.ParcsDescId! == parc.ParcsDescId!) {
        if (element.ParcsDesc_Lib!.compareTo(InitLib) == 0) {
          isEq = true;
          return isEq;
        }
      }
    }
    ;

    if (isEq) return isEq;

    final db = await database;
    {
      int? repid = await db.update(
        "Parcs_Desc",
        parc.toMap(),
        where: "ParcsDescId = ?",
        whereArgs: [parc.ParcsDescId],
      );
    }

    bool modifDesc = false;
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie wParam_Saisie = Srv_DbTools.ListParam_Saisie[i];
      if (wParam_Saisie.Param_Saisie_ID.compareTo(parc.ParcsDesc_Type!) == 0) {
        modifDesc = true;
      }
    }
    if (!modifDesc) return isEq;

    for (int i = 0; i < DbTools.glfParcs_Desc.length; i++) {
      Parc_Desc element = DbTools.glfParcs_Desc[i];
      if (element.ParcsDescId! > parc.ParcsDescId!) {
        bool isDesc = false;
        for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
          Param_Saisie wParam_Saisie = Srv_DbTools.ListParam_Saisie[i];
          if (wParam_Saisie.Param_Saisie_ID.compareTo(element.ParcsDesc_Type!) == 0) {
            if (wParam_Saisie.Param_Saisie_Type.compareTo("Desc") == 0) isDesc = true;
          }
        }

        if (isDesc) {
          element.ParcsDesc_Lib = "---";
          int? repid = await db.update(
            "Parcs_Desc",
            element.toMap(),
            where: "ParcsDescId = ?",
            whereArgs: [element.ParcsDescId],
          );
//          return false;
//          Srv_DbTools.getParam_Saisie_ParamMem_PRS();
        }
      }
    }
    return false;
  }

  static Future<void> updateParc_Desc_NoRaz(Parc_Desc Parc_Desc, String InitLib) async {
    bool isEq = false;
    glfParcs_Desc.forEach((element) async {
      if (element.ParcsDescId! == Parc_Desc.ParcsDescId!) {
        if (element.ParcsDesc_Lib!.compareTo(InitLib) == 0) {
          isEq = true;
          return;
        }
      }
    });

    if (isEq) {
      print(">>>> A updateParc_Desc_NoRaz isEq");
      return;
    }

    final db = await database;
    int? repid = await db.update(
      "Parcs_Desc",
      Parc_Desc.toMap(),
      where: "ParcsDescId = ?",
      whereArgs: [Parc_Desc.ParcsDescId],
    );
    print(">>>> updateParc_Desc_NoRaz  db.update $repid ${Parc_Desc.ParcsDescId} ${Parc_Desc.ParcsDesc_Id} ${Parc_Desc.ParcsDesc_Lib} ");
  }

  static Future<void> insertParc_Desc(Parc_Desc parc_Desc) async {
    print(">>>> insertParc_Desc A ${parc_Desc.ParcsDescId} ${parc_Desc.ParcsDesc_Lib} ");

    final db = await DbTools.database;
    int? repid = await db.insert("Parcs_Desc", parc_Desc.toMap());
    print("insertParc_Desc ${repid}");
  }

  static Future<void> insertIntoParc_Desc(Parc_Desc aParc_Desc) async {
    print(">>>> insertIntoParc_Desc A ${aParc_Desc.toString()}");
    String wSql = 'INSERT INTO Parcs_Desc(ParcsDescId, ParcsDesc_ParcsId, ParcsDesc_Type, ParcsDesc_Id, ParcsDesc_Lib) VALUES ('
        'NULL ,  ${aParc_Desc.ParcsDesc_ParcsId},'
        '"${aParc_Desc.ParcsDesc_Type}",'
        '"${aParc_Desc.ParcsDesc_Id}",'
        '"${aParc_Desc.ParcsDesc_Lib}")';

    final db = await database;
    await db.execute(wSql);
  }

  static Future<void> insertParc_Desc_Srv(Parc_Desc_Srv parc_Desc) async {
    final db = await DbTools.database;
    int? repid = await db.insert("Parcs_Desc", parc_Desc.toMap());
    print("insertParc_Desc_Srv ${repid}");
  }

  static Future<void> deleteParc_Desc(int aID) async {
    final db = await database;
    await db.delete(
      "Parcs_Desc",
      where: "ParcsDescId = ?",
      whereArgs: [aID],
    );
  }

  //************************************************
  //****************** P A R C S  ART **************
  //************************************************

  static List<Parc_Art> glfParcs_Art = [];
  static List<Parc_Art> lParcs_Art = [];

  static Parc_Art gParc_Art = Parc_Art();

  static Future<List<Parc_Art>> getParcs_ArtAll(int ParcsArt_ParcsId) async {
    List<Parc_Art> Parc_ArtRet = [];
    List<Parc_Art> Parc_ArtTmp = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
    Parc_ArtRet.addAll(Parc_ArtTmp);
    Parc_ArtTmp = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
    Parc_ArtRet.addAll(Parc_ArtTmp);
    Parc_ArtTmp = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "S");
    Parc_ArtRet.addAll(Parc_ArtTmp);
    Parc_ArtTmp = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "ES");
    Parc_ArtRet.addAll(Parc_ArtTmp);
    Parc_ArtTmp = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "Mo");
    Parc_ArtRet.addAll(Parc_ArtTmp);
    Parc_ArtTmp = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "Dn");
    Parc_ArtRet.addAll(Parc_ArtTmp);
    Parc_ArtTmp = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "Serv");
    Parc_ArtRet.addAll(Parc_ArtTmp);

    return Parc_ArtRet;
  }

  static Future<List<Parc_Art>> getParcs_Art(int ParcsArt_ParcsId, String ParcsArt_Type) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT Parcs_Art.* FROM Parcs_Art  WHERE ParcsArt_ParcsId = '${ParcsArt_ParcsId}' and ParcsArt_Type = '${ParcsArt_Type}' ORDER BY ParcsArt_Id");
    return await List.generate(maps.length, (i) {
      return Parc_Art.fromMap(maps[i]);
    });
  }

  static Future<List<Parc_Art>> getParcs_Art_AllType(int ParcsArt_ParcsId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT Parcs_Art.* FROM Parcs_Art  WHERE ParcsArt_ParcsId = "${ParcsArt_ParcsId}" ORDER BY ParcsArt_Id', []);
    return await List.generate(maps.length, (i) {
      return Parc_Art.fromMap(maps[i]);
    });
  }

  static Future<List<Parc_Art>> getParcs_ArtInter(int Parcs_InterventionId) async {
    final db = await database;

    String wTmp = "SELECT Parcs_Art.* FROM Parcs_Art, Parcs_Ent  WHERE ParcsArt_ParcsId = ParcsId AND Parcs_InterventionId = ${Parcs_InterventionId} ORDER BY `Parcs_Art`.`ParcsArt_Id` ASC";

    print("getParcs_ArtInter ${wTmp}");
    List<Map<String, dynamic>> maps = await db.rawQuery(wTmp);

    print("getParcs_ArtInter maps.length ${maps.length}");

    return await List.generate(maps.length, (i) {
      return Parc_Art.fromMap(maps[i]);
    });
  }

  static Future<List<Parc_Art>> getParcs_ArtInterSum(int Parcs_InterventionId) async {
    final db = await database;

    String wTmp = "SELECT Parcs_Art.*, SUM(`ParcsArt_Qte`) as Qte FROM Parcs_Art, Parcs_Ent WHERE ParcsArt_ParcsId = ParcsId AND Parcs_InterventionId = ${Parcs_InterventionId} GROUP BY ParcsArt_Id ORDER BY `Parcs_Art`.`ParcsArt_Id` ASC;";

    print("getParcs_ArtInter ${wTmp}");
    List<Map<String, dynamic>> maps = await db.rawQuery(wTmp);

    print("getParcs_ArtInter maps.length ${maps.length}");

    return await List.generate(maps.length, (i) {
      return Parc_Art.fromMapQte(maps[i]);
    });
  }

  static Future<List<Parc_Art>> getParcs_ArtTout() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT Parcs_Art.* FROM Parcs_Art');
    return await List.generate(maps.length, (i) {
      return Parc_Art.fromMap(maps[i]);
    });
  }

  static Future<void> updateParc_Art(Parc_Art parc) async {
    final db = await database;
    int? repid = await db.update(
      "Parcs_Art",
      parc.toMap(),
      where: "ParcsArtId = ?",
      whereArgs: [parc.ParcsArtId],
    );
    print(">>>> updateParc_Art ${parc.ParcsArtId} ${parc.ParcsArt_Lib} ");

    gParc_Ent.Livr = parc.ParcsArt_Livr!.substring(0, 1).compareTo("R") == 0 ? "R" : "";
    updateParc_Ent_Livr(gParc_Ent);

    Srv_DbTools.gIntervention.Livr = gParc_Ent.Livr;
    Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);

    Srv_DbTools.gGroupe.Livr = gParc_Ent.Livr!;
    Srv_DbTools.setGroupe(Srv_DbTools.gGroupe);

    Srv_DbTools.gSite.Livr = gParc_Ent.Livr!;
    Srv_DbTools.setSite(Srv_DbTools.gSite);

    Srv_DbTools.gClient.Livr = gParc_Ent.Livr!;
    Srv_DbTools.setClient(Srv_DbTools.gClient);
  }

  static Future<void> insertParc_Art(Parc_Art parc_Art) async {
    parc_Art.ParcsArtId = null;
    final db = await DbTools.database;
    int? repid = await db.insert("Parcs_Art", parc_Art.toMap());
//    print(">>>>>>>>>>> db.insert repid ${repid}");

  }

  static Future<void> insertParc_Art_Srv(Parc_Art_Srv parc_Art) async {
    parc_Art.ParcsArtId = null;
    final db = await DbTools.database;
    int? repid = await db.insert("Parcs_Art", parc_Art.toMap());
  }

  static Future<void> deleteParc_Art(int aID) async {
    final db = await database;
    await db.delete(
      "Parcs_Art",
      where: "ParcsArtId = ?",
      whereArgs: [aID],
    );
  }

  static Future<void> deleteParc_Art_ParcsArt_ParcsId(int ParcsArt_ParcsId) async {
    final db = await database;
    String wTmp = "DELETE FROM Parcs_Art WHERE ParcsArt_ParcsId = $ParcsArt_ParcsId AND ParcsArt_lnk = 'L'";
    print("deleteParc_Art_ParcsArt_ParcsId ${wTmp}");
    List<Map<String, dynamic>> maps = await db.rawQuery(wTmp);

  }



  //************************************************
  //******************** P A R C S     I M G *******
  //************************************************

  static List<Parc_Img> glfParc_Imgs = [];
  static List<Parc_Img> lParc_Imgs = [];
  static Parc_Img gParc_Img = Parc_Img();
  static int gParc_Img_Type = 0;

  static Future<List<Parc_Img>> getParc_Imgs(int ParcsId, int Type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("Parc_Imgs", orderBy: "Parc_Imgid ASC", where: 'Parc_Imgs_ParcsId = ${ParcsId} AND Parc_Imgs_Type = ${Type}', whereArgs: []);
    //print("getParcs Parcs.length gParc.ParcsId ${ParcsId} ${maps.length}");
    return List.generate(maps.length, (i) {
      return Parc_Img(
        Parc_Imgid: maps[i]["Parc_Imgid"],
        Parc_Imgs_ParcsId: maps[i]["Parc_Imgs_ParcsId"],
        Parc_Imgs_Path: maps[i]["Parc_Imgs_Path"],
        Parc_Imgs_Data: maps[i]["Parc_Imgs_Data"],
      );
    });
  }

  static Future<void> insertParc_Img(Parc_Img parc_Img) async {
    List<Parc_Img> wParc_Imgs = [];
    wParc_Imgs = await getParc_Imgs(parc_Img.Parc_Imgs_ParcsId!, parc_Img.Parc_Imgs_Type!);

    wParc_Imgs.forEach((element) async {
      print("parc_Img.Parc_Imgid ${parc_Img.Parc_Imgid}");

      if (parc_Img.Parc_Imgid != null) await deleteParc_Img(parc_Img.Parc_Imgid!, parc_Img.Parc_Imgs_Type!);
    });

    final db = await DbTools.database;
    int? repid = await db.insert("Parc_Imgs", parc_Img.toMap());
    print("insertParc_Img ${repid} parc_Img.toMap() ${parc_Img.toMap()}");
  }

  static Future<void> deleteParc_Img(int aID, int Type) async {
    final db = await database;
    await db.delete(
      "Parc_Imgs",
      where: "Parc_Imgid = ${aID} AND Parc_Imgs_Type = ${Type}",
      whereArgs: [],
    );
  }

  //***
  //***
  //***

  static Future<void> AddPiece(int GrdBtnId, String GrdBtn_Label) async {
    bool trv = false;
    int i = 0;
    DbTools.lMaints.forEach((element) {
      if (element.Maints_ArticleId == GrdBtnId && element.Maints_Fact == 1) {
        DbTools.lMaints[i].Maints_Qte = element.Maints_Qte! + 1;
        trv = true;
      }
      i++;
    });
    if (!trv) {
      print("InkWell onTap B $i ${GrdBtnId} ${GrdBtn_Label}");

      Maint wMaint1 = Maint(i, GrdBtnId, GrdBtn_Label, 1, 1, false);
      DbTools.lMaints.add(wMaint1);
    }
  }

  static Future<void> AddPieceInter(int GrdBtnId, String GrdBtn_Label) async {
    bool trv = false;
    int i = 0;
    DbTools.lMaints.forEach((element) {
      if (element.Maints_ArticleId == GrdBtnId) {
        trv = true;
      }
      i++;
    });
    if (!trv) {
      Maint wMaint1 = Maint(i++, GrdBtnId, GrdBtn_Label, 1, 1, false);
      DbTools.lMaints.add(wMaint1);
    }
  }
}

class GrdBtnGrp {
  int? GrdBtnGrpId = 0;
  Color? GrdBtnGrp_Color = Colors.white;
  Color? GrdBtnGrp_ColorSel = Colors.black;
  Color? GrdBtnGrp_Txt_Color = Colors.black;
  Color? GrdBtnGrp_Txt_Colordes = Colors.black;
  Color? GrdBtnGrp_Txt_ColorSel = Colors.white;
  int? GrdBtnGrpType = 0;
  List<int>? GrdBtnGrpSelId = [0];

  GrdBtnGrp({
    this.GrdBtnGrpId,
    this.GrdBtnGrp_Color,
    this.GrdBtnGrp_ColorSel,
    this.GrdBtnGrp_Txt_Color,
    this.GrdBtnGrp_Txt_Colordes,
    this.GrdBtnGrp_Txt_ColorSel,
    this.GrdBtnGrpType,
    this.GrdBtnGrpSelId,
  });
}

class GrdBtn {
  int? GrdBtnId = 0;
  int? GrdBtn_GroupeId = 0;
  String? GrdBtn_Label = "";

  GrdBtn({
    this.GrdBtnId,
    this.GrdBtn_GroupeId,
    this.GrdBtn_Label,
  });
}
