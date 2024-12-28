[//]: # "###################################################"
[//]: # "#####                 HEADER                  #####"
[//]: # "###################################################"


# [EncodedToken](https://github.com/Rubology/encoded_token)



[//]: # "###################################################"
[//]: # "#####                 BADGES                  #####"
[//]: # "###################################################"

| Main Branch| Dev Branch|
|---|---|
| ![ruby 3.4](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-4.yml/badge.svg?branch=main) | ![ruby 3.4](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-4.yml/badge.svg?branch=dev) |
| ![ruby 3.3](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-3.yml/badge.svg?branch=main) | ![ruby 3.3](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-3.yml/badge.svg?branch=dev) |
| ![ruby 3.2](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-2.yml/badge.svg?branch=main) | ![ruby 3.2](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-2.yml/badge.svg?branch=dev) |
| ![ruby 3.1](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-1.yml/badge.svg?branch=main) | ![ruby 3.1](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-1.yml/badge.svg?branch=dev) |
| ![ruby 3.0](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-0.yml/badge.svg?branch=main) | ![ruby 3.0](https://github.com/Rubology/encoded_token/actions/workflows/ruby-3-0.yml/badge.svg?branch=dev) |
| ![ruby 2.7](https://github.com/Rubology/encoded_token/actions/workflows/ruby-2-7.yml/badge.svg?branch=main) | ![ruby 2.7](https://github.com/Rubology/encoded_token/actions/workflows/ruby-2-7.yml/badge.svg?branch=dev) |
| ![ruby 2.6](https://github.com/Rubology/encoded_token/actions/workflows/ruby-2-6.yml/badge.svg?branch=main) | ![ruby 2.6](https://github.com/Rubology/encoded_token/actions/workflows/ruby-2-6.yml/badge.svg?branch=dev) |
| ![ruby 2.5](https://github.com/Rubology/encoded_token/actions/workflows/ruby-2-5.yml/badge.svg?branch=main) | ![ruby 2.5](https://github.com/Rubology/encoded_token/actions/workflows/ruby-2-5.yml/badge.svg?branch=dev) |
| &nbsp; |  |
| [![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](#license)  | [![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](#license) |
| [![Gem Version](https://badge.fury.io/rb/encoded_token.svg)](https://badge.fury.io/rb/encoded_token) | [![Gem Version](https://badge.fury.io/rb/encoded_token.svg)](https://badge.fury.io/rb/encoded_token) |
| ![100% Coverage](https://github.com/Rubology/state_gate/actions/workflows/code_coverage.yml/badge.svg?branch=main) | ![100% Coverage](https://github.com/Rubology/state_gate/actions/workflows/code_coverage.yml/badge.svg?branch=dev) |



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

**EncodedToken** works by encoding a record's ID, or UUID, into a token string 
that can be used within a URL.

When the application receives an incoming request, it decodes the 
token and loads the record from the database using the decoded ID. 
No searching or indexing needed!

**EncodedToken** is more secure: removing the need to directly
search the database with an insecure parameter,
completely elliminates a potential SQL Injection attack vector.

**EncodedToken** is more efficient: reducing the number of
database queries. Imagine being able to filter out all random 
requests, and only hit the database when the token actually 
contains an integer ID or string UUID.

**EncodedToken** promotes best practice: because there is
an inherent reluctance to include a user's ID in a public URL, 
creating new models to manage the token requests helps to 
keep everything RESTful and efficient. 
(See the [Walkthrough Example](#walkthrough))

With **only 2 methods**, it really couldn't be 
any simpler to use!

> _**>>> EncodedToken is pure Ruby and is framework agnostic. <<<**_

---

[//]: # "###################################################"
[//]: # "#####               REQUIREMENTS              #####"
[//]: # "###################################################"


<a name='requirements'></a>
## Requirements

- Ruby 2.5+



---

[//]: # "###################################################"
[//]: # "#####              INSTALLATION               #####"
[//]: # "###################################################"


<a name='installation'></a>
## Installation

Add this line to your Gemfile:

`gem 'encoded_token'`



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

The seed may only be set once, either with an environment variable:

```shell
ENV['ENCODED_TOKEN_SEED']="12345"
```

... or directly with:

```ruby
EncodedToken.seed = 12345
```


### WARNING:
> _**>>> Changing the seed will invalidate any tokens generated from a previous seed! <<<**_



---

[//]: # "######################################"
[//]: # "#####         ENCODING           #####"
[//]: # "######################################"


<a name='encoding'></a>
## Encoding
Tokens are produced by encoding an ID. The ID can be:

- a String UUID, such as "4ef2091f-023b-4af6-9e9f-f46465f897ba"
- an Integer ID, such as 12345
- a String integer, such as "12345"

```ruby
EncodedToken.encode(12345)
  #=> "b4ex6AEB62jlBGpVAGNou8iRmD7pnHGHafQlAHB7w0J"
    
EncodedToken.encode("12345")
  #=> "oTyhEKYsv7rueZt87wPTgJqlnATC7cittp0ncawkupTF1amtV"
    
EncodedToken.encode("4ef2091f-023b-4af6-9e9f-f46465f897ba")
  #=> "c0WKM0w75r7cfMIrqfIMn374f1rcrff7171UfjrB34JsJd4zBB"
```

### On Error
- with `:encode`  - an invalid ID will raise an `ArgumentError`
- with `:encode!` - an invalid ID will raise the original `RuntimeError`exception.

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
EncodedToken.decode("b4ex6AEB62jlBGpVAGNou8iRmD7pnHGHafQlAHB7w0J")
  #=> "12345"

EncodedToken.decode("oTyhEKYsv7rueZt87wPTgJqlnATC7cittp0ncawkupTF1amtV")
  #=> "12345"

EncodedToken.decode("c0WKM0w75r7cfMIrqfIMn374f1rcrff7171UfjrB34JsJd4zBB")
  #=> "4ef2091f-023b-4af6-9e9f-f46465f897ba"
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


