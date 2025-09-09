// import 'package:flutter/material.dart';
// import 'package:laundry_jaya/api/orders.dart';
// import 'package:laundry_jaya/models/get_order_model.dart';
// import 'package:laundry_jaya/models/change_status_model.dart';

// class LihatPesananScreen extends StatefulWidget {
//   const LihatPesananScreen({super.key});
//   static const id = "/lihatpesanan";

//   @override
//   State<LihatPesananScreen> createState() => _LihatPesananScreenState();
// }

// class _LihatPesananScreenState extends State<LihatPesananScreen> {
//   late Future<GetOrderModel> _orderFuture;

//   @override
//   void initState() {
//     super.initState();
//     _loadOrders();
//   }

//   void _loadOrders() {
//     setState(() {
//       _orderFuture = OrdersAPI.getOrders();
//     });
//   }

//   Future<void> _updateOrderStatus(int orderId, String newStatus) async {
//     try {
//       // Perhatikan: Endpoint.status saat ini hardcoded ke orders/5/status
//       // Kita perlu mengubah API untuk menerima orderId sebagai parameter
//       final response = await OrdersAPI.updateStatus(
//         orderId: orderId,
//         status: newStatus,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Status berhasil diubah menjadi $newStatus")),
//       );

//       _loadOrders(); // Reload data setelah update
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Gagal mengubah status: ${e.toString()}")),
//       );
//     }
//   }

//   void _showStatusDialog(int orderId, String currentStatus) {
//     final statusOptions = ['baru', 'selesai'];

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF03A9F4),
//           title: Center(
//             child: Text(
//               "Ubah Status Pesanan",
//               style: TextStyle(fontFamily: "OpenSans_SemiBold", fontSize: 20),
//             ),
//           ),
//           content: Container(
//             width: double.maxFinite,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: statusOptions.map((status) {
//                 return ListTile(
//                   title: Text(
//                     status.toUpperCase(),
//                     style: TextStyle(
//                       fontFamily: "OpenSans_Regular",
//                       color: status == currentStatus
//                           ? Colors.blue
//                           : Colors.black,
//                     ),
//                   ),
//                   trailing: status == currentStatus
//                       ? Icon(Icons.check, color: Colors.green)
//                       : null,
//                   onTap: () {
//                     Navigator.pop(context);
//                     _updateOrderStatus(orderId, status);
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(
//                 "Batal",
//                 style: TextStyle(
//                   fontFamily: "Baloo",
//                   fontSize: 16,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'diproses':
//         return Colors.blue;
//       case 'selesai':
//         return Colors.green;
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
//                       color: Colors.white,
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       child: ListTile(
//                         title: Text(
//                           order.layanan ?? "Tanpa Layanan",
//                           style: TextStyle(fontFamily: "OpenSans_SemiBold"),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "ID: ${order.id}",
//                               style: TextStyle(fontFamily: "OpenSans_Regular"),
//                             ),
//                             Text(
//                               "Tanggal: ${order.createdAt?.toLocal()}",
//                               style: TextStyle(fontFamily: "OpenSans_Regular"),
//                             ),
//                             ...items.map(
//                               (i) => Text(
//                                 "• ${i.serviceItem?.name} (${i.quantity}x)",
//                                 style: TextStyle(
//                                   fontFamily: "OpenSans_Regular",
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               "Total: Rp ${order.total?.toStringAsFixed(0) ?? '0'}",
//                               style: TextStyle(
//                                 fontFamily: "OpenSans_SemiBold",
//                                 color: Color(0xFFFFB74D),
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: _getStatusColor(
//                                   order.status ?? 'pending',
//                                 ),
//                               ),
//                               child: Text(
//                                 order.status?.toUpperCase() ?? "-",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontFamily: "Baloo",
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             IconButton(
//                               icon: Icon(Icons.edit, size: 18),
//                               onPressed: () {
//                                 _showStatusDialog(
//                                   order.id!,
//                                   order.status ?? 'pending',
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
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
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//               color: Color(0xFF03A9F4),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(top: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Lihat Pesanan",
//                     style: TextStyle(
//                       fontFamily: "Montserrat_Bold",
//                       fontSize: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
