Rails.application.routes.draw do
  
  root "home#index"

  resources :jobs
  get '/scraping', to: 'jobs#scraping', as: 'scraping'
  get '/filtrerjobs', to: 'jobs#filtrerjobs', as: 'filtrerjobs'

end
