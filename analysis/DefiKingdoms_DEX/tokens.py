import json


f = open('liquidity_pools.json')
y = json.loads(f.read())

dups = []

def replaceQuotes(buf):
    return buf.replace("'","")

doOnceFlag = True
def doOnce(firstTime, repeatedTimes):
    global doOnceFlag
    if doOnceFlag == True:
        doOnceFlag = False
        return firstTime
    return repeatedTimes

print("{{ config(materialized='table', unique_key=\"CONCAT_WS('-', token_address, token_name)\", tags=['playground', 'ant_labels', 'ant_tokens2']) }}")

for lpPool in y["data"]["pairs"]:
    #print(lpPool["id"] + ":" + lpPool["token0"]["name"] + "-" + lpPool["token1"]["name"] + " LP")
    if (lpPool["token0"]["id"] in dups) == False:
        print(doOnce("      ", "union ") + "select '" + lpPool["token0"]["id"] + "' as token_address, '" + replaceQuotes(lpPool["token0"]["name"]) + "' as token_name, '" + lpPool["token0"]["symbol"] + "' as token_symbol, " + lpPool["token0"]["decimals"] + " as decimals")
        dups.append(lpPool["token0"]["id"])
        
    if (lpPool["token1"]["id"] in dups) == False:
        print("union select '" + lpPool["token1"]["id"] + "' as token_address, '" + replaceQuotes(lpPool["token1"]["name"]) + "' as token_name, '" + lpPool["token1"]["symbol"] + "' as token_symbol, " + lpPool["token1"]["decimals"] + " as decimals")
        dups.append(lpPool["token1"]["id"])

## Additional tables
if ('0x9edb3da18be4b03857f3d39f83e5c6aad67bc148' in dups) == False:
    print("union select '0x9edb3da18be4b03857f3d39f83e5c6aad67bc148' as token_address, 'Golden Egg' as token_name, 'DFKGOLDEGG' as token_symbol, 0 as decimals")