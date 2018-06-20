xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.Patients do
  xml.Patient do
    xml.LastName patient.family_name
    xml.FirstName patient.given_name
    xml.HospitalNumber patient.local_patient_id
    xml.ExternalPatientId patient.nhs_number
  end
end
