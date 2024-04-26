Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "logins#new"
  resources 'logins'
  resources 'users'
  post '/add_members' => 'users#add_members'
  resources 'channels' do
    resources 'messages'
  end
end
