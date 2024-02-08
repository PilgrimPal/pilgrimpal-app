import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/core/routes.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PilgrimPal")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 4,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(crowdnessRoute),
              child: const Card(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people,
                        size: 60,
                        color: Colors.deepPurple,
                      ),
                      Text(
                        "Crowdness",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(assistantRoute),
              child: const Card(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat,
                        size: 60,
                        color: Colors.deepPurple,
                      ),
                      Text(
                        "Assistant",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
