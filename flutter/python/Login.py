from fastapi import APIRouter
import pymysql

router = APIRouter()

def connection():
    # Database 주소는 192.168.50.123
    conn = pymysql.connect(
        host='192.168.50.123',
        user='root',
        password='qwer1234',
        db='Manatest',
        charset='utf8'
    )
    return conn

@router.get("/Login_Check")
async def select():
    conn = connection()
    curs = conn.cursor()
    # 결과값을 딕셔너리로 변환할때 쓰이는 SQL문장
    sql = "SELECT * FROM Login"
    # sql = "select * from student"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    print(rows)
    # 데이터가 많을때 쓰는 방법
    return {'results' : rows}