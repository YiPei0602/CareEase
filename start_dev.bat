@echo off

REM Activate virtual environment first
start cmd /k "cd backend && call ..\.venv\Scripts\activate && uvicorn main:app --reload"

REM Start Ollama in a separate window
start cmd /k "ollama run doctor-phi3"

REM Start Flutter frontend
start cmd /k "cd frontend && flutter run"