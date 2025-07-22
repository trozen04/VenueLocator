class VenueModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String type;
  final String address;

  VenueModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.address,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      type: json['type'],
      address: json['address'] ?? '',
    );
  }
}