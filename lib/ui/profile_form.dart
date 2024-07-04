import 'package:flutter/material.dart';
import 'package:tokoku/bloc/profile_bloc.dart';
import 'package:tokoku/model/profile.dart';
import 'package:tokoku/ui/produk_page.dart';
import 'package:tokoku/widget/warning_dialog.dart';

// ignore: must_be_immutable
class ProfileForm extends StatefulWidget {
  Profile? profile;

  ProfileForm({super.key, this.profile});
  // ProfileForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "UBAH PROFILE";
  String tombolSubmit = "UBAH";

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();

  final _currentPasswordTextboxController = TextEditingController();
  final _newPasswordTextboxController = TextEditingController();
  final _confirmPasswordTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    setState(() {
      _namaTextboxController.text = widget.profile!.nama!;
      _emailTextboxController.text = widget.profile!.email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _namaTextField(),
                _emailTextField(),
                _currentPasswordTextField(),
                _newPasswordTextField(),
                _confirmPasswordTextField(),
                const SizedBox(
                  height:20,
                ),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Nama",
        icon: Icon(Icons.person)
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama harus diisi";
        }
        return null;
      }
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
        icon: Icon(Icons.mail)
      ),
      keyboardType: TextInputType.text,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email harus diisi";
        }
        return null;
      }
    );
  }
  
  Widget _currentPasswordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Current Password",
        icon: Icon(Icons.key)
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _currentPasswordTextboxController,
      validator: (value) {
        //jika karakter yang dimasukkan kurang dari 6 karakter
        // if (value!.isEmpty) {
        //   return "Password harus diisi";
        // }
        return null;
      }
    );
  }
  
  Widget _newPasswordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "New Password",
        icon: Icon(Icons.key)
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _newPasswordTextboxController,
      validator: (value) {
        //jika karakter yang dimasukkan kurang dari 6 karakter
        // if (value!.isEmpty) {
        //   return "Password harus diisi";
        // }
        return null;
      }
    );
  }

  Widget _confirmPasswordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        icon: Icon(Icons.key)
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _confirmPasswordTextboxController,
      validator: (value) {
        //jika karakter yang dimasukkan kurang dari 6 karakter
        // if (value!.isEmpty) {
        //   return "Password harus diisi";
        // }
        return null;
      }
    );
  }

  //Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();

        if (validate) {
          if (!_isLoading) {
            setState(() {
              _isLoading = true;
            });

            Profile updateProfile = Profile.lengkap(email: _emailTextboxController.text);
            updateProfile.nama = _namaTextboxController.text;
            updateProfile.currentPassword = _currentPasswordTextboxController.text;
            updateProfile.newPassword = _newPasswordTextboxController.text;
            updateProfile.confirmPassword = _confirmPasswordTextboxController.text;

            ProfileBloc.updateProfile(profile: updateProfile).then((value) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const ProdukPage()
              ));
            }, onError: (error) {
              showDialog(
                context: context,
                builder: (BuildContext context) => const WarningDialog(
                  description: "Permintaan ubah data gagal, silahkan coba lagi",
                )
              );
            });

            setState(() {
              _isLoading = false;
            });
          }
        }
      }
    );
  }
}
