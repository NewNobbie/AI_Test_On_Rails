class CreateResponses < ActiveRecord::Migration[7.2]
  def change
    create_table :responses do |t|
      t.references :form, null: false, foreign_key: true
      t.text :ia_response
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
