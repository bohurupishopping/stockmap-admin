// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mr_activity_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MRProfile {

 String get userId; String get name; String get email;
/// Create a copy of MRProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MRProfileCopyWith<MRProfile> get copyWith => _$MRProfileCopyWithImpl<MRProfile>(this as MRProfile, _$identity);

  /// Serializes this MRProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MRProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,email);

@override
String toString() {
  return 'MRProfile(userId: $userId, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class $MRProfileCopyWith<$Res>  {
  factory $MRProfileCopyWith(MRProfile value, $Res Function(MRProfile) _then) = _$MRProfileCopyWithImpl;
@useResult
$Res call({
 String userId, String name, String email
});




}
/// @nodoc
class _$MRProfileCopyWithImpl<$Res>
    implements $MRProfileCopyWith<$Res> {
  _$MRProfileCopyWithImpl(this._self, this._then);

  final MRProfile _self;
  final $Res Function(MRProfile) _then;

/// Create a copy of MRProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? email = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MRProfile implements MRProfile {
  const _MRProfile({required this.userId, required this.name, required this.email});
  factory _MRProfile.fromJson(Map<String, dynamic> json) => _$MRProfileFromJson(json);

@override final  String userId;
@override final  String name;
@override final  String email;

/// Create a copy of MRProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MRProfileCopyWith<_MRProfile> get copyWith => __$MRProfileCopyWithImpl<_MRProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MRProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MRProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,email);

@override
String toString() {
  return 'MRProfile(userId: $userId, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class _$MRProfileCopyWith<$Res> implements $MRProfileCopyWith<$Res> {
  factory _$MRProfileCopyWith(_MRProfile value, $Res Function(_MRProfile) _then) = __$MRProfileCopyWithImpl;
@override @useResult
$Res call({
 String userId, String name, String email
});




}
/// @nodoc
class __$MRProfileCopyWithImpl<$Res>
    implements _$MRProfileCopyWith<$Res> {
  __$MRProfileCopyWithImpl(this._self, this._then);

  final _MRProfile _self;
  final $Res Function(_MRProfile) _then;

/// Create a copy of MRProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? email = null,}) {
  return _then(_MRProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpcomingVisit {

 String get id; String get nextVisitDate; String? get nextVisitObjective; String get doctorName; String get doctorSpecialty; String get doctorTier; String get doctorAddress; String get mrName; String get mrUserId; String? get lastVisitDate;
/// Create a copy of UpcomingVisit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpcomingVisitCopyWith<UpcomingVisit> get copyWith => _$UpcomingVisitCopyWithImpl<UpcomingVisit>(this as UpcomingVisit, _$identity);

  /// Serializes this UpcomingVisit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingVisit&&(identical(other.id, id) || other.id == id)&&(identical(other.nextVisitDate, nextVisitDate) || other.nextVisitDate == nextVisitDate)&&(identical(other.nextVisitObjective, nextVisitObjective) || other.nextVisitObjective == nextVisitObjective)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.doctorSpecialty, doctorSpecialty) || other.doctorSpecialty == doctorSpecialty)&&(identical(other.doctorTier, doctorTier) || other.doctorTier == doctorTier)&&(identical(other.doctorAddress, doctorAddress) || other.doctorAddress == doctorAddress)&&(identical(other.mrName, mrName) || other.mrName == mrName)&&(identical(other.mrUserId, mrUserId) || other.mrUserId == mrUserId)&&(identical(other.lastVisitDate, lastVisitDate) || other.lastVisitDate == lastVisitDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nextVisitDate,nextVisitObjective,doctorName,doctorSpecialty,doctorTier,doctorAddress,mrName,mrUserId,lastVisitDate);

@override
String toString() {
  return 'UpcomingVisit(id: $id, nextVisitDate: $nextVisitDate, nextVisitObjective: $nextVisitObjective, doctorName: $doctorName, doctorSpecialty: $doctorSpecialty, doctorTier: $doctorTier, doctorAddress: $doctorAddress, mrName: $mrName, mrUserId: $mrUserId, lastVisitDate: $lastVisitDate)';
}


}

/// @nodoc
abstract mixin class $UpcomingVisitCopyWith<$Res>  {
  factory $UpcomingVisitCopyWith(UpcomingVisit value, $Res Function(UpcomingVisit) _then) = _$UpcomingVisitCopyWithImpl;
@useResult
$Res call({
 String id, String nextVisitDate, String? nextVisitObjective, String doctorName, String doctorSpecialty, String doctorTier, String doctorAddress, String mrName, String mrUserId, String? lastVisitDate
});




}
/// @nodoc
class _$UpcomingVisitCopyWithImpl<$Res>
    implements $UpcomingVisitCopyWith<$Res> {
  _$UpcomingVisitCopyWithImpl(this._self, this._then);

  final UpcomingVisit _self;
  final $Res Function(UpcomingVisit) _then;

/// Create a copy of UpcomingVisit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nextVisitDate = null,Object? nextVisitObjective = freezed,Object? doctorName = null,Object? doctorSpecialty = null,Object? doctorTier = null,Object? doctorAddress = null,Object? mrName = null,Object? mrUserId = null,Object? lastVisitDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nextVisitDate: null == nextVisitDate ? _self.nextVisitDate : nextVisitDate // ignore: cast_nullable_to_non_nullable
as String,nextVisitObjective: freezed == nextVisitObjective ? _self.nextVisitObjective : nextVisitObjective // ignore: cast_nullable_to_non_nullable
as String?,doctorName: null == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String,doctorSpecialty: null == doctorSpecialty ? _self.doctorSpecialty : doctorSpecialty // ignore: cast_nullable_to_non_nullable
as String,doctorTier: null == doctorTier ? _self.doctorTier : doctorTier // ignore: cast_nullable_to_non_nullable
as String,doctorAddress: null == doctorAddress ? _self.doctorAddress : doctorAddress // ignore: cast_nullable_to_non_nullable
as String,mrName: null == mrName ? _self.mrName : mrName // ignore: cast_nullable_to_non_nullable
as String,mrUserId: null == mrUserId ? _self.mrUserId : mrUserId // ignore: cast_nullable_to_non_nullable
as String,lastVisitDate: freezed == lastVisitDate ? _self.lastVisitDate : lastVisitDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UpcomingVisit implements UpcomingVisit {
  const _UpcomingVisit({required this.id, required this.nextVisitDate, this.nextVisitObjective, required this.doctorName, required this.doctorSpecialty, required this.doctorTier, required this.doctorAddress, required this.mrName, required this.mrUserId, this.lastVisitDate});
  factory _UpcomingVisit.fromJson(Map<String, dynamic> json) => _$UpcomingVisitFromJson(json);

@override final  String id;
@override final  String nextVisitDate;
@override final  String? nextVisitObjective;
@override final  String doctorName;
@override final  String doctorSpecialty;
@override final  String doctorTier;
@override final  String doctorAddress;
@override final  String mrName;
@override final  String mrUserId;
@override final  String? lastVisitDate;

/// Create a copy of UpcomingVisit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpcomingVisitCopyWith<_UpcomingVisit> get copyWith => __$UpcomingVisitCopyWithImpl<_UpcomingVisit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpcomingVisitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpcomingVisit&&(identical(other.id, id) || other.id == id)&&(identical(other.nextVisitDate, nextVisitDate) || other.nextVisitDate == nextVisitDate)&&(identical(other.nextVisitObjective, nextVisitObjective) || other.nextVisitObjective == nextVisitObjective)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.doctorSpecialty, doctorSpecialty) || other.doctorSpecialty == doctorSpecialty)&&(identical(other.doctorTier, doctorTier) || other.doctorTier == doctorTier)&&(identical(other.doctorAddress, doctorAddress) || other.doctorAddress == doctorAddress)&&(identical(other.mrName, mrName) || other.mrName == mrName)&&(identical(other.mrUserId, mrUserId) || other.mrUserId == mrUserId)&&(identical(other.lastVisitDate, lastVisitDate) || other.lastVisitDate == lastVisitDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nextVisitDate,nextVisitObjective,doctorName,doctorSpecialty,doctorTier,doctorAddress,mrName,mrUserId,lastVisitDate);

@override
String toString() {
  return 'UpcomingVisit(id: $id, nextVisitDate: $nextVisitDate, nextVisitObjective: $nextVisitObjective, doctorName: $doctorName, doctorSpecialty: $doctorSpecialty, doctorTier: $doctorTier, doctorAddress: $doctorAddress, mrName: $mrName, mrUserId: $mrUserId, lastVisitDate: $lastVisitDate)';
}


}

/// @nodoc
abstract mixin class _$UpcomingVisitCopyWith<$Res> implements $UpcomingVisitCopyWith<$Res> {
  factory _$UpcomingVisitCopyWith(_UpcomingVisit value, $Res Function(_UpcomingVisit) _then) = __$UpcomingVisitCopyWithImpl;
@override @useResult
$Res call({
 String id, String nextVisitDate, String? nextVisitObjective, String doctorName, String doctorSpecialty, String doctorTier, String doctorAddress, String mrName, String mrUserId, String? lastVisitDate
});




}
/// @nodoc
class __$UpcomingVisitCopyWithImpl<$Res>
    implements _$UpcomingVisitCopyWith<$Res> {
  __$UpcomingVisitCopyWithImpl(this._self, this._then);

  final _UpcomingVisit _self;
  final $Res Function(_UpcomingVisit) _then;

/// Create a copy of UpcomingVisit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nextVisitDate = null,Object? nextVisitObjective = freezed,Object? doctorName = null,Object? doctorSpecialty = null,Object? doctorTier = null,Object? doctorAddress = null,Object? mrName = null,Object? mrUserId = null,Object? lastVisitDate = freezed,}) {
  return _then(_UpcomingVisit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nextVisitDate: null == nextVisitDate ? _self.nextVisitDate : nextVisitDate // ignore: cast_nullable_to_non_nullable
as String,nextVisitObjective: freezed == nextVisitObjective ? _self.nextVisitObjective : nextVisitObjective // ignore: cast_nullable_to_non_nullable
as String?,doctorName: null == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String,doctorSpecialty: null == doctorSpecialty ? _self.doctorSpecialty : doctorSpecialty // ignore: cast_nullable_to_non_nullable
as String,doctorTier: null == doctorTier ? _self.doctorTier : doctorTier // ignore: cast_nullable_to_non_nullable
as String,doctorAddress: null == doctorAddress ? _self.doctorAddress : doctorAddress // ignore: cast_nullable_to_non_nullable
as String,mrName: null == mrName ? _self.mrName : mrName // ignore: cast_nullable_to_non_nullable
as String,mrUserId: null == mrUserId ? _self.mrUserId : mrUserId // ignore: cast_nullable_to_non_nullable
as String,lastVisitDate: freezed == lastVisitDate ? _self.lastVisitDate : lastVisitDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MRStats {

 String get mrUserId; String get mrName; int get totalDoctors; int get visitsThisMonth; int get visitsLastMonth; int get aTierVisits; int get bTierVisits; int get cTierVisits; double get avgVisitsPerDoctor; int get neglectedDoctors;
/// Create a copy of MRStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MRStatsCopyWith<MRStats> get copyWith => _$MRStatsCopyWithImpl<MRStats>(this as MRStats, _$identity);

  /// Serializes this MRStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MRStats&&(identical(other.mrUserId, mrUserId) || other.mrUserId == mrUserId)&&(identical(other.mrName, mrName) || other.mrName == mrName)&&(identical(other.totalDoctors, totalDoctors) || other.totalDoctors == totalDoctors)&&(identical(other.visitsThisMonth, visitsThisMonth) || other.visitsThisMonth == visitsThisMonth)&&(identical(other.visitsLastMonth, visitsLastMonth) || other.visitsLastMonth == visitsLastMonth)&&(identical(other.aTierVisits, aTierVisits) || other.aTierVisits == aTierVisits)&&(identical(other.bTierVisits, bTierVisits) || other.bTierVisits == bTierVisits)&&(identical(other.cTierVisits, cTierVisits) || other.cTierVisits == cTierVisits)&&(identical(other.avgVisitsPerDoctor, avgVisitsPerDoctor) || other.avgVisitsPerDoctor == avgVisitsPerDoctor)&&(identical(other.neglectedDoctors, neglectedDoctors) || other.neglectedDoctors == neglectedDoctors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mrUserId,mrName,totalDoctors,visitsThisMonth,visitsLastMonth,aTierVisits,bTierVisits,cTierVisits,avgVisitsPerDoctor,neglectedDoctors);

@override
String toString() {
  return 'MRStats(mrUserId: $mrUserId, mrName: $mrName, totalDoctors: $totalDoctors, visitsThisMonth: $visitsThisMonth, visitsLastMonth: $visitsLastMonth, aTierVisits: $aTierVisits, bTierVisits: $bTierVisits, cTierVisits: $cTierVisits, avgVisitsPerDoctor: $avgVisitsPerDoctor, neglectedDoctors: $neglectedDoctors)';
}


}

/// @nodoc
abstract mixin class $MRStatsCopyWith<$Res>  {
  factory $MRStatsCopyWith(MRStats value, $Res Function(MRStats) _then) = _$MRStatsCopyWithImpl;
@useResult
$Res call({
 String mrUserId, String mrName, int totalDoctors, int visitsThisMonth, int visitsLastMonth, int aTierVisits, int bTierVisits, int cTierVisits, double avgVisitsPerDoctor, int neglectedDoctors
});




}
/// @nodoc
class _$MRStatsCopyWithImpl<$Res>
    implements $MRStatsCopyWith<$Res> {
  _$MRStatsCopyWithImpl(this._self, this._then);

  final MRStats _self;
  final $Res Function(MRStats) _then;

/// Create a copy of MRStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mrUserId = null,Object? mrName = null,Object? totalDoctors = null,Object? visitsThisMonth = null,Object? visitsLastMonth = null,Object? aTierVisits = null,Object? bTierVisits = null,Object? cTierVisits = null,Object? avgVisitsPerDoctor = null,Object? neglectedDoctors = null,}) {
  return _then(_self.copyWith(
mrUserId: null == mrUserId ? _self.mrUserId : mrUserId // ignore: cast_nullable_to_non_nullable
as String,mrName: null == mrName ? _self.mrName : mrName // ignore: cast_nullable_to_non_nullable
as String,totalDoctors: null == totalDoctors ? _self.totalDoctors : totalDoctors // ignore: cast_nullable_to_non_nullable
as int,visitsThisMonth: null == visitsThisMonth ? _self.visitsThisMonth : visitsThisMonth // ignore: cast_nullable_to_non_nullable
as int,visitsLastMonth: null == visitsLastMonth ? _self.visitsLastMonth : visitsLastMonth // ignore: cast_nullable_to_non_nullable
as int,aTierVisits: null == aTierVisits ? _self.aTierVisits : aTierVisits // ignore: cast_nullable_to_non_nullable
as int,bTierVisits: null == bTierVisits ? _self.bTierVisits : bTierVisits // ignore: cast_nullable_to_non_nullable
as int,cTierVisits: null == cTierVisits ? _self.cTierVisits : cTierVisits // ignore: cast_nullable_to_non_nullable
as int,avgVisitsPerDoctor: null == avgVisitsPerDoctor ? _self.avgVisitsPerDoctor : avgVisitsPerDoctor // ignore: cast_nullable_to_non_nullable
as double,neglectedDoctors: null == neglectedDoctors ? _self.neglectedDoctors : neglectedDoctors // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MRStats implements MRStats {
  const _MRStats({required this.mrUserId, required this.mrName, required this.totalDoctors, required this.visitsThisMonth, required this.visitsLastMonth, required this.aTierVisits, required this.bTierVisits, required this.cTierVisits, required this.avgVisitsPerDoctor, required this.neglectedDoctors});
  factory _MRStats.fromJson(Map<String, dynamic> json) => _$MRStatsFromJson(json);

@override final  String mrUserId;
@override final  String mrName;
@override final  int totalDoctors;
@override final  int visitsThisMonth;
@override final  int visitsLastMonth;
@override final  int aTierVisits;
@override final  int bTierVisits;
@override final  int cTierVisits;
@override final  double avgVisitsPerDoctor;
@override final  int neglectedDoctors;

/// Create a copy of MRStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MRStatsCopyWith<_MRStats> get copyWith => __$MRStatsCopyWithImpl<_MRStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MRStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MRStats&&(identical(other.mrUserId, mrUserId) || other.mrUserId == mrUserId)&&(identical(other.mrName, mrName) || other.mrName == mrName)&&(identical(other.totalDoctors, totalDoctors) || other.totalDoctors == totalDoctors)&&(identical(other.visitsThisMonth, visitsThisMonth) || other.visitsThisMonth == visitsThisMonth)&&(identical(other.visitsLastMonth, visitsLastMonth) || other.visitsLastMonth == visitsLastMonth)&&(identical(other.aTierVisits, aTierVisits) || other.aTierVisits == aTierVisits)&&(identical(other.bTierVisits, bTierVisits) || other.bTierVisits == bTierVisits)&&(identical(other.cTierVisits, cTierVisits) || other.cTierVisits == cTierVisits)&&(identical(other.avgVisitsPerDoctor, avgVisitsPerDoctor) || other.avgVisitsPerDoctor == avgVisitsPerDoctor)&&(identical(other.neglectedDoctors, neglectedDoctors) || other.neglectedDoctors == neglectedDoctors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mrUserId,mrName,totalDoctors,visitsThisMonth,visitsLastMonth,aTierVisits,bTierVisits,cTierVisits,avgVisitsPerDoctor,neglectedDoctors);

@override
String toString() {
  return 'MRStats(mrUserId: $mrUserId, mrName: $mrName, totalDoctors: $totalDoctors, visitsThisMonth: $visitsThisMonth, visitsLastMonth: $visitsLastMonth, aTierVisits: $aTierVisits, bTierVisits: $bTierVisits, cTierVisits: $cTierVisits, avgVisitsPerDoctor: $avgVisitsPerDoctor, neglectedDoctors: $neglectedDoctors)';
}


}

/// @nodoc
abstract mixin class _$MRStatsCopyWith<$Res> implements $MRStatsCopyWith<$Res> {
  factory _$MRStatsCopyWith(_MRStats value, $Res Function(_MRStats) _then) = __$MRStatsCopyWithImpl;
@override @useResult
$Res call({
 String mrUserId, String mrName, int totalDoctors, int visitsThisMonth, int visitsLastMonth, int aTierVisits, int bTierVisits, int cTierVisits, double avgVisitsPerDoctor, int neglectedDoctors
});




}
/// @nodoc
class __$MRStatsCopyWithImpl<$Res>
    implements _$MRStatsCopyWith<$Res> {
  __$MRStatsCopyWithImpl(this._self, this._then);

  final _MRStats _self;
  final $Res Function(_MRStats) _then;

/// Create a copy of MRStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mrUserId = null,Object? mrName = null,Object? totalDoctors = null,Object? visitsThisMonth = null,Object? visitsLastMonth = null,Object? aTierVisits = null,Object? bTierVisits = null,Object? cTierVisits = null,Object? avgVisitsPerDoctor = null,Object? neglectedDoctors = null,}) {
  return _then(_MRStats(
mrUserId: null == mrUserId ? _self.mrUserId : mrUserId // ignore: cast_nullable_to_non_nullable
as String,mrName: null == mrName ? _self.mrName : mrName // ignore: cast_nullable_to_non_nullable
as String,totalDoctors: null == totalDoctors ? _self.totalDoctors : totalDoctors // ignore: cast_nullable_to_non_nullable
as int,visitsThisMonth: null == visitsThisMonth ? _self.visitsThisMonth : visitsThisMonth // ignore: cast_nullable_to_non_nullable
as int,visitsLastMonth: null == visitsLastMonth ? _self.visitsLastMonth : visitsLastMonth // ignore: cast_nullable_to_non_nullable
as int,aTierVisits: null == aTierVisits ? _self.aTierVisits : aTierVisits // ignore: cast_nullable_to_non_nullable
as int,bTierVisits: null == bTierVisits ? _self.bTierVisits : bTierVisits // ignore: cast_nullable_to_non_nullable
as int,cTierVisits: null == cTierVisits ? _self.cTierVisits : cTierVisits // ignore: cast_nullable_to_non_nullable
as int,avgVisitsPerDoctor: null == avgVisitsPerDoctor ? _self.avgVisitsPerDoctor : avgVisitsPerDoctor // ignore: cast_nullable_to_non_nullable
as double,neglectedDoctors: null == neglectedDoctors ? _self.neglectedDoctors : neglectedDoctors // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NeglectedDoctor {

 String get id; String get fullName; String get specialty; String get tier; String get clinicAddress; String get mrName; String? get lastVisitDate; int? get daysSinceVisit;
/// Create a copy of NeglectedDoctor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NeglectedDoctorCopyWith<NeglectedDoctor> get copyWith => _$NeglectedDoctorCopyWithImpl<NeglectedDoctor>(this as NeglectedDoctor, _$identity);

  /// Serializes this NeglectedDoctor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NeglectedDoctor&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.specialty, specialty) || other.specialty == specialty)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.clinicAddress, clinicAddress) || other.clinicAddress == clinicAddress)&&(identical(other.mrName, mrName) || other.mrName == mrName)&&(identical(other.lastVisitDate, lastVisitDate) || other.lastVisitDate == lastVisitDate)&&(identical(other.daysSinceVisit, daysSinceVisit) || other.daysSinceVisit == daysSinceVisit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,specialty,tier,clinicAddress,mrName,lastVisitDate,daysSinceVisit);

@override
String toString() {
  return 'NeglectedDoctor(id: $id, fullName: $fullName, specialty: $specialty, tier: $tier, clinicAddress: $clinicAddress, mrName: $mrName, lastVisitDate: $lastVisitDate, daysSinceVisit: $daysSinceVisit)';
}


}

/// @nodoc
abstract mixin class $NeglectedDoctorCopyWith<$Res>  {
  factory $NeglectedDoctorCopyWith(NeglectedDoctor value, $Res Function(NeglectedDoctor) _then) = _$NeglectedDoctorCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String specialty, String tier, String clinicAddress, String mrName, String? lastVisitDate, int? daysSinceVisit
});




}
/// @nodoc
class _$NeglectedDoctorCopyWithImpl<$Res>
    implements $NeglectedDoctorCopyWith<$Res> {
  _$NeglectedDoctorCopyWithImpl(this._self, this._then);

  final NeglectedDoctor _self;
  final $Res Function(NeglectedDoctor) _then;

/// Create a copy of NeglectedDoctor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? specialty = null,Object? tier = null,Object? clinicAddress = null,Object? mrName = null,Object? lastVisitDate = freezed,Object? daysSinceVisit = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,specialty: null == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,clinicAddress: null == clinicAddress ? _self.clinicAddress : clinicAddress // ignore: cast_nullable_to_non_nullable
as String,mrName: null == mrName ? _self.mrName : mrName // ignore: cast_nullable_to_non_nullable
as String,lastVisitDate: freezed == lastVisitDate ? _self.lastVisitDate : lastVisitDate // ignore: cast_nullable_to_non_nullable
as String?,daysSinceVisit: freezed == daysSinceVisit ? _self.daysSinceVisit : daysSinceVisit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _NeglectedDoctor implements NeglectedDoctor {
  const _NeglectedDoctor({required this.id, required this.fullName, required this.specialty, required this.tier, required this.clinicAddress, required this.mrName, this.lastVisitDate, this.daysSinceVisit});
  factory _NeglectedDoctor.fromJson(Map<String, dynamic> json) => _$NeglectedDoctorFromJson(json);

@override final  String id;
@override final  String fullName;
@override final  String specialty;
@override final  String tier;
@override final  String clinicAddress;
@override final  String mrName;
@override final  String? lastVisitDate;
@override final  int? daysSinceVisit;

/// Create a copy of NeglectedDoctor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NeglectedDoctorCopyWith<_NeglectedDoctor> get copyWith => __$NeglectedDoctorCopyWithImpl<_NeglectedDoctor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NeglectedDoctorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NeglectedDoctor&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.specialty, specialty) || other.specialty == specialty)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.clinicAddress, clinicAddress) || other.clinicAddress == clinicAddress)&&(identical(other.mrName, mrName) || other.mrName == mrName)&&(identical(other.lastVisitDate, lastVisitDate) || other.lastVisitDate == lastVisitDate)&&(identical(other.daysSinceVisit, daysSinceVisit) || other.daysSinceVisit == daysSinceVisit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,specialty,tier,clinicAddress,mrName,lastVisitDate,daysSinceVisit);

@override
String toString() {
  return 'NeglectedDoctor(id: $id, fullName: $fullName, specialty: $specialty, tier: $tier, clinicAddress: $clinicAddress, mrName: $mrName, lastVisitDate: $lastVisitDate, daysSinceVisit: $daysSinceVisit)';
}


}

/// @nodoc
abstract mixin class _$NeglectedDoctorCopyWith<$Res> implements $NeglectedDoctorCopyWith<$Res> {
  factory _$NeglectedDoctorCopyWith(_NeglectedDoctor value, $Res Function(_NeglectedDoctor) _then) = __$NeglectedDoctorCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String specialty, String tier, String clinicAddress, String mrName, String? lastVisitDate, int? daysSinceVisit
});




}
/// @nodoc
class __$NeglectedDoctorCopyWithImpl<$Res>
    implements _$NeglectedDoctorCopyWith<$Res> {
  __$NeglectedDoctorCopyWithImpl(this._self, this._then);

  final _NeglectedDoctor _self;
  final $Res Function(_NeglectedDoctor) _then;

/// Create a copy of NeglectedDoctor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? specialty = null,Object? tier = null,Object? clinicAddress = null,Object? mrName = null,Object? lastVisitDate = freezed,Object? daysSinceVisit = freezed,}) {
  return _then(_NeglectedDoctor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,specialty: null == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,clinicAddress: null == clinicAddress ? _self.clinicAddress : clinicAddress // ignore: cast_nullable_to_non_nullable
as String,mrName: null == mrName ? _self.mrName : mrName // ignore: cast_nullable_to_non_nullable
as String,lastVisitDate: freezed == lastVisitDate ? _self.lastVisitDate : lastVisitDate // ignore: cast_nullable_to_non_nullable
as String?,daysSinceVisit: freezed == daysSinceVisit ? _self.daysSinceVisit : daysSinceVisit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MRActivityFilters {

 String? get selectedMR; String? get selectedPeriod;
/// Create a copy of MRActivityFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MRActivityFiltersCopyWith<MRActivityFilters> get copyWith => _$MRActivityFiltersCopyWithImpl<MRActivityFilters>(this as MRActivityFilters, _$identity);

  /// Serializes this MRActivityFilters to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MRActivityFilters&&(identical(other.selectedMR, selectedMR) || other.selectedMR == selectedMR)&&(identical(other.selectedPeriod, selectedPeriod) || other.selectedPeriod == selectedPeriod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectedMR,selectedPeriod);

@override
String toString() {
  return 'MRActivityFilters(selectedMR: $selectedMR, selectedPeriod: $selectedPeriod)';
}


}

/// @nodoc
abstract mixin class $MRActivityFiltersCopyWith<$Res>  {
  factory $MRActivityFiltersCopyWith(MRActivityFilters value, $Res Function(MRActivityFilters) _then) = _$MRActivityFiltersCopyWithImpl;
@useResult
$Res call({
 String? selectedMR, String? selectedPeriod
});




}
/// @nodoc
class _$MRActivityFiltersCopyWithImpl<$Res>
    implements $MRActivityFiltersCopyWith<$Res> {
  _$MRActivityFiltersCopyWithImpl(this._self, this._then);

  final MRActivityFilters _self;
  final $Res Function(MRActivityFilters) _then;

/// Create a copy of MRActivityFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedMR = freezed,Object? selectedPeriod = freezed,}) {
  return _then(_self.copyWith(
selectedMR: freezed == selectedMR ? _self.selectedMR : selectedMR // ignore: cast_nullable_to_non_nullable
as String?,selectedPeriod: freezed == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MRActivityFilters implements MRActivityFilters {
  const _MRActivityFilters({this.selectedMR, this.selectedPeriod});
  factory _MRActivityFilters.fromJson(Map<String, dynamic> json) => _$MRActivityFiltersFromJson(json);

@override final  String? selectedMR;
@override final  String? selectedPeriod;

/// Create a copy of MRActivityFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MRActivityFiltersCopyWith<_MRActivityFilters> get copyWith => __$MRActivityFiltersCopyWithImpl<_MRActivityFilters>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MRActivityFiltersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MRActivityFilters&&(identical(other.selectedMR, selectedMR) || other.selectedMR == selectedMR)&&(identical(other.selectedPeriod, selectedPeriod) || other.selectedPeriod == selectedPeriod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectedMR,selectedPeriod);

@override
String toString() {
  return 'MRActivityFilters(selectedMR: $selectedMR, selectedPeriod: $selectedPeriod)';
}


}

/// @nodoc
abstract mixin class _$MRActivityFiltersCopyWith<$Res> implements $MRActivityFiltersCopyWith<$Res> {
  factory _$MRActivityFiltersCopyWith(_MRActivityFilters value, $Res Function(_MRActivityFilters) _then) = __$MRActivityFiltersCopyWithImpl;
@override @useResult
$Res call({
 String? selectedMR, String? selectedPeriod
});




}
/// @nodoc
class __$MRActivityFiltersCopyWithImpl<$Res>
    implements _$MRActivityFiltersCopyWith<$Res> {
  __$MRActivityFiltersCopyWithImpl(this._self, this._then);

  final _MRActivityFilters _self;
  final $Res Function(_MRActivityFilters) _then;

/// Create a copy of MRActivityFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedMR = freezed,Object? selectedPeriod = freezed,}) {
  return _then(_MRActivityFilters(
selectedMR: freezed == selectedMR ? _self.selectedMR : selectedMR // ignore: cast_nullable_to_non_nullable
as String?,selectedPeriod: freezed == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TierDistribution {

 String get tier; int get totalVisits; double get percentage;
/// Create a copy of TierDistribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TierDistributionCopyWith<TierDistribution> get copyWith => _$TierDistributionCopyWithImpl<TierDistribution>(this as TierDistribution, _$identity);

  /// Serializes this TierDistribution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TierDistribution&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.totalVisits, totalVisits) || other.totalVisits == totalVisits)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tier,totalVisits,percentage);

@override
String toString() {
  return 'TierDistribution(tier: $tier, totalVisits: $totalVisits, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $TierDistributionCopyWith<$Res>  {
  factory $TierDistributionCopyWith(TierDistribution value, $Res Function(TierDistribution) _then) = _$TierDistributionCopyWithImpl;
@useResult
$Res call({
 String tier, int totalVisits, double percentage
});




}
/// @nodoc
class _$TierDistributionCopyWithImpl<$Res>
    implements $TierDistributionCopyWith<$Res> {
  _$TierDistributionCopyWithImpl(this._self, this._then);

  final TierDistribution _self;
  final $Res Function(TierDistribution) _then;

/// Create a copy of TierDistribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tier = null,Object? totalVisits = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,totalVisits: null == totalVisits ? _self.totalVisits : totalVisits // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TierDistribution implements TierDistribution {
  const _TierDistribution({required this.tier, required this.totalVisits, required this.percentage});
  factory _TierDistribution.fromJson(Map<String, dynamic> json) => _$TierDistributionFromJson(json);

@override final  String tier;
@override final  int totalVisits;
@override final  double percentage;

/// Create a copy of TierDistribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TierDistributionCopyWith<_TierDistribution> get copyWith => __$TierDistributionCopyWithImpl<_TierDistribution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TierDistributionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TierDistribution&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.totalVisits, totalVisits) || other.totalVisits == totalVisits)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tier,totalVisits,percentage);

@override
String toString() {
  return 'TierDistribution(tier: $tier, totalVisits: $totalVisits, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$TierDistributionCopyWith<$Res> implements $TierDistributionCopyWith<$Res> {
  factory _$TierDistributionCopyWith(_TierDistribution value, $Res Function(_TierDistribution) _then) = __$TierDistributionCopyWithImpl;
@override @useResult
$Res call({
 String tier, int totalVisits, double percentage
});




}
/// @nodoc
class __$TierDistributionCopyWithImpl<$Res>
    implements _$TierDistributionCopyWith<$Res> {
  __$TierDistributionCopyWithImpl(this._self, this._then);

  final _TierDistribution _self;
  final $Res Function(_TierDistribution) _then;

/// Create a copy of TierDistribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tier = null,Object? totalVisits = null,Object? percentage = null,}) {
  return _then(_TierDistribution(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,totalVisits: null == totalVisits ? _self.totalVisits : totalVisits // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$StrategicRecommendation {

 String get type;// 'error', 'warning', 'info'
 String get message; String get mrUserId;
/// Create a copy of StrategicRecommendation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StrategicRecommendationCopyWith<StrategicRecommendation> get copyWith => _$StrategicRecommendationCopyWithImpl<StrategicRecommendation>(this as StrategicRecommendation, _$identity);

  /// Serializes this StrategicRecommendation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StrategicRecommendation&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.mrUserId, mrUserId) || other.mrUserId == mrUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,message,mrUserId);

@override
String toString() {
  return 'StrategicRecommendation(type: $type, message: $message, mrUserId: $mrUserId)';
}


}

/// @nodoc
abstract mixin class $StrategicRecommendationCopyWith<$Res>  {
  factory $StrategicRecommendationCopyWith(StrategicRecommendation value, $Res Function(StrategicRecommendation) _then) = _$StrategicRecommendationCopyWithImpl;
@useResult
$Res call({
 String type, String message, String mrUserId
});




}
/// @nodoc
class _$StrategicRecommendationCopyWithImpl<$Res>
    implements $StrategicRecommendationCopyWith<$Res> {
  _$StrategicRecommendationCopyWithImpl(this._self, this._then);

  final StrategicRecommendation _self;
  final $Res Function(StrategicRecommendation) _then;

/// Create a copy of StrategicRecommendation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? message = null,Object? mrUserId = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,mrUserId: null == mrUserId ? _self.mrUserId : mrUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _StrategicRecommendation implements StrategicRecommendation {
  const _StrategicRecommendation({required this.type, required this.message, required this.mrUserId});
  factory _StrategicRecommendation.fromJson(Map<String, dynamic> json) => _$StrategicRecommendationFromJson(json);

@override final  String type;
// 'error', 'warning', 'info'
@override final  String message;
@override final  String mrUserId;

/// Create a copy of StrategicRecommendation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StrategicRecommendationCopyWith<_StrategicRecommendation> get copyWith => __$StrategicRecommendationCopyWithImpl<_StrategicRecommendation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StrategicRecommendationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StrategicRecommendation&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.mrUserId, mrUserId) || other.mrUserId == mrUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,message,mrUserId);

@override
String toString() {
  return 'StrategicRecommendation(type: $type, message: $message, mrUserId: $mrUserId)';
}


}

/// @nodoc
abstract mixin class _$StrategicRecommendationCopyWith<$Res> implements $StrategicRecommendationCopyWith<$Res> {
  factory _$StrategicRecommendationCopyWith(_StrategicRecommendation value, $Res Function(_StrategicRecommendation) _then) = __$StrategicRecommendationCopyWithImpl;
@override @useResult
$Res call({
 String type, String message, String mrUserId
});




}
/// @nodoc
class __$StrategicRecommendationCopyWithImpl<$Res>
    implements _$StrategicRecommendationCopyWith<$Res> {
  __$StrategicRecommendationCopyWithImpl(this._self, this._then);

  final _StrategicRecommendation _self;
  final $Res Function(_StrategicRecommendation) _then;

/// Create a copy of StrategicRecommendation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? message = null,Object? mrUserId = null,}) {
  return _then(_StrategicRecommendation(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,mrUserId: null == mrUserId ? _self.mrUserId : mrUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
