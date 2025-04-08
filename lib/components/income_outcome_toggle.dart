import 'package:flutter/material.dart';

class IncomeOutcomeToggle extends StatefulWidget {
  final VoidCallback onIncomeSelected;
  final VoidCallback onOutcomeSelected;

  const IncomeOutcomeToggle({
    super.key,
    required this.onIncomeSelected,
    required this.onOutcomeSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _IncomeOutcomeToggleState createState() => _IncomeOutcomeToggleState();
}

class _IncomeOutcomeToggleState extends State<IncomeOutcomeToggle> {
  List<bool> isSelected = [true, false]; // "Income" seleccionado por defecto
  String selectedOption = "Income"; // Variable que cambia

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      borderRadius: BorderRadius.circular(10),
      selectedColor: Colors.white,
      fillColor: Colors.green,
      color: Colors.black,
      borderWidth: 2,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Income"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Outcome"),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = (i == index);
          }
          selectedOption = index == 0 ? "Income" : "Outcome";

          // Llama la función que se pasó al widget
          if (selectedOption == "Income") {
            widget.onIncomeSelected();
          } else {
            widget.onOutcomeSelected();
          }
        });
      },
    );
  }
}
