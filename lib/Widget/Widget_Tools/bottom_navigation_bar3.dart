import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Catalogue_Grig/light_color.dart';
import 'package:verifplus/Widget/Widget_Tools/bottom_curved_Painter.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class CustomBottomNavigationBar3 extends StatefulWidget {
  final Function(int) onIconPresedCallback;
  CustomBottomNavigationBar3({Key? key, required this.onIconPresedCallback}) : super(key: key);

  @override
  _CustomBottomNavigationBar3State createState() => _CustomBottomNavigationBar3State();
}

class _CustomBottomNavigationBar3State extends State<CustomBottomNavigationBar3> with TickerProviderStateMixin {
  int _selectedIndex = DbTools.gCurrentIndex3;
  late AnimationController _xController;
  late AnimationController _yController;
  @override
  void initState() {
    _xController = AnimationController(vsync: this, animationBehavior: AnimationBehavior.preserve);
    _yController = AnimationController(vsync: this, animationBehavior: AnimationBehavior.preserve);

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _xController.value = _indexToPosition(_selectedIndex) / MediaQuery.of(context).size.width;
    _yController.value = 1.0;
    super.didChangeDependencies();
  }

  double _indexToPosition(int index) {
    const buttonCount = 7.0;
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX + index.toDouble() * buttonsWidth / buttonCount + buttonsWidth / (buttonCount * 2.0);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  Widget _icon(String icon, String lbl, bool isEnable, int index) {
    return Expanded(
        child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      onTap: () {
        _handlePressed(index);
      },
      child: Stack(fit: StackFit.expand, children: <Widget>[
        AnimatedContainer(
            duration: Duration(milliseconds: 500),
            alignment: isEnable ? Alignment.topCenter : Alignment.center,
            child: Column(
              children: [
                AnimatedContainer(
                    padding: isEnable ? const EdgeInsets.fromLTRB(0, 0, 0, 0) : const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    height: isEnable ? 40 : 40,
                    duration: Duration(milliseconds: 300),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: isEnable ? gColors.secondary : gColors.transparent,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: isEnable ? gColors.grey : gColors.transparent,
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                        shape: BoxShape.circle),
                    child: Opacity(
                      opacity: isEnable ? _yController.value : 1,
                      child: ImageIcon(AssetImage("assets/images/$icon"), color: isEnable ? LightColor.background : Theme.of(context).iconTheme.color),
                    )),
                Text("${lbl}"),
              ],
            )),

        !(DbTools.gCountRel > 0 && icon.contains("Rel"))
            ? Container()
            : Positioned(
          top: 0,
          right: 15,
          child:
          Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 5,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: gColors.tks,
              child: Text("${DbTools.gCountRel}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  )),
            ),
          ),
        ),

        !(DbTools.gCountDev > 0 && icon.contains("Dev"))
            ? Container()
            : Positioned(
                top: 0,
                right: 15,
                child:
                Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 10,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: gColors.tks,
                    child: Text("${DbTools.gCountDev}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                ),
              ),
      ]),
    ));
  }

  Widget _buildBackground() {
    final inCurve = ElasticOutCurve(0.38);
    return CustomPaint(
      painter: BackgroundCurvePainter(
        _xController.value * MediaQuery.of(context).size.width,
        Tween<double>(
          begin: Curves.easeInExpo.transform(_yController.value),
          end: inCurve.transform(_yController.value),
        ).transform(_yController.velocity.sign * 0.5 + 0.5),
        gColors.LinearGradient3,
      ),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
/*
    if (width > 400.0) {
      width = 400.0;
    }
*/
    return width;
  }

  void _handlePressed(int index) {
    if (_selectedIndex == index || _xController.isAnimating) return;
    widget.onIconPresedCallback(index);
    setState(() {
      _selectedIndex = index;
    });
    _yController.value = 1.0;
    _xController.animateTo(_indexToPosition(index) / MediaQuery.of(context).size.width, duration: Duration(milliseconds: 620));
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        _yController.animateTo(1.0, duration: Duration(milliseconds: 1200));
      },
    );
    _yController.animateTo(0.0, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final height = 60.0;
    return Container(
      width: appSize.width,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            width: appSize.width,
            height: height - 10,
            child: _buildBackground(),
          ),
          Positioned(
            left: (appSize.width - _getButtonContainerWidth()) / 2,
            top: 0,
            width: _getButtonContainerWidth(),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _icon("Icon_CR.png"     , "CR", _selectedIndex == 0, 0),
                _icon("Icon_Rel.png"    , "Reliq", _selectedIndex == 1, 1),
                _icon("Icon_BL.png"     , "BL", _selectedIndex == 2, 2),
                _icon("Icon_BC.png"     , "BC", _selectedIndex == 3, 3),
                _icon("Icon_Dev.png"    , "Devis", _selectedIndex == 4, 4),
                _icon("Icon_Note.png"   , "Note", _selectedIndex == 5, 5),
                _icon("Icon_Sign.png"   , "Signature", _selectedIndex == 6, 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
