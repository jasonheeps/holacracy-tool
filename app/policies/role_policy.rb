class RolePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    sec_or_admin?
  end

  def create?
    new?
  end

  def show?
    true
  end

  def edit?
    sec_or_admin?
  end

  def update?
    edit?
  end

  def destroy?
    sec_or_admin?
  end

  private

  def sec_or_admin?
    circle = record.primary_circle
    sec = Role.find_by(primary_circle_id: circle.id, role_type: :sec)
    user.employee.roles.include?(sec) || user.admin
  end
end
