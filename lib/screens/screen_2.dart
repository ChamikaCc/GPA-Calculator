import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

/// Screen2 displays the calculated GPA along with a confetti animation.
/// It adapts its layout based on screen width to provide an optimal UI experience.
class Screen2 extends StatefulWidget {
  /// The GPA value passed from the previous screen.
  final double gpa;

  /// Constructor to initialize Screen2 with a required GPA value.
  Screen2({required this.gpa});

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GPA Result",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF3700B3),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;
          return Stack(
            children: [
              Center(
                child: Container(
                  width: constraints.maxWidth * 0.95,
                  color: Color(0xFFfefefe),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: isWideScreen
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/girl.png',
                                  width: constraints.maxWidth * 0.3,
                                  height: constraints.maxWidth * 0.3,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: _buildGPASection(context),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/girl.png',
                                width: constraints.maxWidth * 0.6,
                                height: constraints.maxWidth * 0.6,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildGPASection(context),
                          ],
                        ),
                ),
              ),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                createParticlePath: (size) {
                  return Path()..addOval(Rect.fromCircle(center: Offset(0, 0), radius: 10));
                },
                emissionFrequency: 0.05,
                maxBlastForce: 30,
                minBlastForce: 15,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Builds the GPA display section, which adapts to the screen size.
  Widget _buildGPASection(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Your GPA",
          style: TextStyle(
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3700B3),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: screenWidth * 0.85,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Color(0xFF03DAC5), width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.gpa.toStringAsFixed(2),
              style: TextStyle(
                fontSize: screenWidth * 0.1,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
