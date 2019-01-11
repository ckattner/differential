# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Differential
  module Calculator
    # Consider this as being line-level and is the lowest point of calculation.
    # Ultimately a Report object will turn all added Record objects into Item objects (placed
    # in Group objects.)
    class Item
      include ::Differential::Calculator::HasTotals
      include ::Differential::Calculator::Side

      attr_reader :a_records,
                  :b_records,
                  :id

      def initialize(id)
        raise ArgumentError, 'id is required' unless id

        @a_records  = []
        @b_records  = []
        @id         = id.is_a?(::Differential::Parser::Id) ? id : ::Differential::Parser::Id.new(id)
      end

      def add(record, side)
        raise ArgumentError, 'record is required' unless record
        raise ArgumentError, 'side is required'   unless side
        raise ArgumentError, "mismatch: #{record.id} != #{id}" if id != record.id

        totals.add(record.value, side)

        account_for_record(record, side)

        self
      end

      def data_peek(field, side = nil)
        data_object = record_peek(side)&.data

        return nil unless data_object

        if data_object.respond_to?(field)
          data_object.send(field)
        elsif data_object.respond_to?(:[])
          data_object[field]
        end
      end

      private

      def record_peek(side)
        if [nil, A].include?(side) && a_records.any?
          a_records
        elsif [nil, B].include?(side) && b_records.any?
          b_records
        else
          []
        end.first
      end

      def account_for_record(record, side)
        case side
        when A
          @a_records << record
        when B
          @b_records << record
        else
          raise ArgumentError, "unknown side: #{side}"
        end

        nil
      end
    end
  end
end
