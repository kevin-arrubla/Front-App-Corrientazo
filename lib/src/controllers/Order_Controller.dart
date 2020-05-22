import 'package:flutter/cupertino.dart';
import 'package:front_app_corrientazo/src/providers/orders_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';

class OrderController {
  OrdersProviders ordersProviders;
  Alerts alerts;

  OrderController() {
    ordersProviders = OrdersProviders();
    alerts = Alerts();
  }

  void orderPayment(BuildContext context,userId, data) {
    ordersProviders.updateOrderPayment(userId, data).then((res){
      if(res==null){
        alerts.errorAlert(context, 'ERROR');
      }
      else{
       alerts.successAlert(context, 'Pago Recibido');
      }

    });
  }
}
