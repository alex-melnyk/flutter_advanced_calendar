import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _calendarControllerToday = AdvancedCalendarController.today();
  final _calendarControllerCustom =
      AdvancedCalendarController.custom(DateTime(2021, 2, 16));
  final List<DateTime> events = [
    DateTime.utc(2021, 08, 10, 12),
    DateTime.utc(2021, 08, 11, 12)
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
                startWeekDay: 1),
            Theme(
              data: ThemeData.light().copyWith(
                textTheme: ThemeData.light().textTheme.copyWith(
                      subtitle1: ThemeData.light().textTheme.subtitle1.copyWith(
                            fontSize: 16,
                            color: theme.accentColor,
                          ),
                      bodyText1: ThemeData.light().textTheme.bodyText1.copyWith(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                      bodyText2: ThemeData.light().textTheme.bodyText1.copyWith(
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
                  startWeekDay: 1),
            ),
          ],
        ),
      ),
    );
  }
}
