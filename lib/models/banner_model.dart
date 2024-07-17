class BannerCard {
  final int id;
  final String bannerCode;
  final String bannerTitle;
  final String bannerImage;
  final String imageUrl;

  BannerCard({
    required this.id,
    required this.bannerCode,
    required this.bannerTitle,
    required this.bannerImage,
    required this.imageUrl,
  });

  factory BannerCard.fromJson(Map<String, dynamic> json) {
    return BannerCard(
      id: json['id'],
      bannerCode: json['banner_code'],
      bannerTitle: json['banner_title'],
      bannerImage: json['banner_image'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banner_code': bannerCode,
      'banner_title': bannerTitle,
      'banner_image': bannerImage,
      'image_url': imageUrl,
    };
  }
}