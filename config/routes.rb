Rails.application.routes.draw do
  root "csv_uploads#index"

  resources :csv_uploads, only: [:index, :create] do
    collection do
      get :show_validation_errors, action: :show_validation_errors
    end
  end
end

