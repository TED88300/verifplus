import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:verifplus/Widget/Catalogue_Grig/data.dart';
import 'package:verifplus/Widget/Catalogue_Grig/product.dart';
import 'package:verifplus/Widget/Catalogue_Grig/light_color.dart';
import 'package:verifplus/Widget/Catalogue_Grig/theme.dart';
import 'package:verifplus/Widget/Catalogue_Grig/product_card.dart';
import 'package:verifplus/Widget/Catalogue_Grig/product_icon.dart';
import 'package:verifplus/Widget/Catalogue_Grig/extentions.dart';

class Catalogue_Grid extends StatefulWidget {
  @override
  _Catalogue_GridState createState() => _Catalogue_GridState();
}

class _Catalogue_GridState extends State<Catalogue_Grid> {
  String wSelCat = AppData.categoryList[0].name;
  String wSearch = "";
  List<Product> wproductList = [];
  final Search_TextController = TextEditingController();
  final ctrlSearch = FocusNode();

  bool isLiked = false;

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(13)), color: Theme.of(context).primaryColor, boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  /*
  *
*/

  Widget _categoryWidget() {
    return Row(
      children: [
        Container(

          width: AppTheme.fullWidth(context),
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: AppData.categoryList
                .map(
                  (category) => ProductIcon(
                    model: category,
                    onSelected: (model) {
                      setState(() {
                        AppData.categoryList.forEach((item) {
                          item.isSelected = false;
                        });
                        model.isSelected = true;
                        wSelCat = model.name;
                        Search_TextController.text = "";
                        ctrlSearch.unfocus();
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _iconLike(
    IconData icon, {
    Color color = LightColor.iconColor,
    double size = 20,
    double padding = 10,
    bool isOutLine = false,
    required Function onPressed,
  }) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(color: LightColor.iconColor, style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color: isOutLine ? Colors.transparent : Theme.of(context).primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0xfff8f8f8), blurRadius: 5, spreadRadius: 10, offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    ).ripple(() {
      if (onPressed != null) {
        onPressed();
      }
    }, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _productWidget() {
    List<Product> wproductList = AppData.productList.where((o) => o.category.compareTo(wSelCat) == 0).toList();

    if (isLiked) {
      wproductList = wproductList.where((o) => o.isliked == true).toList();
    }

    if (Search_TextController.text.isNotEmpty) {
      wproductList = wproductList.where((o) => o.name.toLowerCase().contains(wSearch.toLowerCase())).toList();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: MediaQuery.of(context).size.height - 300,

      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1 / 2, mainAxisSpacing: 10, crossAxisSpacing: 20),
        padding: EdgeInsets.only(left: 20),
        scrollDirection: Axis.vertical,
        children: wproductList
            .map(
              (product) => ProductCard(
                product: product,
                onSelected: (model) {
                  setState(() {
                    AppData.productList.forEach((item) {
                      item.isSelected = false;
                    });
                    model.isSelected = true;
                    wSelCat = model.name;
                    wSearch = "";
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: LightColor.lightGrey.withAlpha(100), borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                controller: Search_TextController,
                focusNode: ctrlSearch,
                decoration: InputDecoration(border: InputBorder.none, hintText: "Search Products", hintStyle: TextStyle(fontSize: 12), contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5), prefixIcon: Icon(Icons.search, color: Colors.black54)),
                onChanged: (String value) async {
                  wSearch = value;
                  setState(() {});
                },
              ),
            ),
          ),
          _iconLike(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? LightColor.red : LightColor.lightGrey, size: 25, padding: 0, isOutLine: true, onPressed: () {
            setState(() {
              isLiked = !isLiked;
            });
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xfff0f0f0),
            Color(0xfff7f7f7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      height: MediaQuery.of(context).size.height ,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _search(),
            _categoryWidget(),
            _productWidget(),
          ],
        ),
      ),
    );
  }
}
