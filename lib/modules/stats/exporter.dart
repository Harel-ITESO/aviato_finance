abstract class Exporter {
  Future<void> export(
    List<Map<String, dynamic>> income,
    List<Map<String, dynamic>> outcome,
  );
}
