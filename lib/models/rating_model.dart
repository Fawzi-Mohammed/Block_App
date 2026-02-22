import 'package:equatable/equatable.dart';

class RatingModel extends Equatable {
  final num rate;
  final int count;

  const RatingModel({required this.rate, required this.count});
  @override
  List<Object?> get props => [rate, count];

  Map<String, dynamic> toMap() {
    return {'rate': rate, 'count': count};
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      rate: map['rate'] as num,
      count: (map['count'] as num).toInt(),
    );
  }
}
