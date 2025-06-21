import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/doctor_models.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Doctor Avatar/Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF6366f1).withValues(alpha: 0.8),
                      const Color(0xFF8b5cf6).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Main Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Status Row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            doctor.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: doctor.statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            doctor.statusDisplay,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: doctor.statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Specialty and Tier Row
                    Row(
                      children: [
                        // Specialty
                        if (doctor.specialty != null)
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.medical_services,
                                  size: 16,
                                  color: const Color(0xFF6366f1),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    doctor.specialty!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6366f1),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(width: 12),
                        
                        // Tier Badge
                        if (doctor.tier != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: doctor.tierColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 12,
                                  color: doctor.tierColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Tier ${doctor.tierDisplay}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: doctor.tierColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // MR Assignment Row
                    Row(
                      children: [
                        Icon(
                          doctor.allottedMR != null ? Icons.person : Icons.person_off,
                          size: 16,
                          color: doctor.allottedMR != null 
                              ? const Color(0xFF059669) 
                              : const Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            doctor.allottedMR?.mrName ?? 'No MR Assigned',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: doctor.allottedMR != null 
                                  ? const Color(0xFF059669) 
                                  : const Color(0xFF6B7280),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Visit Count (if available)
                        if (doctor.visitCount != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.visibility,
                                  size: 12,
                                  color: Color(0xFF3B82F6),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${doctor.visitCount}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF3B82F6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow Icon
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