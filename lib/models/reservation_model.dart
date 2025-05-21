class ReservationModel {
  String id;
  String postedByUid;
  String postedByName;
  String title;
  String description;
  num price;
  int capacity;
  String category;
  String imageUrl;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;

  ReservationModel(
    this.id,
    this.postedByUid,
    this.postedByName,
    this.title,
    this.description,
    this.price,
    this.capacity,
    this.category,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.createdAt,
  );

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      json['id'] ?? '',
      json['postedByUid'] ?? '',
      json['postedByName'] ?? '',
      json['title'] ?? '',
      json['description'] ?? '',
      json['price'] ?? 0,
      json['capacity'] ?? 0,
      json['category'] ?? 'General',
      json['imageUrl'] ?? '',
      DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postedByUid': postedByUid,
      'postedByName': postedByName,
      'title': title,
      'description': description,
      'price': price,
      'capacity': capacity,
      'category': category,
      'imageUrl': imageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
