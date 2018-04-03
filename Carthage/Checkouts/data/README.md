# data

Defines the data schema shared between platform, server, and mobile.

## Compilation

A `Makefile` has been provided for simple compilation of the protobuf files for the various languages in use at Centigrade. As such, compilation is as easy as running `make` to compile for all languages. There are also targets for individual languages (currently only Swift, e.g. `make swift`).

## Usage

All communications using protobuf must be sent with the following headers:

* `Content-Type: application/octet-stream`
* `Message-Type: com.cntgrd.<message-name>`
