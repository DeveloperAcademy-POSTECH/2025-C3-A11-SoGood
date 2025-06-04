import json

# 제미나이 응답 dict로 변환. 실패시 "error" return
def json_filter(message):
    try:
        dic_message = message.replace("json","").replace("`","").strip()
        return json.loads(dic_message)
    except:
        return "error"
