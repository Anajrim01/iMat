import 'package:flutter/material.dart';

class DeliveryPopup extends StatefulWidget {
  const DeliveryPopup({super.key});

  @override
  State<DeliveryPopup> createState() => DeliveryPopupState();
}

class DeliveryPopupState extends State<DeliveryPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Välj leveransadress'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); 
              },
              child: const Text('Bekräfta adress'),
            ),
          ],
        ),
      ),
    );
  }
}