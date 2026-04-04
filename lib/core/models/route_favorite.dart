class RouteFavorite {
  final int id;
  final String origin;
  final String destination;

  const RouteFavorite({
    required this.id,
    required this.origin,
    required this.destination,
  });

  factory RouteFavorite.fromJson(Map<String, dynamic> json) {
    return RouteFavorite(
      id: json['id'] as int,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
    );
  }
}
