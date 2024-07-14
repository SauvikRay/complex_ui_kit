import 'package:flutter/material.dart';

import '../utils/helper_functions.dart';

// OverlayEntry overlayEntry = _insertOverlay(navigatorKey.currentContext!, errrrrr.message);
// navigatorKey.currentState!.overlay!.insert(overlayEntry);
// Future.delayed(const Duration(seconds: 2)).then((value) => overlayEntry.remove());

OverlayEntry insertOverlay(BuildContext context, String message, VoidCallback onTap) {
  RenderBox renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;
  // log('Size: $size'); //MediaQuery.of(context).size;
  return OverlayEntry(
    builder: (context) {
      return Positioned(
          top: MediaQuery.of(context).size.height / 2,
          width: size.width,
          height: 100,
          child: Material(
            color: Colors.red,
            child: Center(
                child: Row(
              children: [Text(message), const Spacer(), IconButton(onPressed: onTap, icon: const Icon(Icons.close))],
            )),
          ));
    },
    maintainState: true,
    // opaque: true,
  );
}

showErrorDialog(String message, VoidCallback onTap) async {
  showGeneralDialog(
    barrierLabel: "Private Request Dialog",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 350),
    context: navigatorKey.currentContext!,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 120, maxWidth: MediaQuery.of(context).size.width - 50),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(message),
                            ),
                            IconButton(onPressed: onTap, icon: const Icon(Icons.close))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
  );
}
