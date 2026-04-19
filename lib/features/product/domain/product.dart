class Product {
  const Product({
    required this.id,
    required this.categoryId,
    required this.brand,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.galleryImageUrls = const [],
    this.originalPrice,
    this.description = '매일 입기 좋은 균형 잡힌 핏과 편안한 소재로 완성했습니다.',
    this.colors = const ['블랙', '화이트'],
    this.sizes = const ['S', 'M', 'L', 'XL'],
    this.rating = 0,
    this.reviewCount = 0,
    this.isNew = false,
    this.isInStock = true,
  });

  final String id;
  final String categoryId;
  final String brand;
  final String name;
  final int price;
  final int? originalPrice;
  final String imageUrl;
  final List<String> galleryImageUrls;
  final String description;
  final List<String> colors;
  final List<String> sizes;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isInStock;

  List<String> get imageGallery {
    return [imageUrl, ...galleryImageUrls];
  }

  int? get discountRate {
    final original = originalPrice;
    if (original == null || original <= price) return null;

    return ((original - price) / original * 100).round();
  }
}
