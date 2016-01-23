def next_step(snake, direction)
     [snake.last.first + direction.first , snake.last.last + direction.last]
end

def move(snake, direction)
	  grow(snake, direction).drop(1)
end

def all_positions_available(food, snake, dimensions)
  taken_fields = food + snake
  all_positions(dimensions).select {|value| !taken_fields.include?(value)}
end

def new_food(food, snake, dimensions)
  all_positions_available(food, snake, dimensions).sample
end

def grow(snake, direction)
  grown_up_snake = snake.clone
  grown_up_snake.push next_step(grown_up_snake, direction)
  grown_up_snake
end

def all_positions(dimensions)
  width_of_field = (dimensions[:width]).pred
  height_of_field = (dimensions[:height]).pred
  ((0..width_of_field).to_a).product((0..height_of_field).to_a)
end

def obstacle_ahead?(snake, direction, dimensions)
  next_move = (grow(snake, direction)).last
  snake.include? next_move or
  (! ((all_positions(dimensions)).include? next_move))
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
  obstacle_ahead?(move(snake, direction), direction, dimensions)
end