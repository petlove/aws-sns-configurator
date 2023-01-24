# [AWS::SNS::Configurator](https://github.com/petlove/aws-sns-configurator)

[![Ruby](https://github.com/petlove/aws-sns-configurator/actions/workflows/ruby.yml/badge.svg)](https://github.com/petlove/aws-sns-configurator/actions/workflows/ruby.yml)

Simple configuration to create topics, create subscriptions and publish messages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws-sns-configurator', github: 'petlove/aws-sns-configurator'
```

## Usage

### Configuration

You should set one or many files to configure the topics. You could use the file _/config/aws-sns-configurator.yml_ or set any file yml into the folder _/config/aws-sns-configurator_. The options are:
```yml
---
default:
  general:
    region: 'us-east-1'
    prefix: 'system_name'
    suffix: 'topic'
    environment: 'production'
    metadata:
      type: Square
  topic:
    region: 'us-east-1'
    prefix: 'system_name'
    suffix: 'topic'
    environment: 'production'
    metadata:
      type: Triangle
topics:
  - name: 'product_event'
    region: 'us-east-1'
    prefix: 'system_name'
    suffix: 'topic'
    environment: 'production'
    metadata:
      type: Circle
```
| Name | Default | Required | What's it |
|------|---------|----------|-----------|
| `default` | `nil` | false | The default values. It allows `general` and `topic`. |
| `general` | `nil` | false | The general default values. It allows `region`, `prefix`, `suffix`, `environment` and `metadata`. |
| `topic` | `nil` | false | The topic default values. The values overwrite `general` values. It allows `region`, `prefix`, `suffix`, `environment` and `metadata`. |
| `topics` | `[]` | yes | The topics list. |
| `name` | `nil` | yes | The topic name. |
| `region` | `nil` | yes | The AWS region. |
| `prefix` | `nil` | no | The topic name prefix. It's inserted before the `environment`.|
| `suffix` | `nil` | no | The topic name suffix. It's inserted after the `name`. |
| `environment` | `nil` | no | The topic environment. It's inserted between `prefix` and `name`. |
| `metadata` | `{}` | no | Any data that you want put inside the topic to identify it after read the config. |

### Environments

You should declare these environments to this gem works as well:
* `AWS_ACCOUNT_ID`: It's your AWS account id
* `AWS_ACCESS_KEY_ID`: It's your AWS access key
* `AWS_SECRET_KEY`: It's your AWS secret key

You could use the environment `AWS_REGION` as the default region.

#### Tasks

If you are using [Ruby on Rails](https://github.com/rails/rails), you could use this rake task:
```bash
rake aws:sns:create
```

Output:
```bash
[2019-07-03T14:42:31-03:00] [AWS::SNS::Configurator] INFO -- : Topic created: system_name_production_customer_topic - sa-east-1
[2019-07-03T14:42:32-03:00] [AWS::SNS::Configurator] INFO -- : Topic created: system_name_production_address_alert - us-east-1
```

#### Create topic

You could create topics using this code:

```ruby
AWS::SNS::Configurator.create!
```

#### Subscribe in a topic

You could subscribe in a topic using this code:
```ruby
topic = {
  name: 'customer',
  region: 'us-east-1'
}
protocol = 'sqs'
endpoint = "arn:aws:sqs:us-east-1:#{ENV['AWS_ACCOUNT_ID']}:customer_adjuster"
options = {
  raw: true,
  attributes: [
    {
      attribute_name: 'RawMessageDelivery',
      attribute_value: 'true'
    }
  ]
}
AWS::SNS::Configurator.subscribe!(topic, protocol, endpoint, options)
```

or using the environment `AWS_REGION`:

```ruby
AWS::SNS::Configurator.subscribe!('customer', protocol, endpoint, options)
```

#### Logging

AWS::SNS:Configurator logs all the topics created in SNS by default. If you want to disable it you can pass `AWS_SNS_CONFIGURATOR_LOGGER=false` before running it.
```bash
AWS_SNS_CONFIGURATOR_LOGGER=false rake aws:sns:create
```

#### Publish a message

You could publish a message to a topic using this code:
```ruby
topic = {
  name: 'customer',
  region: 'us-east-1'
}
message = {
  name: 'linqueta',
  blog: 'linqueta.com'
}
AWS::SNS::Configurator.publish!(topic, message)
```

or using the environment `AWS_REGION`:

```ruby
AWS::SNS::Configurator.publish!('customer', message)
```

#### Get topics by config

You could get the topics in the config using this code:
```ruby
AWS::SNS::Configurator.topics!
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/petlove/aws-sns-configurator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
