// File: views/status_screen.dart
import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/orders.dart';
import 'package:laundry_jaya/models/change_status_model.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({
    super.key,
    required this.orderId,
    required this.currentStatus,
  });

  static const id = "/status";

  final int orderId;
  final String currentStatus;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _statusController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _statusController = TextEditingController(text: widget.currentStatus);
  }

  @override
  void dispose() {
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _simpanStatus() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      ChangeStatusModel response = await OrdersAPI.changeStatus(
        orderId: widget.orderId,
        status: _statusController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Status berhasil diubah")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal ubah status: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubah Status"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(
                  labelText: "Status Pesanan",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Status wajib diisi"
                    : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _simpanStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text("Simpan"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
