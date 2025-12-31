import 'package:flutter/material.dart';
import '../../../data/datasources/service_local_datasource.dart';

class ServiceInputField extends StatefulWidget {
  final TextEditingController controller;

  const ServiceInputField({super.key, required this.controller});

  @override
  State<ServiceInputField> createState() => _ServiceInputFieldState();
}

class _ServiceInputFieldState extends State<ServiceInputField> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Service You Provide",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            readOnly: loading,
            onTap: _fetchServices,
            validator: (v) => v!.isEmpty ? "Enter or select service" : null,
            decoration: InputDecoration(
              hintText: loading
                  ? "Fetching services..."
                  : "Type or select service",
              prefixIcon: const Icon(Icons.build_outlined),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchServices() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));

    final services = await ServiceLocalDatasource().getServices();
    setState(() => loading = false);

    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        children: services
            .map(
              (s) => ListTile(
                title: Text(s),
                onTap: () {
                  widget.controller.text = s;
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
