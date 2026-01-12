class HeroCarouselModel {
  final String id;
  final String image;

  HeroCarouselModel({
    required this.id,
    required this.image,
  });

  factory HeroCarouselModel.fromJson(Map<String, dynamic> json) {
    return HeroCarouselModel(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
