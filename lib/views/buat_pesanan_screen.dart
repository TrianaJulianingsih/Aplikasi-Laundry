import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/orders.dart';
import 'package:laundry_jaya/models/get_order_model.dart';

class BuatPesananScreen extends StatefulWidget {
  final Map<int, int> selectedItems;
  final double totalPrice;
  static const id = "/buatpesanan";

  const BuatPesananScreen({
    super.key,
    required this.selectedItems,
    required this.totalPrice,
  });

  @override
  State<BuatPesananScreen> createState() => _BuatPesananScreenState();
}

class _BuatPesananScreenState extends State<BuatPesananScreen> {
  String layanan = "Antar";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    int totalItem = widget.selectedItems.values.fold(0, (a, b) => a + b);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 86,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Color(0xFF03A9F4),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: Text(
                          "Buat Pesanan",
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
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Text("Pilih Layanan:", style: TextStyle(fontSize: 16, fontFamily: "OpenSans_Medium")),
          ),
          Row(
            children: [
              Radio(
                value: "Antar",
                groupValue: layanan,
                onChanged: (value) {
                  setState(() {
                    layanan = value.toString();
                  });
                },
              ),
              Text("Antar", style: TextStyle(fontFamily: "OpenSans_Regular"),),
              Radio(
                value: "Jemput",
                groupValue: layanan,
                onChanged: (value) {
                  setState(() {
                    layanan = value.toString();
                  });
                },
              ),
              Text("Jemput", style: TextStyle(fontFamily: "OpenSans_Regular"),),
            ],
          ),
          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text("Item yang dipilih:", style: TextStyle(fontSize: 16, fontFamily: "OpenSans_Medium")),
          ),
          Expanded(
            child: ListView(
              children: widget.selectedItems.entries.map((entry) {
                return ListTile(
                  title: Text("Item ID: ${entry.key}", style: TextStyle(fontFamily: "OpenSans_Medium"),),
                  subtitle: Text("Jumlah: ${entry.value}", style: TextStyle(fontFamily: "OpenSans_Regular"),),
                );
              }).toList(),
            ),
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Text("Total Item: $totalItem", style: TextStyle(fontFamily: "OpenSans_Regular"),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text("Total Harga: Rp ${widget.totalPrice.toStringAsFixed(0)}", style: TextStyle(fontFamily: "OpenSans_Regular"),),
          ),

          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
              child: ElevatedButton(
                onPressed: isLoading ? null : _buatPesanan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Pesan", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buatPesanan() async {
    setState(() {
      isLoading = true;
    });

    try {
      final itemsPayload = widget.selectedItems.entries.map((e) {
        return {"service_item_id": e.key, "quantity": e.value};
      }).toList();

      await OrdersAPI.addOrder(
        layanan: layanan,
        status: "baru",
        items: itemsPayload,
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal buat pesanan: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
