#!/usr/bin/env python3
"""Query real-time stock quote from Moomoo via OpenD."""

import sys
import futu


def get_quote(symbols, host="127.0.0.1", port=11111):
    ctx = futu.OpenQuoteContext(host=host, port=port)
    try:
        ret, data = ctx.get_market_snapshot(symbols)
        if ret != futu.RET_OK:
            print(f"Error: {data}")
            return
        cols = [
            "code", "name", "last_price", "open_price",
            "high_price", "low_price", "volume", "turnover",
            "prev_close_price", "change_rate",
        ]
        print(data[cols].to_string(index=False))
    finally:
        ctx.close()


if __name__ == "__main__":
    symbols = sys.argv[1:] if len(sys.argv) > 1 else ["US.NVDA"]
    get_quote(symbols)
