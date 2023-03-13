import 'package:eskan/cache/cache_manager.dart';
import 'package:eskan/root/auth/screens/login.dart';
import 'package:eskan/root/auth/screens/otp_screen.dart';
import 'package:eskan/root/auth/service/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/loading_widget/loading_widget.dart';
import '../../../widget/popup_widget/generic_error_dialog.dart';

class AuthController extends GetxController {
  // ignore: non_constant_identifier_names
  AuthService? aService;

  // ignore: non_constant_identifier_names
  AuthController({this.aService});
  var passwordProtected = true.obs;
  var rePasswordProtected = true.obs;
  var userEmail = '';

  var processIndex = 0.obs;
  late BuildContext splashContext;
  // List<CountryModel> listOfCountries = <CountryModel>[].obs;
  // List<CountryModel> filteredListOfCountries = <CountryModel>[].obs;
  //
  // List<CrewTypeModel> listOfCrewTypes = <CrewTypeModel>[].obs;
  // List<CrewTypeModel> filteredListOfCrewTypes = <CrewTypeModel>[].obs;
  var isApiDataFetched = false.obs;
  var selectedCountry = 'United States'.obs;
  var selectedPosition = 'Pilot in Command'.obs;

  var showCountryDropDrown = false.obs;
  var showPositionDropDown = false.obs;

  List<String> listOfQatarZones = [
    'Al Jasrah',
    'Al Bidda',
    'Fereej Mohamed Bin Jasim Mushayrib',
    'Mushayrib',
    'Al Najada  Barahat Al Jufairi Fereej Al Asmakh',
    'Old Al Ghanim',
    'Al Souq',
    'Wadi Al Sail',
    'Rumeilah',
    'Al Bidda',
    'Mushayrib',
    'Fereej Abdel Aziz',
    'Ad Dawhah al Jadidah',
    'Old Al Ghanim',
    'Al Rufaa Old Al Hitmi',
    'As Salatah Al Mirqab',
    'Doha Port',
    'Wadi Al Sail',
    'Rumeilah',
    'Fereej Bin Mahmoud',
    'Rawdat Al Khail',
    'Fereej Bin Durham Al Mansoura',
    'Najma',
    'Umm Ghuwailina',
    'Al Khulaifat Ras Abu Aboud',
    'Duhail',
    'Umm Lekhba',
    'Madinat Khalifa North Dahl Al Hamam',
    'Al Markhiya',
    'Madinat Khalifa South',
    'Fereej Kulaib',
    'Al Messila',
    'Fereej Bin Omran New Al Hitmi Hamad Medical City',
    'Al Sadd',
    'Al Sadd New Al Mirqab Fereej Al Nasr',
    'New Salatah',
    'Nuaija',
    'Al Hilal',
    'Nuaija',
    'Old Airport',
    'Al Thumama',
    'Doha International Airport',
    'Zone 50',
    'Industrial Area',
    'Zone 58',
    'Al Dafna Al Qassar',
    'Onaiza',
    'Lejbailat',
    'Onaiza Leqtaifiya Al Qassar',
    'Hazm Al Markhiya',
    'Jelaiah Al Tarfa Jeryan Nejaima',
    'Al Gharrafa Gharrafat Al Rayyan Izghawa Bani Hajer Al Seej Rawdat Egdaim Al Themaid',
    'Al Luqta Lebday Old Al Rayyan Al Shagub Fereej Al Zaeem',
    'New Al Rayyan Al Wajbah Muaither',
    'Fereej Al Amir Luaib Muraikh Baaya Mehairja Fereej Al Soudan',
    'Fereej Al Soudan Al Waab Al Aziziya New Fereej Al Ghanim Fereej Al Murra Fereej Al Manaseer Bu Sidra Muaither Al Sailiya Al Mearad',
    'Fereej Al Asiri New Fereej Al Khulaifat Bu Samra Al Mamoura Abu Hamour Mesaimeer Ain Khaled',
    'Mebaireek',
    'Al Karaana',
    'Abu Samra',
    'Sawda Natheel',
    'Jabal Thuaileb Al Kharayej Lusail Al Egla Wadi Al Banat',
    'Leabaib Al Ebb Jeryan Jenaihat Al Kheesa Rawdat Al Hamama Wadi Al Wasaah Al Sakhama Al Masrouhiya Wadi Lusail Lusail Umm Qarn Al Daayen',
    'Bu Fasseela Izghawa Al Kharaitiyat Umm Salal Ali Umm Salal Mohammed Saina Al-Humaidi Umm Al Amad Umm Ebairiya',
    'Simaisma Al Jeryan Al Khor City',
    'Al Thakhira Ras Laffan Umm Birka',
    'Al Ghuwariyah',
    'Ain Sinan Madinat Al Kaaban Fuwayrit',
    'Abu Dhalouf Zubarah',
    "Madinat ash Shamal Ar Ru'ays",
    'Al Utouriya',
    'Al Jemailiya',
    'Al-Shahaniya City',
    'Rawdat Rashed',
    'Umm Bab',
    'Al Nasraniya',
    'Dukhan',
    'Al Wakrah',
    'Al Thumama Al Wukair Al Mashaf',
    'Mesaieed',
    'Mesaieed Industrial Area',
    'Shagra',
    'Al Kharrara',
    'Khawr al Udayd',
  ].obs;
  List<String> filteredListOfQatarZones = [
    'Al Jasrah',
    'Al Bidda',
    'Fereej Mohamed Bin Jasim Mushayrib',
    'Mushayrib',
    'Al Najada  Barahat Al Jufairi Fereej Al Asmakh',
    'Old Al Ghanim',
    'Al Souq',
    'Wadi Al Sail',
    'Rumeilah',
    'Al Bidda',
    'Mushayrib',
    'Fereej Abdel Aziz',
    'Ad Dawhah al Jadidah',
    'Old Al Ghanim',
    'Al Rufaa Old Al Hitmi',
    'As Salatah Al Mirqab',
    'Doha Port',
    'Wadi Al Sail',
    'Rumeilah',
    'Fereej Bin Mahmoud',
    'Rawdat Al Khail',
    'Fereej Bin Durham Al Mansoura',
    'Najma',
    'Umm Ghuwailina',
    'Al Khulaifat Ras Abu Aboud',
    'Duhail',
    'Umm Lekhba',
    'Madinat Khalifa North Dahl Al Hamam',
    'Al Markhiya',
    'Madinat Khalifa South',
    'Fereej Kulaib',
    'Al Messila',
    'Fereej Bin Omran New Al Hitmi Hamad Medical City',
    'Al Sadd',
    'Al Sadd New Al Mirqab Fereej Al Nasr',
    'New Salatah',
    'Nuaija',
    'Al Hilal',
    'Nuaija',
    'Old Airport',
    'Al Thumama',
    'Doha International Airport',
    'Zone 50',
    'Industrial Area',
    'Zone 58',
    'Al Dafna Al Qassar',
    'Onaiza',
    'Lejbailat',
    'Onaiza Leqtaifiya Al Qassar',
    'Hazm Al Markhiya',
    'Jelaiah Al Tarfa Jeryan Nejaima',
    'Al Gharrafa Gharrafat Al Rayyan Izghawa Bani Hajer Al Seej Rawdat Egdaim Al Themaid',
    'Al Luqta Lebday Old Al Rayyan Al Shagub Fereej Al Zaeem',
    'New Al Rayyan Al Wajbah Muaither',
    'Fereej Al Amir Luaib Muraikh Baaya Mehairja Fereej Al Soudan',
    'Fereej Al Soudan Al Waab Al Aziziya New Fereej Al Ghanim Fereej Al Murra Fereej Al Manaseer Bu Sidra Muaither Al Sailiya Al Mearad',
    'Fereej Al Asiri New Fereej Al Khulaifat Bu Samra Al Mamoura Abu Hamour Mesaimeer Ain Khaled',
    'Mebaireek',
    'Al Karaana',
    'Abu Samra',
    'Sawda Natheel',
    'Jabal Thuaileb Al Kharayej Lusail Al Egla Wadi Al Banat',
    'Leabaib Al Ebb Jeryan Jenaihat Al Kheesa Rawdat Al Hamama Wadi Al Wasaah Al Sakhama Al Masrouhiya Wadi Lusail Lusail Umm Qarn Al Daayen',
    'Bu Fasseela Izghawa Al Kharaitiyat Umm Salal Ali Umm Salal Mohammed Saina Al-Humaidi Umm Al Amad Umm Ebairiya',
    'Simaisma Al Jeryan Al Khor City',
    'Al Thakhira Ras Laffan Umm Birka',
    'Al Ghuwariyah',
    'Ain Sinan Madinat Al Kaaban Fuwayrit',
    'Abu Dhalouf Zubarah',
    "Madinat ash Shamal Ar Ru'ays",
    'Al Utouriya',
    'Al Jemailiya',
    'Al-Shahaniya City',
    'Rawdat Rashed',
    'Umm Bab',
    'Al Nasraniya',
    'Dukhan',
    'Al Wakrah',
    'Al Thumama Al Wukair Al Mashaf',
    'Mesaieed',
    'Mesaieed Industrial Area',
    'Shagra',
    'Al Kharrara',
    'Khawr al Udayd',
  ].obs;
  var selectedQatarZone = 'Location'.obs;

  var selectedQatarZoneError = false.obs;

  Future loginUser(BuildContext context, String phoneNumber,
      {bool showLoading = true}) async {
    print(aService);
    if (showLoading) {
      LoadingWidget(context).showProgressIndicator();
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        // phoneNumber: '+974$phoneNumber',
        phoneNumber: '+923124883748',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) async {
          LoadingWidget(context).hideProgressIndicator();
          print('I am in verificationFailed');

          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }

          await GenericErrorDialog.show(context, e.message.toString());

          print(e);

          // Handle other errors
        },
        codeSent: (String verificationId, int? resendToken) async {
          CacheManager().verificationId = verificationId;
          LoadingWidget(context).hideProgressIndicator();
          Get.off(OTPScreen(
            comingFromLoginScreen: true,
            phoneNumber: phoneNumber,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseException catch (e) {
      print(e);
      LoadingWidget(context).hideProgressIndicator();
      FocusManager.instance.primaryFocus?.unfocus();
      if (e.code == 'user-not-found') {
        await GenericErrorDialog.show(context, 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        await GenericErrorDialog.show(
            context, 'Wrong password provided for that user');
        print('Wrong password provided for that user.');
      }
    } on Exception catch (e) {
      print(e);
      LoadingWidget(context).hideProgressIndicator();
      FocusManager.instance.primaryFocus?.unfocus();
      await GenericErrorDialog.show(context, 'Some Error Occurred');
    }
  }

  Future registerUser(BuildContext context, {bool fromLogin = false}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    print('Phone number: +974${CacheManager().registerModel.phoneNumber}');

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '++974${CacheManager().registerModel.phoneNumber}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) async {
        print('I am in verificationFailed');
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        //await GenericErrorDialog.show(context, e.message.toString());

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
        ));

        print(e);

        // Handle other errors
      },
      codeSent: (String verificationId, int? resendToken) async {
        CacheManager().verificationId = verificationId;
        Get.off(OTPScreen(
          comingFromLoginScreen: fromLogin,
          phoneNumber: CacheManager().registerModel.phoneNumber!,
        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future verifyOTP(BuildContext context, String email, String otp) async {
    try {
      await aService?.verifyOTP(
        context,
        (
          isSuccess,
          responseCode,
          responseDesc,
          parsedJson,
        ) {
          if (isSuccess) {
            print('OTP verified Successfully');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()),
            );
          }
        },
        email,
        otp,
      );
    } catch (_) {
      debugPrint('loginUser - onCatch error ');
    }
  }

  Future getCountries(BuildContext context, {bool loginFlow = false}) async {
    try {
      await aService?.getCountries(
        context,
        (
          isSuccess,
          responseCode,
          responseDesc,
          parsedJson,
        ) {
          if (isSuccess) {
            selectedCountry.value = 'United States';
            selectedPosition.value = 'Pilot in Command';
            // listOfCountries.clear();
            // filteredListOfCountries.clear();
            // List<dynamic> parsedListJson = parsedJson as List;
            // listOfCountries = List<CountryModel>.from(
            //     parsedListJson.map((i) => CountryModel.fromJson(i)));
            // filteredListOfCountries = List<CountryModel>.from(
            //     parsedListJson.map((i) => CountryModel.fromJson(i)));

            if (loginFlow) {
              //Get.to(Dashboard());
            }
          }
        },
      );
    } catch (_) {
      debugPrint('getBranches - onCatch error ');
    }
  }

  Future getCrewTypes(BuildContext context) async {
    try {
      await aService?.getCrewTypes(
        context,
        (
          isSuccess,
          responseCode,
          responseDesc,
          parsedJson,
        ) {
          if (isSuccess) {
            // listOfCrewTypes.clear();
            // filteredListOfCrewTypes.clear();
            // List<dynamic> parsedListJson = parsedJson as List;
            // listOfCrewTypes = List<CrewTypeModel>.from(
            //     parsedListJson.map((i) => CrewTypeModel.fromJson(i)));
            // filteredListOfCrewTypes = List<CrewTypeModel>.from(
            //     parsedListJson.map((i) => CrewTypeModel.fromJson(i)));
            // selectedPosition.value = filteredListOfCrewTypes[0].name!;
            isApiDataFetched.value = true;
            update();

            getCountries(context);
          }
        },
      );
    } catch (_) {
      debugPrint('getBranches - onCatch error ');
    }
  }
}
