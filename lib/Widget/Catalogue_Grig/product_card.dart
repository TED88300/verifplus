import 'package:flutter/material.dart';

import 'package:verifplus/Widget/Catalogue_Grig/product.dart';
import 'package:verifplus/Widget/Catalogue_Grig/product_detail.dart';
import 'package:verifplus/Widget/Catalogue_Grig/light_color.dart';
import 'package:verifplus/Widget/Catalogue_Grig/title_text.dart';
import 'package:verifplus/Widget/Catalogue_Grig/extentions.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onSelected;
  const ProductCard({Key? key, required this.product, required this.onSelected}) : super(key: key);

//   @override
//   _ProductCardState createState() => _ProductCardState();
// }

// class _ProductCardState extends State<ProductCard> {
//   Product product;
//   @override
//   void initState() {
//     product = widget.product;
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,###.00');

    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
        ],
      ),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(product.image, height: 200,)
                    ],
                  ),
                ),
                // SizedBox(height: 5),
                TitleText(
                  text: product.name,
                  fontSize:  14,
                  maxLines: 3,
                ),
                TitleText(
                  text: product.category,
                  fontSize:  12,
                  color: LightColor.orange,
                ),
                Row(

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                  product.promo == 0 ?
                  TitleText(
                    text: "${formatter.format(product.price).replaceAll(',', ' ').replaceAll('.', ',')}€",
                    fontSize: 14,
                    color: LightColor.black,
                  )
                      :
                  TitleText(
                    text: "${formatter.format(product.promo).replaceAll(',', ' ').replaceAll('.', ',')}€",
                    fontSize: 14,
                    color: LightColor.red,
                  ),
                    product.promo == 0 ? Container():
                    Container(width: 10,
                    ),
                  product.promo == 0 ? Container():
                  TitleText(
                    text: "${formatter.format(product.price).replaceAll(',', ' ').replaceAll('.', ',')}€",
                    fontSize: 12,
                    color: LightColor.black,
                    lineThrough: true,
                  ),
                ],),






              ],
            ),
            Positioned(
              left: 0,
              top: 0,
              child: IconButton(
                icon: Icon(
                  product.isliked ? Icons.favorite : Icons.favorite_border,
                  color:
                  product.isliked ? LightColor.red : LightColor.iconColor,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ).ripple(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailPage(product : product)));
      }, borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }
}
