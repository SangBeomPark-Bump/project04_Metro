"""
author: 
Description: 
Fixed: 
Usage: 
"""

from fastapi import FastAPI
from Login import router as Login_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# CORS 설정정
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'], # 모든 도메인 허용
    allow_credentials=True,
    allow_methods=['*'], # 모든 http 메서드 허용
    allow_headers=['*'], # 모든 헤더 허용
)

# Router설정정
app.include_router(Login_router, prefix="/Login", tags=["Login"])


# 서버 연결결
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host = "127.0.0.1", port = 8000)