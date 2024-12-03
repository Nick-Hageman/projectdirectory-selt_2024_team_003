# frozen_string_literal: true
class UserController < ApplicationController

  def index
    case current_user.archetype
    when 'Arcane Strategist'
      @image = 'attack.png'
    when 'Iron Guardian'
      @image = 'defense.png'
    when 'Omni Knight'
      @image = 'balanced.png'
    else
      @image = 'balanced.png'
    end

    @stats = [
      { name: "Archetype", value: current_user.archetype },
      { name: "Max Health", value: current_user.health },
      { name: "Max Mana", value: current_user.mana },
      { name: "Attack", value: current_user.attack },
      { name: "Special Attack", value: current_user.special_attack },
      { name: "Defense", value: current_user.defense },
      { name: "Special Defense", value: current_user.special_defense },
      { name: "IQ", value: current_user.iq }
    ]

    if params[:search].present?
      @users = User.where("username LIKE ?", "%#{params[:search]}%").where.not(id: current_user.id)
    else
      @users = User.where.not(id: current_user.id)
    end

    @achievements = current_user.achievements || []
  end

  def add_friend
    friend = User.find(params[:friend_id])

    if current_user.friends.include?(friend)
      flash[:alert] = "#{friend.username} is already your friend."
    else
      current_user.friendships.create(friend: friend)
      flash[:notice] = "#{friend.username} has been added to your friends list!"
    end

    redirect_to account_path
  end

  def remove_friend
    friend = User.find(params[:friend_id])

    friendship = current_user.friendships.find_by(friend: friend)
    if friendship
      friendship.destroy
      flash[:notice] = "#{friend.username} has been removed from your friends list."
    else
      flash[:alert] = "#{friend.username} is not your friend."
    end

    redirect_to account_path
  end
end
