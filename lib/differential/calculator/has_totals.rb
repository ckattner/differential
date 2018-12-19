# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Differential
  module Calculator
    # There are multiple classes that all need calculation support (The Total class.)
    # Instead of using inheritance, those classes can use this mix-in for composition.
    module HasTotals
      extend Forwardable

      def_delegators :totals, :a_sigma, :b_sigma, :delta

      def totals
        @totals ||= ::Differential::Calculator::Totals.new
      end
    end
  end
end
