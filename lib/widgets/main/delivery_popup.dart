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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _mobilePhoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _adressController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _postAdressController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Center(child: Text('Välj leveransadress')),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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
            Row(
              children: [
                 Expanded(
                  child: _buildField(
                  label: "Mobilnummer",
                  controller: _mobilePhoneNumberController,
                  hintText: "efternamn",
                ),
              ),
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
            const SizedBox(height: 10,),
            Row(
              children: [
                 Expanded(
                  child: _buildField(
                  label: "Postkod",
                  controller: _postCodeController,
                  hintText: "postkod",
                ),
              ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                 Expanded(
                  child: _buildField(
                  label: "Postadress",
                  controller: _postAdressController,
                  hintText: "postadress",
                ),
              ),
              ],
            ),
            
            const SizedBox(height: 7,),
           ElevatedButton(
              onPressed: (
              ) {
                if(_adressController.text.trim()=='' || _emailController.text.trim()=='' 
                || _phoneNumberController.text.trim()=='' || _lastNameController.text.trim()==''
                || _firstNameController.text.trim() == '' || _mobilePhoneNumberController.text.trim() == ''
                || _postAdressController.text.trim() =='' || _postCodeController.text.trim()==''){
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Måste välja adress")),
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
        ),
        )
      ),
    );
  }
  void save_info(){
    final iMatHandler = Provider.of<ImatDataHandler>(context, listen: false);
    final customer = iMatHandler.getCustomer();
    final user = iMatHandler.getUser();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();    
    final phoneNumber = _phoneNumberController.text.trim();
    final email = _emailController.text.trim();
    final adress = _adressController.text.trim();

    // Uppdatera kunddata
    final updateCustomer = Customer(
      firstName,
      lastName,
      phoneNumber,
      _mobilePhoneNumberController.text.trim(),
      email,
      adress,
      _postCodeController.text.trim(),
      _postAdressController.text.trim(),
    );
    iMatHandler.setCustomer(updateCustomer);

    //Måste också uppdatera user
    final updateUser = User(
      email,
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