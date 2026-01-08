import 'package:shared_preferences/shared_preferences.dart';

enum Env { local, network, production, test }

class Variables {
  static String url = 'https://api.fitcpx.com';
  // static String url = 'http://192.168.1.16:8070';
  static Env currentEnv = Env.production;

  static Future<void> setEnv(Env env) async {
    currentEnv = env;

    switch (env) {
      case Env.local:
        url = 'http://localhost:8070';
        break;

      case Env.network:
        url = 'http://192.168.1.10:8070';
        break;

      case Env.test:
        url = 'https://apitest.fitcpx.com';
        break;

      case Env.production:
        url = 'https://api.fitcpx.com';
        break;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('environment', env.name); // ← mais limpo
  }

  static Future<void> loadEnv() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('environment');

    if (saved == null) return;

    // converte "local", "network", "production" ou "test" para Env
    try {
      final env = Env.values.firstWhere((e) => e.name == saved);
      await setEnv(env); // aplica
    } catch (_) {
      // se der erro, mantém production
    }
  }

  static String get envLabel {
    switch (currentEnv) {
      case Env.local:
        return "LOCAL MODE - $url";

      case Env.network:
        return "NETWORK MODE - $url";

      case Env.test:
        return "TEST MODE - $url";

      case Env.production:
        return "";
    }
  }
}
