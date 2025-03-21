import 'package:aviato_finance/Components/globalVariables.dart';
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
  final Color customRed = Color.fromRGBO(160, 74, 67, 1);
  final Color customGreen = Color.fromARGB(255, 161, 195, 105); 
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _paymentMethodController =
      TextEditingController();
  final List<String> _outcomeCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
  ];
  final List<String> _incomeCategories = [
    'Salary',
    'Freelance',
    'Gift',
    'Extra Income',
  ];
  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
  ];
  final List<String> _repeatOptions = [
    'Daily',
    'Every 3 days',
    'Weekly',
    'Monthly',
    'Every 6 months',
  ];
  final TextEditingController _repeatController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<String> _categories = []; // Added to store categories dynamically

  bool _isIncome = true; // true = Income, false = Outcome

  @override
  void initState() {
    super.initState();
    _categories = _incomeCategories; // Initialize with income categories
  }

  void _onToggleChanged(bool isIncome) {
    setState(() {
      _isIncome = isIncome;
      _categories = _isIncome ? _incomeCategories : _outcomeCategories;
      _categoryController.clear();
    });
  }

  // void addData hace referencia a la función que se ejecuta al presionar el botón de "Save",
  //se encarga de validar que los campos no estén vacíos y muestra un mensaje emergente
  //en caso de que no se haya llenado algún campo.
  //pero no se ha implementado la función de agregar datos a la base de datos. xd :v
  // ignore: slash_for_doc_comments
  /** 
  void _addData() {
    if (_nameController.text.isNotEmpty && _amountController.text.isNotEmpty) {
      // ignore: unintended_html_in_doc_comment, unintended_html_in_doc_comment
      final Map<String, dynamic> data = {
        "type": _isIncome ? 'Income' : 'Outcome',
        "name": _nameController.text,
        "amount": double.parse(_amountController.text),
        "date": DateTime.now().toIso8601String(),
        "categoryOutcome": _categoryController.text,
        "paymentMethod": _paymentMethodController.text,
        "repeat": _repeatController.text,
        "description": _descriptionController.text,
      };
      print(data); // Use the data variable by printing it
      Navigator.pop(context);
    }
  }
*/
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/addData');
        break;
      case 2:
        Navigator.pushNamed(context, '/stats');
        break;
      default:
      // Handle any other cases if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centrar el texto de la AppBar
        title: const Text("Add Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                  fillColor: _isIncome ? customGreen : customGreen,
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
                _buildTextField(
                  controller: _nameController,
                  label: "Title",
                  icon: Icons.edit,
                ),
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
                  keyboardType: TextInputType.number, // Solo datos numéricos
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                ),
                const SizedBox(height: 10),
                _buildDropdown(
                  controller: _categoryController,
                  label: "Category",
                  icon: Icons.list,
                  items: _categories, // Use dynamic categories
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
                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(100, 60), // Ancho de 200 y alto de 60
                      ),
                      onPressed: () {
                        if (_nameController.text.isNotEmpty &&
                            _amountController.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Continue adding data')),
                          );
                          _nameController.clear();
                          _amountController.clear();
                          _dateController.clear();
                          _categoryController.clear();
                          _paymentMethodController.clear();
                          _repeatController.clear();
                          _descriptionController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please fill in all required fields',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.2,
                            ), // Color y opacidad de la sombra
                            spreadRadius: 2, // Difuminado hacia afuera
                            blurRadius: 8, // Suavizado de la sombra
                            offset: const Offset(
                              4,
                              4,
                            ), // Desplazamiento de la sombra
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: customGreen,
                          minimumSize: const Size(
                            200,
                            60,
                          ), // Ancho de 200 y alto de 60
                        ),
                        onPressed: () {
                          _nameController.clear();
                          _amountController.clear();
                          _dateController.clear();
                          _categoryController.clear();
                          _paymentMethodController.clear();
                          _repeatController.clear();
                          _descriptionController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.grey, // Texto siempre gris
        unselectedItemColor: Colors.grey, // Texto no seleccionado también gris
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              alignment:
                  Alignment.center, // Centrar el ícono dentro del rectángulo
              child: const Icon(
                Icons.home_filled,
                color: Color.fromARGB(255, 85, 91, 89),
              ), // Ícono blanco
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 60, // Ancho del rectángulo
              height: 40, // Altura del rectángulo
              decoration: BoxDecoration(
                color:
                    _selectedIndex == 1
                        ? customGreen
                        : Colors
                            .transparent, // Fondo relleno si está seleccionado
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
              ),
              alignment:
                  Alignment.center, // Centrar el ícono dentro del rectángulo
              child: const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ), // Ícono blanco
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Container(
              alignment:
                  Alignment.center, // Centrar el ícono dentro del rectángulo
              child: const Icon(
                Icons.bar_chart_rounded,
                color: Color.fromARGB(255, 91, 76, 76),
              ),
            ),
            label: 'Stats',
          ),
        ],
      ),
    );
  }

  // Función para construir un campo de texto con un icono a la izquierda y un borde redondeado de 8
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
      inputFormatters: inputFormatters,
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // función para construir un menú desplegable con un icono a la izquierda y un borde redondeado de 8
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
      ),
      items: [
        ...items.map((item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }),
        if (onAddNew != null)
          DropdownMenuItem<String>(
            value: 'Add New',
            child: Row(
              children: const [
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

  // Función para seleccionar la fecha y la hora
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

  // Función para seleccionar la hora
  Future<void> _selectedTime(DateTime _pickedDate) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (_pickedTime != null) {
      setState(() {
        String formattedTime = _pickedTime.format(context);
        _dateController.text =
            "${_pickedDate.toString().split(' ')[0]} $formattedTime";
      });
    }
  }

  // Función para mostrar un diálogo para agregar una nueva categoría
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (_newCategoryController.text.isNotEmpty) {
                    setState(() {
                      _categories.add(
                        _newCategoryController.text,
                      ); // Use _categories directly
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

  // Función para mostrar un diálogo para agregar una nueva repetición personalizada
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
              decoration: const InputDecoration(
                hintText: "Enter number of days",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (customRepeatController.text.isNotEmpty) {
                    String customValue =
                        "Every ${customRepeatController.text} days";
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
