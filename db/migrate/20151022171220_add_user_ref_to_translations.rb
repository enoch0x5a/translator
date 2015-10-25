class AddUserRefToTranslations < ActiveRecord::Migration
  def change
    add_reference :translations, :user, index: true, foreign_key: true
  end
end
