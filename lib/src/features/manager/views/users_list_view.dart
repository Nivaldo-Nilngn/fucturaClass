import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_spacing.dart';
import '../services/user_management_service.dart';
import 'user_form_view.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  final UserManagementService _service = UserManagementService();
  bool _isLoading = true;
  List<AppUser> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      // Por simplicidade, carrega os estudantes (o painel pode filtrar depois)
      final students = await _service.getUsersByRole(UserRole.student);
      final professors = await _service.getUsersByRole(UserRole.professor);
      
      setState(() {
        _users = [...students, ...professors];
      });
    } catch (e) {
      debugPrint("Erro ao carregar: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Usuários (Firebase)', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormView()),
          );
          if (result == true) {
            _loadUsers();
          }
        },
        label: const Text('Novo Usuário'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum usuário encontrado no Firebase.',
                    style: GoogleFonts.nunitoSans(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(user.name.substring(0, 1).toUpperCase()),
                        ),
                        title: Text(user.name, style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
                        subtitle: Text('CPF: ${user.cpf} • ${user.role.name.toUpperCase()}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Mostrar detalhes
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
