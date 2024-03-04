
class DynamicPopupCallBack extends StatefulWidget {
  const DynamicPopupCallBack({
    super.key,
    required this.subcategoryList,
    required this.context,
    required this.onCallBack,
  });
  final List<Subcategory> subcategoryList;
  final BuildContext context;
  final Function(Map data) onCallBack;

  @override
  State<DynamicPopupCallBack> createState() => _DynamicPopupCallBackState();
}

class _DynamicPopupCallBackState extends State<DynamicPopupCallBack> {
  List<GlobalKey> menuKeys = [];
  @override
  void initState() {
    if (widget.subcategoryList.isNotEmpty) {
      menuKeys = List.generate(widget.subcategoryList.length, (index) => GlobalKey(), growable: true);
    }
    super.initState();
  }

  onTabPressed(Subcategory subcategory, int index) async {
    RenderBox box = menuKeys[index].currentContext?.findRenderObject() as RenderBox;
    // Offset offset = box.localToGlobal(Offset.zero);
    // // double y= offset.dy;
    // // double x=offset.dx;
    // // // log('Render Object Size ${box.size.width} ${box.size.height}');
    // // // log('Position of x : $x and y:$y ');
    //  final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(box.size.bottomLeft(const Offset(0, -5)), ancestor: overlay),
        box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    // log('Relative rect postion : left=${position.left}  top=${position.top} right=${position.right} bottom=${position.bottom}');
    if (subcategory.menuCategory?.isNotEmpty == true) {
      showMenu(
          context: context,
          constraints: const BoxConstraints(maxWidth: double.infinity),
          position: position,
          items: List.generate(subcategory.menuCategory!.length, (mIndex) {
            ChildCategory childCategory = subcategory.menuCategory?[mIndex] ?? ChildCategory();

            return PopupMenuItem(
                height: 30,
                value: childCategory,
                onTap: () {
                  // log('Child Category Tapped ${childCategory.slug}  ${childCategory.id} ${childCategory.name}');
                  widget.onCallBack({
                    'type': 'child-category',
                    'subCategory': {
                      'id': subcategory.subCateId,
                      'slug': subcategory.subCateSlug,
                      'name': subcategory.subCateName,
                    },
                    'id': childCategory.id,
                    'slug': childCategory.slug,
                    'name': childCategory.name,
                  });
                },
                padding: const EdgeInsets.only(left: 5, right: 0),
                child: Text(childCategory.name ?? ''));
          }, growable: true));
    } else {
      // log('Subcategory:  ${subcategory.subCateName} ${subcategory.subCateId}  ${subcategory.subCateSlug}');
      widget.onCallBack({
        ' type': 'subCategory',
        'id': subcategory.subCateId,
        'slug': subcategory.subCateSlug,
        'name': subcategory.subCateName,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness systemBrigthness = MediaQuery.of(context).platformBrightness;
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: systemBrigthness == Brightness.dark ? CupertinoColors.secondarySystemFill : colorF2F0F0,
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 2.0, offset: Offset(0.0, 0.75))]),
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, i) => const SizedBox(
          width: 10,
        ),
        itemCount: widget.subcategoryList.length,
        itemBuilder: (context, index) {
          Subcategory subcategory = widget.subcategoryList[index];
          return CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              onTabPressed(subcategory, index);
            },
            child: Tab(
              key: menuKeys.isEmpty ? GlobalKey() : menuKeys[index],
              child: Row(
                children: [
                  Text(
                    '${subcategory.subCateName}',
                    style: styleF14Normal(context: context, color: Colors.black, systemBrigthness: systemBrigthness),
                  ),
                  if (subcategory.menuCategory!.isNotEmpty)
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: systemBrigthness == Brightness.dark ? colorE5E5EA : Colors.black,
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
