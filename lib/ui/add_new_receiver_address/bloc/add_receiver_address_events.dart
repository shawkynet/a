import 'package:flutter/foundation.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

@immutable
abstract class AddReceiverAddressEvents
{
  const AddReceiverAddressEvents();
}

class SubmitAddReceiverAddressEvent extends AddReceiverAddressEvents {
  final PickResult? pickResult;

  SubmitAddReceiverAddressEvent({
    required  this.pickResult,
});
}
class FetchAddReceiverAddressEvent extends AddReceiverAddressEvents {}
class NextAddReceiverAddressEvent extends AddReceiverAddressEvents {}
class ChangeAddReceiverAddressEvent extends AddReceiverAddressEvents {}
class ChangeSearchReceiverAddressEvent extends AddReceiverAddressEvents {}
class ChangeBackwardEvent extends AddReceiverAddressEvents {}

class FetchCitiesAddReceiverAddressEvent extends AddReceiverAddressEvents {
  final String countryId ;
  FetchCitiesAddReceiverAddressEvent({
    required  this.countryId,
  });
}

class FetchAreasAddReceiverAddressEvent extends AddReceiverAddressEvents {
  final String cityId ;
  FetchAreasAddReceiverAddressEvent({
    required  this.cityId,
  });
}
