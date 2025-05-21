[//]: # "###################################################"
[//]: # "#####                 HEADER                  #####"
[//]: # "###################################################"


# [EncodedToken](https://github.com/Rubology/encoded_token)



[//]: # "###################################################"
[//]: # "#####                 BADGES                  #####"
[//]: # "###################################################"

## Status

![Build](https://github.com/Rubology/encoded_token/actions/workflows/build.yml/badge.svg?branch=main) 
&nbsp;
![100% Test Coverage](https://github.com/Rubology/state_gate/actions/workflows/code_coverage.yml/badge.svg?branch=main)
&nbsp;
[![Gem Version](https://badge.fury.io/rb/encoded_token.svg)](https://badge.fury.io/rb/encoded_token)
&nbsp;
[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](#license)




[//]: # "###################################################"
[//]: # "#####                  INDEX                  #####"
[//]: # "###################################################"


## Index

- [Description](#description)
- [Requirements](#requirements)
- [Installation](#installation)
- [ChangeLog](#changelog)
- [Setup](#setup)
- [Encoding](#encoding)
- [Decoding](#decoding)
- [Walkthrough Example](#example)
- [Contributing](#contributing)
- [Security Policy](SECURITY.md)
- [Code of Conduct](#code-of-conduct)
- [License](#license)



---

[//]: # "###################################################"
[//]: # "#####               DESCRIPTION               #####"
[//]: # "###################################################"


<a name='description'></a>
## Description

**Encoded Token** is a more secure and efficient replacement for secure tokens.
Used in features such as:

- password reset links: `/password_resets/xxx_encoded_token_xxx`
- email confirmation links: `/email_confirmations/xxx_encoded_token_xxx`
- invitation links: `/invitations/xxx_encoded_token_xxx`
- file sharing links: `/file_shares/xxx_encoded_token_xxx`
- password rollback links: `/password_rollbacks/xxx_encoded_token_xxx`

**EncodedToken** lets you encode a record's ID, UUID, or any UTF-8 string into a 
URL safe token.

When the application receives an incoming request, it decodes the 
token and loads the record from the database using the decoded data. 
No searching or indexing needed!

**EncodedToken** is more secure: 
- Never searching the database for a token, eliminates any 
  potential SQL Injection attack vector.
- CRC Cheksum ensures the token received, is the same token that was sent.
- Random guesses would have to match not only the token, but also the ID of the record using that token.

**EncodedToken** is more efficient: 
- Never searching the database for a token reduces the amount of database interaction.
- No need to index token columns on the DB.
- Response times for invalid tokens are reduced.

**EncodedToken** is simple to use:
- With only `encode` and `decode` methods, it really couldn't be any simpler to use!

> _**>>> EncodedToken is pure Ruby and is framework agnostic. <<<**_

---

[//]: # "###################################################"
[//]: # "#####               REQUIREMENTS              #####"
[//]: # "###################################################"


<a name='requirements'></a>
## Requirements

- Ruby 2.6+



---

[//]: # "###################################################"
[//]: # "#####              INSTALLATION               #####"
[//]: # "###################################################"


<a name='installation'></a>
## Installation

Add this line to your Gemfile:

`gem 'encoded_token'`

or install directly with:

`gem install 'encoded_token'`

---

[//]: # "#######################################"
[//]: # "#####          CHANGELOG          #####"
[//]: # "#######################################"


<a name='changelog'></a>
## ChangeLog
All changes can be found in the [ChangeLog](CHANGELOG.md) file.



---

[//]: # "###############################"
[//]: # "#####        SETUP        #####"
[//]: # "###############################"


<a name='setup'></a>
## Setup
Before use, **EncodedToken** needs to be configured with an integer seed, of at
least five characters in length, which it uses to generate the encryption ciphers.

The seed is set from within a configuration file.

```ruby
EncodedToken.configure do |config|
  config.seed = 12345
end
```

... or preferably, with an environment variable:

```ruby
EncodedToken.configure do |config|
  config.seed = ENV['ENCODED_TOKEN_SEED']
end
```

---

[//]: # "######################################"
[//]: # "#####         ENCODING           #####"
[//]: # "######################################"


<a name='encoding'></a>
## Encoding
Tokens are produced by encoding any integer or UTF-8 String. For example:

```ruby
EncodedToken.encode(12345)
  #=> "po2y8BBXHh5v32xW8wpI66kgIxzHCZ9YcTjoAq3kkl_"
    
EncodedToken.encode("12345")
  #=> "pTJy8BBXHh5v32xW8wnoOlN9yxsoUZgY4IpngdNgyP7o_"
    
EncodedToken.encode("4ef2091f-023b-4af6-9e9f-f46465f897ba")
  #=> "pYnycDBbdNSU3ixAqGUdHt7MHi5z3fjTAKU2Hjp6HUP33pjWqG9f9dp6HA5U32xoqH9fFDBnHDSz8FQ0cWpndw3MyxWIKU_"

EncodedToken.encode( {a: 1, b: 2} )
  #=> "pW2yVDjSdM51OyxfATDyHEBAZi5zNCVmgV3qRMEMIjZhCUrbc_"
```

### On Error
- with `:encode`  - an invalid ID will raise an `ArgumentError`
- with `:encode!` - an invalid ID will raise the original `RuntimeError` exception.

```ruby
EncodedToken.encode(:test)
  # =>  ArgumentError,
  #     :id must be an Integer or String. UUID format must be '8-4-4-4-12'.

EncodedToken.encode!(:test)
  #=> Non-numeric or UUID argument. (RuntimeError)
```


---

[//]: # "######################################"
[//]: # "#####         ENCODING           #####"
[//]: # "######################################"


<a name='decoding'></a>
## Decoding
Encoded tokens are decoded to return a String of the original ID

```ruby
EncodedToken.decode("po2y8BBXHh5v32xW8wpI66kgIxzHCZ9YcTjoAq3kkl_")
  #=> "12345"

EncodedToken.decode("pTJy8BBXHh5v32xW8wnoOlN9yxsoUZgY4IpngdNgyP7o_")
  #=> "12345"

EncodedToken.decode("pYnycDBbdNSU3ixAqGUdHt7MHi5z3fjTAKU2Hjp6HUP33pjWqG9f9dp6HA5U32xoqH9fFDBnHDSz8FQ0cWpndw3MyxWIKU_")
  #=> "4ef2091f-023b-4af6-9e9f-f46465f897ba"

EncodedToken.decode("pW2yVDjSdM51OyxfATDyHEBAZi5zNCVmgV3qRMEMIjZhCUrbc_")
  #=> "{a: 1, b: 2}"
```

### On Error
- with `:decode`  - an invalid ID will return `nil`
- with `:decode!` - an invalid ID will raise the original `RuntimeError`exception.

```ruby
EncodedToken.decode(:test)
  #=> nil

EncodedToken.decode!(:test)
  #=> Token is not a string. (RuntimeError)
```



---

[//]: # "###################################"
[//]: # "#####         EXAMPLE         #####"
[//]: # "###################################"


<a name='example'></a>
## Walkthrough Example
A complete walkthrough, showing the best way to use **EncodedToken** can
be found in the [Password Rollback Example](EXAMPLE.md) file.



---

[//]: # "########################################"
[//]: # "#####         CONTRIBUTING         #####"
[//]: # "########################################"


<a name='contributing'></a>
## Contributing

> - [Security issues](#security-issues)
> - [Reporting issues](#reporting-issues)
> - [Pull requests](#pull-requests)

In all cases please respect our [Contributor Code of Conduct](CODE_OF_CONDUCT.md).


<a name='security-issues'></a>
### Security issues

If you have found a security related issue, please follow our 
[Security Policy](SECURITY.md).


<a name='reporting-issues'></a>
### Reporting issues

Please try to answer the following questions in your bug report:

- What did you do?
- What did you expect to happen?
- What happened instead?

Make sure to include as much relevant information as possible, including:

- Ruby version.
- EncodedToken version.
- OS version.
- The steps needed to replicate the issue.
- Any stack traces you have are very valuable.


<a name='pull-requests'></a>
### Pull Requests

We encourage contributions via GitHub pull requests.

Our [Developer Guide](DEVELOPER_GUIDE.md) details how to fork the project;
get it running locally; run the tests; check the documentation;
check your style; and submit a pull request.



---

[//]: # "###################################################"
[//]: # "#####              CODE OF CONDUCT            #####"
[//]: # "###################################################"


<a name='code-of-conduct'></a>
## Code of Conduct

We as members, contributors, and leaders pledge to make participation in our
community a harassment-free experience for everyone, regardless of age, body
size, visible or invisible disability, ethnicity, sex characteristics, gender
identity and expression, level of experience, education, socio-economic status,
nationality, personal appearance, race, religion, or sexual identity
and orientation.


Read the full details in our [Contributor Code of Conduct](CODE_OF_CONDUCT.md).



---

[//]: # "###################################################"
[//]: # "#####                  LICENSE                #####"
[//]: # "###################################################"


<a name='license'></a>
## License

The MIT License (MIT)

Copyright (c) 2020 CodeMeister

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
