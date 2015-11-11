class User < ActiveRecord::Base
  has_many :translations, :dependent => :destroy

  validates_presence_of :name,
                        :email,
                        :password_digest

  validates_uniqueness_of :email

  # has_secure_password
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    c.crypted_password_field = :password_digest
  end


end
