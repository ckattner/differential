# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Differential do
  it 'should calculate a report' do
    dataset_a = [
      { name: 'Matt', minutes: 100, transport: 'Bike' }
    ]

    dataset_b = [
      { name: 'Matt', minutes: 20, transport: 'Car' }
    ]

    reader_config = {
      record_id_key:  :name,
      value_key:      :minutes,
      group_id_key:   :transport
    }

    report = ::Differential.calculate(dataset_a:      dataset_a,
                                      dataset_b:      dataset_b,
                                      reader_config:  reader_config)

    expect(report.groups.length).to eq(2)
  end
end
