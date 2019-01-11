# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Differential
  module Calculator
    # Value object that can capture basic calculations:
    # - a_sigma is the sum of data set A's values.
    # - b_sigma is the sum of data set B's values.
    # - delta is the difference: b_sigma - a_sigma.
    class Totals
      include ::Differential::Calculator::Side

      DIGITS = 6

      attr_reader :a_sigma,
                  :a_size,
                  :b_sigma,
                  :b_size

      def initialize
        @a_sigma = BigDecimal(0, DIGITS)
        @a_size  = 0
        @b_sigma = BigDecimal(0, DIGITS)
        @b_size  = 0
      end

      def delta
        b_sigma - a_sigma
      end

      def add(value, side)
        increment_sigma(value, side)
        increment_size(side)
      end

      private

      def increment_sigma(value, side)
        case side
        when A
          @a_sigma += value
        when B
          @b_sigma += value
        else
          raise ArgumentError, "unknown side: #{side}"
        end

        nil
      end

      def increment_size(side)
        case side
        when A
          @a_size += 1.0
        when B
          @b_size += 1.0
        else
          raise ArgumentError, "unknown side: #{side}"
        end

        nil
      end
    end
  end
end
