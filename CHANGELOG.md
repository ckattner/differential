## 1.0.4 (December 21, 2018)

- Adjusted reader so it stores multipart ID's properly in the ID's data field.

## 1.0.3 (December 21, 2018)

- Added a_size and b_size for totals.  This allows you to see how many items contributed to a calculation.
- Changed ID to be a first-class object instead of a string.  Now groups and items can have their respective ID parts consumed using: `id.data`.  The string representation is still accessible via  `id.value`.
- Ignore null hashes when reading input.
