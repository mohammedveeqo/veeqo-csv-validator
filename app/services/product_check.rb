class ProductCheck
  REQUIRED_HEADERS = {
    "sku_code" => [],
    "product_title" => [],
    "sales_price" => ["is_float?"],
    "tax_rate" => ["is_float?"],
  }.freeze

  OPTIONAL_HEADERS = {
    "product_id" => ["is_integer?"],
    "variant_title" => [],
    "cost_price" => ["is_float?"],
    "brand" => [],
    "upc_code" => [],
    "image_url" => [],
    "country_origin_code" => ["is_country_code_valid?"],
    "weight_grams" => ["is_float?"],
    "min_reorder_level" => ["is_integer?"],
    "quantity_to_reorder" => ["is_integer?"],
    "max_reorder_level" => ["is_integer?"],
    "width" => ["is_float?"],
    "depth" => ["is_float?"],
    "height" => ["is_float?"],
    "dimensions_unit" => ["is_unit_valid?"],
    "estimated_delivery" => [],
    "tags" => [],
    "product_properties" => ["is_json_or_empty?"],
    "variant_options" => ["is_json_or_empty?"],
    "tariff_code" => ["is_tariff_code_valid?"],
    "qty_on_hand" => ["is_integer_or_infinity?"],
    "total_qty" => ["is_integer_or_infinity?"],
    "total_stock_value" => [],
  }.freeze

  def validate(csv_data)
    errors = []
    csv_data.each_with_index do |row, index|
      # Validate required fields
      REQUIRED_HEADERS.each do |header, validators|
        value = row[header]
        if value.nil? || value.strip.empty?
          errors << "Row #{index + 1}: #{header} can't be blank."
        else
          validators.each do |validator|
            unless send(validator, value)
              errors << "Row #{index + 1}: #{header} is invalid (#{value})."
            end
          end
        end
      end

      # Validate optional fields
      OPTIONAL_HEADERS.each do |header, validators|
        value = row[header]
        next if value.nil? || value.strip.empty? # Skip if blank

        validators.each do |validator|
          unless send(validator, value)
            errors << "Row #{index + 1}: #{header} is invalid (#{value})."
          end
        end
      end
    end
    errors
  end

  # Validation methods
  def is_float?(value)
    !!(value =~ /\A[-+]?[0-9]*\.?[0-9]+\z/)
  end

  def is_integer?(value)
    value.to_i.to_s == value.to_s
  end

  def is_country_code_valid?(country_code)
    # Example: Assuming a simple validation for demonstration
    country_code.length == 2
  end

  def is_unit_valid?(unit)
    ["cm", "inches"].include?(unit.downcase)
  end

  def is_json_or_empty?(string)
    string.strip.empty? || !!JSON.parse(string) rescue false
  end

  def is_integer_or_infinity?(value)
    value == "Infinity" || is_integer?(value)
  end

  def is_tariff_code_valid?(tariff_code)
    # HS codes should be 6 to 12 characters long and contain only letters, numbers, spaces, and dashes
    !!(tariff_code =~ /\A[a-zA-Z0-9\- ]{6,12}\z/)
  end
end


