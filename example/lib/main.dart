import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final _calendarControllerToday = AdvancedCalendarController.today();
  final _calendarControllerCustom =
      AdvancedCalendarController.custom(DateTime(2022, 10, 23));
  final List<DateTime> events = [
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdvancedCalendar(
              controller: _calendarControllerToday,
              events: events,
              startWeekDay: 1,
            ),
            AdvancedCalendar(
              controller: _calendarControllerToday,
              events: events,
              startWeekDay: 1,
              showNavigationArrows: true,
            ),
            Theme(
              data: ThemeData.light().copyWith(
                textTheme: ThemeData.light().textTheme.copyWith(
                      titleMedium:
                          ThemeData.light().textTheme.titleMedium.copyWith(
                                fontSize: 16,
                                color: theme.colorScheme.secondary,
                              ),
                      bodyLarge: ThemeData.light().textTheme.bodyLarge.copyWith(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                      bodyMedium:
                          ThemeData.light().textTheme.bodyLarge.copyWith(
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
        ),
      ),
    );
  }
}
