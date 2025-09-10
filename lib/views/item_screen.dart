import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/items.dart';
import 'package:laundry_jaya/api/kategori.dart';
import 'package:laundry_jaya/models/get_kategori_model.dart';
import 'package:laundry_jaya/models/item_model.dart';
import 'package:laundry_jaya/views/buat_pesanan_screen.dart';

class ItemScreen extends StatefulWidget {
  final int selectedCategoryId;

  const ItemScreen({super.key, required this.selectedCategoryId});
  static const id = "/itemsByCategory";

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  Future<ItemModel>? _itemsFuture;
  Future<GetKategoriModel>? _kategoriFuture;
  int _selectedCategoryId = 0;
  Map<int, int> selectedItems = {};
  bool isBottomSheetVisible = false;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId;
    _loadData();
  }

  void _loadData() {
    setState(() {
      _kategoriFuture = KategoriAPI.getKategori();

      if (_selectedCategoryId == 0) {
        print("Loading ALL items");
        _itemsFuture = ItemsAPI.getAllItem();
      } else {
        print("Loading items for category ID: $_selectedCategoryId");
        _itemsFuture = ItemsAPI.getItemByCategory(_selectedCategoryId);
      }
    });
  }

  void _changeCategory(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _loadData();
    });
  }

  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final route = ModalRoute.of(context);
  //   if (route != null) {
  //     route.addScopedWillPopCallback(() {
  //       _loadData();
  //       return SynchronousFuture(true);
  //     });
  //   }
  // }
  void _addItem(int itemId, String itemName, double itemPrice) {
    setState(() {
      if (selectedItems.containsKey(itemId)) {
        selectedItems[itemId] = selectedItems[itemId]! + 1;
      } else {
        selectedItems[itemId] = 1;
      }
      totalPrice += itemPrice;
      if (!isBottomSheetVisible) {
        isBottomSheetVisible = true;
        _showBottomSheet();
      } else {
        _updateBottomSheet();
      }
    });
  }

  void _removeItem(int itemId, double itemPrice) {
    setState(() {
      if (selectedItems.containsKey(itemId) && selectedItems[itemId]! > 1) {
        selectedItems[itemId] = selectedItems[itemId]! - 1;
        totalPrice -= itemPrice;
      } else if (selectedItems.containsKey(itemId) &&
          selectedItems[itemId]! == 1) {
        selectedItems.remove(itemId);
        totalPrice -= itemPrice;
        if (selectedItems.isEmpty) {
          isBottomSheetVisible = false;
        }
      }
      _updateBottomSheet();
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildBottomSheetContent();
      },
    ).then((value) {
      setState(() {
        isBottomSheetVisible = false;
      });
    });
  }

  void _updateBottomSheet() {
    Navigator.of(context).pop();
    _showBottomSheet();
  }

  Widget _buildBottomSheetContent() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Detail Pesanan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "OpenSans_Bold",
            ),
          ),
          SizedBox(height: 16),
          if (selectedItems.isNotEmpty)
            Column(
              children: selectedItems.entries.map((entry) {
                return FutureBuilder<ItemModel>(
                  future: _itemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final item = snapshot.data!.data!.firstWhere(
                        (item) => item.id == entry.key,
                        orElse: () => Datum(),
                      );

                      if (item.id == null) return SizedBox();

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text(
                          item.name ?? "Unnamed",
                          style: TextStyle(fontFamily: "OpenSans_Medium"),
                        ),
                        subtitle: Text(
                          "Rp ${item.price?.toString() ?? '0'} x ${entry.value}",
                          style: TextStyle(fontFamily: "OpenSans_Regular"),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _removeItem(
                                entry.key,
                                item.price?.toDouble() ?? 0.0,
                              ),
                            ),
                            Text(
                              entry.value.toString(),
                              style: TextStyle(
                                fontFamily: "OpenSans_Medium",
                                fontSize: 14,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _addItem(
                                entry.key,
                                item.name ?? "",
                                item.price?.toDouble() ?? 0.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox();
                  },
                );
              }).toList(),
            ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Harga:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans_Bold",
                ),
              ),
              Text(
                "Rp ${totalPrice.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans_Bold",
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuatPesananScreen(
                      selectedItems: selectedItems,
                      totalPrice: totalPrice,
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    setState(() {
                      selectedItems.clear();
                      totalPrice = 0;
                      isBottomSheetVisible = false;
                    });
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Lanjutkan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "OpenSans_SemiBold",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: Column(
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
                          padding: const EdgeInsets.only(right: 110),
                          child: Text(
                            "Pilih Layanan",
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
            FutureBuilder<GetKategoriModel>(
              future: _kategoriFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 60,
                    child: Center(child: Text("Error: ${snapshot.error}")),
                  );
                } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                  return const SizedBox(
                    height: 60,
                    child: Center(child: Text("Tidak ada kategori")),
                  );
                }

                final kategoriList = snapshot.data!.data!;

                return SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _changeCategory(0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedCategoryId == 0
                                ? Colors.blue[700]
                                : Colors.blue[400],
                          ),
                          child: Text(
                            "Semua",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      ...kategoriList.map((kategori) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => _changeCategory(kategori.id!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _selectedCategoryId == kategori.id
                                  ? Colors.blue[700]
                                  : Colors.blue[400],
                            ),
                            child: Text(
                              kategori.name ?? "Unnamed",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "OpenSans_SemiBold",
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),

            const Divider(),

            Expanded(
              child: FutureBuilder<ItemModel>(
                future: _itemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.data == null) {
                    return const Center(
                      child: Text("Tidak ada layanan tersedia"),
                    );
                  }
                  final layananList = snapshot.data!.data!;
                  print("Received ${layananList.length} items");
                  for (var item in layananList) {
                    print(
                      "Item: ${item.name}, Category ID: ${item.categoryId}",
                    );
                  }
                  final filteredItems = _selectedCategoryId == 0
                      ? layananList
                      : layananList
                            .where(
                              (item) => item.categoryId == _selectedCategoryId,
                            )
                            .toList();

                  print(
                    "Filtered ${filteredItems.length} items for category $_selectedCategoryId",
                  );

                  if (filteredItems.isEmpty) {
                    return Center(
                      child: Text("Tidak ada layanan untuk kategori ini"),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final itemCount = selectedItems[item.id] ?? 0;

                      return Card(
                        color: Color(0xFFFFB74D),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(
                            item.name ?? "Unnamed",
                            style: const TextStyle(
                              fontFamily: "OpenSans_Bold",
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kategori: ${item.category?.name ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "OpenSans_Regular",
                                ),
                              ),
                              Text(
                                "Harga: Rp ${item.price?.toString() ?? '0'}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "OpenSans_Regular",
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (itemCount > 0) {
                                    _removeItem(
                                      item.id!,
                                      item.price?.toDouble() ?? 0.0,
                                    );
                                  }
                                },
                                icon: Image.asset(
                                  "assets/images/Rh-.png",
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                              Text(
                                itemCount.toString(),
                                style: TextStyle(
                                  fontFamily: "OpenSans_Medium",
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _addItem(
                                    item.id!,
                                    item.name ?? "",
                                    item.price?.toDouble() ?? 0.0,
                                  );
                                },
                                icon: Image.asset(
                                  "assets/images/Rh+.png",
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
