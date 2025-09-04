import 'package:cargo/components/main_button.dart';
import 'package:cargo/ui/forget_password/bloc/forget_password_bloc.dart';
import 'package:cargo/ui/forget_password/bloc/forget_password_events.dart';
import 'package:cargo/ui/forget_password/bloc/forget_password_states.dart';
import 'package:cargo/utils/config/config.dart';
import 'package:cargo/utils/constants/constants.dart';
import 'package:cargo/utils/constants/local_keys.dart';
import 'package:cargo/utils/di/di.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgetPasswordBloc>(
      create: (BuildContext context) => di<ForgetPasswordBloc>(),
      child: BlocListener<ForgetPasswordBloc, ForgetPasswordStates>(
        listener: (BuildContext context, ForgetPasswordStates state) async {
          if (state is ErrorForgetPasswordState) {
            print('asdasdasd');
            showToast(state.error, false);
          }
          if (state is SuccessForgetPasswordState) {
            showToast(state.message, false);
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: rgboOrHex(Config.get.styling[Config.get.themeMode]?.primary),
            title: Text(
              tr(LocalKeys.forget_password),
              style: TextStyle(
                color: rgboOrHex(Config.get.styling[Config.get.themeMode]?.buttonTextColor),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) => SizedBox.expand(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (6.4 / 100),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  tr(LocalKeys.email),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: TextFormField(
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return tr(LocalKeys.this_field_cant_be_empty);
                                    }
                                    else if(!RegExp(
                                      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
                                    ).hasMatch(v.toLowerCase().trim())){
                                      return tr(LocalKeys.thisIsNotEmail);
                                    }else {
                                      return null;
                                    }
                                  },
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: tr(LocalKeys.email),
                                    hintStyle: TextStyle(fontSize: 11),
                                    focusedBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                        borderSide: BorderSide(color: Colors.black, width: 2)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (12.1 / 100),
                              ),
                              BlocBuilder<ForgetPasswordBloc, ForgetPasswordStates>(
                                builder: (context, state) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                  child: MainButton(
                                      isLoading: state is LoadingForgetPasswordState,
                                    borderColor: rgboOrHex(
                                        Config.get.styling[Config.get.themeMode]?.secondaryVariant),
                                    borderRadius: 0,
                                    onPressed: () {
                                      formKey.currentState?.save();
                                      if (formKey.currentState != null && formKey.currentState!.validate()) {
                                        BlocProvider.of<ForgetPasswordBloc>(context).add(
                                          SubmitForgetPasswordEvent(
                                            email: emailController.text,
                                          ),
                                        );
                                      }
                                    },
                                    text: tr(LocalKeys.login),
                                    textColor: rgboOrHex(
                                        Config.get.styling[Config.get.themeMode]?.buttonTextColor),
                                    color: rgboOrHex(Config
                                        .get.styling[Config.get.themeMode]?.primary),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (4.1 / 100),
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
