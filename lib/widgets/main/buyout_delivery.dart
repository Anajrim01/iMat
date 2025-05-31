import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/user_manager.dart';
import 'package:imat_app/widgets/main/login_delivey_popup.dart';
import 'package:imat_app/widgets/main/time_popup.dart';
import 'package:provider/provider.dart';

class BuyoutDelivery extends StatefulWidget {
  final String deliveryTime;
  const BuyoutDelivery({super.key, this.deliveryTime = ''});

  @override
  State<BuyoutDelivery> createState() => BuyoutDeliveryState();
}

class BuyoutDeliveryState extends State<BuyoutDelivery> {
  bool addressSelected = false;
  late String selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.deliveryTime.isNotEmpty ? widget.deliveryTime : '';
  }

  Future<void> showLoginDeliveryPopup() async {
    await showDialog(
      context: context,
      builder: (context) => const LoginDeliveyPopup(),
    );
  }

  Future<void> showTimePopup() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const TimePopup(),
    );

    if (result != null) {
      setState(() {
        selectedTime = result;
      });
    }
  }

  bool hasValidAddress() {
    final iMatHandler = Provider.of<ImatDataHandler>(context, listen: false);
    final customer = iMatHandler.getCustomer();

    return customer.address.isNotEmpty &&
        customer.postCode.isNotEmpty &&
        customer.postAddress.isNotEmpty;
  }

  bool hasSelectedTime() {
    return selectedTime.isNotEmpty;
  }

  String getSelectedTime() {
    if (selectedTime.isNotEmpty) {
      return selectedTime;
    } else {
      return "Ingen tid vald";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userManager = Provider.of<UserManager>(context);
    final iMatHandler = Provider.of<ImatDataHandler>(context);
    final customer = iMatHandler.getCustomer();
    final address =
        "${customer.address}, ${customer.postCode}\n${customer.postAddress}";
    final isLoggedIn = userManager.isLoggedIn;
    final hasAddress = customer.address.isNotEmpty && isLoggedIn;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 1200;

        return Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 40 : 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(70),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(isWideScreen ? 32.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Leveransinformation",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Välj när och var du vill få dina varor levererade",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    if (isWideScreen)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildAddressSection(
                              address,
                              isLoggedIn,
                              hasAddress,
                            ),
                          ),
                          const SizedBox(width: 24),

                          Expanded(flex: 3, child: _buildTimeSection()),

                          const SizedBox(width: 24),

                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildStatusSection(hasAddress),
                                if (hasAddress && selectedTime.isNotEmpty) ...[
                                  const SizedBox(height: 24),
                                  _buildSummarySection(address),
                                ],
                              ],
                            ),
                          ),
                        ],
                      )
                    else if (constraints.maxWidth >= 700)
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildAddressSection(
                                  address,
                                  isLoggedIn,
                                  hasAddress,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(child: _buildTimeSection()),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildStatusSection(hasAddress),
                          if (hasAddress && selectedTime.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            _buildSummarySection(address),
                          ],
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildAddressSection(address, isLoggedIn, hasAddress),
                          const SizedBox(height: 24),
                          _buildTimeSection(),
                          const SizedBox(height: 24),
                          _buildStatusSection(hasAddress),
                          if (hasAddress && selectedTime.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            _buildSummarySection(address),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressSection(
    String address,
    bool isLoggedIn,
    bool hasAddress,
  ) {
    return _buildInfoCard(
      title: 'Leveransadress',
      icon: Icons.home,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              color: Colors.grey.shade100,
            ),
            child: Row(
              children: [
                Icon(
                  hasAddress ? Icons.check_circle : Icons.location_on,
                  size: 36,
                  color: hasAddress ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasAddress
                            ? "Leveransadress vald"
                            : "Ingen adress vald",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: hasAddress ? Colors.black : Colors.grey[700],
                        ),
                      ),
                      if (hasAddress)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Button to select address
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => showLoginDeliveryPopup(),
                icon: Icon(
                  isLoggedIn ? Icons.edit_location : Icons.add_location,
                  size: 24,
                ),
                label: Text(
                  hasAddress ? 'Ändra adress' : 'Välj adress',
                  style: const TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colorScheme.secondary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                ),
              ),
            ),
          ),

          // Help text for logging in (deprecated behavior)
          if (!isLoggedIn)
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                "Logga in för att använda lagrade adresser",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSection() {
    return _buildInfoCard(
      title: 'Leveranstid',
      icon: Icons.access_time,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time selection status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              color: Colors.grey.shade100,
            ),
            child: Row(
              children: [
                Icon(
                  selectedTime.isNotEmpty ? Icons.check_circle : Icons.schedule,
                  size: 36,
                  color: selectedTime.isNotEmpty ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedTime.isNotEmpty
                            ? "Leveranstid vald"
                            : "Ingen tid vald",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:
                              selectedTime.isNotEmpty
                                  ? Colors.black
                                  : Colors.grey[700],
                        ),
                      ),
                      if (selectedTime.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            selectedTime,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Button to select time
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: showTimePopup,
                icon: Icon(
                  selectedTime.isNotEmpty
                      ? Icons.edit_calendar
                      : Icons.calendar_month,
                  size: 24,
                ),
                label: Text(
                  selectedTime.isNotEmpty ? 'Ändra tid' : 'Välj tid',
                  style: const TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colorScheme.secondary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(bool hasAddress) {
    final bool isTimeSelected = selectedTime.isNotEmpty;
    final bool allSelected = hasAddress && isTimeSelected;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: allSelected ? Colors.green.shade50 : Colors.amber.shade50,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: allSelected ? Colors.green.shade200 : Colors.amber.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            allSelected ? Icons.check_circle : Icons.info,
            color: allSelected ? Colors.green : Colors.amber.shade800,
            size: 36,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allSelected
                      ? "Allt klart för leverans!"
                      : "Ytterligare uppgifter krävs",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color:
                        allSelected
                            ? Colors.green.shade800
                            : Colors.amber.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  allSelected
                      ? "Du kan nu fortsätta till betalningen."
                      : "Vänligen välj ${!hasAddress ? 'leveransadress' : ''}${!hasAddress && !isTimeSelected ? ' och ' : ''}${!isTimeSelected ? 'leveranstid' : ''} för att fortsätta.",
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        allSelected
                            ? Colors.green.shade800
                            : Colors.amber.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String address) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Leveransinformation - Sammanfattning",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryItem(
              icon: Icons.location_on,
              title: "Levereras till:",
              value: address,
            ),
            const Divider(),
            _buildSummaryItem(
              icon: Icons.access_time_filled,
              title: "Leveranstid:",
              value: selectedTime,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blue.shade800),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Row(
              children: [
                Icon(icon, size: 32, color: AppTheme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            content,
          ],
        ),
      ),
    );
  }
}
