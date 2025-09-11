import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:laundry_jaya/api/register_user.dart';
import 'package:laundry_jaya/extension/navigtaion.dart';
import 'package:laundry_jaya/models/register_model.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';
import 'package:laundry_jaya/views/buttom_nav.dart';
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
        const SnackBar(content: Text("Email, dan Password tidak boleh kosong")),
      );
      isLoading = false;

      return;
    }
    try {
      final result = await AuthenticationAPI.loginUser(
        email: email,
        password: password,
      );
      setState(() {
        user = result;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login berhasil")));
      PreferenceHandler.saveToken(user?.data?.token.toString() ?? "");
      context.pushReplacementNamed(ButtomNav.id);
      print(user?.toJson());
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() {});
      isLoading = false;
    }
    // final user = User(email: email, password: password, name: name);
    // await DbHelper.registerUser(user);
    // Future.delayed(const Duration(seconds: 1)).then((value) {
    //   isLoading = false;
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("Pendaftaran berhasil")));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(

      // ),
      body: Form(
        key: _formKey,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/background.jpg"),
                ),
              ),
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
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 42),
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
                    padding: const EdgeInsets.only(right: 20, left: 35),
                    child: Text(
                      "Selamat datang kembali di Laundry Jaya. Have a good time",
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
                            hint: Text(
                              "Email/id Anda",
                              style: TextStyle(
                                color: const Color.fromARGB(223, 85, 85, 88),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "Gilroy_Regular",
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 8),
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
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return "Email tidak boleh kosong";
                          //   } else if (!value.contains("@")) {
                          //     return "Email tidak valid";
                          //   } else if (RegExp(r'^\d').hasMatch(value)) {
                          //     return "Email tidak valid";
                          //   }
                          //   return null;
                          // },
                        ),
                        Divider(
                          indent: 15,
                          endIndent: 15,
                          color: const Color.fromARGB(71, 152, 152, 161),
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 10),
                            prefixIcon: Transform.translate(
                              offset: Offset(0, -1),
                              child: Image.asset(
                                "assets/images/iconLock.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            hint: Text(
                              "Kata Sandi Anda",
                              style: TextStyle(
                                color: const Color.fromARGB(195, 61, 61, 62),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "Gilroy_Regular",
                              ),
                            ),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return "Password tidak boleh kosong";
                          //   } else if (RegExp(r'^\d').hasMatch(value)) {
                          //     return "Password tidak valid";
                          //   }
                          //   return null;
                          // },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.only(right: 210),
                    child: Text(
                      "Lupa Password ?",
                      style: TextStyle(
                        color: const Color.fromARGB(148, 62, 62, 70),
                        fontSize: 12,
                        fontFamily: "Poppins_Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 45),
                  SizedBox(
                    height: 56,
                    width: 327,
                    child: ElevatedButton(
                      onPressed: () {
                        loginUser();
                        //Error dan sukses menggunakan ScaffoldMessenger dan formKey
                        // if (_formKey.currentState!.validate()) {
                        //   // ScaffoldMessenger.of(context).showSnackBar(
                        //   //   SnackBar(content: Text("Form Validasi Berhasil")),
                        //   // );
                        //   context.pushReplacement(TugasDelapan());
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text("Form Validasi Berhasil"),
                        //       duration: Duration(microseconds: 2),
                        //     ),
                        //   );
                        // } else {
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: Text("Login failed"),
                        //         content: Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             Text("Email or password is invalid"),
                        //             SizedBox(height: 20),
                        //             // Image.asset(
                        //             //   'assets/images/rendang.jpeg',
                        //             //   width: 90,
                        //             //   height: 100,
                        //             //   fit: BoxFit.cover,
                        //             // ),
                        //             Lottie.asset(
                        //               'assets/animations/false.json',
                        //               width: 100,
                        //               height: 100,
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ],
                        //         ),
                        //         actions: [
                        //           TextButton(
                        //             child: Text("Batal"),
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //           ),
                        //           TextButton(
                        //             child: Text("Ok"),
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // }
                      },
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
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(9),
                            child: Image.asset(
                              "assets/images/iconPembatas.png",
                            ),
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
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Image.asset(
                              "assets/images/iconPembatas.png",
                            ),
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
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            width: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(59, 190, 190, 195),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage("assets/images/google.png"),
                              ),
                            ),
                            // child: Text("Postingan"),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            height: 48,
                            width: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(59, 190, 190, 195),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/cib_apple.png",
                                ),
                              ),
                            ),
                            // child: Text("Follower"),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            height: 48,
                            width: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(59, 190, 190, 195),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage("assets/images/twitter.png"),
                              ),
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
