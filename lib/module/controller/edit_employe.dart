import 'package:fhe_template/module/db/MyDatabase.dart';
import 'package:fhe_template/module/view/employee.dart';
import 'package:flutter/material.dart';

import '../view/home.dart';

class EditEmploye extends StatefulWidget {
  final MyDatabase myDatabase;
  const EditEmploye(
      {super.key, required this.employee, required this.myDatabase});

  final Employee employee;

  @override
  State<EditEmploye> createState() => _EditEmploye();
}

class _EditEmploye extends State<EditEmploye> {
  bool isFemale = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    idController.text = '${widget.employee.empId}';
    nameController.text = widget.employee.empName;
    designationController.text = widget.employee.empDesignation;
    isFemale = widget.employee.isMale ? false : true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employe"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              enabled: false,
              focusNode: _focusNode,
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Employee Id',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: nameController,
              //keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Employee Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: designationController,
              //keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Employee Designation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Male',
                  style: TextStyle(
                    fontWeight: isFemale ? FontWeight.normal : FontWeight.bold,
                    color: isFemale ? Colors.blue : Colors.blue,
                  ),
                ),
                Icon(
                  Icons.male,
                  color: isFemale ? Colors.blue : Colors.blue,
                ),
              ],
            ),
            Switch(
              value: isFemale,
              onChanged: (newValue) {
                setState(() {
                  isFemale = newValue;
                });
              },
            ),
            Row(
              children: [
                Text(
                  'Female',
                  style: TextStyle(
                    fontWeight: isFemale ? FontWeight.bold : FontWeight.normal,
                    color: isFemale ? Colors.pink : Colors.grey,
                  ),
                ),
                Icon(
                  Icons.male,
                  color: isFemale ? Colors.red : Colors.pink,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Employee employee = Employee(
                        empId: int.parse(idController.text),
                        empName: nameController.text,
                        empDesignation: designationController.text,
                        isMale: !isFemale);
                    await widget.myDatabase.updateEmp(employee);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text('${employee.empName} updated')));
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                          ((route) => false));
                    }
                  },
                  child: const Text("Update"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () {
                    idController.text = '';
                    nameController.text = '';
                    designationController.text = '';
                    isFemale = false;
                    setState(() {});
                    _focusNode.requestFocus();
                  },
                  child: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
