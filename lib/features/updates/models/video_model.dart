class VideoModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String? videoFile;
  final DateTime createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.videoFile,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id'] ?? '',
      title: json['videoTitle'] ?? '',
      description: json['videoDescription'] ?? '',
      videoUrl: json['videoURL'] ?? '',
      videoFile: json['video'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
