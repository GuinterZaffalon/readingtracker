import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class registro {
  String? title;
  String? author;
  String? publisher;
  int? editionYear;
}

class Register extends StatefulWidget {
  final Map<String, dynamic> registro;
  const Register({super.key, required this.registro});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool? isReading;
  TextEditingController dateController = TextEditingController();
  int rating = 0;
  String comment = "";

  Future<void> _showDatePicker() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_pickedDate != null) {
      setState(() {
        dateController.text =
            "${_pickedDate.day}/${_pickedDate.month}/${_pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookReceived = widget.registro;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
        title: const Text("ReadingTracker"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text("Livro: ${bookReceived["title"]}",
              style: TextStyle(fontSize: 20)),
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
                      : Column(children: [
                          const SizedBox(height: 10),
                          Text("Quando terminou a leitura?",
                              style: TextStyle(fontSize: 20)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
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
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(189, 213, 234, 1)),
                                  ),
                                ),
                                readOnly: true,
                              )),
                          Text("Quantas estrelas daria para a obra?",
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                this.rating = rating.toInt();
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Text("Gostaria de deixar alguma anotação?",
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    comment = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Escreva aqui",
                                  filled: true,
                                  prefixIcon: Icon(Icons.note_alt_outlined),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(189, 213, 234, 1)),
                                  ),
                                ),
                                maxLines: null,
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("Salvar"),
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.fromLTRB(
                                                40, 10, 40, 10)),
                                      ),
                                    ))
                              ])
                        ])),
            ),
          ),
        ],
      ),
    );
  }
}
