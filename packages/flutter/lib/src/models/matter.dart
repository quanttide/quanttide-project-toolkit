import 'package:freezed_annotation/freezed_annotation.dart';

part 'matter.freezed.dart';
part 'matter.g.dart';


@unfreezed
class Matter with _$Matter {
  factory Matter({
    required final String id,
    required final int number,
    required final DateTime createdAt,
    required DateTime updatedAt,
    String? title,
    String? description,
    @Default('default') String type,
    @Default('drafting') String status,
    @Default('low') String priority,
  }) = _Matter;

  factory Matter.fromJson(Map<String, dynamic> json) => _$MatterFromJson(json);
}
