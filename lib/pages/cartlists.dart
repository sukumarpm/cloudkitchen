// class Cartlists {
//   String title;
//   String price;
//   double qty;
//   String url;

//   Cartlists({
//     required this.title,
//     required this.price,
//     required this.qty,
//     required this.url,
//   });
// }
class Cartlists {
  String? title;
  String? price;
  double? qty;
  String? url;

  Cartlists(
      {required this.title,
      required this.price,
      required this.qty,
      required this.url});

  Cartlists.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    qty = json['qty'];
    url = json['url'];
  }
  Map<String, dynamic> toFirestore() {
    return {
      "active": title,
      "delivery": price,
      "imageurl1": qty,
      "imageurl2": url
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['qty'] = qty;
    data['url'] = url;
    return data;
  }
}
