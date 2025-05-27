import 'package:imat_app/widgets/main/time_popup.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/main/delivery_popup.dart';


class BuyoutDelivery extends StatefulWidget {
  const BuyoutDelivery({super.key});

  @override
  State<BuyoutDelivery> createState() => BuyoutDeliveryState();
}

class BuyoutDeliveryState extends State<BuyoutDelivery> {
  bool adress_vald = false; // Flytta till klassnivå
  String? selectedTime;     // Sparar vald tid + datum

  Future<void> showDeliveryPopup() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const DeliveryPopup(),
    );

    if (result != null) {
      setState(() {
        adress_vald = result; // Antar att popupen returnerar ett bool-värde
      });
    }
  }

  Future<void> showTimePopup() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const TimePopup(),
    );

    if (result != null) {
      setState(() {
        selectedTime = result; // Sparar vald tid + datum
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    return Center(
      child: Container(
        width: 950,
        height: 430,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(51), 
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            )
          ],
          color: Colors.white,
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(80, 80, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: Icon(
                    Icons.house,
                    size: 40,
                    color: AppTheme.colorScheme.primary,
                  ),
                ),
                Text(
                  "Adress",
                  style: AppTheme.textTheme.displayMedium,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(280, 9, 0, 0),
                  child: Icon(Icons.access_time_outlined, size: 40, color: AppTheme.colorScheme.primary),
                ),
                Text(
                  "Leveranstid",
                  style: AppTheme.textTheme.displayMedium,
                )
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 20, 0, 0),
                child: Container(
                  width: 350,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      if (!adress_vald)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "Ingen adress vald",
                            style: AppTheme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "Adress är vald",
                            style: AppTheme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: ElevatedButton(
                          onPressed: () {
                            showDeliveryPopup();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            fixedSize: const Size(140, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Text(
                              'Välj adress',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 20, 0, 0),
                child: Container(
                  width: 350,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      if (selectedTime == null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "Ingen tid vald",
                            style: AppTheme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      else
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Vald tid:\n$selectedTime",
                              style: AppTheme.textTheme.headlineSmall?.copyWith(
                                color: AppTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 75),
                        child: ElevatedButton(
                          onPressed: () {
                            showTimePopup();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            fixedSize: const Size(140, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Text(
                              'Välj tid',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
