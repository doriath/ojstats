class HomeController < ApplicationController
  def index
    @ranking = Ranking.global
  end
end
