import 'package:after_layout/after_layout.dart';
import 'package:cargo/models/shipment_model.dart';
import 'package:cargo/ui/shipment_details/bloc/shipment_details_bloc.dart';
import 'package:cargo/ui/shipment_details/bloc/shipment_details_events.dart';
import 'package:cargo/ui/shipment_details/bloc/shipment_details_states.dart';
import 'package:cargo/utils/config/config.dart';
import 'package:cargo/utils/constants/app_keys.dart';
import 'package:cargo/utils/constants/constants.dart';
import 'package:cargo/utils/constants/local_keys.dart';
import 'package:cargo/utils/di/di.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShipmentDetailsScreen extends StatefulWidget {
    final ShipmentModel? shipmentModel ;
    final String? code;
    ShipmentDetailsScreen(this.shipmentModel,{this.code});

    @override
    _NewOrderState createState() => _NewOrderState();
}

class _NewOrderState extends State<ShipmentDetailsScreen> with AfterLayoutMixin {

    @override
    void initState() {
        print('shipmentModel');
        print(widget.code);

        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return BlocProvider<ShipmentDetailsBloc>(
            create: (BuildContext context) => di<ShipmentDetailsBloc>()..add(FetchShipmentDetailsEvent(widget.shipmentModel?.id??'',widget.shipmentModel,code: widget.code)),
            child: BlocListener<ShipmentDetailsBloc, ShipmentDetailsStates>(
              listener: (BuildContext context, ShipmentDetailsStates state) async {
                  if (state is ErrorShipmentDetailsState) {
                      showToast(state.error, false);
                  }
              },
              child: SafeArea(
                child: Scaffold(
                    body: Builder(
                        builder: (context) => SizedBox.expand(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Container(
                                        color: rgboOrHex(Config.get.styling[Config.get.themeMode]?.primary),
                                        child: Column(
                                            children: [
                                                SizedBox(
                                                    height: MediaQuery.of(context).size.height * (1.2 / 100),
                                                ),
                                                Row(
                                                    children: [
                                                        SizedBox(
                                                            width: MediaQuery.of(context).size.height * (1.2 / 100),
                                                        ),
                                                        Container(
                                                            height: MediaQuery.of(context).size.height * (5.91 / 100),
                                                            child: IconButton(
                                                                icon: Icon(Icons.arrow_back_ios,
                                                                    color: rgboOrHex(Config.get.styling[Config.get.themeMode]?.buttonTextColor),
                                                                ),
                                                                onPressed: () {
                                                                    Navigator.pop(context);
                                                                },
                                                            ),
                                                        ),
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(
                                                                    tr(LocalKeys.shipment_details),
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: rgboOrHex(Config.get.styling[Config.get.themeMode]?.buttonTextColor),
                                                                    ),
                                                                ),
                                                            ),
                                                        ),
                                                        Container(
                                                            width: MediaQuery.of(context).size.height * (5.91 / 100),
                                                        )
                                                    ],
                                                ),
                                                SizedBox(
                                                    height: MediaQuery.of(context).size.height * (1.97 / 100),
                                                ),
                                            ],
                                        ),
                                    ),
                                    Expanded(
                                        child:  BlocBuilder<ShipmentDetailsBloc,ShipmentDetailsStates>(builder: (context, state) =>
                                                ConditionalBuilder(condition: state is !LoadingShipmentDetailsState,
                                                        builder: (context) => buildContent(),
                                                    fallback: (context) => Center(
                                                        child: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                valueColor: AlwaysStoppedAnimation<Color>(rgboOrHex(Config.get.styling[Config.get.themeMode]?.primary)),
                                                            ),
                                                        ),
                                                    ),
                                                )),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
          ),
        );
    }

    @override
    void afterFirstLayout(BuildContext context) {
        // TODO: implement afterFirstLayout
    }

    Widget buildContent() {
        return Builder(
            builder: (context) => SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        if(BlocProvider.of<ShipmentDetailsBloc>(context).errorOccurred)
                        Container(
                            color: Colors.redAccent,
                            padding:
                            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child: Row(
                                children: [
                                    Expanded(
                                        child: Text(
                                            tr(LocalKeys.server_error),
                                            style: TextStyle(
                                                color: rgboOrHex(Config.get.styling[Config.get.themeMode]?.buttonTextColor),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                            ),
                                        ),
                                    ),
                                    Container(
                                        height: 50,
                                        width: 100,
                                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width* 0.02,vertical: MediaQuery.of(context).size.height* 0.01),
                                        alignment: Alignment.bottomCenter,
                                        child: TextButton(
                                            onPressed: () {
                                                BlocProvider.of<ShipmentDetailsBloc>(context).add(FetchShipmentDetailsEvent(widget.shipmentModel?.id??'',widget.shipmentModel,code: widget.code));
                                            },
                                            child: Text(
                                                tr(LocalKeys.retry),
                                                style: TextStyle(
                                                    color: rgboOrHex(Config.get.styling[Config.get.themeMode]?.buttonTextColor),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                ),
                                            ),
                                        ),
                                    ),

                                ],
                            ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * (3.9 / 100),
                        ),
                        Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      tr(LocalKeys.shipment_info),
                                      style: TextStyle(
                                          color: rgboOrHex(Config.get.styling[Config.get.themeMode]?.primary),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                      ),
                                  ),
                                ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                                          vertical: MediaQuery.of(context).size.width * (2.0 / 100),
                                      ),
                                      child: Text(
                                          tr(AppKeys.getShipmentStatus(int.parse(BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.status_id??'0'))),
                                          style: TextStyle(
                                              color: Colors.white,
                                          ),
                                      ),
                                  ),
                              ],
                            ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * (1.0 / 100),
                        ),
                        Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child:Text(
                                BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.code??'',
                                style: TextStyle(
                                    color: rgboOrHex(
                                            Config.get.styling[Config.get.themeMode]?.secondaryVariant),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                ),
                            ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * (2.9 / 100),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (2.1 / 100)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                    Row(
                                        children: [
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.shipment_type),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                BlocProvider.of<ShipmentDetailsBloc>(context)?.shipmentModel?.type??'',
                                                                style: TextStyle(
                                                                    // color: rgboOrHex(Config
                                                                    //         .get.styling[Config.get.themeMode].color),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.sender_address),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.from_address?.address??'',
                                                                style: TextStyle(
                                                                    // color: rgboOrHex(Config
                                                                    //         .get.styling[Config.get.themeMode].color),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ],
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height * (4 / 100),
                                    ),
                                    Row(
                                        children: [
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.receiver),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.reciver_name??'',
                                                                style: TextStyle(
                                                                    // color: rgboOrHex(Config
                                                                    //         .get.styling[Config.get.themeMode].color),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.receiver_address),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.reciver_address??'',
                                                                style: TextStyle(
                                                                    // color: rgboOrHex(Config
                                                                    //         .get.styling[Config.get.themeMode].color),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ],
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height * (4 / 100),
                                    ),
                                    Row(
                                        children: [
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.tax),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                (BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.tax??'').toString()+' '+(BlocProvider.of<ShipmentDetailsBloc>(context).currencyModel?.symbol??'').toString(),
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.insurance),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                ((BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.insurance??'').toString()+' '+(BlocProvider.of<ShipmentDetailsBloc>(context).currencyModel?.symbol??'').toString()).toString(),
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ],
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height * (4 / 100),
                                    ),
                                    Row(
                                        children: [
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.return_cost),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                (BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.return_cost??'')+' '+(BlocProvider.of<ShipmentDetailsBloc>(context).currencyModel?.symbol??'').toString()??'',
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.shipping_cost),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                (BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.shipping_cost??'')+' '+(BlocProvider.of<ShipmentDetailsBloc>(context).currencyModel?.symbol??'').toString(),
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ],
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height * (3.9 / 100),
                                    ),
                                    Row(
                                        children: [
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.total_cost),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 15,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                (double.parse(BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.shipping_cost??'0')+double.parse(BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.tax??'0')+double.parse(BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.insurance??'0')).toString()+' '+(BlocProvider.of<ShipmentDetailsBloc>(context).currencyModel?.symbol??'').toString(),
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                tr(LocalKeys.otp),
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                            height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                            child: Text(
                                                                (BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.otp??''),
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18,
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ],
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height * (3.0 / 100),
                                    ),
                                    ConditionalBuilder(
                                        fallback: (context) => const SizedBox(),
                                        condition: BlocProvider.of<ShipmentDetailsBloc>(context).paymentTypes != null &&
                                         BlocProvider.of<ShipmentDetailsBloc>(context).paymentTypes.length >0,
                                      builder:(context) =>  Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context).size.width * (4.2 / 100),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (4.2 / 100)),
                                                  child: Text(
                                                      (){
                                                          final id =  BlocProvider.of<ShipmentDetailsBloc>(context).shipmentModel?.payment_method_id.toString();
                                                          final types = BlocProvider.of<ShipmentDetailsBloc>(context).paymentTypes ;
                                                          if(types.any((element) => element.id.toString()== id)){
                                                              return types.firstWhere((element) => element.id.toString()== id ).name;
                                                          }
                                                          return '';

                                                      }(),
                                                      style: TextStyle(
                                                          color: rgboOrHex(Config.get.styling[Config.get.themeMode]?.secondary),
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.end,
                                                  ),
                                              ),

                                          ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height * (3.9 / 100),
                                    ),
                                ],
                            ),
                        ),
                        Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child: Text(
                                tr(LocalKeys.package_items),
                                style: TextStyle(
                                    color: rgboOrHex(Config.get.styling[Config.get.themeMode]?.primary),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                ),
                            ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * (1.9 / 100),
                        ),
                        Column(
                            children: [
                                if(BlocProvider.of<ShipmentDetailsBloc>(context).packages!=null)
                                ...BlocProvider.of<ShipmentDetailsBloc>(context).packages.asMap().map((key, value) => MapEntry(
                                    value, Card(
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                    child: Container(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *(2.1 / 100)),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                SizedBox(
                                                    height: MediaQuery.of(context).size.height * (2 / 100),
                                                ),
                                                Row(
                                                    children: [
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            tr(LocalKeys.category),
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 13,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            value.package.name,
                                                                            style: TextStyle(
                                                                                // color: rgboOrHex(Config
                                                                                //         .get.styling[Config.get.themeMode].color),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 14,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            tr(LocalKeys.quantity),
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 13,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            value.qty??'',
                                                                            style: TextStyle(
                                                                                // color: rgboOrHex(Config
                                                                                //         .get.styling[Config.get.themeMode].color),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 14,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                SizedBox(
                                                    height: MediaQuery.of(context).size.height * (4 / 100),
                                                ),
                                                Row(
                                                    children: [
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            tr(LocalKeys.weight),
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 13,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            (value.weight??'') +( AppKeys.weights.first??''),
                                                                            style: TextStyle(
                                                                                // color: rgboOrHex(Config
                                                                                //         .get.styling[Config.get.themeMode].color),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 14,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            tr(LocalKeys.height),
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 13,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            (value.height??'' )+ (AppKeys.heights.first??''),
                                                                            style: TextStyle(
                                                                                // color: rgboOrHex(Config
                                                                                //         .get.styling[Config.get.themeMode].color),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 14,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                SizedBox(
                                                    height: MediaQuery.of(context).size.height * (4 / 100),
                                                ),
                                                Row(
                                                    children: [
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            tr(LocalKeys.width),
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 13,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            (value.width??'' )+( AppKeys.heights.first??''),
                                                                            style: TextStyle(
                                                                                // color: rgboOrHex(Config
                                                                                //         .get.styling[Config.get.themeMode].color),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 14,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            tr(LocalKeys.length),
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 13,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            (value.length??'' )+ (AppKeys.heights.first??''),
                                                                            style: TextStyle(
                                                                                // color: rgboOrHex(Config
                                                                                //         .get.styling[Config.get.themeMode].color),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 14,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                SizedBox(
                                                    height: MediaQuery.of(context).size.height * (4 / 100),
                                                ),
                                                Row(
                                                    children: [
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            tr(LocalKeys.description),
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 13,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                                                        child: Text(
                                                                            value.description??'',
                                                                            style: TextStyle(
                                                                                // color: rgboOrHex(Config
                                                                                //         .get.styling[Config.get.themeMode].color),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 14,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                SizedBox(
                                                    height: MediaQuery.of(context).size.height * (4.1 / 100),
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                                )).values.toList()
                            ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * (2.1 / 100),
                        ),
                    ],
                ),
            ),
        );
    }

}
