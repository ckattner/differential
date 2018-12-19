# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Differential::Parser::Record do
  it 'should initialize correctly' do
    hash = {
      id: '1',
      group_id: '2',
      value: 3,
      data: { id: '1' }
    }

    record = ::Differential::Parser::Record.new(hash)

    expect(record.id).to        eq(hash[:id])
    expect(record.group_id).to  eq(hash[:group_id])
    expect(record.value).to     eq(hash[:value])
    expect(record.data).to      eq(hash[:data])
  end
end
