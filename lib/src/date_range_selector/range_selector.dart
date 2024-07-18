library date_range_selector;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../calendar_view/calendar_view.dart';

part 'junky_logic.dart';
part 'range_selector_logic.dart';

typedef BottomBarBuilder = Widget Function(
  RangeSelectorLogic logic,
  BuildContext context,
);

class RangeSelector extends StatefulWidget {
  final double width;
  final double spacing;
  final double crossAxisPadding;
  final Color dividerColor;
  final TextStyle? headerTextStyle;
  final CalendarColorScheme? colorScheme;
  final BottomBarBuilder? bottomBar;
  final DateTime? startDate;
  final DateTime? endDate;
  const RangeSelector({
    super.key,
    this.width = 520,
    this.spacing = 24,
    this.crossAxisPadding = 12,
    this.dividerColor = Colors.grey,
    this.headerTextStyle,
    this.colorScheme,
    this.bottomBar,
    this.startDate,
    this.endDate,
  });

  @override
  State<RangeSelector> createState() => _RangeSelectorState();
}

class _RangeSelectorState extends State<RangeSelector> {
  late double maxWidth;
  late double calendarViewWidth;

  late RangeSelectorLogic logic;

  @override
  void initState() {
    logic = RangeSelectorLogic(
        startDate: widget.startDate, endDate: widget.endDate);
    maxWidth = widget.width + widget.spacing + (widget.crossAxisPadding * 2);
    calendarViewWidth = widget.width / 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      width: maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _calendarControls(
                controller: logic.startController,
                notifier: logic.startCalendarDate,
              ),
              SizedBox(width: widget.spacing),
              _calendarControls(
                controller: logic.endController,
                notifier: logic.endCalendarDate,
              ),
            ],
          ),
          Divider(
            color: widget.dividerColor,
            height: 0,
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _calendarView(logic.startController),
              SizedBox(width: widget.spacing),
              _calendarView(logic.endController),
            ],
          ),
          const SizedBox(height: 7),
          Divider(
            color: widget.dividerColor,
            height: 0,
          ),
          if (widget.bottomBar != null) widget.bottomBar!.call(logic, context),
          // Container(
          //   height: 44,
          //   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          //   alignment: Alignment.centerRight,
          //   child: SizedBox(
          //     width: 55,
          //     child: MaterialButton(
          //       color: Colors.blue,
          //       onPressed: () {
          //         print(logic.startRange);
          //         print(logic.endRange);
          //       },
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(2),
          //       ),
          //       elevation: 0,
          //       child: const Text(
          //         'OK',
          //         overflow: TextOverflow.ellipsis,
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  CalendarView _calendarView(
    CalendarViewController controller,
  ) {
    return CalendarView(
      controller: controller,
      width: calendarViewWidth,
      colorScheme: widget.colorScheme,
      onHover: (calendarElemet, value) {
        logic.onHover(
          calendarElemet,
          controller,
          value,
        );
      },
      onClick: (calendarElemet) {
        logic.onClick(calendarElemet, controller);
      },
    );
  }

  Widget _calendarControls({
    required CalendarViewController controller,
    required ValueNotifier<String> notifier,
  }) {
    return SizedBox(
      height: 42,
      width: calendarViewWidth,
      child: Row(
        children: [
          InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              logic.calendarMovement(
                calendarMovementType: CalendarMovementType.previousYear,
                notifier: notifier,
                controller: controller,
              );
            },
            child: SvgPicture.asset(
              CalendarViewData.doublerrowImage,
              package: 'range_mason',
            ),
          ),
          InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              logic.calendarMovement(
                calendarMovementType: CalendarMovementType.previousMonth,
                notifier: notifier,
                controller: controller,
              );
            },
            child: SvgPicture.asset(
              CalendarViewData.singleArrowImage,
              package: 'range_mason',
            ),
          ),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, val, _) {
              return Text(
                val,
                style: widget.headerTextStyle,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          const Spacer(),
          Transform.rotate(
            angle: math.pi,
            child: InkWell(
              hoverColor: Colors.transparent,
              onTap: () {
                logic.calendarMovement(
                  calendarMovementType: CalendarMovementType.nextMonth,
                  notifier: notifier,
                  controller: controller,
                );
              },
              child: SvgPicture.asset(
                CalendarViewData.singleArrowImage,
                package: 'range_mason',
              ),
            ),
          ),
          Transform.rotate(
            angle: math.pi,
            child: InkWell(
              hoverColor: Colors.transparent,
              onTap: () {
                logic.calendarMovement(
                  calendarMovementType: CalendarMovementType.nextYear,
                  notifier: notifier,
                  controller: controller,
                );
              },
              child: SvgPicture.asset(
                CalendarViewData.doublerrowImage,
                package: 'range_mason',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
