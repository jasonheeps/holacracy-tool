class RolePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user.admin
  end

  def create?
    new?
  end

  def show?
    true
  end

  def edit?
    user.admin
  end

  def update?
    edit?
  end
end
