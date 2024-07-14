import 'dart:math' as math;


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const double _kLeadingWidth = kToolbarHeight; // So the leading button is square.
const double _kMaxTitleTextScaleFactor = 1.34;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates a Material Design app bar.
  ///
  /// If [elevation] is specified, it must be non-negative.
  ///
  /// Typically used in the [Scaffold.appBar] property.
  CustomAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
  })  : assert(elevation == null || elevation >= 0.0),
        preferredSize = _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height);

  /// Used by [Scaffold] to compute its [AppBar]'s overall height. The returned value is
  /// the same `preferredSize.height` unless [AppBar.toolbarHeight] was null and
  /// `AppBarTheme.of(context).toolbarHeight` is non-null. In that case the
  /// return value is the sum of the theme's toolbar height and the height of
  /// the app bar's [AppBar.bottom] widget.
  static double preferredHeightFor(BuildContext context, Size preferredSize) {
    if (preferredSize is _PreferredAppBarSize && preferredSize.toolbarHeight == null) {
      return (AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight) + (preferredSize.bottomHeight ?? 0);
    }
    return preferredSize.height;
  }

  /// {@template flutter.material.appbar.leading}
  /// A widget to display before the toolbar's [title].
  ///
  /// Typically the [leading] widget is an [Icon] or an [IconButton].
  ///
  /// Becomes the leading component of the [NavigationToolbar] built
  /// by this widget. The [leading] widget's width and height are constrained to
  /// be no bigger than [leadingWidth] and [toolbarHeight] respectively.
  ///
  /// If this is null and [automaticallyImplyLeading] is set to true, the
  /// [AppBar] will imply an appropriate widget. For example, if the [AppBar] is
  /// in a [Scaffold] that also has a [Drawer], the [Scaffold] will fill this
  /// widget with an [IconButton] that opens the drawer (using [Icons.menu]). If
  /// there's no [Drawer] and the parent [Navigator] can go back, the [AppBar]
  /// will use a [BackButton] that calls [Navigator.maybePop].
  /// {@endtemplate}
  ///
  /// {@tool snippet}
  ///
  /// The following code shows how the drawer button could be manually specified
  /// instead of relying on [automaticallyImplyLeading]:
  ///
  /// ```dart
  /// AppBar(
  ///   leading: Builder(
  ///     builder: (BuildContext context) {
  ///       return IconButton(
  ///         icon: const Icon(Icons.menu),
  ///         onPressed: () { Scaffold.of(context).openDrawer(); },
  ///         tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
  ///       );
  ///     },
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// The [Builder] is used in this example to ensure that the `context` refers
  /// to that part of the subtree. That way this code snippet can be used even
  /// inside the very code that is creating the [Scaffold] (in which case,
  /// without the [Builder], the `context` wouldn't be able to see the
  /// [Scaffold], since it would refer to an ancestor of that widget).
  ///
  /// See also:
  ///
  ///  * [Scaffold.appBar], in which an [AppBar] is usually placed.
  ///  * [Scaffold.drawer], in which the [Drawer] is usually placed.
  final Widget? leading;

  /// {@template flutter.material.appbar.automaticallyImplyLeading}
  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [AppBar.leading] is null, automatically try to deduce what the leading
  /// widget should be. If false and [AppBar.leading] is null, leading space is given to [AppBar.title].
  /// If leading widget is not null, this parameter has no effect.
  /// {@endtemplate}
  final bool automaticallyImplyLeading;

  /// {@template flutter.material.appbar.title}
  /// The primary widget displayed in the app bar.
  ///
  /// Becomes the middle component of the [NavigationToolbar] built by this widget.
  ///
  /// Typically a [Text] widget that contains a description of the current
  /// contents of the app.
  /// {@endtemplate}
  ///
  /// The [title]'s width is constrained to fit within the remaining space
  /// between the toolbar's [leading] and [actions] widgets. Its height is
  /// _not_ constrained. The [title] is vertically centered and clipped to fit
  /// within the toolbar, whose height is [toolbarHeight]. Typically this
  /// isn't noticeable because a simple [Text] [title] will fit within the
  /// toolbar by default. On the other hand, it is noticeable when a
  /// widget with an intrinsic height that is greater than [toolbarHeight]
  /// is used as the [title]. For example, when the height of an Image used
  /// as the [title] exceeds [toolbarHeight], it will be centered and
  /// clipped (top and bottom), which may be undesirable. In cases like this
  /// the height of the [title] widget can be constrained. For example:
  ///
  /// ```dart
  /// MaterialApp(
  ///   home: Scaffold(
  ///     appBar: AppBar(
  ///       title: SizedBox(
  ///         height: _myToolbarHeight,
  ///         child: Image.asset(_logoAsset),
  ///       ),
  ///       toolbarHeight: _myToolbarHeight,
  ///     ),
  ///   ),
  /// )
  /// ```
  final Widget? title;

  /// {@template flutter.material.appbar.actions}
  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [IconButton]s representing common operations.
  /// For less common operations, consider using a [PopupMenuButton] as the
  /// last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built
  /// by this widget. The height of each action is constrained to be no bigger
  /// than the [toolbarHeight].
  ///
  /// To avoid having the last action covered by the debug banner, you may want
  /// to set the [MaterialApp.debugShowCheckedModeBanner] to false.
  /// {@endtemplate}
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// Scaffold(
  ///   body: CustomScrollView(
  ///     primary: true,
  ///     slivers: <Widget>[
  ///       SliverAppBar(
  ///         title: const Text('Hello World'),
  ///         actions: <Widget>[
  ///           IconButton(
  ///             icon: const Icon(Icons.shopping_cart),
  ///             tooltip: 'Open shopping cart',
  ///             onPressed: () {
  ///               // handle the press
  ///             },
  ///           ),
  ///         ],
  ///       ),
  ///       // ...rest of body...
  ///     ],
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  final List<Widget>? actions;

  /// {@template flutter.material.appbar.flexibleSpace}
  /// This widget is stacked behind the toolbar and the tab bar. Its height will
  /// be the same as the app bar's overall height.
  ///
  /// A flexible space isn't actually flexible unless the [AppBar]'s container
  /// changes the [AppBar]'s size. A [SliverAppBar] in a [CustomScrollView]
  /// changes the [AppBar]'s height when scrolled.
  ///
  /// Typically a [FlexibleSpaceBar]. See [FlexibleSpaceBar] for details.
  /// {@endtemplate}
  final Widget? flexibleSpace;

  /// {@template flutter.material.appbar.bottom}
  /// This widget appears across the bottom of the app bar.
  ///
  /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can
  /// be used at the bottom of an app bar.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
  final PreferredSizeWidget? bottom;

  /// {@template flutter.material.appbar.elevation}
  /// The z-coordinate at which to place this app bar relative to its parent.
  ///
  /// This property controls the size of the shadow below the app bar if
  /// [shadowColor] is not null.
  ///
  /// If [surfaceTintColor] is not null then it will apply a surface tint overlay
  /// to the background color (see [Material.surfaceTintColor] for more
  /// detail).
  ///
  /// The value must be non-negative.
  ///
  /// If this property is null, then [AppBarTheme.elevation] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the
  /// default value is 4.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [scrolledUnderElevation], which will be used when the app bar has
  ///    something scrolled underneath it.
  ///  * [shadowColor], which is the color of the shadow below the app bar.
  ///  * [surfaceTintColor], which determines the elevation overlay that will
  ///    be applied to the background of the app bar.
  ///  * [shape], which defines the shape of the app bar's [Material] and its
  ///    shadow.
  final double? elevation;

  /// {@template flutter.material.appbar.scrolledUnderElevation}
  /// The elevation that will be used if this app bar has something
  /// scrolled underneath it.
  ///
  /// If non-null then it [AppBarTheme.scrolledUnderElevation] of
  /// [ThemeData.appBarTheme] will be used. If that is also null then [elevation]
  /// will be used.
  ///
  /// The value must be non-negative.
  ///
  /// {@endtemplate}
  ///
  /// See also:
  ///  * [elevation], which will be used if there is no content scrolled under
  ///    the app bar.
  ///  * [shadowColor], which is the color of the shadow below the app bar.
  ///  * [surfaceTintColor], which determines the elevation overlay that will
  ///    be applied to the background of the app bar.
  ///  * [shape], which defines the shape of the app bar's [Material] and its
  ///    shadow.
  final double? scrolledUnderElevation;

  /// A check that specifies which child's [ScrollNotification]s should be
  /// listened to.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.
  final ScrollNotificationPredicate notificationPredicate;

  /// {@template flutter.material.appbar.shadowColor}
  /// The color of the shadow below the app bar.
  ///
  /// If this property is null, then [AppBarTheme.shadowColor] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default value
  /// is fully opaque black.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [elevation], which defines the size of the shadow below the app bar.
  ///  * [shape], which defines the shape of the app bar and its shadow.
  final Color? shadowColor;

  /// {@template flutter.material.appbar.surfaceTintColor}
  /// The color of the surface tint overlay applied to the app bar's
  /// background color to indicate elevation.
  ///
  /// If null no overlay will be applied.
  /// {@endtemplate}
  ///
  /// See also:
  ///   * [Material.surfaceTintColor], which described this feature in more detail.
  final Color? surfaceTintColor;

  /// {@template flutter.material.appbar.shape}
  /// The shape of the app bar's [Material] as well as its shadow.
  ///
  /// If this property is null, then [AppBarTheme.shape] of
  /// [ThemeData.appBarTheme] is used. Both properties default to null.
  /// If both properties are null then the shape of the app bar's [Material]
  /// is just a simple rectangle.
  ///
  /// A shadow is only displayed if the [elevation] is greater than
  /// zero.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [elevation], which defines the size of the shadow below the app bar.
  ///  * [shadowColor], which is the color of the shadow below the app bar.
  final ShapeBorder? shape;

  /// {@template flutter.material.appbar.backgroundColor}
  /// The fill color to use for an app bar's [Material].
  ///
  /// If null, then the [AppBarTheme.backgroundColor] is used. If that value is also
  /// null:
  /// In Material v2 (i.e., when [ThemeData.useMaterial3] is false),
  /// then [AppBar] uses the overall theme's [ColorScheme.primary] if the
  /// overall theme's brightness is [Brightness.light], and [ColorScheme.surface]
  /// if the overall theme's brightness is [Brightness.dark].
  /// In Material v3 (i.e., when [ThemeData.useMaterial3] is true),
  /// then [AppBar] uses the overall theme's [ColorScheme.surface]
  ///
  /// If this color is a [MaterialStateColor] it will be resolved against
  /// [MaterialState.scrolledUnder] when the content of the app's
  /// primary scrollable overlaps the app bar.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [foregroundColor], which specifies the color for icons and text within
  ///    the app bar.
  ///  * [Theme.of], which returns the current overall Material theme as
  ///    a [ThemeData].
  ///  * [ThemeData.colorScheme], the thirteen colors that most Material widget
  ///    default colors are based on.
  ///  * [ColorScheme.brightness], which indicates if the overall [Theme]
  ///    is light or dark.
  final Color? backgroundColor;

  /// {@template flutter.material.appbar.foregroundColor}
  /// The default color for [Text] and [Icon]s within the app bar.
  ///
  /// If null, then [AppBarTheme.foregroundColor] is used. If that
  /// value is also null:
  /// In Material v2 (i.e., when [ThemeData.useMaterial3] is false),
  /// then [AppBar] uses the overall theme's [ColorScheme.onPrimary] if the
  /// overall theme's brightness is [Brightness.light], and [ColorScheme.onSurface]
  /// if the overall theme's brightness is [Brightness.dark].
  /// In Material v3 (i.e., when [ThemeData.useMaterial3] is true),
  /// then [AppBar] uses the overall theme's [ColorScheme.onSurface].
  ///
  /// This color is used to configure [DefaultTextStyle] that contains
  /// the toolbar's children, and the default [IconTheme] widgets that
  /// are created if [iconTheme] and [actionsIconTheme] are null.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [backgroundColor], which specifies the app bar's background color.
  ///  * [Theme.of], which returns the current overall Material theme as
  ///    a [ThemeData].
  ///  * [ThemeData.colorScheme], the thirteen colors that most Material widget
  ///    default colors are based on.
  ///  * [ColorScheme.brightness], which indicates if the overall [Theme]
  ///    is light or dark.
  final Color? foregroundColor;

  /// {@template flutter.material.appbar.iconTheme}
  /// The color, opacity, and size to use for toolbar icons.
  ///
  /// If this property is null, then a copy of [ThemeData.iconTheme]
  /// is used, with the [IconThemeData.color] set to the
  /// app bar's [foregroundColor].
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [actionsIconTheme], which defines the appearance of icons in
  ///    the [actions] list.
  final IconThemeData? iconTheme;

  /// {@template flutter.material.appbar.actionsIconTheme}
  /// The color, opacity, and size to use for the icons that appear in the app
  /// bar's [actions].
  ///
  /// This property should only be used when the [actions] should be
  /// themed differently than the icon that appears in the app bar's [leading]
  /// widget.
  ///
  /// If this property is null, then [AppBarTheme.actionsIconTheme] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then the value of
  /// [iconTheme] is used.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [iconTheme], which defines the appearance of all of the toolbar icons.
  final IconThemeData? actionsIconTheme;

  /// {@template flutter.material.appbar.primary}
  /// Whether this app bar is being displayed at the top of the screen.
  ///
  /// If true, the app bar's toolbar elements and [bottom] widget will be
  /// padded on top by the height of the system status bar. The layout
  /// of the [flexibleSpace] is not affected by the [primary] property.
  /// {@endtemplate}
  final bool primary;

  /// {@template flutter.material.appbar.centerTitle}
  /// Whether the title should be centered.
  ///
  /// If this property is null, then [AppBarTheme.centerTitle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then value is
  /// adapted to the current [TargetPlatform].
  /// {@endtemplate}
  final bool? centerTitle;

  /// {@template flutter.material.appbar.excludeHeaderSemantics}
  /// Whether the title should be wrapped with header [Semantics].
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool excludeHeaderSemantics;

  /// {@template flutter.material.appbar.titleSpacing}
  /// The spacing around [title] content on the horizontal axis. This spacing is
  /// applied even if there is no [leading] content or [actions]. If you want
  /// [title] to take all the space available, set this value to 0.0.
  ///
  /// If this property is null, then [AppBarTheme.titleSpacing] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then the
  /// default value is [NavigationToolbar.kMiddleSpacing].
  /// {@endtemplate}
  final double? titleSpacing;

  /// {@template flutter.material.appbar.toolbarOpacity}
  /// How opaque the toolbar part of the app bar is.
  ///
  /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
  ///
  /// Typically, this value is not changed from its default value (1.0). It is
  /// used by [SliverAppBar] to animate the opacity of the toolbar when the app
  /// bar is scrolled.
  /// {@endtemplate}
  final double toolbarOpacity;

  /// {@template flutter.material.appbar.bottomOpacity}
  /// How opaque the bottom part of the app bar is.
  ///
  /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
  ///
  /// Typically, this value is not changed from its default value (1.0). It is
  /// used by [SliverAppBar] to animate the opacity of the toolbar when the app
  /// bar is scrolled.
  /// {@endtemplate}
  final double bottomOpacity;

  /// {@template flutter.material.appbar.preferredSize}
  /// A size whose height is the sum of [toolbarHeight] and the [bottom] widget's
  /// preferred height.
  ///
  /// [Scaffold] uses this size to set its app bar's height.
  /// {@endtemplate}
  @override
  final Size preferredSize;

  /// {@template flutter.material.appbar.toolbarHeight}
  /// Defines the height of the toolbar component of an [AppBar].
  ///
  /// By default, the value of [toolbarHeight] is [kToolbarHeight].
  /// {@endtemplate}
  final double? toolbarHeight;

  /// {@template flutter.material.appbar.leadingWidth}
  /// Defines the width of [AppBar.leading] widget.
  ///
  /// By default, the value of [AppBar.leadingWidth] is 56.0.
  /// {@endtemplate}
  final double? leadingWidth;

  /// {@template flutter.material.appbar.toolbarTextStyle}
  /// The default text style for the AppBar's [leading], and
  /// [actions] widgets, but not its [title].
  ///
  /// If this property is null, then [AppBarTheme.toolbarTextStyle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default
  /// value is a copy of the overall theme's [TextTheme.bodyMedium]
  /// [TextStyle], with color set to the app bar's [foregroundColor].
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [titleTextStyle], which overrides the default text style for the [title].
  ///  * [DefaultTextStyle], which overrides the default text style for all of the
  ///    widgets in a subtree.
  final TextStyle? toolbarTextStyle;

  /// {@template flutter.material.appbar.titleTextStyle}
  /// The default text style for the AppBar's [title] widget.
  ///
  /// If this property is null, then [AppBarTheme.titleTextStyle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default
  /// value is a copy of the overall theme's [TextTheme.titleLarge]
  /// [TextStyle], with color set to the app bar's [foregroundColor].
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [toolbarTextStyle], which is the default text style for the AppBar's
  ///    [title], [leading], and [actions] widgets, also known as the
  ///    AppBar's "toolbar".
  ///  * [DefaultTextStyle], which overrides the default text style for all of the
  ///    widgets in a subtree.
  final TextStyle? titleTextStyle;

  /// {@template flutter.material.appbar.systemOverlayStyle}
  /// Specifies the style to use for the system overlays (e.g. the status bar on
  /// Android or iOS, the system navigation bar on Android).
  ///
  /// If this property is null, then [AppBarTheme.systemOverlayStyle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, an appropriate
  /// [SystemUiOverlayStyle] is calculated based on the [backgroundColor].
  ///
  /// The AppBar's descendants are built within a
  /// `AnnotatedRegion<SystemUiOverlayStyle>` widget, which causes
  /// [SystemChrome.setSystemUIOverlayStyle] to be called
  /// automatically. Apps should not enclose an AppBar with their
  /// own [AnnotatedRegion].
  /// {@endtemplate}
  //
  /// See also:
  ///
  ///  * [AnnotatedRegion], for placing [SystemUiOverlayStyle] in the layer tree.
  ///  * [SystemChrome.setSystemUIOverlayStyle], the imperative API for setting
  ///    system overlays style.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// {@template flutter.material.appbar.forceMaterialTransparency}
  /// Forces the AppBar's Material widget type to be [MaterialType.transparency]
  /// (instead of Material's default type).
  ///
  /// This will remove the visual display of [backgroundColor] and [elevation],
  /// and affect other characteristics of the AppBar's Material widget.
  ///
  /// Provided for cases where the app bar is to be transparent, and gestures
  /// must pass through the app bar to widgets beneath the app bar (i.e. with
  /// [Scaffold.extendBodyBehindAppBar] set to true).
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool forceMaterialTransparency;

  /// {@macro flutter.material.Material.clipBehavior}
  final Clip? clipBehavior;

  bool _getEffectiveCenterTitle(ThemeData theme) {
    bool platformCenter() {
      switch (theme.platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return false;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return actions == null || actions!.length < 2;
      }
    }

    return centerTitle ?? theme.appBarTheme.centerTitle ?? platformCenter();
  }

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && widget.notificationPredicate(notification)) {
      final bool oldScrolledUnder = _scrolledUnder;
      final ScrollMetrics metrics = notification.metrics;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
          // Scroll view is reversed
          _scrolledUnder = metrics.extentAfter > 0;
          break;
        case AxisDirection.down:
          _scrolledUnder = metrics.extentBefore > 0;
          break;
        case AxisDirection.right:
        case AxisDirection.left:
          // Scrolled under is only supported in the vertical axis, and should
          // not be altered based on horizontal notifications of the same
          // predicate since it could be a 2D scroller.
          break;
      }

      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {
          // React to a change in MaterialState.scrolledUnder
        });
      }
    }
  }

  Color _resolveColor(Set<MaterialState> states, Color? widgetColor, Color? themeColor, Color defaultColor) {
    return MaterialStateProperty.resolveAs<Color?>(widgetColor, states) ?? MaterialStateProperty.resolveAs<Color?>(themeColor, states) ?? MaterialStateProperty.resolveAs<Color>(defaultColor, states);
  }

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness, [Color? backgroundColor]) {
    final SystemUiOverlayStyle style = brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    // For backward compatibility, create an overlay style without system navigation bar settings.
    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarBrightness: style.statusBarBrightness,
      statusBarIconBrightness: style.statusBarIconBrightness,
      systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final IconButtonThemeData iconButtonTheme = IconButtonTheme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final AppBarTheme defaults = theme.useMaterial3 ? _AppBarDefaultsM3(context) : _AppBarDefaultsM2(context);
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    final FlexibleSpaceBarSettings? settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final Set<MaterialState> states = <MaterialState>{
      if (settings?.isScrolledUnder ?? _scrolledUnder) MaterialState.scrolledUnder,
    };

    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    final double toolbarHeight = widget.toolbarHeight ?? appBarTheme.toolbarHeight ?? kToolbarHeight;

    final Color backgroundColor = _resolveColor(
      states,
      widget.backgroundColor,
      appBarTheme.backgroundColor,
      defaults.backgroundColor!,
    );

    final Color scrolledUnderBackground = _resolveColor(
      states,
      widget.backgroundColor,
      appBarTheme.backgroundColor,
      Theme.of(context).colorScheme.surfaceContainer,
    );

    bool getBoolValue(ThemeData theme) {
      switch (theme.platform) {
        case TargetPlatform.android:
          return true;
        case TargetPlatform.fuchsia:
          return true;
        case TargetPlatform.iOS:
          return false;
        case TargetPlatform.linux:
          return true;
        case TargetPlatform.macOS: // TODO: Handle this case.
          return false;
        case TargetPlatform.windows:
          return true;
      }
    }

    final Color effectiveBackgroundColor = states.contains(MaterialState.scrolledUnder) ? scrolledUnderBackground : backgroundColor;

    final Color foregroundColor = widget.foregroundColor ?? appBarTheme.foregroundColor ?? defaults.foregroundColor!;

    final double elevation = widget.elevation ?? appBarTheme.elevation ?? defaults.elevation!;

    final double effectiveElevation =
        states.contains(MaterialState.scrolledUnder) ? widget.scrolledUnderElevation ?? appBarTheme.scrolledUnderElevation ?? defaults.scrolledUnderElevation ?? elevation : elevation;

    IconThemeData overallIconTheme = widget.iconTheme ?? appBarTheme.iconTheme ?? defaults.iconTheme!.copyWith(color: foregroundColor);

    final Color? actionForegroundColor = widget.foregroundColor ?? appBarTheme.foregroundColor;
    IconThemeData actionsIconTheme =
        widget.actionsIconTheme ?? appBarTheme.actionsIconTheme ?? widget.iconTheme ?? appBarTheme.iconTheme ?? defaults.actionsIconTheme?.copyWith(color: actionForegroundColor) ?? overallIconTheme;

    TextStyle? toolbarTextStyle = widget.toolbarTextStyle ?? appBarTheme.toolbarTextStyle ?? defaults.toolbarTextStyle?.copyWith(color: foregroundColor);

    TextStyle? titleTextStyle = widget.titleTextStyle ?? appBarTheme.titleTextStyle ?? defaults.titleTextStyle?.copyWith(color: foregroundColor);

    if (widget.toolbarOpacity != 1.0) {
      final double opacity = const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.toolbarOpacity);
      if (titleTextStyle?.color != null) {
        titleTextStyle = titleTextStyle!.copyWith(color: titleTextStyle.color!.withOpacity(opacity));
      }
      if (toolbarTextStyle?.color != null) {
        toolbarTextStyle = toolbarTextStyle!.copyWith(color: toolbarTextStyle.color!.withOpacity(opacity));
      }
      overallIconTheme = overallIconTheme.copyWith(
        opacity: opacity * (overallIconTheme.opacity ?? 1.0),
      );
      actionsIconTheme = actionsIconTheme.copyWith(
        opacity: opacity * (actionsIconTheme.opacity ?? 1.0),
      );
    }

    Widget? leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (hasDrawer) {
        leading = DrawerButton(
          style: IconButton.styleFrom(iconSize: overallIconTheme.size ?? 24),
        );
      } else if (parentRoute?.impliesAppBarDismissal ?? false) {
        leading = useCloseButton ? const CloseButton() : const BackButton();
      }
    }
    if (leading != null) {
      if (theme.useMaterial3) {
        final IconButtonThemeData effectiveIconButtonTheme;

        // This comparison is to check if there is a custom [overallIconTheme]. If true, it means that no
        // custom [overallIconTheme] is provided, so [iconButtonTheme] is applied. Otherwise, we generate
        // a new [IconButtonThemeData] based on the values from [overallIconTheme]. If [iconButtonTheme] only
        // has null values, the default [overallIconTheme] will be applied below by [IconTheme.merge]
        if (overallIconTheme == defaults.iconTheme) {
          effectiveIconButtonTheme = iconButtonTheme;
        } else {
          // The [IconButton.styleFrom] method is used to generate a correct [overlayColor] based on the [foregroundColor].
          final ButtonStyle leadingIconButtonStyle = IconButton.styleFrom(
            foregroundColor: overallIconTheme.color,
            iconSize: overallIconTheme.size,
          );

          effectiveIconButtonTheme = IconButtonThemeData(
              style: iconButtonTheme.style?.copyWith(
            foregroundColor: leadingIconButtonStyle.foregroundColor,
            overlayColor: leadingIconButtonStyle.overlayColor,
            iconSize: leadingIconButtonStyle.iconSize,
          ));
        }

        leading = IconButtonTheme(
          data: effectiveIconButtonTheme,
          child: leading is IconButton ? Center(child: leading) : leading,
        );

        // Based on the Material Design 3 specs, the leading IconButton should have
        // a size of 48x48, and a highlight size of 40x40. Users can also put other
        // type of widgets on leading with the original config.
        leading = ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: widget.leadingWidth ?? _kLeadingWidth),
          child: leading,
        );
      } else {
        leading = ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: widget.leadingWidth ?? _kLeadingWidth),
          child: leading,
        );
      }
    }

    Widget? title = widget.title;
    if (title != null) {
      title = _AppBarTitleBox(child: title);
      if (!widget.excludeHeaderSemantics) {
        title = Semantics(
          namesRoute: getBoolValue(theme),
          // switch (theme.platform) {

          //   TargetPlatform.android || TargetPlatform.fuchsia || TargetPlatform.linux || TargetPlatform.windows => true,
          //   TargetPlatform.iOS || TargetPlatform.macOS => null,
          // },
          header: true,
          child: title,
        );
      }

      title = DefaultTextStyle(
        style: titleTextStyle!,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: title,
      );

      // Set maximum text scale factor to [_kMaxTitleTextScaleFactor] for the
      // title to keep the visual hierarchy the same even with larger font
      // sizes. To opt out, wrap the [title] widget in a [MediaQuery] widget
      // with a different `TextScaler`.
      title = MediaQuery.withClampedTextScaling(
        maxScaleFactor: _kMaxTitleTextScaleFactor,
        child: title,
      );
    }

    Widget? actions;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      actions = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: theme.useMaterial3 ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
        children: widget.actions!,
      );
    } else if (hasEndDrawer) {
      actions = EndDrawerButton(
        style: IconButton.styleFrom(iconSize: overallIconTheme.size ?? 24),
      );
    }

    // Allow the trailing actions to have their own theme if necessary.
    if (actions != null) {
      final IconButtonThemeData effectiveActionsIconButtonTheme;
      if (actionsIconTheme == defaults.actionsIconTheme) {
        effectiveActionsIconButtonTheme = iconButtonTheme;
      } else {
        final ButtonStyle actionsIconButtonStyle = IconButton.styleFrom(
          foregroundColor: actionsIconTheme.color,
          iconSize: actionsIconTheme.size,
        );

        effectiveActionsIconButtonTheme = IconButtonThemeData(
            style: iconButtonTheme.style?.copyWith(
          foregroundColor: actionsIconButtonStyle.foregroundColor,
          overlayColor: actionsIconButtonStyle.overlayColor,
          iconSize: actionsIconButtonStyle.iconSize,
        ));
      }

      actions = IconButtonTheme(
        data: effectiveActionsIconButtonTheme,
        child: IconTheme.merge(
          data: actionsIconTheme,
          child: actions,
        ),
      );
    }

    final Widget toolbar = NavigationToolbar(
      leading: leading,
      middle: title,
      trailing: actions,
      centerMiddle: widget._getEffectiveCenterTitle(theme),
      middleSpacing: widget.titleSpacing ?? appBarTheme.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
    );

    // If the toolbar is allocated less than toolbarHeight make it
    // appear to scroll upwards within its shrinking container.
    Widget appBar = ClipRect(
      clipBehavior: widget.clipBehavior ?? Clip.hardEdge,
      child: CustomSingleChildLayout(
        delegate: _ToolbarContainerLayout(toolbarHeight),
        child: IconTheme.merge(
          data: overallIconTheme,
          child: DefaultTextStyle(
            style: toolbarTextStyle!,
            child: toolbar,
          ),
        ),
      ),
    );
    if (widget.bottom != null) {
      appBar = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: toolbarHeight),
              child: appBar,
            ),
          ),
          if (widget.bottomOpacity == 1.0)
            widget.bottom!
          else
            Opacity(
              opacity: const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.bottomOpacity),
              child: widget.bottom,
            ),
        ],
      );
    }

    // The padding applies to the toolbar and tabbar, not the flexible space.
    if (widget.primary) {
      appBar = SafeArea(
        bottom: false,
        child: appBar,
      );
    }

    appBar = Align(
      alignment: Alignment.topCenter,
      child: appBar,
    );

    if (widget.flexibleSpace != null) {
      appBar = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Semantics(
            sortKey: const OrdinalSortKey(1.0),
            explicitChildNodes: true,
            child: widget.flexibleSpace,
          ),
          Semantics(
            sortKey: const OrdinalSortKey(0.0),
            explicitChildNodes: true,
            // Creates a material widget to prevent the flexibleSpace from
            // obscuring the ink splashes produced by appBar children.
            child: Material(
              type: MaterialType.transparency,
              child: appBar,
            ),
          ),
        ],
      );
    }

    final SystemUiOverlayStyle overlayStyle = widget.systemOverlayStyle ??
        appBarTheme.systemOverlayStyle ??
        defaults.systemOverlayStyle ??
        _systemOverlayStyleForBrightness(
          ThemeData.estimateBrightnessForColor(effectiveBackgroundColor),
          // Make the status bar transparent for M3 so the elevation overlay
          // color is picked up by the statusbar.
          theme.useMaterial3 ? const Color(0x00000000) : null,
        );

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          color: theme.useMaterial3 ? effectiveBackgroundColor : backgroundColor,
          elevation: effectiveElevation,
          type: widget.forceMaterialTransparency ? MaterialType.transparency : MaterialType.canvas,
          shadowColor: widget.shadowColor ?? appBarTheme.shadowColor ?? defaults.shadowColor,
          surfaceTintColor: widget.surfaceTintColor ??
              appBarTheme.surfaceTintColor
              // M3 `defaults.surfaceTint` is Colors.transparent now. It is not used
              // here because otherwise, it will cause breaking change for
              // `scrolledUnderElevation`.
              ??
              (theme.useMaterial3 ? theme.colorScheme.surfaceTint : null),
          shape: widget.shape ?? appBarTheme.shape ?? defaults.shape,
          child: Semantics(
            explicitChildNodes: true,
            child: appBar,
          ),
        ),
      ),
    );
  }
}

// Hand coded defaults based on Material Design 2.
class _AppBarDefaultsM2 extends AppBarTheme {
  _AppBarDefaultsM2(this.context)
      : super(
          elevation: 4.0,
          shadowColor: const Color(0xFF000000),
          titleSpacing: NavigationToolbar.kMiddleSpacing,
          toolbarHeight: kToolbarHeight,
        );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  Color? get backgroundColor => _colors.brightness == Brightness.dark ? _colors.surface : _colors.primary;

  @override
  Color? get foregroundColor => _colors.brightness == Brightness.dark ? _colors.onSurface : _colors.onPrimary;

  @override
  IconThemeData? get iconTheme => _theme.iconTheme;

  @override
  TextStyle? get toolbarTextStyle => _theme.textTheme.bodyMedium;

  @override
  TextStyle? get titleTextStyle => _theme.textTheme.titleLarge;
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight) : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class _AppBarDefaultsM3 extends AppBarTheme {
  _AppBarDefaultsM3(this.context)
      : super(
          elevation: 0.0,
          scrolledUnderElevation: 3.0,
          titleSpacing: NavigationToolbar.kMiddleSpacing,
          toolbarHeight: 64.0,
        );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  Color? get backgroundColor => _colors.surface;

  @override
  Color? get foregroundColor => _colors.onSurface;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  IconThemeData? get iconTheme => IconThemeData(
        color: _colors.onSurface,
        size: 24.0,
      );

  @override
  IconThemeData? get actionsIconTheme => IconThemeData(
        color: _colors.onSurfaceVariant,
        size: 24.0,
      );

  @override
  TextStyle? get toolbarTextStyle => _textTheme.bodyMedium;

  @override
  TextStyle? get titleTextStyle => _textTheme.titleLarge;
}

class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
  const _ToolbarContainerLayout(this.toolbarHeight);

  final double toolbarHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.tighten(height: toolbarHeight);
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, toolbarHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height);
  }

  @override
  bool shouldRelayout(_ToolbarContainerLayout oldDelegate) => toolbarHeight != oldDelegate.toolbarHeight;
}

// Layout the AppBar's title with unconstrained height, vertically
// center it within its (NavigationToolbar) parent, and allow the
// parent to constrain the title's actual height.
class _AppBarTitleBox extends SingleChildRenderObjectWidget {
  const _AppBarTitleBox({required Widget super.child});

  @override
  _RenderAppBarTitleBox createRenderObject(BuildContext context) {
    return _RenderAppBarTitleBox(
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderAppBarTitleBox renderObject) {
    renderObject.textDirection = Directionality.of(context);
  }
}

class _RenderAppBarTitleBox extends RenderAligningShiftedBox {
  _RenderAppBarTitleBox({
    super.textDirection,
  }) : super(alignment: Alignment.center);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final BoxConstraints innerConstraints = constraints.copyWith(maxHeight: double.infinity);
    final Size childSize = child!.getDryLayout(innerConstraints);
    return constraints.constrain(childSize);
  }

  @override
  void performLayout() {
    final BoxConstraints innerConstraints = constraints.copyWith(maxHeight: double.infinity);
    child!.layout(innerConstraints, parentUsesSize: true);
    size = constraints.constrain(child!.size);
    alignChild();
  }
}
