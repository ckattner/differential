# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'forwardable'
require 'bigdecimal'

require_relative 'calculator/calculator'
require_relative 'parser/parser'

# This module will serve as the top-level entry point for consumers.
# You can stick with the API provided here unless you know the internals behind this point.
module Differential
  extend ::Differential::Calculator::Side

  class << self
    def calculate(dataset_a: [], dataset_b: [], reader_config: {})
      reader = ::Differential::Parser::Reader.new(reader_config)
      report = ::Differential::Calculator::Report.new

      dataset_a.each { |hash| report.add(reader.read(hash), A) }
      dataset_b.each { |hash| report.add(reader.read(hash), B) }

      report
    end
  end
end
