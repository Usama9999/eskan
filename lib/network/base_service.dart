import 'dart:convert';

import 'package:eskan/network/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../cache/cache_manager.dart';
import '../constants/messages_util.dart';
import '../enums/request_type.dart';
import '../widget/loading_widget/loading_widget.dart';
import '../widget/popup_widget/generic_error_dialog.dart';

typedef void ServiceCallBack(bool isSuccess, String? responseCode,
    String? responseDesc, dynamic parsedJson);

class BaseService {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  Map<String, dynamic> params = new Map();

  Future<void> execute(String actionName, BuildContext context,
      ServiceCallBack completionHandler, RequestType requestType,
      {bool showLoadingOnStart = true, bool hideLoadingAtEnd = true}) async {
    if (showLoadingOnStart) {
      LoadingWidget(context).showProgressIndicator();
    }
    final baseURL = URLs().baseURL;
    var url = Uri.parse(baseURL + actionName);

    print('url :$url');

    var reqToPrint = baseURL + actionName;
    // params.forEach((key, value) {
    //   reqToPrint += key + "=" + value + "&";
    // });

    // pattern
    //     .allMatches(reqToPrint)
    //     .forEach((match) => debugPrint("${match.group(0)}"));

    try {
      var response;
      print("requestType: $requestType");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${CacheManager().apiToken}'
      };

      if (requestType == RequestType.GET) {
        response = await http.get(url, headers: headers);
      } else if (requestType == RequestType.POST) {
        response =
            await http.post(url, body: jsonEncode(params), headers: headers);
      } else if (requestType == RequestType.PUT) {
        response =
            await http.put(url, body: jsonEncode(params), headers: headers);
      } else {
        response = await http.delete(url, body: params, headers: headers);
      }

      print("response: $response");
      print("body: ${response.body}");

      if (showLoadingOnStart && hideLoadingAtEnd) {
        LoadingWidget(context).hideProgressIndicator();
      }

      var parsedResponse = await parse(response, context, actionName);

      //print("parsedResponse: ${parsedResponse}");

      completionHandler(parsedResponse.isSuccess, parsedResponse.responseCode,
          parsedResponse.responseDesc, parsedResponse.responsePayload);
    } catch (e) {
      print(e);
      if (hideLoadingAtEnd) {
        LoadingWidget(context).hideProgressIndicator();
      }
      debugPrint("Error in $actionName");
      //debugPrint(e.toString());
      //GenericErrorDialog.show(context, ErrorMessages.stringServiceError);
    }
  }

  Future<ParsedResponse> parse(
      http.Response response, BuildContext context, String actionName) async {
    try {
      var responseObject = json.decode(response.body);

      //print("responseObject: $responseObject");

      // debugPrint("Response for ${response.request!.url}: -- ${response.body}",
      //     wrapWidth: 1024);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseObject != null) {
        return ParsedResponse("success", "success", responseObject, true);
      } else {
        await GenericErrorDialog.show(context, responseObject["message"]);
        return ParsedResponse(null, null, responseObject, false);
      }
    } catch (e) {
      await GenericErrorDialog.show(context, ErrorMessages.stringServiceError);
      return ParsedResponse(null, null, null, false);
    }
  }
}

class ParsedResponse {
  String? responseCode;
  String? responseDesc;
  dynamic responsePayload;
  bool isSuccess;

  ParsedResponse(this.responseCode, this.responseDesc, this.responsePayload,
      this.isSuccess);
}
