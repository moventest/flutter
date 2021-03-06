import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id = '';
  String firstName = '';
  String lastName = '';
  String description = '';
  String email = '';
  String picture = '';
  GeoPoint address = GeoPoint(0, 0);

  UserModel();

  UserModel.fromSnapshot(DocumentSnapshot snapDoc) {
    if (snapDoc != null) {
      Map<String, dynamic> data = snapDoc.data;
      this.id = snapDoc.documentID;
      this.firstName = data.containsKey('first_name') ? data['first_name'] : "";
      this.lastName = data.containsKey('last_name') ? data['last_name'] : "";
      this.description =
          data.containsKey('description') ? data['description'] : "";
      this.email = data.containsKey('email') ? data['email'] : "";
      this.picture = data.containsKey('picture') ? data['picture'] : "";
      this.address =
          data.containsKey('address') ? data['address'] : GeoPoint(0, 0);
    }
  }

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, description: $description, email: $email, picture: $picture, address: $address}';
  }

  Map<String, dynamic> toFirestoreObject(bool addId) {
    Map<String, dynamic> result = new Map();
    result['first_name'] = this.firstName;
    result['last_name'] = this.lastName;
    result['description'] = this.description;
    result['email'] = this.email;
    result['picture'] = this.picture;
    result['address'] = this.address;
    if (addId) {
      result['id'] = this.id;
    }
    return result;
  }

  from(UserModel user) {
    this.id = user.id;
    this.firstName = user.firstName;
    this.lastName = user.lastName;
    this.description = user.description;
    this.email = user.email;
    this.picture = user.picture;
    this.address = user.address;
  }
}
