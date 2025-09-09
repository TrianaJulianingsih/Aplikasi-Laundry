import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/register_user.dart';
import 'package:laundry_jaya/extension/navigtaion.dart';
import 'package:laundry_jaya/models/register_model.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';
import 'package:laundry_jaya/views/buttomNav.dart';
import 'package:laundry_jaya/views/post_api_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const id = "/loginapi";

  @override
  State<LoginScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GetProfile? user;
  String? errorMessage;
  bool isVisibility = false;
  bool isLoading = false;

  void loginUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password harus diisi")),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final result = await AuthenticationAPI.loginUser(
        email: email,
        password: password,
      );
      final savedRole = await PreferenceHandler.getUserRole();
      final savedEmail = await PreferenceHandler.getUserEmail();

      String userRole = "";

      if (savedEmail == email && savedRole != null) {
        userRole = savedRole;
      } else {
        userRole = "customer";
        PreferenceHandler.saveUserRole(userRole);
        PreferenceHandler.saveUserEmail(email);
      }
      PreferenceHandler.saveToken(result.data?.token ?? "");
      PreferenceHandler.saveUserRole(userRole);
      PreferenceHandler.saveUserEmail(email);

      PreferenceHandler.saveUserId(result.data?.user?.id ?? 0);
      PreferenceHandler.saveUserName(result.data?.user?.name ?? "");

      setState(() {
        user = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Login berhasil sebagai ${userRole == 'owner' ? 'Pemilik' : 'Pelanggan'}",
          ),
        ),
      );
      context.pushReplacementNamed(ButtomNav.id);
    } catch (e) {
      print("Login error: $e");
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login gagal: ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF03A9F4)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        backgroundImage: AssetImage("assets/images/logo.png"),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        backgroundImage: AssetImage("assets/images/logo.png"),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        backgroundImage: AssetImage("assets/images/logo.png"),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 68),
              height: 744,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 92),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Text(
                      "Selamat Datang Kembali",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Gilroy_Medium",
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.only(right: 140),
                    child: Text(
                      "Cucian selesai, kamu santai.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(204, 67, 66, 66),
                        fontFamily: "Gilroy_Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: 327,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(47, 174, 174, 178),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email/id Anda",
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(223, 85, 85, 88),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: "Gilroy_Regular",
                            ),
                            contentPadding: EdgeInsets.only(top: 8, left: 16),
                            prefixIcon: Transform.translate(
                              offset: Offset(0, -2),
                              child: Image.asset(
                                "assets/images/iconProfil.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        Divider(
                          indent: 15,
                          endIndent: 15,
                          color: const Color.fromARGB(71, 152, 152, 161),
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !isVisibility,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 10, left: 16),
                            prefixIcon: Transform.translate(
                              offset: Offset(0, -1),
                              child: Image.asset(
                                "assets/images/iconLock.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            hintText: "Kata Sandi Anda",
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(195, 61, 61, 62),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: "Gilroy_Regular",
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isVisibility
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  isVisibility = !isVisibility;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),

                  Padding(
                    padding: const EdgeInsets.only(right: 210),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Lupa Password ?",
                        style: TextStyle(
                          color: const Color.fromARGB(148, 62, 62, 70),
                          fontSize: 12,
                          fontFamily: "Poppins_Regular",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 45),

                  SizedBox(
                    height: 56,
                    width: 327,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          111,
                          30,
                          192,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Masuk",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Atau masuk dengan",
                          style: TextStyle(
                            color: const Color.fromARGB(200, 62, 62, 70),
                            fontFamily: "Poppins_Medium",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 35,
                      right: 35,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Image.asset("assets/images/google.png"),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Image.asset("assets/images/cib_apple.png"),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Image.asset("assets/images/twitter.png"),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 140),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Belum punya akun? ",
                        style: TextStyle(
                          color: const Color.fromARGB(182, 100, 100, 106),
                          fontFamily: "Poppins_Regular",
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push(PostApiScreen());
                              },
                            text: " Daftar",
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 11, 39, 164),
                              fontFamily: "Poppins_Bold",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
