# elixir-steganography
## Supports (was tested on)
* PC bitmap, Windows 95/NT4 and newer format, X x Y x 24
* PC bitmap, Windows 3.x format, X x Y x 24
* PC bitmap, Windows 98/2000 and newer format, X x Y x 32
* And many others

## Usage
`git clone git@github.com:ValBaturin/elixir-steganography.git && cd elixir-steganography`

`iex`

`c "bmp_steganography.ex"`

`BMPS.encrypt("images/IMAGE.BMP", "MESSAGE", "results/IMAGE.BMP"`

`BMPS.decrypt("results/IMAGE.BMP")`

## Important
if your length of your message is more than allowed to store in a picture, your message will be truncated automaticaly!
