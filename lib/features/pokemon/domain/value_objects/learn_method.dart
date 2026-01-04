enum LearnMethod {
  levelUp(id: 'level-up', displayName: 'Level up', priority: 1),
  machine(id: 'machine', displayName: 'TM/HM', priority: 2),
  egg(id: 'egg', displayName: 'Eggs', priority: 3),
  tutor(id: 'tutor', displayName: 'Tutor', priority: 4);

  final String id;
  final String displayName;
  final int priority;

  const LearnMethod({
    required this.id,
    required this.displayName,
    required this.priority,
  });

  static LearnMethod? fromId(String? id) {
    if (id == null) return null;
    try {
      return LearnMethod.values.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  static String getDisplayName(String? methodId) {
    final method = fromId(methodId);
    return method?.displayName ?? methodId ?? 'Unknown';
  }
}
