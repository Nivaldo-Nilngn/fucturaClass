import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_model/profile_view_model.dart';
import '../../../core/theme/app_spacing.dart';

class ProfileCompletionView extends ConsumerStatefulWidget {
  const ProfileCompletionView({super.key});

  @override
  ConsumerState<ProfileCompletionView> createState() => _ProfileCompletionViewState();
}

class _ProfileCompletionViewState extends ConsumerState<ProfileCompletionView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _financialRespController = TextEditingController();
  final _legalRespController = TextEditingController();

  DateTime? _selectedBirthDate;

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _motherNameController.dispose();
    _fatherNameController.dispose();
    _financialRespController.dispose();
    _legalRespController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF0055FF),
              onPrimary: Colors.white,
              surface: Color(0xFF252538),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione a Data de Nascimento')));
      return;
    }

    try {
      await ref.read(profileViewModelProvider.notifier).updateProfile(
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
        email: _emailController.text,
        birthDate: _selectedBirthDate!,
        motherName: _motherNameController.text,
        fatherName: _fatherNameController.text,
        financialResponsible: _financialRespController.text,
        legalResponsible: _legalRespController.text,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil completo! Você ganhou +100 XP! 🚀'),
            backgroundColor: Color(0xFF00E1AB),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: const Color(0xFFFF5C5C),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileViewModelProvider);
    final primaryColor = const Color(0xFF0055FF);
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isDesktop ? 32 : 16),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 800 : 600),
            child: Container(
              padding: EdgeInsets.all(isDesktop ? 40 : 16),
              decoration: BoxDecoration(
                color: const Color(0xFF252538),
                borderRadius: BorderRadius.circular(isDesktop ? 24 : 0),
                border: isDesktop ? Border.all(color: primaryColor.withOpacity(0.3), width: 1.5) : null,
                boxShadow: isDesktop
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        )
                      ]
                    : [],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Icon(Icons.stars, color: const Color(0xFFFFD700), size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Complete seu Perfil',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preencha seus dados para completar seu cadastro e ganhar +100 Pontos de Experiência na plataforma!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Sessão 1: Dados Pessoais
                    Text('Dados Pessoais', style: GoogleFonts.poppins(color: primaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildResponsiveRow(
                      _buildTextField(
                        controller: _emailController,
                        label: 'E-mail Pessoal',
                        icon: Icons.email_outlined,
                        primaryColor: primaryColor,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Telefone',
                        icon: Icons.phone_outlined,
                        primaryColor: primaryColor,
                        keyboardType: TextInputType.phone,
                      ),
                      isDesktop,
                    ),
                    const SizedBox(height: 16),
                    _buildResponsiveRow(
                      _buildTextField(
                        controller: _birthDateController,
                        label: 'Data de Nascimento',
                        icon: Icons.calendar_today_outlined,
                        primaryColor: primaryColor,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      _buildTextField(
                        controller: _cityController,
                        label: 'Cidade',
                        icon: Icons.location_city_outlined,
                        primaryColor: primaryColor,
                      ),
                      isDesktop,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Endereço Completo',
                      icon: Icons.home_outlined,
                      primaryColor: primaryColor,
                    ),
                    
                    const SizedBox(height: 32),
                    // Sessão 2: Filiação e Responsáveis
                    Text('Filiação e Responsáveis', style: GoogleFonts.poppins(color: primaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildResponsiveRow(
                      _buildTextField(
                        controller: _motherNameController,
                        label: 'Nome da Mãe',
                        icon: Icons.person_3_outlined,
                        primaryColor: primaryColor,
                      ),
                      _buildTextField(
                        controller: _fatherNameController,
                        label: 'Nome do Pai',
                        icon: Icons.person_outlined,
                        primaryColor: primaryColor,
                      ),
                      isDesktop,
                    ),
                    const SizedBox(height: 16),
                    _buildResponsiveRow(
                      _buildTextField(
                        controller: _legalRespController,
                        label: 'Responsável Legal',
                        icon: Icons.gavel_outlined,
                        primaryColor: primaryColor,
                      ),
                      _buildTextField(
                        controller: _financialRespController,
                        label: 'Responsável Financeiro',
                        icon: Icons.attach_money_outlined,
                        primaryColor: primaryColor,
                      ),
                      isDesktop,
                    ),

                    const SizedBox(height: 40),
                    if (isDesktop)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(
                              'Preencher mais tarde',
                              style: GoogleFonts.poppins(color: Colors.white54),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: _buildSubmitButton(isLoading, primaryColor),
                          ),
                        ],
                      )
                    else ...[
                      SizedBox(
                        height: 50,
                        child: _buildSubmitButton(isLoading, primaryColor),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'Preencher mais tarde',
                          style: GoogleFonts.poppins(color: Colors.white54),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading, Color primaryColor) {
    return ElevatedButton(
      onPressed: isLoading ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : Text(
              'Salvar Perfil (+100 XP)',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildResponsiveRow(Widget child1, Widget child2, bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: child1),
          const SizedBox(width: 16),
          Expanded(child: child2),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child1,
          const SizedBox(height: 16),
          child2,
        ],
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color primaryColor,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(color: Colors.white),
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
    );
  }
}
