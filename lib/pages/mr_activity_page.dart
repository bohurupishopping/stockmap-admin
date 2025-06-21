import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/mr_activity_service.dart';
import '../models/mr_activity_models.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/footer_nav_bar.dart';

class MRActivityPage extends StatefulWidget {
  const MRActivityPage({super.key});

  @override
  State<MRActivityPage> createState() => _MRActivityPageState();
}

class _MRActivityPageState extends State<MRActivityPage>
    with TickerProviderStateMixin {
  final MRActivityService _mrActivityService = MRActivityService();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  
  List<MRProfile> _mrProfiles = [];
  List<UpcomingVisit> _upcomingVisits = [];
  List<MRStats> _mrStats = [];
  List<NeglectedDoctor> _neglectedDoctors = [];
  List<StrategicRecommendation> _recommendations = [];
  List<TierDistribution> _tierDistribution = [];
  
  String _selectedMR = 'all';
  String _selectedPeriod = 'week';
  bool _isLoading = false;
  bool _showFilters = false;
  String? _error;
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadData() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      // Fetch MR profiles first
      final profiles = await _mrActivityService.fetchMRProfiles();
      setState(() {
        _mrProfiles = profiles;
      });
      
      if (profiles.isNotEmpty) {
        // Fetch all other data
        await Future.wait([
          _loadUpcomingVisits(),
          _loadMRStats(),
          _loadNeglectedDoctors(),
        ]);
        
        // Generate recommendations and tier distribution
        setState(() {
          _recommendations = _mrActivityService.generateRecommendations(_mrStats);
          _tierDistribution = _mrActivityService.calculateTierDistribution(_mrStats);
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _loadUpcomingVisits() async {
    try {
      final visits = await _mrActivityService.fetchUpcomingVisits(
        selectedMR: _selectedMR,
        selectedPeriod: _selectedPeriod,
      );
      setState(() {
        _upcomingVisits = visits;
      });
    } catch (e) {
      // Handle error silently for individual components
    }
  }
  
  Future<void> _loadMRStats() async {
    try {
      final stats = await _mrActivityService.fetchMRStats(
        mrProfiles: _mrProfiles,
        selectedMR: _selectedMR,
      );
      setState(() {
        _mrStats = stats;
      });
    } catch (e) {
      // Handle error silently for individual components
    }
  }
  
  Future<void> _loadNeglectedDoctors() async {
    try {
      final neglected = await _mrActivityService.fetchNeglectedDoctors(
        selectedMR: _selectedMR,
      );
      setState(() {
        _neglectedDoctors = neglected;
      });
    } catch (e) {
      // Handle error silently for individual components
    }
  }
  
  void _onFiltersChanged() {
    _loadUpcomingVisits();
    _loadMRStats();
    _loadNeglectedDoctors();
  }
  
  Color _getTierBadgeColor(String tier) {
    switch (tier) {
      case 'A':
        return const Color(0xFFDC2626); // Red
      case 'B':
        return const Color(0xFFF59E0B); // Yellow
      case 'C':
        return const Color(0xFF059669); // Green
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
  
  Color _getPerformanceColor(int current, int previous) {
    if (current > previous) return const Color(0xFF059669); // Green
    if (current < previous) return const Color(0xFFDC2626); // Red
    return const Color(0xFF6B7280); // Gray
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: LoadingOverlay(
                isLoading: _isLoading,
                child: Column(
                  children: [
                    // Error Message
                    if (_error != null) _buildErrorMessage(),
                    
                    // Filters
                    if (_showFilters) _buildFilters(),
                    
                    // Results Summary
                    _buildResultsSummary(),
                    
                    // Tabs Content
                    Expanded(
                      child: Column(
                        children: [
                          _buildTabBar(),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildUpcomingVisitsTab(),
                                _buildMRPerformanceTab(),
                                _buildEngagementAnalysisTab(),
                                _buildNeglectedDoctorsTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavBar(currentRoute: '/dashboard/mr-activity'),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            Color(0xFF334155),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              // Icon and title
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  size: 28,
                  color: Color(0xFF0EA5E9),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'MR Activity & Planning',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Monitor fieldwork and strategic execution',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Filter button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                  icon: Icon(
                    _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Refresh button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: _loadData,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Color(0xFFDC2626)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
          TextButton(
            onPressed: _loadData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: Color(0xFF0EA5E9),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Activity Filters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MR Filter',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedMR,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: 'all',
                          child: Text('All MRs'),
                        ),
                        ..._mrProfiles.map((mr) => DropdownMenuItem(
                              value: mr.userId,
                              child: Text(mr.name),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedMR = value!;
                        });
                        _onFiltersChanged();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Planning Period',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedPeriod,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'week',
                          child: Text('Next 7 Days'),
                        ),
                        DropdownMenuItem(
                          value: 'month',
                          child: Text('Next 30 Days'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPeriod = value!;
                        });
                        _onFiltersChanged();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedMR = 'all';
                    _selectedPeriod = 'week';
                  });
                  _onFiltersChanged();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  foregroundColor: const Color(0xFF64748B),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                icon: const Icon(Icons.clear_all_rounded, size: 18),
                label: const Text(
                  'Clear All',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildResultsSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Showing ${_upcomingVisits.length} planned visits',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF64748B).withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: const Color(0xFF0F172A),
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Upcoming'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Performance'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Engagement'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Neglected'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUpcomingVisitsTab() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: _upcomingVisits.isEmpty
          ? _buildEmptyState(
              icon: Icons.calendar_today_outlined,
              title: 'No upcoming visits scheduled',
              subtitle: 'Try adjusting your filters or planning period',
            )
          : _buildUpcomingVisitsList(),
    );
  }
  
  Widget _buildUpcomingVisitsList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _upcomingVisits.length,
      itemBuilder: (context, index) {
        final visit = _upcomingVisits[index];
        final daysSinceLastVisit = visit.lastVisitDate != null
            ? DateTime.now().difference(DateTime.parse(visit.lastVisitDate!)).inDays
            : null;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64748B).withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF0EA5E9),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visit.doctorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          visit.doctorSpecialty,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getTierBadgeColor(visit.doctorTier).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getTierBadgeColor(visit.doctorTier).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${visit.doctorTier}-Tier',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _getTierBadgeColor(visit.doctorTier),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Color(0xFF0EA5E9),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Next Visit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _dateFormat.format(DateTime.parse(visit.nextVisitDate)),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (daysSinceLastVisit != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: daysSinceLastVisit > 30
                                  ? const Color(0xFFFEF2F2)
                                  : daysSinceLastVisit > 14
                                      ? const Color(0xFFFEFBF2)
                                      : const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: daysSinceLastVisit > 30
                                    ? const Color(0xFFFECACA)
                                    : daysSinceLastVisit > 14
                                        ? const Color(0xFFFED7AA)
                                        : const Color(0xFFBBF7D0),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '$daysSinceLastVisit days ago',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: daysSinceLastVisit > 30
                                    ? const Color(0xFFDC2626)
                                    : daysSinceLastVisit > 14
                                        ? const Color(0xFFD97706)
                                        : const Color(0xFF059669),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (visit.nextVisitObjective != null &&
                        visit.nextVisitObjective!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          visit.nextVisitObjective!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF64748B).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assigned MR',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        visit.mrName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMRPerformanceTab() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: _mrStats.isEmpty
          ? _buildEmptyState(
              icon: Icons.bar_chart,
              title: 'No performance data available',
              subtitle: 'MR performance metrics will appear here',
            )
          : ListView.builder(
              itemCount: _mrStats.length,
              itemBuilder: (context, index) {
                final stat = _mrStats[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF3B82F6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stat.mrName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${stat.totalDoctors} doctors allotted',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${stat.visitsThisMonth}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'visits this month',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'A-Tier',
                              '${stat.aTierVisits}',
                              Colors.red,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'B-Tier',
                              '${stat.bTierVisits}',
                              Colors.yellow,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'C-Tier',
                              '${stat.cTierVisits}',
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'Avg/Doctor',
                              '${stat.avgVisitsPerDoctor}',
                              Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            stat.visitsThisMonth > stat.visitsLastMonth
                                ? Icons.trending_up
                                : stat.visitsThisMonth < stat.visitsLastMonth
                                    ? Icons.trending_down
                                    : Icons.trending_flat,
                            color: _getPerformanceColor(
                              stat.visitsThisMonth,
                              stat.visitsLastMonth,
                            ),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${stat.visitsThisMonth > stat.visitsLastMonth ? '+' : ''}${stat.visitsThisMonth - stat.visitsLastMonth} vs last month',
                            style: TextStyle(
                              fontSize: 14,
                              color: _getPerformanceColor(
                                stat.visitsThisMonth,
                                stat.visitsLastMonth,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (stat.neglectedDoctors > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning,
                                    size: 12,
                                    color: Colors.red[800],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${stat.neglectedDoctors} neglected',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
  
  Widget _buildStatCard(String title, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildEngagementAnalysisTab() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tier Distribution
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Visit Distribution by Tier (This Month)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: _tierDistribution.map((tier) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getTierBadgeColor(tier.tier).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${tier.tier}-Tier',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: _getTierBadgeColor(tier.tier),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${tier.totalVisits}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: tier.percentage / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation(
                                _getTierBadgeColor(tier.tier),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${tier.percentage.toStringAsFixed(1)}% of total visits',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Recommendations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Strategic Recommendations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _recommendations.isEmpty
                      ? _buildEmptyState(
                          icon: Icons.check_circle,
                          title: 'All good!',
                          subtitle: 'No recommendations at this time',
                        )
                      : ListView.builder(
                          itemCount: _recommendations.length,
                          itemBuilder: (context, index) {
                            final rec = _recommendations[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: rec.type == 'error'
                                    ? Colors.red[50]
                                    : rec.type == 'warning'
                                        ? Colors.yellow[50]
                                        : Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: rec.type == 'error'
                                      ? Colors.red[200]!
                                      : rec.type == 'warning'
                                          ? Colors.yellow[200]!
                                          : Colors.blue[200]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: rec.type == 'error'
                                          ? Colors.red[100]
                                          : rec.type == 'warning'
                                              ? Colors.yellow[100]
                                              : Colors.blue[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(
                                      rec.type == 'error'
                                          ? Icons.close
                                          : rec.type == 'warning'
                                              ? Icons.warning
                                              : Icons.check_circle,
                                      size: 16,
                                      color: rec.type == 'error'
                                          ? Colors.red[600]
                                          : rec.type == 'warning'
                                              ? Colors.yellow[600]
                                              : Colors.blue[600],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      rec.message,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNeglectedDoctorsTab() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: _neglectedDoctors.isEmpty
          ? Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 48,
                      color: Colors.green[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Excellent! No neglected doctors found.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All doctors have been visited within the last 30 days.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _neglectedDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _neglectedDoctors[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: doctor.tier == 'A' ? Colors.red[50] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: doctor.tier == 'A'
                          ? Colors.red[200]!
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: doctor.tier == 'A'
                                  ? Colors.red[100]
                                  : doctor.tier == 'B'
                                      ? Colors.yellow[100]
                                      : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              doctor.tier == 'A'
                                  ? 'HIGH'
                                  : doctor.tier == 'B'
                                      ? 'MEDIUM'
                                      : 'LOW',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: doctor.tier == 'A'
                                    ? Colors.red[800]
                                    : doctor.tier == 'B'
                                        ? Colors.yellow[800]
                                        : Colors.grey[800],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTierBadgeColor(doctor.tier).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${doctor.tier}-Tier',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getTierBadgeColor(doctor.tier),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        doctor.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              doctor.clinicAddress,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'MR: ${doctor.mrName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              doctor.lastVisitDate != null
                                  ? '${doctor.daysSinceVisit} days overdue'
                                  : 'Never visited',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (doctor.lastVisitDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Last visit: ${_dateFormat.format(DateTime.parse(doctor.lastVisitDate!))}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
  
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 48,
                color: const Color(0xFF0EA5E9),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}