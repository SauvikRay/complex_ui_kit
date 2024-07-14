import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';
import '../utils/common_style.dart';
import '../utils/size_helper.dart';
import 'icon_widget.dart';

// ignore: must_be_immutable
class BaseActionButton extends StatelessWidget {
  VoidCallback onPress;
  String title;
  Color bgColor;
  String icon;
  Color? textColor;

  BaseActionButton({super.key, required this.title, required this.onPress, this.bgColor = colorF2F2F7, this.textColor = color007AFF, this.icon = ""});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPress();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: color007AFF, // MediaQuery.of(context).platformBrightness == Brightness.dark ? color29292C : bgColor,
            elevation: 0,
            // side: BorderSide(color: MediaQuery.of(context).platformBrightness == Brightness.dark ? colorA0A0A0 : color007AFF),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)))),
        child: Container(
          alignment: Alignment.center,
          padding:const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon.isNotEmpty)
                SvgPicture.asset(
                  icon,
                  semanticsLabel: 'icon',
                ),
              if (icon.isNotEmpty)
                const SizedBox(
                  width: 7.0,
                ),
              Text(
                title,
                style: TextStyle(
                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutLineBaseButton extends StatelessWidget {
  const OutLineBaseButton({super.key, required this.title, required this.onPress, this.textColor = color007AFF, this.icon = ""});
  final VoidCallback onPress;
  final String title;

  final String icon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          onPress();
        },
        style: OutlinedButton.styleFrom(
            // backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? color29292C : bgColor,
            elevation: 0,
            side: const BorderSide(color: color007AFF, width: 1.5),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)))),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon.isNotEmpty)
                SvgPicture.asset(
                  icon,
                  semanticsLabel: 'icon',
                ),
              if (icon.isNotEmpty)
                const SizedBox(
                  width: 7.0,
                ),
              Text(
                title,
                style: TextStyle(
                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BaseIconButton extends StatelessWidget {
  const BaseIconButton({super.key, required this.onPressed, required this.icon, this.height, this.width});
  final void Function()? onPressed;
  final String icon;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        // splashRadius: 15,
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),
        height: height ?? 25,
        minWidth: width ?? 25,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: onPressed,
        child: IconWidget(
          icon: icon,
        ));
  }
}

class OutlineButtonWithIconText extends StatelessWidget {
  const OutlineButtonWithIconText({super.key, required this.onPressed, required this.icon, required this.title});
  final VoidCallback onPressed;
  final String icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(fixedSize: const Size.fromWidth(135), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), side: BorderSide(color: color007AFF, width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            height: 20,
            width: 20,
            colorFilter: const ColorFilter.mode(color007AFF, BlendMode.srcIn),
          ),
          SpaceHepler.horizontalSmall,
          Text(
            title,
            style: body14SemiBold(darkThemeColor: color007AFF, lightThemeColor: color007AFF, context: context),
          )
        ],
      ),
    );
  }
}
