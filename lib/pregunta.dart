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