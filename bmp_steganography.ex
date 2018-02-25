defmodule BMPS do
    use Bitwise
    def encrypt(pic, message, output) do
        {:ok, bin} = File.read(pic)
        <<"BM",
        _file_size::little-size(32),
        _reserved::little-size(32),
        offset::little-size(32),
        _win_header_size::little-size(32),
        _width::little-size(32),
        _height::little-size(32),
        _planes::little-size(16),
        _bits_per_pixel::little-size(16),
        _compression::little-size(32),
        _rest::binary>> = bin

        <<unchanged::size(offset)-bytes, pixels::binary>> = bin
        new_pixels = encode(pixels, trunc(message, div(byte_size(pixels), 8) ), <<>>)
        file_data = unchanged <> new_pixels
        File.write(output, file_data)
    end

    defp trunc(message, max_length) do
        if max_length >= byte_size(message), do: message,
        else: trunc(to_string(List.delete_at(to_charlist(message), -1)), max_length)
    end


    defp encode(<<>>, <<>>, acc), do: acc

    defp encode(<<byte::size(8), rest_pixels::binary>>, <<>>, acc) do
        encode(rest_pixels, <<>>, acc <>
                            <<(byte >>> 1 <<< 1)::size(8)>>)
    end

    defp encode(<<byte::size(8),
                rest_pixels::binary>>,
                <<string_bit::size(1),
                rest_string::bitstring>>,
                acc) do
        encode(rest_pixels, rest_string, acc <>
                                    <<((byte >>> 1 <<< 1) ||| string_bit)::size(8)>>)
    end

    def decrypt(pic) do
        {:ok, bin} = File.read(pic)
        <<"BM",
        _file_size::little-size(32),
        _reserved::little-size(32),
        offset::little-size(32),
        _win_header_size::little-size(32),
        _width::little-size(32),
        _height::little-size(32),
        _planes::little-size(16),
        _bits_per_pixel::little-size(16),
        _compression::little-size(32),
        _rest::binary>> = bin
        <<_unchanged::size(offset)-bytes, pixels::binary>> = bin
        message = String.codepoints decode(pixels, <<>>)
        to_string Enum.filter(message, fn(x) -> x !== <<0>> end)
    end

    defp decode(<<>>, acc), do: acc

    defp decode(<<byte::size(8), rest_pixels::binary>>, acc) do
        decode(rest_pixels, << acc::bitstring,
                            (byte &&& 1)::size(1)>>)
    end

end
