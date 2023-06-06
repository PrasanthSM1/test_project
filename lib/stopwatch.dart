import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_project/buttonwidget.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({Key? key}) : super(key: key);

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  static const countdownDuration = Duration(minutes: 10);
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = false, resume = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reset();
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
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Stopwatch Screen"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
      buildTimeCard(time: hours, header: 'HOURS'),
      const SizedBox(width: 10),
      buildTimeCard(time: minutes, header: 'MINUTES'),
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
                text: "Start!",
                color: Colors.white,
                backgroundColor: Colors.green,
                onClicked: () {
                  startTimer();
                });
  }
}
