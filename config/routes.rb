Rails.application.routes.draw do
  root "users#index"
  post "import", to: "users#import"
end
