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

      attr_reader :id, :a_records, :b_records

      def initialize(id)
        raise ArgumentError, 'id is required' unless id

        @id         = id
        @a_records  = []
        @b_records  = []
      end

      def add(record, side)
        raise ArgumentError, 'record is required' unless record
        raise ArgumentError, 'side is required'   unless side
        raise ArgumentError, "mismatch: #{record.id} != #{id}" if id != record.id

        totals.add(record.value, side)

        account_for_record(record, side)

        self
      end

      private

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
