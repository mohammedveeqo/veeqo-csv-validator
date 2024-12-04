class PurchaseOrderCheck
  REQUIRED_HEADERS = {
    "supplier_id" => ["is_integer?"],
    "supplier_name" => ["is_present?"],
    "supplier_email" => ["is_email_valid?"],
    "status" => ["is_status_valid?"],
    "warehouse" => ["is_present?"],
    "product_sku" => ["is_sku_present?"],
    "product_order_qty" => ["is_integer?"],
    "product_supplier_cost_price" => ["is_float?"],
    "product_tax" => ["is_float?"],
    "currency" => ["is_currency_code_valid?"],
  }

  def validate(csv_data)
    errors = []

    csv_data.each_with_index do |row, index|
      REQUIRED_HEADERS.each do |header, validators|
        value = row[header]

        # Skip validation if value is missing, but track as missing field.
        if value.nil? || value.strip.empty?
          errors << "#{row_error(index, header)} can't be blank."
          next # Skip the validation for this header if blank
        end

        # Apply all validators
        validators.each do |validator|
          unless send(validator, value)
            errors << format_error_message(index, header, value, validator)
          end
        end
      end
    end

    errors
  end

  private

  def row_error(index, header)
    "Row #{index + 1}: #{header}"
  end

  def format_error_message(index, header, value, validator)
    case validator
    when "is_integer?"
      return "#{row_error(index, header)} should be an integer, but got '#{value}'. Example: '123'."
    when "is_float?"
      return "#{row_error(index, header)} should be a valid number with decimals, but got '#{value}'. Example: '99.99'."
    when "is_email_valid?"
      return "#{row_error(index, header)} should be a valid email address, but got '#{value}'. Example: 'email@example.com'."
    when "is_status_valid?"
      return "#{row_error(index, header)} should be 'active' or 'draft', but got '#{value}'. Valid values: 'active', 'draft'."
    when "is_sku_present?"
      return "#{row_error(index, header)} should not be blank. Example: 'SKU123'."
    when "is_currency_code_valid?"
      return "#{row_error(index, header)} should be a valid currency code, but got '#{value}'. Valid values: 'USD', 'EUR', 'GBP', 'AUD', etc."
    else
      return "#{row_error(index, header)} has an invalid value: #{value.inspect}"
    end
  end

  def is_present?(value)
    value.present?
  end

  def is_integer?(value)
    value.to_s.match?(/\A-?\d+\Z/)
  end

  def is_float?(value)
    value.to_s.match?(/\A-?\d+(\.\d+)?\Z/)
  end

  def is_email_valid?(email)
    return false if email.nil?
    email.match?(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
  end

  def is_sku_present?(sku)
    sku.present? && sku.length > 0
  end

  def is_currency_code_valid?(currency)
    supported_currencies = [
      "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN",
      "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL",
      "BSD", "BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY",
      "COP", "CRC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP",
      "ERN", "ETB", "EUR", "FJD", "FKP", "FOK", "GBP", "GEL", "GGP", "GHS",
      "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF",
      "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JMD", "JOD", "JPY",
      "KES", "KGS", "KHR", "KID", "KMF", "KRW", "KWD", "KYD", "KZT", "LAK",
      "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK",
      "MNT", "MOP", "MRU", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD",
      "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP",
      "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD",
      "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "SSP", "STN",
      "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TVD",
      "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VES", "VND", "VUV",
      "WST", "XAF", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMW", "ZWL"
    ]
    supported_currencies.include?(currency.upcase)
  end

  def is_status_valid?(status)
    return false if status.nil?
    unless ["active", "draft"].include?(status.downcase)
      return false
    end
    true
  end
end

