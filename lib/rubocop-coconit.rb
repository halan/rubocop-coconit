# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/coconit'
require_relative 'rubocop/coconit/version'
require_relative 'rubocop/coconit/inject'

RuboCop::Coconit::Inject.defaults!

require_relative 'rubocop/cop/coconit_cops'
