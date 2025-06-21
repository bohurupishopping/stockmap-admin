-- Add location verification fields to mr_visit_logs table
-- This migration adds support for GPS-based visit verification

ALTER TABLE public.mr_visit_logs 
ADD COLUMN is_location_verified BOOLEAN,
ADD COLUMN distance_from_clinic_meters DECIMAL(10, 2);

-- Add comments to document the new fields
COMMENT ON COLUMN public.mr_visit_logs.is_location_verified IS 'Whether the visit was verified to be within the clinic verification radius';
COMMENT ON COLUMN public.mr_visit_logs.distance_from_clinic_meters IS 'Distance in meters from the clinic when the visit was logged';

-- Create an index for performance when querying verified visits
CREATE INDEX idx_mr_visit_logs_location_verified ON public.mr_visit_logs(is_location_verified);