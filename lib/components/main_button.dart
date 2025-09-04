import 'package:cargo/utils/constants/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double?borderRadius;
  final double? horizontalPadding;
  final bool isFullWidth;
  final bool hasIcon;
  final bool isLoading;
  final IconData? icon;
  final Color color;
  final Color? borderColor;
  final Color textColor;

  MainButton({
    required  this.onPressed,
    required  this.text,
    required  this.color,
    this.horizontalPadding,
    this.borderRadius,
    this.isLoading =false,
    this.icon,
    this.hasIcon=false,
    this.isFullWidth = false,
    this.borderColor,
    required  this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ?double.infinity: null,
      child: MaterialButton(
        onPressed: onPressed,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        color: MaterialStateColor.resolveWith((states) => color),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: borderColor != null ? BorderSide(color: borderColor!,width: borderRadius??0) : BorderSide.none,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: toPx(10),horizontal: horizontalPadding??0),
          child: ConditionalBuilder(
            condition: isLoading== false,
            builder: (context) =>  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(hasIcon ==true)
                  SizedBox(width: MediaQuery.of(context).size.width*(4.5/100),),
                if(hasIcon ==true)
                Icon(icon,color: textColor,size: 22,),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if(hasIcon ==true)
                SizedBox(width: 22+MediaQuery.of(context).size.width*(4.5/100),),
              ],
            ),
            fallback: (context) => Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
