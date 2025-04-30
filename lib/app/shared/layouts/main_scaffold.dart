import 'package:flutter/material.dart';
import 'package:triggerly/app/shared/widgets/custom_app_bar.dart';
import 'package:triggerly/app/shared/widgets/history_drawer.dart';
import 'package:triggerly/app/shared/widgets/settings_drawer.dart';

class MainScaffold extends StatefulWidget {
  final List<Widget> children;

  const MainScaffold({super.key, required this.children});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorWeight: 2,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
          dividerColor: Theme.of(context).dividerColor.withAlpha(50),
          dividerHeight: 0.5,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: const [
            Tab(icon: Icon(Icons.home_rounded)),
            Tab(icon: Icon(Icons.bar_chart_rounded)),
          ],
        ),
      ),
      drawer: const HistoryDrawer(),
      endDrawer: const SettingsDrawer(),
      body: TabBarView(
        controller: _tabController,
        clipBehavior: Clip.none,
        children: widget.children,
      ),
    );
  }
}
