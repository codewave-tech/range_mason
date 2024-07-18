part of date_range_selector;

class RangeSelectorLogic {
  late CalendarViewController startController;

  late CalendarViewController endController;

  late ValueNotifier<String> startCalendarDate;
  late ValueNotifier<String> endCalendarDate;

  DateTime? startRange;
  DateTime? endRange;

  RangeSelectorLogic({DateTime? startDate, DateTime? endDate}) {
    startController = CalendarViewController(
      enableRangeSelectionMode: true,
      initialFocusDifferenceMonths: -1,
      id: 'start',
      startDate: startDate,
    );
    endController = CalendarViewController(
      enableRangeSelectionMode: true,
      id: 'end',
      startDate: startDate,
      endDate: endDate,
    );
    startCalendarDate =
        ValueNotifier<String>(_format(startController.displayDate!));
    endCalendarDate =
        ValueNotifier<String>(_format(endController.displayDate!));
  }

  String _format(DateTime dateTime) => DateFormat('MMM yyyy').format(dateTime);

  void calendarMovement({
    required CalendarMovementType calendarMovementType,
    required ValueNotifier<String> notifier,
    required CalendarViewController controller,
  }) {
    bool isStartCalendar = controller.id == 'start';

    junkyMovementLogic(calendarMovementType, isStartCalendar, controller);

    notifier.value = _format(controller.displayDate!);
  }

  void onClick(CalendarElemet ele, CalendarViewController c) {
    if (ele.isLeadingOrTrailing) return;
    // bool isStartCalendar = c.id == 'start';
    if (startRange == null && endRange == null) {
      updateStartRange(ele, c);
    } else if (startRange != null && endRange == null) {
      updateEndRange(ele, c);
    } else if (startRange != null && endRange != null) {
      int nearest = findNearestDateTime(startRange!, endRange!, ele.dateTime);
      if (nearest == 0) {
        updateStartRange(ele, c);
      } else {
        updateEndRange(ele, c);
      }
    }
  }

  void onHover(
    CalendarElemet calendarElemet,
    CalendarViewController controller,
    bool value,
  ) {
    if (startRange == null && endRange == null) return;
    if (!value && controller.hoverEnd != null) {
      startController.setHoverEndRange(null);
      endController.setHoverEndRange(null);
      return;
    }
    if (startRange != null) {
      startController.setHoverEndRange(calendarElemet.dateTime);
      endController.setHoverEndRange(calendarElemet.dateTime);
      return;
    }
  }

  bool isDateTimeInRange(DateTime A, DateTime B, DateTime X) {
    DateTime minDateTime = A.isBefore(B) ? A : B;
    DateTime maxDateTime = A.isBefore(B) ? B : A;

    return X.isAfter(minDateTime) && X.isBefore(maxDateTime);
  }
}
