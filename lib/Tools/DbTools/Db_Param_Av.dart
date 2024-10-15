class Param_Av {
  String Param_AvID = "";
  String Param_Av_No = "";
  String Param_Av_Det = "";
  String Param_Av_Proc = "";
  String Param_Av_Lnk = "";

  static Param_AvInit() {
    return Param_Av("", "", "", "", "");
  }

  Param_Av(
    String Param_AvID,
    String Param_Av_No,
    String Param_Av_Det,
    String Param_Av_Proc,
    String Param_Av_Lnk,
  ) {
    this.Param_AvID = Param_AvID;
    this.Param_Av_No = Param_Av_No;
    this.Param_Av_Det = Param_Av_Det;
    this.Param_Av_Proc = Param_Av_Proc;
    this.Param_Av_Lnk = Param_Av_Lnk;
  }
}
