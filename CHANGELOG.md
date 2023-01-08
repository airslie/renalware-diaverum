# Change Log

All notable changes to this project will be documented in
this [changelog](http://keepachangelog.com/en/0.3.0/).
This project adheres to Semantic Versioning.

## Unreleased
### Added
### Changed
### Fixed

## 1.0.15
08-01-2023
### Added
### Changed
- Correct constant names to satisfy zeitwerk loading
### Fixed

## 1.0.14
29-08-2022
### Added
### Changed
- No longer use async (AJ/Wisper) when subscribing to events
### Fixed

## 1.0.13
09-02-2022
### Added
### Changed
- Use nhs_number or local_patient_id for locating Diaverum HD Patients #88
### Fixed

## 1.0.12
07-02-2022
### Added
### Changed
- Switch to using nhs_number for locating Diaverum HD Patients #87
### Fixed

## 1.0.11
03-02-2022
### Added
### Changed
- Ruby 3 compatibility #87
- Use started_at and stopped_at rather than  performed_on + start_time + end_time #87
### Fixed

## 1.0.10
22-11-2019
### Added
### Changed
- Add ability to recreate missing .hl7 path results files for one specific patient
### Fixed

## 1.0.9
19-11-2019
### Added
### Changed
- Remove webpacker depdendency
### Fixed

## 1.0.8
18-11-2019
### Added
- Add a rake task to recreate missing .hl7 path results files
### Changed
### Fixed

## 1.0.7
13-11-2019
### Added
### Changed
### Fixed
- Prefix message_processed event handler with oru_

## 1.0.5
27-08-2019
### Added
- Housekeeping rake task
### Changed
### Fixed

## 1.0.5
06-06-2019
### Added
### Changed
- Set respiratory_rate_measured to :no in HD::Session #48
### Fixed

## 1.0.4
### Added
### Changed
- Set AVF/AVG assessment to 'Not Applicable' in HD Session
- Set MR VICTOR assessment to 'Not Applicable' in HD Session
### Fixed

## 1.0.3
### Added
- Added seed data to make development easier
- Log JournalEntry's that we did not store because their date did not match any Treatment in the file

### Fixed
- Store DNA Session notes

## 1.0.2
### Added
- Call HD::UpdateRollingPatientStatisticsJob after saving a job

### Added
### Changed
- Add a configurable go-live date before which sessions will not be imported.
### Fixed

## 0.1.7
23-10-2018

### Fixed
- Use case-insensitive search when looking up patients by local_patient_id #23

## 0.1.6
18-10-2018

### Added
### Changed
- Detect HD Type in incoming XML #18
