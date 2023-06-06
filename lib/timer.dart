import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_project/buttonwidget.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Duration countdownDuration = const Duration(minutes: 0);
  final GlobalKey<FormState> _formKeyTimer = GlobalKey<FormState>();
  // static const countdownDuration = Duration(minutes: 10);
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = true, resume = false, isEnabled = true;
  final TextEditingController timerMin = TextEditingController();
  String selectedDropDown = "Minute";
  List<String> dropDown = ['Hour', 'Minute'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reset();
  }

  @override
  void dispose() {
    timerMin.dispose();
    super.dispose();
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        isEnabled = true;
        timerMin.text = "";
        setState(() {});
        showAlertDialog(context);
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert!"),
      content: const Text("Timer has been completed.."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      isEnabled = true;
      timerMin.text = "";
      countdownDuration = const Duration(minutes: 0);
      setState(() {});
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Timer Screen"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Timer For  ",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Form(
                    key: _formKeyTimer,
                    child: SizedBox(
                      width: 120.0,
                      child: TextFormField(
                        controller: timerMin,
                        enabled: isEnabled,
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(5)],
                        decoration: InputDecoration(
                          labelText: "Hrs / Mins",
                          labelStyle: GoogleFonts.poppins(fontSize: 14),
                          errorStyle: const TextStyle(fontSize: 11.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        onChanged: (value) {
                          countdownDuration = selectedDropDown == "Hour"
                              ? Duration(hours: int.parse(value))
                              : Duration(minutes: int.parse(value));
                          reset();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter the time";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      iconSize: 30.0,
                      value: selectedDropDown,
                      items: dropDown.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        selectedDropDown = newValue!;
                        if (timerMin.text.isNotEmpty) {
                          countdownDuration = newValue == "Hour"
                              ? Duration(hours: int.parse(timerMin.text))
                              : Duration(minutes: int.parse(timerMin.text));
                          reset();
                        } else {
                          countdownDuration = newValue == "Hour"
                              ? const Duration(hours: 0)
                              : const Duration(minutes: 0);
                          reset();
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              buildTime(),
              const SizedBox(height: 80),
              buildButtons(),
            ],
          ),
        ),
      );

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(
          time: selectedDropDown == "Hour" &&
                  timerMin.text.isNotEmpty &&
                  timer == null
              ? int.parse(timerMin.text) < 10
                  ? "0${timerMin.text}"
                  : timerMin.text
              : hours,
          header: 'HOURS'),
      const SizedBox(width: 10),
      buildTimeCard(
          time: selectedDropDown == "Minute" &&
                  timerMin.text.isNotEmpty &&
                  timer == null
              ? int.parse(timerMin.text) < 10
                  ? "0${timerMin.text}"
                  : timerMin.text
              : minutes,
          header: 'MINUTES'),
      const SizedBox(width: 10),
      buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
          const SizedBox(height: 24),
          Text(header, style: const TextStyle(color: Colors.black45)),
        ],
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning && resume == false
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                  text: 'PAUSE',
                  onClicked: () {
                    if (isRunning) {
                      stopTimer(resets: false);
                      resume = true;
                      setState(() {});
                    }
                  }),
              const SizedBox(width: 12),
              ButtonWidget(text: "RESET", onClicked: stopTimer),
            ],
          )
        : resume == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                      text: 'RESUME',
                      onClicked: () {
                        startTimer();
                        resume = false;
                        setState(() {});
                      }),
                  const SizedBox(width: 12),
                  ButtonWidget(text: "RESET", onClicked: stopTimer),
                ],
              )
            : ButtonWidget(
                text: "Start Timer!",
                color: Colors.white,
                backgroundColor: Colors.green,
                onClicked: () {
                  if (_formKeyTimer.currentState!.validate()) {
                    startTimer();
                    isEnabled = false;
                    setState(() {});
                  }
                });
  }
}
