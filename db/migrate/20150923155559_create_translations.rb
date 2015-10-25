class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.text :input_text
      t.text :output_text
      t.string :from_lang
      t.string :to_lang
      t.timestamps null: false
    end
  end
end
