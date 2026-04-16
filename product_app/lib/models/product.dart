class Product {
  final int? id;
  final String name;
  final double price;
  final String description;
  final String image;
  final String category;

  const Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.image = '',
    this.category = 'general',
  });

  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? image,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      category: category ?? this.category,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: (json['title'] ?? json['name'] ?? '') as String,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: (json['description'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      category: (json['category'] ?? 'general') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': name,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
    };
  }
}
