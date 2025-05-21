# Commenting Skills Guide

This document outlines the conventions for documenting methods in the `EncodedToken` project using YARD syntax.

## General Format

Method comments should use the following structure:

1.  Start with a `##` on its own line.
2.  Follow with a `#` and a brief description of the method.
3.  Include a blank comment line (`#`).
4.  Use YARD tags (`@param`, `@return`, `@raise`, etc.) to describe inputs, outputs, and side effects.
5.  Maintain consistent indentation for tag descriptions.

### Example

```ruby
##
# Encodes the given input into a UTF-8 token.
#
# @param [Integer, String, *.to_s] input
#   the input to encode.
#
# @return [String]
#   the encoded UTF-8 token.
#
# @raise [ArgumentError]
#   if the input is invalid.
#
def encode(input)
  # ... implementation
end
```

## YARD Tags

### @param

Describes a method parameter.

- **Syntax:** `@param [Type] name`
- **Description:** Follow on the next line, indented by 2 spaces.

```ruby
# @param [String] token
#   the token to decode.
```

### @return

Describes the return value.

- **Syntax:** `@return [Type]`
- **Description:** Follow on the next line, indented by 2 spaces.

```ruby
# @return [String, nil]
#   the decoded value, or nil if unsuccessful.
```

### @raise

Describes exceptions that the method might throw.

- **Syntax:** `@raise [ExceptionClass]`
- **Description:** Follow on the next line, indented by 2 spaces.

```ruby
# @raise [ArgumentError]
#   if the token is invalid.
```

### @yield

Describes what the method yields if it takes a block.

- **Syntax:** `@yield [parameters]`

```ruby
# @yield [config]
#   yields the configuration instance.
```

## Internal and Private Methods

While public methods MUST be documented, significant internal or private methods SHOULD also be documented using the same style to maintain clarity for developers.

## Style Consistency

- Use `##` to start the comment block for methods.
- Use a single `#` for other types of comments (classes, modules, or inline).
- Ensure that the types in brackets `[Type]` are accurate and reflect common Ruby types (e.g., `String`, `Integer`, `Boolean`, `Array<String>`, `Hash<Symbol, String>`).
- If a method returns itself, use `@return [self]`.
