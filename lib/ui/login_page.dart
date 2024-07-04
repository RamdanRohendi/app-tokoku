import 'package:flutter/material.dart';
import 'package:tokoku/bloc/login_bloc.dart';
import 'package:tokoku/helpers/user_info.dart';
import 'package:tokoku/ui/produk_page.dart';
import 'package:tokoku/ui/registrasi_page.dart';
import 'package:tokoku/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height:60,
                ),
                const Icon(Icons.shop_sharp, size: 140.0),
                const SizedBox(
                  height:20,
                ),
                _emailTextField(),
                _passwordTextField(),
                const SizedBox(
                  height:30,
                ),
                _buttonLogin(),
                const SizedBox(
                  height:20,
                ),
                _menuRegistrasi()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
        icon: Icon(Icons.mail)
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        //validasi harus diisi
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      }
    );
  }

  //Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Password",
        icon: Icon(Icons.key)
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        //jika karakter yang dimasukkan kurang dari 6 karakter
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      }
    );
  }

  //Membuat Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.lightBlue)
      ),
      child: const Text("Login", style: TextStyle(color: Colors.white)),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        
        if (validate) {
          if (!_isLoading) _submit();
        }
      }
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text
    ).then((value) async {
      await UserInfo().setToken(value.token.toString());
      await UserInfo().setUserID(int.parse(value.userID.toString()));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProdukPage()));
    }, onError: (error) {
      print(error);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Login gagal, silahkan coba lagi",
        )
      );
    });
    setState(() {
      _isLoading = false;
    });
  }

  // Membuat menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage())
          );
        },
      ),
    );
  }
}
