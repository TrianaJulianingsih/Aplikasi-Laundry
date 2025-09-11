import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/kategori.dart';
import 'package:laundry_jaya/models/get_kategori_model.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  late Future<GetKategoriModel>? _kategoriFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadKategori();
  }

  void _loadKategori() {
    setState(() {
      _kategoriFuture = KategoriAPI.getKategori();
    });
  }

  // Future<void> _confirmDeleteKategori(GetImage kategori) async {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: Text(
  //           "Konfirmasi Hapus",
  //           style: TextStyle(fontFamily: "Montserrat_Medium"),
  //         ),
  //         content: Text(
  //           "Apakah Anda yakin ingin menghapus kategori '${kategori.name}'?",
  //           style: TextStyle(fontFamily: "OpenSans_Regular"),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text(
  //               "Batal",
  //               style: TextStyle(
  //                 fontFamily: "Baloo",
  //                 color: Colors.black,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop();
  //               await _deleteKategori(kategori);
  //             },
  //             child: const Text(
  //               "Hapus",
  //               style: TextStyle(
  //                 color: Colors.red,
  //                 fontFamily: "Baloo",
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _refreshCategories() async {
    setState(() {
      _kategoriFuture = KategoriAPI.getKategori();
    });
  }

  Future<void> _deleteCategory(int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Kategori"),
        content: Text("Yakin mau hapus kategori $name?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await KategoriAPI.deleteKategori(id: id);

        _refreshCategories();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kategori $name berhasil dihapus")),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal hapus kategori: $e")));
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
                          "Hapus Kategori",
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
            child: FutureBuilder<GetKategoriModel>(
              future: _kategoriFuture,
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return FutureBuilder<GetKategoriModel>(
                  future: _kategoriFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Gagal memuat kategori: ${snapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.data!.isEmpty) {
                      return const Center(
                        child: Text("Tidak ada kategori tersedia"),
                      );
                    }

                    final kategoriList = snapshot.data!.data!;

                    return RefreshIndicator(
                      onRefresh: () async {
                        _loadKategori();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: kategoriList.length,
                        itemBuilder: (context, index) {
                          final kategori = kategoriList[index];
                          return Card(
                            color: Colors.white,
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xFF03A9F4),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child:
                                          (kategori.imageUrl != null &&
                                              kategori.imageUrl!.isNotEmpty)
                                          ? Image.network(
                                              kategori.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                  ),
                                            )
                                          : const Icon(
                                              Icons.category,
                                              color: Colors.grey,
                                            ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          kategori.name ?? "Unnamed Category",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: "OpenSans_Bold",
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteCategory(
                                      kategori.id!,
                                      kategori.name ?? "Unnamed Category",
                                    ),
                                    //     _confirmDeleteKategori(kategori),
                                    // tooltip: "Hapus Kategori",
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
