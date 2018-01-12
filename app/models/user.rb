class User < ActiveRecord::Base
  attr_accessor :password
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}, :length => { :in => 3..20 }
  validates :password, :confirmation => true #password_confirmation attr
  has_many :books, dependent: :nullify
  before_save :encrypt_password
  after_save :clear_password
	
	def encrypt_password
	  if password.present?
		self.salt = BCrypt::Engine.generate_salt
		self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
	  end
	end
	
	def clear_password
	  self.password = nil
	end
	
	def upd_photo(photo)
	 self.photo=photo
	end
	
	def self.authenticate(username_or_email="", login_password="")
	  user = User.find_by_username(username_or_email)
	  if user && user.match_password(login_password)
		return user
	  else
		return false
	  end
	end   
	def match_password(login_password="")
	  if login_password=="" and encrypted_password == nil
		return true
	  else 
		encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
	  end
	end
end
