import 'package:flutter/foundation.dart';

@immutable
abstract class AddReceiverEvents
{
  const AddReceiverEvents();
}

class SubmitAddReceiverEvent extends AddReceiverEvents {
}
class FetchAddReceiverEvent extends AddReceiverEvents {}
class NextAddReceiverEvent extends AddReceiverEvents {}
class ChangeAddReceiverEvent extends AddReceiverEvents {}
class ChangeBackwardEvent extends AddReceiverEvents {}

class FetchCitiesAddReceiverEvent extends AddReceiverEvents {
  final String countryId ;
  FetchCitiesAddReceiverEvent({
    required  this.countryId,
  });
}

class FetchAreasAddReceiverEvent extends AddReceiverEvents {
  final String cityId ;
  FetchAreasAddReceiverEvent({
    required  this.cityId,
  });
}
