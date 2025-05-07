import 'dart:convert'; // Para manipular JSON
import 'package:contagem_carga/card.dart';
import 'package:contagem_carga/splash.dart';
import 'package:contagem_carga/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'abrir_contagem.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',



      //home: LoginScreen(),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    final String url =
        'http://10.87.199.29/seg/dev/teste_real/login_dev.php'; // URL da API PHP ---- OK
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'matricula': _matriculaController.text,
          'senha': _senhaController.text,
        },
      );

      if (response.statusCode == 200) {
        switch (response.body.trim()) {
          case '1':
            setState(() {
              _errorMessage = "Usuário não encontrado - Use a Mesma senha do SCI.";
            });
            break;
          case '2':
            setState(() {
              _errorMessage = "Senha errada - Use a Mesma senha do SCI.";
            });
            break;
          case '3':
            setState(() {
              _errorMessage = "";
            });
            UserData.matricula = _matriculaController.text;
            // Navegar para outra página após o login bem-sucedido
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => PassagemTurnoApp()),
              MaterialPageRoute(
                builder: (context) => AbrirContagemPage(),
              ),
            );
            break;
          default:
            setState(() {
              _errorMessage = "Erro inesperado: ${response.body}";
              print(response.body);
              print(_errorMessage);
            });
        }
      } else {
        setState(() {
          _errorMessage = "Erro ao se conectar à API.";
          print(_errorMessage);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Erro: $e";
        print(_errorMessage);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Login',style: TextStyle(color: Colors.yellow,fontSize: 25,),),

        actions: [
          IconButton(
            icon: Icon(Icons.info,color: Colors.yellow,),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],

          backgroundColor: Color(0xFF002D72),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon(Icons.business, size: 200, color: Color(0xFF002D72),),
            //Text('Contagem de Carga',style: TextStyle(fontSize: 25, color: Colors.blue),),
            //Text('Contagem de Carga',style: TextStyle(fontSize: 25, color: Colors.blue),),
            Image.asset(
              'images/logo.png', // Caminho para a imagem
              width: 300, // Largura da imagem
              height: 300, // Altura da imagem
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _matriculaController,
                decoration: InputDecoration(
                    labelText: 'Matrícula', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _senhaController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Senha SCI',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text(
                      'Entrar',
                     // style: TextStyle(color: Colors.white, fontSize: 18),
                      style: TextStyle(color: Color(0xFFF6EB61), fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF002D72),
                      //backgroundColor: Colors.blue,
                      minimumSize: Size(800, 50),
                    ),
                  ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
void _showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[800]),
              SizedBox(width: 10),
              Text(
                'Sobre o App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Versão
              _buildInfoRow(
                icon: Icons.apps,
                label: 'Versão:',
                value: '1.0.0',
              ),

              SizedBox(height: 16),

              // Descrição
              Text(
                'Descrição:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Solução integrada ao programa SCI para contagem e registro de carga, agilizando processos e reduzindo erros manuais.',
                style: TextStyle(color: Colors.grey[700]),
              ),

              SizedBox(height: 16),

              // Funcionalidades
              Text(
                'Principais funcionalidades:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              _buildFeatureItem('Integração direta com o SCI'),
              _buildFeatureItem('Contagem rápida de carga'),
              _buildFeatureItem('Registro automático dos dados'),
              _buildFeatureItem('Interface intuitiva'),

              SizedBox(height: 16),

              // Desenvolvedor
              _buildInfoRow(
                icon: Icons.person,
                label: 'Desenvolvedor:',
                value: 'Adriano Rodrigues',
              ),
              Padding(
                padding: EdgeInsets.only(left: 34),
                child: Text(
                  'Matrícula: 84246626',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'FECHAR',
              style: TextStyle(color: Colors.blue[800]),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// Método auxiliar para construir linhas de informação
Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: Colors.blue[700]),
      SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    ],
  );
}

// Método auxiliar para itens da lista
Widget _buildFeatureItem(String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_right, size: 16, color: Colors.blue),
        SizedBox(width: 4),
        Expanded(child: Text(text)),
      ],
    ),
  );
}