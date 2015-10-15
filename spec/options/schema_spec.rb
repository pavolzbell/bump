require 'spec_helper'

command 'bump' do
  describe '--schema=' do
    it 'exists on empty schema' do
      expect(bump '--schema=').to fail_with('invalid option: --schema=')
    end
  end

  describe '--schema=hello' do
    it 'exists on unknown schema' do
      expect(bump '--schema=hello').to fail_with('invalid option: --schema=hello')
    end
  end
end
