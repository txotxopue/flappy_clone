# Bird.gd

extends RigidBody2D

onready var state = FlyingState.new(self)
var speed = 50

const STATE_FLYING    = 0
const STATE_FLAPPING  = 1
const STATE_HIT       = 2
const STATE_GROUNDED  = 3

signal state_changed


func _ready():
    add_to_group(Game.GROUP_BIRDS)
    connect("body_entered", self, "_on_body_enter")
    pass

func _physics_process(delta):
    state.update(delta)
    pass

func _input(event):
    state.input(event)
    pass

func _unhandled_input(event): # Handles inputs not used by any node on the scene.
    if state.has_method("unhandled_input"):
        state.unhandled_input(event)
    pass

func _on_body_enter(other_body):
    if state.has_method("on_body_enter"):
        state.on_body_enter(other_body)
    pass

func set_state(new_state):
    state.exit()

    if new_state == STATE_FLYING:
        state = FlyingState.new(self)
    elif new_state == STATE_FLAPPING:
        state = FlappingState.new(self)
    elif new_state == STATE_HIT:
        state = HitState.new(self)
    elif new_state == STATE_GROUNDED:
        state = GroundState.new(self)

    emit_signal("state_changed", self)
    pass

func get_state():
    if state is FlyingState:
        return STATE_FLYING
    elif state is FlappingState:
        return STATE_FLAPPING
    elif state is HitState:
        return STATE_HIT
    elif state is GroundState:
        return STATE_GROUNDED
    pass


# Class FlyingState ----------------------------------------------------------------------------------

class FlyingState:
    var bird
    var prev_gravity_scale

    func _init(bird):     # Automatically called when creating a new instance of this class.
        self.bird = bird
        bird.get_node("AnimationPlayer").play("flying")
        bird.linear_velocity = Vector2(bird.speed, bird.linear_velocity.y)
        prev_gravity_scale = bird.get_gravity_scale()
        bird.set_gravity_scale(0)
        pass

    func update(delta):
        pass

    func input(event):
        pass

    func exit():
        bird.set_gravity_scale(prev_gravity_scale)
        bird.get_node("AnimationPlayer").stop()
        bird.get_node("AnimatedSprite").position = Vector2(0, 0)
        pass


# Class FlappingState --------------------------------------------------------------------------------

class FlappingState:
    const FLAP_IMPULSE = 150

    var bird

    func _init(bird):
        self.bird = bird
        bird.linear_velocity = Vector2(bird.speed, bird.linear_velocity.y)
        flap() # Call flap once on entering, so the bird doesn't begin the game falling down.
        pass

    func update(delta):
        if rad2deg(bird.rotation) < -30:
            bird.rotation = deg2rad(-30)
            bird.angular_velocity = 0

        if bird.linear_velocity.y > 0:
            bird.angular_velocity = 1.5
        pass

    func input(event):
#        if event is InputEventKey && event.is_pressed() && !event.is_echo():
#            if  event.scancode == KEY_SPACE:
#                print("Key event")
        if event.is_action_pressed("flap"):
            flap()
        pass

    func unhandled_input(event):
        if !event is InputEventMouseButton or !event.is_pressed() or event.is_echo():
            return

        if event.button_index == BUTTON_LEFT:
            flap()
        pass

    func on_body_enter(other_body):
        if other_body.is_in_group(Game.GROUP_PIPES):
            bird.set_state(bird.STATE_HIT)
        elif other_body.is_in_group(Game.GROUP_GROUNDS):
            bird.set_state(bird.STATE_GROUNDED)
        pass

    func flap():
        bird.linear_velocity = Vector2(bird.linear_velocity.x, -FLAP_IMPULSE)
        bird.angular_velocity = -3
        bird.get_node("AnimationPlayer").play("flap")
        pass

    func exit():
        pass


# Class HitState -------------------------------------------------------------------------------------

class HitState:
    var bird

    func _init(bird):
        self.bird = bird
        bird.linear_velocity = Vector2(0, 0)
        bird.angular_velocity = 2

        var other_body = bird.get_colliding_bodies()[0]
        bird.add_collision_exception_with(other_body)
        pass

    func update(delta):
        pass

    func input(event):
        pass

    func on_body_enter(other_body):
        if other_body.is_in_group(Game.GROUP_GROUNDS):
            bird.set_state(bird.STATE_GROUNDED)
        pass

    func exit():
        pass


# Class GroundState ----------------------------------------------------------------------------------

class GroundState:
    var bird

    func _init(bird):
        self.bird = bird
        bird.linear_velocity = Vector2(0, 0)
        bird.angular_velocity = 0
        pass

    func update(delta):
        pass

    func input(event):
        pass

    func exit():
        pass
