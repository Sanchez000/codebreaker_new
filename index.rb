# frozen_string_literal: true

require 'i18n'
require 'yaml'
require_relative 'validator'
require_relative 'console'
require_relative 'user'
require_relative 'game'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.default_locale = :en
Console.new.main_menu
