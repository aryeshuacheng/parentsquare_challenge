class AddMesssageIdToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :message_id, :string
    add_column :messages, :status, :string
    add_column :messages, :internal_status, :string
  end
end
