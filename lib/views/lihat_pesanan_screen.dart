// File: views/riwayat_screen.dart
import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/orders.dart';
import 'package:laundry_jaya/models/get_order_model.dart';
import 'package:laundry_jaya/views/status_screen.dart';

class LihatPesananScreen extends StatefulWidget {
  const LihatPesananScreen({super.key});
  static const id = "/riwayatpesanan";

  @override
  State<LihatPesananScreen> createState() => _LihatPesananScreenState();
}

class _LihatPesananScreenState extends State<LihatPesananScreen> {
  late Future<GetOrderModel> _orderFuture;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    setState(() {
      _orderFuture = OrdersAPI.getOrders();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Baru':
        return Color(0xFFFFB74D);
      case 'Selesai':
        return Color(0xFF03A9F4);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: RefreshIndicator(
              onRefresh: () async {
                _loadOrders();
                await _orderFuture;
              },
              child: FutureBuilder<GetOrderModel>(
                future: _orderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.data!.isEmpty) {
                    return const Center(child: Text("Belum ada pesanan"));
                  }

                  final orders = snapshot.data!.data!;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final items = order.items ?? [];
                      return InkWell(
                        onTap: () async {
                          final changed = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StatusScreen(
                                orderId: order.id!,
                                currentStatus: order.status ?? "",
                              ),
                            ),
                          );
                          if (changed == true) {
                            _loadOrders();
                          }
                        },
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Text(
                              order.layanan ?? "Tanpa Layanan",
                              style: TextStyle(fontFamily: "OpenSans_SemiBold"),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal: ${order.createdAt?.toLocal()}",
                                  style: TextStyle(
                                    fontFamily: "OpenSans_Regular",
                                  ),
                                ),
                                ...items.map(
                                  (i) => Text(
                                    "• ${i.serviceItem?.name}",
                                    style: TextStyle(
                                      fontFamily: "OpenSans_Regular",
                                    ),
                                  ),
                                ),
                                Text(
                                  "Harga: ${order.total}",
                                  style: TextStyle(
                                    fontFamily: "OpenSans_SemiBold",
                                    color: Color(0xFFFFB74D),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status ?? ''),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order.status?.toUpperCase() ?? '-',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: "Baloo",
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            height: 86,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Color(0xFF03A9F4),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 120),
                    child: Text(
                      "List Pesanan",
                      style: TextStyle(
                        fontFamily: "Montserrat_Bold",
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
