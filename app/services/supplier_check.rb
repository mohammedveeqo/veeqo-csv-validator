class SupplierCheck
  REQUIRED_HEADERS = {
    "supplier_name" => [],
    "supplier_zipcode" => [],
    "supplier_country" => ["is_country_code_valid?"],
    "supplier_currency" => ["is_currency_code_valid?"],
    "supplier_sales_email" => ["is_email_valid?", "contains_no_whitespace?"],
  }.freeze

  OPTIONAL_HEADERS = {
    "supplier_id" => ["is_integer?"],
    "supplier_address_1" => [],
    "supplier_address_2" => [],
    "supplier_state" => [],
    "supplier_town" => [],
    "supplier_sales_contact_name" => [],
    "supplier_phone" => ["is_integer?"],
    "supplier_bank_account" => ["is_integer?"],
    "supplier_sort_code" => [],
    "supplier_accounts_contact_name" => [],
    "supplier_accounts_email" => ["is_email_valid?"],
    "supplier_accounts_phone_number" => ["is_integer?"],
  }.freeze

  def validate(csv_data)
    errors = []

    csv_data.each_with_index do |row, index|
      # Check required headers
      validate_required_fields(row, index + 1, errors)
      
      # Check optional headers
      validate_optional_fields(row, index + 1, errors)
    end

    errors
  end

  private

  def validate_required_fields(row, row_number, errors)
    REQUIRED_HEADERS.each do |header, validators|
      value = row[header]

      # Check for blank cells in required fields
      if value.nil? || value.strip.empty?
        errors << "Row #{row_number}: #{header} can't be blank."
      else
        # Apply validators
        validators.each do |validator|
          unless send(validator, value)
            errors << "Row #{row_number}: #{header} is invalid."
          end
        end
      end
    end
  end

  def validate_optional_fields(row, row_number, errors)
    OPTIONAL_HEADERS.each do |header, validators|
      value = row[header]
      next if value.nil? || value.strip.empty?  # Skip blank optional fields

      # Apply validators to non-blank optional fields
      validators.each do |validator|
        unless send(validator, value)
          errors << "Row #{row_number}: #{header} is invalid."
        end
      end
    end
  end

  # Validators

  def is_country_code_valid?(country_code)
    return false if country_code.nil?
    country_code.length == 2  # Assuming valid country codes are 2-letter codes
  end

  def is_currency_code_valid?(currency_code)
    return false if currency_code.nil?
    %w[USD EUR GBP JPY AUD].include?(currency_code)
  end

  def is_email_valid?(email)
    !!(email =~ URI::MailTo::EMAIL_REGEXP)
  end

  def contains_no_whitespace?(string)
    return false if string.nil?
    !string.match?(/\s/)
  end

  def is_integer?(value)
    return false if value.nil?
    value.to_i.to_s == value.to_s
  end
end
