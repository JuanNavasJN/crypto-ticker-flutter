import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'constants.dart';
import 'components/card_rate.dart';
import 'services/requests.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double btcRate = 0.0;
  double ethRate = 0.0;
  double ltcRate = 0.0;

  @override
  void initState() {
    super.initState();
    updateRates();
  }

  void updateRates() async {
    double newBtcRate = await getRate('BTC', selectedCurrency);
    double newEthRate = await getRate('ETH', selectedCurrency);
    double newLtcRate = await getRate('LTC', selectedCurrency);

    setState(() {
      btcRate = newBtcRate;
      ethRate = newEthRate;
      ltcRate = newLtcRate;
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        // setState(() {
        selectedCurrency = value;
        updateRates();
        // });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = [];

    for (String currency in currenciesList) {
      var newItem = Text(
        currency,
        style: TextStyle(color: Colors.white),
      );

      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: primaryColor,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        // print(selectedIndex);
        selectedCurrency = currenciesList[selectedIndex];
        updateRates();
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        title: Text('Crypto Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardRate(
                  rate: btcRate,
                  fiat: selectedCurrency,
                  crypto: 'BTC',
                ),
                CardRate(
                  rate: ethRate,
                  fiat: selectedCurrency,
                  crypto: 'ETH',
                ),
                CardRate(
                  rate: ltcRate,
                  fiat: selectedCurrency,
                  crypto: 'LTC',
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 140),
            // color: primaryColor,
            child: MaterialButton(
              color: primaryColor,
              child: Icon(Icons.refresh),
              onPressed: () {
                updateRates();
              },
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: primaryColor,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
