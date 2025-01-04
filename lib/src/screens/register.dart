import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool? isReading;
  TextEditingController dateController = TextEditingController();

  Future<void> _showDatePicker() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if(_pickedDate != null) {
      setState(() {
        dateController.text = "${_pickedDate.day}/${_pickedDate.month}/${_pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
        title: const Text("ReadingTracker"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Acabou a leitura?", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isReading = false;
                  });
                },
                child: const Text("Sim"),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isReading = true;
                  });
                },
                child: const Text("Não"),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: isReading == null
                  ? const Text("Escolha uma opção.")
                  : (isReading!
                  ? const Text("Ainda estou lendo")
                  : Column(
                  children: [
                    const SizedBox(height: 10),
                    Text("Quando terminou a leitura?", style: TextStyle(fontSize: 20)),
                    Padding(padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: TextField(
                      controller: dateController,
                      onTap: () {
                        _showDatePicker();
                      },
                      decoration: InputDecoration(
                        labelText: "Insira a data",
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(189, 213, 234, 1)),
                        ),
                      ),
                      readOnly: true,
                    )),
                  ]
              )
              ),
            ),
          ),
        ],
      ),
    );
  }

}
