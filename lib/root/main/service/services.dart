import 'package:flutter/material.dart';

import '../../../enums/request_type.dart';
import '../../../network/base_service.dart';

class MainService extends BaseService {
  static MainService instance = MainService();

  getCountries(
    BuildContext context,
    ServiceCallBack completion,
  ) {
    super.params = new Map();
    execute("countries", context, completion, RequestType.GET);
  }

  getCrewTypes(
    BuildContext context,
    ServiceCallBack completion,
  ) {
    super.params = new Map();
    execute("crew_types", context, completion, RequestType.GET);
  }

  loginUser(
    BuildContext context,
    ServiceCallBack completion,
    String email,
    String password,
    bool showLoading,
  ) {
    super.params = new Map();
    super.params["email"] = email;
    super.params["password"] = password;
    execute("users/login", context, completion, RequestType.POST,
        hideLoadingAtEnd: showLoading == false ? false : true,
        showLoadingOnStart: showLoading == false ? false : true);
  }

  verifyOTP(
    BuildContext context,
    ServiceCallBack completion,
    String email,
    String otp,
  ) {
    super.params = new Map();
    super.params["email"] = email;
    super.params["code"] = otp;
    execute("users/verify_code", context, completion, RequestType.POST);
  }

  // registerUser(BuildContext context, ServiceCallBack completion,
  //     RegisterRequestModel registerRequestModel, bool crewModule) {
  //   super.params = new Map();
  //   print("Damn");
  //   super.params["firstname"] = registerRequestModel.firstName;
  //   super.params["lastname"] = registerRequestModel.lastName;
  //   super.params["email"] = registerRequestModel.email;
  //   super.params["password"] = registerRequestModel.password;
  //   super.params["country_id"] = registerRequestModel.countryId;
  //   super.params["crew_type_id"] = registerRequestModel.positionId;
  //   super.params["newsletter"] = registerRequestModel.newsLetter;
  //   super.params["promo_code"] = registerRequestModel.promoCode;
  //   super.params["company_name"] = registerRequestModel.companyName;
  //   String url = crewModule ? "crews/register" : "clients/register";
  //   execute(url, context, completion, RequestType.POST);
  // }
}
