class UserModel {
  String firstName;
  String lastName;
  String role;
  String phoneNumber;
  String email;
  String carBrand;
  String carID;
  String carYear;
  String carColor;
  String provinces;
  num wallet;
  List<String> groups;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.phoneNumber,
    required this.email,
    required this.carID,
    required this.carColor,
    required this.carYear,
    required this.provinces,
    required this.carBrand,
    required this.groups,
    this.wallet = 0,
  });

  //from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['fisrtName'] ?? '',
      lastName: map['lastName'] ?? '',
      role: map['role'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      carID: map['carID'] ?? '',
      carColor: map['carColor'] ?? '',
      provinces: map['provinces'] ?? '',
      carBrand: map['carBrand'] ?? '',
      carYear: map['carYear'] ?? '',
      wallet: map['wallet'] ?? '',
      groups: List<String>.from(map['groups'] ?? []),
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "role": role,
      "phoneNumber": phoneNumber,
      "email": email,
      "carID": carID,
      "carColor": carColor,
      "carYear": carYear,
      "provinces": provinces,
      "carBrand": carBrand,
      "wallet": wallet,
      "groups": groups,
    };
  }
}
