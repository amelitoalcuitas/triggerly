import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/pages/summary/screens/mobile/summary_page.dart';
import 'package:triggerly/app/shared/layouts/main_scaffold.dart';
import 'package:triggerly/app/pages/charts/screens/mobile/charts_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(children: [const SummaryPage(), const ChartsPage()]);
  }
}
