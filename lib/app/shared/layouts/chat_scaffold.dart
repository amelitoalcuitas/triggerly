import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/shared/widgets/chat_app_bar.dart';

class ChatScaffold extends ConsumerWidget {
  final Widget body;

  const ChatScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const ChatAppBar(),
      body: SafeArea(child: Stack(children: [body])),
    );
  }
}
