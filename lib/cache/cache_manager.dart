import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../root/auth/model/register_model.dart';

class CacheManager {
  static final CacheManager _singleton = CacheManager._internal();

  factory CacheManager() {
    return _singleton;
  }
  CacheManager._internal();
  String cardProgramName = "";
  late Size screenSize;
  String apiToken = "";
  int roleId = 1;
  late BuildContext splashContext;
  var crewModule = true;

  var myProperties = <DocumentSnapshot>[];
  var apartmentProperties = <DocumentSnapshot>[];
  var villaProperties = <DocumentSnapshot>[];
  var villaApartmentProperties = <DocumentSnapshot>[];
  var townhouseProperties = <DocumentSnapshot>[];
  var penthouseProperties = <DocumentSnapshot>[];
  var compoundProperties = <DocumentSnapshot>[];
  var duplexProperties = <DocumentSnapshot>[];
  var wholeBuildingProperties = <DocumentSnapshot>[];
  var hotelApartmentsProperties = <DocumentSnapshot>[];
  var hotelRoomsProperties = <DocumentSnapshot>[];
  var staffAccommodationProperties = <DocumentSnapshot>[];
  var bedSpaceProperties = <DocumentSnapshot>[];
  var studioProperties = <DocumentSnapshot>[];
  var permanentModule = true;
  bool loggedIn = false;

  var userEmail = '';
  var userName = '';
  var phoneNumber = '';
  var location = '';

  var rememberMe = false;
  var enabledUser = false;

  var currentState = GlobalKey<ScaffoldState>().currentState;
  String verificationId = '';
  RegisterRequestModel registerModel = RegisterRequestModel();
}
