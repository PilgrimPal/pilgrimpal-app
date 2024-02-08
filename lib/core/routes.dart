import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/pages/assistant_page.dart';
import 'package:pilgrimpal_app/modules/crowdness/presentation/pages/crowd_detail_page.dart';
import 'package:pilgrimpal_app/modules/crowdness/presentation/pages/crowdness_page.dart';
import 'package:pilgrimpal_app/modules/home/presentation/pages/home_page.dart';

const homeRoute = "/home";
const crowdnessRoute = "/crowdness";
const crowdDetailRoute = "/crowdness/detail";
const assistantRoute = "/assistant";

final Map<String, Widget Function(BuildContext)> routes = {
  homeRoute: (context) => const HomePage(),
  crowdnessRoute: (context) => const CrowdnessPage(),
  crowdDetailRoute: (context) => const CrowdDetailPage(),
  assistantRoute: (context) => const AssistantPage(),
};
