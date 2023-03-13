// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
//       userEmail: json['userEmail'] as String,
//       properties: (json['properties'] as List<dynamic>)
//           .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      postedBy: json['postedBy'] != null ? json['postedBy'] as String : '',
      apartmentType: json['apartmentType'] as String,
      rank: json['rank'] != null ? json['rank'] as int : 0,
      propertyBedrooms: json['propertyBedrooms'] as String,
      propertyBathrooms: json['propertyBathrooms'] as String,
      userId: json['userId'] as String,
      propertyFurnish: json['propertyFurnish'] as String,
      propertyImages: (json['propertyImages'] != null
          ? json['propertyImages'] as List<dynamic>
          : []),
      immunities:
          Immunities.fromJson(json['immunities'] as Map<String, dynamic>),
      depositDropDown: json['depositDropDown'] as String,
      commission: json['commission'] as String,
      rentalPeriod: json['rentalPeriod'] as String,
      price: json['price'] as String,
      propertyLocation: json['location'] as String,
      adTitle: json['adTitle'] as String,
      adDescription: json['adDescription'] as String,
      contractDuration: json['contractDuration'] as String,
      email: json['email'] != null ? json['email'] as String : '',
      comment: json['comment'] != null ? json['comment'] as String : '',
      id: json['id'] != null ? json['id'] as int : 0,
      docId: json['docId'] != null ? json['docId'] as String : '0',
      currentIndex: 0,
      viewCount: json['viewCount'] != null ? json['viewCount'] as int : 0,
      adEnabled: json['adEnabled'] != null ? json['adEnabled'] as bool : true,
      favorite: json['favorite'] != null ? json['favorite'] as bool : false,
      phoneNumber:
          json['phoneNumber'] != null ? json['phoneNumber'] as String : '',
      location: json['location'] != null ? json['location'] as String : '',
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'apartmentType': instance.apartmentType,
      'propertyBedrooms': instance.propertyBedrooms,
      'propertyBathrooms': instance.propertyBathrooms,
      'propertyFurnish': instance.propertyFurnish,
      'immunities': instance.immunities,
      'depositDropDown': instance.depositDropDown,
      'commission': instance.commission,
      'rentalPeriod': instance.rentalPeriod,
      'price': instance.price,
      'propertyLocation': instance.propertyLocation,
      'adTitle': instance.adTitle,
      'adDescription': instance.adDescription,
      'contractDuration': instance.contractDuration,
    };

Immunities _$ImmunitiesFromJson(Map<String, dynamic> json) => Immunities(
      acSplit: json['acSplit'] as bool,
      acWindow: json['acWindow'] as bool,
      kitchenOpen: json['kitchenOpen'] as bool,
      centralAc: json['centralAc'] != null ? json['centralAc'] as bool : false,
      kitchenSeparate: json['kitchenSeparate'] as bool,
      parking: json['parking'] as bool,
      seaView: json['seaView'] as bool,
      gardenView: json['gardenView'] as bool,
      maidRoom: json['maidRoom'] as bool,
    );

Map<String, dynamic> _$ImmunitiesToJson(Immunities instance) =>
    <String, dynamic>{
      'acSplit': instance.acSplit,
      'acWindow': instance.acWindow,
      'centralAc': instance.centralAc,
      'kitchenOpen': instance.kitchenOpen,
      'kitchenSeparate': instance.kitchenSeparate,
      'parking': instance.parking,
      'seaView': instance.seaView,
      'gardenView': instance.gardenView,
      'maidRoom': instance.maidRoom,
    };

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      properties: json['properties'] != null
          ? (json['properties'] as List<dynamic>)
              .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
