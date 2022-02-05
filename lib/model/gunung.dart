import 'package:flutter/material.dart';

class Gunung {
  String id;
  String name;
  String image_url;
  String lokasi;
  double lat;
  double lon;
  String deskripsi;
  String jalur_pendakian;
  String info_gunung;
  int province_id;

  Gunung({
    required this.id,
    required this.name,
    required this.image_url,
    required this.lokasi,
    required this.lat,
    required this.lon,
    required this.deskripsi,
    required this.jalur_pendakian,
    required this.info_gunung,
    required this.province_id,
  });

  factory Gunung.fromJson(Map<String, dynamic> json) {
    return Gunung(
      id: json['id'],
      name: json['name'],
      image_url: json['image_url'],
      lokasi: json['lokasi'],
      lat: json['lat'],
      lon: json['lon'],
      deskripsi: json['deskripsi'],
      jalur_pendakian: json['jalur_pendakian'],
      info_gunung: json['info_gunung'],
      province_id: json['province_id']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': image_url,
        'lokasi': lokasi,
        'lat': lat,
        'lon': lon,
        'deskripsi': deskripsi,
        'jalur_pendakian': jalur_pendakian,
        'info_gunung': info_gunung,
        'province_id': province_id
      };
}
