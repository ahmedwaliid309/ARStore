class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.description = '',
    this.images = const [],
    this.widthCm = 0,
    this.heightCm = 0,
    this.depthCm = 0,
    this.colors = const [],
    this.modelUrl,
  });

  final String id;
  final String name;
  final double price;
  final String category;
  final String description;

  /// روابط أو مسارات assets للصور
  final List<String> images;

  /// الأبعاد الحقيقية بالسنتيمتر (مهمة للـ AR)
  final double widthCm;
  final double heightCm;
  final double depthCm;

  /// الألوان المتاحة (HEX مثل '#9AA0A6')
  final List<String> colors;

  /// رابط أو مسار مجسم .glb للـ AR (لسه مؤجل)
  final String? modelUrl;

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'].toString(),
        name: j['name'] as String? ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0,
        category: j['category'] as String? ?? '',
        description: j['description'] as String? ?? '',
        images: (j['images'] as List?)?.cast<String>() ?? const [],
        widthCm: (j['widthCm'] as num?)?.toDouble() ?? 0,
        heightCm: (j['heightCm'] as num?)?.toDouble() ?? 0,
        depthCm: (j['depthCm'] as num?)?.toDouble() ?? 0,
        colors: (j['colors'] as List?)?.cast<String>() ?? const [],
        modelUrl: j['modelUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'category': category,
        'description': description,
        'images': images,
        'widthCm': widthCm,
        'heightCm': heightCm,
        'depthCm': depthCm,
        'colors': colors,
        'modelUrl': modelUrl,
      };

  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
