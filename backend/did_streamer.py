from fastapi import APIRouter, HTTPException, Body
from pydantic import BaseModel
import requests, base64

router = APIRouter()

# Your D-ID API credentials
DID_KEY = "dGFueWlwZWkwNjAyQGdtYWlsLmNvbQ:azo4-kkwIrfxyDeWlh0TI"
DID_URL = "https://api.d-id.com"

_basic = base64.b64encode(DID_KEY.encode()).decode()
HEADERS = {
    "Authorization": f"Basic {_basic}",
    "Content-Type": "application/json"
}

# Stream creation model
class StreamCreateReq(BaseModel):
    source_url: str

@router.post("/speak/streams")
async def create_stream(req: StreamCreateReq):
    try:
        r = requests.post(f"{DID_URL}/talks/streams", headers=HEADERS, json={"source_url": req.source_url})
        r.raise_for_status()
        return r.json()
    except Exception as e:
        print("Create Stream Error:", r.status_code, r.text)
        raise HTTPException(500, detail=r.text)

# SDP exchange model
class SDPReq(BaseModel):
    answer: dict
    session_id: str

@router.post("/speak/streams/{stream_id}/sdp")
async def send_sdp(stream_id: str, req: SDPReq):
    try:
        payload = {"answer": req.answer, "session_id": req.session_id}
        r = requests.post(f"{DID_URL}/talks/streams/{stream_id}/sdp", headers=HEADERS, json=payload)
        r.raise_for_status()
        return r.json()
    except Exception as e:
        print("SDP Error:", r.status_code, r.text)
        raise HTTPException(500, detail=r.text)

# ICE exchange model
class ICEReq(BaseModel):
    candidate: str
    sdpMid: str
    sdpMLineIndex: int
    session_id: str

@router.post("/speak/streams/{stream_id}/ice")
async def send_ice(stream_id: str, req: ICEReq):
    try:
        payload = {
            "candidate": req.candidate,
            "sdpMid": req.sdpMid,
            "sdpMLineIndex": req.sdpMLineIndex,
            "session_id": req.session_id
        }
        r = requests.post(f"{DID_URL}/talks/streams/{stream_id}/ice", headers=HEADERS, json=payload)
        r.raise_for_status()
        return r.json()
    except Exception as e:
        print("ICE Error:", r.status_code, r.text)
        raise HTTPException(500, detail=r.text)

# Speaking model
class SpeakReq(BaseModel):
    text: str
    session_id: str

@router.post("/speak/streams/{stream_id}")
async def speak_text(stream_id: str, req: SpeakReq):
    body = {
        "script": {
            "type": "text",
            "subtitles": False,
            "provider": { "type": "microsoft", "voice_id": "en-US-ChristopherNeural" },
            "ssml": True,
            "input": req.text
        },
        "config": {
            "fluent": True,
            "pad_audio": 0,
            "driver_expressions": [],  # required for real-time lip-sync
            "align_driver": True,
            "align_expand_factor": 0,
            "auto_match": True,
            "motion_factor": 1,
            "normalization_factor": 1,
            "sharpen": True,
            "stitch": False,
            "result_format": "mp4"
        },
        "driver_url": "bank://lively/",
        "session_id": req.session_id
    }

    try:
        r = requests.post(f"{DID_URL}/talks/streams/{stream_id}", headers=HEADERS, json=body)
        print("Speak Error:", r.status_code, r.text)  # Print response for debugging
        r.raise_for_status()
        return r.json()
    except Exception as e:
        raise HTTPException(500, detail=r.text)

# Stream deletion
class DeleteReq(BaseModel):
    session_id: str

@router.delete("/speak/streams/{stream_id}")
async def delete_stream(stream_id: str, req: DeleteReq = Body(...)):
    try:
        r = requests.delete(f"{DID_URL}/talks/streams/{stream_id}", headers=HEADERS, json={"session_id": req.session_id})
        r.raise_for_status()
        return {"status": "deleted"}
    except Exception as e:
        print("Delete Error:", r.status_code, r.text)
        raise HTTPException(500, detail=r.text)
