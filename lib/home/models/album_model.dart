import 'dart:convert';

class Album {
  final int id;
  final String title;
  final int category;
  final double price;
  final String img;
  final String band;
  final int year;
  bool isFavorite;

  Album({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.img,
    required this.band,
    required this.year,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'category': category});
    result.addAll({'price': price});
    result.addAll({'img': img});
    result.addAll({'band': band});
    result.addAll({'year': year});
    result.addAll({'isFavorite': isFavorite});

    return result;
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      category: map['category']?.toInt() ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      img: map['img'] ?? '',
      band: map['band'] ?? '',
      year: map['year']?.toInt() ?? 0,
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) => Album.fromMap(json.decode(source));
}
