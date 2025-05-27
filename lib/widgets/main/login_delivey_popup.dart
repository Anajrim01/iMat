import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/user.dart';

class LoginDeliveyPopup extends StatefulWidget {
  const LoginDeliveyPopup({super.key,});

  @override
  State<LoginDeliveyPopup> createState() => LoginDeliveyPopupState();
}

class LoginDeliveyPopupState extends State<LoginDeliveyPopup> {
  final _adressController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Center(child: Text('Välj leveransadress')),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height,

          child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildField(
                  label: "Adress",
                  controller: _adressController,
                  hintText: "12-345",
                ),
              )
            ],
            ),
            
            const SizedBox(height: 370,),
           ElevatedButton(
              onPressed: (
              ) {
                if(_adressController.text.trim()==''){
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Måste fylla i adressen")),
                 );
                }
                else{
                  save_info();
                  Navigator.pop(context);
                }
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
                child: Text('Klar'),
              ),
            ),
          ],
        )
      ),
    );
  }
  void save_info(){
    final iMatHandler = Provider.of<ImatDataHandler>(context, listen: false);
    final customer = iMatHandler.getCustomer();
    final user = iMatHandler.getUser();
    final adress = _adressController.text.trim();

    // Uppdatera kunddata
    final updateCustomer = Customer(
      customer.firstName,
      customer.lastName,
      customer.phoneNumber,
      customer.mobilePhoneNumber,
      customer.email,
      adress,
      customer.postCode,
      customer.postAddress,
    );
    iMatHandler.setCustomer(updateCustomer);

    //Måste också uppdatera user
    final updateUser = User(
      customer.email,
      user.password,
    );
    iMatHandler.setUser(updateUser);
  }
  Widget _buildField({
    required String label,
    String? trailingLabel,
    required TextEditingController controller,
    String? hintText,
    bool obscure = false,
  }){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            if (trailingLabel != null)
              Text(
                trailingLabel,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.greenAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }
}