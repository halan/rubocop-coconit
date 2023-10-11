# frozen_string_literal: true
require 'pry'

module RuboCop
  module Cop
    module Coconit
      class DigDeep < Base
        MSG = 'Use `dig` instead of `[]`.'

        RESTRICT_ON_SEND = [:[]].freeze

        def_node_matcher :deep_hash_accessor?, <<~PATTERN
          (send (send {_ #deep_hash_accessor?} :[] _) :[] _)
        PATTERN

        def on_send(node)
          return unless deep_hash_accessor?(node)
          return if deep_hash_accessor?(node.parent)

          add_offense(node)
        end
      end
    end
  end
end
