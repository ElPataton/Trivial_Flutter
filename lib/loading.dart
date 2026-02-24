import 'trivial.dart';
import 'pregunta.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Loading extends StatefulWidget {
  const Loading({
    super.key
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final url = Uri.parse(
      'https://corsproxy.io/?https://www.vidalibarraquer.net/android/trivial.json',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      try {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final list = jsonMap['Trivial'] as List<dynamic>;

        final preguntes = list.map((e) => Pregunta.fromJson(e as Map<String, dynamic>)).toList();
        preguntes.shuffle();

        await Future.delayed(const Duration(seconds: 1));

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
    } else {
      throw Exception('Error al cargar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          strokeWidth: 6.0,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}