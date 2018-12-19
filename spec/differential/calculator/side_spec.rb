# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Differential::Calculator::Side do
  it 'should contain the correct number of constants' do
    constants = ::Differential::Calculator::Side.constants

    expect(constants.length).to eq(2)
  end

  it 'should contain the correct constant for side a' do
    value = ::Differential::Calculator::Side.const_get(:A)

    expect(value).to eq(:a)
  end

  it 'should contain the correct constant for side a' do
    value = ::Differential::Calculator::Side.const_get(:B)

    expect(value).to eq(:b)
  end
end
