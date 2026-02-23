import 'package:flutter/material.dart';
import 'pregunta.dart';
import 'resultat.dart';

class TrivialScreen extends StatefulWidget {
  final List<Pregunta> preguntes;

  const TrivialScreen({
    super.key, 
    required this.preguntes
  });

  @override
  State<TrivialScreen> createState() => _TrivialScreenState();
}

class _TrivialScreenState extends State<TrivialScreen> {
  int preguntaIndex = 0;
  int puntuacio = 0;
  bool respostaSel = false;
  int? respostaSelIndex;
  int? respostaCorrectaIndex;
  bool seguent = false;

  final Map<String, Color> _colorsCategoria = {
  'entreteniment': Colors.orange,
  'història': Colors.brown,
  'esports': Colors.blue,
  'ciència': Colors.purple,
  'geografia': Colors.green,
  'vehicles': Colors.lime,
  'celebritats': Colors.pink,
  'cultura general': Colors.teal,
  };

  Color _colorCategoria(String categoria){
    final base = categoria.split(':').first.trim().toLowerCase();
    return _colorsCategoria[base] ?? Colors.grey;
  }

  late List<String> respostesActuals;

  @override
  void initState() {
    super.initState();
    _carregarpregunta();
  }

  void _carregarpregunta() {
    final pregunta = widget.preguntes[preguntaIndex];
    respostesActuals = [pregunta.respostaCorrecta, ...pregunta.respostesIncorrectes] ..shuffle();
  }

  void _selresposta(int index) {
    if (respostaSel) return;
    setState(() {
      respostaSel = true;
      respostaSelIndex = index;
      seguent = true;
      respostaCorrectaIndex = respostesActuals.indexOf(
        widget.preguntes[preguntaIndex].respostaCorrecta,
      );
      if (index == respostaCorrectaIndex) {
        puntuacio += 10;
      } else {
        puntuacio -= 5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (preguntaIndex >= widget.preguntes.length) return const SizedBox();
    final pregunta = widget.preguntes[preguntaIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pregunta ${preguntaIndex + 1}/${widget.preguntes.length} Categoria: ${pregunta.categoria}, Dificultat: ${pregunta.dificultat}, Puntuacio: $puntuacio',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: _colorCategoria(pregunta.categoria),
                child: Center(
                  child: Text(
                    pregunta.pregunta,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30
            ),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: respostesActuals.length,
                itemBuilder: (context, index) {
                  final color = respostaSel? (
                    index == respostaCorrectaIndex? Colors.green : 
                    index == respostaSelIndex? Colors.red : 
                    null
                  ) : null;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: respostaSel? () {
                      } : () => _selresposta(index),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: color ?? Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(20),
                      ),

                      child: Text(
                        respostesActuals[index],
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: seguent? FloatingActionButton(
        onPressed: () {
          if (seguent) {
            if (preguntaIndex < widget.preguntes.length - 1) {
              setState(() {
                preguntaIndex++;
                respostaSel = false;
                respostaSelIndex = null;
                respostaCorrectaIndex = null;
                seguent = false;
              });
              _carregarpregunta();
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultatScreen(puntuacio: puntuacio),
                ),
              );
            }
          }
        },
        child: const Icon(Icons.arrow_forward),
      ) : null,
    );
  }
}
