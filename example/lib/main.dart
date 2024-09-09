import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _calendarControllerToday = AdvancedCalendarController.today();
  final _calendarControllerCustom =
      AdvancedCalendarController(DateTime(2022, 10, 23));
  final events = <DateTime>[
    DateTime.now(),
    DateTime(2022, 10, 10),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Advanced Calendar Example'),
        ),
        body: Builder(builder: (context) {
          final theme = Theme.of(context);

          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdvancedCalendar(
                showNavigationArrows: true,
                controller: _calendarControllerToday,
                events: events,
                startWeekDay: 1,
              ),
              Theme(
                data: theme.copyWith(
                  textTheme: theme.textTheme.copyWith(
                    titleMedium: theme.textTheme.titleMedium!.copyWith(
                      fontSize: 16,
                      color: theme.colorScheme.secondary,
                    ),
                    bodyLarge: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    bodyMedium: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  primaryColor: Colors.red,
                  highlightColor: Colors.yellow,
                  disabledColor: Colors.green,
                ),
                child: AdvancedCalendar(
                  controller: _calendarControllerCustom,
                  events: events,
                  weekLineHeight: 48.0,
                  startWeekDay: 1,
                  innerDot: true,
                  keepLineSize: true,
                  calendarTextStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    height: 1.3125,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
