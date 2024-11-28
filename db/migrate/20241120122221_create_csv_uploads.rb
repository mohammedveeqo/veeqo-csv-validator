class CreateCsvUploads < ActiveRecord::Migration[7.1]
  def change
    create_table :csv_uploads do |t|
      t.string :file
      t.string :type
      t.timestamps
    end
  end
end

