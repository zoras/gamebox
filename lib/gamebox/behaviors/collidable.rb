# available collidable_shapes are :circle, :polygon, :aabb
class Collidable < Behavior

  attr_accessor :collidable_shape, :cw_local_points, :shape

  def setup
    @shape = build_shape

    relegates :collidable_shape, :radius, :cw_world_points, :cw_world_lines, :center_x, :center_y, :cw_world_edge_normals
    relegates :width unless @actor.respond_to? :width
    relegates :height unless @actor.respond_to? :height
    relegates :bb unless @actor.respond_to? :bb

    register_actor
  end

  def width; 1; end
  def height; 1; end

  def bb
    w = actor.width || 1
    h = actor.height || 1
    hw = w / 2
    hh = h / 2
    x = actor.x - hw
    y = actor.y - hh
    @bb ||= Rect.new
    @bb.x = x
    @bb.y = y
    @bb.w = w
    @bb.h = h
    @bb
  end

  def register_actor
    @actor.stage.register_collidable @actor
  end

  def removed
    @actor.stage.unregister_collidable @actor
    super
  end

  def build_shape
    shape = nil
    @collidable_shape = opts[:shape]
    case @collidable_shape
    when :circle
      shape = CircleCollidable.new @actor, opts
    when :aabb
      shape = AaBbCollidable.new @actor, opts
    when :polygon
      shape = PolygonCollidable.new @actor, opts
    end

    shape.setup
    shape
  end

  def update(time)
    shape.update(time)
  end

  def method_missing(name, *args)
    @shape.send(name, *args)
  end
end
