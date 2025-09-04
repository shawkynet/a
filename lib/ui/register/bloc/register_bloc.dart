import 'package:cargo/models/address_model.dart';
import 'package:cargo/models/area_model.dart';
import 'package:cargo/models/county_model.dart';
import 'package:cargo/models/google_maps_model.dart';
import 'package:cargo/models/state_model.dart';
import 'package:cargo/ui/register/bloc/register_events.dart';
import 'package:cargo/ui/register/bloc/register_states.dart';
import 'package:cargo/utils/constants/constants.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisterBloc extends Bloc<RegisterEvents, RegisterStates> {
  final Repository _repository;
  Position? location;
  LatLng? latLng;
  int currentIndex = 0;
  List<CountryModel> countries = [];
  List<StateModel> cities = [];
  List<AreaModel> areas = [];
  List<CountryModel> searchCountries = [];
  bool showPassword = false;

  CountryModel? selectedCountry;
  StateModel? selectedCity;
  AreaModel? selectedArea;
  GoogleMapsModel? googleMapsModel;
  bool errorOccurred = false;

  RegisterBloc(this._repository) : super(InitialRegisterState());

  static RegisterBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<RegisterStates> mapEventToState(RegisterEvents event) async* {
    if (event is NextRegisterEvent) {
      yield SuccessNextRegisterState();
    }

    if (event is PasswordToggleChangedRegisterEvent) {
      yield SuccessNextRegisterState();
    }

    if (event is ChangeEvent) {
      yield SuccessStepForwardRegisterState();
    }
    if (event is ChangeBackwardEvent) {
      yield SuccessStepBackwardRegisterState();
    }

    if (event is SubmitRegisterEvent) {
      yield LoadingRegisterState();

      final registerResponse =
          await _repository.register(userModel: event.userModel);

      yield* registerResponse.fold((l) async* {
        yield ErrorRegisterState(l, false);
      }, (r) async* {
        _repository.user = r;
        if (r.error != null) {
          yield ErrorRegisterState(r?.error??'', false);
        } else {
          await _repository.saveNewAddressOfSender(
              addressModel: AddressModel(
                address_name: event.addressName,
                area_id: selectedArea?.id ?? '',
                area_name: selectedArea?.name ?? '',
                country_code: selectedCity?.country_code??'',
                country_currency: selectedCountry?.currency??'',
                country_id: selectedCountry?.id??'',
                country_name: selectedCountry?.name??'',
                country_phonecode: selectedCountry?.phonecode??'',
                state_id: selectedCity?.id??'',
                state_name: selectedCity?.name??'',
              ),
              pickResult: event.pickResult);
          yield RegisteredSuccessfully();
        }
      });
    }

    if (event is FetchRegisterEvent) {
      errorOccurred = false;
      yield LoadingProgressRegisterState();
      try {
        location = await Geolocator.getCurrentPosition();
        latLng = LatLng(location!.latitude, location!.longitude);
      } catch (e) {
        latLng = LatLng(40.7128, 74.0060);
      }
      final countriesResponse = await _repository.getAllCountries();
      final googleMapsResponse = await _repository.getGoogleMaps();
      yield* googleMapsResponse.fold((l) async* {
        print('llllllllllllll');
        print(l);
        errorOccurred = true;
        yield ErrorRegisterState(l, true);
      }, (r) async* {
        googleMapsModel = r;
        print("googleMapsModel " +googleMapsModel.toString());

      });

      yield* countriesResponse.fold((l) async* {
        showToast(l, false);
        errorOccurred = true;
        yield ErrorRegisterState(l, true);
      }, (r) async* {
        countries = r;
        print('countries');
        print(countries.length);
        final branchesResponse = await _repository.getBranches();

        yield* branchesResponse.fold((l) async* {
          yield SuccessRegisterState(branches: []);
        }, (r) async* {
          yield SuccessRegisterState(branches: r);
        });
      });
    }
    if (event is FetchCitiesEvent) {
      yield LoadingProgressRegisterState();
      final citiesResponse =
          await _repository.getCities(countyID: event.countryId);
      yield* citiesResponse.fold((l) async* {
        showToast(l, false);
        yield ErrorRegisterState(l, true);
      }, (r) async* {
        cities = r;
        print('cities');
        print(cities.length);
        yield SuccessRegisterState( branches: []);
      });
    }
    if (event is FetchAreasEvent) {
      yield LoadingProgressRegisterState();
      final areasResponse = await _repository.getAreas(cityID: event.cityId);
      yield* areasResponse.fold((l) async* {
        showToast(l, false);
        yield ErrorRegisterState(l, true);
      }, (r) async* {
        areas = r;
        print('areas');
        print(areas.length);
        yield SuccessRegisterState(branches: []);
      });
    }
  }
}
