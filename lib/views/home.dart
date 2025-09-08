import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/kategori.dart';
import 'package:laundry_jaya/extension/navigtaion.dart';
import 'package:laundry_jaya/models/get_kategori_model.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';
import 'package:laundry_jaya/views/item_screen.dart';
import 'package:laundry_jaya/views/tambah_item_screen.dart';
import 'package:laundry_jaya/views/tambah_kategori_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  // final bool? appBar;
  static const id = "/homeScreen";

  @override
  State<HomeScreen> createState() => _TugasTujuhState();
}

class _TugasTujuhState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _refreshKey = UniqueKey();
  Future<GetKategoriModel>? _kategoriFuture;
  // final TextEditingController _namaController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: PreferenceHandler.getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final userRole = snapshot.data ?? "customer";
        final isOwner = userRole == "owner";

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Color(0xFF03A9F4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Text(
                                    isOwner ? "Pemilik Laundry" : "Pelanggan",
                                    style: TextStyle(
                                      fontFamily: "Montserrat_Regular",
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 200),
                                if (isOwner)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            context.pushNamed(TambahKategoriScreen.id);
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              TambahItemScreen.id,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: FutureBuilder<String?>(
                              future: PreferenceHandler.getUserName(),
                              builder: (context, snapshot) {
                                final userName = snapshot.data ?? "User";
                                return Text(
                                  userName,
                                  style: TextStyle(
                                    fontFamily: "Montserrat_Bold",
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 105),
                        child: Container(
                          height: 169,
                          width: 360,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(4, 4),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                            left: 20,
                                          ),
                                          child: Text(
                                            "Lacak pesanan",
                                            style: TextStyle(
                                              fontFamily: "OpenSans_Regular",
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            left: 20,
                                          ),
                                          child: Text(
                                            "Anda memiliki 2 laundry aktif",
                                            style: TextStyle(
                                              fontFamily: "Montserrat_Bold",
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 30,
                                      right: 30,
                                    ),
                                    child: Image.asset(
                                      "assets/images/Jacuzzi.png",
                                      height: 73,
                                      width: 73,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Lihat semua",
                                    style: TextStyle(
                                      fontFamily: "Baloo",
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFF0D47A1),
                                      decorationThickness: 2,
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kategori",
                        style: TextStyle(
                          fontFamily: "Montserrat_Bold",
                          fontSize: 16,
                        ),
                      ),
                      FutureBuilder<GetKategoriModel>(
                        future: _kategoriFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              "Gagal memuat kategori: ${snapshot.error}",
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.data!.isEmpty) {
                            return Text("Kategori kosong");
                          }

                          final kategoriList = snapshot.data!.data!;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                            itemCount: kategoriList.length + (isOwner ? 2 : 0),
                            itemBuilder: (context, index) {
                              final kategori = kategoriList[index];
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ItemScreen(
                                            selectedCategoryId: kategori.id!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Color(0xFF03A9F4),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
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
                                                    ) => Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                    ),
                                              )
                                            : Icon(
                                                Icons.image,
                                                size: 30,
                                                color: Colors.grey,
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    kategori.name ?? "NULL",
                                    style: TextStyle(fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      // if (!isOwner) ...[
                      //   SizedBox(height: 30),
                      //   Text(
                      //     "Riwayat",
                      //     style: TextStyle(
                      //       fontFamily: "Montserrat_Bold",
                      //       fontSize: 16,
                      //     ),
                      //   ),
                        
                      // ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
