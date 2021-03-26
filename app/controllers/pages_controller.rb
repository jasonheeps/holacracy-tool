class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def overview
    @circles = policy_scope(Circle)
  end
end
