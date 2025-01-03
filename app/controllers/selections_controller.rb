class SelectionsController < ApplicationController
  before_action :authenticate_user! # Ensure the user is logged in

  def index
    # Render the initial character selection page
  end

  def update_archetype
    archetype = params[:archetype]

    # Add the initial skin to the user's inventory
    skin_image_path = select_skin_image(archetype)
    skin = current_user.skins.build(
      archetype: archetype, # Save the archetype
      current: true         # Mark as current skin
    )
    skin.image.attach(
      io: File.open(Rails.root.join("app/assets/images/#{skin_image_path}")),
      filename: "#{archetype.downcase.gsub(' ', '_')}.png",
      content_type: 'image/png'
    )

    if skin.save
      # Add the knife weapon to the user's inventory
      knife_weapon = current_user.weapons.create(
        name: 'Knife',
        current: true
      )

      if knife_weapon.persisted?
        render json: { success: true }
      else
        render json: { success: false, error: "Failed to save weapon: #{knife_weapon.errors.full_messages.join(', ')}" }
      end
    else
      render json: { success: false, error: "Failed to save skin: #{skin.errors.full_messages.join(', ')}" }
    end
  rescue StandardError => e
    render json: { success: false, error: e.message }
  end

  private

  # Map archetypes to skin image file paths
  def select_skin_image(archetype)
    case archetype
    when 'Attacker'
      'attack.png'
    when 'Defender'
      'defense.png'
    when 'Healer'
      'balanced.png'
    else
      raise 'Invalid archetype selected'
    end
  end
end
