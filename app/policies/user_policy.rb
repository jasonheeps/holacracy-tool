class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def toggle_deactivated?
    user.admin?
  end
end
