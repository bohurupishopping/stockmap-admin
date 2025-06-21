// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/doctor_models.dart';

// --- A refined, professional color palette for the list items ---
const Color _primaryAccentColor = Color(0xFF3B82F6);
const Color _cardBackgroundColor = Colors.white;
const Color _titleColor = Color(0xFF111827);
const Color _subtitleColor = Color(0xFF4B5563);
const Color _iconColor = Color(0xFF6B7280);
const Color _borderColor = Color(0xFFF3F4F6); // Lighter border

class DoctorTableRow extends StatelessWidget {
  final Doctor doctor;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  const DoctorTableRow({
    super.key,
    required this.doctor,
    required this.dateFormat,
    required this.onTap,
  });

  // Helper widget for creating consistent info chips
  Widget _buildInfoChip(IconData icon, String text, {Color color = _subtitleColor}) {
    // Don't build a chip for null or empty text
    if (text.isEmpty || text == 'N/A') return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: _iconColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // --- Updated, more subtle Doctor Avatar ---
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _primaryAccentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: _primaryAccentColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // --- Main Content Area ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Name and Status Row ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            doctor.fullName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: _titleColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: doctor.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20), // Pill shape
                          ),
                          child: Text(
                            doctor.statusDisplay,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: doctor.statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // --- Responsive Info Chips using Wrap ---
                    Wrap(
                      spacing: 12.0, // Horizontal space between chips
                      runSpacing: 6.0,  // Vertical space between lines
                      children: [
                        if (doctor.specialty != null)
                          _buildInfoChip(
                            Icons.medical_services_outlined,
                            doctor.specialty!,
                          ),
                        if (doctor.tier != null)
                          _buildInfoChip(
                            Icons.star_outline,
                            'Tier ${doctor.tierDisplay}',
                          ),
                        _buildInfoChip(
                          doctor.allottedMR != null 
                              ? Icons.assignment_ind_outlined 
                              : Icons.person_off_outlined,
                          doctor.allottedMR?.mrName ?? 'No MR',
                        ),
                        if (doctor.visitCount != null && doctor.visitCount! > 0)
                           _buildInfoChip(
                            Icons.visibility_outlined,
                            '${doctor.visitCount} visits',
                          ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // --- Arrow Icon ---
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}