require 'spec_helper'

command 'bump' do
  describe '--schema=' do
    it 'exists on empty schema' do
      expect(bump '--schema=').to fail_with('invalid option: --schema=')
    end
  end

  describe '--schema=x' do
    it 'exists on unknown schema' do
      expect(bump '--schema=x').to fail_with('invalid option: --schema=x')
    end
  end
end
