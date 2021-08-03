class CirclePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    circle = record.super_circle
    role = secretary(circle)
    has_role_or_is_admin?(role)
  end

  def create?
    new?
  end

  def show?
    true
  end

  def edit?
    # find circle which is responsible for making this decision (supercircle or GCC)
    circle = record.super_circle ? record.super_circle : record
    # find role which is responsible (secretary)
    role = secretary(circle)
    # check if employee fills this role or is admin
    has_role_or_is_admin?(role)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  private

  def secretary(circle)
    Role.find_by(primary_circle_id: circle.id, role_type: :sec)
  end

  def has_role_or_is_admin?(role)
    user.employee.roles.include?(role) || user.admin
  end
end
