class DailyUpdateModel {
  final String id;
  final String headline;
  final String subheadline;
  final String description;
  final String image;
  final String createdAt;

  DailyUpdateModel({
    required this.id,
    required this.headline,
    required this.subheadline,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  factory DailyUpdateModel.fromJson(Map<String, dynamic> json) {
    return DailyUpdateModel(
      id: json['_id'] ?? '',
      headline: json['Headline'] ?? '',
      subheadline: json['Subheadline'] ?? '',
      description: json['Description'] ?? '',
      image: json['Image'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
