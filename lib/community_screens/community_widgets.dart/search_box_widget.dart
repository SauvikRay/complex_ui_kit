import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/common_style.dart';
import '../../utils/helper_functions.dart';

class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget({
    super.key,
    required this.searchController,
    required this.hintText,
  });

  final String hintText;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 35,
        child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(width: 1, color: colorE5E5EA))),
              controller: searchController,
              hintText: hintText, //'Search',
              hintStyle: WidgetStatePropertyAll(body14Normal(darkThemeColor: iconColor(context), lightThemeColor: color363638, context: context)),
              onTapOutside: (event) {
                hideKyBoard(context);
              },
            );
          },
          suggestionsBuilder: (context, controller) {
            return List.generate(5, (index) => Container());
          },
        ));
  }
}
