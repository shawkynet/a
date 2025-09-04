import 'package:flutter/material.dart';

@immutable
abstract class NewOrderEvents
{
  const NewOrderEvents();
}

class FetchNewOrderEvent extends NewOrderEvents {}
class NextNewOrderEvent extends NewOrderEvents {}
class NewOrderChangeEvent extends NewOrderEvents {}
class NewOrderChangeBackwardEvent extends NewOrderEvents {}

class ChangeSendReceiveNewOrderEvent extends NewOrderEvents {}
class ChangeCollectionTimeNewOrderEvent extends NewOrderEvents {
  final TimeOfDay timeOfDay;

  ChangeCollectionTimeNewOrderEvent(this.timeOfDay);
}

class CreateNewOrderEvent extends NewOrderEvents {}

class AddDateNewOrderEvent extends NewOrderEvents {}

class AddPackageNewOrderEvent extends NewOrderEvents {}
class RemovePackageNewOrderEvent extends NewOrderEvents {}

class SetSenderAddressNewOrderEvent extends NewOrderEvents {}
class SetBranchNewOrderEvent extends NewOrderEvents {}
class SetReceiverAddressNewOrderEvent extends NewOrderEvents {}
class SetReceiverNewOrderEvent extends NewOrderEvents {}

class SetPackageNewOrderEvent extends NewOrderEvents {}
class SetPaymentNewOrderEvent extends NewOrderEvents {}
class SetPaymentMethodNewOrderEvent extends NewOrderEvents {}
class SetAmountToBeCollectedNewOrderEvent extends NewOrderEvents {}
class SetOrderIDNewOrderEvent extends NewOrderEvents {}
