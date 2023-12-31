import 'package:flutter/material.dart';

class Compose extends StatefulWidget {

  // typedef OnCompose = void Function(String firstName,String LastName)
  const Compose({super.key});
  @override
  _ComposeState createState() => _ComposeState();
}

class _ComposeState extends State<Compose> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(hintText: "Enter First Name"),
        ),
        TextField(
          controller: _lastNameController,
          decoration: const InputDecoration(hintText: "Enter Last Name"),
        ),
        TextButton(
          onPressed: () {},
          child: const Text("Add to List"),
        )
      ]),
    );
  }
}
