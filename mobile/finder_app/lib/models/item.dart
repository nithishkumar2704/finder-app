class Category {
  final int id;
  final String name;
  final String? icon;

  Category({required this.id, required this.name, this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

class ItemImage {
  final int id;
  final String image;
  final bool isPrimary;

  ItemImage({required this.id, required this.image, this.isPrimary = false});

  factory ItemImage.fromJson(Map<String, dynamic> json) {
    return ItemImage(
      id: json['id'],
      image: json['image'],
      isPrimary: json['is_primary'] ?? false,
    );
  }
}

class Item {
  final int id;
  final String title;
  final String description;
  final int category;
  final String categoryName;
  final String itemType; // 'LOST' or 'FOUND'
  final String status;
  final double latitude;
  final double longitude;
  final String? address;
  final int postedBy;
  final String postedByUsername;
  final List<ItemImage> images;
  final DateTime createdAt;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.categoryName,
    required this.itemType,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.postedBy,
    required this.postedByUsername,
    required this.images,
    required this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      categoryName: json['category_name'],
      itemType: json['item_type'],
      status: json['status'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      address: json['address'],
      postedBy: json['posted_by'],
      postedByUsername: json['posted_by_username'],
      images: (json['images'] as List).map((i) => ItemImage.fromJson(i)).toList(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
