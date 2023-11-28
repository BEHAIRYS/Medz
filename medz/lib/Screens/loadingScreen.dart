import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return LoadingScreen_State();
  }
}

class LoadingScreen_State extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('..Loading'));
  }
}
