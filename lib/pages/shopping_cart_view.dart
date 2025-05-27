import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/main/buyout_cart_bar.dart';
import 'package:imat_app/widgets/main/buyout_delivery.dart';
import 'package:imat_app/widgets/main/buyout_payment.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/shopping_cart.dart';
import 'package:imat_app/model/imat/shopping_item.dart';

class ShoppingCartView extends StatefulWidget {
  const ShoppingCartView({super.key});

  @override
  State<ShoppingCartView> createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView>{
  int page_number = 1;
  @override
  Widget build(BuildContext context){
    final handler = context.watch<ImatDataHandler>();
    
    
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
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
                padding: const EdgeInsets.symmetric(horizontal: 100),
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
              ) {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3E5F5),
                foregroundColor: Colors.black,
                elevation: 2,
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                fixedSize: Size(170, 50),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                  )
                ],
            ),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //använder padding för spacing av knappar
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 20, 287, 20),
                child: ElevatedButton.icon(
                  label: const Text('tillbaka'),
                  onPressed: (){
                    if(page_number == 1){
                      Navigator.pop(context);
                    }
                    else{
                      _changePage(page_number-1);
                    }
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3E5F5),
                    foregroundColor: Colors.black,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                      ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                ),
              )
              ),
              ElevatedButton.icon(
              label: const Text('Varukorg'),
                onPressed: (){
                  _changePage(1);
                }, 
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3E5F5),
                foregroundColor: Colors.black,
                elevation: 0.5,
                padding: const EdgeInsets.symmetric(
                  horizontal: 43,
                  vertical: 43,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton.icon(
              label: const Text('Leverans'),
                onPressed: (){
                  _changePage(2);
                }, 
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3E5F5),
                foregroundColor: Colors.black,
                elevation: 0.5,
                padding: const EdgeInsets.symmetric(
                  horizontal: 43,
                  vertical: 43,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton.icon(
              label: const Text('Betalning'),
                onPressed: (){
                  _changePage(3);
                }, 
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3E5F5),
                foregroundColor: Colors.black,
                elevation: 0.5,
                padding: const EdgeInsets.symmetric(
                  horizontal: 43,
                  vertical: 43,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
              if(page_number != 3)
                Padding(
                  padding: const EdgeInsets.fromLTRB(290,20,38,20),
                  child: ElevatedButton.icon(
                    label: const Text('Fortsätt'),
                    onPressed: (){
                      _changePage(page_number+1);
                      print(page_number);
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3E5F5),
                      foregroundColor: Colors.black,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                        ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                      side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                  ),
                )
              )
            ],
          )
        ),
        if (page_number==1)
         Expanded(
          child: BuyoutCartBar(handler: handler)
        )
        else if (page_number == 2)
         Expanded(
          child: BuyoutDelivery()
         )
        else if (page_number==3)
         Expanded(child: BuyoutPayment(handler: handler))
      ]
      ),
    );
  }
  void _changePage(int newPage) {
    setState(() {
      page_number = newPage;
    });
  }
}
