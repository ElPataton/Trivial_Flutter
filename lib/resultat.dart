import 'package:flutter/material.dart';
import 'loading.dart';

class ResultatScreen extends StatefulWidget{
  final int puntuacio;

  const ResultatScreen({
    super.key, 
    required this.puntuacio
  });

  @override
  State<ResultatScreen> createState() => _ResultatScreenState();
}

class _ResultatScreenState extends State<ResultatScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Gracies per jugar al Trivial"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Puntuacio aconseguida: ${widget.puntuacio} / 500",
              style: TextStyle(fontSize: 50),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const Loading()),
                  (route) => false,
                );
              },
              child: Text("Reintentar")
            )
          ],
        ),
      ),
    );
  }
}