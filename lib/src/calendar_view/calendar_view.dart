library calendar_view;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'controller.dart';
part 'data.dart';
part 'data_modelling.dart';
part 'extensions.dart';
part 'widgets.dart';

class CalendarView extends StatefulWidget {
  final double width;
  final CalendarViewController controller;
  final CalendarClick? onClick;
  final CalendarHover? onHover;
  final CalendarColorScheme? colorScheme;
  const CalendarView({
    super.key,
    required this.controller,
    this.width = 280,
    this.onClick,
    this.onHover,
    this.colorScheme,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  void initState() {
    widget.controller._init(setState, widget.onClick, widget.onHover);
    CalendarViewWidgets.setColorScheme(
        widget.colorScheme ?? const CalendarColorScheme());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      // height: widget.height,
      width: widget.width,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          // mainAxisSpacing: 3,
          // crossAxisSpacing: 8,
        ),
        itemCount: 49,
        itemBuilder: (context, index) =>
            widget.controller._buildMonthElemet(index),
      ),
    );
  }
}
