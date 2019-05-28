# Change Log

All notable changes to this project will be documented in
this [changelog](http://keepachangelog.com/en/0.3.0/).
This project adheres to Semantic Versioning.

## Unreleased
31-10-2018

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
