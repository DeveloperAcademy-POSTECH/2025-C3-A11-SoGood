from scripts.gemini.ask_gemini import GeminiClient

client = GeminiClient()

def daily_scoring(for_gemini_crawled_data, data):
    for sector in for_gemini_crawled_data.keys():
        if sector not in data:
            data[sector] = {}
        
        for date in for_gemini_crawled_data[sector].keys():
            if date not in data[sector]:
                data[sector][date] = {}
                
            ask = str(for_gemini_crawled_data[sector][date])

            data[sector][date] = client.ask(sector, ask)
            print("sector: ", sector, "date: ", date)

    return data