class Driver {
  String? name;
  String? phone;
  String? vehmodel;
  String? bikenum;
  String? identidityurl;
  String? bikeurl;
  bool? active;

  Driver(
      {this.name,
      this.phone,
      this.vehmodel,
      this.bikenum,
      this.identidityurl,
      this.bikeurl,
      this.active});

  Driver.fromJson(Map<String, dynamic> json) {
    name = json['driver_name'];
    phone = json['driverphone'];
    vehmodel = json['vehicle_model'];
    bikenum = json['vehicle_number'];
    identidityurl = json['imageurl1'];
    bikeurl = json['imageurl2'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_name'] = name;
    data['driverphone'] = phone;
    data['vehicle_model'] = vehmodel;
    data['vehicle_number'] = bikenum;
    data['imageurl1'] = identidityurl;
    data['imageurl2'] = bikeurl;
    data['active'] = active;
    return data;
  }
}
