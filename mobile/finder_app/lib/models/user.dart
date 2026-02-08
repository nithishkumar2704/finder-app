class User {
  final int id;
  final String username;
  final String email;
  final String? phone;
  final String? profilePicture;
  final int reputationScore;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.profilePicture,
    this.reputationScore = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      profilePicture: json['profile_picture'],
      reputationScore: json['reputation_score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'profile_picture': profilePicture,
      'reputation_score': reputationScore,
    };
  }
}
