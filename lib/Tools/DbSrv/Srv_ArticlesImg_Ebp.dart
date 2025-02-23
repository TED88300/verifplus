class ArticlesImg_Ebp {
  String ArticlesImg_codeArticle     = "";
  String ArticlesImg_Image  = "";


  static ArticlesImg_EbpInit() {
    return ArticlesImg_Ebp("", "");
  }
  ArticlesImg_Ebp(
      String ArticlesImg_codeArticle,
      String ArticlesImg_Image,


      ) {
    this.ArticlesImg_codeArticle           =  ArticlesImg_codeArticle;
    this.ArticlesImg_Image    =  ArticlesImg_Image;

  }

  factory ArticlesImg_Ebp.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    ArticlesImg_Ebp warticlesimgEbp = ArticlesImg_Ebp(
      json['ArticlesImg_codeArticle'],
      json['ArticlesImg_Image'],

    );

    return warticlesimgEbp;
  }


}