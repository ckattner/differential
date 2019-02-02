# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Differential
  module Parser
    # This class is used to parse incoming datasets.
    # Usage:
    # Instantiate new object with configuration options.
    # Call read to parse individual hash objects into Record objects.
    class Reader
      attr_reader :record_id_key,
                  :value_key,
                  :group_id_key

      # Params:
      # +record_id_key+:: The hash key(s) to use to uniquely identify a record (required)
      # +value_key+:: The hash key used to extract the value of the record.
      # +group_id_key+:: The hash key(s) to use to identify which group the record belongs to.
      def initialize(record_id_key:, value_key:, group_id_key: nil)
        raise ArgumentError, 'record_id_key is required'  unless record_id_key
        raise ArgumentError, 'value_key is required'      unless value_key

        @record_id_key  = record_id_key
        @value_key      = value_key
        @group_id_key   = group_id_key
      end

      def read(hash)
        id        = make_record_id(hash)
        group_id  = make_group_id(hash)
        value     = hash[value_key]

        ::Differential::Parser::Record.new(id: id,
                                           group_id: group_id,
                                           value: value,
                                           data: hash)
      end

      private

      def make_record_id(hash)
        record_id_key_array.map { |k| hash[k] }
      end

      def make_group_id(hash)
        group_id_key_array.map { |k| hash[k] }
      end

      def record_id_key_array
        @record_id_key_array ||= Array(record_id_key)
      end

      def group_id_key_array
        @group_id_key_array ||= Array(group_id_key)
      end

      def array(hashes)
        if hashes.is_a?(Hash)
          [hashes]
        # If the consumer passed in a value that responds to each (is enumerable-like) then
        # we can accept that as is.
        elsif !hashes.respond_to?(:each)
          Array(hashes)
        else
          hashes
        end
      end
    end
  end
end
