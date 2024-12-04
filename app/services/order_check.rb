class OrderCheck
  REQUIRED_HEADERS = {
    "number" => [],
    "shipping_address_first_name" => [],
    "shipping_address_last_name" => [],
    "shipping_address_address1" => [],
    "shipping_address_city" => [],
    "shipping_address_country" => ["is_country_code_valid?"],
    "shipping_address_state" => [],
    "shipping_address_zip" => [],
    "sku" => [],
    "quantity" => ["is_integer?"],
  }.freeze

  OPTIONAL_HEADERS = {
    "receipt_printed" => ["is_bool?"],
    "status" => ["is_status_valid?"],
    "created_at" => [],
    "number_of_lines" => [],
    "customer_note" => [],
    "notes" => [],
    "due_date" => ["is_date_valid?"],
    "tags" => [],
    "tracking_number" => [],
    "product_title" => [],
    "variant_title" => [],
    "additional_options" => [],
    "variant_weight" => ["is_float?"],
    "subtotal_price" => ["is_float?"],
    "total_tax" => ["is_float?"],
    "total_discounts" => ["is_float?"],
    "payment_type" => [],
    "payment_created_at" => [],
    "price_per_unit" => ["is_float?"],
    "price_per_unit_including_tax" => ["is_float?"],
    "delivery_method" => [],
    "cancelled_at" => [],
    "cancel_reason" => [],
    "customer_email" => ["is_email_valid?"],
    "customer_phone" => ["is_integer?"],
    "customer_mobile" => ["is_integer?"],
    "billing_address_first_name" => [],
    "billing_address_last_name" => [],
    "billing_address_company" => [],
    "billing_address_1" => [],
    "billing_address_2" => [],
    "billing_address_city" => [],
    "billing_address_country" => ["is_country_code_valid?"],
    "billing_address_state" => [],
    "billing_address_zip" => [],
    "billing_address_phone" => ["is_integer?"],
    "shipping_address_company" => [],
    "shipping_address_phone" => ["is_integer?"],
  }.freeze

  def validate(csv_data)
    errors = []

    # Check required headers
    missing_headers = REQUIRED_HEADERS.keys - csv_data.headers
    unless missing_headers.empty?
      errors << "Missing required columns: #{missing_headers.join(', ')}"
    end

    csv_data.each_with_index do |row, index|
      validate_row(row, index + 1, errors)
    end

    errors
  end

  private

  def validate_row(row, row_number, errors)
    # Validate required fields
    REQUIRED_HEADERS.each do |col, validators|
      value = row[col]
      if value.nil? || value.strip.empty?
        errors << "#{row_error(row_number, col)} can't be blank."
      else
        validators.each do |validator|
          unless send(validator, value)
            errors << generate_error_message(row_number, col, value, validator)
          end
        end
      end
    end

    # Validate optional fields
    OPTIONAL_HEADERS.each do |col, validators|
      value = row[col]
      next if value.nil? || value.strip.empty? # Skip blank optional fields

      validators.each do |validator|
        unless send(validator, value)
          errors << generate_error_message(row_number, col, value, validator)
        end
      end
    end
  end

  def row_error(row_number, col)
    "Row #{row_number}: #{col}"
  end

  def generate_error_message(row_number, col, value, validator)
    case validator
    when "is_integer?"
      return "#{row_error(row_number, col)} should be an integer, but got '#{value}'. Example: '123'."
    when "is_float?"
      return "#{row_error(row_number, col)} should be a valid number with decimals, but got '#{value}'. Example: '99.99'."
    when "is_country_code_valid?"
      return "#{row_error(row_number, col)} should be a valid country code, but got '#{value}'. Example: 'US', 'CA'."
    when "is_email_valid?"
      return "#{row_error(row_number, col)} should be a valid email address, but got '#{value}'. Example: 'email@example.com'."
    when "is_bool?"
      return "#{row_error(row_number, col)} should be 'true' or 'false', but got '#{value}'."
    when "is_status_valid?"
      return "#{row_error(row_number, col)} should be one of 'pending', 'shipped', 'delivered', or 'cancelled', but got '#{value}'."
    when "is_date_valid?"
      return "#{row_error(row_number, col)} should be a valid date in 'YYYY-MM-DD' format, but got '#{value}'."
    else
      return "#{row_error(row_number, col)} is invalid with value '#{value}'."
    end
  end

  # Example validators
  def is_integer?(value)
    value.to_s.match?(/\A-?\d+\z/)
  end

  def is_float?(value)
    !!Float(value) rescue false
  end

  def is_country_code_valid?(code)
    valid_country_codes = [
      "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", 
      "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", 
      "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", 
      "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", 
      "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FM", "FO", "FR", "GA", "GB", 
      "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GT", "GU", "GW", 
      "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", 
      "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", 
      "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", 
      "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", 
      "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", 
      "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PT", 
      "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", 
      "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", 
      "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TZ", "UA", 
      "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", 
      "YT", "ZA", "ZM", "ZW"
    ]
    
    valid_country_codes.include?(code.upcase)
  end
  

  def is_email_valid?(email)
    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(email)
  end

  def is_bool?(value)
    ["true", "false", true, false].include?(value)
  end

  def is_status_valid?(status)
    ["pending", "shipped", "delivered", "cancelled"].include?(status)
  end

  def is_date_valid?(date)
    # Check if the date is in 'YYYY-MM-DD' format
    /\A\d{4}-\d{2}-\d{2}\z/.match?(date)
  end
end
