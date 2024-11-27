class CreateCsvUploads < ActiveRecord::Migration[7.1]
  def change
    create_table :csv_uploads do |t|
      t.string :file_name        # To store the name of the uploaded file
      t.string :upload_type      # To store the type (e.g., "Purchase Order", "Order", etc.)
      t.text :validation_errors  # To store validation errors as JSON or plain text

      t.timestamps
    end
  end
end

