// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// Product review data
class Review {
  const Review({
    required this.rating,
    required this.comment,
    required this.date,
  });
  final double rating; // from 1 to 5
  final String comment;
  final DateTime date;

  Review copyWith({
    double? rating,
    String? comment,
    DateTime? date,
  }) {
    return Review(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rating': rating,
      'comment': comment,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      rating: map['rating'] as double,
      comment: map['comment'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Review(rating: $rating, comment: $comment, date: $date)';

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.rating == rating && other.comment == comment && other.date == date;
  }

  @override
  int get hashCode => rating.hashCode ^ comment.hashCode ^ date.hashCode;
}
