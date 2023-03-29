class UserModel {
  String firstName;
  String lastName;
  String dProfilePic;
  String uid;
  String phoneNumber;
  String carBrand;
  String carID;
  String carYear;
  String carColor;
  String provinces;
  String createAt;
  num wallet;
  List<String> groups;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.dProfilePic,
    required this.uid,
    required this.phoneNumber,
    required this.carID,
    required this.carColor,
    required this.carYear,
    required this.provinces,
    required this.carBrand,
    required this.createAt,
    this.wallet = 0,
    required this.groups,
  });

  //from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['fisrtName'] ?? '',
      lastName: map['lastName'] ?? '',
      dProfilePic: map['dProfilePic'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      carID: map['carID'] ?? '',
      carColor: map['carColor'] ?? '',
      createAt: map['createAt'] ?? '',
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
      "profilePic": dProfilePic,
      "uid": uid,
      "phoneNumber": phoneNumber,
      "createAt": createAt,
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
