import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_data.dart';


class EditarPage extends StatefulWidget {
  final Map<String, dynamic> dados;

  EditarPage({required this.dados});

  @override
  _EditarPageState createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {
  late TextEditingController _dataContController;
  late TextEditingController _horaContController;
  late TextEditingController _dataCargaController;
  late TextEditingController _qtdController;

  String? _tipoServico;
  String? _tratamento;
  String? _direcao;
  String? _posicao;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _dataContController = TextEditingController(text: widget.dados['data_cont']);
    _horaContController = TextEditingController(text: widget.dados['hora_cont']);
    _dataCargaController = TextEditingController(text: widget.dados['data_carga']);
    _qtdController = TextEditingController(text: widget.dados['qtd']);

    _tipoServico = widget.dados['tipo_servico'];
    _tratamento = widget.dados['tratamento'];
    _direcao = widget.dados['direcao'];
    _posicao = widget.dados['posicao'];
  }

  Future<void> _salvarEdicao() async {
    setState(() => _isLoading = true);

    // Função para converter string no formato "dd/MM/yyyy" para DateTime
    DateTime? _parseDate(String dateString) {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      return null; // Retorna null se o formato estiver errado
    }

    // Convertendo a data de contagem
    DateTime? dataCont = _parseDate(_dataContController.text);

    // Mantendo a data da carga existente se não for fornecida nova data
    DateTime? dataCarga = _dataCargaController.text.isNotEmpty
        ? _parseDate(_dataCargaController.text)
        : DateTime.parse(widget.dados['data_carga']); // Mantém a data antiga

    final Map<String, dynamic> dadosAtualizados = {
      'id': widget.dados['id'],
      'data_cont': dataCont?.toIso8601String(),
      'hora_cont': _horaContController.text,
      'data_carga': dataCarga?.toIso8601String(),
      'tipo_servico': _tipoServico,
      'tratamento': _tratamento,
      'direcao': _direcao,
      'posicao': _posicao,
      'qtd': _qtdController.text,
    };

    try {
      final response = await http.put(
        Uri.parse('http://10.87.199.29/seg/dev/teste_real/edit.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dadosAtualizados),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Registro')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDateField('Data de Contagem', _dataContController),
            _buildTextField('Hora de Contagem', _horaContController),
            _buildDateField('Data da Carga', _dataCargaController),
            _buildDropdown('Tipo de Serviço', [
              "Express",
              "Standard",
              "Prime",
              "FE",
              "FE_SHOPEE",
              "FE_PRIME"
            ], _tipoServico, (value) => _tipoServico = value),
            _buildDropdown('Tratamento', [
              "ERM",
              "MALA",
              "MECANIZADO",
              "RECONDICIONAMENTO",
              "RECO",
              "STES"
            ], _tratamento, (value) => _tratamento = value),
            _buildDropdown('Direção', [
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
              "PL2"
            ], _direcao, (value) => _direcao = value),
            _buildDropdown('Posição', [
              "A",
              "B",
              "C",
              "D",
              "E",
              "F",
              "G"
            ], _posicao, (value) => _posicao = value),
            _buildTextField('Quantidade', _qtdController),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _salvarEdicao,
              child: Text('Salvar Alterações'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(labelText: label),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
        }
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}