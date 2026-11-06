import 'package:flutter/material.dart';
import 'assessment_model.dart';
import 'auth_screen.dart';

class UniGradeHome extends StatefulWidget {
  const UniGradeHome({super.key});

  @override
  State<UniGradeHome> createState() => _UniGradeHomeState();
}

class _UniGradeHomeState extends State<UniGradeHome> {
  final List<Assessment> _assessments = [
    Assessment(id: '1', courseCode: 'CSE-311', title: 'Quiz 1', marksObtained: 16.0, totalMarks: 20.0),
    Assessment(id: '2', courseCode: 'SWE-432', title: 'Midterm Exam', marksObtained: 26.5, totalMarks: 30.0),
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _obtainedController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  void _createAssessment(String code, String title, double obtained, double total) {
    setState(() {
      _assessments.add(Assessment(id: DateTime.now().toString(), courseCode: code, title: title, marksObtained: obtained, totalMarks: total));
    });
  }

  void _updateAssessment(String id, String code, String title, double obtained, double total) {
    setState(() {
      final index = _assessments.indexWhere((element) => element.id == id);
      if (index != -1) {
        _assessments[index] = Assessment(id: id, courseCode: code, title: title, marksObtained: obtained, totalMarks: total);
      }
    });
  }

  void _deleteAssessment(String id) {
    setState(() {
      _assessments.removeWhere((element) => element.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grade row erased successfully.'), backgroundColor: Colors.redAccent));
  }

  void _showFormModal({Assessment? item}) {
    if (item != null) {
      _codeController.text = item.courseCode;
      _titleController.text = item.title;
      _obtainedController.text = item.marksObtained.toString();
      _totalController.text = item.totalMarks.toString();
    } else {
      _codeController.clear();
      _titleController.clear();
      _obtainedController.clear();
      _totalController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(item == null ? 'Record Marks Entry' : 'Modify Record Details', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextFormField(controller: _codeController, decoration: const InputDecoration(labelText: 'Course Code', border: OutlineInputBorder()), validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Assessment Title', border: OutlineInputBorder()), validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _obtainedController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Marks Secured', border: OutlineInputBorder()), validator: (val) => val == null || double.tryParse(val) == null ? 'Must be numerical' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _totalController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Marks Out-Of', border: OutlineInputBorder()), validator: (val) => val == null || double.tryParse(val) == null ? 'Must be numerical' : null),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      double opt = double.parse(_obtainedController.text);
                      double tot = double.parse(_totalController.text);
                      if (item == null) {
                        _createAssessment(_codeController.text, _titleController.text, opt, tot);
                      } else {
                        _updateAssessment(item.id, _codeController.text, _titleController.text, opt, tot);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(item == null ? 'Save Mark' : 'Apply Changes'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page 64 A'), backgroundColor: Colors.blue, foregroundColor: Colors.white, actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search)), IconButton(onPressed: () {}, icon: const Icon(Icons.person))]),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(decoration: BoxDecoration(color: Colors.blue), accountName: Text('Syeda Arfa'), accountEmail: Text('arfa.student@unigrade.com')),
            ListTile(trailing: const Icon(Icons.home), title: const Text('Home Page'), onTap: () => Navigator.pop(context)),
            const Divider(color: Colors.blue),
            const Spacer(),
            ListTile(trailing: const Icon(Icons.logout, color: Colors.red), title: const Text('LOG OUT'), onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()))),
          ],
        ),
      ),
      body: _assessments.isEmpty
          ? const Center(child: Text('No academic scores tracked yet.', style: TextStyle(fontSize: 16, color: Colors.grey)))
          : ListView.builder(
              itemCount: _assessments.length,
              itemBuilder: (context, index) {
                final item = _assessments[index];
                final rate = item.scorePercentage;
                return Card(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
                  elevation: 6,
                  shadowColor: rate >= 50 ? Colors.blueAccent : Colors.redAccent,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: rate >= 50 ? Colors.blue.shade50 : Colors.red.shade50,
                      child: Text("${rate.toStringAsFixed(0)}%", style: TextStyle(fontWeight: FontWeight.bold, color: rate >= 50 ? Colors.blue : Colors.red)),
                    ),
                    title: Text('[${item.courseCode}] ${item.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Score Card: ${item.marksObtained} / ${item.totalMarks}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showFormModal(item: item)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteAssessment(item.id)),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showFormModal(), backgroundColor: Colors.blue, foregroundColor: Colors.white, tooltip: 'Add Something', shape: const CircleBorder(), child: const Icon(Icons.add)),
    );
  }
}
