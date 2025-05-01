import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:spod_app/theme.dart';

class AddPaymentCardView extends StatefulWidget {
  @override
  _AddPaymentCardViewState createState() => _AddPaymentCardViewState();
}

class _AddPaymentCardViewState extends State<AddPaymentCardView> {
  final List<Map<String, String>> savedCards = [
    {
      'cardNumber': '**** **** **** 4242',
      'expiry': '12/25',
      'holder': 'Sue Smith',
    },
    {
      'cardNumber': '**** **** **** 1111',
      'expiry': '05/24',
      'holder': 'Phil Richards',
    },
  ];

  bool showAddCardForm = false;

  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  void _addCard() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        savedCards.add({
          'cardNumber':
              '**** **** **** ${_cardNumberController.text.substring(_cardNumberController.text.length - 4)}',
          'expiry': _expiryDateController.text,
          'holder': _cardHolderController.text,
        });
        showAddCardForm = false;
        _cardNumberController.clear();
        _expiryDateController.clear();
        _cvvController.clear();
        _cardHolderController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Card added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Payment Cards'),
        backgroundColor: primaryColor500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!showAddCardForm) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: savedCards.length,
                  itemBuilder: (context, index) {
                    final card = savedCards[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(CupertinoIcons.creditcard_fill, color: darkBlue300),
                        title: Text(card['cardNumber']!),
                        subtitle: Text(
                            '${card['holder']} • Expires ${card['expiry']}'),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text("Add New Card"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor500,
                ),
                onPressed: () {
                  setState(() {
                    showAddCardForm = true;
                  });
                },
              ),
            ] else ...[
              Form(
                key: _formKey,
                child: Expanded(
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Card Number'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a card number' : null,
                      ),
                      TextFormField(
                        controller: _expiryDateController,
                        keyboardType: TextInputType.datetime,
                        decoration:
                            InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter expiry date' : null,
                      ),
                      TextFormField(
                        controller: _cvvController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'CVV'),
                        obscureText: true,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter CVV' : null,
                      ),
                      TextFormField(
                        controller: _cardHolderController,
                        decoration:
                            InputDecoration(labelText: 'Cardholder Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter cardholder name' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor500,
                        ),
                        child: Text('Save Card'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showAddCardForm = false;
                          });
                        },
                        child: Text("Cancel"),
                      )
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
