class User < ApplicationRecord
  has_many :activity_historys, dependent: :destroy
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 },
   format: { with: /\A[a-zA-Z0-9]+\z/ }
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password
end
