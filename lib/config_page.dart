import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración WiFi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Red WiFi",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "wifi1",
                  child: Text("MiCasa"),
                ),
                DropdownMenuItem(
                  value: "wifi2",
                  child: Text("Oficina"),
                ),
              ],
              onChanged: (_) {},
            ),

            const SizedBox(height: 20),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Guardar"),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "IP: No conectada",
              style: TextStyle(fontSize: 18),
            ),

          ],
        ),
      ),
    );
  }
}