import 'package:cargo/utils/config/config.dart';
import 'package:cargo/utils/constants/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyContent extends StatelessWidget {
  EmptyContent({
    Key? key,
    this.svgIconPath,
    this.withCircle = false,
    this.hasEmptyHeight=false,
    this.icon = Icons.access_alarm,
    required  this.message ,
  }) : super(key: key);
  final IconData icon;
  final String? svgIconPath;
  final String message;
  final bool hasEmptyHeight ;
  final bool withCircle ;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if(hasEmptyHeight)
            SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
          ConditionalBuilder(
            condition: svgIconPath == null,
            builder: (context) => Icon(icon, size: 50, color: Color(0xffDDDDDD)),
            fallback: (context) => Container(
              padding: EdgeInsets.all(withCircle?(21):0),
              decoration: withCircle ?BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color(0xff46017b).withOpacity(0.07),
              ):BoxDecoration(),
              child: SvgPicture.asset(
                svgIconPath!,
                width: 60,
                height: 60,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: rgboOrHex(Config.get.styling[Config.get.themeMode]!.secondaryVariant)),
          ),
          if(hasEmptyHeight)
            SizedBox(height: MediaQuery.of(context).size.height * 0.15,),       ],
      ),
    );
  }
}
