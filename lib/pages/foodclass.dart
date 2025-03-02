import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FoodSource {
  FoodSource({
    required this.active,
    required this.delivery,
    required this.imageurl1,
    required this.imageurl2,
    required this.imageurl3,
    required this.ingredients,
    required this.itemdescription,
    required this.itemname,
    required this.pickup,
    required this.rate,
    required this.when,
  });

  final bool? active;
  final bool? delivery;
  final String? imageurl1;
  final String? imageurl2;
  final String? imageurl3;
  final String ingredients;
  final String? itemdescription;
  final String? itemname;
  final bool? pickup;
  final String? rate;
  final String? when;

  factory FoodSource.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    // SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return FoodSource(
      active: data["active"],
      delivery: data["delivery"],
      imageurl1: data["imageurl1"],
      imageurl2: data["imageurl2"],
      imageurl3: data["imageurl3"],
      ingredients: data['ingredients'],
      itemdescription: data["item_description"],
      itemname: data["item_name"],
      pickup: data["pickup"],
      rate: data["rate"],
      when: data["when"],
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
      "delivery": delivery,
      "imageurl1": imageurl1,
      "imageurl2": imageurl2,
      "imageurl3": imageurl3,
      "ingredients": ingredients,
      "itemdescription": itemdescription,
      "itemname": itemname,
      "pickup": pickup,
      "rate": rate,
      "when": when,
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
