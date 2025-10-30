class Grade {
  final List<GradeComponent> components;

  Grade({this.components = const []});

  /// sum of all component weights in percent (0–100)
  double get totalWeightPercent {
    return components.fold(0, (sum, c) => sum + c.weight * 100);
  }

  /// final grade contribution (only valid if totalWeightPercent == 100)
  double get finalPercent {
    if (totalWeightPercent != 100) return 0; 
    return components.fold<double>(0, (sum, c) => sum + c.percentOfTotal);
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

  GradeEntry({required this.earned, required this.total});
}
