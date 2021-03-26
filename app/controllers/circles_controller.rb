class CirclesController < ApplicationController
  def index
    @circles = policy_scope(Circle)
  end

  def show
    authorize @circle = Circle.find_by_id(params[:id])
  end
end
