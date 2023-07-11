import 'dart:convert';

List<EventModel> eventModelFromJson(String str) =>
    List<EventModel>.from(json.decode(str).map((x) => EventModel.fromJson(x)));

class EventModel {
  EventModel({
    required this.id,
    required this.camera,
    required this.startTime,
    required this.label,
    required this.topScore,
    required this.zones,
    required this.hasClip,
    required this.hasSnapshot,
    required this.retainIndefinitely,
    this.endTime,
    this.thumbnail,
    this.area,
    this.box,
    this.falsePositive,
    this.plusId,
    this.ratio,
    this.region,
    this.subLabel,
  });

  final String id;
  final String? area;
  final List<int>? box;
  final String camera;
  final int? endTime;
  final int startTime;
  final String? falsePositive;
  final bool hasClip;
  final bool hasSnapshot;
  final String label;
  final String? plusId;
  final String? ratio;
  final List<int>? region;
  final bool retainIndefinitely;
  final String? subLabel;
  final String? thumbnail;
  final double topScore;
  final List<String> zones;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        area: json["area"],
        box: json["box"],
        camera: json["camera"],
        endTime: json["end_time"],
        startTime: json["start_time"],
        falsePositive: json["false_positive"],
        hasClip: json["has_clip"],
        hasSnapshot: json["has_snapshot"],
        label: json["label"],
        plusId: json["plus_id"],
        ratio: json["ratio"],
        region: json["region"],
        retainIndefinitely: json["retain_indefinitely"],
        subLabel: json["sub_label"],
        thumbnail: json["thumbnail"],
        topScore: json["top_score"],
        zones: List<String>.from(json["zones"].map((x) => x)),
      );
}

String cameraEventQueryParamsToJson(CameraEventQueryParams data) =>
    json.encode(data.toJson());

class CameraEventQueryParams {
  CameraEventQueryParams({
    this.before,
    this.after,
    this.cameras,
    this.labels,
    this.zones,
    this.limit,
    this.hasSnapshot,
    this.hasClip,
    this.includeThumbnails,
    this.inProgress,
  });

  int? before;
  int? after;
  String? cameras;
  List<String>? labels;
  List<String>? zones;
  List<int>? limit;
  int? hasSnapshot;
  int? hasClip;
  int? includeThumbnails;
  int? inProgress;

  Map<String, dynamic> toJson() => {
        "before": before,
        "after": after,
        "cameras": cameras,
        "labels": labels,
        "zones": zones,
        "limit": limit,
        "has_snapshot": hasSnapshot,
        "has_clip": hasClip,
        "include_thumbnails": includeThumbnails,
        "in_progress": inProgress,
      };
}
