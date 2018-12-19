# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Differential
  module Calculator
    # Differential can currently only compute calculations for two datasets, represented as:
    # A and B.  Ultimately, how you define what A and B are up to the consuming application.
    module Side
      A = :a
      B = :b
    end
  end
end
