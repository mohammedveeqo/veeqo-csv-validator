class CreateCsvValidations < ActiveRecord::Migration[7.1]
  def change
    create_table :csv_validations do |t|
      t.text :validation_errors

      t.timestamps
    end
  end
end
