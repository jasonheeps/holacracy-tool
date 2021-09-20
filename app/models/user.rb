class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_one :employee

  scope :activated, -> { where "deactivated = false" }
  scope :deactivated, -> { where "deactivated = true" }
  scope :ordered_by_email, -> { order(email: :asc) }

  def deactivated?
    deactivated
  end

  def admin?
    admin
  end


  # for 'destroy' (in users_controller) and 'active_for_authentication?' I followed this tutorial:
  # https://kodius.com/blog/how-to-deactivate-user-rails-with-devise/

  # assures user can only log in if they're not deactivated
  def active_for_authentication?
    super && !deactivated
  end
end

# add this above to enable user sign up
# :registerable,
