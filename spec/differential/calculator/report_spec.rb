# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Differential::Calculator::Report do
  it 'should initialize correctly' do
    report = ::Differential::Calculator::Report.new

    expect(report.a_sigma).to eq(0)
    expect(report.b_sigma).to eq(0)
    expect(report.delta).to   eq(0)
  end

  let(:group_1_plus8) do
    ::Differential::Parser::Record.new(id: '1', group_id: '1', value: 8, data: { id: '1' })
  end

  let(:group_1_minus9) do
    ::Differential::Parser::Record.new(id: '1', group_id: '1', value: -9, data: { id: '1' })
  end

  let(:group_2_plus3) do
    ::Differential::Parser::Record.new(id: '2', group_id: '2', value: 3, data: { id: '1' })
  end

  let(:group_2_minus2) do
    ::Differential::Parser::Record.new(id: '3', group_id: '2', value: -2, data: { id: '1' })
  end

  context 'when totaling sigma and deltas at report level' do
    it 'should compute sigma & delta correctly' do
      report = ::Differential::Calculator::Report.new

      report.add(group_1_plus8, ::Differential::Calculator::Side::A)

      expect(report.a_sigma).to eq(group_1_plus8.value)
      expect(report.b_sigma).to eq(0)
      expect(report.delta).to   eq(-group_1_plus8.value)

      report.add(group_1_minus9, ::Differential::Calculator::Side::B)

      expect(report.a_sigma).to eq(group_1_plus8.value)
      expect(report.b_sigma).to eq(group_1_minus9.value)
      expect(report.delta).to   eq(group_1_minus9.value - group_1_plus8.value)
    end
  end

  context 'when totaling sigma and deltas at group level' do
    it 'should compute sigma & delta correctly' do
      report = ::Differential::Calculator::Report.new

      report.add(group_1_plus8, ::Differential::Calculator::Side::A)

      group1 = report.groups.first

      expect(report.groups.length).to eq(1)
      expect(group1.id).to eq(group_1_plus8.group_id)
      expect(group1.a_sigma).to eq(group_1_plus8.value)
      expect(group1.b_sigma).to eq(0)
      expect(group1.delta).to eq(-group_1_plus8.value)

      report.add(group_1_minus9, ::Differential::Calculator::Side::B)

      group1 = report.groups.first

      expect(report.groups.length).to eq(1)
      expect(group1.id).to eq(group_1_plus8.group_id)
      expect(group1.a_sigma).to eq(group_1_plus8.value)
      expect(group1.b_sigma).to eq(group_1_minus9.value)
      expect(group1.delta).to eq(group_1_minus9.value - group_1_plus8.value)

      report.add(group_2_plus3, ::Differential::Calculator::Side::A)

      group2 = report.groups.last

      expect(report.groups.length).to eq(2)
      expect(group2.id).to eq(group_2_plus3.group_id)
      expect(group2.a_sigma).to eq(group_2_plus3.value)
      expect(group2.b_sigma).to eq(0)
      expect(group2.delta).to eq(-group_2_plus3.value)

      report.add(group_2_minus2, ::Differential::Calculator::Side::B)

      group2 = report.groups.last

      expect(report.groups.length).to eq(2)
      expect(group2.id).to eq(group_2_plus3.group_id)
      expect(group2.a_sigma).to eq(group_2_plus3.value)
      expect(group2.b_sigma).to eq(group_2_minus2.value)
      expect(group2.delta).to eq(group_2_minus2.value - group_2_plus3.value)
    end
  end

  context 'when totaling sigma and deltas at item level' do
    it 'should compute sigma & delta correctly' do
      report = ::Differential::Calculator::Report.new

      report.add(group_1_plus8,   ::Differential::Calculator::Side::A)
      report.add(group_1_minus9,  ::Differential::Calculator::Side::B)
      report.add(group_2_plus3,   ::Differential::Calculator::Side::A)
      report.add(group_2_minus2,  ::Differential::Calculator::Side::B)

      group1 = report.groups.first
      group2 = report.groups.last

      expect(group1.items.length).to eq(1)
      expect(group2.items.length).to eq(2)

      group1_item1 = group1.items.first

      expect(group1_item1.id).to eq(group_1_plus8.id)
      expect(group1_item1.a_sigma).to eq(group_1_plus8.value)
      expect(group1_item1.b_sigma).to eq(group_1_minus9.value)
      expect(group1_item1.delta).to eq(group_1_minus9.value - group_1_plus8.value)

      group2_item1 = group2.items.first
      group2_item2 = group2.items.last

      expect(group2_item1.id).to eq(group_2_plus3.id)
      expect(group2_item1.a_sigma).to eq(group_2_plus3.value)
      expect(group2_item1.b_sigma).to eq(0)
      expect(group2_item1.delta).to eq(-group_2_plus3.value)

      expect(group2_item2.id).to eq(group_2_minus2.id)
      expect(group2_item2.a_sigma).to eq(0)
      expect(group2_item2.b_sigma).to eq(group_2_minus2.value)
      expect(group2_item2.delta).to eq(group_2_minus2.value)
    end
  end
end
