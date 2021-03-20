class CirclesController < ApplicationController

  def index
    @circles = policy_scope(Circle)
  end
end
