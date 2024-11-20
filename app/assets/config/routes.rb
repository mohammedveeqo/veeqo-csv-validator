Rails.application.routes.draw do
    # Define routes for the CsvUploadsController
    resources :csv_uploads, only: [:index, :create] do
      collection do
        get :show_validation_errors
      end
    end
  
    # Route for success page
    get '/success', to: 'csv_uploads#success', as: :success
  
    # Root route (optional)
    root to: 'csv_uploads#index'
  end
  