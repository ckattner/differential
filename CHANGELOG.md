## 1.1.0 (January 31, 2019)

Maintenance Update + 1 Enhancement

* Ruby to min version 2.3.8
* Updated Rubocop
* Updated README
* Minor performance optimization: Allow input to be a reader (responds to #each.)

## 1.0.6 (January 11, 2019)

- Added Data Peeking for groups and items (group#data_peek, item#data_peek methods).
- Changed precision of Totals a_sigma, b_sigma, and delta to be BigDecimal with precision of 6.

## 1.0.5 (January 11, 2019)

- Added lexicographic ID sorting (report#sorted_groups and group#sorted_items methods.)

## 1.0.4 (December 21, 2018)

- Adjusted reader so it stores multipart ID's properly in the ID's data field.

## 1.0.3 (December 21, 2018)

- Added a_size and b_size for totals.  This allows you to see how many items contributed to a calculation.
- Changed ID to be a first-class object instead of a string.  Now groups and items can have their respective ID parts consumed using: `id.data`.  The string representation is still accessible via  `id.value`.
- Ignore null hashes when reading input.
