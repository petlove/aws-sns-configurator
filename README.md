# [AWS::SNS::Configurator](https://github.com/petlove/aws-sns-configurator)

[![Build Status](https://travis-ci.org/petlove/aws-sns-configurator.svg?branch=master)](https://travis-ci.org/petlove/aws-sns-configurator)
[![Maintainability](https://api.codeclimate.com/v1/badges/3ed50227b9170851483e/maintainability)](https://codeclimate.com/github/petlove/aws-sns-configurator/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/3ed50227b9170851483e/test_coverage)](https://codeclimate.com/github/petlove/aws-sns-configurator/test_coverage)

Simple configuration to create topics and create topics subscriptions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws-sns-configurator'
```
or the latest version:

```ruby
gem 'aws-sns-configurator', github: 'petlove/aws-sns-configurator'
```

## Usage

### Configuration
Set the config in _/config/aws-sns-configurator.yml_ like this:
```yml
---
region: 'us-east-1'
prefix: 'system_name'
suffix: 'topic'
environment: 'production'
topics:
  - name: 'customer'
    region: 'sa-east-1'
  - name: 'address'
    suffix: 'alert'
```

Out of topics list, you should define default options that won't be required in the topic options. The available options are:

| Name | Default | Required | What's it |
|------|---------|----------|-----------|
| `region` | `nil` | yes | The AWS region. |
| `prefix` | `nil` | no | The topic name prefix. It's inserted before the `environment`.|
| `suffix` | `nil` | no | The topic name suffix. It's inserted after the `name`. |
| `environment` | `nil` | no | The topic environment. It's inserted between `prefix` and `name`. |
| `topics` | `[]` | yes | The topics list. |
| `name` | `nil` | yes | The topic name. |

### Environments

You should declare these environments to this gem works as well:
* `AWS_ACCOUNT_ID`: It's your AWS account id
* `AWS_ACCESS_KEY_ID`: It's your AWS access key
* `AWS_SECRET_KEY`: It's your AWS secret key

#### Tasks

If you are using [Ruby on Rails](https://github.com/rails/rails), you could use this rake task:
```bash
rake sns:create
```

Output:
```bash
[2019-07-03T14:42:31-03:00] [AWS::SNS::Configurator] INFO -- : Created: system_name_production_customer_topic - sa-east-1
[2019-07-03T14:42:32-03:00] [AWS::SNS::Configurator] INFO -- : Created: system_name_production_address_alert - us-east-1
```

You could pass the option "force" to create them without check if they exist.

#### Create

You could create topics using this code:

```ruby
AWS::SNS::Configurator.create!
```

or if you would like to force:

```ruby
AWS::SNS::Configurator.create!(true)
```

#### Subscribe

You could subscribe in topics using this code:
```ruby
topic = AWS::SNS::Configurator::Topic.new(name: 'customer', region: 'us-east-1')
protocol = 'sqs'
endpoint = "arn:aws:sqs:us-east-1:#{ENV['AWS_ACCOUNT_ID']}:customer_adjuster"
options = {
raw: true,
attributes: [{ attribute_name: 'RawMessageDelivery', attribute_value: 'true' }]
}
AWS::SNS::Configurator.subscribe!(protocol, endpoint, options)
```

#### Get topics by config

You could get the topics in the config using this code:
```ruby
AWS::SNS::Configurator.read!
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/petlove/aws-sns-configurator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
