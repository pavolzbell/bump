shared_examples_for 'optional_argument' do |option, *_|
  describe "--#{option}" do
    it 'proceeds with no argument' do
      # TODO refactor this to: .not_to fail_with("missing argument: --#{option}")
      # all checks cause fast fail and since arguments are always checked after options this works as intended
      expect(bump "--#{option} x").to fail_with('invalid argument: x')
      expect(bump "--#{option}= x").to fail_with('invalid argument: x')
    end
  end
end
