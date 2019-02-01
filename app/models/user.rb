# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord

    after_initialize :ensure_session_token
    validates :email,:session_token, presence: true, uniqueness: true 

    def self.generate_session_token
        SecureRandom::urlsafe_base64 #this is simply just creating one
    end

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)
        if user && user.is_password?(password)
            return user
        else
            user = nil
        end

    end

    def reset_session_token! #taking already had session token one and updating to different one
        self.session_token = SecureRandom::urlsafe_base64 
        self.save!
        self.ensure_session_token
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end
    
    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)  
        #the code aboves is just overriding the password setter to also generate
        #our password_digest
    end
    
    def password
        @password = password
    end

    def is_password?(password)
        BCrypt::Password.new(password_digest).is_password?(password)
        #this is checking if our password_digest is the same as the password they pass
        #it is doing 'kind of a' backwards hash but not really
        #its more like its checking the BCrypy#is_password(password) is the same as
        #our bcrypted password_digest
    end 
    
end
