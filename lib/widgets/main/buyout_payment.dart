import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class BuyoutPayment extends StatelessWidget{
  final ImatDataHandler handler;
  const BuyoutPayment({required this.handler, super.key});

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container(
        width: 900,
        height: 430,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 120),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 9),
              child: Icon(
              Icons.credit_card,
              size: 40,
              ),
            ),
            Text(
              "Betala",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                ),
              ),
            ],
          )
        )
      )
    );
  } 
} 