Rails.application.routes.draw do
  root "users#index"
  post "upload", to: "users#upload"
end
