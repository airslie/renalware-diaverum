xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.Patients do
  xml.Patient do
    xml.LastName patient.family_name
    xml.FirstName patient.given_name
    xml.HospitalNumber patient.local_patient_id
    xml.ExternalPatientId patient.nhs_number
    xml.DateOfBirth patient.born_on&.strftime("%Y-%m-%d")
    xml.Sex patient.sex
    xml.ModalityTypeId # not sending
    xml.ModalityTypeDescription # not sending
    xml.PrimaryRenalDiagnosisCodeId # not sending
    xml.PrimaryRenalDiagnosisCodeDescription # not sending
    xml.RaceId # not sending
    xml.RaceDescription # not sending
    xml.Height patient.height_in_cm
    xml.ResponsiblePhysicianID # not sending
    xml.ResponsiblePhysicianLastName # not sending
    xml.ResponsiblePhysicianFirstName # not sending
    xml.FirstDialysis
    xml.FirstRenalDialysis
    xml.StreetAddress
    xml.Postcode
    xml.City
    xml.PatientStatus
  end
end
