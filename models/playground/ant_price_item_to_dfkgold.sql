{{ config(materialized='table', unique_key='contract_address', tags=['playground', 'ant_labels']) }}

select lower('0x043f9bd9bb17dfc90de3d416422695dd8fa44486') as contract_address, 3 as gold
union select lower('0x094243dfabfbb3e6f71814618ace53f07362a84c') as contract_address, 15 as gold
union select lower('0x2493cfdacc0f9c07240b5b1c4be08c62b8eeff69') as contract_address, 100 as gold
union select lower('0x372caf681353758f985597a35266f7b330a2a44d') as contract_address, 60 as gold
union select lower('0x600541ad6ce0a8b5dae68f086d46361534d20e80') as contract_address, 100 as gold
union select lower('0x68ea4640c5ce6cc0c9a1f17b7b882cb1cbeaccd7') as contract_address, 10 as gold
union select lower('0x6b10ad6e3b99090de20bf9f95f960addc35ef3e2') as contract_address, 5 as gold
union select lower('0x6e1bc01cc52d165b357c42042cf608159a2b81c1') as contract_address, 12.5 as gold
union select lower('0x78aed65a2cc40c7d8b0df1554da60b38ad351432') as contract_address, 3 as gold
union select lower('0x8bf4a0888451c6b5412bcad3d9da3dcf5c6ca7be') as contract_address, 5 as gold
union select lower('0xb80a07e13240c31ec6dc0b5d72af79d461da3a70') as contract_address, 50 as gold
union select lower('0xc5891912718ccffcc9732d1942ccd98d5934c2e1') as contract_address, 15 as gold
union select lower('0xcdffe898e687e941b124dfb7d24983266492ef1d') as contract_address, 75 as gold
union select lower('0xe4cfee5bf05cef3418da74cfb89727d8e4fee9fa') as contract_address, 5 as gold
union select lower('0xac5c49ff7e813de1947dc74bbb1720c353079ac9') as contract_address, 5 as gold
union select lower('0xc0214b37fcd01511e6283af5423cf24c96bb9808') as contract_address, 12.5 as gold
union select lower('0x19b9f05cde7a61ab7aae5b0ed91aa62ff51cf881') as contract_address, 10 as gold