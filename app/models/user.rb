class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {maximum: 50}, format: { with: /\A[a-zA-Z0-9]+\z/ }
  has_secure_password
end
