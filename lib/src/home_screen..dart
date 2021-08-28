import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _amount = TextEditingController();
  String amount = "";
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future openCheckout({@required int amount}) async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount,
      'name': 'Upwork Corp',
      'description': 'Some Product',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  bool paymentSuccess = false;
  bool paymentUnsuccess = false;
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    /* Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT); */

    setState(() {
      paymentSuccess = true;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    /*   Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT); */
    setState(() {
      paymentUnsuccess = true;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: ListView(
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Container(
              margin: EdgeInsets.only(left: width * 0.1),
              child: Text(
                "Pay with RazorPay",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.1),
                  width: width * 0.515,
                  height: 1,
                  color: Colors.black,
                ),
              ],
            ),
            SizedBox(
              height: height * 0.08,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                //     controller: _email,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold),

                decoration: InputDecoration(
                  /*   prefixIcon: Icon(Icons.payment, size: 20), */
                  filled: true,
                  fillColor: Color(0xFFF2F2F2),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(width: 1, color: Colors.green)),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFFB3B1B1),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide:
                          BorderSide(width: 1, color: Color(0xFFB3B1B1))),

                  hintText: "Enter Amount *",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB3B1B1),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold),

                  //errorText: snapshot.error,
                ),
                onChanged: (String val) {
                  setState(() {
                    amount = val;
                    paymentUnsuccess = false;
                    paymentSuccess = false;
                  });
                },
                //  controller: _usernameController,
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (amount != "" || amount != null) {
                      openCheckout(amount: int.parse(amount) * 100);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              offset: Offset(0, 2),
                              color: Colors.green,
                              spreadRadius: 1)
                        ]),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                    child: Text(
                      "Pay".toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2.9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.15,
            ),
            paymentSuccess == true
                ? Container(
                    child: Text(
                      "Payment Successful",
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2.9,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox(),
            paymentUnsuccess == true
                ? Container(
                    child: Text(
                      "Payment Unsuccessful",
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2.9,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
