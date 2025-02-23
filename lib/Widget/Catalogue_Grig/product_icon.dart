import 'package:flutter/material.dart';
import 'package:verifplus/Widget/Catalogue_Grig/category.dart';
import 'package:verifplus/Widget/Catalogue_Grig/light_color.dart';
import 'package:verifplus/Widget/Catalogue_Grig/theme.dart';
import 'package:verifplus/Widget/Catalogue_Grig/title_text.dart';
import 'package:verifplus/Widget/Catalogue_Grig/extentions.dart';

class ProductIcon extends StatelessWidget {
  // final String imagePath;
  // final String text;
  final ValueChanged<Category> onSelected;
  final Category model;
  const ProductIcon({Key? key,required  this.model,required  this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return model.id == null
        ? Container(width: 5)
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Container(
              padding: AppTheme.hPadding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: model.isSelected
                    ? LightColor.background
                    : Colors.transparent,
                border: Border.all(
                  color: model.isSelected ? LightColor.orange : LightColor.grey,
                  width: model.isSelected ? 2 : 1,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: model.isSelected ? const Color(0xfffbf2ef) : Colors.white,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: const Offset(5, 5),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  model.image != null ?
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.asset(model.image),
                  )
                   : const SizedBox(),
                  model.name == null
                      ? Container()
                      : Container(
                          child: TitleText(
                            text: model.name,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        )
                ],
              ),
            ).ripple(
              () {
                onSelected(model);
              },
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          );
  }
}
