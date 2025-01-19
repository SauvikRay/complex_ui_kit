import 'package:flutter/material.dart';

class CustomEndDrawer extends StatelessWidget {
  const CustomEndDrawer({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 80),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerTileButton extends StatelessWidget {
  const DrawerTileButton({super.key, required this.onPressed, required this.buttonText, this.icon});
  final void Function()? onPressed;
  final String buttonText;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        children: [
          Text(buttonText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              )),
          Spacer(),
          icon ??
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blueAccent,
                size: 20,
              )
        ],
      ),
    );
  }
}
