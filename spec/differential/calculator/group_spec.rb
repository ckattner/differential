# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Differential::Calculator::Group do
  let(:group_id) { 'matt' }

  let(:group) { ::Differential::Calculator::Group.new(group_id) }

  it 'should initialize correctly' do
    expect(group.id).to eq(group_id)
  end

  it '#sorted_items should be lexicographically sorted' do
    unsorted_ids = [
      'zYx',
      '123',
      'aBC',
      '1 AC.'
    ]

    unsorted_ids.each do |unsorted_id|
      record = ::Differential::Parser::Record.new(id:       unsorted_id,
                                                  group_id: group_id,
                                                  value:    1,
                                                  data:     {})

      group.add(record, ::Differential::Calculator::Side::A)
    end

    actual_ids = group.sorted_items.map { |i| i.id.value }

    expected_ids = unsorted_ids.sort

    expect(actual_ids).to eq(expected_ids)
  end

  it 'should peek at data based on first item it finds' do
    record = ::Differential::Parser::Record.new(id:       '1',
                                                group_id: group_id,
                                                value:    1,
                                                data:     { name: 'Millie' })

    group.add(record, ::Differential::Calculator::Side::A)

    expect(group.data_peek(:name)).to eq(record.data[:name])
  end
end
