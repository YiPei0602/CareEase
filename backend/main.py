from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import chat

app = FastAPI(title="AI Doctor Backend")

# CORS config for frontend connection
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount chat router
app.include_router(chat.router)

@app.get("/")
def root():
    return {"message": "AI Doctor backend is running."}
