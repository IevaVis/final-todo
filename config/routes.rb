Rails.application.routes.draw do
  get 'braintree/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  resources :users
  resources :todos
  post "/user/logout" => "sessions#logout", as: "logout"
  get "/user/signin" => "sessions#signin", as: "sign_in"
  post "/user/signin" => "sessions#login"
  post "/todo/:id/toggle" => "todos#toggle", as: "toggle"
  get "/admin/:id/controls" => "admin#show", as: "admin"
  get "/admin/:id/show/users" => "admin#show_users", as: "show_users"
  get "/admin/:admin_id/user/:user_id" => "admin#inspect_user", as: "inspect_user"
  post "/admin/:admin_id/delete/todo/:todo_id" => "admin#delete_todo", as: "delete_todo"
  post "/admin/:admin_id/remove/user/:user_id" => "admin#remove_user", as: "remove_user"
  post "/admin/:admin_id/assign/admin/user/:user_id" => "admin#assign_admin", as: "assign_admin"
  post 'braintree/checkout'
end