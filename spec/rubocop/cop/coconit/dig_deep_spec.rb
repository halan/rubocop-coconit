# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Coconit::DigDeep, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `[]` into a nested hash' do
    expect_offense(<<~RUBY)
      nested_hash["a"]["b"]
      ^^^^^^^^^^^^^^^^^^^^^ Coconit/DigDeep: Use `dig` instead of `[]`.
      nested_hash["a"]["b"]["c"]
      ^^^^^^^^^^^^^^^^^^^^^^^^^^ Coconit/DigDeep: Use `dig` instead of `[]`.
      nested_hash["a"]["b"]["c"]["d"]
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Coconit/DigDeep: Use `dig` instead of `[]`.
      nested_hash[:a]["b"]
      ^^^^^^^^^^^^^^^^^^^^ Coconit/DigDeep: Use `dig` instead of `[]`.
      nested_hash["a"][:b]
      ^^^^^^^^^^^^^^^^^^^^ Coconit/DigDeep: Use `dig` instead of `[]`.
      nested_hash[a][b]
      ^^^^^^^^^^^^^^^^^ Coconit/DigDeep: Use `dig` instead of `[]`.
    RUBY

    expect_correction(<<~RUBY)
      nested_hash.dig("a", "b")
      nested_hash.dig("a", "b", "c")
      nested_hash.dig("a", "b", "c", "d")
      nested_hash.dig(:a, "b")
      nested_hash.dig("a", :b)
      nested_hash.dig(a, b)
    RUBY
  end

  it 'does not register an offense when using `dig` into a nested hash' do
    expect_no_offenses(<<~RUBY)
      nested_hash["a"]
      nested_hash.dig("a", "b")
    RUBY
  end
end
