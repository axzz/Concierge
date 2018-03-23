Hanami::Model.migration do
  change do
    create_table :projects do
      primary_key :id

      foreign_key :creator_id, :users,on_delete: :cascade,null:false

      column :name, String
      column :des, String
      column :image_data, String
      column :address, String
      column :time_table,String
      column :state,String
      column :check_mode,String
      column :manager_ids,"text[]"
      column :share_code,String
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
