from fastapi import APIRouter, File, UploadFile, HTTPException
from sqlalchemy import Column, Integer, create_engine, String
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.mysql import MEDIUMBLOB
from fastapi import Form
import pymysql
import base64

router = APIRouter()

# 데이터베이스 연결 설정
DATABASE_URL = "mysql+pymysql://root:qwer1234@192.168.50.123:3306/Manatest"
engine = create_engine(
    DATABASE_URL,
    pool_size=10,
    max_overflow=20
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def encode_image(image_data):
    return base64.b64encode(image_data).decode('utf-8')
# 테이블 정의
class Image(Base):
    __tablename__ = 'test_image'
    id = Column(Integer, primary_key=True, index=True)
    cp_name = Column(String(255), nullable=False)
    data = Column(MEDIUMBLOB, nullable=False)

# 테이블 생성
Base.metadata.create_all(bind=engine)

# 이미지 업로드 엔드포인트
@router.post("/upload")
async def upload_image(cp_name: str = Form(...), image: UploadFile = File(...)):
    session = SessionLocal()
    try:
        # 이미지를 읽어서 BLOB 형태로 변환
        image_data = await image.read()
        new_image = Image(cp_name=cp_name, data=image_data)  # 업체명(cp_name) 저장

        # MySQL에 저장
        session.add(new_image)
        session.commit()

        # 업로드 성공 후 이미지 URL 생성
        image_url = f"http://127.0.0.1:8000/Image/{new_image.id}"
        
        # 업로드 성공 메시지와 URL 반환
        return {"message": "Image uploaded successfully", "url": image_url}

    except Exception as e:
        session.rollback()
        print(f"Error during image upload: {str(e)}")  # 오류를 로그에 출력
        return {"error": str(e)}
    finally:
        session.close()

# 업로드된 이미지 조회 엔드포인트
@router.get("/{image_id}")
async def get_image(image_id: int):
    # 이미지 ID를 기반으로 이미지를 DB에서 검색
    session = SessionLocal()  # 세션 초기화
    image = session.query(Image).filter(Image.id == image_id).first()

    if not image:
        raise HTTPException(status_code=404, detail="Image not found")

    return {
        "id": image.id,
        "data": image.data.hex()  # 이미지를 반환하는 로직
    }