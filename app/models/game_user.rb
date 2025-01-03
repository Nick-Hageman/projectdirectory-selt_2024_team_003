class GameUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  before_create :set_health_and_mana

  validates :x_position, :y_position, presence: true, numericality: { only_integer: true }

  def move_to(new_x, new_y)
    if (new_x - x_position).abs <= 1 && (new_y - y_position).abs <= 1
      left_starting_position = (x_position == 0 && y_position == 0) && (new_x != 0 || new_y != 0)

      if update(x_position: new_x, y_position: new_y)
        user.add_achievement('Explorer: The first step is always the bravest. Welcome to the unknown.') if left_starting_position
        true
      end
    else
      false
    end
  end



  def update_health_and_mana
    current_skin = user.current_skin
    if current_skin
      self.health = current_skin.health
      self.mana = current_skin.mana
      self.level = current_skin.level
      save!
    else
      raise "User does not have a current skin"
    end
  end

  def set_health_and_mana
    current_skin = user.current_skin
    if current_skin
      self.health = current_skin.health
      self.mana = current_skin.mana
    else
      raise "User does not have a current skin"
    end
  end

  def take_damage(damage)
    self.health -= damage
    save
  end

  def use_mana(amount)
    if mana >= amount
      self.mana -= amount
      save!
      true
    else
      false
    end
  end
end
