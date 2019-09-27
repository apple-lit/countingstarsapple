class Counts < ActiveRecord::Migration[5.2]
  def change

    create_table :counts do |t|
      t.string :name
      t.integer :number, default: 0
      t.string :image
      t.references :user
      t.timestamps null: false
    end

  end
end
