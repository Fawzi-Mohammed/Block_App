import 'package:equatable/equatable.dart';
import 'package:block_app/models/rating_model.dart';

class ProductModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final num price;
  final String category;
  final String image;
  final RatingModel rating;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'rating': rating.toMap(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: (map['id'] as num).toInt(),
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as num,
      category: map['category'] as String,
      image: map['image'] as String,
      rating: RatingModel.fromMap(
        Map<String, dynamic>.from(map['rating'] as Map),
      ),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    category,
    image,
    rating,
  ];
}
