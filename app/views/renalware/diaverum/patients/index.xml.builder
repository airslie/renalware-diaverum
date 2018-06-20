xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.Patients do
  patients.each do |patient|
    xml.Patient do
      xml.LastName patient.family_name
      xml.FirstName patient.given_name
      xml.HospitalNumber patient.local_patient_id
      xml.ExternalPatientId patient.nhs_number
      xml.link(href: diaverum_patient_path(unit_id: hospital_unit, id: patient))
    end
  end
end


# render "sending_facility", builder: xml, patient: patient
# render "patient", builder: xml, patient: patient
# render "lab_orders", builder: xml, patient: patient
# render "social_histories", builder: xml, patient: patient
# render "family_histories", builder: xml, patient: patient
# render "observations", builder: xml, patient: patient
# render "allergies", builder: xml, patient: patient
# render "diagnoses", builder: xml, patient: patient
# render "medications", builder: xml, patient: patient
# render "documents", builder: xml, patient: patient
# render "encounters", builder: xml, patient: patient
# render "program_memberships", builder: xml, patient: patient
# render "clinical_relationships", builder: xml, patient: patient
# render "surveys", builder: xml, patient: patient
