import 'package:dating_app/helpers/app_localizations.dart';
import 'package:dating_app/models/app_model.dart';
import 'package:dating_app/models/user_model.dart';
import 'package:dating_app/screens/payment_screen.dart';
import 'package:dating_app/widgets/my_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class StoreProducts extends StatefulWidget {
  final Widget icon;
  final Color priceColor;

  const StoreProducts({Key? key, required this.icon, required this.priceColor})
      : super(key: key);

  @override
  _StoreProductsState createState() => _StoreProductsState();
}

class _StoreProductsState extends State<StoreProducts> {
  // Variables
  bool _storeIsAvailable = false;
  List<ProductDetails>? _products;
  late AppLocalizations _i18n;

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */

    // showAlertDialog(context, "Payment Failed",
    //     "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */

    // showAlertDialog(
    //     context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    // showAlertDialog(
    //     context, "External Wallet Selected", "${response.walletName}");
  }


  @override
  void initState() {
    super.initState();

    // Check google play services
    InAppPurchase.instance.isAvailable().then((result) {
      if (mounted) {
        print('_storeIsAvailable $_storeIsAvailable');
        setState(() {
          print('my result');
          print(result);
          _storeIsAvailable =
              result; // if false the store can not be reached or accessed
        });
      }
    });

    // Get product subscriptions from google play store / apple store
    InAppPurchase.instance
        .queryProductDetails(['subscription_product1'].toSet())
        .then((ProductDetailsResponse response) {
      /// Update UI
      if (mounted) {
        setState(() {
          // Get product list
          _products = response.productDetails;
          print('product my ');
          print(_products);
          print(_products!.isNotEmpty);
          // Check result
          if (_products!.isNotEmpty) {
            // Order price by ASC
            _products!.sort((a, b) {
              // Get int prices to be ordered
              final priceA =
                  int.parse(a.price.replaceAll(RegExp(r'[^0-9]'), ''));
              final priceB =
                  int.parse(b.price.replaceAll(RegExp(r'[^0-9]'), ''));
              // ASC order
              return priceA.compareTo(priceB);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Init
    _i18n = AppLocalizations.of(context);

    return _storeIsAvailable ? _showProducts() : _storeNotAvailable();
  }

  Widget _showProducts() {
    if (_products == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const MyCircularProgress(),
              const SizedBox(height: 5),
              Text(_i18n.translate("processing"),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center),
              Text(_i18n.translate("please_wait"),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center)
            ],
          ),
        ),
      );
    } else if (_products!.isNotEmpty) {
      // Show Subscriptions
      return ScopedModelDescendant<UserModel>(
          builder: (context, child, userModel) {
        return Column(
            children: _products!.map<Widget>((item) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              enabled: userModel.activeVipId == item.id ? false : true,
              leading: widget.icon,
              title: Text(
                  // Android only - remove the app name from title
                  item.title.replaceAll(
                      RegExp(r"\([^]*\)", caseSensitive: false), ''),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(item.price,
                  style: TextStyle(
                      fontSize: 19,
                      color: widget.priceColor,
                      fontWeight: FontWeight.bold)),
              trailing: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(8)),
                          
                      backgroundColor: MaterialStateProperty.all<Color>(
                          userModel.activeVipId == item.id
                              ? Colors.grey
                              : widget.priceColor),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
                  child: userModel.activeVipId == item.id
                      ? Text(_i18n.translate("ACTIVE"),
                          style: const TextStyle(color: Colors.white))
                      : Text(_i18n.translate("SUBSCRIBE"),
                          style: const TextStyle(color: Colors.white)),

                onPressed: () async {
                  Razorpay razorpay = Razorpay();

                  var options = {
                    'key': 'rzp_live_ILgsfZCZoFIKMb',
                    'amount':
                    int.parse("100") * 100, //in paise.
                    'name': 'Datting App.',
                    'description': 'Fine T-Shirt',
                    'timeout': 60, // in seconds
                    'prefill': {
                      'contact': '7389681128',
                      'email': 'gaurav.kumar@example.com'
                    }
                  };

                  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                      handlePaymentErrorResponse);
                  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                      handlePaymentSuccessResponse);
                  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                      handleExternalWalletSelected);
                  razorpay.open(options);
                },
                  // onPressed: userModel.activeVipId == item.id
                  //     ? null
                  //     : () async {
                  //       print('my item');
                  //       print(item);
                  //         // Purchase parameters
                  //         final pParam = PurchaseParam(
                  //           productDetails: item,
                  //         );
                  //
                  //         /// Subscribe
                  //         InAppPurchase.instance
                  //             .buyNonConsumable(purchaseParam: pParam);
                  //       }
                        ),
            ),
          );
        }).toList());
      });
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.search,
                  size: 80, color: Theme.of(context).primaryColor),
              Text(_i18n.translate("no_products_or_subscriptions"),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
  }

  Widget _storeNotAvailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error_outline,
              size: 80, color: Theme.of(context).primaryColor),
          Text(_i18n.translate("oops_an_error_has_occurred"),
              style: const TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

