from scripts.firebase.auth import firebase_auth
from scripts.scoring.count import count_score


class PutData:
    def __init__(self):
        self.db = firebase_auth()

    def put_sector_score(self, datas):
        data = {}
        for sector in datas.keys():
            if sector not in data:
                data[sector] = {}
            for date in datas[sector].keys():
                score = count_score(datas[sector][date]["scores"])
                data[sector] = score

        self.db.collection("sector_score").document("datas").set(data)
        
    def put_sector_detail__dates(self, datas):
        for sector in datas.keys():
            for date in datas[sector].keys():
                score = count_score(datas[sector][date]["scores"])
                data = {"counts": score, "summary": datas[sector][date]["summary"]}
                self.db.collection("sector_detail").document(sector).collection("dates").document(date).set(data)

    def put_sector_detail__detail_dates(self, telegram_datas,gemini_datas):
        for sector in telegram_datas.keys():
            for date in telegram_datas[sector].keys():
                data = {}
                for channel in telegram_datas[sector][date].keys():
                    try:
                        telegram_posts = telegram_datas[sector][date][channel].get("posts")
                        gemini_score = gemini_datas[sector][date]["scores"].get(channel)

                        if telegram_posts is not None and gemini_score is not None:
                            if channel not in data:
                                data[channel] = {}
                            data[channel]["posts"] = telegram_posts
                            data[channel]["score"] = gemini_score
                        
                    except Exception as e:
                        print(f"데이터 누락: sector={sector}, date={date}, channel={channel}")
                        continue
                if data:    
                    self.db.collection("sector_detail").document(sector).collection("detail_dates").document(date).set(data)

