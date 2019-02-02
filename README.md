# Differential

[![Build Status](https://travis-ci.org/bluemarblepayroll/differential.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/differential) <a href="https://codeclimate.com/github/bluemarblepayroll/differential/maintainability"><img src="https://api.codeclimate.com/v1/badges/6874556c14fe97ce898e/maintainability" /></a> <a href="https://codeclimate.com/github/bluemarblepayroll/differential/test_coverage"><img src="https://api.codeclimate.com/v1/badges/6874556c14fe97ce898e/test_coverage" /></a>

Have you ever had two numerical-based data sets of mostly the same data and you wanted to see the summations and deltas of each data set at the report, group, and line level?  Look no further!  Differential allows you to pass in two data sets and it will calculate all that for you.

Consider the following two data sets showing commute times for employees:

**Week 1 Commute Times:**

| Name  | Transport | Minutes
| ----- | --------- | -------
| Matt  | Car       | 50
| Nick  | Car       | 75
| Sam   | Train     | 48
| Katie | Bike      | 12

**Week 2 Commute Times:**

| Name  | Transport | Minutes
| ----- | --------- | -------
| Matt  | Car       | 30
| Nick  | Car       | 50
| Sam   | Train     | 60
| Nate  | Walk      | 12

You could use Differential to compute the following reports:

**By Employee:**

| Name      | Wk. 1 Minutes | Wk. 2 Minutes | Difference
| --------- | ------------- | ------------- | ----------
| Matt      | 50            | 30            | -20
| Nick      | 75            | 50            | -25
| Sam       | 48            | 60            | 12
| Katie     | 12            | 0             | -12
| Nate      | 0             | 12            | 12
| **TOTAL** | **185**       | **152**       | **-33**

**By Transport Type:**

| Transport | Wk. 1 Minutes | Wk. 2 Minutes | Difference
| --------- | ------------- | ------------- | ----------
| Car       | 125           | 80            | -20
| Train     | 48            | 60            | -25
| Bike      | 12            | 0             | 12
| Walk      | 0             | 12            | -12
| **TOTAL** | **185**       | **152**       | **-33**

**By Employee, Grouped By Transport Type**

| Transport    | Employee      | Wk. 1 Minutes | Wk. 2 Minutes | Difference
| ------------ | ------------- | ------------- | ------------- | ----------
| Car          | Matt          | 50            | 30            | -20
| Car          | Nick          | 75            | 50            | -25
| **SUBTOTAL** |               | **125**       | **80**        | **-45**
| Train        | Sam           | 48            | 60            | 12
| **SUBTOTAL** |               | **48**        | **60**        | **12**
| Bike         | Katie         | 12            | 0             | -12
| **SUBTOTAL** |               | **12**        | **0**         | **-12**
| Walk         | Nate          | 0             | 12            | 12
| **SUBTOTAL** |               | **0**         | **12**        | **12**
| **TOTAL**    |               | **185**       | **152**       | **-33**

## Installation

To install through Rubygems:

````
gem install install differential
````

You can also add this to your Gemfile:

````
bundle add differential
````

## Examples

In the above example the data sets could be represented as:

```
week1_data = [
  { name: 'Matt',   transport: 'Car',   minutes: 50 },
  { name: 'Nick',   transport: 'Car',   minutes: 75 },
  { name: 'Sam',    transport: 'Train', minutes: 48 },
  { name: 'Katie',  transport: 'Bike',  minutes: 12 }
]

week2_data = [
  { name: 'Matt',   transport: 'Car',   minutes: 30 },
  { name: 'Nick',   transport: 'Car',   minutes: 50 },
  { name: 'Sam',    transport: 'Train', minutes: 60 },
  { name: 'Nate',   transport: 'Walk',  minutes: 12 }
]
```

### By Employee Report

There is a couple key pieces of configuration you need to establish.  Below is the configuration necessary for the 'By Employee' report:

```
reader_config = {
  record_id_key:  :name,
  value_key:      :minutes
}
```

To run the report, run:

```
report = Differential.calculate(dataset_a: week1_data, dataset_b: week2_data, reader_config: reader_config)
```

The report variable will now hold a Report object with the following methods:

* a_sigma: sum of all A record values
* b_sigma: sum of all B record values
* delta: difference of B - A
* groups: all groups and their respective items

You can further iterate over groups.  Similar to Report, each group provides the following methods:

* a_sigma: sum of all items in the group for dataset A
* b_sigma: sum of all items in the group for dataset B
* delta: difference of all the items in the group: B - A
* items: all items belonging to the group

Finally, you can iterate over the items array and access the following:

* a_sigma: sum of items in dataset A
* b_sigma: sum of items in dataset B
* delta: difference of items B - A
* a_records: all dataset A records that were aggregated together to produce this item
* b_records: all dataset B records that were aggregated together to produce this item

### By Transport Report

Change the options like so:

```
reader_config = {
  record_id_key:  :transport,
  value_key:      :minutes
}
```

Then execute:

```
report = Differential.calculate(dataset_a: week1_data, dataset_b: week2_data, reader_config: reader_config)
```

### By Employee, Grouped By Transport Type Report

Change the options like so:

```
reader_config = {
  record_id_key:  :name,
  value_key:      :minutes,
  group_id_key:   :transport
}
```

Then execute:

```
report = Differential.calculate(dataset_a: week1_data, dataset_b: week2_data, reader_config: reader_config)
```

Now, this will output a report with two groups instead of one which will allow you to present this with sub-totals.

### Compound ID Keys

You are not restricted to automatically derive a unique ID per record, the library can also handle this like so:

```
reader_config = {
  record_id_key:  [:company_id, :employee_id],
  value_key:      :minutes,
  group_id_key:   [:transport, :direction]
}
```

In this example we are showing that a unique identifier for an employee is not just the employee's ID, but also the companies ID.  The above configuration would output a dataset that is grouped by transport type and direction (i.e. Outbound Train, Inbound Train, Outbound Car, etc...) and lists each unique employee per company in each group.

### Data Peeking

*Raw data* is defined as the initial dataset(s) passed into Differential#calculate.  The consumer application defines this raw data and what Differential does is parses, interprets, and pivots it based on the configuration sent in.  By the time Differential is complete you will end up with a completely different result set than initially passed in.  This does not mean you cannot trace back the raw data.

You still have access to the raw data after the data has been consumed and calculated within a report.  An example of accessing this on a specific item would be:

````
item.data_peek(:name)
````

In the above example, the item would the first record added (precedence to side A, then B) and execute the field on the record's data value.  If the data value is a hash, it will send it through the brackets [] method, if the data value is an object, it will check to see if it responds to field and call it if it can.

If you want to only check one side, you can also specify the side:

````
item.data_peek(:name, ::Differential::Calculator::Side::A) # item.data_peek(:name, :a)
item.data_peek(:name, ::Differential::Calculator::Side::B) # item.data_peek(:name, :b)
````

Data peeking also works at the group level, where it will look at the first item added:

````
group.data_peek(:name)
````


## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check differential.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/differential.git)
4. Navigate to the root folder (cd differential)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite run:

````
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````
bundle exec guard
````

Also, do not forget to run Rubocop:

````
bundle exec rubocop
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update ```lib/differential/version.rb``` using [semantic versioning](https://semver.org/)
3. Install dependencies: ```bundle```
4. Update ```CHANGELOG.md``` with release notes
5. Commit & push master to remote and ensure CI builds master successfully
6. Build the project locally: `gem build differential`
7. Publish package to RubyGems: `gem push differential-X.gem` where X is the version to push
8. Tag master with new version: `git tag <version>`
9. Push tags remotely: `git push origin --tags`

## License

This project is MIT Licensed.
