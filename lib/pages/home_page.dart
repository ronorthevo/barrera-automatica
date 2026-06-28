import 'dart:async';

import 'package:flutter/material.dart';
import '../services/http_service.dart';
import '../services/settings_service.dart';
import 'config_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HttpService httpService = HttpService();
  final SettingsService settings = SettingsService();

  Timer? timer;

  String estado = "Comprobando...";
  String ip = "192.168.0.20";
  String key = "123456";

  @override
  void initState() {
    super.initState();

    cargarConfiguracion();

    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => comprobarConexion(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> cargarConfiguracion() async {
    ip = await settings.getIp();
    key = await settings.getKey();

    await comprobarConexion();
  }

  Future<void> comprobarConexion() async {
    final nuevoEstado = await httpService.getBarrierState(ip);

    if (!mounted) return;

    setState(() {
      estado = nuevoEstado;
    });
  }

  Color colorEstado() {
    switch (estado) {
      case "ABIERTA":
        return Colors.green;
      case "CERRADA":
        return Colors.red;
      case "MOVIENDO":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData iconoEstado() {
    switch (estado) {
      case "ABIERTA":
        return Icons.lock_open;
      case "CERRADA":
        return Icons.lock;
      case "MOVIENDO":
        return Icons.sync;
      default:
        return Icons.cloud_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Barrera Automática"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            Icon(
              Icons.garage,
              size: 100,
              color: colorEstado(),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconoEstado(),
                  color: colorEstado(),
                ),
                const SizedBox(width: 10),
                Text(
                  estado,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorEstado(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConfigPage(),
                  ),
                );

                await cargarConfiguracion();
              },
              icon: const Icon(Icons.settings),
              label: const Text("Configuración"),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: estado == "DESCONECTADA"
                  ? null
                  : () async {
                      final ok = await httpService.openBarrier(ip, key);

                      if (!mounted) return;

                      if (ok) {
                        await comprobarConexion();
                      }

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? "Barrera accionada"
                                : "Error de comunicación",
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.lock_open),
              label: const Text("Abrir Barrera"),
            ),

            const Spacer(),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "IP: $ip",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Estado: $estado",
                      style: TextStyle(
                        fontSize: 18,
                        color: colorEstado(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}