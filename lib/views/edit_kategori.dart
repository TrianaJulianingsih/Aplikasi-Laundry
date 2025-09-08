import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_jaya/api/kategori.dart';
import 'package:laundry_jaya/models/get_kategori_model.dart';

class EditKategoriScreen extends StatefulWidget {
  final GetImage kategori;

  const EditKategoriScreen({super.key, required this.kategori});

  static const id = "/editKategori";

  @override
  State<EditKategoriScreen> createState() => _EditKategoriScreenState();
}

class _EditKategoriScreenState extends State<EditKategoriScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.kategori.name ?? "";
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _updateKategori() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nama kategori tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await KategoriAPI.updateCategory(
        id: widget.kategori.id!,
        name: _nameController.text,
        image: _selectedImage,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kategori berhasil diupdate"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengupdate kategori: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Edit Kategori"),
      //   backgroundColor: Color(0xFF03A9F4),
      //   foregroundColor: Colors.white,
      //   actions: [
      //     if (_isLoading)
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: CircularProgressIndicator(color: Colors.white),
      //       ),
      //   ],
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    // mainAxisAlignment: MainAxisAlignment.start,
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
                          "Edit Kategori",
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
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Kategori",
                labelStyle: TextStyle(fontFamily: "OpenSans_Regular"),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              style: TextStyle(fontFamily: "OpenSans_Regular"),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "Gambar Kategori (opsional)",
              style: TextStyle(fontFamily: "OpenSans_Medium", fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : widget.kategori.imageUrl != null
                    ? Image.network(
                        widget.kategori.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            "Tap untuk memilih gambar",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "OpenSans_Regular",
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "Kosongkan jika tidak ingin mengubah gambar",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: "OpenSans_Regular",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _updateKategori,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF03A9F4),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Simpan Perubahan",
                      style: TextStyle(fontFamily: "Baloo", fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
