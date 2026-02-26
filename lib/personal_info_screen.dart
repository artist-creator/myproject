import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() =>
      _PersonalInfoScreenState();
}

class _PersonalInfoScreenState
    extends State<PersonalInfoScreen> {

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();

  double _age = 25;
  String _country = 'India';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    setState(() {
      _nameController.text =
          prefs.getString('name') ?? '';
      _usernameController.text =
          prefs.getString('username') ?? '';
      _age = prefs.getDouble('age') ?? 25;
      _country =
          prefs.getString('country') ?? 'India';
    });
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
        'name', _nameController.text);
    await prefs.setString(
        'username', _usernameController.text);
    await prefs.setDouble('age', _age);
    await prefs.setString('country', _country);

    Fluttertoast.showToast(
      msg: "Profile updated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            TextField(
              controller: _nameController,
              decoration:
                  const InputDecoration(
                      labelText: 'Name'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _usernameController,
              decoration:
                  const InputDecoration(
                      labelText: 'Username'),
            ),

            const SizedBox(height: 20),

            const Text("Age"),
            Slider(
              value: _age,
              min: 18,
              max: 100,
              divisions: 82,
              label: _age.round().toString(),
              onChanged: (value) {
                setState(() {
                  _age = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text("Country"),
            DropdownButton<String>(
              value: _country,
              isExpanded: true,
              items: [
                'India',
                'United States',
                'Canada'
              ]
                  .map((country) =>
                      DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _country = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveUserData,
              child:
                  const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}