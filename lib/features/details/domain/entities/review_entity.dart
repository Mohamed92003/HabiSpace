class ReviewEntity {
  final int id;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String comment;
  final String createdAt;

  const ReviewEntity({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}