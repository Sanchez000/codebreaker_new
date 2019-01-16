require 'pry'
# some top comment
class Console
  COMMANDS = {
    start: 'start',
    rules: 'rules',
    stats: 'stats',
    exit: 'exit'
  }.freeze
  # include Validate
  # include Loader
  def show_message(command, **hash)
    puts I18n.t(command, **hash)
  end

  def main_menu
    show_message(:welcome)
    loop do
      show_message(:menu_options, options: COMMANDS.values.join(' | '))
      input = gets.chomp.downcase
      menu_options(input)
    end
  end

  def menu_options(input)
    case input
    when COMMANDS[:start] then start
    when COMMANDS[:rules] then show_message(:rules)
    when COMMANDS[:stats] then table(load_db) if load_db
    when COMMANDS[:exit] then quit
    else show_message(:unexpected_command)
    end
  end

  def quit
    show_message(:bye)
    exit
  end

  def start
    puts 'Create instanse of Game amd start playing' # temp
  end
end
