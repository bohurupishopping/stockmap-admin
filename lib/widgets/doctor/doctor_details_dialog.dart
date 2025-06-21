// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import '../../models/doctor_models.dart';
import '../../models/mr_activity_models.dart';
import '../../services/doctor_service.dart';

// --- Professional Color Palette ---
const Color _primaryColor = Color(0xFF2563EB); // A slightly deeper blue
const Color _scaffoldBgColor = Color(0xFFF8FAFC);
const Color _cardBgColor = Colors.white;
const Color _headingColor = Color(0xFF111827); // Darker for headings
const Color _textColor = Color(0xFF374151); // Softer for body text
const Color _labelColor = Color(0xFF6B7280); // Lighter for labels
const Color _borderColor = Color(0xFFE5E7EB);
const Color _successColor = Color(0xFF059669);

class DoctorDetailsDialog extends StatefulWidget {
  final Doctor doctor;
  final DateFormat dateFormat;
  final VoidCallback onDoctorUpdate;

  const DoctorDetailsDialog({
    super.key,
    required this.doctor,
    required this.dateFormat,
    required this.onDoctorUpdate,
  });

  @override
  State<DoctorDetailsDialog> createState() => _DoctorDetailsDialogState();
}

class _DoctorDetailsDialogState extends State<DoctorDetailsDialog>
    with SingleTickerProviderStateMixin {
  final DoctorService _doctorService = DoctorService();
  late TabController _tabController;

  List<MRVisitLog> _visitLogs = [];
  bool _isLoadingVisits = false;
  String? _visitError;
  
  final Map<String, String> _addressCache = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadVisitLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadVisitLogs() async {
    setState(() {
      _isLoadingVisits = true;
      _visitError = null;
    });

    try {
      final visits = await _doctorService.getDoctorVisitLogs(
        doctorId: widget.doctor.id,
        limit: 10,
      );

      setState(() {
        _visitLogs = visits;
        _isLoadingVisits = false;
      });
    } catch (e) {
      setState(() {
        _visitError = 'Failed to load visit history. Please try again.';
        _isLoadingVisits = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a ConstrainedBox for a larger, responsive dialog
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Scaffold(
            backgroundColor: _scaffoldBgColor,
            body: Column(
              children: [
                _buildHeader(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDetailsTab(),
                      _buildClinicsTab(),
                      _buildVisitHistoryTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: _primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor.fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.doctor.specialty != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      widget.doctor.specialty!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildBadge(widget.doctor.statusDisplay, Colors.white.withOpacity(0.2)),
          if (widget.doctor.tier != null) ...[
            const SizedBox(width: 8),
            _buildBadge('Tier ${widget.doctor.tierDisplay}', Colors.white.withOpacity(0.2)),
          ],
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: _cardBgColor,
        border: Border(bottom: BorderSide(color: _borderColor)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: _primaryColor,
        unselectedLabelColor: _labelColor,
        indicatorColor: _primaryColor,
        indicatorWeight: 3.0,
        tabs: const [
          Tab(text: 'Details'),
          Tab(text: 'Clinics'),
          Tab(text: 'Visit History'),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact grid layout for better space utilization
          _buildCompactInfoGrid(),
          const SizedBox(height: 20),
          _buildSection('System Information', [
            _buildDetailRow(Icons.calendar_today_outlined, 'Created', widget.dateFormat.format(widget.doctor.createdAt)),
            _buildDetailRow(Icons.update_outlined, 'Updated', widget.dateFormat.format(widget.doctor.updatedAt)),
          ]),
        ],
      ),
    );
  }

  Widget _buildClinicsTab() {
    final clinics = widget.doctor.clinics;
    if (clinics == null || clinics.isEmpty) {
      return _buildEmptyState(
        icon: Icons.business_center_outlined,
        message: 'No clinics registered',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: clinics.length,
      itemBuilder: (context, index) => _buildClinicCard(clinics[index]),
    );
  }

  Widget _buildVisitHistoryTab() {
    if (_isLoadingVisits) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_visitError != null) {
      return _buildErrorState(message: _visitError!, onRetry: _loadVisitLogs);
    }
    if (_visitLogs.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history_toggle_off_outlined,
        message: 'No visit history found',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _visitLogs.length,
      itemBuilder: (context, index) => _buildVisitCard(_visitLogs[index]),
    );
  }

  Widget _buildCompactInfoGrid() {
    final items = <Widget>[];
    
    // Contact Information
    if (widget.doctor.phoneNumber != null) {
      items.add(_buildCompactInfoCard(Icons.phone_outlined, 'Phone', widget.doctor.phoneNumber!));
    }
    if (widget.doctor.email != null) {
      items.add(_buildCompactInfoCard(Icons.email_outlined, 'Email', widget.doctor.email!));
    }
    if (widget.doctor.clinicAddress != null) {
      items.add(_buildCompactInfoCard(Icons.location_on_outlined, 'Address', widget.doctor.clinicAddress!));
    }
    
    // Professional Information
    items.add(_buildCompactInfoCard(Icons.medical_services_outlined, 'Specialty', widget.doctor.specialty ?? 'N/A'));
    if (widget.doctor.tier != null) {
      items.add(_buildCompactInfoCard(Icons.star_outline, 'Tier', 'Tier ${widget.doctor.tier}'));
    }
    
    // MR Assignment
    items.add(_buildCompactInfoCard(Icons.person_outline, 'Allotted MR', widget.doctor.allottedMR?.mrName ?? 'Not assigned'));
    
    // Personal Information
    if (widget.doctor.dateOfBirth != null) {
      items.add(_buildCompactInfoCard(Icons.cake_outlined, 'Date of Birth', widget.dateFormat.format(widget.doctor.dateOfBirth!)));
    }
    if (widget.doctor.anniversaryDate != null) {
      items.add(_buildCompactInfoCard(Icons.favorite_outline, 'Anniversary', widget.dateFormat.format(widget.doctor.anniversaryDate!)));
    }
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: items,
    );
  }
  
  Widget _buildCompactInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: _primaryColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: _labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _headingColor)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _cardBgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _borderColor),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: _primaryColor),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 13, color: _labelColor)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicCard(DoctorClinic clinic) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _borderColor),
      ),
      color: _cardBgColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    clinic.clinicName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _headingColor),
                  ),
                ),
                if (clinic.isPrimary)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Primary', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _successColor)),
                  ),
              ],
            ),
            if (clinic.latitude != null && clinic.longitude != null) ...[
              const SizedBox(height: 12),
              _buildLocationInfo(clinic.latitude!, clinic.longitude!),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildLocationInfo(double latitude, double longitude) {
    final coordKey = '${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}';
    
    return FutureBuilder<String>(
      future: _getAddressFromCoordinates(latitude, longitude, coordKey),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coordinates row
            Row(
              children: [
                const Icon(Icons.my_location, size: 14, color: _labelColor),
                const SizedBox(width: 6),
                Text(
                  'Coordinates:',
                  style: const TextStyle(fontSize: 12, color: _labelColor, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12, color: _textColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Address row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 14, color: _labelColor),
                const SizedBox(width: 6),
                Text(
                  'Address:',
                  style: const TextStyle(fontSize: 12, color: _labelColor, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? Row(
                          children: [
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Loading address...',
                              style: TextStyle(fontSize: 12, color: _labelColor, fontStyle: FontStyle.italic),
                            ),
                          ],
                        )
                      : Text(
                          snapshot.data ?? 'Address not available',
                          style: TextStyle(
                            fontSize: 12,
                            color: snapshot.hasError ? Colors.redAccent : _textColor,
                            fontStyle: snapshot.hasError ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  
  Future<String> _getAddressFromCoordinates(double latitude, double longitude, String cacheKey) async {
    // Check cache first
    if (_addressCache.containsKey(cacheKey)) {
      return _addressCache[cacheKey]!;
    }
    
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final addressParts = [
          if (placemark.street?.isNotEmpty == true) placemark.street,
          if (placemark.subLocality?.isNotEmpty == true) placemark.subLocality,
          if (placemark.locality?.isNotEmpty == true) placemark.locality,
          if (placemark.administrativeArea?.isNotEmpty == true) placemark.administrativeArea,
          if (placemark.postalCode?.isNotEmpty == true) placemark.postalCode,
          if (placemark.country?.isNotEmpty == true) placemark.country,
        ].where((part) => part != null && part.isNotEmpty).toList();
        
        final address = addressParts.join(', ');
        _addressCache[cacheKey] = address;
        return address;
      }
    } catch (e) {
      final errorMsg = 'Unable to fetch address';
      _addressCache[cacheKey] = errorMsg;
      return errorMsg;
    }
    
    final fallback = 'Address not available';
    _addressCache[cacheKey] = fallback;
    return fallback;
  }

  Widget _buildVisitCard(MRVisitLog visit) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _borderColor),
      ),
      color: _cardBgColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.dateFormat.format(visit.visitDate),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _headingColor),
                ),
                if (visit.mrName != null)
                  Text(
                    visit.mrName!,
                    style: const TextStyle(fontSize: 14, color: _primaryColor, fontWeight: FontWeight.w500),
                  ) else const SizedBox.shrink(),
              ],
            ),
            const Divider(height: 24, color: _borderColor),
            if (visit.feedbackReceived != null && visit.feedbackReceived!.isNotEmpty)
              Text(
                visit.feedbackReceived!,
                style: const TextStyle(fontSize: 14, color: _textColor, fontStyle: FontStyle.italic),
              )
            else
              const Text(
                'No feedback was recorded for this visit.',
                style: TextStyle(fontSize: 14, color: _labelColor, fontStyle: FontStyle.italic),
              ),
            if (visit.nextVisitDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: _labelColor),
                    const SizedBox(width: 8),
                    Text(
                      'Next visit: ${widget.dateFormat.format(visit.nextVisitDate!)}',
                      style: const TextStyle(fontSize: 12, color: _labelColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: _labelColor.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontSize: 16, color: _labelColor), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState({required String message, required VoidCallback onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontSize: 16, color: Colors.redAccent), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: _primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}