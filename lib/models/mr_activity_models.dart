import 'package:freezed_annotation/freezed_annotation.dart';

part 'mr_activity_models.freezed.dart';
part 'mr_activity_models.g.dart';

@freezed
class MRProfile with _$MRProfile {
  const factory MRProfile({
    required String userId,
    required String name,
    required String email,
  }) = _MRProfile;

  factory MRProfile.fromJson(Map<String, dynamic> json) => _$MRProfileFromJson(json);
  
  @override

  String get email => throw UnimplementedError();
  
  @override

  String get name => throw UnimplementedError();
  
  @override
  Map<String, dynamic> toJson() {
    
    throw UnimplementedError();
  }
  
  @override
  String get userId => throw UnimplementedError();
}

@freezed
abstract class UpcomingVisit with _$UpcomingVisit {
  const factory UpcomingVisit({
    required String id,
    required String nextVisitDate,
    String? nextVisitObjective,
    required String doctorName,
    required String doctorSpecialty,
    required String doctorTier,
    required String doctorAddress,
    required String mrName,
    required String mrUserId,
    String? lastVisitDate,
  }) = _UpcomingVisit;

  factory UpcomingVisit.fromJson(Map<String, dynamic> json) => _$UpcomingVisitFromJson(json);
}

@freezed
abstract class MRStats with _$MRStats {
  const factory MRStats({
    required String mrUserId,
    required String mrName,
    required int totalDoctors,
    required int visitsThisMonth,
    required int visitsLastMonth,
    required int aTierVisits,
    required int bTierVisits,
    required int cTierVisits,
    required double avgVisitsPerDoctor,
    required int neglectedDoctors,
  }) = _MRStats;

  factory MRStats.fromJson(Map<String, dynamic> json) => _$MRStatsFromJson(json);
}

@freezed
abstract class NeglectedDoctor with _$NeglectedDoctor {
  const factory NeglectedDoctor({
    required String id,
    required String fullName,
    required String specialty,
    required String tier,
    required String clinicAddress,
    required String mrName,
    String? lastVisitDate,
    int? daysSinceVisit,
  }) = _NeglectedDoctor;

  factory NeglectedDoctor.fromJson(Map<String, dynamic> json) => _$NeglectedDoctorFromJson(json);
}

@freezed
abstract class MRActivityFilters with _$MRActivityFilters {
  const factory MRActivityFilters({
    String? selectedMR,
    String? selectedPeriod,
  }) = _MRActivityFilters;

  factory MRActivityFilters.fromJson(Map<String, dynamic> json) => _$MRActivityFiltersFromJson(json);
}

@freezed
abstract class TierDistribution with _$TierDistribution {
  const factory TierDistribution({
    required String tier,
    required int totalVisits,
    required double percentage,
  }) = _TierDistribution;

  factory TierDistribution.fromJson(Map<String, dynamic> json) => _$TierDistributionFromJson(json);
}

@freezed
abstract class StrategicRecommendation with _$StrategicRecommendation {
  const factory StrategicRecommendation({
    required String type, // 'error', 'warning', 'info'
    required String message,
    required String mrUserId,
  }) = _StrategicRecommendation;

  factory StrategicRecommendation.fromJson(Map<String, dynamic> json) => _$StrategicRecommendationFromJson(json);
}