class DCL_Det {
  int? DCL_DetID;
  int? DCL_Det_EntID;
  int? DCL_Det_ParcsArtId;
  int? DCL_Det_Ordre;
  String? DCL_Det_Type;
  // A Article
  // T Texte
  // L Ligne
  // P Saut de Page
  // S Sous Total
  String? DCL_Det_NoArt;
  String? DCL_Det_Lib;
  int? DCL_Det_Qte;
  double? DCL_Det_PU;
  double? DCL_Det_RemP;
  double? DCL_Det_RemMt;
  double? DCL_Det_TVA;


  int? DCL_Det_Livr;
  String? DCL_Det_DateLivr;
  int? DCL_Det_Rel;
  String? DCL_Det_DateRel;
  String? DCL_Det_Statut;
  String? DCL_Det_Note;
  String? DCL_Det_Garantie;

  DCL_Det(
      { this.DCL_DetID,
        this.DCL_Det_EntID,
        this.DCL_Det_ParcsArtId,
        this.DCL_Det_Ordre,
        this.DCL_Det_Type,
        this.DCL_Det_NoArt,
        this.DCL_Det_Lib,
        this.DCL_Det_Qte,
        this.DCL_Det_PU,
        this.DCL_Det_RemP,
        this.DCL_Det_RemMt,
        this.DCL_Det_TVA,
        this.DCL_Det_Livr,
        this.DCL_Det_DateLivr,
        this.DCL_Det_Rel,
        this.DCL_Det_DateRel,
        this.DCL_Det_Statut,
        this.DCL_Det_Note,
        this.DCL_Det_Garantie
      });

static DCL_DetInit() {
  return DCL_Det(
      DCL_DetID : -1,
      DCL_Det_EntID : 0,
      DCL_Det_ParcsArtId : 0,
      DCL_Det_Ordre : 0 ,
      DCL_Det_Type : "",
      DCL_Det_NoArt : "",
      DCL_Det_Lib : "Saisir texte",
      DCL_Det_Qte : 0,
      DCL_Det_PU : 0,
      DCL_Det_RemP : 0,
      DCL_Det_RemMt : 0,
      DCL_Det_TVA : 0,
      DCL_Det_Livr : 0,
      DCL_Det_DateLivr : "",
      DCL_Det_Rel : 0,
      DCL_Det_DateRel : "",
      DCL_Det_Statut : "",
      DCL_Det_Note : "",
      DCL_Det_Garantie : ""
      );
}

DCL_Det.fromJson(Map<String, dynamic> json) {
    DCL_DetID = int.parse(json['DCL_DetID']);
    DCL_Det_EntID = int.parse(json['DCL_Det_EntID']);
    DCL_Det_ParcsArtId = int.parse(json['DCL_Det_ParcsArtId']);
    DCL_Det_Ordre = int.parse(json['DCL_Det_Ordre']);
    DCL_Det_Type = json['DCL_Det_Type'];
    DCL_Det_NoArt = json['DCL_Det_NoArt'];
    DCL_Det_Lib = json['DCL_Det_Lib'];
    DCL_Det_Qte = int.parse(json['DCL_Det_Qte']);
    DCL_Det_PU = double.parse(json['DCL_Det_PU']);
    DCL_Det_RemP = double.parse(json['DCL_Det_Rem_P']);
    DCL_Det_RemMt = double.parse(json['DCL_Det_Rem_Mt']);
    DCL_Det_TVA = double.parse(json['DCL_Det_TVA']);
    DCL_Det_Livr = int.parse(json['DCL_Det_Livr']);
    DCL_Det_DateLivr = json['DCL_Det_DateLivr'];
    DCL_Det_Rel = int.parse(json['DCL_Det_Rel']);
    DCL_Det_DateRel = json['DCL_Det_DateRel'];
    DCL_Det_Statut = json['DCL_Det_Statut'];
    DCL_Det_Note = json['DCL_Det_Note'];
    DCL_Det_Garantie = json['DCL_Det_Garantie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DCL_DetID'] = DCL_DetID;
    data['DCL_Det_EntID'] = DCL_Det_EntID;
    data['DCL_Det_ParcsArtId'] = DCL_Det_ParcsArtId;
    data['DCL_Det_Ordre'] = DCL_Det_Ordre;
    data['DCL_Det_Type'] = DCL_Det_Type;
    data['DCL_Det_NoArt'] = DCL_Det_NoArt;
    data['DCL_Det_Lib'] = DCL_Det_Lib;
    data['DCL_Det_Qte'] = DCL_Det_Qte;
    data['DCL_Det_PU'] = DCL_Det_PU;
    data['DCL_Det_Rem_P'] = DCL_Det_RemP;
    data['DCL_Det_Rem_Mt'] = DCL_Det_RemMt;
    data['DCL_Det_TVA'] = DCL_Det_TVA;
    data['DCL_Det_Livr'] = DCL_Det_Livr;
    data['DCL_Det_DateLivr'] = DCL_Det_DateLivr;
    data['DCL_Det_Rel'] = DCL_Det_Rel;
    data['DCL_Det_DateRel'] = DCL_Det_DateRel;
    data['DCL_Det_Statut'] = DCL_Det_Statut;
    data['DCL_Det_Note'] = DCL_Det_Note;
    data['DCL_Det_Garantie'] = DCL_Det_Garantie;
    return data;
  }

  @override
  String Desc() {
    return "$DCL_Det_Lib";
  }



}
