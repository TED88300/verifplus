import 'package:flutter/material.dart';
import 'package:verifplus/Widget/Catalogue_Grig/light_color.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final int maxLines;
  final bool lineThrough;


  const TitleText(
      {Key? key,
        required  this.text,
      this.fontSize = 18,
        this.maxLines = 1,
      this.color = LightColor.titleTextColor,
      this.fontWeight = FontWeight.w800,
      this.lineThrough = false,
      }
      )


      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        style: GoogleFonts.mulish(
            fontSize: fontSize, fontWeight: fontWeight, color: color, decoration: lineThrough ? TextDecoration.lineThrough : null));
  }
}
