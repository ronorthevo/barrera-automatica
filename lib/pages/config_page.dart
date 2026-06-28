import 'package:flutter/material.dart';
import '../services/ble_service.dart';
import '../services/settings_service.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final BleService ble = BleService();
  final SettingsService settings = SettingsService();

  final ipController = TextEditingController();
  final keyController = TextEditingController();
  final wifiController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  @override
  void dispose() {
    ipController.dispose();
    keyController.dispose();
    wifiController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> cargarDatos() async {
    ipController.text = await settings.getIp();
    keyController.text = await settings.getKey();
  }

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "ESP32",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: "IP del ESP32",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: "Clave",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            const Divider(),

            const SizedBox(height: 20),

            const Text(
              "Configuración WiFi (BLE)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: wifiController,
              decoration: const InputDecoration(
                labelText: "SSID",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña WiFi",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () async {
                await settings.save(
                  ipController.text.trim(),
                  keyController.text.trim(),
                );

                await ble.sendWifi(
                  wifiController.text.trim(),
                  passwordController.text,
                );

                if (!mounted) return;

                messenger.showSnackBar(
                  const SnackBar(
                    content: Text("Configuración guardada"),
                  ),
                );
              },
              child: const Text("Guardar"),
            ),

            const SizedBox(height: 25),

            StreamBuilder<String>(
              stream: ble.messages.stream,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? "Sin mensajes",
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}