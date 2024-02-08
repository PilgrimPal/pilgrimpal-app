import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/common/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PilgrimPal")),
      drawer: const AppDrawer(),
    );
  }
}
