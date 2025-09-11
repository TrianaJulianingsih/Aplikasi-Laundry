// import 'package:flutter/material.dart';
// import 'package:laundry_jaya/api/orders.dart';

// class StatusScreen extends StatefulWidget {
//   const StatusScreen({super.key});

//   @override
//   State<StatusScreen> createState() => _StatusScreenState();
// }

// class _StatusScreenState extends State<StatusScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _statusController = TextEditingController();
//   @override
//   Future<void> _simpanStatus() async {
//     if (_formKey.currentState!.validate() &&
//         _selectedCategoryId != null &&
//         _selectedServiceTypeId != null) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         final result = await OrdersAPI.changeStatus(
//           status: _statusController.text,
//           price: int.parse(_hargaController.text),
//           categoryId: _selectedCategoryId!,
//           serviceTypeId: _selectedServiceTypeId!,
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(result.message ?? "Item berhasil ditambahkan"),
//           ),
//         );

//         _namaController.clear();
//         _hargaController.clear();
//         setState(() {
//           _selectedCategoryId = null;
//           _selectedServiceTypeId = null;
//           _layananFuture = null;
//         });
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(e.toString())));
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
