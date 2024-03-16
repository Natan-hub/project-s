import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:project_s/constants/const.dart';
import 'package:project_s/model/todo.dart';
import 'package:project_s/widgets/campo_tetx.dart';
import 'package:project_s/widgets/todo_item.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

List<ToDo> _foundToDo = [];

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController dataControllerInit = TextEditingController();
  TextEditingController dataControllerEnd = TextEditingController();
  final List<String> categories = ['Categoria 1', 'Categoria 2', 'Categoria 3'];
  String _selectedCategory = '';

  var formatDate = DateFormat('dd/MM/yyyy', 'pt_Br');
  DateTime dateStart = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchBox(),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Periodos",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                height: 400,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: _foundToDo.isEmpty
                    ? const Center(child: Text("Nenhum período adicionado"))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _foundToDo.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child: ToDoItem(
                              showEditPeriodDialog: showEditPeriodDialog,
                              key: Key(_foundToDo[index]
                                  .id!), // Adicionando uma chave única para cada item
                              todo: _foundToDo[index],
                              onToDoChanged: _toggleToDoStatus,
                              onDeleteItem: _deleteToDo,
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddPeriodDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azulPadrao,
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
                    child: const Text(
                      'Adicionar periodo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/images/avatar.jpeg'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "João",
                        style: TextStyle(color: azulPadrao),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Sair",
                        style: TextStyle(
                          color: azulPadrao,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleToDoStatus(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDo(String? id) {
    setState(() {
      _foundToDo.removeWhere((element) => element.id == id);
    });
  }

  Widget searchBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0),
                  prefixIconConstraints: const BoxConstraints(
                    maxHeight: 20,
                    minWidth: 25,
                  ),
                  border: InputBorder.none,
                  labelText: '  Apelido',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  labelStyle: const TextStyle(color: cinzaPadrao),
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/avatar.jpeg'),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Editar foto",
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget campoData(BuildContext context, String label, controllerDate) {
    TextEditingController? controller = controllerDate;
    String dateText = controller!.text; // Obtenha o valor atual do controlador
    return CampoUserSenha(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      controller: controller,
      readOnly: true,
      onTap: () async {
        if (Platform.isAndroid) {
          DateTime? newDate = await pickDateRangeStrAndroid(context, dateText);
          if (newDate != null) {
            controller.text = formatDate.format(newDate);
          }
        } else if (Platform.isIOS) {
          DateTime? newDate = await pickDateRangeStrIOS(context, dateText);
          if (newDate != null) {
            controller.text = formatDate.format(newDate);
          }
        }
      },
      hintText: (dateText.isNotEmpty)
          ? formatDate.format(formatDate.parse(dateText))
          : label,
      obscureText: false,
      suffixIcon: const Icon(
        Icons.calendar_month_outlined,
        color: azulPadrao,
      ),
      prefixIcon: null,
    );
  }

  Future<DateTime?> pickDateRangeStrAndroid(
      BuildContext context, String dateText) async {
    DateTime? selectedDate = dateStart;
    if (dateText.isNotEmpty) {
      selectedDate = formatDate.parse(dateText);
    }

    DateTime? newDate = await showDatePicker(
      locale: const Locale('pt', 'BR'),
      context: context,
      initialDate: selectedDate,
      initialEntryMode: DatePickerEntryMode.calendar,
      lastDate: DateTime(DateTime.now().year + 1),
      firstDate: DateTime(1900),
    );

    if (newDate != null) {
      return newDate;
    }
    return null;
  }

  Future<DateTime?> pickDateRangeStrIOS(
      BuildContext context, String dateText) async {
    DateTime? selectedDate = dateStart;
    if (dateText.isNotEmpty) {
      selectedDate = formatDate.parse(dateText);
    }

    DateTime? newDate = await showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (context) => CupertinoActionSheet(
              title: const Text('Selecionar Data'),
              actions: [
                SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height / 3,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime newDateTime) {
                      selectedDate = newDateTime;
                    },
                    initialDateTime: selectedDate,
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year + 1,
                  ),
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    if (selectedDate != null) {
                      String formattedDate = formatDate.format(selectedDate!);
                      dateText =
                          formattedDate; // Atualiza o texto do controlador
                      Navigator.pop(
                          context, selectedDate); // Retorna a data selecionada
                    }
                  },
                  child: const Text('OK')),
            ));

    if (newDate != null) {
      return newDate;
    }
    return null;
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      title: const Text("Configurações"),
    );
  }

  void _showAddPeriodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novo Período'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Nomeie seu periodo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                campoData(context, "Começa", dataControllerInit),
                const SizedBox(height: 15),
                campoData(context, "Termina", dataControllerEnd),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value:
                      _selectedCategory.isNotEmpty ? _selectedCategory : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addPeriod(_titleController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Concluir'),
            ),
          ],
        );
      },
    );
  }

  void showEditPeriodDialog(BuildContext context, ToDo todo) {
    _titleController.text = todo.todoText!;
    dataControllerInit.text =
        dataControllerInit.text; // Defina aqui a descrição do período
    dataControllerEnd.text =
        dataControllerEnd.text; // Defina aqui o outro campo, se houver
    _selectedCategory = ''; // Defina aqui a categoria selecionada

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Editar Período'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nomeie seu periodo',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  campoData(context, "Começa", dataControllerInit),
                  const SizedBox(height: 15),
                  campoData(context, "Termina", dataControllerEnd),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value:
                        _selectedCategory.isNotEmpty ? _selectedCategory : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updatePeriod(todo);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updatePeriod(ToDo updatedTodo) {
    setState(() {
      // Procura o período na lista pelo ID e atualiza os detalhes
      for (int i = 0; i < _foundToDo.length; i++) {
        if (_foundToDo[i].id == updatedTodo.id) {
          _foundToDo[i] = updatedTodo;
          break;
        }
      }
    });
  }

  void _addPeriod(String toDo) {
    setState(() {
      _foundToDo.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
    });
  }
}
