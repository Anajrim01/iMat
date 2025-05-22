import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class ShoppingCartView_1 extends StatelessWidget{
  const ShoppingCartView_1({super.key});

  @override
  Widget build(BuildContext context){
    final handler = context.watch<ImatDataHandler>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'I',
              style: TextStyle(
                color: AppTheme.colorScheme.primary,
                fontSize: 50,
              ),
            ),
            const Text('Mat', style: TextStyle(fontSize: 50)),
            const SizedBox(width: 150),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    color: Colors.grey[200],
                  ),
                )
              )
            )
            ,ElevatedButton(
              onPressed: (
                
              ) {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                child: Text('Hem'),
              ),
            ),
          ]
        ),
      )
      ,body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          )
        ]
      ),
    );
  }
}