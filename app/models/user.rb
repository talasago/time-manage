class User < ApplicationRecord
  # アクセサ
  attr_accessor :remember_token
  # リレーション
  has_many :activity_historys, dependent: :destroy
  # バリデーション
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 },
   format: { with: /\A[a-zA-Z0-9]+\z/ }
  validates :password, presence: true, length: { minimum: 8 }
  # パスワード認証用
  has_secure_password

  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続セッション用トークンをDBに保存する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 永続セッション用ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
