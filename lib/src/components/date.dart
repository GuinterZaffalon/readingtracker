import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DatePickerField({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controllerDate;

  @override
  void initState() {
    super.initState();
    _controllerDate = TextEditingController();
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<void> _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      widget.onDateSelected(pickedDate);
      setState(() {
        _controllerDate.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Quando terminou a leitura?",
          style: TextStyle(fontSize: 20),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 15),
          child: TextField(
            controller: _controllerDate,
            onTap: _showDatePicker,
            decoration: InputDecoration(
              labelText: "Insira a data",
              filled: true,
              prefixIcon: const Icon(Icons.calendar_today),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(189, 213, 234, 1),
                ),
              ),
            ),
            readOnly: true,
          ),
        ),
      ],
    );
  }
}
