# 설치 가이드


## Prerequsite
* git (checked version: 1.8.3.1)
* podman (checked version: v3.0.1)
* [helm](https://helm.sh/docs/intro/install/) (v2.8.0+)
* [kubectl](https://kubernetes.io/ko/docs/tasks/tools/install-kubectl-linux/) (checked version: v1.19.4)
* ingress controller

## How-to

### 폐쇄망에서 설치를 위한 환경 준비하기
1. (외부망 환경에서) HyperRegistry 이미지 및 바이너리 다운로드
    1. git repo 클론
       ```bash
       git clone -b 5.0 https://github.com/tmax-cloud/HyperRegistry-Chart
       ```
    2. HyperRegistry 이미지 다운로드
       ```bash
       cd HyperRegistry-Chart
       chmod +x download.sh
       ./download.sh <download_dir> # ./download.sh ./downloads
       ```
    3. Helm 클라이언트 다운로드 (Prerequsite - helm 참조)
    4. Helm Server를 위한 nginx 이미지 다운로드
        ```bash
       podman pull docker.io/nginx:latest
       podman save docker.io/nginx:latest -o nginx_latest.tar
       mv nginx_latest.tar <download_dir>
        ```

2. git repo 전체(다운로드한 이미지 포함)를 내부망으로 복사 

3. 패키지 및 유틸리티 설치
   ```bash
   cd <copied_repo>
   sudo cp <helm_binary> /usr/local/bin
   sudo yum -y install git podman
   ```

4. 폐쇄망 환경에 레지스트리 설치 ([참조](https://github.com/tmax-cloud/install-registry/tree/5.0))

5. 설치한 레지스트리에 이미지 업로드
   ```bash
   chmod +x ./upload.sh
   ./upload.sh <download_dir> <registry> # ./update.sh ./downloads 172.22.11.2:5000
   ```

6. Helm 차트 준비
   ```bash
   mv <download_dir> /tmp
   sed 's/__REPO__/<registry>/' values.yaml.tpl > values.yaml
   helm package .
   helm repo index .
   mkdir chart-repository
   mv index.yaml HyperRegistry-v0.0.1.tgz chart-repository
   ```

7. 폐쇄망 환경에 Helm 서버 설치
   ```bash
   podman run --name helm --rm -v ./chart-repository:/usr/share/nginx/html -p 8080:80 -d <registry>/nginx:latest
   ```

### 설치

1. Helm repository 추가 및 업데이트
   - cf. 공개망 Helm 차트 URL: https://tmax-cloud.github.io/HyperRegistry-Chart/ 
   ```bash
    helm repo add hyperregistry <helm_server>
    helm repo update
    ```
2. values.yaml 수정
    - 다음 필드들의 domain 부분을 <인그레스컨트롤러_EXTERNAL_SERVICE_IP>.nip.io로 변경
        * expose.ingress.hosts.core
          * core.harbor.domain -> core.harbor.172.22.11.2.nip.io
        * expose.ingress.hosts.notray
          * notary.harbor.domain -> notary.harbor.172.22.11.2.nip.io
        * externalURL
          * https://core.harbor.domain -> https://core.harbor.172.22.11.2.nip.io
    - (옵션) ingress.class 설정
        * expose.ingress.annotations에 사용할 인그레스의 클래스 추가하기
          * ex) kubernetes.io/ingress.class: "nginx-shd"
3. 스토리지클래스 설정
    ```bash
    kubectl get storageclass
    NAME                    PROVISIONER                       RECLAIMPOLICY      VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE              AGE
    rook-cephfs (default)   rook-ceph.cephfs.csi.ceph.com     DELETE             Immediate           true                   1d
    ```
    cf. 기본 스토리지클래스가 없을 경우 새로 지정하기
    ```bash
    kubectl patch storageclass rook-cephfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
    ```
   
4. 배포
    ```bash
    helm install <name> hyperregistry/HyperRegistry -f values.yaml
    ```

## Trouble-Shoting
* x509: certificate signed by unknown authority
   1. crio 재시작
      ```bash
      systemctl restart crio
      ```
