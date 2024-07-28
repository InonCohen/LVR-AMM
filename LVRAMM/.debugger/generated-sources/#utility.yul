{

    function cleanup_t_uint256(value) -> cleaned {
        cleaned := value
    }

    function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
        mstore(pos, cleanup_t_uint256(value))
    }

    function abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack_reversed(headStart , value1, value0) -> tail {
        tail := add(headStart, 64)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

        abi_encode_t_uint256_to_t_uint256_fromStack(value1,  add(headStart, 32))

    }

    function cleanup_t_uint160(value) -> cleaned {
        cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
    }

    function identity(value) -> ret {
        ret := value
    }

    function convert_t_uint160_to_t_uint160(value) -> converted {
        converted := cleanup_t_uint160(identity(cleanup_t_uint160(value)))
    }

    function convert_t_uint160_to_t_address(value) -> converted {
        converted := convert_t_uint160_to_t_uint160(value)
    }

    function convert_t_contract$_IERC20_$77_to_t_address(value) -> converted {
        converted := convert_t_uint160_to_t_address(value)
    }

    function abi_encode_t_contract$_IERC20_$77_to_t_address_fromStack(value, pos) {
        mstore(pos, convert_t_contract$_IERC20_$77_to_t_address(value))
    }

    function abi_encode_tuple_t_contract$_IERC20_$77__to_t_address__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_contract$_IERC20_$77_to_t_address_fromStack(value0,  add(headStart, 0))

    }

    function cleanup_t_uint8(value) -> cleaned {
        cleaned := and(value, 0xff)
    }

    function abi_encode_t_uint8_to_t_uint8_fromStack(value, pos) {
        mstore(pos, cleanup_t_uint8(value))
    }

    function abi_encode_tuple_t_uint8__to_t_uint8__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_uint8_to_t_uint8_fromStack(value0,  add(headStart, 0))

    }

    function abi_encode_tuple_t_uint256__to_t_uint256__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

    }

    function allocate_unbounded() -> memPtr {
        memPtr := mload(64)
    }

    function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
        revert(0, 0)
    }

    function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
        revert(0, 0)
    }

    function validator_revert_t_uint256(value) {
        if iszero(eq(value, cleanup_t_uint256(value))) { revert(0, 0) }
    }

    function abi_decode_t_uint256(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_uint256(value)
    }

    function abi_decode_tuple_t_uint256t_uint256(headStart, dataEnd) -> value0, value1 {
        if slt(sub(dataEnd, headStart), 64) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

        {

            let offset := 32

            value1 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

    }

    function panic_error_0x11() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x11)
        revert(0, 0x24)
    }

    function shift_right_1_unsigned(value) -> newValue {
        newValue :=

        shr(1, value)

    }

    function checked_exp_helper(_power, _base, exponent, max) -> power, base {
        power := _power
        base  := _base
        for { } gt(exponent, 1) {}
        {
            // overflow check for base * base
            if gt(base, div(max, base)) { panic_error_0x11() }
            if and(exponent, 1)
            {
                // No checks for power := mul(power, base) needed, because the check
                // for base * base above is sufficient, since:
                // |power| <= base (proof by induction) and thus:
                // |power * base| <= base * base <= max <= |min| (for signed)
                // (this is equally true for signed and unsigned exp)
                power := mul(power, base)
            }
            base := mul(base, base)
            exponent := shift_right_1_unsigned(exponent)
        }
    }

    function checked_exp_unsigned(base, exponent, max) -> power {
        // This function currently cannot be inlined because of the
        // "leave" statements. We have to improve the optimizer.

        // Note that 0**0 == 1
        if iszero(exponent) { power := 1 leave }
        if iszero(base) { power := 0 leave }

        // Specializations for small bases
        switch base
        // 0 is handled above
        case 1 { power := 1 leave }
        case 2
        {
            if gt(exponent, 255) { panic_error_0x11() }
            power := exp(2, exponent)
            if gt(power, max) { panic_error_0x11() }
            leave
        }
        if or(
            and(lt(base, 11), lt(exponent, 78)),
            and(lt(base, 307), lt(exponent, 32))
        )
        {
            power := exp(base, exponent)
            if gt(power, max) { panic_error_0x11() }
            leave
        }

        power, base := checked_exp_helper(1, base, exponent, max)

        if gt(power, div(max, base)) { panic_error_0x11() }
        power := mul(power, base)
    }

    function checked_exp_t_uint256_t_uint8(base, exponent) -> power {
        base := cleanup_t_uint256(base)
        exponent := cleanup_t_uint8(exponent)

        power := checked_exp_unsigned(base, exponent, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)

    }

    function panic_error_0x12() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x12)
        revert(0, 0x24)
    }

    function checked_div_t_uint256(x, y) -> r {
        x := cleanup_t_uint256(x)
        y := cleanup_t_uint256(y)
        if iszero(y) { panic_error_0x12() }

        r := div(x, y)
    }

    function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function store_literal_in_memory_398975f84453d02f72be2f04ea41567c835ff1dbdf476a80db1c02f27c9d4bb2(memPtr) {

        mstore(add(memPtr, 0), "Invalid amounts")

    }

    function abi_encode_t_stringliteral_398975f84453d02f72be2f04ea41567c835ff1dbdf476a80db1c02f27c9d4bb2_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 15)
        store_literal_in_memory_398975f84453d02f72be2f04ea41567c835ff1dbdf476a80db1c02f27c9d4bb2(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_398975f84453d02f72be2f04ea41567c835ff1dbdf476a80db1c02f27c9d4bb2__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_398975f84453d02f72be2f04ea41567c835ff1dbdf476a80db1c02f27c9d4bb2_to_t_string_memory_ptr_fromStack( tail)

    }

    function cleanup_t_address(value) -> cleaned {
        cleaned := cleanup_t_uint160(value)
    }

    function abi_encode_t_address_to_t_address_fromStack(value, pos) {
        mstore(pos, cleanup_t_address(value))
    }

    function abi_encode_tuple_t_address_t_address_t_uint256__to_t_address_t_address_t_uint256__fromStack_reversed(headStart , value2, value1, value0) -> tail {
        tail := add(headStart, 96)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

        abi_encode_t_address_to_t_address_fromStack(value1,  add(headStart, 32))

        abi_encode_t_uint256_to_t_uint256_fromStack(value2,  add(headStart, 64))

    }

    function cleanup_t_bool(value) -> cleaned {
        cleaned := iszero(iszero(value))
    }

    function validator_revert_t_bool(value) {
        if iszero(eq(value, cleanup_t_bool(value))) { revert(0, 0) }
    }

    function abi_decode_t_bool_fromMemory(offset, end) -> value {
        value := mload(offset)
        validator_revert_t_bool(value)
    }

    function abi_decode_tuple_t_bool_fromMemory(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_bool_fromMemory(add(headStart, offset), dataEnd)
        }

    }

    function checked_mul_t_uint256(x, y) -> product {
        x := cleanup_t_uint256(x)
        y := cleanup_t_uint256(y)
        let product_raw := mul(x, y)
        product := cleanup_t_uint256(product_raw)

        // overflow, if x != 0 and y != product/x
        if iszero(
            or(
                iszero(x),
                eq(y, div(product, x))
            )
        ) { panic_error_0x11() }

    }

    function checked_add_t_uint256(x, y) -> sum {
        x := cleanup_t_uint256(x)
        y := cleanup_t_uint256(y)
        sum := add(x, y)

        if gt(x, sum) { panic_error_0x11() }

    }

    function store_literal_in_memory_dce59b5772a29b1565e201f4d5bdc0b0bba251b05df4dc8508f020701daa1650(memPtr) {

        mstore(add(memPtr, 0), "Invalid target price")

    }

    function abi_encode_t_stringliteral_dce59b5772a29b1565e201f4d5bdc0b0bba251b05df4dc8508f020701daa1650_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 20)
        store_literal_in_memory_dce59b5772a29b1565e201f4d5bdc0b0bba251b05df4dc8508f020701daa1650(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_dce59b5772a29b1565e201f4d5bdc0b0bba251b05df4dc8508f020701daa1650__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_dce59b5772a29b1565e201f4d5bdc0b0bba251b05df4dc8508f020701daa1650_to_t_string_memory_ptr_fromStack( tail)

    }

    function checked_sub_t_uint256(x, y) -> diff {
        x := cleanup_t_uint256(x)
        y := cleanup_t_uint256(y)
        diff := sub(x, y)

        if gt(diff, x) { panic_error_0x11() }

    }

    function store_literal_in_memory_d9ffa389f9dd3a84666d7e7425c7bc9ef75477a9b3f2d917a4e822ac85908691(memPtr) {

        mstore(add(memPtr, 0), "Not enough liquidity")

    }

    function abi_encode_t_stringliteral_d9ffa389f9dd3a84666d7e7425c7bc9ef75477a9b3f2d917a4e822ac85908691_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 20)
        store_literal_in_memory_d9ffa389f9dd3a84666d7e7425c7bc9ef75477a9b3f2d917a4e822ac85908691(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_d9ffa389f9dd3a84666d7e7425c7bc9ef75477a9b3f2d917a4e822ac85908691__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_d9ffa389f9dd3a84666d7e7425c7bc9ef75477a9b3f2d917a4e822ac85908691_to_t_string_memory_ptr_fromStack( tail)

    }

}
