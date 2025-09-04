import 'package:cargo/models/address_response_model.dart';
import 'package:cargo/models/area_model.dart';
import 'package:cargo/models/county_model.dart';
import 'package:cargo/models/google_maps_model.dart';
import 'package:cargo/models/state_model.dart';
import 'package:cargo/ui/add_new_receiver_address/bloc/add_receiver_address_events.dart';
import 'package:cargo/ui/add_new_receiver_address/bloc/add_receiver_address_states.dart';
import 'package:cargo/utils/constants/constants.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddReceiverAddressBloc extends Bloc<AddReceiverAddressEvents, AddReceiverAddressStates> {
  final Repository _repository;
  Position? location;
  LatLng? latLng;
  int currentIndex = 0;
  List<CountryModel> countries = [];
  List<CountryModel> searchCountries = [];
  List<StateModel> cities = [];
  List<AreaModel> areas = [];
  GoogleMapsModel? googleMapsModel;

  String? addressName;

  CountryModel? selectedCountry;

  StateModel? selectedCity;

  AreaModel? selectedArea;

  AddReceiverAddressBloc(this._repository) : super(InitialAddReceiverAddressState());

  static AddReceiverAddressBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<AddReceiverAddressStates> mapEventToState(AddReceiverAddressEvents event) async* {
    if (event is NextAddReceiverAddressEvent) {
      yield SuccessNextAddReceiverAddressState();
    }

    if (event is ChangeSearchReceiverAddressEvent) {
      yield SuccessSearchAddReceiverAddressState();
    }

    if (event is SubmitAddReceiverAddressEvent) {
      yield LoadingAddReceiverAddressState();
      final registerResponse = await _repository.saveNewAddressOfReceiver(
          addressResponseModel: AddressResponseModel(
            id: '',
              client_id: '',
              created_at: '',
              updated_at: '',

              address: addressName??'',
              area_id: selectedArea?.id??'',
              country_id: selectedCountry?.id??'',
              state_id: selectedCity?.id??'',
              client_lat: (event.pickResult?.geometry?.location.lat ?? '').toString(),
              client_lng: (event.pickResult?.geometry?.location.lng ?? '').toString(),
              client_street_address_map: event.pickResult?.vicinity ?? '',
              client_url: event.pickResult?.url ?? '',
          ));

      yield* registerResponse.fold((l) async* {
        yield ErrorAddReceiverAddressState(l, false);
      }, (r) async* {
        yield SuccessAddReceiverAddressState();
        print('dadadad');
        print(r);
      });
    }

    if (event is FetchAddReceiverAddressEvent) {
      yield LoadingProgressAddReceiverAddressState();
        try {
         location =  await Geolocator.getCurrentPosition();
      latLng = LatLng(location!.latitude, location!.longitude);
      } catch (e) {
      latLng = LatLng(40.7128, 74.0060);
      }
      final countriesResponse = await _repository.getAllCountries();
      final googleMapsResponse = await _repository.getGoogleMaps();

      yield* countriesResponse.fold((l) async* {
        yield ErrorAddReceiverAddressState(l, true);
      }, (r) async* {
        countries = r;
      });

      yield* googleMapsResponse.fold((l) async* {
        print('llllllllllllll');
        print(l);
        yield ErrorAddReceiverAddressState(l, true);
      }, (r) async* {
        googleMapsModel = r;
        yield SuccessAddReceiverAddressState();
      });
    }
    if (event is FetchCitiesAddReceiverAddressEvent) {
      yield LoadingProgressAddReceiverAddressState();
      final citiesResponse = await _repository.getCities(countyID: event.countryId);
      yield* citiesResponse.fold((l) async* {
        showToast(l, false);
        yield ErrorAddReceiverAddressState(l, true);
      }, (r) async* {
        cities = r;
        print('cities');
        print(cities.length);
        yield SuccessAddReceiverAddressState();
      });
    }
    if (event is FetchAreasAddReceiverAddressEvent) {
      yield LoadingProgressAddReceiverAddressState();
      final areasResponse = await _repository.getAreas(cityID: event.cityId);
      yield* areasResponse.fold((l) async* {
        showToast(l, false);
        yield ErrorAddReceiverAddressState(l, true);
      }, (r) async* {
        areas = r;
        print('areas');
        print(areas.length);
        yield SuccessAddReceiverAddressState();
      });
    }
  }
}
