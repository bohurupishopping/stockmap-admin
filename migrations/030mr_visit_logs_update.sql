-- Add a column to link a visit log to a specific clinic
ALTER TABLE public.mr_visit_logs
ADD COLUMN clinic_id UUID REFERENCES public.doctor_clinics(id) ON DELETE SET NULL;

-- Add a comment for clarity
COMMENT ON COLUMN public.mr_visit_logs.clinic_id IS 'The specific clinic where the visit took place. Can be NULL for virtual calls or if the visit was at the primary location before it was formally added to the doctor_clinics table.';