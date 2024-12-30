from fastapi import APIRouter
import pymysql
import base64

router = APIRouter()

def connection():
    # Database 주소는 192.168.50.123
    conn = pymysql.connect(
        host='192.168.50.123',
        user='root',
        password='qwer1234',
        db='Manatest',
        charset='utf8mb4'
    )
    return conn

def encode_image(image_data):
    return base64.b64encode(image_data).decode('utf-8')

@router.get('/Ad_List_Select')
async def select():
    conn = connection()
    curs = conn.cursor(pymysql.cursors.DictCursor)  # 딕셔너리 커서 사용
    sql = "SELECT id, cp_name, data FROM Bn_list"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    for row in rows:
        if row['data']:  # 데이터가 존재할 경우
            row['data'] = encode_image(row['data'])  # Base64로 인코딩
    
    # 결과값 반환
    return {'results': rows}

@router.get('/test')
async def select():
    conn = connection()
    curs = conn.cursor()  # 딕셔너리 커서 사용
    sql = "SELECT id, cp_name FROM Bn_list"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    # 결과값 반환
    return {'results': rows}