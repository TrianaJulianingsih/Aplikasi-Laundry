import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_jaya/api/kategori.dart';

class TambahKategoriScreen extends StatefulWidget {
  const TambahKategoriScreen({super.key});
  static const id = "/tambahKategori";

  @override
  State<TambahKategoriScreen> createState() => _TambahKategoriScreenState();
}

class _TambahKategoriScreenState extends State<TambahKategoriScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  File? selectedImage;
  bool loading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      final result = await KategoriAPI.addKategori(
        name: nameController.text,
        image: selectedImage,
      );

      setState(() => loading = false);
      if (result == "success") {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Kategori berhasil ditambahkan"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.green),
        );
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
                        padding: const EdgeInsets.only(right: 100),
                        child: Text(
                          "Tambah Kategori",
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey),
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Tap untuk pilih gambar",
                                      style: TextStyle(
                                        fontFamily: "OpenSans_Regular",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Nama Kategori",
                        labelStyle: TextStyle(fontFamily: "OpenSans_Regular"),
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Nama wajib diisi"
                          : null,
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: loading ? null : handleSubmit,
                      icon: Icon(Icons.add, color: Colors.white),
                      label: loading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Tambah Kategori",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Baloo",
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Color(0xFF0D47A1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
