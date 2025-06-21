import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mr_activity_models.dart';

class MRActivityService {
  final _supabase = Supabase.instance.client;

  // Fetch all MR profiles
  Future<List<MRProfile>> fetchMRProfiles() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('user_id, name, email')
          .eq('role', 'mr');

      return (response as List)
          .map((profile) => MRProfile.fromJson({
                'userId': profile['user_id'],
                'name': profile['name'],
                'email': profile['email'],
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch MR profiles: $e');
    }
  }

  // Fetch upcoming visits
  Future<List<UpcomingVisit>> fetchUpcomingVisits({
    String? selectedMR,
    String selectedPeriod = 'week',
  }) async {
    try {
      final endDate = DateTime.now();
      
      late DateTime calculatedEndDate;
      if (selectedPeriod == 'week') {
        calculatedEndDate = endDate.add(const Duration(days: 7));
      } else {
        calculatedEndDate = endDate.add(const Duration(days: 30));
      }

      var query = _supabase
          .from('mr_visit_logs')
          .select('''
            id,
            next_visit_date,
            next_visit_objective,
            visit_date,
            doctors!inner(
              full_name,
              specialty,
              tier,
              clinic_address
            ),
            profiles!inner(
              name,
              user_id
            )
          ''')
          .not('next_visit_date', 'is', null)
          .gte('next_visit_date', DateTime.now().toIso8601String().split('T')[0])
          .lte('next_visit_date', calculatedEndDate.toIso8601String().split('T')[0]);

      if (selectedMR != null && selectedMR != 'all') {
        query = query.eq('mr_user_id', selectedMR);
      }

      final response = await query.order('next_visit_date', ascending: true);

      return (response as List).map((visit) {
        final doctor = visit['doctors'] as Map<String, dynamic>;
        final profile = visit['profiles'] as Map<String, dynamic>;
        
        return UpcomingVisit.fromJson({
          'id': visit['id'],
          'nextVisitDate': visit['next_visit_date'],
          'nextVisitObjective': visit['next_visit_objective'] ?? '',
          'doctorName': doctor['full_name'],
          'doctorSpecialty': doctor['specialty'],
          'doctorTier': doctor['tier'],
          'doctorAddress': doctor['clinic_address'],
          'mrName': profile['name'],
          'mrUserId': profile['user_id'],
          'lastVisitDate': visit['visit_date'],
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming visits: $e');
    }
  }

  // Fetch MR statistics
  Future<List<MRStats>> fetchMRStats({
    List<MRProfile>? mrProfiles,
    String? selectedMR,
  }) async {
    try {
      if (mrProfiles == null || mrProfiles.isEmpty) {
        return [];
      }

      final stats = <MRStats>[];
      
      for (final mr in mrProfiles) {
        if (selectedMR != null && selectedMR != 'all' && mr.userId != selectedMR) {
          continue;
        }

        // Get total doctors allotted
        final totalDoctorsResponse = await _supabase
            .from('mr_doctor_allotments')
            .select('*')
            .eq('mr_user_id', mr.userId)
            .count();
        final totalDoctors = totalDoctorsResponse.count;

        // Get visits this month
        final thisMonthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
        final visitsThisMonthResponse = await _supabase
            .from('mr_visit_logs')
            .select('*')
            .eq('mr_user_id', mr.userId)
            .gte('visit_date', thisMonthStart.toIso8601String())
            .count();
        final visitsThisMonth = visitsThisMonthResponse.count;

        // Get visits last month
        final lastMonthStart = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
        final lastMonthEnd = DateTime(DateTime.now().year, DateTime.now().month, 0);
        final visitsLastMonthResponse = await _supabase
            .from('mr_visit_logs')
            .select('*')
            .eq('mr_user_id', mr.userId)
            .gte('visit_date', lastMonthStart.toIso8601String())
            .lte('visit_date', lastMonthEnd.toIso8601String())
            .count();
        final visitsLastMonth = visitsLastMonthResponse.count;

        // Get tier-wise visits this month
        final tierVisitsResponse = await _supabase
            .from('mr_visit_logs')
            .select('''
              doctors!inner(tier)
            ''')
            .eq('mr_user_id', mr.userId)
            .gte('visit_date', thisMonthStart.toIso8601String());

        final tierVisits = tierVisitsResponse as List;
        final aTierVisits = tierVisits.where((v) => v['doctors']['tier'] == 'A').length;
        final bTierVisits = tierVisits.where((v) => v['doctors']['tier'] == 'B').length;
        final cTierVisits = tierVisits.where((v) => v['doctors']['tier'] == 'C').length;

        // Calculate neglected doctors (no visit in 30+ days)
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        
        final allottedDoctorsResponse = await _supabase
            .from('mr_doctor_allotments')
            .select('''
              doctors!inner(id)
            ''')
            .eq('mr_user_id', mr.userId);

        int neglectedCount = 0;
        final allottedDoctors = allottedDoctorsResponse as List;
        
        for (final allotment in allottedDoctors) {
          final doctorId = allotment['doctors']['id'];
          final recentVisitResponse = await _supabase
              .from('mr_visit_logs')
              .select('visit_date')
              .eq('doctor_id', doctorId)
              .eq('mr_user_id', mr.userId)
              .gte('visit_date', thirtyDaysAgo.toIso8601String())
              .limit(1);
          
          if (recentVisitResponse.isEmpty) {
            neglectedCount++;
          }
        }

        stats.add(MRStats(
          mrUserId: mr.userId,
          mrName: mr.name,
          totalDoctors: totalDoctors,
          visitsThisMonth: visitsThisMonth,
          visitsLastMonth: visitsLastMonth,
          aTierVisits: aTierVisits,
          bTierVisits: bTierVisits,
          cTierVisits: cTierVisits,
          avgVisitsPerDoctor: totalDoctors > 0 
              ? double.parse((visitsThisMonth / totalDoctors).toStringAsFixed(1))
              : 0.0,
          neglectedDoctors: neglectedCount,
        ));
      }

      return stats;
    } catch (e) {
      throw Exception('Failed to fetch MR stats: $e');
    }
  }

  // Fetch neglected doctors
  Future<List<NeglectedDoctor>> fetchNeglectedDoctors({
    String? selectedMR,
  }) async {
    try {

      var query = _supabase
          .from('doctors')
          .select('''
            id,
            full_name,
            specialty,
            tier,
            clinic_address,
            mr_doctor_allotments!inner(
              mr_user_id,
              profiles!inner(name)
            )
          ''');

      if (selectedMR != null && selectedMR != 'all') {
        query = query.eq('mr_doctor_allotments.mr_user_id', selectedMR);
      }

      final doctorsResponse = await query;
      final doctors = doctorsResponse as List;
      final neglected = <NeglectedDoctor>[];

      for (final doctor in doctors) {
        final lastVisitResponse = await _supabase
            .from('mr_visit_logs')
            .select('visit_date')
            .eq('doctor_id', doctor['id'])
            .order('visit_date', ascending: false)
            .limit(1);

        String? lastVisitDate;
        int? daysSinceVisit;
        
        if (lastVisitResponse.isNotEmpty) {
          lastVisitDate = lastVisitResponse.first['visit_date'];
          final lastVisit = DateTime.parse(lastVisitDate!);
          daysSinceVisit = DateTime.now().difference(lastVisit).inDays;
        }

        if (lastVisitDate == null || daysSinceVisit! > 30) {
          final allotments = doctor['mr_doctor_allotments'] as List;
          final mrName = allotments.isNotEmpty 
              ? allotments.first['profiles']['name'] 
              : 'Unknown';

          neglected.add(NeglectedDoctor(
            id: doctor['id'],
            fullName: doctor['full_name'],
            specialty: doctor['specialty'] ?? '',
            tier: doctor['tier'] ?? 'C',
            clinicAddress: doctor['clinic_address'] ?? '',
            mrName: mrName,
            lastVisitDate: lastVisitDate,
            daysSinceVisit: daysSinceVisit,
          ));
        }
      }

      // Sort by tier priority (A first) and then by days since visit
      neglected.sort((a, b) {
        const tierOrder = {'A': 0, 'B': 1, 'C': 2};
        final aTierOrder = tierOrder[a.tier] ?? 2;
        final bTierOrder = tierOrder[b.tier] ?? 2;
        
        if (aTierOrder != bTierOrder) {
          return aTierOrder.compareTo(bTierOrder);
        }
        return (b.daysSinceVisit ?? 999).compareTo(a.daysSinceVisit ?? 999);
      });

      return neglected;
    } catch (e) {
      throw Exception('Failed to fetch neglected doctors: $e');
    }
  }

  // Generate strategic recommendations
  List<StrategicRecommendation> generateRecommendations(List<MRStats> mrStats) {
    final recommendations = <StrategicRecommendation>[];
    
    for (final stat in mrStats) {
      // Check if MR should focus more on A-Tier doctors
      if (stat.aTierVisits < stat.bTierVisits + stat.cTierVisits) {
        recommendations.add(StrategicRecommendation(
          type: 'warning',
          message: '${stat.mrName} should focus more on A-Tier doctors (high potential)',
          mrUserId: stat.mrUserId,
        ));
      }
      
      // Check for low visit frequency
      if (stat.avgVisitsPerDoctor < 2) {
        recommendations.add(StrategicRecommendation(
          type: 'info',
          message: '${stat.mrName} has low visit frequency - consider increasing doctor engagement',
          mrUserId: stat.mrUserId,
        ));
      }
      
      // Check for neglected doctors
      if (stat.neglectedDoctors > 0) {
        recommendations.add(StrategicRecommendation(
          type: 'error',
          message: '${stat.mrName} has ${stat.neglectedDoctors} doctors not visited in 30+ days',
          mrUserId: stat.mrUserId,
        ));
      }
    }
    
    return recommendations;
  }

  // Calculate tier distribution
  List<TierDistribution> calculateTierDistribution(List<MRStats> mrStats) {
    final totalATierVisits = mrStats.fold(0, (sum, stat) => sum + stat.aTierVisits);
    final totalBTierVisits = mrStats.fold(0, (sum, stat) => sum + stat.bTierVisits);
    final totalCTierVisits = mrStats.fold(0, (sum, stat) => sum + stat.cTierVisits);
    final totalAllVisits = totalATierVisits + totalBTierVisits + totalCTierVisits;
    
    return [
      TierDistribution(
        tier: 'A',
        totalVisits: totalATierVisits,
        percentage: totalAllVisits > 0 ? (totalATierVisits / totalAllVisits * 100) : 0,
      ),
      TierDistribution(
        tier: 'B',
        totalVisits: totalBTierVisits,
        percentage: totalAllVisits > 0 ? (totalBTierVisits / totalAllVisits * 100) : 0,
      ),
      TierDistribution(
        tier: 'C',
        totalVisits: totalCTierVisits,
        percentage: totalAllVisits > 0 ? (totalCTierVisits / totalAllVisits * 100) : 0,
      ),
    ];
  }
}