module GitHelper
  def current_git_branch
    `git rev-parse --abbrev-ref HEAD`.strip
  end

  def git_root
    `git rev-parse --show-toplevel`.strip
  end

  def last_git_commit_message
    `git log -1 --pretty=%B`.strip
  end

  def last_git_commit_message_and_tag_name
    [last_git_commit_message, last_git_tag_name]
  end

  def last_git_tag_name
    `git tag`.split(/\n+/).first.strip
  end
end

RSpec.configure do |c|
  c.include GitHelper
end
