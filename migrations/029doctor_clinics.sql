-- Table: doctor_clinics (To store additional practice locations for a doctor)
CREATE TABLE public.doctor_clinics (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    doctor_id UUID NOT NULL REFERENCES public.doctors(id) ON DELETE CASCADE, -- Link back to the doctor
    
    clinic_name TEXT NOT NULL, -- e.g., "Apollo Clinic", "City Center Chamber"
    
    -- Geotagging for this specific clinic
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    
    -- To identify the doctor's main practice location, which corresponds to the details on the doctors table
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- Standard Admin fields
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- OPTIONAL BUT RECOMMENDED: Ensure a doctor can only have one location marked as "primary".
CREATE UNIQUE INDEX one_primary_clinic_per_doctor
ON public.doctor_clinics (doctor_id)
WHERE is_primary = TRUE;

-- Add comments for clarity
COMMENT ON TABLE public.doctor_clinics IS 'Stores multiple clinic/chamber locations for a doctor, primarily for geotagging and naming.';
COMMENT ON COLUMN public.doctor_clinics.is_primary IS 'Flag to identify the location that corresponds to the main address in the doctors table.';