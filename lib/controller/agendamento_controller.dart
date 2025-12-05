import '../model/agendamento.dart';

class AgendamentoController {
  // Padrão Singleton: Garante que a lista seja a mesma em todo o app
  static final AgendamentoController _instance = AgendamentoController._internal();
  factory AgendamentoController() => _instance;
  AgendamentoController._internal();

  // Nossa "Base de Dados" na memória
  final List<Agendamento> _agendamentos = [
    // Dados inicias de exemplo (Mock)
    Agendamento(
      data: "15/12/2024", 
      coletor: "João Silva", 
      material: "Papel",
      status: "Confirmado"
    ),
  ];

  // Retorna a lista de agendamentos
  List<Agendamento> get lista => _agendamentos;

  // Adiciona um novo agendamento
  void adicionar(Agendamento agendamento) {
    _agendamentos.add(agendamento);
  }

  // Remove um agendamento
  void remover(Agendamento agendamento) {
    _agendamentos.remove(agendamento);
  }
}