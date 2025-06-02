from dataclasses import dataclass
from datetime import datetime
from typing import Dict, List


@dataclass
class Post:
    time: str
    content: str
    views: int

@dataclass
class Channel:
    channel_name: str
    posts: List[Post]
    subscribe: int
    score: int

@dataclass
class SectorData:
    category: str
    date: str
    chennels: List[Channel]
    summary: int


