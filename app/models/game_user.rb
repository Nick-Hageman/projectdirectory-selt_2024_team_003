
class GameUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  before_create :set_health

  validates :x_position, :y_position, presence: true, numericality: { only_integer: true }

  def move_to(new_x, new_y)
    if (new_x - x_position).abs <= 1 && (new_y - y_position).abs <= 1
      update(x_position: new_x, y_position: new_y)
    else
      false
    end
  end

  def update_health
    self.health = user.health
    self.level = user.level
    save!
  end

  def set_health
    self.health = user.health
  end

  def take_damage(damage)
    self.health -= damage
    self.save
  end
end
