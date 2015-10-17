shared_examples_for 'needless_argument' do |option, *args|
  type = args.find { |a| a.is_a? Symbol } || :string

  describe "--#{option}=x" do
    it 'exits on needless argument' do
      expect(bump "--#{option}=").to fail_with("needless argument: --#{option}=")
      expect(bump "--#{option}=x").to fail_with("needless argument: --#{option}=x")
    end
  end

  include_examples 'needless_argument', "no-#{option}" if option !~ /^no-/ && type == :boolean
end

