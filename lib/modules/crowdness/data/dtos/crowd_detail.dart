import "package:intl/intl.dart";

final _dateFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");

class CrowdDetail {
  final int crowdCount;
  final double crowdDensity;
  final DateTime updatedAt;
  final double avgCrowdCount;
  final double avgCrowdDensity;
  final List<CrowdRecord> crowdHistory;

  CrowdDetail({
    required this.crowdCount,
    required this.crowdDensity,
    required this.updatedAt,
    required this.avgCrowdCount,
    required this.avgCrowdDensity,
    required this.crowdHistory,
  });

  factory CrowdDetail.fromJson(Map<String, dynamic> json) => CrowdDetail(
        crowdCount: json["crowd_count"],
        crowdDensity: json["crowd_density"],
        updatedAt:
            _dateFormatter.tryParse(json["updated_at"]) ?? DateTime(1970, 1, 1),
        avgCrowdCount: json["avg_crowd_count"],
        avgCrowdDensity: json["avg_crowd_density"],
        crowdHistory: List<CrowdRecord>.from(
          json["crowd_history"].map((record) => CrowdRecord.fromJson(record)),
        ),
      );
}

class CrowdRecord {
  final int crowdCount;
  final double crowdDensity;
  final DateTime updatedAt;

  CrowdRecord({
    required this.crowdCount,
    required this.crowdDensity,
    required this.updatedAt,
  });

  factory CrowdRecord.fromJson(Map<String, dynamic> json) => CrowdRecord(
        crowdCount: json["crowd_count"],
        crowdDensity: json["crowd_density"],
        updatedAt:
            _dateFormatter.tryParse(json["updated_at"]) ?? DateTime(1970, 1, 1),
      );
}
