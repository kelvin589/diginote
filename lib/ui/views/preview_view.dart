import 'package:flutter/material.dart';

class PreviewView extends StatefulWidget {
  const PreviewView({Key? key}) : super(key: key);

  @override
  _PreviewViewState createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: const Center(
        child: Text('Preview'),
      ),
    );
  }
}
