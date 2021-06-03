class CirclePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
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
