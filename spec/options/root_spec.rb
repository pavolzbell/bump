require 'spec_helper'

command 'bump' do
  describe '--root' do
    it 'exists on empty root' do
      expect(bump '--root=').to fail_with('invalid option: --root=')
    end
  end

  describe '--root=hello' do
    it 'exists on non-existing root' do
      # TODO this probably needs some stderr message
      expect(bump '--root=hello').to fail_with status: 1
    end
  end

  describe '--root=OK' do
    pending
  end
end
