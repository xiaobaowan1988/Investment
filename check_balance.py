#!/usr/bin/env python3
"""Query Moomoo account balance via OpenD."""

import sys
import futu


def check_balance(host="127.0.0.1", port=11111):
    ctx = futu.OpenSecTradeContext(
        filter_trdenv=futu.TrdEnv.REAL,
        host=host,
        port=port,
        security_firm=futu.SecurityFirm.FUTUSECURITIES,
    )

    try:
        ret, data = ctx.accinfo_query(trd_env=futu.TrdEnv.REAL, acc_index=0)
        if ret != futu.RET_OK:
            print(f"Error: {data}")
            return

        print("=== Account Balance ===")
        print(data.to_string(index=False))
    finally:
        ctx.close()


if __name__ == "__main__":
    host = sys.argv[1] if len(sys.argv) > 1 else "127.0.0.1"
    port = int(sys.argv[2]) if len(sys.argv) > 2 else 11111
    check_balance(host, port)
