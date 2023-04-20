class RecipesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_data
  before_action :authorize

  def index
    recipes = Recipe.all
    render json: recipes, status: :created
  end

  def create
    # byebug
    user = User.find(session[:user_id])
    recipe = user.recipes.create!(recipe_params)
    render json: recipe, status: :created
  end
  
  private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end

  def authorize
    render json: {errors: ["Not Authorized"]}, status: :unauthorized unless session.include? :user_id
  end

  def handle_invalid_data(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

end
