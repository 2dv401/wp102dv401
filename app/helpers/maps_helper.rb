module MapsHelper

  def first_map?
    return current_user.maps.count === 0
  end
end
