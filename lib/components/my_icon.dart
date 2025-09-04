import 'package:cargo/utils/constants/constant_keys.dart';
import 'package:cargo/utils/constants/constants.dart';
import 'package:cargo/utils/constants/fa_mapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyIcon extends StatelessWidget {
  final String icon;
  final Color? color;
  final double? size;

  const MyIcon({
    Key? key,
    required  this.icon,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stringNotNullOrEmpty(icon) == false) {
      return SizedBox();
    }
    return icon.startsWith('fa')
        ? FaIcon(
            faMap[icon],
            color: color,
            size: size,
          )
        : Icon(
            IconData(int.parse((icon)), fontFamily: ICON_FAMILY),
            color: color,
            size: size,
          );
  }
}
