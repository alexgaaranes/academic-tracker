class Grade {
  final List<GradeComponent> components;

  Grade({
    this.components = const [],
  });

  /// weighted average (based on each component's percentage)
  double get weightedAverage {
    if (components.isEmpty) return 0;

    double totalWeighted = 0;
    double totalWeight = 0;

    for (final c in components) {
      totalWeighted += c.percentOfTotal;
      totalWeight += c.weight;
    }

    if (totalWeight == 0) return 0;
    return totalWeighted / totalWeight;
  }
}

class GradeComponent {
  final String name; // e.g. "Exam", "Quiz"
  final double weight; // e.g. 0.1 means 10%
  final List<GradeEntry> entries;

  GradeComponent({
    required this.name,
    required this.weight,
    this.entries = const [],
  });

  /// percentage score across all entries (0–100)
  double get percentScore {
    if (entries.isEmpty) return 0;

    double totalEarned = 0;
    double totalPossible = 0;

    for (final e in entries) {
      totalEarned += e.earned;
      totalPossible += e.total;
    }

    if (totalPossible == 0) return 0;
    return (totalEarned / totalPossible) * 100;
  }

  /// actual contribution to the overall grade (e.g. 7.3 if 10% * 73%)
  double get percentOfTotal {
    return percentScore * weight;
  }
}

class GradeEntry {
  final double earned;
  final double total;
  

  GradeEntry({
    required this.earned,
    required this.total,
  });
}
