class CsvUpload < ApplicationRecord
  # Add any validations or relationships here if needed
  validates :file_name, presence: true
  validates :upload_type, presence: true  # Change this to :upload_type
end
