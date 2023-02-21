Rails.application.routes.draw do
  
  scope :api, defaults: { format: :json } do
    mount_devise_token_auth_for 'User', skip: [:invitations], controllers: { 
      # sessions: :sessions, 
      # registrations: "registrations", 
      confirmations: :confirmations
    },
    path_names: { sign_in: :login, sign_out: :logout }

    devise_for :user, class_name: "User", only: [:invitations], controllers: {invitations: "users/invitations"}
    resource :referrals, only: [:show] do
      get :send_invite
    end
  end

end
