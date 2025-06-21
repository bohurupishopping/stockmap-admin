-- ========= DOCTORS & ALLOTMENT TABLES (The Foundation) =========

-- Table: doctors (The company's master list of all doctors)
CREATE TABLE public.doctors (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    full_name TEXT NOT NULL,
    specialty TEXT,
    clinic_address TEXT,
    phone_number TEXT,
    email TEXT,
    date_of_birth DATE,
    anniversary_date DATE,
    
    -- ADVANCED: For Tiering/Segmentation
    tier CHAR(1) CHECK (tier IN ('A', 'B', 'C')), -- A=High, B=Medium, C=Low Potential
    
    -- ADVANCED: For Geotagging/Map View
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    
    -- Standard Admin fields
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    created_by UUID REFERENCES public.profiles(user_id) ON DELETE SET NULL
);

-- Table: mr_doctor_allotments (Links doctors to MRs)
CREATE TABLE public.mr_doctor_allotments (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    mr_user_id UUID NOT NULL REFERENCES public.profiles(user_id) ON DELETE CASCADE,
    doctor_id UUID NOT NULL REFERENCES public.doctors(id) ON DELETE CASCADE,
    
    -- Ensures a doctor is only allotted to one MR at a time
    CONSTRAINT unique_doctor_allotment UNIQUE (doctor_id) 
);


-- ========= VISIT & INTERACTION LOGS (The Living Document) =========

-- Table: mr_visit_logs (The core timeline of all interactions)
CREATE TABLE public.mr_visit_logs (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    mr_user_id UUID NOT NULL REFERENCES public.profiles(user_id) ON DELETE RESTRICT,
    doctor_id UUID NOT NULL REFERENCES public.doctors(id) ON DELETE RESTRICT,
    visit_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),

    -- What happened during the visit?
    products_detailed JSONB, -- e.g., [{"product_id": "uuid", "name": "Med-X"}]
    feedback_received TEXT,
    samples_provided JSONB, -- e.g., [{"product_id": "uuid", "quantity": 5}]
    
    -- ADVANCED: For Intelligence Gathering
    competitor_activity_notes TEXT,
    prescription_potential_notes TEXT,

    -- ADVANCED: For Smart Scheduling
    next_visit_date DATE,
    next_visit_objective TEXT,
    
    -- Link to sales
    linked_sale_order_id UUID REFERENCES public.mr_sales_orders(id) ON DELETE SET NULL,
    
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);