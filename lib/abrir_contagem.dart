import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'card.dart';
import 'user_data.dart';

class Globalnumber {
  static String? number_hora;
}

class AbrirContagemPage extends StatefulWidget {
  @override
  _AbrirContagemPageState createState() => _AbrirContagemPageState();
}

class _AbrirContagemPageState extends State<AbrirContagemPage> {
  String? selectedHora;
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  final List<String> horarios = [
    "06:00",
    "08:00",
    "12:00",
    "13:00",
    "16:00",
    "18:00",
    "22:00",
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> verificarEAbrirContagem() async {
    if (selectedHora == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione um horário')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Formatação da data
      String formattedDate =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      // Remove espaços em branco do horário
      String formattedHora = selectedHora!.trim();

      // Construção da URL corretamente codificada ------------- OK para abrir
      final uri = Uri.http('10.87.199.29', '/seg/dev/teste_real/abrir_contagem_dev.php', {
        'data': formattedDate,
        'hora': formattedHora,
        'matricula': UserData.matricula
      });
     // ------------------------------------------------------------------------
      print('Fazendo requisição para: $uri'); // Debug

      final response = await http.get(uri).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('A conexão expirou');
        },
      );

      print('Status code: ${response.statusCode}'); // Debug
      print('Resposta: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        String result = response.body.trim();

        switch (result) {
          case "result1":
            _mostrarMensagem('Erro ao abrir contagem');
            break;
          case "result2":
            _mostrarMensagem('Contagem aberta com sucesso');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PassagemTurnoApp()),
            );
            break;
          case "result3":
            _mostrarMensagem('Contagem aberta com sucesso');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PassagemTurnoApp()),
            );
            // _mostrarMensagem('Contagem aberta com sucesso');
            //  Navigator.pushReplacement(
            //    context,
            //     MaterialPageRoute(builder: (context) => PassagemTurnoApp()),);
            //_mostrarMensagem('Contagem Fechada');
            break;
          case "result4":
            _mostrarMensagem('Já existe uma contagem aberta');
            break;
          default:
            _mostrarMensagem('Resposta inesperada: $result');
        }
      } else {
        _mostrarMensagem('Erro no servidor: ${response.statusCode}');
      }
    } on TimeoutException {
      _mostrarMensagem('A conexão expirou. Tente novamente.');
    } catch (e) {
      print('Erro detalhado: $e'); // Debug
      _mostrarMensagem('Erro ao verificar contagem: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Abrir Contagem',style: TextStyle(color:Colors.yellow),),
        backgroundColor: Color(0xFF005ca9),
       // backgroundColor: const Color(0xFF0047BB),

      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                title: Text(
                    'Data: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Horário',
                    border: InputBorder.none,
                  ),
                  value: selectedHora,
                  items: horarios.map((hora) {
                    return DropdownMenuItem(
                      value: hora,
                      child: Text(hora),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedHora = value;
                      Globalnumber.number_hora = selectedHora;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: isLoading ? null : verificarEAbrirContagem,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Abrir Contagem',style: TextStyle(color:Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
