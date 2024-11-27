# frozen_string_literal: true

class GameUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  validates :x_position, :y_position, presence: true, numericality: { only_integer: true }

  def move_to(new_x, new_y)
    # Ensure the new position is adjacent
    if (new_x - x_position).abs <= 1 && (new_y - y_position).abs <= 1
      update(x_position: new_x, y_position: new_y)
    else
      errors.add(:base, "Invalid move. You can only move to adjacent spaces.")
    end
  end
end
