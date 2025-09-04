import 'package:cargo/utils/constants/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySVG extends StatelessWidget {
  MySVG({this.svgPath, this.size,this.fromFiles = false,this.imagePath});

  String? svgPath;
  final double? size;
  final String? imagePath;
  final bool fromFiles ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConditionalBuilder(
        condition: !fromFiles,
        builder: (context) => ConditionalBuilder(
          condition: svgPath == null && !isSvg(
                  ''//Config.get.logo.dark
          ),
          builder: (context) => Image(
            image: NetworkImage(
              ''//Config.get.logo.dark,
            ),
            height: size ?? 60,
            fit: BoxFit.contain,
          ),
          fallback: (context) => svgPath != null
              ? SvgPicture.asset(svgPath!)
              : SvgPicture.network(
                  '',//Config.get.logo.dark,
            height: size ?? 60,
                ),
        ),
        fallback: (context) =>imagePath ==null ?const SizedBox(): Image.asset(imagePath!,
          height: size ?? 60,
        ),
      ),
    );
  }
}
