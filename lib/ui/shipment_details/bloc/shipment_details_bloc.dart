import 'package:cargo/models/currency_model.dart';
import 'package:cargo/models/payment_method_model.dart';
import 'package:cargo/models/shipment_model.dart';
import 'package:cargo/models/single_package_shipment_model.dart';
import 'package:cargo/ui/shipment_details/bloc/shipment_details_events.dart';
import 'package:cargo/ui/shipment_details/bloc/shipment_details_states.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShipmentDetailsBloc extends Bloc<ShipmentDetailsEvents, ShipmentDetailsStates> {
  final Repository _repository;
  List<SinglePackageShipmentModel> packages =[];
  CurrencyModel? currencyModel ;
  ShipmentModel? shipmentModel;
  List<PaymentMethodModel> paymentTypes= [];
  bool errorOccurred= false ;

  ShipmentDetailsBloc(this._repository) : super(InitialShipmentDetailsState());

  static ShipmentDetailsBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<ShipmentDetailsStates> mapEventToState(ShipmentDetailsEvents event) async*
  {
    if (event is NextShipmentDetailsEvent) {
      yield SuccessNextShipmentDetailsState();
    }
    if (event is FetchShipmentDetailsEvent) {
      errorOccurred = false;
      yield LoadingShipmentDetailsState();
      if(event.code != null)
        {
          final getPaymentTypes = await  _repository.getPaymentTypes();
          yield* getPaymentTypes.fold((l)async* {
            errorOccurred = true;
            yield ErrorShipmentDetailsState(l);
          }, (r)async *{
            paymentTypes = r;
          });

          final f1 =await  _repository.getShipments(code: event.code);
          yield* f1.fold((l) async* {}, (r) async*{
            if(r != null && r.data != null && r.data.length==1){
              final getCurrencies = await  _repository.getCurrencies();
              yield* getCurrencies.fold((l)async* {
                errorOccurred = true;
                yield ErrorShipmentDetailsState(l);
              }, (r)async *{
                 currencyModel = r;
              });
              final f =await  _repository.getSingleShipmentPackages(shipmentId: r.data.first.id);
              shipmentModel = r.data.first;
              yield* f.fold((l) async*{
                errorOccurred = true;
                yield ErrorShipmentDetailsState(l);
              }, (r) async*{
                packages = r;
                print('r.length');
                yield SuccessShipmentDetailsState();
              });
            }
          });
        }else{
        print('ollplpl');
        print(event.shipmentModel);

        final List<Either<String, dynamic>> responses = await Future.wait([
          _repository.getCurrencies(),
          _repository.getPaymentTypes(),
          _repository.getSingleShipmentPackages(shipmentId: event.shipmentId),
        ]);

        final Either<String, CurrencyModel> getCurrencies = responses[0].map((r) => r);
        yield* getCurrencies.fold((l)async* {
          errorOccurred = true;
          yield ErrorShipmentDetailsState(l);
        }, (r)async *{
          currencyModel = r;
        });
        final Either<String, List<PaymentMethodModel>> getPaymentTypes = responses[1].map((r) => r);
        yield* getPaymentTypes.fold((l)async* {
          errorOccurred = true;
          yield ErrorShipmentDetailsState(l);
        }, (r)async *{
          paymentTypes = r;
        });

        shipmentModel = event.shipmentModel;
        final Either<String, List<SinglePackageShipmentModel>> f = responses[2].map((r) => r );
        yield* f.fold((l) async*{
          errorOccurred = true;
          yield ErrorShipmentDetailsState(l);
        }, (r) async*{
          packages = r;
          print('r.length');
          print(packages.length);
          yield SuccessShipmentDetailsState();
        });
      }
    }

    }
  }
