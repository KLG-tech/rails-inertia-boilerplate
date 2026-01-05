# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar_url             :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :keycloak ]

  # Find or create user from OAuth data
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end

  # Update user info from OAuth if needed
  def self.find_or_create_from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first

    if user
      # Update profile info on each login if changed
      user.update(
        name: auth.info.name,
        avatar_url: auth.info.image
      )
      user
    else
      # Try to find by email first (for linking accounts)
      user = find_by(email: auth.info.email)

      if user
        # Link OAuth to existing account
        user.update(
          provider: auth.provider,
          uid: auth.uid,
          name: auth.info.name || user.name,
          avatar_url: auth.info.image || user.avatar_url
        )
        user
      else
        # Create new user
        from_omniauth(auth)
      end
    end
  end
end
