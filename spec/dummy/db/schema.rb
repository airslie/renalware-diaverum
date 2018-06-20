# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180611152505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "tablefunc"
  enable_extension "btree_gist"
  enable_extension "intarray"

  create_table "access_assessments", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "type_id", null: false
    t.string "side", null: false
    t.date "performed_on", null: false
    t.date "procedure_on"
    t.text "comments"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_access_assessments_on_created_by_id"
    t.index ["document"], name: "index_access_assessments_on_document", using: :gin
    t.index ["patient_id"], name: "index_access_assessments_on_patient_id"
    t.index ["type_id"], name: "index_access_assessments_on_type_id"
    t.index ["updated_by_id"], name: "index_access_assessments_on_updated_by_id"
  end

  create_table "access_catheter_insertion_techniques", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "access_plan_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_access_plan_types_on_deleted_at"
  end

  create_table "access_plans", id: :serial, force: :cascade do |t|
    t.integer "plan_type_id", null: false
    t.text "notes"
    t.integer "patient_id", null: false
    t.integer "decided_by_id"
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "terminated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "patient_id, COALESCE(terminated_at, '1970-01-01 00:00:00'::timestamp without time zone)", name: "access_plan_uniqueness", unique: true
    t.index ["created_by_id"], name: "index_access_plans_on_created_by_id"
    t.index ["decided_by_id"], name: "index_access_plans_on_decided_by_id"
    t.index ["patient_id"], name: "index_access_plans_on_patient_id"
    t.index ["plan_type_id"], name: "index_access_plans_on_plan_type_id"
    t.index ["terminated_at"], name: "index_access_plans_on_terminated_at"
    t.index ["updated_by_id"], name: "index_access_plans_on_updated_by_id"
  end

  create_table "access_procedures", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "type_id", null: false
    t.string "side"
    t.date "performed_on", null: false
    t.boolean "first_procedure"
    t.string "catheter_make"
    t.string "catheter_lot_no"
    t.text "outcome"
    t.text "notes"
    t.date "first_used_on"
    t.date "failed_on"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "performed_by"
    t.integer "pd_catheter_insertion_technique_id"
    t.index ["created_by_id"], name: "index_access_procedures_on_created_by_id"
    t.index ["patient_id"], name: "index_access_procedures_on_patient_id"
    t.index ["pd_catheter_insertion_technique_id"], name: "access_procedure_pd_catheter_tech_idx"
    t.index ["type_id"], name: "index_access_procedures_on_type_id"
    t.index ["updated_by_id"], name: "index_access_procedures_on_updated_by_id"
  end

  create_table "access_profiles", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.date "formed_on", null: false
    t.date "started_on"
    t.date "terminated_on"
    t.integer "type_id", null: false
    t.string "side", null: false
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "decided_by_id"
    t.index ["created_by_id"], name: "index_access_profiles_on_created_by_id"
    t.index ["decided_by_id"], name: "index_access_profiles_on_decided_by_id"
    t.index ["patient_id"], name: "index_access_profiles_on_patient_id"
    t.index ["type_id"], name: "index_access_profiles_on_type_id"
    t.index ["updated_by_id"], name: "index_access_profiles_on_updated_by_id"
  end

  create_table "access_sites", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "access_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviation"
    t.string "rr02_code"
    t.string "rr41_code"
  end

  create_table "access_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "access_versions_type_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "addressable_type", null: false
    t.integer "addressable_id", null: false
    t.string "street_1"
    t.string "street_2"
    t.string "county"
    t.string "town"
    t.string "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "organisation_name"
    t.string "telephone"
    t.string "email"
    t.string "street_3"
    t.integer "country_id"
    t.text "region"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", unique: true
  end

  create_table "admission_admissions", force: :cascade do |t|
    t.bigint "hospital_ward_id", null: false
    t.bigint "patient_id", null: false
    t.date "admitted_on", null: false
    t.string "admission_type", null: false
    t.string "consultant"
    t.bigint "modality_at_admission_id"
    t.text "reason_for_admission", null: false
    t.text "notes"
    t.date "transferred_on"
    t.string "transferred_to"
    t.date "discharged_on"
    t.string "discharge_destination"
    t.string "destination_notes"
    t.text "discharge_summary"
    t.date "summarised_on"
    t.bigint "summarised_by_id"
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admitted_on"], name: "index_admission_admissions_on_admitted_on"
    t.index ["created_by_id"], name: "index_admission_admissions_on_created_by_id"
    t.index ["deleted_at"], name: "index_admission_admissions_on_deleted_at"
    t.index ["discharged_on"], name: "index_admission_admissions_on_discharged_on"
    t.index ["hospital_ward_id"], name: "index_admission_admissions_on_hospital_ward_id"
    t.index ["modality_at_admission_id"], name: "index_admission_admissions_on_modality_at_admission_id"
    t.index ["patient_id"], name: "index_admission_admissions_on_patient_id"
    t.index ["summarised_by_id"], name: "index_admission_admissions_on_summarised_by_id"
    t.index ["updated_by_id"], name: "index_admission_admissions_on_updated_by_id"
  end

  create_table "admission_consult_sites", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_admission_consult_sites_on_name"
  end

  create_table "admission_consults", force: :cascade do |t|
    t.bigint "hospital_ward_id"
    t.bigint "patient_id", null: false
    t.bigint "seen_by_id"
    t.date "started_on"
    t.date "ended_on"
    t.date "decided_on"
    t.date "transferred_on"
    t.string "transfer_priority"
    t.string "aki_risk"
    t.string "consult_type"
    t.string "contact_number"
    t.boolean "requires_aki_nurse", default: false, null: false
    t.text "description"
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "other_site_or_ward"
    t.bigint "consult_site_id"
    t.boolean "rrt", default: false, null: false
    t.index ["consult_site_id"], name: "index_admission_consults_on_consult_site_id"
    t.index ["created_by_id"], name: "index_admission_consults_on_created_by_id"
    t.index ["hospital_ward_id"], name: "index_admission_consults_on_hospital_ward_id"
    t.index ["patient_id"], name: "index_admission_consults_on_patient_id"
    t.index ["seen_by_id"], name: "index_admission_consults_on_seen_by_id"
    t.index ["updated_by_id"], name: "index_admission_consults_on_updated_by_id"
  end

  create_table "admission_request_reasons", force: :cascade do |t|
    t.string "description", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_admission_request_reasons_on_deleted_at"
  end

  create_table "admission_requests", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.integer "reason_id", null: false
    t.bigint "hospital_unit_id"
    t.text "notes"
    t.string "priority", null: false
    t.integer "position", default: 0, null: false
    t.datetime "deleted_at"
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_admission_requests_on_created_by_id"
    t.index ["deleted_at"], name: "index_admission_requests_on_deleted_at"
    t.index ["hospital_unit_id"], name: "index_admission_requests_on_hospital_unit_id"
    t.index ["patient_id", "deleted_at"], name: "index_admission_requests_on_patient_id_and_deleted_at", unique: true
    t.index ["patient_id"], name: "index_admission_requests_on_patient_id"
    t.index ["position"], name: "index_admission_requests_on_position"
    t.index ["reason_id"], name: "index_admission_requests_on_reason_id"
    t.index ["updated_by_id"], name: "index_admission_requests_on_updated_by_id"
  end

  create_table "clinic_appointments", id: :serial, force: :cascade do |t|
    t.datetime "starts_at", null: false
    t.integer "patient_id", null: false
    t.integer "user_id", null: false
    t.integer "clinic_id", null: false
    t.integer "becomes_visit_id"
    t.index ["clinic_id"], name: "index_clinic_appointments_on_clinic_id"
    t.index ["patient_id"], name: "index_clinic_appointments_on_patient_id"
    t.index ["user_id"], name: "index_clinic_appointments_on_user_id"
  end

  create_table "clinic_clinics", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_clinic_clinics_on_user_id"
  end

  create_table "clinic_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "clinic_versions_type_id"
  end

  create_table "clinic_visits", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.date "date", null: false
    t.float "height"
    t.float "weight"
    t.integer "systolic_bp"
    t.integer "diastolic_bp"
    t.string "urine_blood"
    t.string "urine_protein"
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "clinic_id", null: false
    t.time "time"
    t.text "admin_notes"
    t.integer "pulse"
    t.boolean "did_not_attend", default: false, null: false
    t.decimal "temperature", precision: 3, scale: 1
    t.integer "standing_systolic_bp"
    t.integer "standing_diastolic_bp"
    t.index ["clinic_id"], name: "index_clinic_visits_on_clinic_id"
    t.index ["created_by_id"], name: "index_clinic_visits_on_created_by_id"
    t.index ["patient_id"], name: "index_clinic_visits_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinic_visits_on_updated_by_id"
  end

  create_table "clinical_allergies", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.text "description", null: false
    t.datetime "recorded_at", null: false
    t.datetime "deleted_at"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_clinical_allergies_on_created_by_id"
    t.index ["deleted_at"], name: "index_clinical_allergies_on_deleted_at"
    t.index ["patient_id"], name: "index_clinical_allergies_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_allergies_on_updated_by_id"
  end

  create_table "clinical_body_compositions", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "modality_description_id"
    t.date "assessed_on", null: false
    t.decimal "overhydration", precision: 3, scale: 1, null: false
    t.decimal "volume_of_distribution", precision: 4, scale: 1, null: false
    t.decimal "total_body_water", precision: 4, scale: 1, null: false
    t.decimal "extracellular_water", precision: 4, scale: 1, null: false
    t.decimal "intracellular_water", precision: 3, scale: 1, null: false
    t.decimal "lean_tissue_index", precision: 4, scale: 1, null: false
    t.decimal "fat_tissue_index", precision: 4, scale: 1, null: false
    t.decimal "lean_tissue_mass", precision: 4, scale: 1, null: false
    t.decimal "fat_tissue_mass", precision: 4, scale: 1, null: false
    t.decimal "adipose_tissue_mass", precision: 4, scale: 1, null: false
    t.decimal "body_cell_mass", precision: 4, scale: 1, null: false
    t.decimal "quality_of_reading", precision: 6, scale: 3, null: false
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assessor_id", null: false
    t.index ["assessor_id"], name: "index_clinical_body_compositions_on_assessor_id"
    t.index ["created_by_id"], name: "index_clinical_body_compositions_on_created_by_id"
    t.index ["modality_description_id"], name: "index_clinical_body_compositions_on_modality_description_id"
    t.index ["patient_id"], name: "index_clinical_body_compositions_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_body_compositions_on_updated_by_id"
  end

  create_table "clinical_dry_weights", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.float "weight", null: false
    t.date "assessed_on", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assessor_id", null: false
    t.index ["assessor_id"], name: "index_clinical_dry_weights_on_assessor_id"
    t.index ["created_by_id"], name: "index_clinical_dry_weights_on_created_by_id"
    t.index ["patient_id"], name: "index_clinical_dry_weights_on_patient_id"
    t.index ["updated_by_id"], name: "index_clinical_dry_weights_on_updated_by_id"
  end

  create_table "clinical_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_clinical_versions_on_item_type_and_item_id"
  end

  create_table "death_causes", id: :serial, force: :cascade do |t|
    t.integer "code"
    t.string "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "directory_people", id: :serial, force: :cascade do |t|
    t.string "given_name", null: false
    t.string "family_name", null: false
    t.string "title"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_directory_people_on_created_by_id"
    t.index ["updated_by_id"], name: "index_directory_people_on_updated_by_id"
  end

  create_table "drug_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_types_drugs", force: :cascade do |t|
    t.integer "drug_id", null: false
    t.integer "drug_type_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["drug_id", "drug_type_id"], name: "index_drug_types_drugs_on_drug_id_and_drug_type_id", unique: true
  end

  create_table "drugs", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "vmpid"
    t.string "description"
    t.index ["deleted_at"], name: "index_drugs_on_deleted_at"
    t.index ["vmpid"], name: "idx_drugs_vmpid", unique: true
  end

  create_table "event_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "event_class_name"
    t.string "slug"
    t.index ["deleted_at"], name: "index_event_types_on_deleted_at"
    t.index ["slug"], name: "index_event_types_on_slug", unique: true
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.datetime "date_time", null: false
    t.integer "event_type_id"
    t.string "description"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.string "type", null: false
    t.jsonb "document"
    t.index ["created_by_id"], name: "index_events_on_created_by_id"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
    t.index ["patient_id"], name: "index_events_on_patient_id"
    t.index ["type"], name: "index_events_on_type"
    t.index ["updated_by_id"], name: "index_events_on_updated_by_id"
  end

  create_table "feed_file_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.text "prompt", null: false
    t.string "download_url_title"
    t.string "download_url"
    t.string "filename_validation_pattern", default: ".*", null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_feed_file_types_on_name"
  end

  create_table "feed_files", id: :serial, force: :cascade do |t|
    t.integer "file_type_id", null: false
    t.string "location", null: false
    t.integer "status", default: 0, null: false
    t.text "result"
    t.integer "time_taken"
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id"
    t.index ["created_by_id"], name: "index_feed_files_on_created_by_id"
    t.index ["file_type_id"], name: "index_feed_files_on_file_type_id"
    t.index ["updated_by_id"], name: "index_feed_files_on_updated_by_id"
  end

  create_table "feed_messages", id: :serial, force: :cascade do |t|
    t.string "event_code", null: false
    t.string "header_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body_hash"
    t.index ["body_hash"], name: "index_feed_messages_on_body_hash", unique: true
  end

  create_table "hd_cannulation_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_hd_cannulation_types_on_deleted_at"
  end

  create_table "hd_dialysates", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "sodium_content", null: false
    t.string "sodium_content_uom", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "bicarbonate_content", precision: 10, scale: 2
    t.string "bicarbonate_content_uom", default: "mmol/L"
    t.decimal "calcium_content", precision: 10, scale: 2
    t.string "calcium_content_uom", default: "mmol/L"
    t.decimal "glucose_content", precision: 10, scale: 2
    t.string "glucose_content_uom", default: "g/L"
    t.decimal "potassium_content", precision: 10, scale: 2
    t.string "potassium_content_uom", default: "mmol/L"
    t.index ["deleted_at"], name: "index_hd_dialysates_on_deleted_at"
  end

  create_table "hd_dialysers", id: :serial, force: :cascade do |t|
    t.string "group", null: false
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "membrane_surface_area", precision: 10, scale: 2
    t.decimal "membrane_surface_area_coefficient_k0a", precision: 10, scale: 2
  end

  create_table "hd_diaries", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "hospital_unit_id", null: false
    t.integer "master_diary_id"
    t.integer "week_number"
    t.integer "year"
    t.boolean "master", default: false, null: false
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_hd_diaries_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_diaries_on_deleted_at"
    t.index ["hospital_unit_id", "week_number", "year"], name: "index_hd_diaries_on_hospital_unit_id_and_week_number_and_year", unique: true, where: "(master = false)"
    t.index ["hospital_unit_id"], name: "index_hd_diaries_on_hospital_unit_id"
    t.index ["hospital_unit_id"], name: "master_index_hd_diaries_on_hospital_unit_id", unique: true, where: "(master = true)"
    t.index ["master_diary_id"], name: "index_hd_diaries_on_master_diary_id"
    t.index ["type"], name: "index_hd_diaries_on_type"
    t.index ["updated_by_id"], name: "index_hd_diaries_on_updated_by_id"
    t.index ["week_number"], name: "index_hd_diaries_on_week_number"
    t.index ["year"], name: "index_hd_diaries_on_year"
  end

  create_table "hd_diary_slots", force: :cascade do |t|
    t.integer "diary_id", null: false
    t.integer "station_id", null: false
    t.integer "day_of_week", null: false
    t.integer "diurnal_period_code_id", null: false
    t.bigint "patient_id", null: false
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "archived", default: false, null: false
    t.datetime "archived_at"
    t.index ["archived"], name: "index_hd_diary_slots_on_archived"
    t.index ["created_by_id"], name: "index_hd_diary_slots_on_created_by_id"
    t.index ["day_of_week"], name: "index_hd_diary_slots_on_day_of_week"
    t.index ["deleted_at"], name: "index_hd_diary_slots_on_deleted_at"
    t.index ["diary_id", "day_of_week", "diurnal_period_code_id", "patient_id"], name: "hd_diary_slots_unique_by_day_period_patient", unique: true, where: "(deleted_at IS NULL)"
    t.index ["diary_id", "diurnal_period_code_id", "day_of_week", "patient_id"], name: "idx_unique_diaryslot_patients", unique: true
    t.index ["diary_id", "station_id", "day_of_week", "diurnal_period_code_id"], name: "hd_diary_slots_unique_by_station_day_period", unique: true, where: "(deleted_at IS NULL)"
    t.index ["diary_id"], name: "index_hd_diary_slots_on_diary_id"
    t.index ["diurnal_period_code_id"], name: "index_hd_diary_slots_on_diurnal_period_code_id"
    t.index ["patient_id"], name: "index_hd_diary_slots_on_patient_id"
    t.index ["station_id"], name: "index_hd_diary_slots_on_station_id"
    t.index ["updated_by_id"], name: "index_hd_diary_slots_on_updated_by_id"
  end

  create_table "hd_diurnal_period_codes", force: :cascade do |t|
    t.string "code", null: false
    t.text "description"
    t.index ["code"], name: "index_hd_diurnal_period_codes_on_code", unique: true
  end

  create_table "hd_patient_statistics", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "hospital_unit_id", null: false
    t.integer "month"
    t.integer "year"
    t.boolean "rolling"
    t.decimal "pre_mean_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "pre_mean_diastolic_blood_pressure", precision: 10, scale: 2
    t.decimal "post_mean_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "post_mean_diastolic_blood_pressure", precision: 10, scale: 2
    t.decimal "lowest_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "highest_systolic_blood_pressure", precision: 10, scale: 2
    t.decimal "mean_fluid_removal", precision: 10, scale: 2
    t.decimal "mean_weight_loss", precision: 10, scale: 2
    t.decimal "mean_machine_ktv", precision: 10, scale: 2
    t.decimal "mean_blood_flow", precision: 10, scale: 2
    t.decimal "mean_litres_processed", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "session_count", default: 0, null: false
    t.integer "number_of_missed_sessions"
    t.integer "dialysis_minutes_shortfall"
    t.decimal "dialysis_minutes_shortfall_percentage", precision: 10, scale: 2
    t.decimal "mean_ufr", precision: 10, scale: 2
    t.decimal "mean_weight_loss_as_percentage_of_body_weight", precision: 10, scale: 2
    t.integer "number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct"
    t.jsonb "pathology_snapshot", default: {}, null: false
    t.index ["hospital_unit_id"], name: "index_hd_patient_statistics_on_hospital_unit_id"
    t.index ["month"], name: "index_hd_patient_statistics_on_month"
    t.index ["patient_id", "month", "year"], name: "index_hd_patient_statistics_on_patient_id_and_month_and_year", unique: true
    t.index ["patient_id", "rolling"], name: "index_hd_patient_statistics_on_patient_id_and_rolling", unique: true
    t.index ["patient_id"], name: "index_hd_patient_statistics_on_patient_id"
    t.index ["rolling"], name: "index_hd_patient_statistics_on_rolling"
    t.index ["year"], name: "index_hd_patient_statistics_on_year"
  end

  create_table "hd_preference_sets", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "hospital_unit_id"
    t.string "other_schedule"
    t.date "entered_on"
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "schedule_definition_id"
    t.index ["created_by_id"], name: "index_hd_preference_sets_on_created_by_id"
    t.index ["hospital_unit_id"], name: "index_hd_preference_sets_on_hospital_unit_id"
    t.index ["patient_id"], name: "index_hd_preference_sets_on_patient_id"
    t.index ["schedule_definition_id"], name: "index_hd_preference_sets_on_schedule_definition_id"
    t.index ["updated_by_id"], name: "index_hd_preference_sets_on_updated_by_id"
  end

  create_table "hd_prescription_administrations", id: :serial, force: :cascade do |t|
    t.integer "hd_session_id", null: false
    t.integer "prescription_id", null: false
    t.boolean "administered"
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_hd_prescription_administrations_on_created_by_id"
    t.index ["hd_session_id"], name: "index_hd_prescription_administrations_on_hd_session_id"
    t.index ["prescription_id"], name: "index_hd_prescription_administrations_on_prescription_id"
    t.index ["updated_by_id"], name: "index_hd_prescription_administrations_on_updated_by_id"
  end

  create_table "hd_profiles", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "hospital_unit_id"
    t.string "other_schedule"
    t.integer "prescribed_time"
    t.date "prescribed_on"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prescriber_id"
    t.integer "named_nurse_id"
    t.integer "transport_decider_id"
    t.datetime "deactivated_at"
    t.boolean "active", default: true
    t.integer "schedule_definition_id"
    t.bigint "dialysate_id"
    t.index ["active", "patient_id"], name: "index_hd_profiles_on_active_and_patient_id", unique: true
    t.index ["created_by_id"], name: "index_hd_profiles_on_created_by_id"
    t.index ["deactivated_at"], name: "index_hd_profiles_on_deactivated_at"
    t.index ["dialysate_id"], name: "index_hd_profiles_on_dialysate_id"
    t.index ["document"], name: "index_hd_profiles_on_document", using: :gin
    t.index ["hospital_unit_id"], name: "index_hd_profiles_on_hospital_unit_id"
    t.index ["named_nurse_id"], name: "index_hd_profiles_on_named_nurse_id"
    t.index ["patient_id"], name: "index_hd_profiles_on_patient_id"
    t.index ["prescriber_id"], name: "index_hd_profiles_on_prescriber_id"
    t.index ["schedule_definition_id"], name: "index_hd_profiles_on_schedule_definition_id"
    t.index ["transport_decider_id"], name: "index_hd_profiles_on_transport_decider_id"
    t.index ["updated_by_id"], name: "index_hd_profiles_on_updated_by_id"
  end

  create_table "hd_schedule_definitions", force: :cascade do |t|
    t.integer "days", default: [], null: false, array: true
    t.integer "diurnal_period_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["days"], name: "index_hd_schedule_definitions_on_days", using: :gin
    t.index ["diurnal_period_id", "days"], name: "days_array_unique_scoped_to_period", using: :gist
    t.index ["diurnal_period_id"], name: "index_hd_schedule_definitions_on_diurnal_period_id"
  end

  create_table "hd_sessions", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "hospital_unit_id"
    t.integer "modality_description_id"
    t.date "performed_on", null: false
    t.time "start_time"
    t.time "end_time"
    t.integer "duration"
    t.text "notes"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "signed_on_by_id"
    t.integer "signed_off_by_id"
    t.string "type", null: false
    t.datetime "signed_off_at"
    t.integer "profile_id"
    t.integer "dry_weight_id"
    t.bigint "dialysate_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.bigint "external_id"
    t.index ["created_by_id"], name: "index_hd_sessions_on_created_by_id"
    t.index ["dialysate_id"], name: "index_hd_sessions_on_dialysate_id"
    t.index ["document"], name: "index_hd_sessions_on_document", using: :gin
    t.index ["dry_weight_id"], name: "index_hd_sessions_on_dry_weight_id"
    t.index ["hospital_unit_id"], name: "index_hd_sessions_on_hospital_unit_id"
    t.index ["id", "type"], name: "index_hd_sessions_on_id_and_type"
    t.index ["modality_description_id"], name: "index_hd_sessions_on_modality_description_id"
    t.index ["patient_id"], name: "index_hd_sessions_on_patient_id"
    t.index ["performed_on"], name: "index_hd_sessions_on_performed_on"
    t.index ["profile_id"], name: "index_hd_sessions_on_profile_id"
    t.index ["signed_off_at"], name: "index_hd_sessions_on_signed_off_at"
    t.index ["signed_off_by_id"], name: "index_hd_sessions_on_signed_off_by_id"
    t.index ["signed_on_by_id"], name: "index_hd_sessions_on_signed_on_by_id"
    t.index ["type"], name: "index_hd_sessions_on_type"
    t.index ["updated_by_id"], name: "index_hd_sessions_on_updated_by_id"
    t.index ["uuid"], name: "index_hd_sessions_on_uuid"
  end

  create_table "hd_station_locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "colour", null: false
    t.index ["name"], name: "index_hd_station_locations_on_name"
  end

  create_table "hd_stations", force: :cascade do |t|
    t.bigint "hospital_unit_id", null: false
    t.integer "position", default: 0, null: false
    t.string "name"
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.index ["created_by_id"], name: "index_hd_stations_on_created_by_id"
    t.index ["deleted_at"], name: "index_hd_stations_on_deleted_at"
    t.index ["hospital_unit_id"], name: "index_hd_stations_on_hospital_unit_id"
    t.index ["position"], name: "index_hd_stations_on_position"
    t.index ["updated_by_id"], name: "index_hd_stations_on_updated_by_id"
  end

  create_table "hd_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "hd_versions_type_id"
  end

  create_table "hospital_centres", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "location"
    t.boolean "active"
    t.boolean "is_transplant_site", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_hospital_centres_on_code"
  end

  create_table "hospital_units", id: :serial, force: :cascade do |t|
    t.integer "hospital_centre_id", null: false
    t.string "name", null: false
    t.string "unit_code", null: false
    t.string "renal_registry_code", null: false
    t.string "unit_type", null: false
    t.boolean "is_hd_site", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hospital_centre_id"], name: "index_hospital_units_on_hospital_centre_id"
  end

  create_table "hospital_wards", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "hospital_unit_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["hospital_unit_id"], name: "index_hospital_wards_on_hospital_unit_id"
    t.index ["name", "hospital_unit_id"], name: "index_hospital_wards_on_name_and_hospital_unit_id", unique: true, where: "(deleted_at IS NOT NULL)"
  end

  create_table "letter_archives", id: :serial, force: :cascade do |t|
    t.text "content", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "letter_id", null: false
    t.index ["created_by_id"], name: "index_letter_archives_on_created_by_id"
    t.index ["letter_id"], name: "index_letter_archives_on_letter_id"
    t.index ["updated_by_id"], name: "index_letter_archives_on_updated_by_id"
  end

  create_table "letter_contact_descriptions", id: :serial, force: :cascade do |t|
    t.string "system_code", null: false
    t.string "name", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_letter_contact_descriptions_on_name", unique: true
    t.index ["position"], name: "index_letter_contact_descriptions_on_position", unique: true
    t.index ["system_code"], name: "index_letter_contact_descriptions_on_system_code", unique: true
  end

  create_table "letter_contacts", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_cc", default: false, null: false
    t.integer "description_id", null: false
    t.string "other_description"
    t.text "notes"
    t.index ["description_id"], name: "index_letter_contacts_on_description_id"
    t.index ["person_id", "patient_id"], name: "index_letter_contacts_on_person_id_and_patient_id", unique: true
  end

  create_table "letter_descriptions", id: :serial, force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "letter_electronic_receipts", force: :cascade do |t|
    t.bigint "letter_id", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["letter_id"], name: "index_letter_electronic_receipts_on_letter_id"
    t.index ["read_at"], name: "index_letter_electronic_receipts_on_read_at"
    t.index ["recipient_id"], name: "index_letter_electronic_receipts_on_recipient_id"
  end

  create_table "letter_letterheads", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "site_code", null: false
    t.string "unit_info", null: false
    t.string "trust_name", null: false
    t.string "trust_caption", null: false
    t.text "site_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "include_pathology_in_letter_body", default: true
  end

  create_table "letter_letters", id: :serial, force: :cascade do |t|
    t.string "event_type"
    t.integer "event_id"
    t.integer "patient_id"
    t.string "type", null: false
    t.date "issued_on", null: false
    t.string "description"
    t.string "salutation"
    t.text "body"
    t.text "notes"
    t.datetime "signed_at"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "letterhead_id", null: false
    t.integer "author_id", null: false
    t.boolean "clinical"
    t.string "enclosures"
    t.datetime "pathology_timestamp"
    t.jsonb "pathology_snapshot", default: {}
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.datetime "submitted_for_approval_at"
    t.bigint "submitted_for_approval_by_id"
    t.datetime "approved_at"
    t.bigint "approved_by_id"
    t.datetime "completed_at"
    t.bigint "completed_by_id"
    t.index ["approved_by_id"], name: "index_letter_letters_on_approved_by_id"
    t.index ["author_id"], name: "index_letter_letters_on_author_id"
    t.index ["completed_by_id"], name: "index_letter_letters_on_completed_by_id"
    t.index ["created_by_id"], name: "index_letter_letters_on_created_by_id"
    t.index ["event_type", "event_id"], name: "index_letter_letters_on_event_type_and_event_id"
    t.index ["id", "type"], name: "index_letter_letters_on_id_and_type"
    t.index ["letterhead_id"], name: "index_letter_letters_on_letterhead_id"
    t.index ["patient_id"], name: "index_letter_letters_on_patient_id"
    t.index ["submitted_for_approval_by_id"], name: "index_letter_letters_on_submitted_for_approval_by_id"
    t.index ["updated_by_id"], name: "index_letter_letters_on_updated_by_id"
    t.index ["uuid"], name: "index_letter_letters_on_uuid"
  end

  create_table "letter_recipients", id: :serial, force: :cascade do |t|
    t.string "role", null: false
    t.string "person_role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "letter_id", null: false
    t.string "addressee_type"
    t.integer "addressee_id"
    t.datetime "emailed_at"
    t.datetime "printed_at"
    t.index ["addressee_type", "addressee_id"], name: "index_letter_recipients_on_addressee_type_and_addressee_id"
    t.index ["letter_id"], name: "index_letter_recipients_on_letter_id"
  end

  create_table "letter_signatures", id: :serial, force: :cascade do |t|
    t.datetime "signed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "letter_id", null: false
    t.integer "user_id", null: false
    t.index ["letter_id"], name: "index_letter_signatures_on_letter_id"
    t.index ["user_id"], name: "index_letter_signatures_on_user_id"
  end

  create_table "low_clearance_profiles", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.jsonb "document"
    t.bigint "updated_by_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_low_clearance_profiles_on_created_by_id"
    t.index ["document"], name: "index_low_clearance_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_low_clearance_profiles_on_patient_id", unique: true
    t.index ["updated_by_id"], name: "index_low_clearance_profiles_on_updated_by_id"
  end

  create_table "low_clearance_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_low_clearance_versions_on_item_type_and_item_id"
  end

  create_table "medication_prescription_terminations", id: :serial, force: :cascade do |t|
    t.date "terminated_on", null: false
    t.text "notes"
    t.integer "prescription_id", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_medication_prescription_terminations_on_created_by_id"
    t.index ["prescription_id"], name: "index_medication_prescription_terminations_on_prescription_id"
    t.index ["updated_by_id"], name: "index_medication_prescription_terminations_on_updated_by_id"
  end

  create_table "medication_prescription_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_medication_prescription_versions_on_item_type_and_item_id"
  end

  create_table "medication_prescriptions", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "drug_id", null: false
    t.string "treatable_type", null: false
    t.integer "treatable_id", null: false
    t.string "dose_amount", null: false
    t.string "dose_unit", null: false
    t.integer "medication_route_id", null: false
    t.string "route_description"
    t.string "frequency", null: false
    t.text "notes"
    t.date "prescribed_on", null: false
    t.integer "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.boolean "administer_on_hd", default: false, null: false
    t.date "last_delivery_date"
    t.index ["created_by_id"], name: "index_medication_prescriptions_on_created_by_id"
    t.index ["drug_id", "patient_id"], name: "index_medication_prescriptions_on_drug_id_and_patient_id"
    t.index ["drug_id"], name: "index_medication_prescriptions_on_drug_id"
    t.index ["medication_route_id"], name: "index_medication_prescriptions_on_medication_route_id"
    t.index ["patient_id", "medication_route_id"], name: "idx_mp_patient_id_medication_route_id"
    t.index ["patient_id"], name: "index_medication_prescriptions_on_patient_id"
    t.index ["treatable_id", "treatable_type"], name: "idx_medication_prescriptions_type"
    t.index ["updated_by_id"], name: "index_medication_prescriptions_on_updated_by_id"
  end

  create_table "medication_routes", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rr_code"
  end

  create_table "messaging_messages", force: :cascade do |t|
    t.text "body", null: false
    t.string "subject", null: false
    t.boolean "urgent", default: false, null: false
    t.datetime "sent_at", null: false
    t.bigint "patient_id", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "replying_to_message_id"
    t.string "type", null: false
    t.index ["author_id"], name: "index_messaging_messages_on_author_id"
    t.index ["patient_id"], name: "index_messaging_messages_on_patient_id"
    t.index ["subject"], name: "index_messaging_messages_on_subject"
    t.index ["type"], name: "index_messaging_messages_on_type"
  end

  create_table "messaging_receipts", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at"
    t.index ["message_id"], name: "index_messaging_receipts_on_message_id"
    t.index ["read_at"], name: "index_messaging_receipts_on_read_at"
    t.index ["recipient_id"], name: "index_messaging_receipts_on_recipient_id"
  end

  create_table "modality_descriptions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_modality_descriptions_on_deleted_at"
    t.index ["id", "type"], name: "index_modality_descriptions_on_id_and_type"
  end

  create_table "modality_modalities", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "description_id", null: false
    t.integer "reason_id"
    t.string "modal_change_type"
    t.text "notes"
    t.date "started_on", null: false
    t.date "ended_on"
    t.string "state", default: "current", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_modality_modalities_on_created_by_id"
    t.index ["description_id"], name: "index_modality_modalities_on_description_id"
    t.index ["patient_id", "description_id"], name: "index_modality_modalities_on_patient_id_and_description_id"
    t.index ["patient_id"], name: "index_modality_modalities_on_patient_id"
    t.index ["reason_id"], name: "index_modality_modalities_on_reason_id"
    t.index ["state"], name: "index_modality_modalities_on_state"
    t.index ["updated_by_id"], name: "index_modality_modalities_on_updated_by_id"
  end

  create_table "modality_reasons", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "rr_code"
    t.string "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "type"], name: "index_modality_reasons_on_id_and_type"
  end

  create_table "pathology_current_observation_sets", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.jsonb "values", default: {}
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["patient_id"], name: "index_pathology_current_observation_sets_on_patient_id", unique: true
    t.index ["values"], name: "index_pathology_current_observation_sets_on_values", using: :gin
  end

  create_table "pathology_labs", id: :serial, force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "pathology_measurement_units", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.index ["name"], name: "index_pathology_measurement_units_on_name", unique: true
  end

  create_table "pathology_observation_descriptions", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.integer "measurement_unit_id"
    t.string "loinc_code"
    t.integer "display_group"
    t.integer "display_order"
    t.integer "letter_group"
    t.integer "letter_order"
    t.index ["code"], name: "index_pathology_observation_descriptions_on_code", unique: true
    t.index ["display_group", "display_order"], name: "obx_unique_display_grouping"
    t.index ["letter_group", "letter_order"], name: "obx_unique_letter_grouping"
  end

  create_table "pathology_observation_requests", id: :serial, force: :cascade do |t|
    t.string "requestor_order_number"
    t.string "requestor_name", null: false
    t.datetime "requested_at", null: false
    t.integer "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "description_id", null: false
    t.index ["description_id"], name: "index_pathology_observation_requests_on_description_id"
    t.index ["patient_id"], name: "index_pathology_observation_requests_on_patient_id"
    t.index ["requested_at"], name: "index_pathology_observation_requests_on_requested_at"
    t.index ["requestor_order_number"], name: "index_pathology_observation_requests_on_requestor_order_number"
  end

  create_table "pathology_observations", id: :serial, force: :cascade do |t|
    t.string "result", null: false
    t.text "comment"
    t.datetime "observed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "description_id", null: false
    t.integer "request_id", null: false
    t.boolean "cancelled"
    t.index ["description_id"], name: "index_pathology_observations_on_description_id"
    t.index ["observed_at"], name: "index_pathology_observations_on_observed_at"
    t.index ["request_id"], name: "index_pathology_observations_on_request_id"
  end

  create_table "pathology_request_descriptions", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.integer "required_observation_description_id"
    t.integer "expiration_days", default: 0, null: false
    t.integer "lab_id", null: false
    t.string "bottle_type"
    t.index ["code"], name: "index_pathology_request_descriptions_on_code", unique: true
    t.index ["lab_id"], name: "index_pathology_request_descriptions_on_lab_id"
    t.index ["required_observation_description_id"], name: "prd_required_observation_description_id_idx"
  end

  create_table "pathology_request_descriptions_requests_requests", id: :serial, force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "request_description_id", null: false
    t.index ["request_description_id"], name: "prdr_requests_description_id_idx"
    t.index ["request_id"], name: "prdr_requests_request_id_idx"
  end

  create_table "pathology_requests_drug_categories", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_pathology_requests_drug_categories_on_name"
  end

  create_table "pathology_requests_drugs_drug_categories", id: :serial, force: :cascade do |t|
    t.integer "drug_id", null: false
    t.integer "drug_category_id", null: false
    t.index ["drug_category_id"], name: "prddc_drug_category_id_idx"
    t.index ["drug_id"], name: "index_pathology_requests_drugs_drug_categories_on_drug_id"
  end

  create_table "pathology_requests_global_rule_sets", id: :serial, force: :cascade do |t|
    t.integer "request_description_id", null: false
    t.string "frequency_type", null: false
    t.integer "clinic_id"
    t.index ["clinic_id"], name: "index_pathology_requests_global_rule_sets_on_clinic_id"
    t.index ["request_description_id"], name: "prddc_request_description_id_idx"
  end

  create_table "pathology_requests_global_rules", id: :serial, force: :cascade do |t|
    t.integer "rule_set_id"
    t.string "type"
    t.string "param_id"
    t.string "param_comparison_operator"
    t.string "param_comparison_value"
    t.string "rule_set_type", null: false
    t.index ["id", "type"], name: "index_pathology_requests_global_rules_on_id_and_type"
    t.index ["rule_set_id", "rule_set_type"], name: "prgr_rule_set_id_and_rule_set_type_idx"
  end

  create_table "pathology_requests_patient_rules", id: :serial, force: :cascade do |t|
    t.text "test_description"
    t.integer "sample_number_bottles"
    t.string "sample_type"
    t.string "frequency_type"
    t.integer "patient_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "lab_id"
    t.index ["lab_id"], name: "index_pathology_requests_patient_rules_on_lab_id"
    t.index ["patient_id"], name: "index_pathology_requests_patient_rules_on_patient_id"
  end

  create_table "pathology_requests_patient_rules_requests", id: :serial, force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "patient_rule_id", null: false
    t.index ["patient_rule_id"], name: "prprr_patient_rule_id_idx"
    t.index ["request_id"], name: "index_pathology_requests_patient_rules_requests_on_request_id"
  end

  create_table "pathology_requests_requests", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "clinic_id", null: false
    t.integer "consultant_id", null: false
    t.string "telephone", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "template", null: false
    t.boolean "high_risk", null: false
    t.index ["clinic_id"], name: "index_pathology_requests_requests_on_clinic_id"
    t.index ["consultant_id"], name: "index_pathology_requests_requests_on_consultant_id"
    t.index ["created_by_id"], name: "index_pathology_requests_requests_on_created_by_id"
    t.index ["patient_id"], name: "index_pathology_requests_requests_on_patient_id"
    t.index ["updated_by_id"], name: "index_pathology_requests_requests_on_updated_by_id"
  end

  create_table "patient_alerts", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.text "notes"
    t.boolean "urgent", default: false, null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_patient_alerts_on_created_by_id"
    t.index ["deleted_at"], name: "index_patient_alerts_on_deleted_at"
    t.index ["patient_id"], name: "index_patient_alerts_on_patient_id"
    t.index ["updated_by_id"], name: "index_patient_alerts_on_updated_by_id"
  end

  create_table "patient_bookmarks", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.boolean "urgent", default: false, null: false
    t.datetime "deleted_at"
    t.string "tags"
    t.index "patient_id, user_id, COALESCE(deleted_at, '1970-01-01 00:00:00'::timestamp without time zone)", name: "patient_bookmarks_uniqueness", unique: true
    t.index ["deleted_at"], name: "index_patient_bookmarks_on_deleted_at", where: "(deleted_at IS NULL)"
    t.index ["patient_id"], name: "index_patient_bookmarks_on_patient_id"
  end

  create_table "patient_ethnicities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cfh_name"
    t.string "rr18_code"
  end

  create_table "patient_languages", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.index ["code"], name: "index_patient_languages_on_code", unique: true
  end

  create_table "patient_practice_memberships", id: :serial, force: :cascade do |t|
    t.integer "practice_id", null: false
    t.integer "primary_care_physician_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_patient_practice_memberships_on_deleted_at"
    t.index ["practice_id", "primary_care_physician_id"], name: "idx_practice_membership", unique: true
    t.index ["practice_id"], name: "index_patient_practice_memberships_on_practice_id"
    t.index ["primary_care_physician_id"], name: "index_patient_practice_memberships_on_primary_care_physician_id"
  end

  create_table "patient_practices", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "telephone"
    t.index ["code"], name: "index_patient_practices_on_code", unique: true
    t.index ["deleted_at"], name: "index_patient_practices_on_deleted_at"
  end

  create_table "patient_primary_care_physicians", id: :serial, force: :cascade do |t|
    t.string "given_name"
    t.string "family_name"
    t.string "code"
    t.string "practitioner_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "telephone"
    t.datetime "deleted_at"
    t.string "name"
    t.index ["code"], name: "index_patient_primary_care_physicians_on_code", unique: true
    t.index ["deleted_at"], name: "index_patient_primary_care_physicians_on_deleted_at"
    t.index ["name"], name: "index_patient_primary_care_physicians_on_name"
  end

  create_table "patient_religions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "patient_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "patient_versions_versions_type_id"
  end

  create_table "patient_worries", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "updated_by_id", null: false
    t.integer "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["created_by_id"], name: "index_patient_worries_on_created_by_id"
    t.index ["patient_id"], name: "index_patient_worries_on_patient_id", unique: true
    t.index ["updated_by_id"], name: "index_patient_worries_on_updated_by_id"
  end

  create_table "patients", id: :serial, force: :cascade do |t|
    t.string "nhs_number"
    t.string "local_patient_id"
    t.string "family_name", null: false
    t.string "given_name", null: false
    t.date "born_on", null: false
    t.boolean "paediatric_patient_indicator"
    t.string "sex"
    t.integer "ethnicity_id"
    t.string "hospital_centre_code"
    t.string "primary_esrf_centre"
    t.date "died_on"
    t.integer "first_cause_id"
    t.integer "second_cause_id"
    t.text "death_notes"
    t.boolean "cc_on_all_letters", default: true
    t.date "cc_decision_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "practice_id"
    t.integer "primary_care_physician_id"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.string "title"
    t.string "suffix"
    t.string "marital_status"
    t.string "telephone1"
    t.string "telephone2"
    t.string "email"
    t.jsonb "document"
    t.integer "religion_id"
    t.integer "language_id"
    t.string "allergy_status", default: "unrecorded", null: false
    t.datetime "allergy_status_updated_at"
    t.string "local_patient_id_2"
    t.string "local_patient_id_3"
    t.string "local_patient_id_4"
    t.string "local_patient_id_5"
    t.string "external_patient_id"
    t.boolean "send_to_renalreg", default: false, null: false
    t.boolean "send_to_rpv", default: false, null: false
    t.date "renalreg_decision_on"
    t.date "rpv_decision_on"
    t.string "renalreg_recorded_by"
    t.string "rpv_recorded_by"
    t.uuid "ukrdc_external_id", default: -> { "uuid_generate_v4()" }, null: false
    t.integer "country_of_birth_id"
    t.integer "legacy_patient_id"
    t.uuid "secure_id", default: -> { "uuid_generate_v4()" }, null: false
    t.datetime "sent_to_ukrdc_at"
    t.index ["created_by_id"], name: "index_patients_on_created_by_id"
    t.index ["document"], name: "index_patients_on_document", using: :gin
    t.index ["ethnicity_id"], name: "index_patients_on_ethnicity_id"
    t.index ["external_patient_id"], name: "index_patients_on_external_patient_id"
    t.index ["first_cause_id"], name: "index_patients_on_first_cause_id"
    t.index ["language_id"], name: "index_patients_on_language_id"
    t.index ["legacy_patient_id"], name: "index_patients_on_legacy_patient_id", unique: true
    t.index ["local_patient_id"], name: "index_patients_on_local_patient_id"
    t.index ["local_patient_id_2"], name: "index_patients_on_local_patient_id_2"
    t.index ["local_patient_id_3"], name: "index_patients_on_local_patient_id_3"
    t.index ["local_patient_id_4"], name: "index_patients_on_local_patient_id_4"
    t.index ["local_patient_id_5"], name: "index_patients_on_local_patient_id_5"
    t.index ["practice_id"], name: "index_patients_on_practice_id"
    t.index ["primary_care_physician_id"], name: "index_patients_on_primary_care_physician_id"
    t.index ["religion_id"], name: "index_patients_on_religion_id"
    t.index ["second_cause_id"], name: "index_patients_on_second_cause_id"
    t.index ["secure_id"], name: "index_patients_on_secure_id", unique: true
    t.index ["ukrdc_external_id"], name: "index_patients_on_ukrdc_external_id"
    t.index ["updated_by_id"], name: "index_patients_on_updated_by_id"
  end

  create_table "pd_assessments", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.jsonb "document"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_pd_assessments_on_created_by_id"
    t.index ["patient_id"], name: "index_pd_assessments_on_patient_id"
    t.index ["updated_by_id"], name: "index_pd_assessments_on_updated_by_id"
  end

  create_table "pd_bag_types", id: :serial, force: :cascade do |t|
    t.string "manufacturer", null: false
    t.string "description", null: false
    t.decimal "glucose_content", precision: 4, scale: 2, null: false
    t.boolean "amino_acid"
    t.boolean "icodextrin"
    t.boolean "low_glucose_degradation"
    t.boolean "low_sodium"
    t.integer "sodium_content"
    t.integer "lactate_content"
    t.integer "bicarbonate_content"
    t.decimal "calcium_content", precision: 3, scale: 2
    t.decimal "magnesium_content", precision: 3, scale: 2
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "glucose_strength", null: false
    t.index ["deleted_at"], name: "index_pd_bag_types_on_deleted_at"
  end

  create_table "pd_exit_site_infections", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "diagnosis_date", null: false
    t.text "treatment"
    t.text "outcome"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "recurrent"
    t.boolean "cleared"
    t.boolean "catheter_removed"
    t.string "clinical_presentation", array: true
    t.index ["clinical_presentation"], name: "index_pd_exit_site_infections_on_clinical_presentation", using: :gin
    t.index ["patient_id"], name: "index_pd_exit_site_infections_on_patient_id"
  end

  create_table "pd_fluid_descriptions", id: :serial, force: :cascade do |t|
    t.string "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pd_infection_organisms", id: :serial, force: :cascade do |t|
    t.integer "organism_code_id", null: false
    t.text "sensitivity"
    t.string "infectable_type"
    t.integer "infectable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "resistance"
    t.index ["infectable_id", "infectable_type"], name: "idx_infection_organisms_type"
    t.index ["organism_code_id", "infectable_id", "infectable_type"], name: "idx_infection_organisms", unique: true
  end

  create_table "pd_organism_codes", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pd_peritonitis_episode_type_descriptions", id: :serial, force: :cascade do |t|
    t.string "term"
    t.string "definition"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pd_peritonitis_episode_types", id: :serial, force: :cascade do |t|
    t.integer "peritonitis_episode_id", null: false
    t.integer "peritonitis_episode_type_description_id", null: false
    t.index ["peritonitis_episode_id", "peritonitis_episode_type_description_id"], name: "pd_peritonitis_episode_types_unique_id", unique: true
  end

  create_table "pd_peritonitis_episodes", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "diagnosis_date", null: false
    t.date "treatment_start_date"
    t.date "treatment_end_date"
    t.integer "episode_type_id"
    t.boolean "catheter_removed"
    t.boolean "line_break"
    t.boolean "exit_site_infection"
    t.boolean "diarrhoea"
    t.boolean "abdominal_pain"
    t.integer "fluid_description_id"
    t.integer "white_cell_total"
    t.integer "white_cell_neutro"
    t.integer "white_cell_lympho"
    t.integer "white_cell_degen"
    t.integer "white_cell_other"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["episode_type_id"], name: "index_pd_peritonitis_episodes_on_episode_type_id"
    t.index ["fluid_description_id"], name: "index_pd_peritonitis_episodes_on_fluid_description_id"
    t.index ["patient_id"], name: "index_pd_peritonitis_episodes_on_patient_id"
  end

  create_table "pd_pet_adequacy_results", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "pet_date"
    t.string "pet_type"
    t.decimal "pet_duration", precision: 8, scale: 1
    t.integer "pet_net_uf"
    t.decimal "dialysate_creat_plasma_ratio", precision: 8, scale: 2
    t.decimal "dialysate_glucose_start", precision: 8, scale: 1
    t.decimal "dialysate_glucose_end", precision: 8, scale: 1
    t.date "adequacy_date"
    t.decimal "ktv_total", precision: 8, scale: 2
    t.decimal "ktv_dialysate", precision: 8, scale: 2
    t.decimal "ktv_rrf", precision: 8, scale: 2
    t.integer "crcl_total"
    t.integer "crcl_dialysate"
    t.integer "crcl_rrf"
    t.integer "daily_uf"
    t.integer "daily_urine"
    t.date "date_rff"
    t.integer "creat_value"
    t.decimal "dialysate_effluent_volume", precision: 8, scale: 2
    t.date "date_creat_clearance"
    t.date "date_creat_value"
    t.decimal "urine_urea_conc", precision: 8, scale: 1
    t.integer "urine_creat_conc"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_pd_pet_adequacy_results_on_created_by_id"
    t.index ["updated_by_id"], name: "index_pd_pet_adequacy_results_on_updated_by_id"
  end

  create_table "pd_regime_bags", id: :serial, force: :cascade do |t|
    t.integer "regime_id", null: false
    t.integer "bag_type_id", null: false
    t.integer "volume", null: false
    t.integer "per_week"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.boolean "sunday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.boolean "capd_overnight_bag", default: false, null: false
    t.index ["bag_type_id"], name: "index_pd_regime_bags_on_bag_type_id"
    t.index ["regime_id"], name: "index_pd_regime_bags_on_regime_id"
  end

  create_table "pd_regime_terminations", id: :serial, force: :cascade do |t|
    t.date "terminated_on", null: false
    t.integer "regime_id", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_pd_regime_terminations_on_created_by_id"
    t.index ["regime_id"], name: "index_pd_regime_terminations_on_regime_id"
    t.index ["updated_by_id"], name: "index_pd_regime_terminations_on_updated_by_id"
  end

  create_table "pd_regimes", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.string "treatment", null: false
    t.string "type"
    t.integer "glucose_volume_low_strength"
    t.integer "glucose_volume_medium_strength"
    t.integer "glucose_volume_high_strength"
    t.integer "amino_acid_volume"
    t.integer "icodextrin_volume"
    t.boolean "add_hd"
    t.integer "last_fill_volume"
    t.boolean "tidal_indicator"
    t.integer "tidal_percentage"
    t.integer "no_cycles_per_apd"
    t.integer "overnight_volume"
    t.string "apd_machine_pac"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "therapy_time"
    t.integer "fill_volume"
    t.string "delivery_interval"
    t.integer "system_id"
    t.integer "additional_manual_exchange_volume"
    t.boolean "tidal_full_drain_every_three_cycles", default: true
    t.integer "daily_volume"
    t.string "assistance_type"
    t.integer "dwell_time"
    t.index ["id", "type"], name: "index_pd_regimes_on_id_and_type"
    t.index ["patient_id"], name: "index_pd_regimes_on_patient_id"
    t.index ["system_id"], name: "index_pd_regimes_on_system_id"
  end

  create_table "pd_systems", id: :serial, force: :cascade do |t|
    t.string "pd_type", null: false
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_pd_systems_on_deleted_at"
    t.index ["pd_type"], name: "index_pd_systems_on_pd_type"
  end

  create_table "pd_training_sessions", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "training_site_id", null: false
    t.jsonb "document"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "training_type_id", null: false
    t.index ["created_by_id"], name: "index_pd_training_sessions_on_created_by_id"
    t.index ["patient_id"], name: "index_pd_training_sessions_on_patient_id"
    t.index ["training_site_id"], name: "index_pd_training_sessions_on_training_site_id"
    t.index ["training_type_id"], name: "index_pd_training_sessions_on_training_type_id"
    t.index ["updated_by_id"], name: "index_pd_training_sessions_on_updated_by_id"
  end

  create_table "pd_training_sites", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pd_training_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problem_notes", id: :serial, force: :cascade do |t|
    t.integer "problem_id"
    t.text "description", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_problem_notes_on_created_by_id"
    t.index ["problem_id"], name: "index_problem_notes_on_problem_id"
    t.index ["updated_by_id"], name: "index_problem_notes_on_updated_by_id"
  end

  create_table "problem_problems", id: :serial, force: :cascade do |t|
    t.integer "position", default: 0, null: false
    t.integer "patient_id", null: false
    t.string "description", null: false
    t.date "date"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id"
    t.index ["created_by_id"], name: "index_problem_problems_on_created_by_id"
    t.index ["deleted_at"], name: "index_problem_problems_on_deleted_at"
    t.index ["patient_id"], name: "index_problem_problems_on_patient_id"
    t.index ["position"], name: "index_problem_problems_on_position"
    t.index ["updated_by_id"], name: "index_problem_problems_on_updated_by_id"
  end

  create_table "problem_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_problem_versions_on_item_type_and_item_id"
  end

  create_table "renal_aki_alert_actions", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_renal_aki_alert_actions_on_name"
  end

  create_table "renal_aki_alerts", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "action_id"
    t.bigint "hospital_ward_id"
    t.boolean "hotlist", default: false, null: false
    t.string "action"
    t.text "notes"
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_cre"
    t.date "cre_date"
    t.integer "max_aki"
    t.date "aki_date"
    t.index ["action"], name: "index_renal_aki_alerts_on_action"
    t.index ["action_id"], name: "index_renal_aki_alerts_on_action_id"
    t.index ["created_by_id"], name: "index_renal_aki_alerts_on_created_by_id"
    t.index ["hospital_ward_id"], name: "index_renal_aki_alerts_on_hospital_ward_id"
    t.index ["hotlist"], name: "index_renal_aki_alerts_on_hotlist"
    t.index ["patient_id"], name: "index_renal_aki_alerts_on_patient_id"
    t.index ["updated_by_id"], name: "index_renal_aki_alerts_on_updated_by_id"
  end

  create_table "renal_prd_descriptions", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renal_profiles", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "esrf_on"
    t.date "first_seen_on"
    t.float "weight_at_esrf"
    t.string "modality_at_esrf"
    t.integer "prd_description_id"
    t.date "comorbidities_updated_on"
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_renal_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_renal_profiles_on_patient_id"
    t.index ["prd_description_id"], name: "index_renal_profiles_on_prd_description_id"
  end

  create_table "renal_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_renal_versions_on_item_type_and_item_id"
  end

  create_table "reporting_audits", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "view_name", null: false
    t.datetime "refreshed_at"
    t.string "refresh_schedule", default: "1 0 * * 1-6"
    t.text "display_configuration", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.boolean "materialized", default: true, null: false
    t.boolean "enabled", default: true, null: false
  end

  create_table "research_studies", force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.string "leader"
    t.text "notes"
    t.date "started_on"
    t.date "terminated_on"
    t.datetime "deleted_at"
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "application_url"
    t.index ["code"], name: "index_research_studies_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["created_by_id"], name: "index_research_studies_on_created_by_id"
    t.index ["deleted_at"], name: "index_research_studies_on_deleted_at"
    t.index ["description"], name: "index_research_studies_on_description"
    t.index ["leader"], name: "index_research_studies_on_leader"
    t.index ["updated_by_id"], name: "index_research_studies_on_updated_by_id"
  end

  create_table "research_study_participants", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.bigint "study_id", null: false
    t.date "joined_on", null: false
    t.date "left_on"
    t.datetime "deleted_at"
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "external_id"
    t.index ["created_by_id"], name: "index_research_study_participants_on_created_by_id"
    t.index ["deleted_at"], name: "index_research_study_participants_on_deleted_at"
    t.index ["external_id"], name: "index_research_study_participants_on_external_id", unique: true
    t.index ["participant_id", "study_id"], name: "unique_study_participants", unique: true, where: "(deleted_at IS NULL)"
    t.index ["participant_id"], name: "index_research_study_participants_on_participant_id"
    t.index ["study_id"], name: "index_research_study_participants_on_study_id"
    t.index ["updated_by_id"], name: "index_research_study_participants_on_updated_by_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false, null: false
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "roles_users", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true
  end

  create_table "snippets_snippets", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "last_used_on"
    t.integer "times_used", default: 0, null: false
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_snippets_snippets_on_author_id"
    t.index ["title"], name: "index_snippets_snippets_on_title"
  end

  create_table "system_countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "alpha2", null: false
    t.string "alpha3", null: false
    t.integer "position"
    t.index ["alpha2"], name: "index_system_countries_on_alpha2"
    t.index ["alpha3"], name: "index_system_countries_on_alpha3"
    t.index ["name"], name: "index_system_countries_on_name"
    t.index ["position"], name: "index_system_countries_on_position"
  end

  create_table "system_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.datetime "time"
    t.string "name"
    t.jsonb "properties"
    t.index "properties jsonb_path_ops", name: "index_system_events_on_properties_jsonb_path_ops", using: :gin
    t.index ["name", "time"], name: "index_system_events_on_name_and_time"
    t.index ["user_id"], name: "index_system_events_on_user_id"
    t.index ["visit_id"], name: "index_system_events_on_visit_id"
  end

  create_table "system_messages", force: :cascade do |t|
    t.string "title"
    t.text "body", null: false
    t.integer "message_type", default: 0, null: false
    t.string "severity"
    t.datetime "display_from", null: false
    t.datetime "display_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_templates", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "title"
    t.string "description", null: false
    t.text "body", null: false
    t.index ["name"], name: "index_system_templates_on_name"
  end

  create_table "system_user_feedback", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.string "category", null: false
    t.text "comment", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "admin_notes"
    t.boolean "acknowledged"
    t.index ["author_id"], name: "index_system_user_feedback_on_author_id"
    t.index ["category"], name: "index_system_user_feedback_on_category"
  end

  create_table "system_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.string "search_keyword"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_system_visits_on_user_id"
    t.index ["visit_token"], name: "index_system_visits_on_visit_token", unique: true
  end

  create_table "transplant_donations", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.integer "recipient_id"
    t.string "state", null: false
    t.string "relationship_with_recipient", null: false
    t.string "relationship_with_recipient_other"
    t.string "blood_group_compatibility"
    t.string "mismatch_grade"
    t.string "paired_pooled_donation"
    t.date "volunteered_on"
    t.date "first_seen_on"
    t.date "workup_completed_on"
    t.date "donated_on"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_transplant_donations_on_patient_id"
    t.index ["recipient_id"], name: "index_transplant_donations_on_recipient_id"
  end

  create_table "transplant_donor_followups", id: :serial, force: :cascade do |t|
    t.integer "operation_id", null: false
    t.text "notes"
    t.boolean "followed_up"
    t.string "ukt_center_code"
    t.date "last_seen_on"
    t.boolean "lost_to_followup"
    t.boolean "transferred_for_followup"
    t.date "dead_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["operation_id"], name: "index_transplant_donor_followups_on_operation_id"
  end

  create_table "transplant_donor_operations", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.date "performed_on", null: false
    t.string "anaesthetist"
    t.string "donor_splenectomy_peri_or_post_operatively"
    t.string "kidney_side"
    t.string "nephrectomy_type"
    t.string "nephrectomy_type_other"
    t.string "operating_surgeon"
    t.text "notes"
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_transplant_donor_operations_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_donor_operations_on_patient_id"
  end

  create_table "transplant_donor_stage_positions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_transplant_donor_stage_positions_on_name", unique: true
    t.index ["position"], name: "index_transplant_donor_stage_positions_on_position"
  end

  create_table "transplant_donor_stage_statuses", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_transplant_donor_stage_statuses_on_name", unique: true
    t.index ["position"], name: "index_transplant_donor_stage_statuses_on_position"
  end

  create_table "transplant_donor_stages", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "stage_position_id", null: false
    t.integer "stage_status_id", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "started_on", null: false
    t.datetime "terminated_on"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_transplant_donor_stages_on_created_by_id"
    t.index ["patient_id"], name: "index_transplant_donor_stages_on_patient_id"
    t.index ["stage_position_id"], name: "tx_donor_stage_position_idx"
    t.index ["stage_status_id"], name: "tx_donor_stage_status_idx"
    t.index ["updated_by_id"], name: "index_transplant_donor_stages_on_updated_by_id"
  end

  create_table "transplant_donor_workups", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_transplant_donor_workups_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_donor_workups_on_patient_id"
  end

  create_table "transplant_failure_cause_description_groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transplant_failure_cause_descriptions", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_transplant_failure_cause_descriptions_on_code", unique: true
    t.index ["group_id"], name: "index_transplant_failure_cause_descriptions_on_group_id"
  end

  create_table "transplant_recipient_followups", id: :serial, force: :cascade do |t|
    t.integer "operation_id", null: false
    t.text "notes"
    t.date "stent_removed_on"
    t.boolean "transplant_failed"
    t.date "transplant_failed_on"
    t.integer "transplant_failure_cause_description_id"
    t.string "transplant_failure_cause_other"
    t.text "transplant_failure_notes"
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_transplant_recipient_followups_on_document", using: :gin
    t.index ["operation_id"], name: "index_transplant_recipient_followups_on_operation_id"
    t.index ["transplant_failure_cause_description_id"], name: "tx_recip_fol_failure_cause_description_id_idx"
  end

  create_table "transplant_recipient_operations", id: :serial, force: :cascade do |t|
    t.integer "patient_id", null: false
    t.date "performed_on", null: false
    t.time "theatre_case_start_time"
    t.datetime "donor_kidney_removed_from_ice_at"
    t.string "operation_type", null: false
    t.integer "hospital_centre_id", null: false
    t.datetime "kidney_perfused_with_blood_at"
    t.integer "cold_ischaemic_time"
    t.integer "warm_ischaemic_time"
    t.text "notes"
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_transplant_recipient_operations_on_document", using: :gin
    t.index ["hospital_centre_id"], name: "index_transplant_recipient_operations_on_hospital_centre_id"
    t.index ["patient_id"], name: "index_transplant_recipient_operations_on_patient_id"
  end

  create_table "transplant_recipient_workups", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.index ["created_by_id"], name: "index_transplant_recipient_workups_on_created_by_id"
    t.index ["document"], name: "index_transplant_recipient_workups_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_recipient_workups_on_patient_id"
    t.index ["updated_by_id"], name: "index_transplant_recipient_workups_on_updated_by_id"
  end

  create_table "transplant_registration_status_descriptions", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rr_code"
    t.text "rr_comment"
    t.index ["code"], name: "index_transplant_registration_status_descriptions_on_code"
  end

  create_table "transplant_registration_statuses", id: :serial, force: :cascade do |t|
    t.integer "registration_id"
    t.integer "description_id"
    t.date "started_on", null: false
    t.date "terminated_on"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["created_by_id"], name: "index_transplant_registration_statuses_on_created_by_id"
    t.index ["description_id"], name: "index_transplant_registration_statuses_on_description_id"
    t.index ["registration_id"], name: "index_transplant_registration_statuses_on_registration_id"
    t.index ["updated_by_id"], name: "index_transplant_registration_statuses_on_updated_by_id"
  end

  create_table "transplant_registrations", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.date "referred_on"
    t.date "assessed_on"
    t.date "entered_on"
    t.text "contact"
    t.text "notes"
    t.jsonb "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_transplant_registrations_on_document", using: :gin
    t.index ["patient_id"], name: "index_transplant_registrations_on_patient_id"
  end

  create_table "transplant_versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "tx_versions_type_id"
  end

  create_table "ukrdc_transmission_logs", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.datetime "sent_at", null: false
    t.integer "status", null: false
    t.uuid "request_uuid", null: false
    t.text "payload_hash"
    t.xml "payload"
    t.text "error"
    t.string "file_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_ukrdc_transmission_logs_on_patient_id"
    t.index ["request_uuid"], name: "index_ukrdc_transmission_logs_on_request_uuid"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "username", null: false
    t.string "given_name", null: false
    t.string "family_name", null: false
    t.string "signature"
    t.datetime "last_activity_at"
    t.datetime "expired_at"
    t.string "professional_position"
    t.boolean "approved", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "telephone"
    t.string "authentication_token"
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["expired_at"], name: "index_users_on_expired_at"
    t.index ["family_name"], name: "index_users_on_family_name"
    t.index ["given_name"], name: "index_users_on_given_name"
    t.index ["last_activity_at"], name: "index_users_on_last_activity_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["signature"], name: "index_users_on_signature"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "virology_profiles", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.jsonb "document", default: {}, null: false
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["created_by_id"], name: "index_virology_profiles_on_created_by_id"
    t.index ["document"], name: "index_virology_profiles_on_document", using: :gin
    t.index ["patient_id"], name: "index_virology_profiles_on_patient_id", unique: true
    t.index ["updated_by_id"], name: "index_virology_profiles_on_updated_by_id"
  end

  create_table "virology_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_virology_versions_on_item_type_and_item_id"
  end

  add_foreign_key "access_assessments", "access_types", column: "type_id"
  add_foreign_key "access_assessments", "patients"
  add_foreign_key "access_assessments", "users", column: "created_by_id", name: "access_assessments_created_by_id_fk"
  add_foreign_key "access_assessments", "users", column: "updated_by_id", name: "access_assessments_updated_by_id_fk"
  add_foreign_key "access_plans", "access_plan_types", column: "plan_type_id"
  add_foreign_key "access_plans", "patients"
  add_foreign_key "access_plans", "users", column: "created_by_id"
  add_foreign_key "access_plans", "users", column: "decided_by_id"
  add_foreign_key "access_plans", "users", column: "updated_by_id"
  add_foreign_key "access_procedures", "access_types", column: "type_id"
  add_foreign_key "access_procedures", "patients"
  add_foreign_key "access_procedures", "users", column: "created_by_id", name: "access_procedures_created_by_id_fk"
  add_foreign_key "access_procedures", "users", column: "updated_by_id", name: "access_procedures_updated_by_id_fk"
  add_foreign_key "access_profiles", "access_types", column: "type_id"
  add_foreign_key "access_profiles", "patients"
  add_foreign_key "access_profiles", "users", column: "created_by_id", name: "access_profiles_created_by_id_fk"
  add_foreign_key "access_profiles", "users", column: "decided_by_id"
  add_foreign_key "access_profiles", "users", column: "updated_by_id", name: "access_profiles_updated_by_id_fk"
  add_foreign_key "addresses", "system_countries", column: "country_id"
  add_foreign_key "admission_admissions", "hospital_wards"
  add_foreign_key "admission_admissions", "modality_modalities", column: "modality_at_admission_id"
  add_foreign_key "admission_admissions", "patients"
  add_foreign_key "admission_admissions", "users", column: "created_by_id"
  add_foreign_key "admission_admissions", "users", column: "summarised_by_id"
  add_foreign_key "admission_admissions", "users", column: "updated_by_id"
  add_foreign_key "admission_consults", "hospital_wards"
  add_foreign_key "admission_consults", "patients"
  add_foreign_key "admission_consults", "users", column: "created_by_id"
  add_foreign_key "admission_consults", "users", column: "seen_by_id"
  add_foreign_key "admission_consults", "users", column: "updated_by_id"
  add_foreign_key "admission_requests", "admission_request_reasons", column: "reason_id"
  add_foreign_key "admission_requests", "hospital_units"
  add_foreign_key "admission_requests", "patients"
  add_foreign_key "admission_requests", "users", column: "created_by_id"
  add_foreign_key "admission_requests", "users", column: "updated_by_id"
  add_foreign_key "clinic_appointments", "clinic_clinics", column: "clinic_id"
  add_foreign_key "clinic_appointments", "clinic_visits", column: "becomes_visit_id"
  add_foreign_key "clinic_appointments", "patients"
  add_foreign_key "clinic_appointments", "users"
  add_foreign_key "clinic_clinics", "users"
  add_foreign_key "clinic_visits", "clinic_clinics", column: "clinic_id"
  add_foreign_key "clinic_visits", "patients", name: "clinic_visits_patient_id_fk"
  add_foreign_key "clinic_visits", "users", column: "created_by_id", name: "clinic_visits_created_by_id_fk"
  add_foreign_key "clinic_visits", "users", column: "updated_by_id", name: "clinic_visits_updated_by_id_fk"
  add_foreign_key "clinical_allergies", "patients"
  add_foreign_key "clinical_allergies", "users", column: "created_by_id"
  add_foreign_key "clinical_allergies", "users", column: "updated_by_id"
  add_foreign_key "clinical_body_compositions", "modality_descriptions"
  add_foreign_key "clinical_body_compositions", "patients"
  add_foreign_key "clinical_body_compositions", "users", column: "assessor_id"
  add_foreign_key "clinical_dry_weights", "patients"
  add_foreign_key "clinical_dry_weights", "users", column: "assessor_id"
  add_foreign_key "clinical_dry_weights", "users", column: "created_by_id", name: "hd_dry_weights_created_by_id_fk"
  add_foreign_key "clinical_dry_weights", "users", column: "updated_by_id", name: "hd_dry_weights_updated_by_id_fk"
  add_foreign_key "directory_people", "users", column: "created_by_id", name: "directory_people_created_by_id_fk"
  add_foreign_key "directory_people", "users", column: "updated_by_id", name: "directory_people_updated_by_id_fk"
  add_foreign_key "drug_types_drugs", "drug_types"
  add_foreign_key "drug_types_drugs", "drugs"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "patients"
  add_foreign_key "events", "users", column: "created_by_id", name: "events_created_by_id_fk"
  add_foreign_key "events", "users", column: "updated_by_id", name: "events_updated_by_id_fk"
  add_foreign_key "feed_files", "feed_file_types", column: "file_type_id"
  add_foreign_key "hd_diaries", "hd_diaries", column: "master_diary_id"
  add_foreign_key "hd_diaries", "hospital_units"
  add_foreign_key "hd_diaries", "users", column: "created_by_id"
  add_foreign_key "hd_diaries", "users", column: "updated_by_id"
  add_foreign_key "hd_diary_slots", "hd_diaries", column: "diary_id"
  add_foreign_key "hd_diary_slots", "hd_diurnal_period_codes", column: "diurnal_period_code_id"
  add_foreign_key "hd_diary_slots", "hd_stations", column: "station_id"
  add_foreign_key "hd_diary_slots", "patients"
  add_foreign_key "hd_diary_slots", "users", column: "created_by_id"
  add_foreign_key "hd_diary_slots", "users", column: "updated_by_id"
  add_foreign_key "hd_patient_statistics", "hospital_units"
  add_foreign_key "hd_patient_statistics", "patients"
  add_foreign_key "hd_preference_sets", "hd_schedule_definitions", column: "schedule_definition_id"
  add_foreign_key "hd_preference_sets", "hospital_units"
  add_foreign_key "hd_preference_sets", "patients"
  add_foreign_key "hd_preference_sets", "users", column: "created_by_id", name: "hd_preference_sets_created_by_id_fk"
  add_foreign_key "hd_preference_sets", "users", column: "updated_by_id", name: "hd_preference_sets_updated_by_id_fk"
  add_foreign_key "hd_prescription_administrations", "hd_sessions"
  add_foreign_key "hd_prescription_administrations", "medication_prescriptions", column: "prescription_id"
  add_foreign_key "hd_prescription_administrations", "users", column: "created_by_id"
  add_foreign_key "hd_prescription_administrations", "users", column: "updated_by_id"
  add_foreign_key "hd_profiles", "hd_dialysates", column: "dialysate_id"
  add_foreign_key "hd_profiles", "hd_schedule_definitions", column: "schedule_definition_id"
  add_foreign_key "hd_profiles", "hospital_units"
  add_foreign_key "hd_profiles", "patients"
  add_foreign_key "hd_profiles", "users", column: "created_by_id", name: "hd_profiles_created_by_id_fk"
  add_foreign_key "hd_profiles", "users", column: "named_nurse_id"
  add_foreign_key "hd_profiles", "users", column: "prescriber_id"
  add_foreign_key "hd_profiles", "users", column: "transport_decider_id"
  add_foreign_key "hd_profiles", "users", column: "updated_by_id", name: "hd_profiles_updated_by_id_fk"
  add_foreign_key "hd_schedule_definitions", "hd_diurnal_period_codes", column: "diurnal_period_id"
  add_foreign_key "hd_sessions", "clinical_dry_weights", column: "dry_weight_id"
  add_foreign_key "hd_sessions", "hd_dialysates", column: "dialysate_id"
  add_foreign_key "hd_sessions", "hd_profiles", column: "profile_id"
  add_foreign_key "hd_sessions", "hospital_units"
  add_foreign_key "hd_sessions", "modality_descriptions"
  add_foreign_key "hd_sessions", "patients"
  add_foreign_key "hd_sessions", "users", column: "created_by_id", name: "hd_sessions_created_by_id_fk"
  add_foreign_key "hd_sessions", "users", column: "signed_off_by_id"
  add_foreign_key "hd_sessions", "users", column: "signed_on_by_id"
  add_foreign_key "hd_sessions", "users", column: "updated_by_id", name: "hd_sessions_updated_by_id_fk"
  add_foreign_key "hd_stations", "hd_station_locations", column: "location_id"
  add_foreign_key "hd_stations", "hospital_units"
  add_foreign_key "hd_stations", "users", column: "created_by_id"
  add_foreign_key "hd_stations", "users", column: "updated_by_id"
  add_foreign_key "hospital_units", "hospital_centres"
  add_foreign_key "hospital_wards", "hospital_units"
  add_foreign_key "letter_archives", "letter_letters", column: "letter_id"
  add_foreign_key "letter_archives", "users", column: "created_by_id", name: "letter_archives_created_by_id_fk"
  add_foreign_key "letter_archives", "users", column: "updated_by_id", name: "letter_archives_updated_by_id_fk"
  add_foreign_key "letter_contacts", "directory_people", column: "person_id"
  add_foreign_key "letter_contacts", "letter_contact_descriptions", column: "description_id"
  add_foreign_key "letter_contacts", "patients"
  add_foreign_key "letter_electronic_receipts", "letter_letters", column: "letter_id"
  add_foreign_key "letter_electronic_receipts", "users", column: "recipient_id"
  add_foreign_key "letter_letters", "letter_letterheads", column: "letterhead_id"
  add_foreign_key "letter_letters", "patients", name: "letter_letters_patient_id_fk"
  add_foreign_key "letter_letters", "users", column: "approved_by_id"
  add_foreign_key "letter_letters", "users", column: "author_id"
  add_foreign_key "letter_letters", "users", column: "completed_by_id"
  add_foreign_key "letter_letters", "users", column: "created_by_id", name: "letter_letters_created_by_id_fk"
  add_foreign_key "letter_letters", "users", column: "submitted_for_approval_by_id"
  add_foreign_key "letter_letters", "users", column: "updated_by_id", name: "letter_letters_updated_by_id_fk"
  add_foreign_key "letter_recipients", "letter_letters", column: "letter_id"
  add_foreign_key "letter_signatures", "letter_letters", column: "letter_id"
  add_foreign_key "letter_signatures", "users"
  add_foreign_key "low_clearance_profiles", "patients"
  add_foreign_key "low_clearance_profiles", "users", column: "created_by_id"
  add_foreign_key "low_clearance_profiles", "users", column: "updated_by_id"
  add_foreign_key "medication_prescription_terminations", "medication_prescriptions", column: "prescription_id"
  add_foreign_key "medication_prescription_terminations", "users", column: "created_by_id"
  add_foreign_key "medication_prescription_terminations", "users", column: "updated_by_id"
  add_foreign_key "medication_prescriptions", "drugs"
  add_foreign_key "medication_prescriptions", "medication_routes"
  add_foreign_key "medication_prescriptions", "patients"
  add_foreign_key "medication_prescriptions", "users", column: "created_by_id"
  add_foreign_key "medication_prescriptions", "users", column: "updated_by_id"
  add_foreign_key "messaging_messages", "messaging_messages", column: "replying_to_message_id"
  add_foreign_key "messaging_messages", "patients"
  add_foreign_key "messaging_messages", "users", column: "author_id"
  add_foreign_key "messaging_receipts", "messaging_messages", column: "message_id"
  add_foreign_key "messaging_receipts", "users", column: "recipient_id"
  add_foreign_key "modality_modalities", "modality_descriptions", column: "description_id"
  add_foreign_key "modality_modalities", "modality_reasons", column: "reason_id"
  add_foreign_key "modality_modalities", "patients"
  add_foreign_key "modality_modalities", "users", column: "created_by_id", name: "modality_modalities_created_by_id_fk"
  add_foreign_key "modality_modalities", "users", column: "updated_by_id", name: "modality_modalities_updated_by_id_fk"
  add_foreign_key "pathology_current_observation_sets", "patients"
  add_foreign_key "pathology_observation_descriptions", "pathology_measurement_units", column: "measurement_unit_id"
  add_foreign_key "pathology_observation_requests", "pathology_request_descriptions", column: "description_id"
  add_foreign_key "pathology_observation_requests", "patients"
  add_foreign_key "pathology_observations", "pathology_observation_descriptions", column: "description_id"
  add_foreign_key "pathology_observations", "pathology_observation_requests", column: "request_id"
  add_foreign_key "pathology_request_descriptions", "pathology_labs", column: "lab_id"
  add_foreign_key "pathology_request_descriptions", "pathology_observation_descriptions", column: "required_observation_description_id"
  add_foreign_key "pathology_request_descriptions_requests_requests", "pathology_request_descriptions", column: "request_description_id"
  add_foreign_key "pathology_request_descriptions_requests_requests", "pathology_requests_requests", column: "request_id"
  add_foreign_key "pathology_requests_drugs_drug_categories", "drugs"
  add_foreign_key "pathology_requests_drugs_drug_categories", "pathology_requests_drug_categories", column: "drug_category_id"
  add_foreign_key "pathology_requests_global_rule_sets", "clinic_clinics", column: "clinic_id"
  add_foreign_key "pathology_requests_global_rule_sets", "pathology_request_descriptions", column: "request_description_id"
  add_foreign_key "pathology_requests_global_rules", "pathology_requests_global_rule_sets", column: "rule_set_id"
  add_foreign_key "pathology_requests_patient_rules", "pathology_labs", column: "lab_id"
  add_foreign_key "pathology_requests_patient_rules", "patients"
  add_foreign_key "pathology_requests_patient_rules_requests", "pathology_requests_patient_rules", column: "patient_rule_id"
  add_foreign_key "pathology_requests_patient_rules_requests", "pathology_requests_requests", column: "request_id"
  add_foreign_key "pathology_requests_requests", "clinic_clinics", column: "clinic_id"
  add_foreign_key "pathology_requests_requests", "patients"
  add_foreign_key "pathology_requests_requests", "users", column: "consultant_id"
  add_foreign_key "pathology_requests_requests", "users", column: "created_by_id", name: "pathology_requests_requests_created_by_id_fk"
  add_foreign_key "pathology_requests_requests", "users", column: "updated_by_id", name: "pathology_requests_requests_updated_by_id_fk"
  add_foreign_key "patient_alerts", "patients"
  add_foreign_key "patient_alerts", "users", column: "created_by_id"
  add_foreign_key "patient_alerts", "users", column: "updated_by_id"
  add_foreign_key "patient_bookmarks", "patients"
  add_foreign_key "patient_bookmarks", "users"
  add_foreign_key "patient_practice_memberships", "patient_practices", column: "practice_id"
  add_foreign_key "patient_practice_memberships", "patient_primary_care_physicians", column: "primary_care_physician_id"
  add_foreign_key "patient_worries", "patients"
  add_foreign_key "patient_worries", "users", column: "created_by_id"
  add_foreign_key "patient_worries", "users", column: "updated_by_id"
  add_foreign_key "patients", "death_causes", column: "first_cause_id"
  add_foreign_key "patients", "death_causes", column: "second_cause_id"
  add_foreign_key "patients", "patient_ethnicities", column: "ethnicity_id"
  add_foreign_key "patients", "patient_languages", column: "language_id"
  add_foreign_key "patients", "patient_practices", column: "practice_id", name: "patients_practice_id_fk"
  add_foreign_key "patients", "patient_primary_care_physicians", column: "primary_care_physician_id"
  add_foreign_key "patients", "patient_religions", column: "religion_id"
  add_foreign_key "patients", "system_countries", column: "country_of_birth_id"
  add_foreign_key "patients", "users", column: "created_by_id", name: "patients_created_by_id_fk"
  add_foreign_key "patients", "users", column: "updated_by_id", name: "patients_updated_by_id_fk"
  add_foreign_key "pd_assessments", "patients"
  add_foreign_key "pd_assessments", "users", column: "created_by_id"
  add_foreign_key "pd_assessments", "users", column: "updated_by_id"
  add_foreign_key "pd_exit_site_infections", "patients"
  add_foreign_key "pd_infection_organisms", "pd_organism_codes", column: "organism_code_id"
  add_foreign_key "pd_peritonitis_episode_types", "pd_peritonitis_episode_type_descriptions", column: "peritonitis_episode_type_description_id"
  add_foreign_key "pd_peritonitis_episode_types", "pd_peritonitis_episodes", column: "peritonitis_episode_id"
  add_foreign_key "pd_peritonitis_episodes", "patients"
  add_foreign_key "pd_peritonitis_episodes", "pd_fluid_descriptions", column: "fluid_description_id"
  add_foreign_key "pd_peritonitis_episodes", "pd_peritonitis_episode_type_descriptions", column: "episode_type_id"
  add_foreign_key "pd_pet_adequacy_results", "patients"
  add_foreign_key "pd_pet_adequacy_results", "users", column: "created_by_id"
  add_foreign_key "pd_pet_adequacy_results", "users", column: "updated_by_id"
  add_foreign_key "pd_regime_bags", "pd_bag_types", column: "bag_type_id"
  add_foreign_key "pd_regime_bags", "pd_regimes", column: "regime_id"
  add_foreign_key "pd_regime_terminations", "pd_regimes", column: "regime_id"
  add_foreign_key "pd_regime_terminations", "users", column: "created_by_id"
  add_foreign_key "pd_regime_terminations", "users", column: "updated_by_id"
  add_foreign_key "pd_regimes", "patients"
  add_foreign_key "pd_regimes", "pd_systems", column: "system_id", name: "pd_regimes_system_id_fk"
  add_foreign_key "pd_training_sessions", "patients"
  add_foreign_key "pd_training_sessions", "pd_training_sites", column: "training_site_id", name: "pd_training_sessions_site_id_fk"
  add_foreign_key "pd_training_sessions", "pd_training_types", column: "training_type_id", name: "pd_training_sessions_type_id_fk"
  add_foreign_key "pd_training_sessions", "users", column: "created_by_id"
  add_foreign_key "pd_training_sessions", "users", column: "updated_by_id"
  add_foreign_key "problem_notes", "problem_problems", column: "problem_id"
  add_foreign_key "problem_notes", "users", column: "created_by_id", name: "problem_notes_created_by_id_fk"
  add_foreign_key "problem_notes", "users", column: "updated_by_id", name: "problem_notes_updated_by_id_fk"
  add_foreign_key "problem_problems", "patients"
  add_foreign_key "problem_problems", "users", column: "created_by_id"
  add_foreign_key "problem_problems", "users", column: "updated_by_id"
  add_foreign_key "renal_aki_alerts", "hospital_wards"
  add_foreign_key "renal_aki_alerts", "patients"
  add_foreign_key "renal_aki_alerts", "renal_aki_alert_actions", column: "action_id"
  add_foreign_key "renal_aki_alerts", "users", column: "created_by_id"
  add_foreign_key "renal_aki_alerts", "users", column: "updated_by_id"
  add_foreign_key "renal_profiles", "patients"
  add_foreign_key "renal_profiles", "renal_prd_descriptions", column: "prd_description_id"
  add_foreign_key "research_studies", "users", column: "created_by_id"
  add_foreign_key "research_studies", "users", column: "updated_by_id"
  add_foreign_key "research_study_participants", "patients", column: "participant_id"
  add_foreign_key "research_study_participants", "research_studies", column: "study_id"
  add_foreign_key "research_study_participants", "users", column: "created_by_id"
  add_foreign_key "research_study_participants", "users", column: "updated_by_id"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "snippets_snippets", "users", column: "author_id"
  add_foreign_key "system_user_feedback", "users", column: "author_id"
  add_foreign_key "transplant_donations", "patients"
  add_foreign_key "transplant_donations", "patients", column: "recipient_id", name: "transplant_donations_recipient_id_fk"
  add_foreign_key "transplant_donor_followups", "transplant_donor_operations", column: "operation_id"
  add_foreign_key "transplant_donor_operations", "patients"
  add_foreign_key "transplant_donor_stages", "patients"
  add_foreign_key "transplant_donor_stages", "transplant_donor_stage_positions", column: "stage_position_id"
  add_foreign_key "transplant_donor_stages", "transplant_donor_stage_statuses", column: "stage_status_id"
  add_foreign_key "transplant_donor_stages", "users", column: "created_by_id"
  add_foreign_key "transplant_donor_stages", "users", column: "updated_by_id"
  add_foreign_key "transplant_donor_workups", "patients"
  add_foreign_key "transplant_failure_cause_descriptions", "transplant_failure_cause_description_groups", column: "group_id"
  add_foreign_key "transplant_recipient_followups", "transplant_failure_cause_descriptions"
  add_foreign_key "transplant_recipient_followups", "transplant_recipient_operations", column: "operation_id"
  add_foreign_key "transplant_recipient_operations", "hospital_centres"
  add_foreign_key "transplant_recipient_operations", "patients"
  add_foreign_key "transplant_recipient_workups", "patients"
  add_foreign_key "transplant_registration_statuses", "transplant_registration_status_descriptions", column: "description_id"
  add_foreign_key "transplant_registration_statuses", "transplant_registrations", column: "registration_id"
  add_foreign_key "transplant_registration_statuses", "users", column: "created_by_id", name: "transplant_registration_statuses_created_by_id_fk"
  add_foreign_key "transplant_registration_statuses", "users", column: "updated_by_id", name: "transplant_registration_statuses_updated_by_id_fk"
  add_foreign_key "transplant_registrations", "patients"
  add_foreign_key "ukrdc_transmission_logs", "patients"
  add_foreign_key "virology_profiles", "patients"
  add_foreign_key "virology_profiles", "users", column: "created_by_id"
  add_foreign_key "virology_profiles", "users", column: "updated_by_id"

  create_view "renalware.pathology_current_observations",  sql_definition: <<-SQL
      SELECT DISTINCT ON (pathology_observation_requests.patient_id, pathology_observation_descriptions.id) pathology_observations.id,
      pathology_observations.result,
      pathology_observations.comment,
      pathology_observations.observed_at,
      pathology_observations.description_id,
      pathology_observations.request_id,
      pathology_observation_descriptions.code AS description_code,
      pathology_observation_descriptions.name AS description_name,
      pathology_observation_requests.patient_id
     FROM ((pathology_observations
       LEFT JOIN pathology_observation_requests ON ((pathology_observations.request_id = pathology_observation_requests.id)))
       LEFT JOIN pathology_observation_descriptions ON ((pathology_observations.description_id = pathology_observation_descriptions.id)))
    ORDER BY pathology_observation_requests.patient_id, pathology_observation_descriptions.id, pathology_observations.observed_at DESC;
  SQL

  create_view "renalware.reporting_hd_blood_pressures_audit", materialized: true,  sql_definition: <<-SQL
      WITH blood_pressures AS (
           SELECT hd_sessions.id AS session_id,
              patients.id AS patient_id,
              hd_sessions.hospital_unit_id,
              (((hd_sessions.document -> 'observations_before'::text) -> 'blood_pressure'::text) ->> 'systolic'::text) AS systolic_pre,
              (((hd_sessions.document -> 'observations_before'::text) -> 'blood_pressure'::text) ->> 'diastolic'::text) AS diastolic_pre,
              (((hd_sessions.document -> 'observations_after'::text) -> 'blood_pressure'::text) ->> 'systolic'::text) AS systolic_post,
              (((hd_sessions.document -> 'observations_after'::text) -> 'blood_pressure'::text) ->> 'diastolic'::text) AS diastolic_post
             FROM (hd_sessions
               JOIN patients ON ((patients.id = hd_sessions.patient_id)))
            WHERE (hd_sessions.signed_off_at IS NOT NULL)
          ), some_other_derived_table_variable AS (
           SELECT 1
             FROM blood_pressures blood_pressures_1
          )
   SELECT hu.name AS hospital_unit_name,
      round(avg((blood_pressures.systolic_pre)::integer)) AS systolic_pre_avg,
      round(avg((blood_pressures.diastolic_pre)::integer)) AS diastolic_pre_avg,
      round(avg((blood_pressures.systolic_post)::integer)) AS systolic_post_avg,
      round(avg((blood_pressures.diastolic_post)::integer)) AS distolic_post_avg
     FROM (blood_pressures
       JOIN hospital_units hu ON ((hu.id = blood_pressures.hospital_unit_id)))
    GROUP BY hu.name;
  SQL

  add_index "renalware.reporting_hd_blood_pressures_audit", ["hospital_unit_name"], name: "index_reporting_hd_blood_pressures_audit_on_hospital_unit_name", unique: true

  create_view "renalware.reporting_main_authors_audit", materialized: true,  sql_definition: <<-SQL
      WITH archived_clinic_letters AS (
           SELECT date_part('year'::text, archive.created_at) AS year,
              to_char(archive.created_at, 'Month'::text) AS month,
              letters.author_id,
              date_part('day'::text, (archive.created_at - (visits.date)::timestamp without time zone)) AS days_to_archive
             FROM ((letter_letters letters
               JOIN letter_archives archive ON ((letters.id = archive.letter_id)))
               JOIN clinic_visits visits ON ((visits.id = letters.event_id)))
            WHERE (archive.created_at > (CURRENT_DATE - '3 mons'::interval))
          ), archived_clinic_letters_stats AS (
           SELECT archived_clinic_letters.year,
              archived_clinic_letters.month,
              archived_clinic_letters.author_id,
              count(*) AS total_letters,
              round(avg(archived_clinic_letters.days_to_archive)) AS avg_days_to_archive,
              (( SELECT count(*) AS count
                     FROM archived_clinic_letters acl
                    WHERE ((acl.days_to_archive <= (7)::double precision) AND (acl.author_id = archived_clinic_letters.author_id))))::numeric AS archived_within_7_days
             FROM archived_clinic_letters
            GROUP BY archived_clinic_letters.year, archived_clinic_letters.month, archived_clinic_letters.author_id
          )
   SELECT (((users.family_name)::text || ', '::text) || (users.given_name)::text) AS name,
      stats.total_letters,
      round(((stats.archived_within_7_days / (stats.total_letters)::numeric) * (100)::numeric)) AS percent_archived_within_7_days,
      stats.avg_days_to_archive,
      users.id AS user_id
     FROM (archived_clinic_letters_stats stats
       JOIN users ON ((stats.author_id = users.id)))
    GROUP BY (((users.family_name)::text || ', '::text) || (users.given_name)::text), users.id, stats.total_letters, stats.avg_days_to_archive, stats.archived_within_7_days
    ORDER BY stats.total_letters;
  SQL

  create_view "renalware.reporting_bone_audit",  sql_definition: <<-SQL
      SELECT e1.modality_desc AS modality,
      count(e1.patient_id) AS patient_count,
      round(avg(e4.cca), 2) AS avg_cca,
      round((((count(e8.cca_2_1_to_2_4))::numeric / GREATEST((count(e4.cca))::numeric, 1.0)) * 100.0), 2) AS pct_cca_2_1_to_2_4,
      round((((count(e7.pth_gt_300))::numeric / GREATEST((count(e2.pth))::numeric, 1.0)) * 100.0), 2) AS pct_pth_gt_300,
      round((((count(e6.pth_gt_800))::numeric / GREATEST((count(e2.pth))::numeric, 1.0)) * 100.0), 2) AS pct_pth_gt_800_pct,
      round(avg(e3.phos), 2) AS avg_phos,
      max(e3.phos) AS max_phos,
      round((((count(e5.phos_lt_1_8))::numeric / GREATEST((count(e3.phos))::numeric, 1.0)) * 100.0), 2) AS pct_phos_lt_1_8
     FROM (((((((( SELECT p.id AS patient_id,
              md.name AS modality_desc
             FROM ((patients p
               JOIN modality_modalities m ON ((m.patient_id = p.id)))
               JOIN modality_descriptions md ON ((m.description_id = md.id)))) e1
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS pth
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'PTH'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e2 ON (true))
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS phos
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'PHOS'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e3 ON (true))
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS cca
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'CCA'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e4 ON (true))
       LEFT JOIN LATERAL ( SELECT e3.phos AS phos_lt_1_8
            WHERE (e3.phos < 1.8)) e5 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.pth AS pth_gt_800
            WHERE (e2.pth > (800)::numeric)) e6 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.pth AS pth_gt_300
            WHERE (e2.pth > (300)::numeric)) e7 ON (true))
       LEFT JOIN LATERAL ( SELECT e4.cca AS cca_2_1_to_2_4
            WHERE ((e4.cca >= 2.1) AND (e4.cca <= 2.4))) e8 ON (true))
    WHERE ((e1.modality_desc)::text = ANY ((ARRAY['HD'::character varying, 'PD'::character varying, 'Transplant'::character varying, 'Low Clearance'::character varying])::text[]))
    GROUP BY e1.modality_desc;
  SQL

  create_view "renalware.medication_current_prescriptions",  sql_definition: <<-SQL
      SELECT mp.id,
      mp.patient_id,
      mp.drug_id,
      mp.treatable_type,
      mp.treatable_id,
      mp.dose_amount,
      mp.dose_unit,
      mp.medication_route_id,
      mp.route_description,
      mp.frequency,
      mp.notes,
      mp.prescribed_on,
      mp.provider,
      mp.created_at,
      mp.updated_at,
      mp.created_by_id,
      mp.updated_by_id,
      mp.administer_on_hd,
      mp.last_delivery_date,
      drugs.name AS drug_name,
      drug_types.code AS drug_type_code,
      drug_types.name AS drug_type_name
     FROM ((((medication_prescriptions mp
       FULL JOIN medication_prescription_terminations mpt ON ((mpt.prescription_id = mp.id)))
       JOIN drugs ON ((drugs.id = mp.drug_id)))
       FULL JOIN drug_types_drugs ON ((drug_types_drugs.drug_id = drugs.id)))
       FULL JOIN drug_types ON (((drug_types_drugs.drug_type_id = drug_types.id) AND ((mpt.terminated_on IS NULL) OR (mpt.terminated_on > now())))));
  SQL

  create_view "renalware.reporting_anaemia_audit",  sql_definition: <<-SQL
      SELECT e1.modality_desc AS modality,
      count(e1.patient_id) AS patient_count,
      round(avg(e2.hgb), 2) AS avg_hgb,
      round((((count(e4.hgb_gt_eq_10))::numeric / GREATEST((count(e2.hgb))::numeric, 1.0)) * 100.0), 2) AS pct_hgb_gt_eq_10,
      round((((count(e5.hgb_gt_eq_11))::numeric / GREATEST((count(e2.hgb))::numeric, 1.0)) * 100.0), 2) AS pct_hgb_gt_eq_11,
      round((((count(e6.hgb_gt_eq_13))::numeric / GREATEST((count(e2.hgb))::numeric, 1.0)) * 100.0), 2) AS pct_hgb_gt_eq_13,
      round(avg(e3.fer), 2) AS avg_fer,
      round((((count(e7.fer_gt_eq_150))::numeric / GREATEST((count(e3.fer))::numeric, 1.0)) * 100.0), 2) AS pct_fer_gt_eq_150,
      (COALESCE(sum(immunosuppressants.ct), (0)::numeric))::integer AS count_epo,
      (COALESCE(sum(mircer.ct), (0)::numeric))::integer AS count_mircer,
      (COALESCE(sum(neo.ct), (0)::numeric))::integer AS count_neo,
      (COALESCE(sum(ara.ct), (0)::numeric))::integer AS count_ara
     FROM ((((((((((( SELECT p.id AS patient_id,
              md.name AS modality_desc
             FROM ((patients p
               JOIN modality_modalities m ON ((m.patient_id = p.id)))
               JOIN modality_descriptions md ON ((m.description_id = md.id)))
            WHERE ((m.ended_on IS NULL) OR (m.ended_on > CURRENT_TIMESTAMP))) e1
       FULL JOIN ( SELECT mcp.patient_id,
              count(DISTINCT mcp.drug_id) AS ct
             FROM medication_current_prescriptions mcp
            WHERE ((mcp.drug_type_code)::text = 'immunosuppressant'::text)
            GROUP BY mcp.patient_id) immunosuppressants ON ((e1.patient_id = immunosuppressants.patient_id)))
       FULL JOIN ( SELECT mcp.patient_id,
              count(DISTINCT mcp.drug_id) AS ct
             FROM medication_current_prescriptions mcp
            WHERE ((mcp.drug_name)::text ~~ 'Mircer%'::text)
            GROUP BY mcp.patient_id) mircer ON ((e1.patient_id = mircer.patient_id)))
       FULL JOIN ( SELECT mcp.patient_id,
              count(DISTINCT mcp.drug_id) AS ct
             FROM medication_current_prescriptions mcp
            WHERE ((mcp.drug_name)::text ~~ 'Neo%'::text)
            GROUP BY mcp.patient_id) neo ON ((e1.patient_id = neo.patient_id)))
       FULL JOIN ( SELECT mcp.patient_id,
              count(DISTINCT mcp.drug_id) AS ct
             FROM medication_current_prescriptions mcp
            WHERE ((mcp.drug_name)::text ~~ 'Ara%'::text)
            GROUP BY mcp.patient_id) ara ON ((e1.patient_id = ara.patient_id)))
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS hgb
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'HGB'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e2 ON (true))
       LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS fer
             FROM pathology_current_observations
            WHERE (((pathology_current_observations.description_code)::text = 'FER'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e3 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_10
            WHERE (e2.hgb >= (10)::numeric)) e4 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_11
            WHERE (e2.hgb >= (11)::numeric)) e5 ON (true))
       LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_13
            WHERE (e2.hgb >= (13)::numeric)) e6 ON (true))
       LEFT JOIN LATERAL ( SELECT e3.fer AS fer_gt_eq_150
            WHERE (e3.fer >= (150)::numeric)) e7 ON (true))
    WHERE ((e1.modality_desc)::text = ANY ((ARRAY['HD'::character varying, 'PD'::character varying, 'Transplant'::character varying, 'Low Clearance'::character varying, 'Nephrology'::character varying])::text[]))
    GROUP BY e1.modality_desc;
  SQL

  create_view "renalware.reporting_pd_audit",  sql_definition: <<-SQL
      WITH pd_patients AS (
           SELECT patients.id
             FROM ((patients
               JOIN modality_modalities current_modality ON ((current_modality.patient_id = patients.id)))
               JOIN modality_descriptions current_modality_description ON ((current_modality_description.id = current_modality.description_id)))
            WHERE ((current_modality.ended_on IS NULL) AND (current_modality.started_on <= CURRENT_DATE) AND ((current_modality_description.name)::text = 'PD'::text))
          ), current_regimes AS (
           SELECT pd_regimes.id,
              pd_regimes.patient_id,
              pd_regimes.start_date,
              pd_regimes.end_date,
              pd_regimes.treatment,
              pd_regimes.type,
              pd_regimes.glucose_volume_low_strength,
              pd_regimes.glucose_volume_medium_strength,
              pd_regimes.glucose_volume_high_strength,
              pd_regimes.amino_acid_volume,
              pd_regimes.icodextrin_volume,
              pd_regimes.add_hd,
              pd_regimes.last_fill_volume,
              pd_regimes.tidal_indicator,
              pd_regimes.tidal_percentage,
              pd_regimes.no_cycles_per_apd,
              pd_regimes.overnight_volume,
              pd_regimes.apd_machine_pac,
              pd_regimes.created_at,
              pd_regimes.updated_at,
              pd_regimes.therapy_time,
              pd_regimes.fill_volume,
              pd_regimes.delivery_interval,
              pd_regimes.system_id,
              pd_regimes.additional_manual_exchange_volume,
              pd_regimes.tidal_full_drain_every_three_cycles,
              pd_regimes.daily_volume,
              pd_regimes.assistance_type
             FROM pd_regimes
            WHERE ((pd_regimes.start_date >= CURRENT_DATE) AND (pd_regimes.end_date IS NULL))
          ), current_apd_regimes AS (
           SELECT current_regimes.id,
              current_regimes.patient_id,
              current_regimes.start_date,
              current_regimes.end_date,
              current_regimes.treatment,
              current_regimes.type,
              current_regimes.glucose_volume_low_strength,
              current_regimes.glucose_volume_medium_strength,
              current_regimes.glucose_volume_high_strength,
              current_regimes.amino_acid_volume,
              current_regimes.icodextrin_volume,
              current_regimes.add_hd,
              current_regimes.last_fill_volume,
              current_regimes.tidal_indicator,
              current_regimes.tidal_percentage,
              current_regimes.no_cycles_per_apd,
              current_regimes.overnight_volume,
              current_regimes.apd_machine_pac,
              current_regimes.created_at,
              current_regimes.updated_at,
              current_regimes.therapy_time,
              current_regimes.fill_volume,
              current_regimes.delivery_interval,
              current_regimes.system_id,
              current_regimes.additional_manual_exchange_volume,
              current_regimes.tidal_full_drain_every_three_cycles,
              current_regimes.daily_volume,
              current_regimes.assistance_type
             FROM current_regimes
            WHERE ((current_regimes.type)::text ~~ '%::APD%'::text)
          ), current_capd_regimes AS (
           SELECT current_regimes.id,
              current_regimes.patient_id,
              current_regimes.start_date,
              current_regimes.end_date,
              current_regimes.treatment,
              current_regimes.type,
              current_regimes.glucose_volume_low_strength,
              current_regimes.glucose_volume_medium_strength,
              current_regimes.glucose_volume_high_strength,
              current_regimes.amino_acid_volume,
              current_regimes.icodextrin_volume,
              current_regimes.add_hd,
              current_regimes.last_fill_volume,
              current_regimes.tidal_indicator,
              current_regimes.tidal_percentage,
              current_regimes.no_cycles_per_apd,
              current_regimes.overnight_volume,
              current_regimes.apd_machine_pac,
              current_regimes.created_at,
              current_regimes.updated_at,
              current_regimes.therapy_time,
              current_regimes.fill_volume,
              current_regimes.delivery_interval,
              current_regimes.system_id,
              current_regimes.additional_manual_exchange_volume,
              current_regimes.tidal_full_drain_every_three_cycles,
              current_regimes.daily_volume,
              current_regimes.assistance_type
             FROM current_regimes
            WHERE ((current_regimes.type)::text ~~ '%::CAPD%'::text)
          )
   SELECT 'APD'::text AS pd_type,
      count(current_apd_regimes.patient_id) AS patient_count,
      0 AS avg_hgb,
      0 AS pct_hgb_gt_100,
      0 AS pct_on_epo,
      0 AS pct_pth_gt_500,
      0 AS pct_phosphate_gt_1_8,
      0 AS pct_strong_medium_bag_gt_1l
     FROM current_apd_regimes
  UNION ALL
   SELECT 'CAPD'::text AS pd_type,
      count(current_capd_regimes.patient_id) AS patient_count,
      0 AS avg_hgb,
      0 AS pct_hgb_gt_100,
      0 AS pct_on_epo,
      0 AS pct_pth_gt_500,
      0 AS pct_phosphate_gt_1_8,
      0 AS pct_strong_medium_bag_gt_1l
     FROM current_capd_regimes
  UNION ALL
   SELECT 'PD'::text AS pd_type,
      count(pd_patients.id) AS patient_count,
      0 AS avg_hgb,
      0 AS pct_hgb_gt_100,
      0 AS pct_on_epo,
      0 AS pct_pth_gt_500,
      0 AS pct_phosphate_gt_1_8,
      0 AS pct_strong_medium_bag_gt_1l
     FROM pd_patients;
  SQL

  create_view "renalware.pathology_observation_digests",  sql_definition: <<-SQL
      SELECT obs_req.patient_id,
      (obs.observed_at)::date AS observed_on,
      jsonb_object_agg(obs_desc.code, obs.result) AS results
     FROM ((pathology_observations obs
       JOIN pathology_observation_requests obs_req ON ((obs.request_id = obs_req.id)))
       JOIN pathology_observation_descriptions obs_desc ON ((obs.description_id = obs_desc.id)))
    GROUP BY obs_req.patient_id, ((obs.observed_at)::date)
    ORDER BY obs_req.patient_id, ((obs.observed_at)::date) DESC;
  SQL

  create_view "renalware.patient_summaries",  sql_definition: <<-SQL
      SELECT patients.id AS patient_id,
      ( SELECT count(*) AS count
             FROM events
            WHERE (events.patient_id = patients.id)) AS events_count,
      ( SELECT count(*) AS count
             FROM clinic_visits
            WHERE (clinic_visits.patient_id = patients.id)) AS clinic_visits_count,
      ( SELECT count(*) AS count
             FROM letter_letters
            WHERE (letter_letters.patient_id = patients.id)) AS letters_count,
      ( SELECT count(*) AS count
             FROM modality_modalities
            WHERE (modality_modalities.patient_id = patients.id)) AS modalities_count,
      ( SELECT count(*) AS count
             FROM problem_problems
            WHERE ((problem_problems.deleted_at IS NULL) AND (problem_problems.patient_id = patients.id))) AS problems_count,
      ( SELECT count(*) AS count
             FROM pathology_observation_requests
            WHERE (pathology_observation_requests.patient_id = patients.id)) AS observation_requests_count,
      ( SELECT count(*) AS count
             FROM (medication_prescriptions p
               FULL JOIN medication_prescription_terminations pt ON ((pt.prescription_id = p.id)))
            WHERE ((p.patient_id = patients.id) AND ((pt.terminated_on IS NULL) OR (pt.terminated_on > CURRENT_TIMESTAMP)))) AS prescriptions_count,
      ( SELECT count(*) AS count
             FROM letter_contacts
            WHERE (letter_contacts.patient_id = patients.id)) AS contacts_count,
      ( SELECT count(*) AS count
             FROM transplant_recipient_operations
            WHERE (transplant_recipient_operations.patient_id = patients.id)) AS recipient_operations_count,
      ( SELECT count(*) AS count
             FROM admission_admissions
            WHERE (admission_admissions.patient_id = patients.id)) AS admissions_count
     FROM patients;
  SQL

  create_view "renalware.reporting_hd_overall_audit", materialized: true,  sql_definition: <<-SQL
      WITH fistula_or_graft_access_types AS (
           SELECT access_types.id
             FROM access_types
            WHERE (((access_types.name)::text ~~* '%fistula%'::text) OR ((access_types.name)::text ~~* '%graft%'::text))
          ), stats AS (
           SELECT s.patient_id,
              s.hospital_unit_id,
              s.month,
              s.year,
              s.session_count,
              s.number_of_missed_sessions,
              s.number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct,
              ((((s.number_of_missed_sessions)::double precision / NULLIF((s.session_count)::double precision, (0)::double precision)) * (100.0)::double precision) > (10.0)::double precision) AS missed_sessions_gt_10_pct,
              (s.dialysis_minutes_shortfall)::double precision AS dialysis_minutes_shortfall,
              (convert_to_float(((s.pathology_snapshot -> 'HGB'::text) ->> 'result'::text)) > (100)::double precision) AS hgb_gt_100,
              (convert_to_float(((s.pathology_snapshot -> 'HGB'::text) ->> 'result'::text)) > (130)::double precision) AS hgb_gt_130,
              (convert_to_float(((s.pathology_snapshot -> 'PTH'::text) ->> 'result'::text)) < (300)::double precision) AS pth_lt_300,
              (convert_to_float(((s.pathology_snapshot -> 'URR'::text) ->> 'result'::text)) > (64)::double precision) AS urr_gt_64,
              (convert_to_float(((s.pathology_snapshot -> 'URR'::text) ->> 'result'::text)) > (69)::double precision) AS urr_gt_69,
              (convert_to_float(((s.pathology_snapshot -> 'PHOS'::text) ->> 'result'::text)) < (1.8)::double precision) AS phos_lt_1_8
             FROM hd_patient_statistics s
            WHERE (s.rolling IS NULL)
          )
   SELECT hu.name,
      stats.year,
      stats.month,
      count(*) AS patient_count,
      round((avg(stats.dialysis_minutes_shortfall))::numeric, 2) AS avg_missed_hd_time,
      round(avg(stats.number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct), 2) AS pct_shortfall_gt_5_pct,
      round(((((count(*) FILTER (WHERE (stats.missed_sessions_gt_10_pct = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS pct_missed_sessions_gt_10_pct,
      round(((((count(*) FILTER (WHERE (stats.hgb_gt_100 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_hgb_gt_100,
      round(((((count(*) FILTER (WHERE (stats.hgb_gt_130 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_hgb_gt_130,
      round(((((count(*) FILTER (WHERE (stats.pth_lt_300 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_pth_lt_300,
      round(((((count(*) FILTER (WHERE (stats.urr_gt_64 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_urr_gt_64,
      round(((((count(*) FILTER (WHERE (stats.urr_gt_69 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_urr_gt_69,
      round(((((count(*) FILTER (WHERE (stats.phos_lt_1_8 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_phosphate_lt_1_8,
      'TBC'::text AS percentage_access_fistula_or_graft
     FROM (stats
       JOIN hospital_units hu ON ((hu.id = stats.hospital_unit_id)))
    GROUP BY hu.name, stats.year, stats.month
    ORDER BY hu.name, stats.year, stats.month;
  SQL

  create_view "renalware.patient_current_modalities",  sql_definition: <<-SQL
      SELECT patients.id AS patient_id,
      patients.secure_id AS patient_secure_id,
      current_modality.id AS modality_id,
      modality_descriptions.id AS modality_description_id,
      modality_descriptions.name AS modality_name,
      current_modality.started_on
     FROM ((patients
       LEFT JOIN ( SELECT DISTINCT ON (modality_modalities.patient_id) modality_modalities.id,
              modality_modalities.patient_id,
              modality_modalities.description_id,
              modality_modalities.reason_id,
              modality_modalities.modal_change_type,
              modality_modalities.notes,
              modality_modalities.started_on,
              modality_modalities.ended_on,
              modality_modalities.state,
              modality_modalities.created_at,
              modality_modalities.updated_at,
              modality_modalities.created_by_id,
              modality_modalities.updated_by_id
             FROM modality_modalities
            ORDER BY modality_modalities.patient_id, modality_modalities.started_on DESC) current_modality ON ((patients.id = current_modality.patient_id)))
       LEFT JOIN modality_descriptions ON ((modality_descriptions.id = current_modality.description_id)));
  SQL

end
