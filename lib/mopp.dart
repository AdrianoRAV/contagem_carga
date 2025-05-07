/*import 'package:flutter/material.dart';

void main() {
  runApp(const CorreiosQuizApp());
}

class CorreiosQuizApp extends StatelessWidget {
  const CorreiosQuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Correios Quiz',
      theme: ThemeData(
        primaryColor: const Color(0xFF0047BB),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFEC20B)),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: Color(0xFF0047BB), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF0047BB)),
          labelLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const QuizHomePage(),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({Key? key}) : super(key: key);

  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<Map<String, Object>> _questions = [
    {
      'questionText': 'Os equipamentos e unitizadores estão posicionados nas estações de trabalho e organizados conforme o leiaute previamente definido pela unidade?',
      'answers': [
        {'text': 'Celula 1', 'score': 1},
        {'text': 'SIM', 'score': 0},
        {'text': 'NÃO', 'score': 0},
        {'text': 'NÂO SE APLICA', 'score': 0},
        {'text': 'Tirar Foto', 'score': 0},
      ],
    },
    {
      'questionText': 'A carga é movimentada conforme previsto?',
      'answers': [
        {'text': 'Celula 1', 'score': 1},
        {'text': 'SIM', 'score': 0},
        {'text': 'NÃO', 'score': 0},
        {'text': 'NÂO SE APLICA', 'score': 0},
        {'text': 'Tirar Foto', 'score': 0},
      ],
    },
    // Adicione mais perguntas conforme necessário
  ];

  void _answerQuestion(int score) {
    setState(() {
      _score += score;
      _currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correios Quiz'),
        backgroundColor: const Color(0xFF0047BB),
      ),
      body: _currentQuestionIndex < _questions.length
          ? Quiz(
              question: _questions[_currentQuestionIndex]['questionText'] as String,
              answers: (_questions[_currentQuestionIndex]['answers'] as List<Map<String, Object>>),
              answerQuestion: _answerQuestion,
            )
          : Result(_score, _questions.length),
    );
  }
}

class Quiz extends StatelessWidget {
  final String question;
  final List<Map<String, Object>> answers;
  final Function answerQuestion;

  const Quiz({
    Key? key,
    required this.question,
    required this.answers,
    required this.answerQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          question,
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ...answers.map((answer) {
          return AnswerButton(
            answerText: answer['text'] as String,
            selectHandler: () => answerQuestion(answer['score']),
          );
        }).toList(),
      ],
    );
  }
}

class AnswerButton extends StatelessWidget {
  final String answerText;
  final VoidCallback selectHandler;

  const AnswerButton({Key? key, required this.answerText, required this.selectHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF0047BB), backgroundColor: const Color(0xFFFEC20B),
        ),
        child: Text(answerText),
        onPressed: selectHandler,
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const Result(this.score, this.totalQuestions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Quiz Concluído!',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          Text(
            'Você acertou $score de $totalQuestions perguntas!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';

void main() {
  runApp(const CorreiosChecklistApp());
}

class CorreiosChecklistApp extends StatelessWidget {
  const CorreiosChecklistApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Correios Checklist',
      theme: ThemeData(
        primaryColor: const Color(0xFF0047BB),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFEC20B)),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: Color(0xFF0047BB), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF0047BB)),
          labelLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const ChecklistHomePage(),
    );
  }
}

class ChecklistHomePage extends StatefulWidget {
  const ChecklistHomePage({Key? key}) : super(key: key);

  @override
  _ChecklistHomePageState createState() => _ChecklistHomePageState();
}

class _ChecklistHomePageState extends State<ChecklistHomePage> {
  String? _selectedCell;
  final _observationController = TextEditingController();

  final List<String> _cells = ['Célula 1', 'Célula 2', 'Célula 3', 'Célula 4'];

  void _submitForm() {
    // Aqui você pode adicionar a lógica para enviar as respostas do checklist
    final selectedCell = _selectedCell;
    final observation = _observationController.text;

    // Exemplo de impressão dos valores
    print('Célula selecionada: $selectedCell');
    print('Observações: $observation');
  }

  Future<void> _takePhoto() async {
    // Aqui você pode adicionar a lógica para tirar foto
    print('Tirar foto');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correios Checklist'),
        backgroundColor: const Color(0xFF0047BB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Os equipamentos e unitizadores estão posicionados nas estações de trabalho e organizados conforme o leiaute previamente definido pela unidade?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Selecione a célula',
                border: OutlineInputBorder(),
              ),
              value: _selectedCell,
              items: _cells.map((cell) {
                return DropdownMenuItem<String>(
                  value: cell,
                  child: Text(cell),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCell = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF0047BB), backgroundColor: const Color(0xFFFEC20B),
              ),
              child: const Text('SIM'),
              onPressed: () {
                _submitForm();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF0047BB), backgroundColor: const Color(0xFFFEC20B),
              ),
              child: const Text('NÃO'),
              onPressed: () {
                _submitForm();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF0047BB), backgroundColor: const Color(0xFFFEC20B),
              ),
              child: const Text('NÃO SE APLICA'),
              onPressed: () {
                _submitForm();
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _observationController,
              decoration: const InputDecoration(
                labelText: 'Observações',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF0047BB), backgroundColor: const Color(0xFFFEC20B),
              ),
              child: const Text('Tirar Foto'),
              onPressed: _takePhoto,
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const CorreiosChecklistApp());
}

class CorreiosChecklistApp extends StatelessWidget {
  const CorreiosChecklistApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Correios Checklist',
      theme: ThemeData(
        primaryColor: const Color(0xFF0047BB),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFEC20B)),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: Color(0xFF0047BB), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF0047BB)),
          labelLarge: TextStyle(color: Colors.white),
        ),
      ),
      home:  ChecklistHomePage(),
    );
  }
}

class ChecklistHomePage extends StatefulWidget {
   ChecklistHomePage({Key? key}) : super(key: key);

  @override
  _ChecklistHomePageState createState() => _ChecklistHomePageState();
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Aqui você pode adicionar a lógica para salvar ou exibir a foto capturada
      print('Foto capturada: ${photo.path}');
    }
  }
}

class _ChecklistHomePageState extends State<ChecklistHomePage> {
  String? _selectedCell;
  final _observationController = TextEditingController();

  final List<String> _cells = ['Célula 1', 'Célula 2', 'Célula 3', 'Célula 4'];

  void _submitForm() {
    // Aqui você pode adicionar a lógica para enviar as respostas do checklist
    final selectedCell = _selectedCell;
    final observation = _observationController.text;

    // Exemplo de impressão dos valores
    print('Célula selecionada: $selectedCell');
    print('Observações: $observation');
  }

  Future<void> _takePhoto() async {
    // Aqui você pode adicionar a lógica para tirar foto
    print('Tirar foto');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correios MOPPP'),
        backgroundColor: const Color(0xFF0047BB),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Os equipamentos e unitizadores estão posicionados nas estações de trabalho e organizados conforme o leiaute previamente definido pela unidade?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Selecione a célula',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCell,
                items: _cells.map((cell) {
                  return DropdownMenuItem<String>(
                    value: cell,
                    child: Text(cell),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCell = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF0047BB), backgroundColor: const Color(0xFFFEC20B),
                ),
                child: const Text('SIM'),
                onPressed: () {
                  _submitForm();
                },
              ),
              const SizedBox(height: 10), // Adiciona um espaçamento de 10 pixels
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF0047BB), backgroundColor: const Color(0xFFFEC20B),
                ),
                child: const Text('NÃO'),
                onPressed: () {
                  _submitForm();
                },
              ),
              const SizedBox(height: 10), // Adiciona um espaçamento de 10 pixels
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF0047BB), backgroundColor: const Color(0xFFFEC20B),
                ),
                child: const Text('NÃO SE APLICA'),
                onPressed: () {
                  _submitForm();
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF0047BB), backgroundColor: const Color(0xFFFEC20B),
                ),
                child: const Text('Tirar Foto'),
                onPressed: _takePhoto,
              ),
              const SizedBox(height: 35),
              TextField(
                controller: _observationController,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const CorreiosChecklistApp());
}

class CorreiosChecklistApp extends StatelessWidget {
  const CorreiosChecklistApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Correios Checklist',
      theme: ThemeData(
        primaryColor: const Color(0xFF0047BB),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFFFEC20B)),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge:
              TextStyle(color: Color(0xFF0047BB), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF0047BB)),
          labelLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const ChecklistHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChecklistHomePage extends StatefulWidget {
  const ChecklistHomePage({Key? key}) : super(key: key);

  @override
  _ChecklistHomePageState createState() => _ChecklistHomePageState();
}

class _ChecklistHomePageState extends State<ChecklistHomePage> {
  String? _selectedCell;
  final _observationController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final List<String> _cells = ['Célula 1', 'Célula 2', 'Célula 3', 'Célula 4'];

  void _submitForm() {
    // Aqui você pode adicionar a lógica para enviar as respostas do checklist
    final selectedCell = _selectedCell;
    final observation = _observationController.text;

    // Exemplo de impressão dos valores
    print('Célula selecionada: $selectedCell');
    print('Observações: $observation');
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Aqui você pode adicionar a lógica para salvar ou exibir a foto capturada
      print('Foto capturada: ${photo.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Correios MOPPP',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0047BB),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Os equipamentos e unitizadores estão posicionados nas estações de trabalho e organizados conforme o leiaute previamente definido pela unidade?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Selecione a célula',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCell,
                items: _cells.map((cell) {
                  return DropdownMenuItem<String>(
                    value: cell,
                    child: Text(cell),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCell = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF0047BB),
                  backgroundColor: const Color(0xFFFEC20B),
                ),
                child: const Text('SIM'),
                onPressed: () {
                  _submitForm();
                },
              ),
              const SizedBox(
                  height: 10), // Adiciona um espaçamento de 10 pixels
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF0047BB),
                  backgroundColor: const Color(0xFFFEC20B),
                ),
                child: const Text('NÃO'),
                onPressed: () {
                  _submitForm();
                },
              ),
              const SizedBox(
                  height: 10), // Adiciona um espaçamento de 10 pixels
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF0047BB),
                  backgroundColor: const Color(0xFFFEC20B),
                ),
                child: const Text('NÃO SE APLICA'),
                onPressed: () {
                  _submitForm();
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF0047BB),
                  backgroundColor: const Color(0xFFFEC20B),
                ),
                child: const Text('Tirar Foto'),
                onPressed: _takePhoto,
              ),
              const SizedBox(height: 35),
              TextField(
                controller: _observationController,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
