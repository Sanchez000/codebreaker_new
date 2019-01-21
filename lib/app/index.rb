# frozen_string_literal: true

require 'i18n'
require 'yaml'
require_relative 'modules/loader'
require_relative 'modules/validator'
require_relative 'entitys/console'
require_relative 'entitys/user'
require_relative 'entitys/game'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.default_locale = :en
Console.new.main_menu
