import 'package:flutter/material.dart';

class Doctor {
  final String id;
  final String fullName;
  final String? specialty;
  final String? clinicAddress;
  final String? phoneNumber;
  final String? email;
  final DateTime? dateOfBirth;
  final DateTime? anniversaryDate;
  final String? tier; // A, B, C
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final List<DoctorClinic>? clinics;
  final MRAllotment? allottedMR;
  final int? visitCount;
  final DateTime? lastVisitDate;

  Doctor({
    required this.id,
    required this.fullName,
    this.specialty,
    this.clinicAddress,
    this.phoneNumber,
    this.email,
    this.dateOfBirth,
    this.anniversaryDate,
    this.tier,
    this.latitude,
    this.longitude,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.clinics,
    this.allottedMR,
    this.visitCount,
    this.lastVisitDate,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      specialty: json['specialty'],
      clinicAddress: json['clinic_address'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      anniversaryDate: json['anniversary_date'] != null
          ? DateTime.parse(json['anniversary_date'])
          : null,
      tier: json['tier'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      createdBy: json['created_by'],
      clinics: json['doctor_clinics'] != null
          ? (json['doctor_clinics'] as List)
              .map((clinic) => DoctorClinic.fromJson(clinic))
              .toList()
          : null,
      allottedMR: json['mr_doctor_allotments'] != null
          ? MRAllotment.fromJson(json['mr_doctor_allotments'])
          : null,
      visitCount: json['visit_count']?.toInt(),
      lastVisitDate: json['last_visit_date'] != null
          ? DateTime.parse(json['last_visit_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'specialty': specialty,
      'clinic_address': clinicAddress,
      'phone_number': phoneNumber,
      'email': email,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
      'anniversary_date': anniversaryDate?.toIso8601String().split('T')[0],
      'tier': tier,
      'latitude': latitude,
      'longitude': longitude,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
    };
  }

  Color get tierColor {
    switch (tier?.toUpperCase()) {
      case 'A':
        return const Color(0xFF059669); // Green
      case 'B':
        return const Color(0xFFF59E0B); // Yellow
      case 'C':
        return const Color(0xFFDC2626); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  String get tierDisplay {
    return tier?.toUpperCase() ?? 'N/A';
  }

  String get statusDisplay {
    return isActive ? 'Active' : 'Inactive';
  }

  Color get statusColor {
    return isActive ? const Color(0xFF059669) : const Color(0xFF6B7280);
  }
}

class DoctorClinic {
  final String id;
  final String doctorId;
  final String clinicName;
  final double? latitude;
  final double? longitude;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorClinic({
    required this.id,
    required this.doctorId,
    required this.clinicName,
    this.latitude,
    this.longitude,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorClinic.fromJson(Map<String, dynamic> json) {
    return DoctorClinic(
      id: json['id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      clinicName: json['clinic_name'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isPrimary: json['is_primary'] ?? false,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'clinic_name': clinicName,
      'latitude': latitude,
      'longitude': longitude,
      'is_primary': isPrimary,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class MRAllotment {
  final String id;
  final String mrUserId;
  final String doctorId;
  final String? mrName;

  MRAllotment({
    required this.id,
    required this.mrUserId,
    required this.doctorId,
    this.mrName,
  });

  factory MRAllotment.fromJson(Map<String, dynamic> json) {
    return MRAllotment(
      id: json['id'] ?? '',
      mrUserId: json['mr_user_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      mrName: json['profiles']?['name'] ?? json['mr_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mr_user_id': mrUserId,
      'doctor_id': doctorId,
    };
  }
}

class MRVisitLog {
  final String id;
  final String mrUserId;
  final String doctorId;
  final DateTime visitDate;
  final List<dynamic>? productsDetailed;
  final String? feedbackReceived;
  final List<dynamic>? samplesProvided;
  final String? competitorActivityNotes;
  final String? prescriptionPotentialNotes;
  final DateTime? nextVisitDate;
  final String? nextVisitObjective;
  final String? linkedSaleOrderId;
  final bool? isLocationVerified;
  final double? distanceFromClinicMeters;
  final String? clinicId;
  final DateTime createdAt;
  final String? mrName;

  MRVisitLog({
    required this.id,
    required this.mrUserId,
    required this.doctorId,
    required this.visitDate,
    this.productsDetailed,
    this.feedbackReceived,
    this.samplesProvided,
    this.competitorActivityNotes,
    this.prescriptionPotentialNotes,
    this.nextVisitDate,
    this.nextVisitObjective,
    this.linkedSaleOrderId,
    this.isLocationVerified,
    this.distanceFromClinicMeters,
    this.clinicId,
    required this.createdAt,
    this.mrName,
  });

  factory MRVisitLog.fromJson(Map<String, dynamic> json) {
    return MRVisitLog(
      id: json['id'] ?? '',
      mrUserId: json['mr_user_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      visitDate: DateTime.parse(
          json['visit_date'] ?? DateTime.now().toIso8601String()),
      productsDetailed: json['products_detailed'],
      feedbackReceived: json['feedback_received'],
      samplesProvided: json['samples_provided'],
      competitorActivityNotes: json['competitor_activity_notes'],
      prescriptionPotentialNotes: json['prescription_potential_notes'],
      nextVisitDate: json['next_visit_date'] != null
          ? DateTime.parse(json['next_visit_date'])
          : null,
      nextVisitObjective: json['next_visit_objective'],
      linkedSaleOrderId: json['linked_sale_order_id'],
      isLocationVerified: json['is_location_verified'],
      distanceFromClinicMeters: json['distance_from_clinic_meters']?.toDouble(),
      clinicId: json['clinic_id'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      mrName: json['profiles']?['name'] ?? json['mr_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mr_user_id': mrUserId,
      'doctor_id': doctorId,
      'visit_date': visitDate.toIso8601String(),
      'products_detailed': productsDetailed,
      'feedback_received': feedbackReceived,
      'samples_provided': samplesProvided,
      'competitor_activity_notes': competitorActivityNotes,
      'prescription_potential_notes': prescriptionPotentialNotes,
      'next_visit_date': nextVisitDate?.toIso8601String().split('T')[0],
      'next_visit_objective': nextVisitObjective,
      'linked_sale_order_id': linkedSaleOrderId,
      'is_location_verified': isLocationVerified,
      'distance_from_clinic_meters': distanceFromClinicMeters,
      'clinic_id': clinicId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class DoctorFilters {
  final String? tier;
  final String? mrUserId;
  final bool? isActive;
  final String? specialty;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  DoctorFilters({
    this.tier,
    this.mrUserId,
    this.isActive,
    this.specialty,
    this.dateFrom,
    this.dateTo,
  });

  Map<String, dynamic> toJson() {
    return {
      'tier': tier,
      'mr_user_id': mrUserId,
      'is_active': isActive,
      'specialty': specialty,
      'date_from': dateFrom?.toIso8601String().split('T')[0],
      'date_to': dateTo?.toIso8601String().split('T')[0],
    };
  }
}