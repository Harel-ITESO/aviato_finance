import 'package:aviato_finance/dummy_data.dart';
import 'package:aviato_finance/modules/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'transaction_model.dart';


class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _repeatController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _incomeCategories = ['Salary', 'Freelance', 'Gift'];
  final List<String> _outcomeCategories = ['Food', 'Transport', 'Shopping'];
  final List<String> _paymentMethods = ['Cash', 'Credit Card', 'Debit Card'];
  final List<String> _repeatOptions = ['Daily', 'Weekly', 'Monthly'];

  bool _isIncome = true;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _categories = _incomeCategories;
  }

  void _toggleTransactionType(bool isIncome) {
    setState(() {
      _isIncome = isIncome;
      _categories = _isIncome ? _incomeCategories : _outcomeCategories;
      _categoryController.clear();
    });
  }

  Future<void> _saveTransaction() async {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    final transaction = TransactionData(
      name: _nameController.text,
      amount: double.parse(_amountController.text),
      date: DateTime.now(),
      category: _categoryController.text,
      paymentMethod: _paymentMethodController.text,
      repeat: _repeatController.text,
      description: _descriptionController.text,
      isIncome: _isIncome,
    );
    
  AuthService authS = AuthService();
  var userEmail = authS.currentUser?.email;
  if (userEmail != Null){
    await addData(userEmail!, transaction.toJson());
  }

    print(transaction.toJson()); // Simulación de guardado

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [_isIncome, !_isIncome],
              onPressed: (index) => _toggleTransactionType(index == 0),
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: _isIncome ? Colors.green : Colors.red,
              children: const [Text("Income"), Text("Outcome")],
            ),
            const SizedBox(height: 20),
            CustomTextField(controller: _nameController, label: "Title", icon: Icons.edit),
            CustomTextField(controller: _amountController, label: "Amount", icon: Icons.attach_money, keyboardType: TextInputType.number),
            CustomDropdown(controller: _categoryController, label: "Category", icon: Icons.list, items: _categories),
            CustomDropdown(controller: _paymentMethodController, label: "Payment Method", icon: Icons.payment, items: _paymentMethods),
            CustomDropdown(controller: _repeatController, label: "Repeat", icon: Icons.repeat, items: _repeatOptions),
            CustomTextField(controller: _descriptionController, label: "Description", icon: Icons.description),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(200, 50)),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}