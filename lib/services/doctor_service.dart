import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/doctor_models.dart';

class DoctorService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch doctors with pagination, search, and filters
  Future<List<Doctor>> fetchDoctors({
    int page = 1,
    int limit = 20,
    String? searchQuery,
    DoctorFilters? filters,
    String sortField = 'created_at',
    String sortDirection = 'desc',
  }) async {
    try {
      dynamic query = _supabase
          .from('doctors')
          .select('''
            *,
            doctor_clinics(*),
            mr_doctor_allotments(
              id,
              mr_user_id,
              doctor_id,
              profiles!mr_doctor_allotments_mr_user_id_fkey(
                name
              )
            )
          ''')
          .order(sortField, ascending: sortDirection == 'asc')
          .range((page - 1) * limit, page * limit - 1);

      // Apply search filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or(
            'full_name.ilike.%$searchQuery%,specialty.ilike.%$searchQuery%,clinic_address.ilike.%$searchQuery%');
      }

      // Apply filters
      if (filters != null) {
        if (filters.tier != null && filters.tier!.isNotEmpty) {
          query = query.eq('tier', filters.tier!);
        }
        if (filters.isActive != null) {
          query = query.eq('is_active', filters.isActive!);
        }
        if (filters.specialty != null && filters.specialty!.isNotEmpty) {
          query = query.ilike('specialty', '%${filters.specialty}%');
        }
        if (filters.dateFrom != null) {
          query = query.gte('created_at', filters.dateFrom!.toIso8601String());
        }
        if (filters.dateTo != null) {
          query = query.lte('created_at', filters.dateTo!.toIso8601String());
        }
      }

      final response = await query;
      
      return (response as List)
          .map((doctor) => Doctor.fromJson(doctor))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch doctors: $e');
    }
  }

  // Get doctor by ID with detailed information
  Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      final response = await _supabase
          .from('doctors')
          .select('''
            *,
            doctor_clinics(*),
            mr_doctor_allotments(
              id,
              mr_user_id,
              doctor_id,
              profiles!mr_doctor_allotments_mr_user_id_fkey(
                name
              )
            )
          ''')
          .eq('id', doctorId)
          .single();

      return Doctor.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch doctor: $e');
    }
  }

  // Get visit logs for a doctor
  Future<List<MRVisitLog>> getDoctorVisitLogs({
    required String doctorId,
    int page = 1,
    int limit = 20,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      dynamic query = _supabase
          .from('mr_visit_logs')
          .select('''
            *,
            profiles!mr_visit_logs_mr_user_id_fkey(
              name
            )
          ''')
          .eq('doctor_id', doctorId)
          .order('visit_date', ascending: false)
          .range((page - 1) * limit, page * limit - 1);

      if (dateFrom != null) {
        query = query.gte('visit_date', dateFrom.toIso8601String());
      }
      if (dateTo != null) {
        query = query.lt('visit_date', dateTo.add(const Duration(days: 1)).toIso8601String());
      }

      final response = await query;
      
      return (response as List)
          .map((log) => MRVisitLog.fromJson(log))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch visit logs: $e');
    }
  }

  // Get doctors summary/statistics
  Future<Map<String, dynamic>> getDoctorsSummary({
    DoctorFilters? filters,
  }) async {
    try {
      dynamic query = _supabase.from('doctors').select('tier, is_active');

      // Apply filters
      if (filters != null) {
        if (filters.tier != null && filters.tier!.isNotEmpty) {
          query = query.eq('tier', filters.tier!);
        }
        if (filters.isActive != null) {
          query = query.eq('is_active', filters.isActive!);
        }
        if (filters.specialty != null && filters.specialty!.isNotEmpty) {
          query = query.ilike('specialty', '%${filters.specialty}%');
        }
        if (filters.dateFrom != null) {
          query = query.gte('created_at', filters.dateFrom!.toIso8601String());
        }
        if (filters.dateTo != null) {
          query = query.lte('created_at', filters.dateTo!.toIso8601String());
        }
      }

      final response = await query;
      final doctors = response as List;

      int totalDoctors = doctors.length;
      int activeDoctors = doctors.where((d) => d['is_active'] == true).length;
      int inactiveDoctors = totalDoctors - activeDoctors;
      int tierA = doctors.where((d) => d['tier'] == 'A').length;
      int tierB = doctors.where((d) => d['tier'] == 'B').length;
      int tierC = doctors.where((d) => d['tier'] == 'C').length;
      int untiered = doctors.where((d) => d['tier'] == null).length;

      return {
        'total_doctors': totalDoctors,
        'active_doctors': activeDoctors,
        'inactive_doctors': inactiveDoctors,
        'tier_a_count': tierA,
        'tier_b_count': tierB,
        'tier_c_count': tierC,
        'untiered_count': untiered,
      };
    } catch (e) {
      throw Exception('Failed to fetch doctors summary: $e');
    }
  }

  // Create a new doctor
  Future<Doctor> createDoctor(Map<String, dynamic> doctorData) async {
    try {
      final response = await _supabase
          .from('doctors')
          .insert(doctorData)
          .select()
          .single();

      return Doctor.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create doctor: $e');
    }
  }

  // Update doctor
  Future<Doctor> updateDoctor(String doctorId, Map<String, dynamic> doctorData) async {
    try {
      doctorData['updated_at'] = DateTime.now().toIso8601String();
      
      final response = await _supabase
          .from('doctors')
          .update(doctorData)
          .eq('id', doctorId)
          .select()
          .single();

      return Doctor.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update doctor: $e');
    }
  }

  // Delete doctor (soft delete by setting is_active to false)
  Future<void> deleteDoctor(String doctorId) async {
    try {
      await _supabase
          .from('doctors')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', doctorId);
    } catch (e) {
      throw Exception('Failed to delete doctor: $e');
    }
  }

  // Get all MR profiles for allotment
  Future<List<Map<String, dynamic>>> getMRProfiles() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('user_id, name')
          .eq('role', 'mr')
          .eq('is_active', true)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch MR profiles: $e');
    }
  }

  // Allot doctor to MR
  Future<void> allotDoctorToMR(String doctorId, String mrUserId) async {
    try {
      // First, remove any existing allotment for this doctor
      await _supabase
          .from('mr_doctor_allotments')
          .delete()
          .eq('doctor_id', doctorId);

      // Then create new allotment
      await _supabase
          .from('mr_doctor_allotments')
          .insert({
            'doctor_id': doctorId,
            'mr_user_id': mrUserId,
          });
    } catch (e) {
      throw Exception('Failed to allot doctor to MR: $e');
    }
  }

  // Remove doctor allotment
  Future<void> removeDoctorAllotment(String doctorId) async {
    try {
      await _supabase
          .from('mr_doctor_allotments')
          .delete()
          .eq('doctor_id', doctorId);
    } catch (e) {
      throw Exception('Failed to remove doctor allotment: $e');
    }
  }

  // Get specialties for filter dropdown
  Future<List<String>> getSpecialties() async {
    try {
      final response = await _supabase
          .from('doctors')
          .select('specialty')
          .not('specialty', 'is', null)
          .order('specialty');

      final specialties = (response as List)
          .map((item) => item['specialty'] as String)
          .toSet()
          .toList();

      return specialties;
    } catch (e) {
      throw Exception('Failed to fetch specialties: $e');
    }
  }

  // Add clinic to doctor
  Future<DoctorClinic> addClinicToDoctor(String doctorId, Map<String, dynamic> clinicData) async {
    try {
      clinicData['doctor_id'] = doctorId;
      
      final response = await _supabase
          .from('doctor_clinics')
          .insert(clinicData)
          .select()
          .single();

      return DoctorClinic.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add clinic: $e');
    }
  }

  // Update clinic
  Future<DoctorClinic> updateClinic(String clinicId, Map<String, dynamic> clinicData) async {
    try {
      clinicData['updated_at'] = DateTime.now().toIso8601String();
      
      final response = await _supabase
          .from('doctor_clinics')
          .update(clinicData)
          .eq('id', clinicId)
          .select()
          .single();

      return DoctorClinic.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update clinic: $e');
    }
  }

  // Delete clinic
  Future<void> deleteClinic(String clinicId) async {
    try {
      await _supabase
          .from('doctor_clinics')
          .delete()
          .eq('id', clinicId);
    } catch (e) {
      throw Exception('Failed to delete clinic: $e');
    }
  }
}