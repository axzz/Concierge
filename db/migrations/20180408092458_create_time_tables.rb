Hanami::Model.migration do
  change do
    create_table :time_tables do
      primary_key :id
      foreign_key :creator_id, :users, on_delete: :cascade, null:false
      foreign_key :project_id, :projects, on_delete: :cascade, null:false

      column :date,       Date
      column :period,     String
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
