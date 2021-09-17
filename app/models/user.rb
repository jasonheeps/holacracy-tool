class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_one :employee


  # for 'destroy' and 'active_for_authentication?' I followed this tutorial:
  # https://kodius.com/blog/how-to-deactivate-user-rails-with-devise/

  # override the devise user#destroy method
  def destroy
    update_attributes(deactivated: true) unless deactivated
  end

  # assures user can only log in if they're not deactivated
  def active_for_authentication?
    super && !deactivated
  end
end

# add this above to enable user sign up
# :registerable,
