import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class TimePopup extends StatefulWidget {
  const TimePopup({super.key});

  @override
  State<TimePopup> createState() => _TimePopupState();
}

class _TimePopupState extends State<TimePopup> {
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;
  int hoveredDayIndex = -1;
  int hoveredTimeIndex = -1;

  final List<String> times = [
    "08:00 - 10:00",
    "12:00 - 14:00",
    "16:00 - 18:00",
  ];

  List<Map<String, String>> days = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final weekdayNames = [
      "Måndag", "Tisdag", "Onsdag", "Torsdag", "Fredag", "Lördag", "Söndag"
    ];

    days = List.generate(4, (i) {
      final date = now.add(Duration(days: i+1));
      final weekday = weekdayNames[date.weekday - 1];
      final formattedDate = "${date.day} ${_getMonthName(date.month)}";
      return {
        "day": weekday,
        "date": formattedDate,
      };
    });
  }

  String _getMonthName(int month) {
    const months = [
      "januari", "februari", "mars", "april", "maj", "juni",
      "juli", "augusti", "september", "oktober", "november", "december"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.colorScheme;
    final textTheme = AppTheme.textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(AppTheme.paddingLarge),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      ),
      child: SizedBox(
        width: 800,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.black54,
                    iconSize: 28,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppTheme.paddingLarge,
                right: AppTheme.paddingLarge,
                bottom: AppTheme.paddingMedium,
              ),
              child: Text(
                "Tid för leverans",
                style: textTheme.displayLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(days.length, (index) {
                  return _dayCard(
                    index,
                    days[index]['day']!,
                    days[index]['date']!,
                    index == selectedDayIndex,
                    () {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    textTheme,
                    colorScheme,
                  );
                }),
              ),
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMediumSmall),
                itemCount: times.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedTimeIndex == index;
                  final isHovered = hoveredTimeIndex == index;

                  return MouseRegion(
                    onEnter: (_) => setState(() => hoveredTimeIndex = index),
                    onExit: (_) => setState(() => hoveredTimeIndex = -1),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedTimeIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: AppTheme.paddingTiny),
                        padding: const EdgeInsets.all(AppTheme.paddingSmall),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : (isHovered ? colorScheme.primary.withOpacity(0.1) : Colors.white),
                          border: Border.all(
                            color: isSelected ? colorScheme.primary : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              times[index],
                              style: textTheme.bodyLarge!.copyWith(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            if (isSelected)
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.check, color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            Padding(
              padding: const EdgeInsets.only(
                bottom: AppTheme.paddingLarge,
                left: AppTheme.paddingLarge,
                right: AppTheme.paddingLarge,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedDayIndex != -1 && selectedTimeIndex != -1
                      ? () {
                          final selectedDay = days[selectedDayIndex];
                          final selectedTime = times[selectedTimeIndex];
                          final result =
                              "${selectedDay['day']} ${selectedDay['date']}, $selectedTime";
                          Navigator.of(context).pop(result);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDayIndex != -1 && selectedTimeIndex != -1
                        ? colorScheme.primary
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.paddingMedium,
                    ),
                    textStyle: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    ),
                  ),
                  child: const Text("Klar"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayCard(
    int index,
    String title,
    String date,
    bool isSelected,
    VoidCallback onTap,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final isHovered = hoveredDayIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hoveredDayIndex = index),
      onExit: (_) => setState(() => hoveredDayIndex = -1),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingMedium,
            vertical: AppTheme.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary
                : isHovered
                    ? colorScheme.primary.withOpacity(0.1)
                    : Colors.white,
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: textTheme.headlineSmall!.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              Text(
                date,
                style: textTheme.bodySmall!.copyWith(
                  color: isSelected ? Colors.white : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}








