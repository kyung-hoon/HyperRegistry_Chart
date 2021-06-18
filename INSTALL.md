# 페쇄망 환경구축 가이드


## Prerequsite
* git (checked version: 1.8.3.1)
* podman (checked version: v3.0.1)
* [helm](https://helm.sh/docs/intro/install/) (v2.8.0+)
* [kubectl](https://kubernetes.io/ko/docs/tasks/tools/install-kubectl-linux/) checked version: v1.19.4
* ingress controller

## How-to

1. (외부망 환경에서) HyperRegistry 이미지 및 바이너리 다운로드 
   ```bash
   git clone -b 5.0 https://github.com/tmax-cloud/HyperRegistry-Chart
   cd HyperRegistry-Chart
   chmod +x download.sh
   ./download.sh <download_dir> # ./download.sh ./downloads
   # Download helm from above prerequite link (kubectl은 이미 설치되어있다고 가정)
   ```

2. git repo 전체(다운로드한 이미지 포함) 복사 

3. 패키지 설치
   ```bash
   sudo yum -y install git podman
   ```

4. 폐쇄망 환경에 레지스트리 설치 ([참조](https://github.com/tmax-cloud/install-registry/tree/5.0))

5. 설치한 레지스트리에 이미지 업로드
   ```bash
   cd <복사한_git_repo_경로>
   chmod +x ./upload.sh
   ./upload.sh ./downloads <download_dir> <registry> # ./update.sh ./downloads 172.22.11.2:5000
   ```

6. Helm 차트 준비
   ```bash
   sudo cp <downloaded_helm> /usr/local/bin
   sed 's/__REPO__/<registry>/' values.yaml.tpl > values.yaml 
   tar -zcvf hyperregistry-v2.2.2.tgz .
   helm repo index .
   mkdir chart-repository
   mv index.yaml hyperregistry-v2.2.2.tgz chart-repository
   ```

7. 폐쇄망 환경에 Helm 서버 설치
   ```bash
   podman run --name helm --rm -v ./chart-repository:/usr/share/nginx/html -p 8080:80 -d docker.io/nginx
   ```

8. HyperRegistry 설치 
   1. Helm repository 추가 및 업데이트
      ```bash
      helm repo add hyperregistry <helm_server> # helm repo add hyperregistry http://172.22.11.2:8080
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
      - ingress.class 추가
       
   3. 기본 스토리지클래스(default) 확인
      ```bash
      kubectl get storageclass
      NAME                    PROVISIONER                       RECLAIMPOLICY      VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE              AGE
      rook-cephfs (default)   rook-ceph.cephfs.csi.ceph.com     DELETE             Immediate           true                   1d
      ```
      * 기본 스토리지클래스가 없을 경우 새로 지정하기
      ```bash
      kubectl patch storageclass rook-cephfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
      ```
   4. 배포
      ```bash
      helm install <name> hyperregistry/HyperRegistry -f value.yaml
      ```

## Trouble-Shoting
* x509: certificate signed by unknown authority
   1. crio 재시작
      ```bash
      systemctl restart crio
      ```
