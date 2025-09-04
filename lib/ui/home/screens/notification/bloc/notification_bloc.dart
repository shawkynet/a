import 'package:cargo/models/notification_model.dart';
import 'package:cargo/ui/home/screens/notification/bloc/notification_states.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_events.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationStates> {
  final Repository _repository;
  List<NotificationModel> notifications=[];
  bool errorOccurred= true ;


  NotificationBloc(this._repository) : super(InitialNotificationState());

  static NotificationBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<NotificationStates> mapEventToState(NotificationEvents event) async*
  {
    if (event is FetchNotificationEvent) {
      errorOccurred = false;
      yield LoadingNotificationState();

      final no =await  _repository.getNotifications();
      yield* no.fold((l) async*{
        errorOccurred = true;
        yield ErrorNotificationState(l);
      }, (r) async*{
        notifications = r;
        print(r.length);
        yield SuccessNotificationState();
      });
    }
  }
}
