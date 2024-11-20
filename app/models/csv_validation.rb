class CsvValidation < ApplicationRecord
    serialize :validation_errors, JSON
  
    validates :validation_errors, presence: true
  
    # Example: Convert errors array to a user-friendly string
    def formatted_errors
      validation_errors.join("\n")
    end
  end
  