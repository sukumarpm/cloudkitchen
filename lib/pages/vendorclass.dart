import 'package:cloud_firestore/cloud_firestore.dart';

class VendorSource {
  VendorSource({
    required this.active,
    required this.discount,
    required this.location,
    required this.address,
    required this.name,
    required this.pickup,
  });

  final bool? active;
  final int discount;
  final List<dynamic> location;
  final String? address;
  final String? name;
  final bool? pickup;

  factory VendorSource.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    // SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return VendorSource(
      active: data["active"],
      discount: data["discount"],
      location: data['location'],
      address: data["address"],
      name: data["name"],
      pickup: data["pickup"],
    );
  }
// Map<String, dynamic> toFirestore() {
//     return {
//       if (name != null) "name": name,
//       if (state != null) "state": state,
//       if (country != null) "country": country,
//       if (capital != null) "capital": capital,
//       if (population != null) "population": population,
//       if (regions != null) "regions": regions,
//     };
//   }
  Map<String, dynamic> toFirestore() {
    return {
      "active": active,
      "discount": discount,
      "location": location,
      "address": address,
      "name": name,
      "pickup": pickup,
    };
  }
}

class Ingredient {
  Ingredient({
    required this.name,
  });

  final String? name;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {"name": name};
}
