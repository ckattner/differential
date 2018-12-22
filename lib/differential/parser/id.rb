# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Differential
  module Parser
    # TODO
    class Id
      attr_reader :data, :value

      def initialize(data)
        @data   = Array(data)
        @value  = make_value(data)
      end

      def to_s
        value
      end

      def eql?(other)
        if other.is_a?(self.class)
          value == other.value
        else
          make_value(other) == value
        end
      end

      def ==(other)
        eql?(other)
      end

      private

      def make_value(val)
        Array(val).join(':')
      end
    end
  end
end
