import 'package:flutter/material.dart';
import 'package:tokoku/bloc/profile_bloc.dart';
import 'package:tokoku/helpers/user_info.dart';
import 'package:tokoku/model/profile.dart';
import 'package:tokoku/ui/login_page.dart';
import 'package:tokoku/ui/profile_form.dart';
import 'package:tokoku/widget/warning_dialog.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile')
      ),
      body: FutureBuilder<Profile>(
        future: ProfileBloc.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData ? ShowProfile(
            profile: snapshot.data,
          ) : const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}

class ShowProfile extends StatelessWidget{
  final Profile? profile;
  const ShowProfile({Key? key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Image.asset('assets/images/default-profile.jpg'),
                Text(
                  "${profile!.nama}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                Text(
                  "${profile!.email}",
                  style: const TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 100.0),
            width: double.infinity,
            child: Column(
              children: [
                OutlinedButton.icon(
                  label: const Text("Update Profile"),
                  icon: const Icon(Icons.edit),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber)
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileForm(profile: profile)
                      )
                    );
                  }
                ),
                OutlinedButton.icon(
                  label: const Text("Hapus Akun"),
                  icon: const Icon(Icons.delete),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                  onPressed: () {
                    AlertDialog alertDialog = AlertDialog(
                      content: const Text("Yakin ingin menghapus akun anda?"),
                      actions: [
                        //tombol hapus
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            foregroundColor: MaterialStateProperty.all(Colors.white)
                          ),
                          child: const Text("Yakin"),
                          onPressed: () {
                            ProfileBloc.deleteAkun().then((value) {
                              UserInfo().logout();

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => const LoginPage()
                              ));
                            }, onError: (error) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => const WarningDialog(
                                  description: "Permintaan hapus akun gagal, silahkan coba lagi",
                                )
                              );
                            });
                          },
                        ),

                        //tombol batal
                        OutlinedButton(
                          child: const Text("Batal"),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    );

                    showDialog(builder: (context) => alertDialog, context: context);
                  },
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
