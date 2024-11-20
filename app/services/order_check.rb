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
    "due_date" => [],
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
        errors << "Row #{row_number}: #{col} can't be blank."
      else
        validators.each do |validator|
          unless send(validator, value)
            errors << "Row #{row_number}: #{col} is invalid."
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
          errors << "Row #{row_number}: #{col} is invalid."
        end
      end
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
    ["US", "CA", "MX"].include?(code.upcase) # Replace with actual country code validation logic
  end

  def is_email_valid?(email)
    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(email)
  end

  def is_bool?(value)
    ["true", "false", true, false].include?(value)
  end

  def is_status_valid?(status)
    # Define valid statuses
    ["pending", "shipped", "delivered", "cancelled"].include?(status)
  end
end
