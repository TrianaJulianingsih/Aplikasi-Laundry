import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/register_user.dart';
import 'package:laundry_jaya/models/register_model.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';

class PostApiScreen extends StatefulWidget {
  const PostApiScreen({super.key});
  static const id = '/post_api_screen';
  
  @override
  State<PostApiScreen> createState() => _PostApiScreenState();
}

class _PostApiScreenState extends State<PostApiScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = "customer";
  GetProfile? user;
  String? errorMessage;
  bool isVisibility = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [buildBackground(), buildLayer()])
    );
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();
    
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi")),
      );
      setState(() => isLoading = false);
      return;
    }
    
    try {
      // Register to backend (without role)
      final result = await AuthenticationAPI.registerUser(
        email: email,
        password: password,
        name: name,
      );
      
      // Save role locally
      PreferenceHandler.saveUserRole(selectedRole);
      PreferenceHandler.saveUserEmail(email);
      PreferenceHandler.saveUserName(name);
      
      setState(() {
        user = result;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registrasi berhasil sebagai ${selectedRole == 'owner' ? 'Pemilik' : 'Pelanggan'}"))
      );
      
      PreferenceHandler.saveToken(user?.data?.token.toString() ?? "");
      
      // Navigate based on role
      if (selectedRole == "owner") {
        Navigator.pushReplacementNamed(context, "/buttomNav");
      } else {
        Navigator.pushReplacementNamed(context, "/buttomNav");
      }
      
    } catch (e) {
      print("Register error: $e");
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registrasi gagal: ${e.toString()}"))
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Daftar Akun Baru",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              height(24),
              
              // Role Selection
              buildTitle("Pilih Jenis Akun"),
              height(12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        value: "customer",
                        child: Text("Pelanggan", style: TextStyle(fontSize: 16)),
                      ),
                      DropdownMenuItem(
                        value: "owner",
                        child: Text("Pemilik Laundry", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),
                ),
              ),
              height(16),
              
              buildTitle("Nama Lengkap"),
              height(12),
              buildTextField(
                hintText: "Masukkan nama lengkap",
                controller: nameController,
              ),
              height(16),
              
              buildTitle("Email"),
              height(12),
              buildTextField(
                hintText: "Masukkan email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              height(16),
              
              buildTitle("Password"),
              height(12),
              buildTextField(
                hintText: "Masukkan password",
                isPassword: true,
                controller: passwordController,
              ),
              height(24),
              
              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Daftar sebagai ${selectedRole == 'owner' ? 'Pemilik' : 'Pelanggan'}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              height(16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Atau Masuk Dengan",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              height(16),
              
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/loginapi");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, color: Colors.blue),
                      width(8),
                      Text("Login", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  TextField buildTextField({
    String? hintText,
    bool isPassword = false,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !isVisibility : false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}