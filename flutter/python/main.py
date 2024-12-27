"""
author: 
Description: 
Fixed: 
Usage: 
"""

from fastapi import FastAPI
from Login import router as Login_router
from fastapi.middleware.cors import CORSMiddleware
from Ad import router as Ad_router
from Ad_List import router as Ad_List_router
from Ad_add import router as Ad_add_router
app = FastAPI()

# CORS 설정정
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'], # 모든 도메인 허용
    allow_credentials=True,
    allow_methods=['*'], # 모든 http 메서드 허용
    allow_headers=['*'], # 모든 헤더 허용
)

# Router설정
app.include_router(Login_router, prefix="/Login", tags=["Login"])
app.include_router(Ad_router, prefix="/Image", tags=["Image"])
app.include_router(Ad_List_router, prefix="/AdList", tags=["AdList"])
app.include_router(Ad_add_router, prefix="/AdAdd", tags=["AdAdd"])

# 서버 연결결
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host = "127.0.0.1", port = 8000)