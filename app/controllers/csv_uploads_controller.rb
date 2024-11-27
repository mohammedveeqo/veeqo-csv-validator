class CsvUploadsController < ApplicationController
  def index
    @errors = []
  end

  def create
    uploaded_file = params.dig(:csv_upload, :file) # Safely fetch the file parameter
    type = params.dig(:csv_upload, :type)         # Safely fetch the type parameter

    unless uploaded_file&.respond_to?(:original_filename)
      flash[:error] = 'No file uploaded or invalid file format.'
      redirect_to csv_uploads_path and return
    end

    if uploaded_file.original_filename.ends_with?('.csv')
      csv_data = CSV.parse(uploaded_file.read, headers: true)
      @errors = validate_csv(csv_data, type)

      if @errors.any?
        CsvValidation.create(validation_errors: @errors.to_json)
        redirect_to show_validation_errors_csv_uploads_path
      else
        redirect_to csv_uploads_path, notice: "CSV processed successfully."
      end
    else
      flash[:error] = 'Only CSV files are allowed.'
      redirect_to csv_uploads_path
    end
  end

  def show_validation_errors
    @validation_record = CsvValidation.last
    @errors = @validation_record ? JSON.parse(@validation_record.validation_errors) : []
  end

  private

  def validate_csv(csv_data, type)
    case type
    when "Purchase Order"
      PurchaseOrderCheck.new.validate(csv_data)
    when "Order"
      OrderCheck.new.validate(csv_data)
    when "Product"
      ProductCheck.new.validate(csv_data)
    when "Supplier"
      SupplierCheck.new.validate(csv_data)
    else
      ["Invalid type selected."]
    end
  end
end
