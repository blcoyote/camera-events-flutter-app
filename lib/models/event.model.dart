import 'dart:convert';

List<EventModel> eventModelFromJson(String str) =>
    List<EventModel>.from(json.decode(str).map((x) => EventModel.fromJson(x)));
    
EventModel eventModelFromJsonSingle(String str) =>
    EventModel.fromJson(json.decode(str));

class EventModel {
  EventModel({
    required this.id,
    required this.camera,
    required this.startTime,
    required this.label,
    required this.zones,
    required this.hasClip,
    required this.hasSnapshot,
    required this.retainIndefinitely,
    this.data,
    this.endTime,
    this.thumbnail,
    this.falsePositive,
    this.plusId,
    this.ratio,
    this.subLabel,
  });

  final String id;
  final DataModel? data;
  final String camera;
  final double? endTime;
  final double startTime;
  final bool? falsePositive;
  final bool hasClip;
  final bool hasSnapshot;
  final String label;
  final String? plusId;
  final double? ratio;
  final bool retainIndefinitely;
  final String? subLabel;
  final String? thumbnail;
  final List<String> zones;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        data: DataModel.fromJson(json["data"]),
        camera: json["camera"],
        endTime: json["end_time"],
        startTime: json["start_time"],
        falsePositive: json["false_positive"],
        hasClip: json["has_clip"],
        hasSnapshot: json["has_snapshot"],
        label: json["label"],
        plusId: json["plus_id"],
        ratio: json["ratio"],
        retainIndefinitely: json["retain_indefinitely"],
        subLabel: json["sub_label"],
        thumbnail: json["thumbnail"],
        zones: List<String>.from(json["zones"].map((x) => x)),
      );
}

DataModel dataModelFromJson(String str) =>
    DataModel.fromJson(json.decode(str));

class DataModel{
  DataModel({
    this.type,
    this.box,
    this.region,
    this.score,
    this.topScore,
  });

  final List<double>? box;
  final List<double>? region;
  final double? score;
  final double? topScore;
  final String? type;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    box: List<double>.from(json["box"].map((x) => x)),
    region: List<double>.from(json["region"].map((x) => x)),
    score: json["score"],
    topScore: json["top_score"],
    type: json["type"]
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
  String? labels;
  String? zones;
  int? limit;
  int? hasSnapshot;
  int? hasClip;
  int? includeThumbnails;
  int? inProgress;

  Map<String, dynamic> toJson() => {
        if (before != null) "before": before.toString(),
        if (after != null) "after": after.toString(),
        if (cameras != null) "cameras": cameras.toString(),
        if (labels != null) "labels": labels.toString(),
        if (zones != null) "zones": zones.toString(),
        if (limit != null) "limit": limit.toString(),
        if (hasSnapshot != null) "has_snapshot": hasSnapshot.toString(),
        if (hasClip != null) "has_clip": hasClip.toString(),
        if (includeThumbnails != null) "include_thumbnails": includeThumbnails.toString(),
        if (inProgress != null) "in_progress": inProgress.toString(),
      };
}
