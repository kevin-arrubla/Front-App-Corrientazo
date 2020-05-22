import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/pages/Change_Password.dart';
import 'package:front_app_corrientazo/src/pages/DetailPayment.dart';
import 'package:front_app_corrientazo/src/pages/List_%20Paid_Product.dart';
import 'package:front_app_corrientazo/src/pages/List_Subscription.dart';
import 'package:front_app_corrientazo/src/pages/Login.dart';
import 'package:front_app_corrientazo/src/pages/NewDirection.dart';
import 'package:front_app_corrientazo/src/pages/Ongoing_Orders.dart';
import 'package:front_app_corrientazo/src/pages/OrdersHistoryDetail.dart';
import 'package:front_app_corrientazo/src/pages/Orders_History.dart';
import 'package:front_app_corrientazo/src/pages/Payment_Method.dart';
import 'package:front_app_corrientazo/src/pages/Payment_WebView.dart';
import 'package:front_app_corrientazo/src/pages/Profile.dart';
import 'package:front_app_corrientazo/src/pages/Reset_Password.dart';
import 'package:front_app_corrientazo/src/pages/Seller_Request.dart';
import 'package:front_app_corrientazo/src/pages/Sign_In.dart';
import 'package:front_app_corrientazo/src/pages/Search_Restaurant.dart';
import 'package:front_app_corrientazo/src/pages/List_Restaurant.dart';
import 'package:front_app_corrientazo/src/pages/Splash.dart';
import 'package:front_app_corrientazo/src/pages/Today_Menu.dart';
import 'package:front_app_corrientazo/src/pages/Select_Menu.dart';
import 'package:front_app_corrientazo/src/pages/UpdateProfile.dart';
import 'package:front_app_corrientazo/src/pages/UserSubscriptions_Detail.dart';
import 'package:front_app_corrientazo/src/pages/historyRequestDetail.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
   
  return <String, WidgetBuilder>{

    'splash'             : (BuildContext context) => SplashScreenPage(),
    'login'              : (BuildContext context) => LoginPage(),
    'registry'           : (BuildContext context) => SingInPage(),
    'search'             : (BuildContext context) => SearchRestaurantPage(),
    'list'               : (BuildContext context) => ListRestaurantPage(),
    'menu'               : (BuildContext context) => TodayMenuPage(), 
    'reset'              : (BuildContext context) => ResetPage(),
    'sellerRequest'      : (BuildContext context) => SellerRequestPage(),
    'select'             : (BuildContext context) => SelectMenuPage(),
    'profile'            : (BuildContext context) => ProfilePage(),
    'updateProfile'      : (BuildContext context) => UpdateProfilePage(),
    'ordersHistory'      : (BuildContext context) => OrdersHistoryPage(),      
    'payment'            : (BuildContext context) => PaymentMethod(),
    'detail'             : (BuildContext context) => HistoryRequestDetail(),
    'historyDetail'      : (BuildContext context) => HistoryOrdersDetail(),
    'ongoingOrders'      : (BuildContext context) => OrgoingOrdersPage(),
    'paymentwebview'     : (BuildContext context) => PaymentWeb(),
    'newdirection'       : (BuildContext context) => NewDirectionPage(),
    'userSubscription'   : (BuildContext context) => UserSubscriptionsPage(),
    'listPaidProduct'    : (BuildContext context) => ListPaidProduct(),
    'listsubscription'   : (BuildContext context) => ListSubscription(),
    'detailpayment'      : (BuildContext context) => DetailPayment(),
    'changepasswordpage' : (BuildContext context) => ChangePasswordPage(),

  };
}