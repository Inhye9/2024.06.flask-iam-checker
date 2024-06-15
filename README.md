# 📌flask-aws-iam-check

AWS IAM User의 Access Key Pair 생성시간이 지정기간(N) 초과하는 UserID와 Acess Key ID를 조회하는 어플리케이션 

# 📌설명

- Terraform으로 AWS 환경에 Minikube 서버 구축
- Docker로 Application Image 생성
- Minikube에 Service, Deployment 배포

# 📌버전 확인

- Terraform v1.8.5
- Python 3.7.16
- Flask 2.2.5
- boto3 1.33.13
- pytz 2024.1

# 📌상세 설명

## 1. Minikube 환경 구축 with Terraform

### 1) terraform test.vars 변수 값 입력

**terraform/environment/test/test.tfvars**

```bash
region          = "ap-northeast-2"
vpc_id          = "<vpc_id>" 
subnet_id       = "<subnet_id>"
name            = "flask-aws-iam-checker"
instance_type   = "t3.large"                  #minikube 최소사양> CPU: 2,Mem: 2GB, Disk: 20GB 
key_pair_name   = "<key_pair_name>" 
my_pc_ip        = "<my_pc_ip>"
```

### 2) teraform 적용

**terraform/environment/test/**

```bash
terraform init 
terraform plan -var-file=test.tfvars 
terraform apply -var-file=test.tfvars 
```

### 3) minikube start

 flask-aws-iam-checker-ec2 서버에서 minikube를 기동한다

```bash
su - msinsa 
# Start Minikube with docker driver 
minikube start --driver=docker

# Enable Minikube dashboard
minikube addons enable dashboard

# minikube 설치 확인 
minikube kubectl -- get po -n kube-system
```



## 2. Docker Image 생성

### 1) docker image 생성

```bash
# flask-aws-iam-checker-ec2에서 git을 clone 해준다
sudo yum install -y git 
git clone https://github.com/Inhye9/2024.06.flask-iam-checker.git

# minikube가 docker env 사용하도록 설정 
# 로컬에 생성한 이미지를 minikube가 사용하려면 eval 세팅 필요
eval $(minikube docker-env) 

# docker build -> aws-iam-check:v1.0 생성 
docker build -t aws-iam-checker:v1.0 . 

# docker run으로 이미지 검증  
ocker run -it -p 5000:5000 -e AWS_ACCESS_KEY_ID=<AWS_ACESS_KEY_ID> -e AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> aws-iam-checker:v1.0
```

## 3. Kubernetes Service,Deployment 배포

### 1)  AWS ACCESS KEY ID, KEY 값 BASE64로 인코딩

```bash
echo -n 'your-access-key-id' | base64
echo -n 'your-secret-access-key' | base64
```

### 2) Kubernetes Secret.yaml에 BASE64 인코딩 값 입력

`./kubernetes/secret.yaml` 

```bash
apiVersion: v1
kind: Secret
metadata:
  name: aws-iam-checker-secret
type: Opaque
data:
  AWS_ACCESS_KEY_ID: <base64-encoded-access-key-id>
  AWS_SECRET_ACCESS_KEY: <base64-encoded-secret-access-key>
```

### 3) kubernetes deployment, service 배포

```bash
# kubernetes deployment, service 배포 
minikube kubectl -- apply -f ./kubernetes/secret.yaml
minikube kubectl -- apply -f ./kubernetes/service.yaml
minikube kubectl -- apply -f ./kubernetes/deployment.yaml

minikube kubectl -- get all 
```

## 4. 브라우저 호출 확인

1) minikube proxy 설정 

minikube에서 띄운 service를 호스트 브라우저에 노출시키기 위해 proxy 설정을 한다.

```bash
# minikube addons list 확인 
minikube addons list 

# minikube 포트를 외부에 노출시키기 위해 작업 필요 
minikube kubectl -- proxy --address='0.0.0.0' --disable-filter=true
```


    

2) 호출 링크로 호출 

```bash
# 생성한지 48시간 경과한 Access Key Pair의 User ID와 Access Key ID 찾기 
http://<퍼블릭IP>:8001/api/v1/namespaces/default/services/http:aws-iam-checker-service:/proxy/old-access-key-users?N=48
```

- 결과

```bash
[{"AccessKeyId":"--------","UserId":"--------"},{"AccessKeyId":"--------","UserId":"--------"},{"AccessKeyId":"--------","UserId":"--------"}]
```

# 📌참고

- **minikube start:**

https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download 

- **[kubernetes] VirtualBox의 Minikube Service 노출시키기**

https://hyeo-noo.tistory.com/373 

- kubernetes 공식문서

https://kubernetes.io/ko/docs/concepts/workloads/controllers/deployment/ 

- amazon boto3  공식문서

https://boto3.amazonaws.com/
