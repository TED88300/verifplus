import 'package:flutter/material.dart';
import 'package:verifplus/Widget/Catalogue_Grig/data.dart';
import 'package:verifplus/Widget/Catalogue_Grig/product.dart';
import 'package:verifplus/Widget/Catalogue_Grig/light_color.dart';
import 'package:verifplus/Widget/Catalogue_Grig/theme.dart';
import 'package:verifplus/Widget/Catalogue_Grig/title_text.dart';
import 'package:verifplus/Widget/Catalogue_Grig/extentions.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({Key? key, required  this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool isLiked = false;

  Product product = Product();



   List<String> showThumbnailList = [];

   String wImg = "";

  @override
  void initState() {
    super.initState();

    product = widget.product;

    showThumbnailList.add("assets/Ext_01.png");
    showThumbnailList.add("assets/Ext_01_01.png");
    showThumbnailList.add("assets/Ext_01_02.png");
    showThumbnailList.add("assets/Ext_01_03.png");

    wImg = showThumbnailList[0];
    print("image $wImg");

    controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();

     isLiked = product.isliked;

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          _icon(isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? LightColor.red : LightColor.lightGrey,
              size: 25,
              padding: 12,
              isOutLine: false, onPressed: () {
            setState(() {
              isLiked = !isLiked;
              product.isliked = isLiked;
            });
          }),
        ],
      ),
    );
  }

  Widget _icon(
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
        border: Border.all(
            color: LightColor.iconColor,
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color:
            isOutLine ? Colors.transparent : Theme.of(context).primaryColor,
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    ).ripple(() {
      onPressed();
        }, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }

  Widget _productImage() {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[

          Image.asset(wImg, height: 300,)
        ],
      ),
    );
  }

  Widget _imagesWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              showThumbnailList.map((x) => _thumbnail(x)).toList()),
    );
  }

  Widget _thumbnail(String image) {
    return AnimatedBuilder(
      animation: animation,
      //  builder: null,
      builder: (context, child) => AnimatedOpacity(
        opacity: animation.value,
        duration: const Duration(milliseconds: 500),
        child: child,
      ),
      child:


      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),

          child:Container(
          height: 40,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: LightColor.grey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            // color: Theme.of(context).backgroundColor,
          ),
          child: Image.asset(image),
        ).ripple(() {
            setState(() {

              print("image $image");
              wImg = image;

            });
          }, borderRadius: const BorderRadius.all(Radius.circular(13))),
      ))
    ;
  }

  Widget _detailWidget() {
    var formatter = NumberFormat('###,###.00');

    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.padding.copyWith(bottom: 0),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: const BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(text: product.name, fontSize: 25,maxLines: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[



                              product.promo == 0 ?
                              TitleText(
                                text: "${formatter.format(product.promo).replaceAll(',', ' ').replaceAll('.', ',')}€",
                                fontSize: 25,
                                color: Colors.red,
                              )
                              :
                              TitleText(
                                text: "${formatter.format(product.price).replaceAll(',', ' ').replaceAll('.', ',')}€",
                                fontSize: 25,
                                color: Colors.red,
                              ),
                              product.promo == 0 ? Container():
                              TitleText(
                                text: "${formatter.format(product.price).replaceAll(',', ' ').replaceAll('.', ',')}€",
                                fontSize: 19,
                                color: Colors.red,
                              ),

                            ],
                          ),


                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                _description(),
              ],
            ),
          ),
        );
      },
    );
  }






  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Text(AppData.description),
      ],
    );
  }

  FloatingActionButton _flotingButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: LightColor.orange,
      child: Icon(Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _flotingButton(),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xfffbfbfb),
              Color(0xfff7f7f7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(),
                  _productImage(),
                  _imagesWidget(),
                ],
              ),
              _detailWidget()
            ],
          ),
        ),
      ),
    );
  }
}
