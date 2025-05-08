import 'package:aviato_finance/dummy_data.dart';
import 'package:aviato_finance/modules/authentication/auth_service.dart';
import 'package:aviato_finance/utils/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _paymentMethodController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _outcomeCategories = ['Food', 'Transport', 'Shopping', 'Entertainment'];
  final List<String> _incomeCategories = ['Salary', 'Freelance', 'Gift', 'Extra Income'];
  final List<String> _paymentMethods = ['Cash', 'Credit Card', 'Debit Card', 'Bank Transfer'];
  final List<String> _repeatOptions = ['Daily', 'Every 3 days', 'Weekly', 'Monthly', 'Every 6 months'];

  List<String> _categories = [];

  final Map<String, bool> _fieldErrors = {
    'name': false,
    'amount': false,
    'date': false,
    'category': false,
    'paymentMethod': false,
    'repeat': false,
  };

  static const Map<String, String> fieldKeys = {
    'Title': 'name',
    'Amount': 'amount',
    'Date': 'date',
    'Category': 'category',
    'Payment Method': 'paymentMethod',
    'Repeat': 'repeat',
  };

  bool _isIncome = true;
  bool _hasTriedToSave = false;

  @override
  void initState() {
    super.initState();
    _categories = _incomeCategories;
  }

  void _onToggleChanged(bool isIncome) {
    setState(() {
      _isIncome = isIncome;
      _categories = _isIncome ? _incomeCategories : _outcomeCategories;
      _categoryController.clear();
    });
  }

  bool _validateFields() {
  setState(() {
    if (_hasTriedToSave) {
      _fieldErrors['name'] = _nameController.text.isEmpty;
      _fieldErrors['amount'] = _amountController.text.isEmpty;
      _fieldErrors['date'] = _dateController.text.isEmpty;
      _fieldErrors['category'] = _categoryController.text.isEmpty;
      _fieldErrors['paymentMethod'] = _paymentMethodController.text.isEmpty;
      _fieldErrors['repeat'] = _repeatController.text.isEmpty;
    }
  });

  return !_fieldErrors.containsValue(true);
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              ToggleButtons(
                isSelected: [_isIncome, !_isIncome],
                onPressed: (index) {
                  _onToggleChanged(index == 0);
                },
                borderRadius: BorderRadius.circular(8),
                selectedColor: Colors.white,
                fillColor: customGreen,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Income"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Outcome"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField(controller: _nameController, label: "Title", icon: Icons.edit),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _dateController,
                label: "Date",
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: _selectedDate,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _amountController,
                label: "Amount",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                controller: _categoryController,
                label: "Category",
                icon: Icons.list,
                items: _categories,
                onAddNew: _showAddCategoryDialog,
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                controller: _paymentMethodController,
                label: "Payment Method",
                icon: Icons.payment,
                items: _paymentMethods,
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                controller: _repeatController,
                label: "Repeat",
                icon: Icons.repeat,
                items: _repeatOptions,
                onAddNew: _showCustomRepeatDialog,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _descriptionController,
                label: "Description",
                icon: Icons.description,
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(100, 60),
                    ),
                    onPressed: () {
                      _nameController.clear();
                      _amountController.clear();
                      _dateController.clear();
                      _categoryController.clear();
                      _paymentMethodController.clear();
                      _repeatController.clear();
                      _descriptionController.clear();
                      setState(() {
                        _fieldErrors.updateAll((key, value) => false);
                      });
                    },
                    child: const Text("Clear", style: TextStyle(color: Colors.white)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(4, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        backgroundColor: customGreen,
                        minimumSize: const Size(200, 60),
                      ),
                      onPressed: () async {
                        setState(() {
                          _hasTriedToSave = true;  // Indica que se intentó guardar
                        });

                        if (!_validateFields()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all required fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        try {
                          AuthService authS = AuthService();
                          var userEmail = authS.currentUser?.email;

                          if (userEmail != null) {
                            await addData(userEmail, {
                              "name": _nameController.text,
                              "amount": _isIncome
                                  ? double.parse(_amountController.text)
                                  : -double.parse(_amountController.text),
                              "date": _dateController.text.split(" ")[0],
                              "tags": [
                                _categoryController.text,
                                _paymentMethodController.text,
                                _repeatController.text
                              ],
                              "description": _descriptionController.text
                            });

                            _nameController.clear();
                            _amountController.clear();
                            _dateController.clear();
                            _categoryController.clear();
                            _paymentMethodController.clear();
                            _repeatController.clear();
                            _descriptionController.clear();

                            setState(() {
                              _fieldErrors.updateAll((key, value) => false);
                              _hasTriedToSave = false;  // Reset after successful save
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data saved successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error saving data: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text("Save", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        errorText: _fieldErrors[fieldKeys[label]] == true ? 'Required' : null,
      ),
    );
  }

  Widget _buildDropdown({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> items,
    VoidCallback? onAddNew,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isNotEmpty ? controller.text : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        errorText: _fieldErrors[fieldKeys[label]] == true ? 'Required' : null,
      ),
      items: [
        ...items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))),
        if (onAddNew != null)
          const DropdownMenuItem<String>(
            value: 'Add New',
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text("Add New"),
              ],
            ),
          ),
      ],
      onChanged: (value) {
        if (value == 'Add New' && onAddNew != null) {
          onAddNew();
        } else {
          setState(() {
            controller.text = value ?? '';
          });
        }
      },
    );
  }

  Future<void> _selectedDate() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (_pickedDate != null) {
      setState(() {
        _dateController.text = _pickedDate.toString().split(' ')[0];
      });
      _selectedTime(_pickedDate);
    }
  }

  Future<void> _selectedTime(DateTime _pickedDate) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_pickedTime != null) {
      setState(() {
        String formattedTime = _pickedTime.format(context);
        _dateController.text = "${_pickedDate.toString().split(' ')[0]} $formattedTime";
      });
    }
  }

  void _showAddCategoryDialog() {
    TextEditingController _newCategoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: const Text("Add New Category"),
            content: TextField(
              controller: _newCategoryController,
              decoration: const InputDecoration(hintText: "Category name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (_newCategoryController.text.isNotEmpty) {
                    setState(() {
                      _categories.add(_newCategoryController.text);
                      _categoryController.text = _newCategoryController.text;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomRepeatDialog() {
    TextEditingController customRepeatController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: const Text("Custom Repeat"),
            content: TextField(
              controller: customRepeatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Enter number of days"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (customRepeatController.text.isNotEmpty) {
                    String customValue = "Every ${customRepeatController.text} days";
                    setState(() {
                      if (!_repeatOptions.contains(customValue)) {
                        _repeatOptions.add(customValue);
                      }
                      _repeatController.text = customValue;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Set"),
              ),
            ],
          ),
        );
      },
    );
  }
}