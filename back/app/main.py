from fastapi import FastAPI
from app.routers import sectors

app = FastAPI()

app.include_router(sectors.router)

@app.get("/")
async def root():
    return {"message": "Hello World"}