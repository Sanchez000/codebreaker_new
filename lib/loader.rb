require 'pry'
module Loader
  def storage
    File.exist?(Game::PATH_TO_DB) ? YAML.load_file(Game::PATH_TO_DB) : []
  end

  def save(game)
    result = { name: game.user.name,
               level: game.level.to_s,
               hints_total: game.hints_total,
               attempts_total: game.attempts_total,
               hints_left: game.hints_left,
               attempts_left: game.attempts_left }
    new_array = storage << result
    File.open(Game::PATH_TO_DB, 'w') { |file| file.write new_array.to_yaml }
  end
end
