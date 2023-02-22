class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules.
  devise :invitable, :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :confirmable
end
