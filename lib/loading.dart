import 'dart:math';
import 'trivial.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'loading.dart';
import 'dart:convert';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

Future<List<Pregunta>> _fetchpreguntes() async {
  final url = Uri.parse(
    'https://corsproxy.io/?https://www.vidalibarraquer.net/android/trivial.json',
  );
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
    final list = jsonMap['Trivial'] as List<dynamic>;
    return list
        .map((e) => Pregunta.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Error al cargar');
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final preguntes = await _fetchpreguntes();
      preguntes.shuffle();
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TrivialScreen(preguntes: preguntes)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al cargar $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 6.0,
            backgroundColor: Colors.white24,
          ),
        ),
      ),
    );
  }
}

class Pregunta {
  final String tipus;
  final String dificultat;
  final String categoria;
  final String pregunta;
  final String respostaCorrecta;
  final List<String> respostesIncorrectes;

  Pregunta({
    required this.tipus,
    required this.dificultat,
    required this.categoria,
    required this.pregunta,
    required this.respostaCorrecta,
    required this.respostesIncorrectes,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      tipus: json['tipus'],
      dificultat: json['dificultat'],
      categoria: json['categoria'],
      pregunta: json['pregunta'],
      respostaCorrecta: json['resposta_correcta'],
      respostesIncorrectes: List<String>.from(
        json['respostes_incorrectes'] as List<dynamic>,
      ),
    );
  }
}
