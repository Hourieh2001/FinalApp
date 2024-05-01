import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';

void main() {
  runApp(ParkingApp());
}

class ParkingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue,
      ),
      home: GetStartedPage(),
    );
  }
}

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Parking App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Get Started',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                // Navigate to GPS page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GPSPickerPage()),
                );
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class GPSPickerPage extends StatelessWidget {
  Future<void> _getLocation(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // استخدم position للوصول إلى معلومات الموقع
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Nearest Parking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'GPS Picker Page',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                _getLocation(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MYHomePage()),
                );
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSlot {
  final String time;
  final String date;

  TimeSlot({required this.time, required this.date});
}

class MYHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Parking App',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement parking reservation logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReserveParkingPage()),
                );
              },
              child: Text('Reserve Parking'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ReserveParkingPage extends StatelessWidget {
  final List<int> reservedSlots = [2, 4, 6]; // Mocking reserved slots

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Parking'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 10, // Assuming there are 10 slots
          itemBuilder: (BuildContext context, int index) {
            final slotNumber = index + 1;
            final isReserved = reservedSlots.contains(slotNumber);

            return ListTile(
              title: Text('Slot $slotNumber'),
              subtitle: isReserved ? Text('Reserved') : Text('Available'),
              trailing: isReserved
                  ? null
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmReservationPage()),
                        );
                        // Implement reservation logic here
                        // You can navigate to a confirmation page or perform any necessary actions
                      },
                      child: Text('Reserve'),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class ConfirmReservationPage extends StatefulWidget {
  @override
  _ConfirmReservationPageState createState() => _ConfirmReservationPageState();
}

class _ConfirmReservationPageState extends State<ConfirmReservationPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Parking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select a timeslot:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text('Select Date'),
            ),
            ElevatedButton(
              onPressed: () {
                _selectTime(context);
              },
              child: Text('Select Time'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement reservation logic here
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Reservation'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selected Timeslot:'),
                          Text(
                              'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                          Text('Time: ${_selectedTime.format(context)}'),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestServicePage(),
                              ),
                            );
                            // Implement reservation logic here
                            // You can navigate to a confirmation page or perform any necessary actions
                          },
                          child: Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Reserve'),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestServicePage extends StatefulWidget {
  @override
  _RequestServicePageState createState() => _RequestServicePageState();
}

class _RequestServicePageState extends State<RequestServicePage> {
  String? _selectedService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: _selectedService,
              hint: Text('Select Service'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedService = newValue;
                });
              },
              items: <String>['Charge Car', 'Car Wash', 'Car Maintenance']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedService != null) {
                  _showServiceRequestConfirmation(context);
                }
              },
              child: Text('Request Service'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to HomePage when "No Thanks" button is pressed
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentMethodPage()),
                );
              },
              child: Text('No Thanks'),
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceRequestConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Service Requested"),
          content:
              Text("Your $_selectedService has been requested successfully."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class PaymentMethodPage extends StatefulWidget {
  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  // Define payment methods
  final List<String> paymentMethods = ['Credit Card', 'PayPal', 'Cash'];

  // Variable to store the selected payment method
  String selectedPaymentMethod = 'Credit Card';

  // Variables to store user input for payment
  late TextEditingController bankAccountController;
  late TextEditingController walletNumberController;
  late TextEditingController passwordController;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    bankAccountController = TextEditingController();
    walletNumberController = TextEditingController();
    passwordController = TextEditingController();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    bankAccountController.dispose();
    walletNumberController.dispose();
    passwordController.dispose();
    amountController.dispose();
    super.dispose();
  }

  // Function to handle payment based on selected method
  void performPayment(String paymentMethod) {
    // Show dialog to request payment information
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your payment details:'),
                SizedBox(height: 10),
                if (paymentMethod == 'Credit Card')
                  TextFormField(
                    controller: bankAccountController,
                    decoration:
                        InputDecoration(labelText: 'Bank Account Number'),
                  ),
                if (paymentMethod == 'PayPal')
                  TextFormField(
                    controller: walletNumberController,
                    decoration:
                        InputDecoration(labelText: 'PayPal Wallet Number'),
                  ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Payment Amount'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform payment processing here
                // You can access entered values using controllers
                print('Payment Method: $paymentMethod');
                if (paymentMethod == 'Credit Card') {
                  print('Bank Account Number: ${bankAccountController.text}');
                } else if (paymentMethod == 'PayPal') {
                  print('PayPal Wallet Number: ${walletNumberController.text}');
                }
                print('Password: ${passwordController.text}');
                print('Amount: ${amountController.text}');
                // Simulating payment processing
                Future.delayed(Duration(seconds: 2), () {
                  // Payment completed, show confirmation message
                  Navigator.of(context).pop(); // Close the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Payment Confirmation'),
                        content: Text(
                            'Payment of ${amountController.text} successfully completed.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Close the confirmation dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MYHomePage()),
                              );
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                });
              },
              child: Text('Confirm Payment'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Payment Method Page',
              style: TextStyle(fontSize: 24),
            ),
            // DropdownButton to select payment method
            DropdownButton<String>(
              value: selectedPaymentMethod,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  // Update selected payment method
                  setState(() {
                    selectedPaymentMethod = newValue;
                  });
                }
              },
              items:
                  paymentMethods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform payment based on selected method
                performPayment(selectedPaymentMethod);
              },
              child: Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
