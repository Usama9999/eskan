import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eskan/cache/cache_manager.dart';
import 'package:eskan/firebase/login_data.dart';
import 'package:eskan/root/auth/model/register_model.dart';
import 'package:eskan/root/auth/screens/admin_panel.dart';
import 'package:eskan/root/bindings/home_bindings.dart';
import 'package:eskan/root/main/model/property_model.dart';
import 'package:eskan/root/main/screens/property_details.dart';
import 'package:eskan/widget/alert.dart';
import 'package:eskan/widget/loading_widget/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../root/main/controller/main_controller.dart';
import '../root/main/screens/dashboard.dart';
import '../widget/popup_widget/generic_error_dialog.dart';

class DataRepository {
  MainController mainController = Get.put(MainController());
  // 1
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user');

  var db = FirebaseFirestore.instance;

  final CollectionReference addPropertyCollection =
      FirebaseFirestore.instance.collection('property');

  final CollectionReference apartmentPropertyCollection =
      FirebaseFirestore.instance.collection('apartment');

  final CollectionReference addFavoriteCollection =
      FirebaseFirestore.instance.collection('favorite');
  // 2
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  // 3
  Future<void> addUser(RegisterRequestModel user) {
    return collection.doc(user.id).set(user.toJson());
  }

  Future<void> getLoginData(BuildContext context) async {
    try {
      final ref =
          db.collection('user').doc(FirebaseAuth.instance.currentUser!.uid);
      final docSnap = await ref.get();

      if (docSnap.exists) {
        RegisterRequestModel user = RegisterRequestModel.fromFirestore(docSnap);
        if (user.admin) {
          log('admin');
          Get.find<UserDetail>()
              .setData(user, isAdmin: true, isLogin: CacheManager().rememberMe);
          Get.offAll(() => AdminDashboardScreen(), binding: HomeBindings());
        } else if (user.enabledUser) {
          log('verified');
          Get.find<UserDetail>()
              .setData(user, isLogin: CacheManager().rememberMe);
          Get.find<UserDetail>().getData();
          Get.offAll(() => DashboardScreen(), binding: HomeBindings());
        } else {
          log('not verified');
          showCustomAlertInfo(
              context: Get.overlayContext!,
              strTitle: 'Under review',
              strMessage:
                  'Your account is in approval phase. An admin will approve your account and then you can login');
        }
      } else {
        // ignore: use_build_context_synchronously

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No such user exists'),
        ));
        //GenericErrorDialog.show(context, 'No such user exists');
      }

      // ignore: non_constant_identifier_names
    } on Exception catch (_, e) {}
  }

  Future<void> addProperty(BuildContext context, PropertyModel property) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      FirebaseFirestore.instance
          .collection('properties')
          .add(property.toJson())
          .then((value) {
        LoadingWidget(context).hideProgressIndicator();
        showCustomAlertInfo(
          context: Get.overlayContext!,
          strTitle: 'Request submitted',
          strMessage:
              'Your request is submitted and is under review. Please wait until we approve your request',
          strRightBtnText: 'Yes',
        );
      });
    } catch (e) {
      LoadingWidget(context).hideProgressIndicator();
    }
  }

  Future<void> addFavorite(BuildContext context, PropertyModel property) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      log(property.docId!);
      FirebaseFirestore.instance
          .collection('properties')
          .doc(property.docId!)
          .update({
        'favourites': FieldValue.arrayUnion([Get.find<UserDetail>().userId])
      });
      mainController.filteredAllProperties
          .where((element) => element.docId == property.docId!)
          .first
          .favorite = true;
      mainController.allProperties
          .where((element) => element.docId == property.docId)
          .first
          .favorite = true;
      mainController.update();
      LoadingWidget(context).hideProgressIndicator();
      return;
    } on Exception catch (_, e) {
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> removeFavorite(BuildContext context, PropertyModel property,
      MainController mainController) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      FirebaseFirestore.instance
          .collection('properties')
          .doc(property.docId!)
          .update({
        'favourites': FieldValue.arrayRemove([Get.find<UserDetail>().userId])
      });
      mainController.filteredAllProperties
          .where((element) => element.docId == property.docId!)
          .first
          .favorite = false;
      mainController.allProperties
          .where((element) => element.docId == property.docId)
          .first
          .favorite = false;
      mainController.update();
      LoadingWidget(context).hideProgressIndicator();
      return;
    } on Exception catch (_, e) {
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> approved(BuildContext context, PropertyModel property,
      String propertyType, String comment) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      FirebaseFirestore.instance
          .collection('properties')
          .doc(property.docId!)
          .update({'approved': true});

      property.adEnabled = false;

      mainController.update();

      LoadingWidget(context).hideProgressIndicator();
    } on Exception catch (_, e) {
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> unapproved(BuildContext context, PropertyModel property,
      String propertyType, String comment) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      FirebaseFirestore.instance
          .collection('properties')
          .doc(property.docId!)
          .update({'approved': false});

      property.adEnabled = false;

      mainController.update();

      LoadingWidget(context).hideProgressIndicator();
    } on Exception catch (_, e) {
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> disableAd(BuildContext context, PropertyModel property,
      String propertyType, String comment) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      FirebaseFirestore.instance
          .collection('properties')
          .doc(property.docId!)
          .update({'adEnabled': false});

      property.adEnabled = false;

      mainController.update();

      LoadingWidget(context).hideProgressIndicator();
    } on Exception catch (_, e) {
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> enableAd(BuildContext context, PropertyModel property,
      String propertyType, String comment) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      FirebaseFirestore.instance
          .collection('properties')
          .doc(property.docId!)
          .update({'adEnabled': true});

      property.adEnabled = true;

      mainController.update();
      LoadingWidget(context).hideProgressIndicator();
      return;
    } on Exception catch (_, e) {
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> deleteAd(
      BuildContext context, PropertyModel property, String propertyType) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      FirebaseFirestore.instance
          .collection('properties')
          .doc(property.docId!)
          .delete();
      mainController.properties.properties
          .removeWhere((element) => element.docId == property.docId);
      mainController.propertiesList.properties
          .removeWhere((element) => element.docId == property.docId);
      mainController.update();
      LoadingWidget(context).hideProgressIndicator();
    } on Exception catch (_, e) {
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> updateAdCount(BuildContext context, PropertyModel property,
      String propertyType, int count) async {
    try {
      List<PropertyModel> allProperties = <PropertyModel>[];

      print('sds');

      await db.collection(propertyType).get().then((querySnapshot) => {
            querySnapshot.docs.forEach((element) {
              print(element.id);
              PropertyModel propertyModel =
                  PropertyModel.fromJson(element.data());
              propertyModel.docId = element.id;
              allProperties.add(propertyModel);
            })
          });

      print('DocID: ${allProperties[0].docId}');

      int selectedIndex = 0;
      for (int i = 0; i < allProperties.length; i++) {
        if (allProperties[i].id == property.id &&
            allProperties[i].phoneNumber == property.phoneNumber) {
          selectedIndex = i;
          allProperties[i].viewCount = count;
        }
      }

      print('SelectedDocId:  ${allProperties[selectedIndex].docId}');
      //
      db
          .collection(propertyType)
          .doc(allProperties[selectedIndex].docId)
          .update({'viewCount': count});

      // final ref = db.collection(propertyType).doc(property.email).withConverter(
      //       fromFirestore: Property.fromFirestore,
      //       toFirestore: (Property property, _) =>
      //           Property(properties: []).toJson(),
      //     );
      // final docSnap = await ref.get();
      //
      // if (docSnap.data() != null) {
      //   mainController.propertiesList= docSnap.data() as Property;
      //
      //   print("ID: ${property.email}");
      //   print(
      //       'Length Properties: ${mainController.propertiesList.value.properties.length}');
      //   for (int i = 0;
      //       i < mainController.propertiesList.value.properties.length;
      //       i++) {
      //     print("ID1: ${mainController.propertiesList.value.properties[i].id}");
      //     print("ID2: ${property.id}");
      //     if (mainController.propertiesList.value.properties[i].id ==
      //             property.id &&
      //         property.email ==
      //             mainController.propertiesList.value.properties[i].email) {
      //       print('updating count');
      //       mainController.propertiesList.value.properties[i].viewCount = count;
      //       break;
      //     }
      //   }
      //
      //   addPropertyCollection
      //       .doc(property.email)
      //       .set(mainController.propertiesList.toJson());
      // }

      return;
    } on Exception catch (_, e) {
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> favoriteAdd(BuildContext context, PropertyModel property) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      final ref =
          db.collection("property").doc(property.phoneNumber).withConverter(
                fromFirestore: Property.fromFirestore,
                toFirestore: (Property property, _) =>
                    Property(properties: []).toJson(),
              );
      final docSnap = await ref.get();

      if (docSnap.data() != null) {
        mainController.propertiesList = docSnap.data() as Property;
        print(
            "Length Properties: ${mainController.propertiesList.properties.length}");
        for (int i = 0;
            i < mainController.propertiesList.properties.length;
            i++) {
          if (mainController.propertiesList.properties[i].id == property.id) {
            mainController.propertiesList.properties[i].favorite =
                !mainController.propertiesList.properties[i].favorite;
            break;
          }
        }

        addPropertyCollection
            .doc(property.phoneNumber)
            .set(mainController.propertiesList.toJson());
      }

      LoadingWidget(context).hideProgressIndicator();
      return;
    } on Exception catch (_, e) {
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> disableUser(
      BuildContext context, RegisterRequestModel user, String comment) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      collection
          .doc(user.id)
          .update({'enabledUser': false, 'comment': comment});

      LoadingWidget(context).hideProgressIndicator();
      return;
    } on Exception catch (e) {
      print(e);
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> enableUser(
      BuildContext context, RegisterRequestModel user, String comment) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      collection.doc(user.id).update({'enabledUser': true, 'comment': comment});

      LoadingWidget(context).hideProgressIndicator();
      return;
    } on Exception catch (e) {
      print(e);
      LoadingWidget(context).hideProgressIndicator();
      await GenericErrorDialog.show(context, 'Some error occurred.');
    }
  }

  Future<void> getMyProperties(
      BuildContext context, MainController mainController) async {
    Future.delayed(Duration.zero, () async {
      LoadingWidget(context).showProgressIndicator();

      try {
        final ref = db.collection('properties');
        final docSnap = await ref
            .where('userId', isEqualTo: Get.find<UserDetail>().userId)
            .get();

        if (docSnap.docs.isNotEmpty) {
          List<PropertyModel> properties = [];
          for (var element in docSnap.docs) {
            PropertyModel property = PropertyModel.fromJson(element.data());
            property.docId = element.id;
            properties.add(property);
          }
          mainController.properties = Property(properties: properties);
          print(
              'Length Properties: ${mainController.properties.properties.length}');
          // ignore: unnecessary_null_comparison
          if (mainController.properties.properties.isEmpty) {
            mainController.hasDataCome.value = false;
          } else {
            mainController.hasDataCome.value = true;
          }
          mainController.update();
        }

        LoadingWidget(context).hideProgressIndicator();

        // ignore: non_constant_identifier_names
      } on Exception catch (_, e) {
        LoadingWidget(context).hideProgressIndicator();
      }
    });
  }

  Future<void> getMyFavoriteProperties(
      BuildContext context, MainController mainController) async {
    Future.delayed(Duration.zero, () async {
      try {
        // LoadingWidget(context).showProgressIndicator();

        mainController.properties.properties.clear();
        mainController.update();
        await db
            .collection('properties')
            .where('adEnabled', isEqualTo: true)
            .where('approved', isEqualTo: true)
            .where('favourites', arrayContains: Get.find<UserDetail>().userId)
            .get()
            .then((querySnapshot) {
          log(querySnapshot.docs.length.toString());
          List<PropertyModel> properties = [];
          for (var element in querySnapshot.docs) {
            List favs = element.data().containsKey('favourites')
                ? element['favourites'] as List
                : [];
            PropertyModel model = PropertyModel.fromJson(element.data());
            model.docId = element.id;
            model.favorite = favs.contains(Get.find<UserDetail>().userId);
            log(model.favorite.toString());
            properties.add(model);
          }
          mainController.properties.properties.addAll(properties);
          log(mainController.properties.properties.length.toString());
          mainController.hasDataCome.value = true;
        });

        mainController.update();

        // LoadingWidget(context).hideProgressIndicator();

        // ignore: non_constant_identifier_names
      } on Exception catch (_, e) {
        LoadingWidget(context).hideProgressIndicator();
      }
    });
  }

  Future<void> getAllUsers(BuildContext context) async {
    Future.delayed(Duration.zero, () async {
      LoadingWidget(context).showProgressIndicator();

      mainController.allUsers.clear();
      mainController.filteredAllUsers.clear();

      try {
        await db
            .collection('user')
            .where('admin', isEqualTo: false)
            .get()
            .then((querySnapshot) => {
                  querySnapshot.docs.forEach((element) {
                    mainController.allUsers
                        .add(RegisterRequestModel.fromFirestore(element));
                    mainController.filteredAllUsers
                        .add(RegisterRequestModel.fromFirestore(element));
                  })
                });

        mainController.isApiDataFetched.value = true;
        mainController.update();

        LoadingWidget(context).hideProgressIndicator();

        //print(allProperties[0].properties[0].adDescription);

        // ignore: non_constant_identifier_names
      } on Exception catch (_, e) {
        LoadingWidget(context).hideProgressIndicator();
      }
    });

    mainController.isApiDataFetched.value = true;
    mainController.update();
  }

  Future<void> getAllProperties(BuildContext context, String propertyType,
      {bool showLoading = true}) async {
    try {
      log(propertyType);
      mainController.allProperties.clear();
      mainController.filteredAllProperties.clear();
      mainController.update();
      log('intial log:' +
          mainController.filteredAllProperties.length.toString());
      await db
          .collection('properties')
          .where('adEnabled', isEqualTo: true)
          .where('approved', isEqualTo: true)
          .where('apartmentType', isEqualTo: propertyType)
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          List favs = element.data().containsKey('favourites')
              ? element['favourites'] as List
              : [];
          PropertyModel model = PropertyModel.fromJson(element.data());
          model.docId = element.id;
          model.favorite = favs.contains(Get.find<UserDetail>().userId);
          mainController.filteredAllProperties.add(model);
        }
        log('intial log:' +
            mainController.filteredAllProperties.length.toString());
        mainController.allProperties = mainController.filteredAllProperties;
      });

      // mainController.update();
    } on Exception catch (_, e) {
      if (showLoading) {
        LoadingWidget(context).hideProgressIndicator();
      }
    }
  }

  Future<void> getAllPendingProperties(
      BuildContext context, MainController mainController,
      {bool showLoading = true}) async {
    Future.delayed(Duration.zero, () async {
      try {
        mainController.pendingProperties.clear();
        mainController.update();
        await db
            .collection('properties')
            .where('approved', isEqualTo: false)
            .get()
            .then((querySnapshot) {
          for (var element in querySnapshot.docs) {
            PropertyModel model = PropertyModel.fromJson(element.data());
            model.docId = element.id;
            mainController.pendingProperties.add(model);
          }
        });
        mainController.update();
      } on Exception catch (_, e) {
        if (showLoading) {
          LoadingWidget(context).hideProgressIndicator();
        }
      }
    });

    mainController.update();
  }

  Future<void> getAllApprovedProperties(
      BuildContext context, MainController mainController,
      {bool showLoading = true}) async {
    Future.delayed(Duration.zero, () async {
      try {
        mainController.approvedProperties.clear();
        mainController.update();
        await db
            .collection('properties')
            .where('approved', isEqualTo: true)
            .get()
            .then((querySnapshot) {
          for (var element in querySnapshot.docs) {
            PropertyModel model = PropertyModel.fromJson(element.data());
            model.docId = element.id;
            mainController.approvedProperties.add(model);
          }
        });
        mainController.update();
      } on Exception catch (_, e) {
        if (showLoading) {
          LoadingWidget(context).hideProgressIndicator();
        }
      }
    });

    mainController.update();
  }

  Future<void> getAProperty(
      BuildContext context, String propertyType, String addId,
      {bool showLoading = true, bool closedAppShared = false}) async {
    Future.delayed(Duration.zero, () async {
      print('getAProperty');
      print('addId: $addId');
      try {
        await db.collection(propertyType).get().then((querySnapshot) => {
              querySnapshot.docs.forEach((element) {
                PropertyModel model = PropertyModel.fromJson(element.data());
                print("elementId: ${model.id.toString()}");
                if (model.id.toString() == addId) {
                  mainController.sharedAdd = model;
                }
              })
            });
        mainController.update();

        if (closedAppShared) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => DashboardScreen(
                        goToSharedAdd: true,
                      )));
        } else {
          Get.to(
              PropertyDetailsScreen(propertyModel: mainController.sharedAdd));
        }

        // ignore: non_constant_identifier_names
      } on Exception catch (_, e) {
        if (showLoading) {
          LoadingWidget(context).hideProgressIndicator();
        }
      }
    });

    mainController.update();
  }

  // Future<void> searchProperties(
  //     BuildContext context, String propertyType, String propertyTitle,
  //     {bool showLoading = true}) async {
  //   Future.delayed(Duration.zero, () async {
  //     // if (showLoading) {
  //     //   LoadingWidget(context).showProgressIndicator();
  //     // }

  //     // print('now: ${mainController.newAllProperties.length}');

  //     try {
  //       mainController.allProperties.clear();
  //       mainController.filteredAllProperties.clear();
  //       CacheManager().myProperties.clear();

  //       print('Searching a property');

  //       print('propertyType: $propertyType');
  //       print('propertyTitle: $propertyTitle');

  //       await db
  //           .collection(propertyType)
  //           .where('adTitle', isGreaterThan: propertyTitle)
  //           .get()
  //           .then((querySnapshot) => {
  //                 querySnapshot.docs.forEach((element) {
  //                   print(element.data());
  //                   if (CacheManager().phoneNumber !=
  //                           PropertyModel.fromJson(element.data())
  //                               .phoneNumber &&
  //                       PropertyModel.fromJson(element.data())
  //                           .adTitle
  //                           .contains(propertyTitle)) {
  //                     CacheManager().myProperties.add(element);
  //                     mainController.allProperties
  //                         .add(PropertyModel.fromJson(element.data()));
  //                     mainController.filteredAllProperties
  //                         .add(PropertyModel.fromJson(element.data()));
  //                   }
  //                 })
  //               });
  //       print('PROPERTIESLENGTH: ${mainController.allProperties.length}');

  //       // await db.collection("property").get().then((querySnapshot) => {
  //       //       querySnapshot.docs.forEach((element) {
  //       //         tempProperties.add(Property.fromJson(element.data()));
  //       //       })
  //       //     });
  //       //
  //       // if (CacheManager().userEmail == 'admin@gmail.com') {
  //       //   for (int i = 0; i < tempProperties.length; i++) {
  //       //     for (int j = 0; j < tempProperties[i].properties.length; j++) {
  //       //       mainController.allProperties.add(tempProperties[i].properties[j]);
  //       //       // mainController.filteredAllProperties
  //       //       //     .add(tempProperties[i].properties[j]);
  //       //     }
  //       //   }
  //       // } else {
  //       //   for (int i = 0; i < tempProperties.length; i++) {
  //       //     for (int j = 0; j < tempProperties[i].properties.length; j++) {
  //       //       if (tempProperties[i].properties[j].adEnabled &&
  //       //           CacheManager().userEmail !=
  //       //               tempProperties[i].properties[j].email) {
  //       //         mainController.allProperties
  //       //             .add(tempProperties[i].properties[j]);
  //       //         // mainController.filteredAllProperties
  //       //         //     .add(tempProperties[i].properties[j]);
  //       //       }
  //       //     }
  //       //   }
  //       // }
  //       //
  //       // print('len: ${mainController.allProperties.length}');
  //       //
  //       // mainController.filteredAllProperties.clear();
  //       // mainController.normalAllProperties.clear();
  //       // mainController.allProperties.forEach((element) {
  //       //   if (element.apartmentType ==
  //       //       mainController.mySelectedPropertyType.value) {
  //       //     mainController.filteredAllProperties.add(element);
  //       //     mainController.normalAllProperties.add(element);
  //       //   }
  //       // });

  //       mainController.update();

  //       // if (showLoading) {
  //       //   LoadingWidget(context).hideProgressIndicator();
  //       // }

  //       //print(allProperties[0].properties[0].adDescription);

  //       // ignore: non_constant_identifier_names
  //     } on Exception catch (_, e) {
  //       print(e);
  //       // if (showLoading) {
  //       //   LoadingWidget(context).hideProgressIndicator();
  //       // }
  //     }
  //   });

  //   mainController.update();
  // }

  // Future<void> paginateAllProperties(BuildContext context, String propertyType,
  //     {bool showLoading = true}) async {
  //   Future.delayed(Duration.zero, () async {
  //     // if (showLoading) {
  //     //   LoadingWidget(context).showProgressIndicator();
  //     // }

  //     List<Property> tempProperties = [];

  //     // print('now: ${mainController.newAllProperties.length}');

  //     print('IAMHEREBRO');

  //     try {
  //       if (CacheManager().phoneNumber == '11223344') {
  //         await db
  //             .collection(propertyType)
  //             // .where('adEnabled', isNotEqualTo: false)
  //             .orderBy('id', descending: true)
  //             .startAfterDocument(CacheManager()
  //                 .myProperties[CacheManager().myProperties.length - 1])
  //             .limit(3)
  //             .get()
  //             .then((querySnapshot) => {
  //                   querySnapshot.docs.forEach((element) {
  //                     CacheManager().myProperties.add(element);
  //                     mainController.allProperties
  //                         .add(PropertyModel.fromJson(element.data()));
  //                     mainController.filteredAllProperties
  //                         .add(PropertyModel.fromJson(element.data()));
  //                   })
  //                 });
  //       } else {
  //         await db
  //             .collection(propertyType)
  //             .orderBy('id', descending: true)
  //             .startAfterDocument(CacheManager()
  //                 .myProperties[CacheManager().myProperties.length - 1])
  //             .limit(3)
  //             .get()
  //             .then((querySnapshot) => {
  //                   querySnapshot.docs.forEach((element) {
  //                     print('IAMHEREBRO');
  //                     if (PropertyModel.fromJson(element.data()).adEnabled &&
  //                         CacheManager().phoneNumber !=
  //                             PropertyModel.fromJson(element.data())
  //                                 .phoneNumber) {
  //                       CacheManager().myProperties.add(element);
  //                       mainController.allProperties
  //                           .add(PropertyModel.fromJson(element.data()));
  //                       mainController.filteredAllProperties
  //                           .add(PropertyModel.fromJson(element.data()));
  //                     }
  //                   })
  //                 });
  //       }

  //       //
  //       // await db
  //       //     .collection(propertyType)
  //       //     .startAfterDocument(CacheManager()
  //       //         .myProperties[CacheManager().myProperties.length - 1])
  //       //     .limit(2)
  //       //     .get()
  //       //     .then((querySnapshot) => {
  //       //           querySnapshot.docs.forEach((element) {
  //       //             CacheManager().myProperties.add(element);
  //       //             mainController.allProperties
  //       //                 .add(PropertyModel.fromJson(element.data()));
  //       //             mainController.filteredAllProperties
  //       //                 .add(PropertyModel.fromJson(element.data()));
  //       //           })
  //       //         });

  //       print('Called getAllProperties');

  //       // await db.collection("property").get().then((querySnapshot) => {
  //       //       querySnapshot.docs.forEach((element) {
  //       //         tempProperties.add(Property.fromJson(element.data()));
  //       //       })
  //       //     });
  //       //
  //       // if (CacheManager().userEmail == 'admin@gmail.com') {
  //       //   for (int i = 0; i < tempProperties.length; i++) {
  //       //     for (int j = 0; j < tempProperties[i].properties.length; j++) {
  //       //       mainController.allProperties.add(tempProperties[i].properties[j]);
  //       //       // mainController.filteredAllProperties
  //       //       //     .add(tempProperties[i].properties[j]);
  //       //     }
  //       //   }
  //       // } else {
  //       //   for (int i = 0; i < tempProperties.length; i++) {
  //       //     for (int j = 0; j < tempProperties[i].properties.length; j++) {
  //       //       if (tempProperties[i].properties[j].adEnabled &&
  //       //           CacheManager().userEmail !=
  //       //               tempProperties[i].properties[j].email) {
  //       //         mainController.allProperties
  //       //             .add(tempProperties[i].properties[j]);
  //       //         // mainController.filteredAllProperties
  //       //         //     .add(tempProperties[i].properties[j]);
  //       //       }
  //       //     }
  //       //   }
  //       // }
  //       //
  //       // print('len: ${mainController.allProperties.length}');
  //       //
  //       // mainController.filteredAllProperties.clear();
  //       // mainController.normalAllProperties.clear();
  //       // mainController.allProperties.forEach((element) {
  //       //   if (element.apartmentType ==
  //       //       mainController.mySelectedPropertyType.value) {
  //       //     mainController.filteredAllProperties.add(element);
  //       //     mainController.normalAllProperties.add(element);
  //       //   }
  //       // });

  //       mainController.update();

  //       // if (showLoading) {
  //       //   LoadingWidget(context).hideProgressIndicator();
  //       // }

  //       //print(allProperties[0].properties[0].adDescription);

  //       // ignore: non_constant_identifier_names
  //     } on Exception catch (_, e) {
  //       if (showLoading) {
  //         LoadingWidget(context).hideProgressIndicator();
  //       }
  //     }
  //   });

  //   mainController.update();
  // }
}
