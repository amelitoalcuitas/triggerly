import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/app.dart';

const apiKey = 'AIzaSyCBIbbab05BF-zE2PvEVgBQrEqQvtNKHnM';

void main() async {
  Gemini.init(apiKey: apiKey);
  runApp(ProviderScope(child: const MyApp()));
}
