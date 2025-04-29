import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/shared/widgets/custom_app_bar.dart';
import 'package:triggerly/app/shared/widgets/history_drawer.dart';
import 'package:triggerly/app/providers/navigation_provider.dart';

class MainScaffold extends ConsumerWidget {
  final Widget body;

  const MainScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      drawer: const HistoryDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected:
            (index) => ref.read(navigationIndexProvider.notifier).state = index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Charts',
          ),
        ],
      ),
      body: SafeArea(child: Stack(children: [body])),
    );
  }
}
