# frozen_string_literal: true

require 'i18n'
# require_relative 'modules/validate'
# require_relative 'modules/loader'
require_relative 'console'
# require_relative 'entitys/user'
# require_relative 'entitys/game'
# require 'yaml'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.default_locale = :en
Console.new.main_menu
