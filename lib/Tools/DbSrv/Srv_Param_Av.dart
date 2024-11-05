class SrvParam_Av {
  String? Param_AvID    = "";
  String? Param_Av_No  = "";
  String? Param_Av_Det  = "";
  String? Param_Av_Proc = "";
  String? Param_Av_Lnk  = "";

  SrvParam_Av(
      {
        this.Param_AvID,
        this.Param_Av_No,
        this.Param_Av_Det,
        this.Param_Av_Proc,
        this.Param_Av_Lnk,
      });

  SrvParam_Av.fromJson(Map<String, dynamic> json) {
    Param_AvID =    json['Param_AvID'];
    Param_Av_No=   json['Param_Av_No'];
    Param_Av_Det=   json['Param_Av_Det'];
    Param_Av_Proc = json['Param_Av_Proc'];
    Param_Av_Lnk=   json['Param_Av_Lnk'];
  }

  Map<String, dynamic> toMap() {
    return {
      'Param_AvID': Param_AvID,
      'Param_Av_No': Param_Av_No,
      'Param_Av_Det': Param_Av_Det,
      'Param_Av_Proc': Param_Av_Proc,
      'Param_Av_Lnk': Param_Av_Lnk,


    };
  }


}

