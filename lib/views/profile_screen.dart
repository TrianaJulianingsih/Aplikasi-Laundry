import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/register_user.dart';
import 'package:laundry_jaya/extension/navigtaion.dart';
import 'package:laundry_jaya/models/get_user_model.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';
import 'package:laundry_jaya/views/login_api_screen.dart';

class ProfileAPIScreen extends StatefulWidget {
  const ProfileAPIScreen({super.key});
  static const id = "/profile";

  @override
  State<ProfileAPIScreen> createState() => _ProfileAPIScreenState();
}

class _ProfileAPIScreenState extends State<ProfileAPIScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  GetUserModel? user;
  String? errorMessage;
  bool isLoading = false;
  bool isUpdating = false;
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    setState(() => isLoading = true);

    try {
      // final role = await RoleChecker.getRoleDisplayName();
      final name = await PreferenceHandler.getUserName();
      final email = await PreferenceHandler.getUserEmail();

      setState(() {
        userName = name ?? "";
      });
      nameController.text = name ?? "";
      emailController.text = email ?? "";

      final userData = await AuthenticationAPI.getProfile();
      setState(() => user = userData);
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _logout() async {
    try {
      await AuthenticationAPI.logout();
      PreferenceHandler.removeAll();
      context.pushNamed(LoginScreen.id);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout berhasil")));
    } catch (e) {
      print("Logout error: $e");

      PreferenceHandler.removeAll();

      Navigator.pushNamed(context, '/loginapi');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout berhasil (local data cleared)")),
      );
    }
  }

  void _showEditDialog() {
    nameController.text = user?.data?.name ?? userName;
    emailController.text = user?.data?.email ?? userEmail;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Edit Profil",
            style: TextStyle(fontFamily: "OpenSans_Bold"),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontFamily: "OpenSans_Regular"),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontFamily: "OpenSans_Regular"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Batal",
                style: TextStyle(fontFamily: "OpenSans_Medium"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _updateProfile();
                Navigator.pop(context);
              },
              child: Text(
                "Simpan",
                style: TextStyle(fontFamily: "OpenSans_Medium"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateProfile() async {
    setState(() => isUpdating = true);

    try {
      final updatedProfile = await AuthenticationAPI.updateProfile(
        name: nameController.text,
        email: emailController.text,
      );
      PreferenceHandler.saveUserName(nameController.text);
      PreferenceHandler.saveUserEmail(emailController.text);

      final userData = await AuthenticationAPI.getProfile();
      setState(() => user = userData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profil berhasil diperbarui"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui profil: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
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
                      Padding(
                        padding: const EdgeInsets.only(left: 170),
                        child: Text(
                          "Profil",
                          style: TextStyle(
                            fontFamily: "Montserrat_Bold",
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: _showEditDialog,
                        icon: Icon(Icons.edit, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Color(0xFFFFB74D),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Informasi Akun",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "OpenSans_Bold",
                                  color: Color(0xFF0D47A1),
                                ),
                              ),
                              SizedBox(height: 16),
                              ListTile(
                                leading: Icon(Icons.person, color: Colors.blue),
                                title: Text(
                                  "Nama",
                                  style: TextStyle(
                                    fontFamily: "OpenSans_Medium",
                                  ),
                                ),
                                subtitle: Text(
                                  user?.data?.name ?? userName,
                                  style: TextStyle(
                                    fontFamily: "OpenSans_Regular",
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.email, color: Colors.blue),
                                title: Text(
                                  "Email",
                                  style: TextStyle(
                                    fontFamily: "OpenSans_Medium",
                                  ),
                                ),
                                subtitle: Text(
                                  user?.data?.email ?? userEmail,
                                  style: TextStyle(
                                    fontFamily: "OpenSans_Regular",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      ElevatedButton.icon(
                        onPressed: _logout,
                        icon: Icon(Icons.logout),
                        label: Text("Logout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
