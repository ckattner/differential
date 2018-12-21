# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Differential::Parser::Reader do
  it 'should initialize correctly' do
    hash = {
      record_id_key:  :name,
      value_key:      :minutes,
      group_id_key:   :transport
    }

    reader = ::Differential::Parser::Reader.new(hash)

    expect(reader.record_id_key).to   eq(hash[:record_id_key])
    expect(reader.value_key).to       eq(hash[:value_key])
    expect(reader.group_id_key).to    eq(hash[:group_id_key])
  end

  context 'When reading just id and value' do
    it 'should properly create a record from a hash' do
      reader = ::Differential::Parser::Reader.new(record_id_key:  :name,
                                                  value_key:      :minutes)

      hashes = [
        {
          name: 'Matt',
          minutes: 34
        }
      ]

      records = []
      reader.each(hashes) do |record|
        records << record
      end

      record = records.first
      hash = hashes.first

      expect(record.id).to        eq(hash[:name])
      expect(record.group_id).to  eq('')
      expect(record.value).to     eq(hash[:minutes])
      expect(record.data).to      eq(hash)
    end

    it 'should skip null records' do
      reader = ::Differential::Parser::Reader.new(record_id_key:  :name,
                                                  value_key:      :minutes)

      hashes = [nil]

      records = []
      reader.each(hashes) do |record|
        records << record
      end

      expect(records.length).to eq(0)
    end
  end

  it 'should read non-array input' do
    reader = ::Differential::Parser::Reader.new(record_id_key:  :name,
                                                value_key:      :minutes)

    hashes = {
      name: 'Matt',
      minutes: 34
    }

    records = []
    reader.each(hashes) do |record|
      records << record
    end

    expect(records.length).to eq(1)
  end

  context 'When reading singular keys' do
    it 'should properly create a record from a hash' do
      reader = ::Differential::Parser::Reader.new(record_id_key:  :name,
                                                  value_key:      :minutes,
                                                  group_id_key: :transport)

      hashes = [
        {
          name: 'Matt',
          minutes: 34,
          transport: 'Train'
        }
      ]

      records = []
      reader.each(hashes) do |record|
        records << record
      end

      record = records.first
      hash = hashes.first

      expect(record.id).to        eq(hash[:name])
      expect(record.group_id).to  eq(hash[:transport])
      expect(record.value).to     eq(hash[:minutes])
      expect(record.data).to      eq(hash)
    end
  end

  context 'When reading multiple id keys' do
    it 'should properly create a record from a hash' do
      reader = ::Differential::Parser::Reader.new(record_id_key:  %i[first last],
                                                  value_key:      :minutes,
                                                  group_id_key:   %i[transport direction])

      hashes = [
        {
          first: 'Matt',
          last: 'Smith',
          minutes: 34,
          transport: 'Train',
          direction: 'Outbound'
        }
      ]

      records = []
      reader.each(hashes) do |record|
        records << record
      end

      record = records.first
      hash = hashes.first

      expect(record.id).to        eq("#{hash[:first]}:#{hash[:last]}")
      expect(record.group_id).to  eq("#{hash[:transport]}:#{hash[:direction]}")
      expect(record.value).to     eq(hash[:minutes])
      expect(record.data).to      eq(hash)
    end
  end
end
