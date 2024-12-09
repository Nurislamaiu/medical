class UserProfile {
  final String name;
  final String address;
  final int age;
  final String gender;
  final String phone;

  UserProfile({
    required this.name,
    required this.address,
    required this.age,
    required this.gender,
    required this.phone,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'age': age,
      'gender': gender,
      'phone': phone,
    };
  }
}
