require 'csv' # Ensure CSV is loaded

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

    # Check if the file is a CSV
    if uploaded_file.original_filename.ends_with?('.csv')
      begin
        csv_data = CSV.parse(uploaded_file.read, headers: true)
        @errors = validate_csv(csv_data, type)

        # Handle errors or successful CSV processing
        if @errors.any?
          CsvValidation.create(validation_errors: @errors.to_json)
          flash[:error] = 'There were validation errors in your CSV file.'
          redirect_to show_validation_errors_csv_uploads_path
        else
          flash[:notice] = "CSV processed successfully."
          redirect_to csv_uploads_path
        end
      rescue => e
        # Handle any unexpected errors (e.g., CSV parsing errors)
        flash[:error] = "An error occurred while processing the file: #{e.message}"
        redirect_to csv_uploads_path
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
