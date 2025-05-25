import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final DateTime orderDate;
  
  const StatusBadge({
    required this.orderDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final status = _getDeliveryStatus(orderDate);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusTextColor(status),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Get delivery status based on date
  String _getDeliveryStatus(DateTime orderDate) {
    final now = DateTime.now();
    final difference = now.difference(orderDate).inDays;

    if (difference > 5) {
      return 'Levererad';
    } else if (difference > 2) {
      return 'Under leverans';
    } else {
      return 'Bearbetas';
    }
  }

  // Get status color based on delivery status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Levererad':
        return Colors.green[100]!;
      case 'Under leverans':
        return Colors.orange[100]!;
      case 'Bearbetas':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  // Get status text color based on delivery status
  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Levererad':
        return Colors.green[800]!;
      case 'Under leverans':
        return Colors.orange[800]!;
      case 'Bearbetas':
        return Colors.blue[800]!;
      default:
        return Colors.grey[800]!;
    }
  }
}