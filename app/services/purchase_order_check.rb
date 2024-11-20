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
        if value.nil? || value.strip.empty?
          errors << "Row #{index + 1}: #{header} can't be blank."
        else
          validators.each do |validator|
            unless send(validator, value)
              errors << "Row #{index + 1}: #{header} has an invalid value: #{value.inspect}"
            end
          end
        end
      end
    end

    errors
  end

  private

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
    sku.present?
  end

  def is_currency_code_valid?(currency)
    [
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
    ].include?(currency.upcase)
  end

  def is_status_valid?(status)
    return false if status.nil?
    ["active", "draft"].include?(status.downcase)
  end
end
