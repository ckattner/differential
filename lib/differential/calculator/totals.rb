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

      attr_reader :a_sigma, :b_sigma

      def initialize
        @a_sigma = 0
        @b_sigma = 0
      end

      def delta
        b_sigma - a_sigma
      end

      def add(value, side)
        case side
        when A
          @a_sigma += value
        when B
          @b_sigma += value
        else
          raise ArgumentError, "unknown side: #{side}"
        end

        self
      end
    end
  end
end
