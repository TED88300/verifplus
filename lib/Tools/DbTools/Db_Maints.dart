

class Maint {
  int?    MaintsId = 0;
  int?    Maints_ArticleId = 0;
  String? Maints_Article = "";
  int?    Maints_Qte = 0;
  int?    Maints_Fact = 0;
  bool?    Maints_sel = false;



  Maint(
    this.MaintsId,
    this.Maints_ArticleId,
    this.Maints_Article,
    this.Maints_Qte,
    this.Maints_Fact,
      this.Maints_sel,

  );

  Map<String, dynamic> toMap() {
    return {

      'MaintsId': MaintsId,
      'Maints_ArticleId': Maints_ArticleId,
      'Maints_Article': Maints_Article,
      'Maints_Qte': Maints_Qte,
      'Maints_Fact': Maints_Fact,
      'Maints_sel': Maints_sel,

    };
  }

  @override
  String toString() {
    return 'Maint{MaintsId: $MaintsId}';
  }
}
