import 'package:cargo/utils/constants/local_keys.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class AppKeys{
    static String APP_LOGO_PATH= 'APP_LOGO_PATH';
    static String onOnBoardOpened= 'onOnBoardOpened';
    static String userData= 'userData';

    // payment method
    static int POSTPAID = 1;
    static int PREPAID = 2;

    static const int PICKUP = 1;
    static const int DROPOFF = 2;

    static const String PICKUP_Key = 'Pickup';
    static const int PICKUP_TYPE = 1;
    static const int DELIVERY_TYPE = 2;
    static const int RETURN_TYPE = 3;
    static const int SUPPLY_TYPE = 4;
    static const int TRANSFER_TYPE = 5;

    static const SAVED_STATUS = 1;
    static const REQUESTED_STATUS = 2;
    static const APPROVED_STATUS = 3;
    static const CLOSED_STATUS = 4;
    static const CAPTAIN_ASSIGNED_STATUS = 5;
    static const RECIVED_STATUS = 6;
    static const IN_STOCK_STATUS = 7;
    static const PENDING_STATUS = 8;
    static const DELIVERED_STATUS = 9;
    static const SUPPLIED_STATUS = 10;
    static const RETURNED_STATUS = 11;
    static const RETURNED_ON_SENDER = 12;
    static const RETURNED_ON_RECEIVER = 13;
    static const RETURNED_STOCK = 14;
    static const RETURNED_CLIENT_GIVEN = 15;

    static getShipmentStatus(int status){
        switch(status){
            case SAVED_STATUS:
                return LocalKeys.saved_status;
            case REQUESTED_STATUS:
                return LocalKeys.requested_status;
            case APPROVED_STATUS:
                return LocalKeys.approved_status;
            case CLOSED_STATUS:
                return LocalKeys.closed_status;
            case CAPTAIN_ASSIGNED_STATUS:
                return LocalKeys.captin_assigned_status;
            case RECIVED_STATUS:
                return LocalKeys.received_status;
            case IN_STOCK_STATUS:
                return LocalKeys.in_stock_status;
            case PENDING_STATUS:
                return LocalKeys.pending_status;
            case DELIVERED_STATUS:
                return LocalKeys.delived_status;
            case SUPPLIED_STATUS:
                return LocalKeys.supplied_status;
            case RETURNED_STATUS:
                return LocalKeys.returned_status;
            case RETURNED_ON_SENDER:
                return LocalKeys.returned_on_sender_status;
            case RETURNED_ON_RECEIVER:
                return LocalKeys.returned_on_receiver_status;
            case RETURNED_STOCK:
                return LocalKeys.returned_stock_status;
            case RETURNED_CLIENT_GIVEN:
                return LocalKeys.returned_client_given_status;

            default:
                return '';
        }
    }


    static const TRACKING_CLIENT_STATUS_CREATED = 1;
    static const TRACKING_CLIENT_STATUS_READY = 2;
    static const TRACKING_CLIENT_STATUS_IN_PROCESSING = 3;
    static const TRACKING_CLIENT_STATUS_TRANSFERED = 4;
    static const TRACKING_CLIENT_STATUS_RECEIVED_BRANCH = 5;
    static const TRACKING_CLIENT_STATUS_OUT_FOR_DELIVERY = 6;
    static const TRACKING_CLIENT_STATUS_DELIVERED = 7;
    static const TRACKING_CLIENT_STATUS_SUPPLIED = 8;

    static getShipmentLogStatus(int status){
        switch(status){
            case TRACKING_CLIENT_STATUS_CREATED:
                return LocalKeys.tracking_client_status_created;
            case TRACKING_CLIENT_STATUS_READY:
                return LocalKeys.tracking_client_status_ready;
            case TRACKING_CLIENT_STATUS_IN_PROCESSING:
                return LocalKeys.tracking_client_status_in_progress;
            case TRACKING_CLIENT_STATUS_TRANSFERED:
                return LocalKeys.tracking_client_status_transferred;
            case TRACKING_CLIENT_STATUS_RECEIVED_BRANCH:
                return LocalKeys.tracking_client_status_received_branch;
            case TRACKING_CLIENT_STATUS_OUT_FOR_DELIVERY:
                return LocalKeys.tracking_client_status_out_for_delivery;
            case TRACKING_CLIENT_STATUS_DELIVERED:
                return LocalKeys.tracking_client_status_delivered;
            case TRACKING_CLIENT_STATUS_SUPPLIED:
                return LocalKeys.tracking_client_status_supplied;

            default:
                return '';
        }
    }

    static const List<int> missionTypes = [
        PICKUP_TYPE,
        SUPPLY_TYPE
    ];

    static getMissionType(int type){
        switch(type){
            case PICKUP_TYPE:
                return LocalKeys.pickup_type;
            case SUPPLY_TYPE:
                return LocalKeys.supply_type;
            default:
                return '';
        }
    }

    static List<int> paymentMethods=[
        POSTPAID,
        PREPAID,
        ];

    static String myAddresses= 'myAddresses';
    static String receiverAddresses= 'receiverAddresses';
    static String receivers= 'receivers';

    static List<String> weights= [
        tr(LocalKeys.kg),
        // tr(LocalKeys.gram),
    ];

  static List<String> heights= [
        // tr(LocalKeys.meter),
        tr(LocalKeys.cm),
    ];

}