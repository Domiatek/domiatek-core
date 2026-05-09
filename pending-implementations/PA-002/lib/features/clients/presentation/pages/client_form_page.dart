import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/client_form_bloc.dart';

class ClientFormPage extends StatefulWidget {
  const ClientFormPage({super.key, this.clientId});

  final int? clientId;

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _dniNieCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _notasCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ClientFormBloc>().add(ClientFormLoaded(widget.clientId));
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidosCtrl.dispose();
    _telefonoCtrl.dispose();
    _emailCtrl.dispose();
    _dniNieCtrl.dispose();
    _direccionCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  void _populate(client) {
    _nombreCtrl.text = client.nombre;
    _apellidosCtrl.text = client.apellidos;
    _telefonoCtrl.text = client.telefono;
    _emailCtrl.text = client.email ?? '';
    _dniNieCtrl.text = client.dniNie ?? '';
    _direccionCtrl.text = client.direccion ?? '';
    _notasCtrl.text = client.notas ?? '';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ClientFormBloc>().add(
          ClientFormSaveRequested(
            nombre: _nombreCtrl.text,
            apellidos: _apellidosCtrl.text,
            telefono: _telefonoCtrl.text,
            email: _emailCtrl.text,
            dniNie: _dniNieCtrl.text,
            direccion: _direccionCtrl.text,
            notas: _notasCtrl.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientFormBloc, ClientFormState>(
      listener: (context, state) {
        if (state is ClientFormReady && state.client != null) {
          _populate(state.client!);
        }
        if (state is ClientFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.clientId == null
                    ? 'Cliente creado correctamente'
                    : 'Cliente actualizado',
              ),
            ),
          );
          context.pop();
        }
        if (state is ClientFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state is ClientFormLoading || state is ClientFormSaving;
        final isEditing = widget.clientId != null;

        return Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? 'Editar cliente' : 'Nuevo cliente'),
            actions: [
              if (!isLoading)
                TextButton(
                  onPressed: _submit,
                  child: const Text('Guardar'),
                ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _Field(
                              controller: _nombreCtrl,
                              label: 'Nombre *',
                              validator: _required,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _Field(
                              controller: _apellidosCtrl,
                              label: 'Apellidos *',
                              validator: _required,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _Field(
                        controller: _telefonoCtrl,
                        label: 'Teléfono *',
                        validator: _required,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      _Field(
                        controller: _emailCtrl,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: _optionalEmail,
                      ),
                      const SizedBox(height: 12),
                      _Field(
                        controller: _dniNieCtrl,
                        label: 'DNI / NIE',
                        textCapitalization: TextCapitalization.characters,
                      ),
                      const SizedBox(height: 12),
                      _Field(
                        controller: _direccionCtrl,
                        label: 'Dirección',
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 12),
                      _Field(
                        controller: _notasCtrl,
                        label: 'Notas',
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _submit,
                        child: Text(isEditing ? 'Actualizar' : 'Crear cliente'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null;

  String? _optionalEmail(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final re = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return re.hasMatch(v.trim()) ? null : 'Email no válido';
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
    );
  }
}
