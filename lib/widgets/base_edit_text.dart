import 'package:flutter/cupertino.dart';

import '../utils/colors.dart';
import '../utils/common_style.dart';

// ignore: must_be_immutable
class BaseEditText extends StatefulWidget {
  TextEditingController textController;
  String? placeHolder;
  TextInputType inputType;
  bool isObsecure;
  final VoidCallback? onTap;
  bool readeOnly;

  BaseEditText({
    super.key,
    required this.textController,
    // ignore: avoid_init_to_null
    this.placeHolder = null,
    this.inputType = TextInputType.text,
    this.isObsecure = false,
    this.onTap,
    this.readeOnly = false,
  });

  @override
  State<BaseEditText> createState() => _BaseEditTextState();
}

class _BaseEditTextState extends State<BaseEditText> {
  @override
  Widget build(BuildContext context) {
    Brightness systemBrigthness = MediaQuery.of(context).platformBrightness;
    return CupertinoTextField(
      onTap: widget.onTap,
      controller: widget.textController,
      readOnly: widget.readeOnly,
      padding:const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: color979797),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      placeholder: widget.placeHolder,
      style: styleF14W400(context: context, color: colorBlack22, systemBrigthness: systemBrigthness),
      keyboardType: widget.inputType,
      obscureText: widget.isObsecure,
    );
  }
}
