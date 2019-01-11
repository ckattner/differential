# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Differential::Calculator::Item do
  let(:id) { '1' }

  let(:item) { ::Differential::Calculator::Item.new(id) }

  it 'should initialize correctly' do
    expect(item.id).to eq(id)
  end

  context 'data peeking' do
    let(:matt_data_hash) { { name: 'matt' } }

    let(:matt_data_object) { OpenStruct.new(matt_data_hash) }

    let(:matt_record) do
      ::Differential::Parser::Record.new(
        id: '1',
        group_id: '1',
        value: 1,
        data: matt_data_hash
      )
    end

    let(:matt_record_with_data_object) do
      ::Differential::Parser::Record.new(
        id: '1',
        group_id: '1',
        value: 1,
        data: matt_data_object
      )
    end

    let(:nick_record) do
      ::Differential::Parser::Record.new(
        id: '1',
        group_id: '1',
        value: 2,
        data: { name: 'nick' }
      )
    end

    let(:sam_record) do
      ::Differential::Parser::Record.new(
        id: '1',
        group_id: '1',
        value: 3,
        data: { name: 'sam' }
      )
    end

    let(:katie_record) do
      ::Differential::Parser::Record.new(
        id: '1',
        group_id: '1',
        value: 4,
        data: { name: 'katie' }
      )
    end

    it 'should work when data is an object' do
      item.add(matt_record_with_data_object, ::Differential::Calculator::Side::A)

      expect(item.data_peek(:name)).to eq(matt_data_object.name)
    end

    it 'should work when data is a hash' do
      item.add(matt_record, ::Differential::Calculator::Side::A)

      expect(item.data_peek(:name)).to eq(matt_data_hash[:name])
    end

    context 'when side is nil' do
      it 'should peek side A when both sides have records' do
        item.add(matt_record,   ::Differential::Calculator::Side::A)
        item.add(nick_record,   ::Differential::Calculator::Side::A)
        item.add(sam_record,    ::Differential::Calculator::Side::B)
        item.add(katie_record,  ::Differential::Calculator::Side::B)

        expect(item.data_peek(:name)).to eq(matt_record.data[:name])
      end

      it 'should peek side A when only side A has records' do
        item.add(matt_record,   ::Differential::Calculator::Side::A)
        item.add(nick_record,   ::Differential::Calculator::Side::A)

        expect(item.data_peek(:name)).to eq(matt_record.data[:name])
      end

      it 'should peek side B when only side B has records' do
        item.add(sam_record,    ::Differential::Calculator::Side::B)
        item.add(katie_record,  ::Differential::Calculator::Side::B)

        expect(item.data_peek(:name)).to eq(sam_record.data[:name])
      end
    end

    context 'when side is A' do
      let(:side) { ::Differential::Calculator::Side::A }

      it 'should peek side A when both sides have records' do
        item.add(matt_record,   ::Differential::Calculator::Side::A)
        item.add(nick_record,   ::Differential::Calculator::Side::A)
        item.add(sam_record,    ::Differential::Calculator::Side::B)
        item.add(katie_record,  ::Differential::Calculator::Side::B)

        expect(item.data_peek(:name, side)).to eq(matt_record.data[:name])
      end

      it 'should peek side A when only side A has records' do
        item.add(matt_record,   ::Differential::Calculator::Side::A)
        item.add(nick_record,   ::Differential::Calculator::Side::A)

        expect(item.data_peek(:name, side)).to eq(matt_record.data[:name])
      end

      it 'should return nil when only side B has records' do
        item.add(sam_record,    ::Differential::Calculator::Side::B)
        item.add(katie_record,  ::Differential::Calculator::Side::B)

        expect(item.data_peek(:name, side)).to eq(nil)
      end
    end

    context 'when side is B' do
      let(:side) { ::Differential::Calculator::Side::B }

      it 'should peek side B when both sides have records' do
        item.add(matt_record,   ::Differential::Calculator::Side::A)
        item.add(nick_record,   ::Differential::Calculator::Side::A)
        item.add(sam_record,    ::Differential::Calculator::Side::B)
        item.add(katie_record,  ::Differential::Calculator::Side::B)

        expect(item.data_peek(:name, side)).to eq(sam_record.data[:name])
      end

      it 'should peek side B when only side B has records' do
        item.add(sam_record,    ::Differential::Calculator::Side::B)
        item.add(katie_record,  ::Differential::Calculator::Side::B)

        expect(item.data_peek(:name, side)).to eq(sam_record.data[:name])
      end

      it 'should return nil when only side A has records' do
        item.add(matt_record,   ::Differential::Calculator::Side::A)
        item.add(nick_record,   ::Differential::Calculator::Side::A)

        expect(item.data_peek(:name, side)).to eq(nil)
      end
    end
  end
end
