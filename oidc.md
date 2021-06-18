# HyperAuth OIDC 연동

### 1. OIDC 클라이언트 등록
    
1. HyperAuth에 접속
2. Realm 생성
3. 클라이언트 생성
   1. (LNB) Clients > Create
   2. Client ID 입력(이후 2.4의 <CLIENT_ID>), Client Protocol = openid-connect 선택 
   3. Save 클릭
4. 클라이언트 설정
    1. Access Type: confidential 선택
    2. Valid Redirect URIs에 <harbor_address>/c/oidc/callback 입력 (2.3 Harbor OIDC 설정 화면에서 save 버튼 위에 나타난 URL)
    3. (생성된) Credentials 탭에서 Secret 값 복사 (이후 2.4의 <SECRET_VALUE>))

### 2. Harbor에 OIDC 설정하기

1. Harbor 접속 및 관리자 로그인(admin/ admin)
2. (LNB) Administration > Configuration 클릭
3. Auth Mode: OIDC 선택
4. 다음 설정값 입력
- OIDC Endpoint: (ex: https://hyperauth.org/auth/realms/<REALM>)
- OIDC Client ID: <CLIENT_ID>
- OIDC Client Secret: <SECRET_VALUE>
- OIDC Scope: openid,profile,offline_access,email
5. Test OIDC SERVER 클릭하여 연동 확인 후 Save
