# HyperRegistry-Chart
This is helm repository for HyperReigstry

## Installation
* [폐쇄망 구축가이드](https://github.com/tmax-cloud/HyperRegistry-Chart/blob/5.0/INSTALL.md)
* [HyperAuth 연동하기](https://github.com/tmax-cloud/HyperRegistry-Chart/blob/5.0/oidc.md)

```bash
helm repo add [YOUR_REPO_NAME] https://tmax-cloud.github.io/HyperRegistry-Chart/
helm repo update
helm show values [YOUR_REPO_NAME]/HyperRegistry > values.yaml
# edit values.yaml
vi values.yaml
helm install [NAME] [YOUR_REPO_NAME]/HyperRegistry -f values.yaml
```

## Usage
### 레지스트리 생성 및 설정하기 
1. 브라우저에서 포털에 OIDC로 로그인(LOGIN VIA OIDC PROVIDER)
2. 프로젝트 생성
    1. (LNB) Projects > New Project
    2. Project 이름 입력 후 OK
3. Configuration 탭에서 

### 레지스트리 신뢰하기

### 이미지 푸시하기

### 이미지 풀하기
