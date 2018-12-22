# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Differential::Calculator::Group do
  let(:id) { 'matt' }

  let(:group) { ::Differential::Calculator::Group.new(id) }

  it 'should initialize correctly' do
    expect(group.id).to eq(id)
  end
end
