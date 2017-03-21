class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  validates_presence_of :name, :email, :password_confirmation, :password_sha, :password_salt
  validates_uniqueness_of :email
  validates_confirmation_of :password

  has_many :appointments, dependent: :destroy

  def save
    self.password_salt = SecureRandom.base64(8)
    self.password_sha = Digest::SHA2.hexdigest(password_salt + password)

    super
  end

  def password_correct?(password_to_confirm)
    password_sha == Digest::SHA2.hexdigest(password_salt + password_to_confirm)
  end
end
