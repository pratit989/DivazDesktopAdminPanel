import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

const double _kScrollbarThickness = 6.0;

class MyScrollbar extends StatefulWidget {
  final ScrollableWidgetBuilder builder;
  final ScrollController? scrollController;

  const MyScrollbar({
    Key? key,
    this.scrollController,
    required this.builder,
  })  : super(key: key);

  @override
  _MyScrollbarState createState() => _MyScrollbarState();
}

class _MyScrollbarState extends State<MyScrollbar> {
  late ScrollbarPainter _scrollbarPainter;
  late ScrollController _scrollController;
  Orientation? _orientation;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _updateScrollPainter(_scrollController.position);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollbarPainter = _buildMaterialScrollbarPainter();
  }

  @override
  void dispose() {
    _scrollbarPainter.dispose();
    super.dispose();
  }

  ScrollbarPainter _buildMaterialScrollbarPainter() {
    return ScrollbarPainter(
      color: Theme.of(context).highlightColor.withOpacity(1.0),
      textDirection: Directionality.of(context),
      thickness: _kScrollbarThickness,
      fadeoutOpacityAnimation: const AlwaysStoppedAnimation<double>(1.0),
      padding: MediaQuery.of(context).padding,
    );
  }

  bool _updateScrollPainter(ScrollMetrics position) {
    _scrollbarPainter.update(
      position,
      position.axisDirection,
    );
    return false;
  }

  @override
  void didUpdateWidget(MyScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateScrollPainter(_scrollController.position);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        _orientation ??= orientation;
        if (orientation != _orientation) {
          _orientation = orientation;
          _updateScrollPainter(_scrollController.position);
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _updateScrollPainter(notification.metrics),
          child: CustomPaint(
            painter: _scrollbarPainter,
            child: widget.builder(context, _scrollController),
          ),
        );
      },
    );
  }
}

LinearGradient backgroundGradient = const LinearGradient(colors: [
  Color.fromRGBO(30, 157, 208, 0.8),
  Color.fromRGBO(2, 107, 203, 1),
], begin: Alignment.topLeft);

const loader = Center(child: CircularProgressIndicator(
  color: Colors.blue,
),);

SizedBox logo = SizedBox(
  height: 120,
  width: 120,
  child: MoveWindow(
    child: SizedBox(
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20),
        child: Image.asset('assets/images/divaz_logo.png', fit: BoxFit.cover, cacheWidth: 120, cacheHeight: 120,),
      ),
    ),
  ),
);