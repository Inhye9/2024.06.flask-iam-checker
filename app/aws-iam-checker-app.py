from flask import Flask, request, jsonify, abort
import boto3
import datetime
import pytz

# Flask 초기화 
app = Flask(__name__)

# AWS IAM 클라이언트 초기화
iam_client = boto3.client('iam')

# TimeZone = Asia/Seoul 설정 
seoul_tz = pytz.timezone('Asia/Seoul')

"""
* 지정 시간(N) 초과 Access Key 사용 User 조회 API 앤드포인트 
* Used: Function: get_old_access_key_user(N) 
* return: JSON List (user1: UserId,AccessKeyId)
"""
@app.route('/old-access-key-users', methods=['GET'])
def get_old_access_key_users():
    
    try: 
        # URL 파라미터에서 지정 시간(N) 가져오기
        N = int(request.args.get('N'))
        old_access_key_user = get_old_access_key_user(N)
        return jsonify(old_access_key_user)
    except ValueError:
        # N 값이 유효하지 않은 경우 에러 반환
        abort(400, description="Invalid value for parameter 'n'. It must be an integer.")
    except Exception as e:
        # 기타 에러 발생 시 에러 메시지를 반환
        abort(500, description=f"Error processing request: {str(e)}")


"""
* get_old_access_key_user: 지정 시간(N) 초과 Access Key 사용 User 조회
* return: List[] (user1: UserId,AccessKeyId)
"""
def get_old_access_key_user(N):
    try:
        # 반환겂 
        old_access_key_user = []
        
        # 전체 IAM 사용자 목록 조회 
        response = iam_client.list_users()
        users = response['Users']

        # 현재 시간 조회(Asia/Seoul)    
        now = datetime.datetime.now(seoul_tz)

        # 지정 시간(N) 초과 Access Key 사용자 조회
        for user in users:
            # Access Key 조회
            access_keys = iam_client.list_access_keys(UserName=user['UserName'])
            
            # 지정 시간(N) 초과 Access Key 사용자
            for key in access_keys['AccessKeyMetadata']:
                key_create_date = key['CreateDate'].astimezone(seoul_tz)
                key_age = now - key_create_date
                if key_age.total_seconds() > N * 3600:
                    old_access_key_user.append({
                        'UserId': user['UserId'],
                        'AccessKeyId': key['AccessKeyId']
                    })
    # 에러 처리
    except Exception as e: 
        raise ("Error occured at get_old_access_key_user(N): " + str(e))
        
    return old_access_key_user

# Flask 0.0.0.0:5000 실행 
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
