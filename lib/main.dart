import 'dart:convert';
import 'package:http/http.dart' as http;
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
      home: CodeCompilerApp(),
    );
  }
}

class CodeCompilerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Compiler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CompilerHomePage(),
    );
  }
}

class CompilerHomePage extends StatefulWidget {
  @override
  _CompilerHomePageState createState() => _CompilerHomePageState();
}

class _CompilerHomePageState extends State<CompilerHomePage> {
  String _code = '';
  String _language = 'python3'; // default language
  String _output = '';
  bool _isLoading = false;

  // Example languages supported by Judge0
  final List<String> _languages = ['python3', 'javascript', 'cpp', 'java'];


  Future<void> executeCode() async {
    // Define the API URL
    final url = Uri.parse('https://api.codex.jaagrav.in');

    // Set the headers
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Define the body data
    final body = {
      'code': '''
public class Main {
  public static void main(String[] args) {
    System.out.print("Enter your value: ");
    int val = Integer.parseInt("7") + 5;
    System.out.println(val);
  }
}
''',
      'language': 'java',
    };

    try {
      // Make the POST request
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Decode the response body
        final responseData = jsonDecode(response.body);
        print('Output: ${responseData['output']}');
        print('Error: ${responseData['error']}');
      } else {
        print('Failed to execute code. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Compiler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            TextField(
              maxLines: 10,
              onChanged: (value) => _code = value,
              decoration: const InputDecoration(
                hintText: 'Enter your code here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
              },
              items: _languages.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(lang.toUpperCase()),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : executeCode,
              child: Text('Compile Code'),
            ),
            SizedBox(height: 20),
            Text(
              'Output:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _output,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
