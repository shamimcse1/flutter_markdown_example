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
  String _language = 'python3';  // default language
  String _output = '';
  bool _isLoading = false;

  // Example languages supported by Judge0
  final List<String> _languages = ['python3', 'javascript', 'cpp', 'java'];

  Future<void> _compileCode() async {
    setState(() {
      _isLoading = true;
      _output = 'Compiling...';
    });

    const apiUrl = 'https://api.jdoodle.com/v1/execute';  // or another API
    const clientId = '85be172c15a98ccd1c50a6a3933aca3e'; // replace with your JDoodle client ID
    const clientSecret = 'c675e215ef7dde155314e16a22f219d2939c84ce057ef9d47ec3a6783ef071b2'; // replace with your JDoodle client secret

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'clientId': clientId,
        'clientSecret': clientSecret,
        'script': _code,
        'language': _language,
        'versionIndex': '0'
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _output = data['output'] ?? 'No output';
      });
    } else {
      setState(() {
        _output = 'Error: Could not compile code.';
      });
    }

    setState(() {
      _isLoading = false;
    });
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
              onPressed: _isLoading ? null : _compileCode,
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