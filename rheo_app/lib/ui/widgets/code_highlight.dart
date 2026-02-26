import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

/// Widget for displaying syntax-highlighted code
class CodeHighlight extends StatelessWidget {
  final String code;
  final String language;

  const CodeHighlight({
    super.key,
    required this.code,
    this.language = 'python',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF282C34), // Atom One Dark background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF404040)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: HighlightView(
          code,
          language: language,
          theme: atomOneDarkTheme,
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}