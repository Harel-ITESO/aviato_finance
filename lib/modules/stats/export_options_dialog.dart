import 'package:aviato_finance/modules/stats/exporter_enum.dart';
import 'package:aviato_finance/utils/colors.dart';
import 'package:flutter/material.dart';

Future<void> showExportDialogOptions(
  BuildContext context,
  Future<void> Function(SelectedExporter) exportSetter,
) {
  List<Widget> options =
      SelectedExporter.values.map((exporter) {
        return SimpleDialogOption(
          onPressed: () async {
            try {
              Navigator.pop(context);
              await exportSetter(exporter);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  backgroundColor: customGreen,
                  showCloseIcon: true,
                  closeIconColor: Colors.white,
                  content: Text(
                    "${exporter.name.toUpperCase()} successfully exported",
                  ),
                ),
              );
            } catch (e) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: customRed,
                  showCloseIcon: true,
                  closeIconColor: Colors.white,
                  content: Text(e.toString()),
                ),
              );
            }
          },
          child: Text("Export to ${exporter.name.toUpperCase()}"),
        );
      }).toList();
  return showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text("Select export option"),
        children: options,
      );
    },
  );
}
