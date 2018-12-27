# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Differential
  module Calculator
    # A Report has 0 or more Group objects and a Group has 0 or more Item objects.
    # Report -> Group -> Item
    # A Group is, as the name implies, a grouping of items.  It is up to the consumer application
    # to define how to group (i.e. group based on this attribute's value or
    # group based on these two  attributes' values.)
    class Group
      include ::Differential::Calculator::HasTotals

      attr_reader :id

      def initialize(id)
        raise ArgumentError, 'id is required' unless id

        @id = id.is_a?(::Differential::Parser::Id) ? id : ::Differential::Parser::Id.new(id)
      end

      def sorted_items
        items.sort_by { |item| item.id.value }
      end

      def items
        items_by_id.values
      end

      def add(record, side)
        raise ArgumentError, 'record is required' unless record
        raise ArgumentError, 'side is required'   unless side
        raise ArgumentError, "mismatch: #{record.group_id} != #{id}" if id != record.group_id

        totals.add(record.value, side)

        upsert_item(record, side)

        self
      end

      private

      def upsert_item(record, side)
        item_id_key = record.id.value
        item_id     = record.id

        # Create a new item if one does not exist
        items_by_id[item_id_key] = Item.new(item_id) unless items_by_id.key?(item_id_key)

        items_by_id[item_id_key].add(record, side)

        nil
      end

      def items_by_id
        @items_by_id ||= {}
      end
    end
  end
end
