import 'package:flutter/material.dart';
import '../../domain/value_objects/sorting.dart';

class SortMenuItem {
  final SortField field;
  final String label;
  final IconData icon;

  const SortMenuItem({
    required this.field,
    required this.label,
    required this.icon,
  });

  static const List<SortMenuItem> allOptions = [
    SortMenuItem(
      field: SortField.id,
      label: 'Pokédex Number',
      icon: Icons.numbers,
    ),
    SortMenuItem(
      field: SortField.name,
      label: 'Name',
      icon: Icons.abc,
    ),
    SortMenuItem(
      field: SortField.height,
      label: 'Height',
      icon: Icons.height,
    ),
    SortMenuItem(
      field: SortField.weight,
      label: 'Weight',
      icon: Icons.fitness_center,
    ),
    SortMenuItem(
      field: SortField.baseExperience,
      label: 'Base Experience',
      icon: Icons.star,
    ),
  ];
}
