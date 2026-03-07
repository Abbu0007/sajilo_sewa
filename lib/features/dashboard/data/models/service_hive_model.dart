import 'package:hive/hive.dart';

part 'service_hive_model.g.dart';

@HiveType(typeId: 2)
class ServiceHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String slug;

  @HiveField(3)
  final String? icon;

  @HiveField(4)
  final num? basePriceFrom;

  ServiceHiveModel({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.basePriceFrom,
  });
}