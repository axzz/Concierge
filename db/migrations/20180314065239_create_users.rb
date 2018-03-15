Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id
      column :name,       String,   null: false
      column :tel,        String,   null: false
      column :SMS,        String
      column :SMS_limit,   DateTime
      column :token,      String
      column :reservation_id, "text[]"
      column :created_pro_id, "text[]"
      column :managed_pro_id, "text[]"
      column :token_limit,DateTime
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end

