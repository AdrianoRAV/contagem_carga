/*import 'package:flutter/material.dart';
import 'dart:async';

import 'main.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Timer para navegar para a próxima tela após 3 segundos
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF002D72), // Azul dos Correios
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Coloque aqui o seu logo ou imagem
           // Icon(Icons.local_post_office, size: 100, color: Color(0xFFF6EB61)), // Amarelo
            Icon(Icons.business, size: 100, color: Color(0xFFF6EB61)),
            SizedBox(height: 20),
            Text(
              'Contagem de Carga',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFFF6EB61), // Amarelo
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'dart:async';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _truckAnimation;
  late Animation<double> _wheelAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador para a animação principal (3 segundos)
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Animação do caminhão movendo-se da esquerda para a direita
    _truckAnimation = Tween<double>(begin: -200, end: 500).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Animação das rodas girando
    _wheelAnimation = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.linear),
      ),
    );

    _controller.forward();

    // Navegação após 3 segundos
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002D72), // Azul dos Correios
      body: Stack(
        children: [
          // Estrada
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height / 2 + 30,
            child: Container(
              height: 3,
              color: Colors.grey[400],
            ),
          ),

          // Caminhão animado
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height / 2 - 20,
                left: _truckAnimation.value,
                child: Column(
                  children: [
                    // Cabine do caminhão
                    const Icon(Icons.local_shipping, size: 80, color: Color(0xFFF6EB61)),

                    // Rodas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: _wheelAnimation.value * 3.14,
                          child: const Icon(Icons.circle, size: 20, color: Colors.black),
                        ),
                        const SizedBox(width: 40),
                        Transform.rotate(
                          angle: _wheelAnimation.value * 3.14,
                          child: const Icon(Icons.circle, size: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // Conteúdo central
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 120), // Espaço para o caminhão passar
                const Icon(Icons.business, size: 150, color: Color(0xFFF6EB61)),
                const SizedBox(height: 20),
                const Text(
                  'Contagem de Carga',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFF6EB61),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Integração SCI',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFFF6EB61).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

