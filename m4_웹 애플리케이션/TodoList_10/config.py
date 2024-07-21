import os

# 현재 파일의 절대 경로를 기반으로 basedir 변수를 설정. 이 변수는 프로젝트의 기본 디렉터리를 나타낸다.
# os.path.abspath(path) : 주어진 경로 path의 절대 경로를 반환
# __file__의 디렉토리 부분만을 추출. D:\kdt_240424\workspace\m4_웹애플리케이션\TodoList_10
basedir = os.path.abspath(os.path.dirname(__file__))
# Flask configuration
# 세션 데이터 암호화, CSRF 보호 등을 위해 사용


class Config:
    SECRET_KEY = "b313086d1a43c6e90e044f0575c6c363654a48e0ec41f129"
    SQLALCHEMY_DATABASE_URI = "mysql+pymysql://kevin:kevin@localhost:3306/kevin_db"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    UPLOADED_FILES_DEST = os.path.join(basedir, "uploads")


# os.path.join(basedir, "uploads")
# os.path.join 함수는 여러 경로 요소를 하나의 경로로 결합
# D:\kdt_240424\workspace\m4_웹애플리케이션\TodoList_10\uploads
