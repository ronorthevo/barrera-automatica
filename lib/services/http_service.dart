import 'package:http/http.dart' as http;

class HttpService {
  static const Duration _timeout = Duration(seconds: 3);

  Future<bool> openBarrier(String ip, String key) async {
    try {
      final url = Uri.parse("http://$ip/open?key=$key");

      final response = await http.get(url).timeout(_timeout);

      return response.statusCode == 200 &&
          response.body.trim().contains("RELAY");
    } catch (_) {
      return false;
    }
  }

  Future<String> getBarrierState(String ip) async {
    try {
      final url = Uri.parse("http://$ip/status");

      final response = await http.get(url).timeout(_timeout);

      if (response.statusCode == 200) {
        return response.body.trim();
      }

      return "ERROR";
    } catch (_) {
      return "DESCONECTADA";
    }
  }

  Future<bool> isAlive(String ip) async {
    final state = await getBarrierState(ip);
    return state != "DESCONECTADA" && state != "ERROR";
  }
}