# Primix (Under Development)[![Build Status](https://travis-ci.org/Primix/Primix.svg?branch=master)](https://travis-ci.org/Primix/Primix)

![primix-banner](images/banner.jpg)

## Usage

Run command `mix init` to initialize a primix project.

```shell
$ mix init

Initiating Primix for current project

Adding default annotation processors
  -> Using json processor
```

This command will add `Mix` and `Postmix` group into your project and make a new folder in project root path.

Primix uses a simple approach to extract struct or class information before compile time, and generate swift or run commands with ruby script. The code below is a simple usage of primix.

```swift
//@json
struct Person {
    let id: Int
    let name: String

    static let JSONKeyPathByPropertyKey: [String: String] = ["name": "nickname.haha"]

    static func nameTransformer(value: Any) -> String? {
        return value as? String
    }
}
```

`//@json` is command which marks the struct/class below is needed to be pass into a parser, extract information and send to an annotation processor as instance variable `meta`.

```ruby
class Json < Primix::Processor
  self.command = "json"

  def run!
"""extension #{meta.name} {
    static func parse(json: Any) -> #{meta.name}? {
        guard let json = json as? [String: Any] else { return nil }
        guard #{json_extraction_lists.join(",\n\t\t\t")} else { return nil }
        return #{meta.name}(#{key_paths.map { |a| "#{a.name}: #{a.name}" }.join(", ") })
    }
}"""
  end
  ...
end
```

After running `mx install` in command line:

```shell
$ mx install

Installing primix annotations

Clearing previous postmix files

Requiring all mix ruby scripts
  -> Using `json_mix.rb`

Analyzing annotations
  -> Analyzing `Model/Person.swift`
```

`Json` annotation processor would generate swift files according to the class/struct information `meta` which gives us an automatically generated swift file:

```swift
extension Person {
    static func parse(json: Any) -> Person? {
        guard let json = json as? [String: Any] else { return nil }
        guard let id = json["id"] as? Int,
			let name = json["nickname"].flatMap(Person.nameTransformer) else { return nil }
        return Person(id: id, name: name)
    }
}
```

This swift file is automatically added to current project and target.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'primix'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install primix




## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/primix/primix. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the Apache 2.0 License

