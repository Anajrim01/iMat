import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/user.dart';

class DeliveryPopup extends StatefulWidget {
  const DeliveryPopup({super.key});

  @override
  State<DeliveryPopup> createState() => DeliveryPopupState();
}

class DeliveryPopupState extends State<DeliveryPopup> {
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _adressController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  var _emailController = TextEditingController();
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
                Expanded(
                  child: _buildField(
                  label: "Förnamn",
                  controller: _firstNameController,
                  hintText: "namn",
                  ),
                ), 
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                 Expanded(
                  child: _buildField(
                  label: "Efternamn",
                  controller: _lastNameController,
                  hintText: "efternamn",
                ),
              ),
              ],
            ),
            const SizedBox(height: 10,),
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
            const SizedBox(height: 10,),
            Row(children: [
              Expanded(child: _buildField(
                  label: "Nummer",
                  controller: _phoneNumberController,
                  hintText: "123-456-7890",
                ),
              )
            ],
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                      child: _buildField(
                        label: "E-postadress/Användarnamn",
                        controller: _emailController,
                        hintText: "namn@gmail.com",
                      ),
                    ),
            ],
            ),
            const SizedBox(height: 7,),
           ElevatedButton(
              onPressed: (
              ) {
                save_info();
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
                child: Text('Klar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void save_info(){
    final iMatHandler = Provider.of<ImatDataHandler>(context, listen: false);
    final customer = iMatHandler.getCustomer();
    final user = iMatHandler.getUser();
    var pass = customer.firstName;
    print("user.password: $pass");

    var firstName = '';
    var lastName = '';
    var phoneNumber = '';
    var email = '';
    var adress = '';

    if(_firstNameController.text.trim()==''){
      firstName = customer.firstName;
    }
    else{
      firstName = _firstNameController.text.trim();
    }
    if(_lastNameController.text.trim()==''){
      lastName = customer.lastName;
    }
    else{
      lastName = _lastNameController.text.trim();    
    }
    if(_phoneNumberController.text.trim()==''){
      phoneNumber = customer.phoneNumber;
    }
    else{
      phoneNumber = _phoneNumberController.text.trim();
    }
    if(_emailController.text.trim()==''){
      email = customer.email;
    }
    else{
      email = _emailController.text.trim();
    }
    if(_adressController.text.trim()==''){
      adress = customer.address;
    }
    else{
      adress = _adressController.text.trim();
    }

    // Uppdatera kunddata
    final updateCustomer = Customer(
      firstName,
      lastName,
      phoneNumber,
      customer.mobilePhoneNumber,
      email,
      adress,
      customer.postCode,
      customer.postAddress,
    );
    iMatHandler.setCustomer(updateCustomer);

    //Måste också uppdatera user
    final updateUser = User(
      email,
      user.password,
    );
    iMatHandler.setUser(updateUser);
    pass = user.password;
    print("user.password: $pass");
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