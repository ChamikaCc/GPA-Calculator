import 'package:flutter/material.dart';
import 'screen_2.dart';

/// The first screen of the GPA Calculator application.
///
/// This screen allows users to input course details such as course name,
/// credit hours, and grade. Users can add multiple courses, delete them,
/// and finally calculate the GPA.
class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  /// A list to store course details including name, credit hours, and grade.
  List<Map<String, dynamic>> courses = [];

  /// A list of available grades for selection.
  List<String> grades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "E"];

  /// Calculates the GPA based on the added courses and navigates to the results screen.
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

  /// Returns the grade point value corresponding to a given grade.
  ///
  /// If the grade is not found, it defaults to 0.0.
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
        backgroundColor: Color(0xFF3700B3), // AppBar color
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

  /// Builds the main content of the screen, including the form and buttons.
  List<Widget> _buildContent(bool isWideScreen) {
    return [
      Flexible(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Button to add a new course.
            Align(
              alignment: Alignment.topRight,
              child: _buildButton("Add Course", Color(0xFF6200EE), () async {
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
            /// Displays the list of added courses.
            Expanded(
              child: courses.isEmpty
                  ? Center(child: Text("No courses added yet."))
                  : ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFF03DAC5),
                          child: ListTile(
                            title: Text(
                              "Course: ${courses[index]['name']}",
                              style: TextStyle(
                                color: Color.fromARGB(255, 10, 10, 10),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Credit: ${courses[index]['credit']}, Grade: ${courses[index]['grade']}",
                              style: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Color(0xFFfefefe)),
                              onPressed: () => setState(() => courses.removeAt(index)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            /// Button to calculate GPA.
            Align(
              alignment: Alignment.bottomRight,
              child: _buildButton("Calculate GPA", Color(0xFF6200EE), courses.isNotEmpty ? calculateGPA : null),
            ),
          ],
        ),
      ),
      if (isWideScreen) SizedBox(width: 20),
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

  /// Creates a styled button with the given [text], [color], and [onPressed] callback.
  Widget _buildButton(String text, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Color(0xFFfefefe))),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(120, 50),
      ),
    );
  }
}

/// A dialog that allows the user to input course details.
///
/// The user can enter the course name, credit hours, and select a grade from a dropdown menu.
class AddCourseDialog extends StatefulWidget {
  /// The list of grades available for selection.
  final List<String> grades;

  AddCourseDialog({required this.grades});

  @override
  _AddCourseDialogState createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  /// Controller for the course name input field.
  TextEditingController nameController = TextEditingController();

  /// Controller for the course credit input field.
  TextEditingController creditController = TextEditingController();

  /// The selected grade from the dropdown.
  String selectedGrade = "A";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Course"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Input field for course name.
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Course Name"),
          ),
          /// Input field for course credits.
          TextField(
            controller: creditController,
            decoration: InputDecoration(labelText: "Number of Credits"),
            keyboardType: TextInputType.number,
          ),
          /// Dropdown for selecting the course grade.
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
            child: Text("Add", style: TextStyle(color: Color(0xFFfefefe))),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6200EE)),
          ),
        ),
      ],
    );
  }
}
