import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/items.dart';
import 'package:laundry_jaya/api/kategori.dart';
import 'package:laundry_jaya/extension/navigtaion.dart';
import 'package:laundry_jaya/models/get_kategori_model.dart';
import 'package:laundry_jaya/models/item_model.dart';
import 'package:laundry_jaya/views/edit_kategori.dart';
import 'package:laundry_jaya/views/hapus_kategori.dart';
import 'package:laundry_jaya/views/tambah_item_screen.dart';
import 'package:laundry_jaya/views/tambah_kategori_screen.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});
  static const id = "/ownerDashboard";

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  Future<GetKategoriModel>? _kategoriFuture;
  Future<ItemModel>? _itemsFuture;
  int _totalCategories = 0;
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _kategoriFuture = KategoriAPI.getKategori();
      _itemsFuture = ItemsAPI.getAllItem();
    });
  }

  void _showKategoriListForEdit() async {
    try {
      final kategoriData = await KategoriAPI.getKategori();

      if (kategoriData.data == null || kategoriData.data!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tidak ada kategori untuk diedit")),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF03A9F4),
            title: Center(child: Text("Pilih Kategori untuk Edit", style: TextStyle(fontFamily: "OpenSans_SemiBold", fontSize: 20),)),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: kategoriData.data!.length,
                itemBuilder: (context, index) {
                  final kategori = kategoriData.data![index];
                  return Card(
                    child: ListTile(
                      leading: kategori.imageUrl != null
                          ? Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              height: 90,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF03A9F4),
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Image.network(
                                  kategori.imageUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                            ),
                          )
                          : Icon(Icons.category),
                      title: Text(kategori.name ?? "", style: TextStyle(fontFamily: "OpenSans_Regular"),),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          EditKategoriScreen.id,
                          arguments: kategori,
                        ).then((value) {
                          if (value == true) _loadData();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Batal", style: TextStyle(fontFamily: "Baloo", fontSize: 16, color: Colors.white),),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat kategori: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 130,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 145),
                        child: Text(
                          "Dashboard",
                          style: TextStyle(
                            fontFamily: "Montserrat_Bold",
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: _loadData,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder<GetKategoriModel>(
                        future: _kategoriFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _totalCategories = snapshot.data!.data!.length;
                          }
                          return _buildStatCard(
                            "Total Kategori",
                            _totalCategories.toString(),
                            Icons.category,
                            Colors.blue,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: FutureBuilder<ItemModel>(
                        future: _itemsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _totalItems = snapshot.data!.data!.length;
                          }
                          return _buildStatCard(
                            "Total Layanan",
                            _totalItems.toString(),
                            Icons.local_laundry_service,
                            Colors.green,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  "Aksi Cepat",
                  style: TextStyle(fontSize: 18, fontFamily: "OpenSans_Bold"),
                ),
                SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                  children: [
                    _buildActionButton(
                      "Tambah Kategori",
                      Icons.add,
                      Color(0xFF03A9F4),
                      () {
                        Navigator.pushNamed(
                          context,
                          TambahKategoriScreen.id,
                        ).then((value) {
                          if (value == true) _loadData();
                        });
                      },
                    ),
                    _buildActionButton(
                      "Tambah Item",
                      Icons.add,
                      Color(0xFF03A9F4),
                      () {
                        Navigator.pushNamed(context, TambahItemScreen.id).then((
                          value,
                        ) {
                          if (value == true) _loadData();
                        });
                      },
                    ),
                    _buildActionButton(
                      "Lihat Pesanan",
                      Icons.list_alt,
                      Color(0xFFFFB74D),
                      () {},
                    ),
                    _buildActionButton(
                      "Edit Kategori",
                      Icons.edit,
                      Color(0xFF0D47A1),
                      () {
                        _showKategoriListForEdit();
                      },
                    ),

                    _buildActionButton(
                      "Hapus Kategori",
                      Icons.delete,
                      Colors.red,
                      () {
                        context.push(DeleteScreen());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: Color(0xFFFFB74D),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontFamily: "Montserrat_Bold"),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "OpenSans_Regular",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon),
      label: Text(
        text,
        style: TextStyle(fontFamily: "OpenSans_Bold", fontSize: 14),
      ),
    );
  }
}
