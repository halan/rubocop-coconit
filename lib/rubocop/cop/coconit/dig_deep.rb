# frozen_string_literal: true
require 'pry'

module RuboCop
  module Cop
    module Coconit
      class DigDeep < Base
        extend AutoCorrector

        MSG = 'Use `dig` instead of `[]`.'

        RESTRICT_ON_SEND = [:[]].freeze

        def_node_matcher :deep_hash_accessor?, <<~PATTERN
          (send (send {_ #deep_hash_accessor?} :[] _) :[] _)
        PATTERN

        def on_send(node)
          expression = deep_hash_accessor?(node)

          return unless expression
          return if deep_hash_accessor?(node.parent)

          add_offense(node) do |corrector|
            args = []
            current = node

            while current.children[1] == :[]
              current, _, arg = current.children
              args << arg
            end

            args_source = args.reverse.map(&:source).join(', ')

            corrector.replace(node, "#{current.source}.dig(#{args_source})")
          end
        end
      end
    end
  end
end
