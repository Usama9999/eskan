import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'property_model.g.dart';

@JsonSerializable()
class Property {
  late List<PropertyModel> properties = [];

  Property({required this.properties});

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PropertyToJson(this);

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);

  factory Property.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    try {
      final data = snapshot.data();
      print(data);
      return Property(
        properties: (data!['properties'] != null
                ? data['properties'] as List<dynamic>
                : [])
            .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on Exception catch (_, e) {
      //LoadingWidget(context).hideProgressIndicator();
    }
    return Property(properties: []);
  }

  Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
        'properties': firestorePropeties(),
      };

  List<Map<String, dynamic>> firestorePropeties() {
    List<Map<String, dynamic>> convertedProperties = [];
    properties.forEach((set) {
      PropertyModel thisSet = set as PropertyModel;
      convertedProperties.add(thisSet.toJson());
    });
    return convertedProperties;
  }
}

@JsonSerializable()
class PropertyModel {
  late String apartmentType;
  late String propertyBedrooms;
  late String propertyBathrooms;
  late String propertyFurnish;
  late Immunities immunities;
  late String depositDropDown;
  late String commission;
  late String rentalPeriod;
  late String price;
  late String propertyLocation;
  late String adTitle;
  late String adDescription;
  late String contractDuration;
  late String postedBy;
  late String phoneNumber;
  late String location;
  late List<dynamic> propertyImages;
  late String email;
  late int id;
  late int viewCount;
  late String? docId;
  String comment;
  String userId;
  int currentIndex;
  bool adEnabled;
  bool approved;
  bool favorite;
  int rank;

  PropertyModel(
      {required this.apartmentType,
      required this.propertyBedrooms,
      required this.propertyBathrooms,
      required this.propertyFurnish,
      required this.immunities,
      required this.postedBy,
      required this.depositDropDown,
      required this.commission,
      required this.rentalPeriod,
      required this.price,
      required this.userId,
      this.viewCount = 0,
      this.phoneNumber = '',
      this.location = '',
      this.rank = 0,
      this.comment = '',
      this.email = '',
      this.id = 0,
      this.docId = '',
      this.favorite = false,
      this.approved = false,
      this.adEnabled = true,
      required this.propertyLocation,
      required this.adTitle,
      required this.adDescription,
      required this.contractDuration,
      this.currentIndex = 0,
      required this.propertyImages});

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  List<String> addImages() {
    List<String> myImages = <String>[];
    propertyImages.forEach((img) {
      myImages.add(img);
    });
    return myImages;
  }

  Map<String, dynamic> _$PropertyModelToJson(instance) => <String, dynamic>{
        'apartmentType': instance.apartmentType,
        'docId': instance.docId,
        'propertyBedrooms': instance.propertyBedrooms,
        'propertyBathrooms': instance.propertyBathrooms,
        'propertyFurnish': instance.propertyFurnish,
        'immunities': immunities.toJson(),
        'propertyImages': addImages(),
        'depositDropDown': instance.depositDropDown,
        'commission': instance.commission,
        'rank': instance.rank,
        'userId': instance.userId,
        'approved': instance.approved,
        'rentalPeriod': instance.rentalPeriod,
        'price': instance.price,
        'propertyLocation': instance.propertyLocation,
        'adTitle': instance.adTitle,
        'postedBy': instance.postedBy,
        'adDescription': instance.adDescription,
        'contractDuration': instance.contractDuration,
        'email': instance.email,
        'adEnabled': instance.adEnabled,
        'id': instance.id,
        'comment': instance.comment,
        'favorite': instance.favorite,
        'phoneNumber': instance.phoneNumber,
        'location': instance.location,
        'viewCount': instance.viewCount,
      };

  // /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  // Map<String, dynamic> toJson() => _$PropertyModelToJson(this);
}

@JsonSerializable()
class Immunities {
  late bool acSplit;
  late bool acWindow;
  late bool kitchenOpen;
  late bool kitchenSeparate;
  late bool parking;
  late bool seaView;
  late bool gardenView;
  late bool maidRoom;
  late bool centralAc;

  Immunities(
      {required this.acSplit,
      required this.acWindow,
      required this.kitchenOpen,
      required this.centralAc,
      required this.kitchenSeparate,
      required this.parking,
      required this.seaView,
      required this.gardenView,
      required this.maidRoom});

  factory Immunities.fromJson(Map<String, dynamic> json) =>
      _$ImmunitiesFromJson(json);

  Map<String, dynamic> toJson() => _$ImmunitiesToJson(this);
}
