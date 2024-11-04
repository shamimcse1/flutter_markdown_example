import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyWidget(),
    );
  }
}

const String _markdownData = """
## Main
Formatted Dart code looks really pretty too:

```dart
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Markdown(data: markdownData),
    ),
  ));
}
""";

class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return Scaffold(
      body: SafeArea(
        child: Markdown(
          controller: controller,
          selectable: true,
          data: _markdownData,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            code: TextStyle(
              fontSize: 14.0,
              fontFamily: 'monospace',
              color: Colors.black87,
            ),
            codeblockPadding: EdgeInsets.all(12.0),
            codeblockDecoration: BoxDecoration(
              color: Color(0xFFF5F5F5), // Light gray background
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
              border: Border.all(
                color: Color(0xFFE0E0E0), // Border color
              ),
            ),
            h2: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            p: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
          builders: {
            'code': CustomInlineCodeBuilder(), // For inline code
            'codeBlock': CustomCodeBuilder(), // For code blocks
          },
        ),
      ),
    );
  }
}


class CustomCodeBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: SelectableText(
        text.text,
        style: TextStyle(
          fontSize: 14.0,
          fontFamily: 'monospace',
          color: Colors.black87,
        ),
      ),
    );
  }
}
class CustomInlineCodeBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Color(0xFF2E2E2E), // Dark background
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: SelectableText(
        text.text,
        style: TextStyle(
          fontSize: 14.0,
          fontFamily: 'monospace',
          color: Colors.white, // Light text color
        ),
      ),
    );
  }
}