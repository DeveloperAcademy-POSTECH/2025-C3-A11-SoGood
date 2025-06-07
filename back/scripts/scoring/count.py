def count_score(data,low=40,high=60):
    score = {"negative": 0,"neutral": 0,"positive": 0}
    for key, value in data.items():
        if value <= low:
            score["negative"] += 1
        elif value <= high:
            score["neutral"] += 1
        else:
            score["positive"] += 1
    return score

