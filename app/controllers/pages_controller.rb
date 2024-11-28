class PagesController < ApplicationController
  # app/controllers/pages_controller.rb
  
  # Grid page action.
  #
  # This action populates the grid page with data. It assigns the following
  # instance variables:
  #
  # * `@user_name`: The current user's username.
  # * `@players`: An array of players in the current game, excluding the current
  #   user.
  before_action :set_game_user

  def grid
    @user_name = current_user.username
    @profile_picture_url = "/path/to/profile.jpg"
    @stats = [
      { name: "Health", value: current_user.health },
      { name: "Attack", value: current_user.attack },
      { name: "Defense", value: current_user.defense },
      { name: "IQ", value: current_user.iq }
    ]
    @players = Game.find_by(code: session[:game_code])&.game_users&.reject { |player| player.user.username == @user_name } || []
    @game = Game.find_by(code: session[:game_code])

    current_game = Game.find_by(code: session[:game_code])
    @current_game_user = current_user.game_users.find_by(game_id: current_game&.id)
    @move_path = move_pages_path
    @player = current_user

    @level = @current_game_user.level || 1
    @current_experience = @player.experience || 0
    @experience_for_next_level = 100 * @level # Example: Next level requires 100 * current level experience points
    @experience_percentage = (@current_experience.to_f / @experience_for_next_level * 100).round(2)
  end

  # Handle movement
  def move
    new_x = params[:x_position].to_i
    new_y = params[:y_position].to_i

    if @game_user.move_to(new_x, new_y)
      render json: { success: true, message: "Move successful", x: new_x, y: new_y }, status: :ok
    else
      render json: { success: false, error: "You can't move to this square" }, status: :unprocessable_entity
    end
  end

  private

  def set_game_user
    current_game = Game.find_by(code: session[:game_code])
    @game_user = current_user.game_users.find_by(game_id: current_game&.id)
    unless @game_user
      render json: { success: false, errors: ["Player not found in this game"] }, status: :unprocessable_entity
    end
  end
end
