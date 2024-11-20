class CreateCsvUploads < ActiveRecord::Migration[7.1]
  def change
    create_table :csv_uploads do |t|

      t.timestamps
    end
  end
end
