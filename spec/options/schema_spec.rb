require 'spec_helper'

command 'bump' do
  include_examples 'mandatory_argument', 'schema'

  describe '--schema=x' do
    context 'with invalid schema' do
      it 'exists on unknown schema' do
        expect(bump '--schema=x').to fail_with('invalid option: --schema=x')
      end
    end
  end
end
