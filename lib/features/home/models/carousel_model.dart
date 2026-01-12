class CarouselModel {
  final String id;
  final String image;
  final String heading;
  final String subheading;
  final String description;
  final int order;

  CarouselModel({
    required this.id,
    required this.image,
    required this.heading,
    required this.subheading,
    required this.description,
    required this.order,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      heading: json['heading'] ?? '',
      subheading: json['subheading'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}
