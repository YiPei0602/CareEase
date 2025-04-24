@echo off

REM Activate virtual environment first
@REM start cmd /k "cd backend && call .\..\.venv\Scripts\activate && uvicorn main:app --reload"
start cmd /k "cd backend && call ..\myenv\Scripts\activate && uvicorn main:app --reload"


REM Start Ollama in a separate window
start cmd /k "ollama run doctor-phi3"

@REM start cmd /k "ollama run llama3.2:1b?"

REM Start Flutter frontend
start cmd /k "cd frontend && flutter run"
