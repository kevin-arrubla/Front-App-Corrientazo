import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:front_app_corrientazo/src/providers/ListRestaurant_Provider.dart';
import 'package:front_app_corrientazo/src/providers/Payment_Providers.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';
import 'package:front_app_corrientazo/src/providers/subscription_Provider.dart';
import 'package:front_app_corrientazo/src/utils/token.dart';

class ListPaidProduct extends StatefulWidget {
  static final String path = "lib/src/pages/onboarding/intro2.dart";

  @override
  _ListPaidProductStatePage createState() => _ListPaidProductStatePage();
}

class _ListPaidProductStatePage extends State<ListPaidProduct> {
  SwiperController _swiperController;
  PaymentProviders paymentProviders;
  OrdersProviders ordersProviders;
  ListRestaurantProviders listRestaurantProviders;
  SubscriptionProvider subscriptionProvider;
  Token token;

  int _currentIndex = 0;
  int _pageCount = 0;

  String paymentId;
  String pago;
  List detailPayment;

  Map orderDetail;
  Map detailRestaurant;
  Map detailSubcription;
  Map detailPackage;

  List<String> itemImage;
  List<String> itemNameRestaurant;
  List<String> itemDescriptionRestaurant;
  List<String> itemDescription;
  List<String> itemPrice;
  List<String> itemDirection;

  _ListPaidProductStatePage() {
    paymentProviders = PaymentProviders();
    ordersProviders = OrdersProviders();
    listRestaurantProviders = ListRestaurantProviders();
    subscriptionProvider = SubscriptionProvider();
    _swiperController = SwiperController();
    token = Token();
  }

  Future listPaidProductUser() async {
    await token.getString('paymentId').then((res) {
      setState(() {
        paymentId = res;
      });
    });
    await token.getString('pago').then((res) {
      setState(() {
        pago = res;
      });
    });

    await paymentProviders.listPaymentDetail(paymentId).then(
      (res) {
        setState(() {
          detailPayment = res;
        });
        if (detailPayment.length > 0) {
          if (pago == 'Pago a Restaurante') {
            for (var i = 0; i < detailPayment.length; i++) {
              ordersProviders
                  .getOrderActive(detailPayment[i]['orderId'])
                  .then((res) {
                setState(() {
                  orderDetail = res;
                  itemDescription.insert(
                      itemDescription.length, orderDetail['menuName']);
                  itemPrice.insert(
                      itemPrice.length, orderDetail['price'].toString());
                  itemDirection.insert(
                      itemDirection.length, orderDetail['address']);
                  listRestaurantProviders
                      .getRestaurantId(orderDetail['restId'])
                      .then((res) {
                    setState(() {
                      detailRestaurant = res;
                      itemImage.insert(
                          itemImage.length, detailRestaurant['image']);
                      itemNameRestaurant.insert(itemNameRestaurant.length,
                          detailRestaurant['namerestaurant']);
                      itemDescriptionRestaurant.insert(
                          itemDescriptionRestaurant.length,
                          detailRestaurant['description']);
                    });
                  });
                });
              });
            }
          } else {
            for (var i = 0; i < detailPayment.length; i++) {
              subscriptionProvider
                  .getOneSubscription(detailPayment[i]['orderId'].toString())
                  .then((res) {
                setState(() {
                  detailSubcription = res;
                  listRestaurantProviders
                      .getRestaurantId(detailSubcription['restId'])
                      .then((res) {
                    setState(() {
                      detailRestaurant = res;
                      subscriptionProvider
                          .getOnePackage(detailSubcription['packageId'])
                          .then((res) {
                        setState(() {
                          detailPackage = res;
                          itemImage.insert(itemImage.length,
                              detailRestaurant['image'].toString());
                          itemNameRestaurant.insert(itemNameRestaurant.length,
                              detailRestaurant['namerestaurant'].toString());
                          itemDescriptionRestaurant.insert(
                              itemDescriptionRestaurant.length,
                              detailRestaurant['description']);
                          itemDescription.insert(
                              itemDescription.length, 'Pago por Suscripcion');
                          itemPrice.insert(itemPrice.length,
                              detailPackage['subvalue'].toString());
                        });
                      });
                    });
                  });
                });
              });
            }
          }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    listPaidProductUser();
    itemImage = [];
    itemNameRestaurant = [];
    itemDescriptionRestaurant = [];
    itemDescription = [];
    itemPrice = [];
    itemDirection = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Lista del Producto',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black.withOpacity(0.02),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Swiper(
              index: _currentIndex,
              controller: _swiperController,
              itemCount: _pageCount = itemNameRestaurant.length,
              onIndexChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              loop: false,
              itemBuilder: (context, index) {
                return _buildPage(
                    itemImage[index].toString(),
                    itemNameRestaurant[index],
                    itemDescriptionRestaurant[index],
                    itemDescription[index],
                    itemPrice[index].toString());
              },
              pagination: SwiperPagination(),
            )),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  if (_pageCount > _currentIndex)
                    _swiperController.move(_currentIndex - 1);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                if (_currentIndex < _pageCount - 1) _swiperController.next();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget listDetail() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 14,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            'Manzana',
            style: TextStyle(fontSize: 23),
          ),
          trailing: Icon(
            Icons.arrow_right,
            color: Colors.red,
            size: 40,
          ),
        );
      },
    );
  }

  Widget _buildPage(
    String image,
    String nameRestaurant,
    String descriptionRestaurant,
    String description,
    String price,
  ) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage('$image'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black38, BlendMode.multiply)),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: ListTile(
                    title: Text(
                      '$nameRestaurant',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('$descriptionRestaurant',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text(
                'Descripcion: ' + '$description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                overflow: TextOverflow.fade,
              ),
              subtitle: Text('Precio: ' + '\$' + '$price',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
