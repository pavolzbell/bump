# TODO refactor custom DSL to proper RSpec matchers

module BumpHelper
  class Schema < OpenStruct
    attr_accessor :name

    def initialize(name, attrs)
      @name = name
      super attrs
    end

    def to_s
      name.to_s
    end
  end

  def relative_path(path)
    "../../../#{path.sub /\A%/, 'spec/fixtures'}"
  end

  def load_sample
    FileUtils.cp_r expand_path("%/#{sample}"), expand_path('.')
    cd(sample) && Dir.chdir(expand_path '.')
  end

  def load_sample_and_input
    load_sample
    expect(input).to have_same_file_content_like("%/outputs/#{sample}")
  end

  def load_empty_sample
    FileUtils.cp_r expand_path('%/empty-sample'), expand_path('.')
    cd('empty-sample') && Dir.chdir(expand_path '.')
  end

  def unload_sample
    Dir.chdir(expand_path '../..')
  end

  class Runner < Proc
  end

  def bump(*args)
    # uncomment this line to see output directly in running tests,
    # note that they always fail since the command is executed twice
    # system "#{relative_path 'bin/bump'} #{args * ' '}"

    Runner.new { run "#{relative_path 'bin/bump'} #{args * ' '}" }
  end

  def expect(*args)
    if args.first.is_a? Runner
      self.define_singleton_method :to do |f|
        args.first.call
        f.call
      end

      return self
    end

    super *args
  end

  def finish_on(options)
    lambda {
      options = { version: options } unless options.is_a? Hash
      options[:schema] ||= sample.match /^\w+/
      options[:message] ||= "Bump version to #{options[:version]}"
      options[:name] ||= "v#{options[:version]}"

      expect(last_command_started).to be_successfully_executed
      expect(output).to have_same_file_content_like("%/outputs/#{options[:schema]}-sample-#{options[:version]}")
      expect(last_git_commit_message_and_tag_name).to contain_exactly(options[:message], options[:name])
    }
  end

  def fail_on(options)
    lambda {
      options = { error: options } unless options.is_a? Hash
      options[:status] ||= 1
      options[:stderr] ||= options[:error] ? "bump: #{options[:error]}" : nil

      expect(last_command_started).to have_exit_status(options[:status])
      expect(last_command_started).to have_output_on_stderr(options[:stderr]) if options[:stderr]
    }
  end

  alias :pin :finish_on
  alias :finish_with :finish_on
  alias :fail_with :fail_on
end

RSpec.configure do |c|
  c.include BumpHelper
end
