Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "logins#new"
  resources 'logins'
  resources 'users'
  post '/add_members' => 'users#add_members'
  delete '/remove_group_member' => 'channels#remove_group_member'
  resources 'channels' do
    resources 'messages'
  end

  get '/not_found' => 'errors#not_found'
end
