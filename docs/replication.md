# REPLICATION 기능 사용

### 1. Replication Endpoint 생성

1. Administration > Registries > NEW ENDPOINT 클릭

2. 다음의 내용으로 생성

   1. Provider: replication 실행할 원격 registry의 provider (ex. Harbor)
   2. Name: endpoint의 이름 설정
   3. Endpoint URL: 원격 registry의 URL (ex. core.harbor.domain.com)
   4. Access ID & Access Secret: 원격 registry에 접근 권한이 있는 ID & Password (ex. admin & admin)
   5. Verify Remote Cert: self-signed cert일 경우 체크 해제

3. Test Connection 후 OK 클릭

### 2. Replication Rule 생성

1. Administration > Replications > NEW REPLICATION RULE 클릭

2. 다음의 내용으로 생성
   1. Name: replication rule의 이름 설정
   2. Replication mode: Push-based
   3. Source resource filter:
      - Name: replication 대상이 될 repository 이름 (ex. library/\*\*)
      - Tag: replication 대상이 될 regpository의 tag (ex. dev)
   4. Destination registry: 1.2에서 생성한 원격 registry 선택
   5. Destination namespace: push 대상이 될 원격 registry의 project 이름
   6. Trigger Mode: Event Based

### 3. 정상 작동 테스트

1. 메인 harbor registry에 테스트용 이미지 푸시

2. Administration > Replication > 2에서 생성한 replication rule 선택

3. Executions에서 status succeeded 확인

4. 원격 registry에 테스트 이미지 복사된 것 확인
