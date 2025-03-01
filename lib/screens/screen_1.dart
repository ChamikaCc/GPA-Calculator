import 'package:flutter/material.dart';
import 'screen_2.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  List<Map<String, dynamic>> courses = [];
  List<String> grades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "E"];

  void calculateGPA() {
    double totalGradePoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      int credit = course['credit'];
      double gradePoint = getGradePoint(course['grade']);
      totalGradePoints += credit * gradePoint;
      totalCredits += credit;
    }

    double gpa = totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen2(gpa: gpa),
      ),
    );
  }

  double getGradePoint(String grade) {
    Map<String, double> gradePoints = {
      "A+": 4.0, "A": 4.0, "A-": 3.7, "B+": 3.3, "B": 3.0, "B-": 2.7,
      "C+": 2.3, "C": 2.0, "C-": 1.7, "D+": 1.3, "D": 1.0, "E": 0.0,
    };
    return gradePoints[grade] ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enter Courses",
          style: TextStyle(color: Color(0xFFfefefe)), // AppBar title color set to #fefefe
        ),
        backgroundColor: Color(0xFF3700B3), // #3700B3 for AppBar
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;
          return Padding(
            padding: EdgeInsets.all(16),
            child: isWideScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildContent(isWideScreen),
                  )
                : Column(
                    children: _buildContent(isWideScreen),
                  ),
          );
        },
      ),
    );
  }

  List<Widget> _buildContent(bool isWideScreen) {
    return [
      Flexible(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Course Button at the top-right
            Align(
              alignment: Alignment.topRight,
              child: _buildButton("Add Course", Color(0xFF6200EE), () async { // #6200EE for button background
                var newCourse = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) => AddCourseDialog(grades: grades),
                );
                if (newCourse != null) {
                  setState(() => courses.add(newCourse));
                }
              }),
            ),
            SizedBox(height: 10),
            Expanded(
              child: courses.isEmpty
                  ? Center(child: Text("No courses added yet."))
                  : ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFF03DAC5), // #03DAC5 for card color
                          child: ListTile(
                            title: Text(
                              "Course: ${courses[index]['name']}",
                              style: TextStyle(
                                color: Color.fromARGB(255, 10, 10, 10),
                                fontWeight: FontWeight.bold, // This makes the text bold
                              ),
                            ),
                            subtitle: Text(
                              "Credit: ${courses[index]['credit']}, Grade: ${courses[index]['grade']}",
                              style: TextStyle(
                                color: Color.fromARGB(255, 10, 10, 10),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Color(0xFFfefefe)), // #fefefe for delete icon color
                              onPressed: () => setState(() => courses.removeAt(index)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            // Calculate GPA Button at the bottom-right
            Align(
              alignment: Alignment.bottomRight,
              child: _buildButton("Calculate GPA", Color(0xFF6200EE), courses.isNotEmpty ? calculateGPA : null), // #6200EE for button background
            ),
          ],
        ),
      ),
      if (isWideScreen)
        SizedBox(width: 20),
      Flexible(
        flex: 1,
        child: Image.asset(
          'assets/gpa.png',
          width: isWideScreen ? 350 : MediaQuery.of(context).size.width * 0.8,
          height: isWideScreen ? 500 : 250,
          fit: BoxFit.contain,
        ),
      ),
    ];
  }

  Widget _buildButton(String text, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Color(0xFFfefefe))), // Set text color to #fefefe
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(120, 50),
      ),
    );
  }
}

class AddCourseDialog extends StatefulWidget {
  final List<String> grades;
  AddCourseDialog({required this.grades});

  @override
  _AddCourseDialogState createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController creditController = TextEditingController();
  String selectedGrade = "A";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Course"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Course Name"),
          ),
          TextField(
            controller: creditController,
            decoration: InputDecoration(labelText: "Number of Credits"),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField(
            value: selectedGrade,
            onChanged: (value) => setState(() => selectedGrade = value as String),
            items: widget.grades.map((grade) => DropdownMenuItem(value: grade, child: Text(grade))).toList(),
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'name': nameController.text,
                'credit': int.tryParse(creditController.text) ?? 0,
                'grade': selectedGrade,
              });
            },
            child: Text(
              "Add",
              style: TextStyle(color: Color(0xFFfefefe)), // Set text color to #fefefe
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6200EE),
            ),
          ),
        ),
      ],
    );
  }
}
