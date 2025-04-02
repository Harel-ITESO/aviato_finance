import 'package:flutter/material.dart';
import 'transaction_form.dart';

class AddDataScreen extends StatelessWidget {
  const AddDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Data"), centerTitle: true),
      body: const Padding(
        padding: EdgeInsets.all(15),
        child: TransactionForm(),
      ),
    );
  }
}