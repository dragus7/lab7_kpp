bool isValidDate(String input) {
  try {
    final parts = input.split('.');
    if (parts.length != 3) return false;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return false;
    final date = DateTime(y, m, d);
    return date.day == d && date.month == m && date.year == y;
  } catch (_) {
    return false;
  }
}

bool isValidTime(String input) {
  try {
    final parts = input.split(':');
    if (parts.length != 2) return false;
    final h = int.tryParse(parts[0]);
    final min = int.tryParse(parts[1]);
    return h != null && min != null && h >= 0 && h < 24 && min >= 0 && min < 60;
  } catch (_) {
    return false;
  }
}
