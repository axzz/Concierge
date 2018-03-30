Hanami::Model.migration do
  change do
    create_table :projects do
      primary_key :id

      foreign_key :creator_id, :users,on_delete: :cascade,null:false

      column :name, String
      column :des, String
      column :image_data, String
      column :default_image, String
      column :address, String
      column :latitude, Float
      column :longitude, Float
      column :time_state,"jsonb"
      column :time_state_parsed,"jsonb"
      column :state,String
      column :check_mode,String
      column :share_pic,String
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
