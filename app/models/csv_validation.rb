class CsvValidation < ApplicationRecord
  # If validation_errors is a JSON or JSONB column, you don't need the serialize line.
  # validate :validation_errors must be present, no change here
  validates :validation_errors, presence: true

  # Example: Convert errors array to a user-friendly string
  def formatted_errors
    validation_errors.join("\n") if validation_errors.is_a?(Array)
  end
end