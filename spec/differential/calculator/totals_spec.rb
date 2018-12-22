# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Differential::Calculator::Totals do
  it 'should properly calculate sigmas and delta' do
    totals = ::Differential::Calculator::Totals.new

    totals.add(300, ::Differential::Calculator::Side::A)

    expect(totals.a_sigma).to     eq(300)
    expect(totals.a_size).to      eq(1)
    expect(totals.b_sigma).to     eq(0)
    expect(totals.b_size).to      eq(0)
    expect(totals.delta).to       eq(-300)

    totals.add(400, ::Differential::Calculator::Side::B)

    expect(totals.a_sigma).to eq(300)
    expect(totals.a_size).to  eq(1)
    expect(totals.b_sigma).to eq(400)
    expect(totals.b_size).to  eq(1)
    expect(totals.delta).to   eq(100)

    totals.add(2.5, ::Differential::Calculator::Side::A)

    expect(totals.a_sigma).to eq(302.5)
    expect(totals.a_size).to  eq(2)
    expect(totals.b_sigma).to eq(400)
    expect(totals.b_size).to  eq(1)
    expect(totals.delta).to   eq(97.5)

    totals.add(2.50, ::Differential::Calculator::Side::B)

    expect(totals.a_sigma).to eq(302.5)
    expect(totals.a_size).to  eq(2)
    expect(totals.b_sigma).to eq(402.5)
    expect(totals.b_size).to  eq(2)
    expect(totals.delta).to   eq(100)
  end
end
