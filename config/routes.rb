Rails.application.routes.draw do
  root "csv_uploads#index"

  resources :csv_uploads do
    collection do
      get :show_validation_errors
    end
  end
end
