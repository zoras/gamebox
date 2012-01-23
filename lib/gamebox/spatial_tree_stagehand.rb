require 'forwardable'

class SpatialTreeStagehand < Stagehand
  extend Forwardable
  def_delegators :@tree, :neighbors_of, :calculate_bb, :to_s, :each

  attr_reader :moved_items

  def setup
    @dead_actors = {}
    @moved_items = {}
    @tree = AABBTree.new
  end

  def items
    @tree.items.values
  end

  def add(actor)
    # TODO change these to one event? position_changed?
    # item.when :width_changed do |old_w, new_w|
    # item.when :height_changed do |old_h, new_h|

    actor.when :x_changed do |old_x, new_x|
      move actor
    end
    actor.when :y_changed do |old_y, new_y|
      move actor
    end
    actor.when :remove_me do
      remove actor
    end
    @dead_actors.delete actor
    if @tree.include? actor
      @tree.reindex actor
    else
      @tree.insert actor
    end

  end

  def remove(actor)
    @dead_actors[actor] = actor
    @moved_items.delete actor
  end

  def move(actor)
    @moved_items[actor] = actor
  end

  def reset
    @dead_actors.keys.each do |actor|
      @tree.remove actor
      @moved_items.delete actor
      actor.unsubscribe_all self
    end

    @moved_items.keys.each do |actor|
      @tree.reindex actor
    end

    @moved_items = {}
    @dead_actors = {}
  end

end
