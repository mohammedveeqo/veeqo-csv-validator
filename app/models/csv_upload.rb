class CsvUpload < ApplicationRecord
  # Add any validations or relationships here if needed
  validates :file_name, presence: true
  validates :file_type, presence: true
end
