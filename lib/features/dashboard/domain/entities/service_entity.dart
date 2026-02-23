class ServiceEntity {
  final String id;
  final String name;
  final String slug;
  final String? icon;
  final num? basePriceFrom;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.basePriceFrom,
  });
}