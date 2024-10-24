import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coeur_artificiel/gamepage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String ia1Difficulty = 'Easy';
  String ia1Type = 'Neural Network';
  String ia2Difficulty = 'Easy';
  String ia2Type = 'Neural Network';
  String ia3Difficulty = 'Easy';
  String ia3Type = 'Neural Network';
  TextEditingController numberOfRoundsController = TextEditingController();

  void sendInitializationRequest() async {
    final roundsInput = numberOfRoundsController.text;
    final errorMessage = validateNumberOfRounds(roundsInput);
    if (errorMessage != null) {
      // Afficher une alerte ou un toast pour notifier l'utilisateur de l'erreur
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Erreur"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final int numberOfRounds = int.parse(roundsInput);
    // Assurez-vous d'ajouter numberOfRounds à votre corps de requête si nécessaire

    final Map<String, dynamic> requestBody = {
      "ia_players": [
        {"id": 1, "type": ia1Type, "difficulte": ia1Difficulty},
        {"id": 2, "type": ia2Type, "difficulte": ia2Difficulty},
        {"id": 3, "type": ia3Type, "difficulte": ia3Difficulty},
      ]
    };

    final String requestBodyJson = json.encode(requestBody);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/initialisation'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GamePage(numberOfRoundsEnteredByUser: numberOfRounds),
          ),
        );
      } else {
        print(
            "Erreur lors de la requête d'initialisation : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors de la requête d'initialisation : $e");
    }
  }

  String? validateNumberOfRounds(String value) {
    if (value.isEmpty) {
      return 'Veuillez entrer un nombre';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Veuillez entrer un nombre valide';
    }
    if (number < 1 || number > 10) {
      return 'Le nombre doit être entre 1 et 10';
    }
    return null; // L'entrée est valide
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SETTINGS"),
        backgroundColor: Colors.red[700],
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/5120953.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  buildIaSection(1),
                  const SizedBox(height: 20),
                  buildIaSection(2),
                  const SizedBox(height: 20),
                  buildIaSection(3),
                  const SizedBox(height: 20),
                  buildNumberOfRoundsInput(),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: sendInitializationRequest,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700]),
                    child: const Text("Start the game!",
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIaSection(int number) {
    String iaDifficulty;
    String iaType;

    switch (number) {
      case 1:
        iaDifficulty = ia1Difficulty;
        iaType = ia1Type;
        break;
      case 2:
        iaDifficulty = ia2Difficulty;
        iaType = ia2Type;
        break;
      case 3:
        iaDifficulty = ia3Difficulty;
        iaType = ia3Type;
        break;
      default:
        return Container();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Intelligence Artificielle $number',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: iaDifficulty,
            onChanged: (String? newValue) {
              setState(() {
                switch (number) {
                  case 1:
                    ia1Difficulty = newValue!;
                    break;
                  case 2:
                    ia2Difficulty = newValue!;
                    break;
                  case 3:
                    ia3Difficulty = newValue!;
                    break;
                }
              });
            },
            items: <String>['Easy', 'Hard']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: iaType,
            onChanged: (String? newValue) {
              setState(() {
                switch (number) {
                  case 1:
                    ia1Type = newValue!;
                    break;
                  case 2:
                    ia2Type = newValue!;
                    break;
                  case 3:
                    ia3Type = newValue!;
                    break;
                }
              });
            },
            items: <String>['Neural Network', 'MCTS']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildNumberOfRoundsInput() {
    return Container(
      padding: const EdgeInsets.only(
          top: 8.0, bottom: 8.0), // Ajustement pour l'espacement vertical
      child: TextField(
        controller: numberOfRoundsController,
        style: const TextStyle(
          color: Colors.black, // Couleur du texte
          fontSize: 18, // Taille du texte
        ),
        decoration: InputDecoration(
          labelText: 'Nombre de Rounds',
          hintText: 'Entrez un nombre entre 1 et 10',
          // Personnalisation de l'apparence du bord du TextField
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white, // Couleur du bord
              width: 1, // Épaisseur du bord
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors
                  .white, // Couleur du bord quand le TextField est actif mais non focalisé
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  Colors.red, // Couleur du bord quand le TextField est focalisé
              width: 2,
            ),
          ),
          // Couleur du texte pour le labelText et hintText
          labelStyle: const TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.75)),
          // Couleur de fond du TextField
          fillColor: Colors.white70,
          filled: true, // Activation de la couleur de fond
          errorText: numberOfRoundsController.text.isEmpty
              ? null
              : validateNumberOfRounds(numberOfRoundsController.text),
        ),
        keyboardType: TextInputType.number,
        // Gestionnaire de soumission pour la validation et l'action
        onSubmitted: (_) => sendInitializationRequest(),
      ),
    );
  }

  @override
  void dispose() {
    numberOfRoundsController.dispose();
    super.dispose();
  }
}
