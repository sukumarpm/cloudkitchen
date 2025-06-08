class MyOrders {
  List<Order>? items;
  String? status;
  String? vendor;
  String? order_id;
  String? user_id;
  String? driver_phone;
  double? total_amount;

  MyOrders(
      {this.status,
      this.vendor,
      this.order_id,
      this.user_id,
      this.driver_phone,
      this.items,
      this.total_amount});

  MyOrders.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Order>[];
      json['items'].forEach((v) {
        items!.add(Order.fromJson(v));
      });
    }
    status = json['status'];
    vendor = json['vendor'];
    order_id = json['order_id'];
    user_id = json['user_id'];
    driver_phone = json['driver_phone'];
    total_amount = json['total_amount'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['vendor'] = vendor;
    data['order_id'] = order_id;
    data['user_id'] = user_id;
    data['driver_phone'] = driver_phone;
    data['total_amount'] = total_amount;
    return data;
  }
}

class Order {
  String? title;
  String? price;
  double? qty;
  String? url;

  Order({this.title, this.price, this.qty, this.url});

  Order.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    qty = json['qty'].toDouble();
    url = json['url'];
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
