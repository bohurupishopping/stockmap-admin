// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mr_activity_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MRProfile _$MRProfileFromJson(Map<String, dynamic> json) => _MRProfile(
  userId: json['userId'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$MRProfileToJson(_MRProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
    };

_UpcomingVisit _$UpcomingVisitFromJson(Map<String, dynamic> json) =>
    _UpcomingVisit(
      id: json['id'] as String,
      nextVisitDate: json['nextVisitDate'] as String,
      nextVisitObjective: json['nextVisitObjective'] as String?,
      doctorName: json['doctorName'] as String,
      doctorSpecialty: json['doctorSpecialty'] as String,
      doctorTier: json['doctorTier'] as String,
      doctorAddress: json['doctorAddress'] as String,
      mrName: json['mrName'] as String,
      mrUserId: json['mrUserId'] as String,
      lastVisitDate: json['lastVisitDate'] as String?,
    );

Map<String, dynamic> _$UpcomingVisitToJson(_UpcomingVisit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nextVisitDate': instance.nextVisitDate,
      'nextVisitObjective': instance.nextVisitObjective,
      'doctorName': instance.doctorName,
      'doctorSpecialty': instance.doctorSpecialty,
      'doctorTier': instance.doctorTier,
      'doctorAddress': instance.doctorAddress,
      'mrName': instance.mrName,
      'mrUserId': instance.mrUserId,
      'lastVisitDate': instance.lastVisitDate,
    };

_MRStats _$MRStatsFromJson(Map<String, dynamic> json) => _MRStats(
  mrUserId: json['mrUserId'] as String,
  mrName: json['mrName'] as String,
  totalDoctors: (json['totalDoctors'] as num).toInt(),
  visitsThisMonth: (json['visitsThisMonth'] as num).toInt(),
  visitsLastMonth: (json['visitsLastMonth'] as num).toInt(),
  aTierVisits: (json['aTierVisits'] as num).toInt(),
  bTierVisits: (json['bTierVisits'] as num).toInt(),
  cTierVisits: (json['cTierVisits'] as num).toInt(),
  avgVisitsPerDoctor: (json['avgVisitsPerDoctor'] as num).toDouble(),
  neglectedDoctors: (json['neglectedDoctors'] as num).toInt(),
);

Map<String, dynamic> _$MRStatsToJson(_MRStats instance) => <String, dynamic>{
  'mrUserId': instance.mrUserId,
  'mrName': instance.mrName,
  'totalDoctors': instance.totalDoctors,
  'visitsThisMonth': instance.visitsThisMonth,
  'visitsLastMonth': instance.visitsLastMonth,
  'aTierVisits': instance.aTierVisits,
  'bTierVisits': instance.bTierVisits,
  'cTierVisits': instance.cTierVisits,
  'avgVisitsPerDoctor': instance.avgVisitsPerDoctor,
  'neglectedDoctors': instance.neglectedDoctors,
};

_NeglectedDoctor _$NeglectedDoctorFromJson(Map<String, dynamic> json) =>
    _NeglectedDoctor(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      specialty: json['specialty'] as String,
      tier: json['tier'] as String,
      clinicAddress: json['clinicAddress'] as String,
      mrName: json['mrName'] as String,
      lastVisitDate: json['lastVisitDate'] as String?,
      daysSinceVisit: (json['daysSinceVisit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NeglectedDoctorToJson(_NeglectedDoctor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'specialty': instance.specialty,
      'tier': instance.tier,
      'clinicAddress': instance.clinicAddress,
      'mrName': instance.mrName,
      'lastVisitDate': instance.lastVisitDate,
      'daysSinceVisit': instance.daysSinceVisit,
    };

_MRActivityFilters _$MRActivityFiltersFromJson(Map<String, dynamic> json) =>
    _MRActivityFilters(
      selectedMR: json['selectedMR'] as String?,
      selectedPeriod: json['selectedPeriod'] as String?,
    );

Map<String, dynamic> _$MRActivityFiltersToJson(_MRActivityFilters instance) =>
    <String, dynamic>{
      'selectedMR': instance.selectedMR,
      'selectedPeriod': instance.selectedPeriod,
    };

_TierDistribution _$TierDistributionFromJson(Map<String, dynamic> json) =>
    _TierDistribution(
      tier: json['tier'] as String,
      totalVisits: (json['totalVisits'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$TierDistributionToJson(_TierDistribution instance) =>
    <String, dynamic>{
      'tier': instance.tier,
      'totalVisits': instance.totalVisits,
      'percentage': instance.percentage,
    };

_StrategicRecommendation _$StrategicRecommendationFromJson(
  Map<String, dynamic> json,
) => _StrategicRecommendation(
  type: json['type'] as String,
  message: json['message'] as String,
  mrUserId: json['mrUserId'] as String,
);

Map<String, dynamic> _$StrategicRecommendationToJson(
  _StrategicRecommendation instance,
) => <String, dynamic>{
  'type': instance.type,
  'message': instance.message,
  'mrUserId': instance.mrUserId,
};

_MRVisitLog _$MRVisitLogFromJson(Map<String, dynamic> json) => _MRVisitLog(
  id: json['id'] as String,
  mrUserId: json['mr_user_id'] as String,
  doctorId: json['doctor_id'] as String,
  visitDate: DateTime.parse(json['visit_date'] as String),
  productsDetailed: json['products_detailed'] as String?,
  feedbackReceived: json['feedback_received'] as String?,
  samplesProvided: json['samples_provided'] as String?,
  competitorActivityNotes: json['competitor_activity_notes'] as String?,
  prescriptionPotentialNotes: json['prescription_potential_notes'] as String?,
  nextVisitDate: json['next_visit_date'] == null
      ? null
      : DateTime.parse(json['next_visit_date'] as String),
  nextVisitObjective: json['next_visit_objective'] as String?,
  linkedSaleOrderId: json['linked_sale_order_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  isLocationVerified: json['is_location_verified'] as bool?,
  distanceFromClinicMeters: (json['distance_from_clinic_meters'] as num?)
      ?.toDouble(),
  clinicId: json['clinic_id'] as String?,
  mrName: _mrNameFromProfile(json['profiles'] as Map<String, dynamic>?),
);

Map<String, dynamic> _$MRVisitLogToJson(_MRVisitLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mr_user_id': instance.mrUserId,
      'doctor_id': instance.doctorId,
      'visit_date': instance.visitDate.toIso8601String(),
      'products_detailed': instance.productsDetailed,
      'feedback_received': instance.feedbackReceived,
      'samples_provided': instance.samplesProvided,
      'competitor_activity_notes': instance.competitorActivityNotes,
      'prescription_potential_notes': instance.prescriptionPotentialNotes,
      'next_visit_date': instance.nextVisitDate?.toIso8601String(),
      'next_visit_objective': instance.nextVisitObjective,
      'linked_sale_order_id': instance.linkedSaleOrderId,
      'created_at': instance.createdAt.toIso8601String(),
      'is_location_verified': instance.isLocationVerified,
      'distance_from_clinic_meters': instance.distanceFromClinicMeters,
      'clinic_id': instance.clinicId,
    };
