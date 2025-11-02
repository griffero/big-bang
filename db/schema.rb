# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_02_120003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "address_stats", force: :cascade do |t|
    t.bigint "address_id", null: false
    t.bigint "confirmed_sats", default: 0, null: false
    t.bigint "unconfirmed_sats", default: 0, null: false
    t.integer "tx_count", default: 0, null: false
    t.datetime "first_seen_at"
    t.datetime "last_seen_at"
    t.string "source"
    t.jsonb "raw_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_address_stats_on_address_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.bigint "phrase_id", null: false
    t.integer "variant", default: 0, null: false
    t.string "address", null: false
    t.string "wif"
    t.string "hash160"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_addresses_on_address", unique: true
    t.index ["phrase_id"], name: "index_addresses_on_phrase_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.integer "kind"
    t.string "name"
    t.string "country"
    t.string "region"
    t.string "address"
    t.string "website"
    t.string "tax_id"
    t.bigint "workspace_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workspace_id"], name: "index_companies_on_workspace_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "title"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contacts_on_company_id"
  end

  create_table "documents", force: :cascade do |t|
    t.bigint "operation_id", null: false
    t.integer "kind"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["operation_id"], name: "index_documents_on_operation_id"
  end

  create_table "operations", force: :cascade do |t|
    t.string "product"
    t.string "operation_type"
    t.string "cargo_type"
    t.string "incoterm"
    t.decimal "value_cif", precision: 15, scale: 2
    t.decimal "weight_kg", precision: 15, scale: 3
    t.decimal "volume_m3", precision: 15, scale: 3
    t.string "origin"
    t.string "destination"
    t.date "etd"
    t.date "eta"
    t.string "bl_number"
    t.string "booking_number"
    t.bigint "customer_id", null: false
    t.bigint "supplier_id", null: false
    t.bigint "contact_id", null: false
    t.bigint "workspace_id", null: false
    t.text "notes"
    t.bigint "pipeline_id", null: false
    t.bigint "stage_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bl_number"], name: "index_operations_on_bl_number"
    t.index ["booking_number"], name: "index_operations_on_booking_number"
    t.index ["contact_id"], name: "index_operations_on_contact_id"
    t.index ["customer_id"], name: "index_operations_on_customer_id"
    t.index ["pipeline_id"], name: "index_operations_on_pipeline_id"
    t.index ["stage_id"], name: "index_operations_on_stage_id"
    t.index ["supplier_id"], name: "index_operations_on_supplier_id"
    t.index ["workspace_id"], name: "index_operations_on_workspace_id"
  end

  create_table "phrases", force: :cascade do |t|
    t.string "content", null: false
    t.integer "status", default: 0, null: false
    t.datetime "last_scanned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_phrases_on_content", unique: true
  end

  create_table "pipelines", force: :cascade do |t|
    t.integer "kind"
    t.string "name"
    t.bigint "workspace_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workspace_id"], name: "index_pipelines_on_workspace_id"
  end

  create_table "quotations", force: :cascade do |t|
    t.string "origin"
    t.string "destination"
    t.string "cargo_type"
    t.string "incoterm"
    t.decimal "weight_kg", precision: 15, scale: 3
    t.decimal "volume_m3", precision: 15, scale: 3
    t.decimal "estimated_value", precision: 15, scale: 2
    t.integer "status", default: 0, null: false
    t.string "evidence_url"
    t.text "evidence_note"
    t.bigint "workspace_id", null: false
    t.bigint "company_id", null: false
    t.bigint "operation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_quotations_on_company_id"
    t.index ["operation_id"], name: "index_quotations_on_operation_id"
    t.index ["status"], name: "index_quotations_on_status"
    t.index ["workspace_id"], name: "index_quotations_on_workspace_id"
  end

  create_table "stage_transitions", force: :cascade do |t|
    t.bigint "from_stage_id", null: false
    t.bigint "to_stage_id", null: false
    t.bigint "user_id", null: false
    t.bigint "operation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_stage_id"], name: "index_stage_transitions_on_from_stage_id"
    t.index ["operation_id"], name: "index_stage_transitions_on_operation_id"
    t.index ["to_stage_id"], name: "index_stage_transitions_on_to_stage_id"
    t.index ["user_id"], name: "index_stage_transitions_on_user_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.jsonb "requirements"
    t.integer "sla_days"
    t.bigint "pipeline_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_id"], name: "index_stages_on_pipeline_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.integer "role"
    t.string "name"
    t.boolean "active", default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["workspace_id"], name: "index_users_on_workspace_id"
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "name"
    t.string "plan"
    t.string "currency"
    t.string "timezone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "address_stats", "addresses"
  add_foreign_key "addresses", "phrases"
  add_foreign_key "companies", "workspaces"
  add_foreign_key "contacts", "companies"
  add_foreign_key "documents", "operations"
  add_foreign_key "operations", "companies", column: "customer_id"
  add_foreign_key "operations", "companies", column: "supplier_id"
  add_foreign_key "operations", "contacts"
  add_foreign_key "operations", "pipelines"
  add_foreign_key "operations", "stages"
  add_foreign_key "operations", "workspaces"
  add_foreign_key "pipelines", "workspaces"
  add_foreign_key "quotations", "companies"
  add_foreign_key "quotations", "operations"
  add_foreign_key "quotations", "workspaces"
  add_foreign_key "stage_transitions", "operations"
  add_foreign_key "stage_transitions", "stages", column: "from_stage_id"
  add_foreign_key "stage_transitions", "stages", column: "to_stage_id"
  add_foreign_key "stage_transitions", "users"
  add_foreign_key "stages", "pipelines"
  add_foreign_key "users", "workspaces"
end
