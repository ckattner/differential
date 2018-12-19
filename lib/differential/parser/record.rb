# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Differential
  module Parser
    # Represents a parsed record object.  This is ultimately what a Reader creates and
    # is serves as input into the Calculator module.
    class Record
      attr_reader :id, :group_id, :value, :data

      def initialize(id:, group_id:, value:, data:)
        @id       = id
        @group_id = group_id
        @value    = value
        @data     = data
      end
    end
  end
end
