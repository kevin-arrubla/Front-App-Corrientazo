import 'package:flutter/material.dart';
import 'package:front_app_corrientazo/src/providers/subscription_Provider.dart';
import 'package:front_app_corrientazo/src/services/Alert.dart';

class SubscriptionController {
  SubscriptionProvider subscriptionProvider;
  Alerts alert;

  SubscriptionController() {
    subscriptionProvider = SubscriptionProvider();
    alert = Alerts();
  }

  createSubscription(BuildContext context, data) {
    subscriptionProvider.createSubscription(data).then((res) {
      if (res == null) {
        alert.errorAlert(context, 'ERROR');
      } else {
        alert.successAlert(context, 'Suscripción exitosa');
      }
    });
  }

  createPackage(BuildContext context, data) {
    subscriptionProvider.createPackage(data).then((res) {
      alert.successAlert(context, 'Paquete Creado con éxito');
    });
  }
}
