abstract class Exporter {
  Future<String> export(
    List<Map<String, dynamic>> income,
    List<Map<String, dynamic>> outcome,
  );
}
