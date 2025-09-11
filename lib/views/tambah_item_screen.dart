// tambah_item_screen.dart
import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/items.dart';
import 'package:laundry_jaya/api/kategori.dart';
import 'package:laundry_jaya/api/services.dart';
import 'package:laundry_jaya/models/get_kategori_model.dart';
import 'package:laundry_jaya/models/get_layanan_model.dart';

class TambahItemScreen extends StatefulWidget {
  static const id = "/tambahItemScreen";

  const TambahItemScreen({super.key});

  @override
  State<TambahItemScreen> createState() => _TambahItemScreenState();
}

class _TambahItemScreenState extends State<TambahItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();

  int? _selectedCategoryId;
  int? _selectedServiceTypeId;
  Future<GetKategoriModel>? _kategoriFuture;
  Future<GetLayananModel>? _layananFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKategori();
    // _checkRole();
  }

  // void _checkRole() async {
  //   final isOwner = await RoleChecker.isOwner();
  //   if (!isOwner) {
  //     Navigator.pop(context);
  //   }
  // }

  void _loadKategori() {
    setState(() {
      _kategoriFuture = KategoriAPI.getKategori();
    });
  }

  void _loadLayananByCategory(int categoryId) {
    setState(() {
      _layananFuture = LayananAPI.getLayananByCategory(categoryId);
      _selectedServiceTypeId = null;
    });
  }

  Future<void> _tambahItem() async {
    if (_formKey.currentState!.validate() &&
        _selectedCategoryId != null &&
        _selectedServiceTypeId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await ItemsAPI.addItem(
          name: _namaController.text,
          price: int.parse(_hargaController.text),
          categoryId: _selectedCategoryId!,
          serviceTypeId: _selectedServiceTypeId!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message ?? "Item berhasil ditambahkan"),
          ),
        );

        _namaController.clear();
        _hargaController.clear();
        setState(() {
          _selectedCategoryId = null;
          _selectedServiceTypeId = null;
          _layananFuture = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
                          "Tambah Item",
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
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: "Nama Item",
                      labelStyle: TextStyle(fontFamily: "OpenSans_Regular"),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama item harus diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hargaController,
                    decoration: const InputDecoration(
                      labelText: "Harga",
                      labelStyle: TextStyle(fontFamily: "OpenSans_Regular"),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Harga harus diisi";
                      }
                      if (int.tryParse(value) == null) {
                        return "Harga harus berupa angka";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<GetKategoriModel>(
                    future: _kategoriFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (!snapshot.hasData ||
                          snapshot.data!.data!.isEmpty) {
                        return const Text("Tidak ada kategori tersedia");
                      }

                      final kategoriList = snapshot.data!.data!;

                      return DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: "Kategori",
                          labelStyle: TextStyle(fontFamily: "OpenSans_Regular"),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCategoryId,
                        items: kategoriList.map((kategori) {
                          return DropdownMenuItem<int>(
                            value: kategori.id,
                            child: Text(kategori.name ?? "Unnamed"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                            if (value != null) {
                              _loadLayananByCategory(value);
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Pilih kategori";
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedCategoryId != null)
                    FutureBuilder<GetLayananModel>(
                      future: _layananFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData ||
                            snapshot.data!.data!.isEmpty) {
                          return const Text(
                            "Tidak ada layanan tersedia untuk kategori ini",
                          );
                        }

                        final layananList = snapshot.data!.data!;

                        return DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: "Jenis Layanan",
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedServiceTypeId,
                          items: layananList.map((layanan) {
                            return DropdownMenuItem<int>(
                              value: layanan.id,
                              child: Text("${layanan.name}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedServiceTypeId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Pilih jenis layanan";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _tambahItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            "Tambah Item",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Baloo",
                              fontSize: 18,
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

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    super.dispose();
  }
}
