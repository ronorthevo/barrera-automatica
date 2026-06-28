import 'package:flutter/material.dart';
import '../services/ble_service.dart';
import 'config_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final BleService bleService = BleService();

  String estado = "Desconectado";

  @override
  Widget build(BuildContext context) {

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

            const Icon(
              Icons.garage,
              size: 100,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            Text(
            estado,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
            onPressed: () async {

                setState(() {
                estado = "Buscando barreras...";
                });

                bool conectado = await bleService.connectToBarrier();

                setState(() {
                estado = conectado
                    ? "Conectado a Barrera"
                    : "Barrera no encontrada";
                });

            },

              icon: const Icon(Icons.bluetooth),
              label: const Text("Conectar a Barrera"),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
            onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConfigPage(),
                ),
                );
            },
            icon: const Icon(Icons.wifi),
            label: const Text("Configurar WiFi"),
            ),


            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.lock_open),
              label: const Text("Abrir Barrera"),
            ),

            const Spacer(),

            const Text(
              "IP: SIN CONECTAR",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}