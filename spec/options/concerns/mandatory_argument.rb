shared_examples_for 'mandatory_argument' do |option, *args|
  type = args.find { |a| a.is_a? Symbol } || :string

  describe "--#{option}" do
    it 'exits on missing argument' do
      expect(bump "--#{option}").to fail_with("missing argument: --#{option}")
      expect(bump "--#{option}=").to fail_with("missing argument: --#{option}=")

      if type == :array
        expect(bump "--#{option} ,").to fail_with("missing argument: --#{option}=")
        expect(bump "--#{option}=,").to fail_with("missing argument: --#{option}=")
      end
    end
  end
end

