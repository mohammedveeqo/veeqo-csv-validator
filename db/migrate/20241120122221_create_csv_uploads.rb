class CreateCsvUploads < ActiveRecord::Migration[7.1]
  def change
    create_table :csv_uploads do |t|
      t.string :file_name
      t.string :upload_type
      t.text :validation_errors

      t.timestamps
    end
  end
end
