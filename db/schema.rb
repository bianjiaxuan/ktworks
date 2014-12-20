# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141110133127) do

  create_table "agent_reports", force: true do |t|
    t.string   "city",           default: ""
    t.integer  "agent_id",       default: 0
    t.integer  "invitees_count", default: 0
    t.integer  "reg_count",      default: 0
    t.string   "day",            default: ""
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "albums", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cover_id"
  end

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.boolean  "is_private",                      default: false
    t.string   "art_types"
    t.string   "summary",                         default: ""
    t.string   "avatar",              limit: 100, default: "/assets/admin_logo.png"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.integer  "views_count",                     default: 0
    t.string   "tags",                            default: ""
    t.string   "from"
  end

  create_table "audio_materials", force: true do |t|
    t.string   "name"
    t.string   "media_id"
    t.datetime "exipire_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "access_token"
    t.string   "access_secret"
  end

  add_index "authentications", ["uid", "provider"], name: "idx_authentication_uids", using: :btree

  create_table "bag_traces", force: true do |t|
    t.string   "code",                                default: ""
    t.string   "city",                                default: ""
    t.string   "location",                            default: ""
    t.integer  "user_id",                             default: 0
    t.integer  "game_id",                             default: 0
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.decimal  "longitude",  precision: 10, scale: 6, default: 0.0
    t.decimal  "latitude",   precision: 10, scale: 6, default: 0.0
  end

  create_table "bags", force: true do |t|
    t.string   "code",       default: ""
    t.string   "url",        default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name",       default: ""
    t.integer  "club_id",    default: 0
  end

  add_index "bags", ["code"], name: "index_bags_on_code", unique: true, using: :btree

  create_table "batch_users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.integer  "seq"
    t.boolean  "status",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "agent_id"
    t.date     "vip_start"
    t.date     "vip_end"
    t.string   "identifier", default: ""
    t.integer  "count",      default: 0
    t.integer  "vip_count"
  end

  add_index "batch_users", ["email"], name: "index_batch_users_on_email", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "clubs", force: true do |t|
    t.string   "name",          default: ""
    t.integer  "user_id"
    t.integer  "agent_id"
    t.date     "start_date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.date     "end_date"
    t.string   "city"
    t.date     "setup_date"
    t.text     "intro"
    t.string   "email"
    t.string   "contact_phone"
    t.string   "contact"
    t.string   "region"
    t.string   "avatar"
    t.string   "banner"
  end

  add_index "clubs", ["city"], name: "index_clubs_on_city", using: :btree

  create_table "coaches", force: true do |t|
    t.string   "name"
    t.string   "country"
    t.string   "sex"
    t.string   "phone"
    t.string   "email"
    t.string   "height"
    t.string   "weight"
    t.string   "idcard"
    t.date     "birthday"
    t.date     "auth_date"
    t.string   "address"
    t.string   "goodat"
    t.text     "intro"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coaches", ["user_id"], name: "index_coaches_on_user_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "logo"
    t.string   "donate_count"
    t.string   "school_items"
    t.string   "intro"
    t.string   "site"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "company_type", default: ""
  end

  create_table "contact_replies", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_replies", ["contact_id"], name: "index_contact_replies_on_contact_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "email"
    t.string   "xingming"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "parent",     default: ""
    t.string   "kind",       default: ""
  end

  create_table "donate_messages", force: true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "phone"
    t.string   "address"
    t.string   "school_name"
    t.string   "student_count"
    t.string   "school_address"
    t.string   "contector"
    t.string   "contector_position"
    t.string   "content_phone"
    t.string   "donate_require"
    t.string   "remark"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "game_albums", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.string   "face_file_name"
    t.string   "face_content_type"
    t.integer  "face_file_size"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "game_applications", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_records", force: true do |t|
    t.integer "game_vedio_id"
    t.integer "user_id"
    t.integer "score",         default: 0
    t.boolean "score_flag",    default: false
  end

  create_table "game_vedios", force: true do |t|
    t.integer  "game_id"
    t.string   "uri"
    t.string   "judger"
    t.string   "local"
    t.datetime "time"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id",    default: 0
    t.string   "vedio_id",   default: ""
    t.boolean  "score_flag", default: false
    t.integer  "game_type",  default: 0
  end

  create_table "games", force: true do |t|
    t.string   "city"
    t.string   "place"
    t.date     "date"
    t.datetime "time_start"
    t.datetime "time_end"
    t.integer  "checked_in",          default: 0
    t.boolean  "opened"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "country"
    t.text     "introduction"
    t.text     "traffic_intro"
    t.text     "arround_intro"
    t.string   "url",                 default: ""
    t.integer  "user_id",             default: 0
    t.integer  "priority",            default: 0
    t.text     "site_introduction"
    t.text     "site_traffic"
    t.text     "site_arround"
    t.string   "code"
    t.string   "name"
    t.integer  "club_id"
    t.string   "location"
  end

  add_index "games", ["city"], name: "index_games_on_city", using: :btree
  add_index "games", ["club_id"], name: "index_games_on_club_id", using: :btree
  add_index "games", ["code"], name: "index_games_on_code", using: :btree
  add_index "games", ["country"], name: "index_games_on_country", using: :btree

  create_table "gifts", force: true do |t|
    t.string   "name",       default: ""
    t.text     "desc"
    t.integer  "scores",     default: 0
    t.string   "images",     default: ""
    t.boolean  "on",         default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "url",        default: ""
    t.integer  "category",   default: 0
  end

  create_table "info_urls", force: true do |t|
    t.string   "usage",                       null: false
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "article_link"
    t.integer  "priority",     default: 0
    t.boolean  "status",       default: true
  end

  create_table "inviters", force: true do |t|
    t.integer  "user_id"
    t.integer  "invitees_count"
    t.integer  "lives_count"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "judge_ranks", force: true do |t|
    t.integer  "user_id"
    t.integer  "scores",     default: 0
    t.string   "day"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "kt_errors", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "klass"
    t.text     "message"
    t.text     "backtrace"
    t.boolean  "is_solved",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.integer  "scores",              default: 0
    t.integer  "grade",               default: 0
    t.integer  "usera_id",            default: 0
    t.integer  "userb_id",            default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "league_type",         default: ""
    t.integer  "status",              default: 0
  end

  create_table "level_rules", force: true do |t|
    t.integer  "grade1"
    t.integer  "grade2"
    t.integer  "win_score"
    t.integer  "draw_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "levels", force: true do |t|
    t.integer  "grade"
    t.integer  "min_score"
    t.integer  "max_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: true do |t|
    t.string   "name",                                   null: false
    t.string   "preview_img",                            null: false
    t.boolean  "preview_in_content", default: true
    t.text     "summary"
    t.text     "content"
    t.string   "link",               default: ""
    t.string   "link_type",          default: "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.string   "email"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "company"
    t.string   "phone"
    t.string   "address"
    t.string   "donate_count"
    t.string   "donate_school"
    t.string   "donate_comment"
    t.string   "contect_time"
  end

  create_table "multiple_material_lists", force: true do |t|
    t.string   "name",                                     null: false
    t.string   "preview_img",                              null: false
    t.boolean  "preview_in_content",   default: true
    t.text     "summary"
    t.text     "content"
    t.integer  "multiple_material_id"
    t.string   "link",                 default: ""
    t.string   "link_type",            default: "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "multiple_material_lists", ["multiple_material_id"], name: "index_multiple_material_lists_on_multiple_material_id", using: :btree

  create_table "multiple_materials", force: true do |t|
    t.string   "name",                                   null: false
    t.string   "preview_img",                            null: false
    t.boolean  "preview_in_content", default: true
    t.text     "summary"
    t.text     "content"
    t.string   "link",               default: ""
    t.string   "link_type",          default: "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "new_plants", force: true do |t|
    t.integer  "support_counter"
    t.string   "indentify"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "recommend_art_ids"
    t.string   "thanks_people"
    t.string   "other_a"
    t.string   "other_b"
    t.string   "other_c"
    t.string   "other_d"
    t.string   "other_e"
    t.text     "youku_info"
    t.string   "youku_username"
    t.string   "youku_token"
    t.string   "youku_refresh_token"
  end

  create_table "online_courses", force: true do |t|
    t.string   "name"
    t.string   "cover"
    t.text     "course_images"
    t.text     "gif_images"
    t.text     "common_error"
    t.text     "prepare"
    t.text     "sjx"
    t.text     "video"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id",     default: 0
    t.integer  "scores",      default: 0
    t.integer  "gift_id",     default: 0
    t.string   "gift_name",   default: "0"
    t.integer  "status",      default: 0
    t.string   "receive_by",  default: ""
    t.string   "phone",       default: ""
    t.string   "address",     default: ""
    t.datetime "send_day"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "source_type", default: 0
  end

  create_table "pictures", force: true do |t|
    t.string   "name"
    t.integer  "album_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "weibo_link"
    t.string   "weibo_tip"
    t.boolean  "is_detail",           default: true
  end

  create_table "rounds", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "pair_id"
    t.string   "game_number"
    t.boolean  "varified",       default: false
    t.integer  "varified_code"
    t.integer  "goals",          default: 0
    t.integer  "pannas",         default: 0
    t.boolean  "panna_ko",       default: false
    t.integer  "fouls",          default: 0
    t.integer  "flagrant_fouls", default: 0
    t.boolean  "abstained",      default: false
    t.integer  "score",          default: 0
    t.integer  "result",         default: 0
    t.boolean  "uploaded",       default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "game_type",      default: 0
    t.string   "code"
  end

  add_index "rounds", ["code"], name: "index_rounds_on_code", using: :btree

  create_table "school_items", force: true do |t|
    t.string   "name"
    t.string   "local"
    t.integer  "school_local_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "province"
    t.string   "city"
    t.integer  "company_id"
    t.string   "phone"
    t.string   "address"
    t.integer  "student_count",    default: 0
    t.string   "school_address"
    t.string   "contact"
    t.string   "contact_position"
    t.string   "contact_phone"
    t.text     "donate_require"
    t.text     "remark"
    t.string   "area"
  end

  add_index "school_items", ["company_id"], name: "index_school_items_on_company_id", using: :btree

  create_table "school_locals", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "selected_sms_users", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sms_records", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "has_sent",   default: false
  end

  create_table "students", force: true do |t|
    t.string   "name"
    t.string   "country"
    t.string   "sex"
    t.string   "phone"
    t.string   "email"
    t.string   "height"
    t.string   "weight"
    t.string   "idcard"
    t.date     "birthday"
    t.date     "join_date"
    t.string   "address"
    t.string   "parents_contact"
    t.string   "contact_type"
    t.string   "expectation"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["user_id"], name: "index_students_on_user_id", using: :btree

  create_table "user_profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "gender"
    t.date     "birthday"
    t.string   "province"
    t.string   "city"
    t.string   "area"
    t.string   "football_age"
    t.text     "introduction"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "manifesto"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "age_group"
    t.string   "country"
  end

  create_table "users", force: true do |t|
    t.string   "nickname",               default: "",    null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "phone",                  default: ""
    t.string   "varified_code",          default: ""
    t.boolean  "varified",               default: false
    t.boolean  "admin",                  default: false
    t.boolean  "subscribed",             default: false
    t.integer  "grade",                  default: 0
    t.integer  "scores",                 default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_vip"
    t.string   "start_vip_time"
    t.string   "end_vip_time"
    t.boolean  "has_subscribed_sms",     default: true
    t.integer  "invitor_id"
    t.integer  "invitees_count",         default: 0
    t.integer  "users_count",            default: 0
    t.date     "birthday"
    t.string   "sex"
    t.string   "authentication_token"
    t.string   "province"
    t.string   "city"
    t.string   "area"
    t.boolean  "is_judge",               default: false
    t.boolean  "agent",                  default: false
    t.integer  "source",                 default: 0
    t.datetime "judge_day"
    t.datetime "agent_day"
    t.integer  "actives_count"
    t.integer  "vip_count",              default: 0
    t.datetime "judge_end_day"
    t.datetime "agent_end_day"
    t.integer  "coins",                  default: 0
    t.integer  "judgeclub_id",           default: 0
    t.string   "binding_code",           default: ""
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["grade"], name: "index_users_on_grade", using: :btree
  add_index "users", ["nickname"], name: "unique_nickname", unique: true, using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["scores"], name: "index_users_on_scores", using: :btree
  add_index "users", ["varified_code"], name: "index_users_on_varified_code", using: :btree

  create_table "w_brands", force: true do |t|
    t.string   "name",                   null: false
    t.string   "ename"
    t.string   "logo"
    t.text     "content"
    t.integer  "sort",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "w_cities", force: true do |t|
    t.string   "name",                   null: false
    t.string   "ename"
    t.string   "cover"
    t.text     "content"
    t.integer  "sort",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "w_media", force: true do |t|
    t.string   "name",                           null: false
    t.string   "sub_name"
    t.string   "cover"
    t.date     "published_date"
    t.text     "content"
    t.integer  "sort",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_title",       default: false
  end

  create_table "w_menus", force: true do |t|
    t.string   "name",                    null: false
    t.integer  "klass",      default: 0
    t.integer  "menu_type",  default: 0
    t.string   "url",        default: ""
    t.string   "key",        default: ""
    t.integer  "parent_id"
    t.integer  "sort",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "w_question_answers", force: true do |t|
    t.string   "result"
    t.boolean  "is_passed"
    t.integer  "w_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "w_questions", force: true do |t|
    t.string   "title"
    t.text     "items"
    t.string   "result"
    t.integer  "sort",       default: 0
    t.boolean  "published",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "w_replies", force: true do |t|
    t.string   "keyword",                   null: false
    t.integer  "reply_type",    default: 0
    t.text     "reply_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "w_replies", ["reply_type"], name: "index_w_replies_on_reply_type", using: :btree

  create_table "w_services", force: true do |t|
    t.string   "app_id"
    t.string   "app_secret"
    t.string   "access_token"
    t.datetime "access_token_expire_time"
    t.integer  "gz_reply_type",            default: 0
    t.text     "gz_reply_content"
    t.integer  "auto_reply_type",          default: 0
    t.text     "auto_reply_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "w_services", ["auto_reply_type"], name: "index_w_services_on_auto_reply_type", using: :btree
  add_index "w_services", ["gz_reply_type"], name: "index_w_services_on_gz_reply_type", using: :btree

  create_table "w_users", force: true do |t|
    t.string   "wx_id"
    t.string   "subscribe"
    t.string   "nickname"
    t.string   "sex"
    t.string   "city"
    t.string   "country"
    t.string   "province"
    t.string   "language"
    t.string   "headimgurl"
    t.datetime "subscribe_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "w_users", ["user_id"], name: "index_w_users_on_user_id", using: :btree

end
