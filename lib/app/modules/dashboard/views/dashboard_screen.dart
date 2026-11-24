import '../../../shared/packages.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/common_bottom_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _scrollThreshold = 14.0;

  final _compactTabs = <int>{};
  double _scrollTravel = 0;

  bool _handleScroll(ScrollNotification notification, int tab) {
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return false;

    if (notification is ScrollStartNotification ||
        notification is ScrollEndNotification) {
      _scrollTravel = 0;
      return false;
    }

    if (notification is! ScrollUpdateNotification ||
        notification.dragDetails == null ||
        metrics.maxScrollExtent <= metrics.minScrollExtent) {
      return false;
    }

    final rawDelta = notification.scrollDelta ?? 0;
    final current = metrics.pixels.clamp(
      metrics.minScrollExtent,
      metrics.maxScrollExtent,
    );
    final previous = (metrics.pixels - rawDelta).clamp(
      metrics.minScrollExtent,
      metrics.maxScrollExtent,
    );
    final delta = current - previous;
    if (delta == 0) return false;

    if (_scrollTravel.sign != delta.sign) _scrollTravel = 0;
    _scrollTravel += delta;
    final reachedTop = delta < 0 && current <= metrics.minScrollExtent;
    if (!reachedTop && _scrollTravel.abs() < _scrollThreshold) return false;

    final shouldCompact = delta > 0;
    if (_compactTabs.contains(tab) != shouldCompact) {
      setState(() {
        if (shouldCompact) {
          _compactTabs.add(tab);
        } else {
          _compactTabs.remove(tab);
        }
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        final tab = controller.selectedIndex;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) => _handleScroll(notification, tab),
            child: IndexedStack(index: tab, children: controller.screens),
          ),
          bottomNavigationBar: CommonBottomBar(
            compact: _compactTabs.contains(tab),
          ),
        );
      },
    );
  }
}
