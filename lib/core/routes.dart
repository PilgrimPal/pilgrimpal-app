import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/crowdness/presentation/pages/crowd_detail_page.dart';
import 'package:pilgrimpal_app/modules/crowdness/presentation/pages/crowdness_page.dart';
import 'package:pilgrimpal_app/modules/home/presentation/pages/home_page.dart';

const homeRoute = "/home";
const crowdnessRoute = "/crowdness";
const crowdDetailRoute = "/crowdness/detail";

final routes = {
  homeRoute: (BuildContext context) => const HomePage(),
  crowdnessRoute: (BuildContext context) => const CrowdnessPage(),
  crowdDetailRoute: (BuildContext context) => const CrowdDetailPage(),
};
