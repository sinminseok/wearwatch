class HealthInformationRequest {
  final double heartBit;
  final double lat;
  final double lon;

  HealthInformationRequest({
    required this.heartBit,
    required this.lat,
    required this.lon,
  });

  Map<String, dynamic> toJson() {
    return {
      'heartBit': heartBit,
      // 'lat': lat,
      // 'lon': lon,
    };
  }
}
