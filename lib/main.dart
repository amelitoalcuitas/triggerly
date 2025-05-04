import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/app.dart';
import 'package:triggerly/config.dart';

void main() async {
  Gemini.init(apiKey: Config.geminiApiKey);
  runApp(ProviderScope(child: const MyApp()));
}
