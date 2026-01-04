import 'package:hive/hive.dart';

import '../../domain/entities/pokemon_types.dart';
import '../../domain/entities/type_defense_info.dart';

part 'type_defense_info_hive_model.g.dart';

@HiveType(typeId: 5)
class TypeDefenseInfoHiveModel extends HiveObject {
  @HiveField(0)
  final int typeIndex;

  @HiveField(1)
  final double damageMultiplier;

  TypeDefenseInfoHiveModel({
    required this.typeIndex,
    required this.damageMultiplier,
  });

  factory TypeDefenseInfoHiveModel.fromDomain(TypeDefenseInfo info) {
    return TypeDefenseInfoHiveModel(
      typeIndex: info.type.index,
      damageMultiplier: info.damageMultiplier,
    );
  }

  TypeDefenseInfo toDomain() {
    return TypeDefenseInfo(
      type: PokemonTypes.values[typeIndex],
      damageMultiplier: damageMultiplier,
    );
  }
}
