// // File: views/order_management_screen.dart
// import 'package:flutter/material.dart';
// import 'package:laundry_jaya/api/orders.dart';
// import 'package:laundry_jaya/models/change_status_model.dart';
// import 'package:laundry_jaya/models/get_order_model.dart';

// class LihatPesananScreen extends StatefulWidget {
//   const LihatPesananScreen({super.key});
//   static const id = "/orderManagement";

//   @override
//   State<LihatPesananScreen> createState() => _LihatPesananScreenState();
// }

// class _LihatPesananScreenState extends State<LihatPesananScreen> {
//   late Future<ChangeStatusModel> _orderFuture;

//   @override
//   void initState() {
//     super.initState();
//     _loadOrders();
//   }

//   void _loadOrders() {
//     setState(() {
//       _orderFuture = OrdersAPI.changeStatus(
//         statusId: 0,
//         status: '-',
//       ); // Dummy call to initialize);
//     });
//   }

//   Future<void> _updateOrderStatus(int statusId, String newStatus) async {
//     try {
//       await OrdersAPI.changeStatus(status: newStatus, statusId: statusId);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Status berhasil diubah menjadi $newStatus")),
//       );
//       _loadOrders();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Gagal mengubah status: ${e.toString()}")),
//       );
//     }
//   }

//   void _showStatusDialog(int orderId, String currentStatus) {
//     final statusOptions = ['Proses', 'Selesai'];

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Ubah Status Order"),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: statusOptions.length,
//               itemBuilder: (context, index) {
//                 final status = statusOptions[index];
//                 return ListTile(
//                   title: Text(
//                     status.toUpperCase(),
//                     style: TextStyle(
//                       fontWeight: status == currentStatus
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                       color: status == currentStatus
//                           ? Colors.blue
//                           : Colors.black,
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _updateOrderStatus();
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Baru':
//         return Color(0xFFFFB74D);
//       case 'Selesai':
//         return Color(0xFF0D47A1);
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 70),
//             child: FutureBuilder<GetOrderModel>(
//               future: _orderFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
//                   return const Center(child: Text("Belum ada pesanan"));
//                 }

//                 final orders = snapshot.data!.data!;
//                 return ListView.builder(
//                   itemCount: orders.length,
//                   itemBuilder: (context, index) {
//                     final order = orders[index];
//                     final items = order.items ?? [];

//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       child: ListTile(
//                         title: Text(
//                           "Order #${order.id}",
//                           style: TextStyle(
//                             fontFamily: "OpenSans_SemiBold",
//                             fontSize: 16,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Layanan: ${order.layanan ?? 'Tidak ada'}",
//                               style: TextStyle(fontFamily: "OpenSans_Regular"),
//                             ),
//                             Text(
//                               "Tanggal: ${order.createdAt?.toLocal().toString().split(' ')[0]}",
//                               style: TextStyle(fontFamily: "OpenSans_Regular"),
//                             ),
//                             if (items.isNotEmpty)
//                               Text(
//                                 "Items: ${items.map((i) => i.serviceItem?.name).join(', ')}",
//                                 style: TextStyle(
//                                   fontFamily: "OpenSans_Regular",
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             Text(
//                               "Total: Rp ${order.total?.toStringAsFixed(0) ?? '0'}",
//                               style: TextStyle(
//                                 fontFamily: "OpenSans_SemiBold",
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: _getStatusColor(order.status ?? ''),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 order.status?.toUpperCase() ?? '-',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                   fontFamily: "Baloo",
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               "Tap to change",
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                         onTap: () {
//                           _showStatusDialog(order.id!, order.status ?? 'Baru');
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Container(
//             height: 86,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//               color: Color(0xFF03A9F4),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: Center(
//                 child: Text(
//                   "Kelola Pesanan",
//                   style: TextStyle(
//                     fontFamily: "Montserrat_Bold",
//                     fontSize: 20,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
