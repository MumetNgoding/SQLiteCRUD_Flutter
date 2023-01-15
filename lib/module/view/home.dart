// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:fhe_template/module/controller/add_employe.dart';
import 'package:fhe_template/module/controller/edit_employe.dart';
import 'package:fhe_template/module/db/MyDatabase.dart';
import 'package:fhe_template/module/view/employee.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  List<Employee> employess = List.empty(growable: true);
  final MyDatabase _myDatabase = MyDatabase();
  int count = 0;

  //get data from firebase

  getDataFromDb() async {
    await _myDatabase.initializeDatabase();
    List<Map<String, Object?>> empList = await _myDatabase.getEmpList();
    for (int i = 0; i < empList.length; i++) {
      employess.add(Employee.toEmp(empList[i]));
    }
    count = await _myDatabase.countEmp();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // employess.add(Employee(
    //     empId: 11, empName: 'empName', empDesignation: 'xyz', isMale: true));
    // employess.add(Employee(
    //     empId: 11, empName: 'empName', empDesignation: 'xyz', isMale: false));
    getDataFromDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees ($count)'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : employess.isEmpty
              ? const Center(
                  child: Text('No data Employee yet'),
                )
              : ListView.builder(
                  itemCount: employess.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditEmploye(
                                    employee: employess[index],
                                    myDatabase: _myDatabase,
                                  )),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor:
                            employess[index].isMale ? Colors.blue : Colors.pink,
                        child: Icon(
                          employess[index].isMale ? Icons.male : Icons.female,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        '${employess[index].empName} (${employess[index].empId})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(employess[index].empDesignation),
                      trailing: IconButton(
                          onPressed: () async {
                            String empName = employess[index].empName;
                            await _myDatabase.deleteEmp(employess[index]);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('$empName deleted')));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()),
                                  ((route) => false));
                            }
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddEmploye(
                      myDatabase: _myDatabase,
                    )),
          );
        },
      ),
    );
  }
}
