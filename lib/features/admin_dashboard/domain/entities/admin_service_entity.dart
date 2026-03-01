class AdminServiceEntity {
  final String id;
  final String name;
  final String slug;
  final String? icon;
  final int basePriceFrom;
  final String status;

  const AdminServiceEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    required this.basePriceFrom,
    required this.status,
  });
}