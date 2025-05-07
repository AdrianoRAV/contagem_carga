import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'editarpage.dart';
import 'user_data.dart';
class PassagemTurnoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contagem de Carga',

      theme: ThemeData(
        primaryColor: Color(0xFF005ca9),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002D72),
        title:
              Text("CONTAGEM DE CARGA", style: TextStyle(color: Colors.yellow),),

                 actions: [
          Container(
            width: 80, // Largura máxima
            child: Center(
              child: Image.asset(
                'images/logo2.png',
                height: 50, // Altura maior mas que caiba na appBar
                fit: BoxFit.contain,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red,),
            onPressed: () => _sairDoApp(context),
          ),
        ],
        //backgroundColor: Color.fromRGBO(255, 235, 59, 100),
        bottom: TabBar(
          labelColor: Colors.yellow, // Cor para tabs selecionadas
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontSize: 18, // Tamanho da fonte quando selecionado
            fontWeight: FontWeight.w300, // Opcional: negrito
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 16, // Tamanho da fonte quando não selecionado
          ),// Cor para tabs não selecionadas
          controller: _tabController,
          tabs: [
            Tab(text: "Cadastrar", ),
            Tab(text: "Cadastrados"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CadastroPage(),
          CadastradosPage(),
        ],
      ),
    );
  }
}

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

  final List<Map<String, dynamic>> embarques = [];
  final now = DateTime.now();

  final String url = 'http://10.87.199.29/seg/dev/teste_real/salva_dev.php';
  bool _isLoading = false;
  int userId = 1; // ID do usuário logado

  void adicionarLinha() {
    setState(() {
      embarques.add({
        'data_cont': '${DateTime.now()}',
        'hora_cont': '',
        'data_carga': '',
        'tipo_servico': '',
        'tratamento': '',
        'direcao': '',
        'posicao': '',
        'qtd': '',
        'matricula': '${UserData.matricula}',
      });
    });
  }
/*
  Future<void> salvarDados() async {
    if (embarques.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adicione pelo menos uma contagem de carga antes de salvar.')),
      );
      return;
    }

    for (var embarque in embarques) {
      if (embarque.values.any((value) => value.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preencha todos os campos!')),
        );
        return;
      }
      embarque['user_id'] = userId; // Adiciona o user_id
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(embarques),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dados salvos com sucesso!')),
          );
          setState(() {
            embarques.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha na requisição: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dados')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
*/

  Future<void> salvarDados() async {
    if (embarques.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adicione pelo menos uma contagem de carga antes de salvar.')),
      );
      return;
    }

    for (var embarque in embarques) {
      if (embarque.values.any((value) => value.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preencha todos os campos!')),
        );
        return;
      }

      // Verificação das regras específicas
      if (!_validarEmbarque(embarque)) {
        return; // Se a validação falhar, interrompe o salvamento
      }

      embarque['user_id'] = userId; // Adiciona o user_id
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(embarques),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dados salvos com sucesso!')),
          );
          setState(() {
            embarques.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha na requisição: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dados')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Função para validar os dados antes de salvar
  bool _validarEmbarque(Map<String, dynamic> embarque) {
    String? servico = embarque['servico'];
    String? tratamento = embarque['tratamento'];
    String? direcao = embarque['direcao'];

    // Checa o FE
    if (servico == "FE" || servico == "FE_SHOPEE" || servico == "FE_PRIME") {
      if (tratamento != "STES") {
        _mostrarErro("Tratamento permitido: STES.");
        return false;
      }
    }

    // Checa o ERM
    if (tratamento == "ERM") {
      List<String> direcoesPermitidas = ["ERMMIX", "ERMCID", "ERMTTO", "ERMOE"];
      if (!direcoesPermitidas.contains(direcao)) {
        _mostrarErro("Direções permitidas: ERM MIX, ERM CID, ERM TTO e ERM OE.");
        return false;
      }
    }

    // Checa o MALA
    if (tratamento == "MALA" && direcao != "AMALA") {
      _mostrarErro("Direção permitida: A.MALA.");
      return false;
    }

    // Checa o MECANIZADO
    if (tratamento == "MECANIZADO") {
      List<String> tipoDeCargaPermitidos = ["CIDPO", "PL1B", "PL1A", "PL 2", "OEPO", "OEGO", "OE", "RJTGO","PL2","CIDGO"];
      if (!tipoDeCargaPermitidos.contains(direcao)) {
        _mostrarErro("Direções permitidas: CID, BH 35, CEM 1, CEM 2, CEM 3, CEM 4, OE, Rejeito GO e Rejeito PO.");
        return false;
      }
    }

    // Checa o RECONDICIONAMENTO
    if (tratamento == "RECO" && direcao != "RECOND") {
      _mostrarErro("Direção permitida: RECOND.");
      return false;
    }

    // Checa o STES
    if (tratamento == "STES" && direcao != "STES") {
      _mostrarErro("Direção permitida: STES.");
      return false;
    }

    return true; // Se todas as regras passarem, retorna true
  }

// Função para exibir mensagens de erro
  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: adicionarLinha,
              child: Text("Adicionar Contagem de Carga"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFCC00),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: embarques.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Text("Hora: {$now}"),


                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'HORA'),
                        items: [
                          "06:00",
                          "08:00",
                          "12:00",
                          "13:00",
                          "16:00",
                          "18:00",
                          "22:00",

                          // Adicione outros tipos de serviço aqui
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (value) => embarques[index]['hora_cont'] = value,
                      ),

                      TextField(
                        readOnly: true, // Torna o campo somente leitura
                        decoration: InputDecoration(labelText: 'Data da Carga'),
                        onTap: () async {
                          // Chama o seletor de data ao clicar
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          // Atualiza o valor no 'embarques' se uma data for selecionada
                          if (picked != null) {
                            //String formattedDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                            String formattedDate = "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
                            embarques[index]['data_carga'] = formattedDate;// Formato: DD/MM/YYYY
                            setState(() {
                              embarques[index]['data_carga'] = formattedDate;
                              print(formattedDate);// Atualiza a data
                            });
                          }
                        },
                        controller: TextEditingController(text: embarques[index]['data_carga']), // Mostra a data selecionada
                      ),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Tipo de Serviço'),
                        items: [
                          "Express",
                          "Standard",
                          "Prime",
                          "FE",
                          "FE_SHOPEE",
                          "FE_PRIME",
                          // Adicione outros tipos de serviço aqui
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (value) => embarques[index]['tipo_servico'] = value,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Tratamento'),
                        items: [
                          "ERM",
                          "MALA",
                          "MECANIZADO",
                          "RECONDICIONAMENTO",
                          "RECO",
                          "STES",

                          // Adicione outros tipos de serviço aqui
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (value) => embarques[index]['tratamento'] = value,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Direção'),
                        items: [
                          "CIDPO",
                          "CIDGO",
                          "PL1B",
                          "PL1A",
                          "MIX",
                          "OEPO",
                          "OEGO",
                          "OE",
                          "RJTGO",
                          "RECOND",
                          "ERMMIX",
                          "ERMCID",
                          "ERMTTO",
                          "ERMOE",
                          "AMALA",
                          "STES",
                          "PL2",

                          // Adicione outros tipos de serviço aqui
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (value) => embarques[index]['direcao'] = value,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Posição'),
                        items: [
                          "A",
                          "B",
                          "C",
                          "D",
                          "E",
                          "F",
                          "G",
                          // Adicione outros tipos de serviço aqui
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (value) => embarques[index]['posicao'] = value,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Quantidade'),
                        onChanged: (value) => embarques[index]['qtd'] = value,

                      ), Text('Matrícula: ${UserData.matricula}'),

                    ],
                  ),
                ),
              );
            },
          ),
          _isLoading
              ? CircularProgressIndicator()
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: salvarDados,
              child: Text("Salvar Dados"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CadastradosPage extends StatefulWidget {
  @override
  _CadastradosPageState createState() => _CadastradosPageState();
}

class _CadastradosPageState extends State<CadastradosPage> {
  List<Map<String, dynamic>> cadastrados = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    carregarCadastrados();
  }

  Future<void> carregarCadastrados() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final url = Uri.parse('http://10.87.199.29/seg/dev/teste_real/buscar_dev.php?user_id=${UserData.matricula}');
      //print(UserData.matricula);
      // final url = Uri.parse('http://10.87.199.29/seg/buscar_dev.php?user_id=${UserData.matricula}');

      print('Fazendo requisição para: $url'); // Debug

      final response = await http.get(url);
      print('Resposta do servidor: ${response.body}'); // Debug
      print('Status code: ${response.statusCode}'); // Debug

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        print('Número de registros recebidos: ${decodedResponse.length}'); // Debug

        setState(() {
          cadastrados = List<Map<String, dynamic>>.from(decodedResponse);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Erro ao carregar dados: ${response.statusCode} - ${response.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Erro ao carregar dados: $e'); // Debug
      print('Stack trace: $stackTrace'); // Debug
      setState(() {
        error = 'Erro ao carregar dados: $e';
        isLoading = false;
      });
    }
  }

  Future<void> editarDados(String id) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.87.199.29/seg/dev/teste_real/edit.php?id=$id'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados excluídos com sucesso!')),
        );
        carregarCadastrados();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir dados')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir dados: $e')),
      );
    }
  }

  Future<void> excluirDados(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.87.199.29/seg/dev/teste_real/excluir_dev.php?id=$id'),

      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados excluídos com sucesso!')),
        );
        carregarCadastrados();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir dados')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir dados: $e')),
      );
    }
  }
  void _navigateToEdicao(BuildContext context, Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarPage(dados: item),
      ),
    ).then((_) => carregarCadastrados());
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    if (cadastrados.isEmpty) {
      return Center(child: Text('Nenhum registro encontrado'));
    }

    return RefreshIndicator(
      onRefresh: carregarCadastrados,
      child: ListView.builder(
        itemCount: cadastrados.length,
        itemBuilder: (context, index) {
          final item = cadastrados[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              //title:Text("Carga Contada, "),
              title: Text("${index + 1}. Carga Contada"),
              // title: Text('Data: ${item['data_cont']}'),
              //  subtitle: Text('Tipo: ${item['tipo_servico']}'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data da Contagem: ${item['data_cont']}'),
                      Text('Hora: ${item['hora_cont']}'),
                      Text('Data da Carga: ${item['data_carga']}'),
                      Text('Tipo: ${item['tipo_servico']}'),
                      Text('Tratamento: ${item['tratamento']}'),
                      Text('Direção: ${item['direcao']}'),
                      Text('Posição: ${item['posicao']}'),
                      Text('Quantidade: ${item['qtd']}'),
                      Text('Matrícula: ${item['matricula']}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        /*  IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),

                            onPressed: () => _navigateToEdicao(context, item),
                          ),*/
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => excluirDados(item['id'].toString()),

                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(PassagemTurnoApp());
}
Future<void> _sairDoApp(BuildContext context) async {
  final sair = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Fechar aplicativo'),
      content: Text('Deseja realmente sair do aplicativo?'),
      actions: [
        TextButton(
          child: Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text('Sair', style: TextStyle(color: Colors.red)),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (sair == true) {
    SystemNavigator.pop();
  }
}
