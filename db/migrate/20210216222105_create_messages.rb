class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.string :to_number
      t.string :message
      t.string :callback_url

      t.timestamps
    end
  end
end
