import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(DateSelection());

class DateSelection extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DateSelectionCalendar(),
    );
  }
}

class DateSelectionCalendar extends StatefulWidget {
  @override
  DateSelectionCalendarState createState() =>
      DateSelectionCalendarState();
}

class DateSelectionCalendarState
    extends State<DateSelectionCalendar> {
  List<DateTime> _blackoutDateCollection;
  List<DateTime> _activeDates;

  @override
  void initState() {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    _activeDates = [
      today,
      today.add(Duration(days: 5)),
      today.add(Duration(days: 10)),
      today.add(Duration(days: 15)),
      today.add(Duration(days: 20)),
      today.add(Duration(days: 25)),
      today.add(Duration(days: 30)),
      today.add(Duration(days: 35))
    ];
    _blackoutDateCollection = <DateTime>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.month,
          blackoutDates: _blackoutDateCollection,
          blackoutDatesTextStyle: TextStyle(
              color: Colors.grey, decoration: TextDecoration.lineThrough),
          onViewChanged: viewChanged,
        ),
      ),
    );
  }

  void viewChanged(ViewChangedDetails viewChangedDetails) {
    DateTime date;
    DateTime startDate = viewChangedDetails.visibleDates[0];
    DateTime endDate = viewChangedDetails
        .visibleDates[viewChangedDetails.visibleDates.length - 1];
    List<DateTime> _blackDates = <DateTime>[];
    for (date = startDate;
        date.isBefore(endDate) || date == endDate;
        date = date.add(const Duration(days: 1))) {
      if (_activeDates.contains(date)) {
        continue;
      }

      _blackDates.add(date);
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _blackoutDateCollection = _blackDates;
      });
    });
  }
}
